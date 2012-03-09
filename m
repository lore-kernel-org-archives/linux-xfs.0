Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q29EM4Jd236854 for <xfs@oss.sgi.com>; Fri, 9 Mar 2012 08:22:04 -0600
Message-ID: <4F59E7A3.4030103@oracle.com>
Date: Fri, 09 Mar 2012 19:21:07 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [RFC PATCH v1 2/4] cgroup quota:  introduce quota subsys
Reply-To: jeff.liu@oracle.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: cgroups@vger.kernel.org
Cc: jack@suse.cz, Daniel Lezcano <daniel.lezcano@free.fr>, Christopher Jones <christopher.jones@oracle.com>, Li Zefan <lizf@cn.fujitsu.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, tj@kernel.org, Ben Myers <bpm@sgi.com>, lxc-devel@lists.sourceforge.net, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, tytso@MIT.EDU, Chris Mason <chris.mason@oracle.com>

Attach a pre-configured project tree ID to the container. Setup quota limits via cgroup config files.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/quota_cgroup.c            |  725 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/quota_cgroup.h |   60 ++++
 2 files changed, 785 insertions(+), 0 deletions(-)
 create mode 100644 fs/quota_cgroup.c
 create mode 100644 include/linux/quota_cgroup.h

diff --git a/fs/quota_cgroup.c b/fs/quota_cgroup.c
new file mode 100644
index 0000000..0342604
--- /dev/null
+++ b/fs/quota_cgroup.c
@@ -0,0 +1,725 @@
+#include <linux/res_counter.h>
+#include <linux/cgroup.h>
+#include <linux/module.h>
+#include <linux/ctype.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/rcupdate.h>
+#include <linux/gfp.h>
+#include <linux/err.h>
+#include <linux/sched.h>
+#include <linux/fs.h>
+#include <linux/seq_file.h>
+#include <linux/mutex.h>
+#include <linux/quota_cgroup.h>
+
+#define MAX_PROJECT_SID_LEN	32
+
+static struct cgroup_subsys_state *quota_create(struct cgroup_subsys *,
+						struct cgroup *);
+static void quota_destroy(struct cgroup_subsys *, struct cgroup *);
+static int quota_populate(struct cgroup_subsys *, struct cgroup *);
+
+static DEFINE_MUTEX(quota_docharge_mutex);
+static DEFINE_MUTEX(quota_setquota_mutex);
+
+struct cgroup_subsys quota_subsys = {
+	.name = "quota",
+	.create = quota_create,
+	.destroy = quota_destroy,
+	.populate = quota_populate,
+	.subsys_id = quota_subsys_id,
+	.module = THIS_MODULE,
+};
+
+/*
+ * FIXME:
+ * qsize_t for limits range?
+ * qid_t id; for project quota id?
+ */
+struct quota_policy_item {
+	/* project identifier in human string */
+	char project_id_s[MAX_PROJECT_SID_LEN];
+	/*
+	 * project identifier
+	 */
+	uint32_t project_id;
+	/*
+	 * the counter to account for project tree block usage
+	 */
+	struct res_counter blkres;
+	/*
+	 * the counter to account for project tree inode usage.
+	 */
+	struct res_counter inores;
+	/*
+	 * the current block limit policy is ready to active or not?
+	 */
+	int blk_limit_state;
+	/*
+	 * the current inode limit policy is ready to active or not?
+	 */
+	int ino_limit_state;
+	/*
+	 * the current limit policy is actived or not?
+	 */
+	int state;
+	struct list_head list;
+	struct rcu_head rcu;
+};
+
+struct quota_cgroup {
+	struct cgroup_subsys_state css;
+	struct list_head policy_item_list; /* list of quota policy entries */
+};
+
+struct quota_cgroup *cgroup_to_quota_cgroup(struct cgroup *cgrp)
+{
+	return container_of(cgroup_subsys_state(cgrp, quota_subsys_id),
+			    struct quota_cgroup, css);
+}
+
+struct quota_cgroup *task_to_quota_cgroup(struct task_struct *tsk)
+{
+	return container_of(task_subsys_state(tsk, quota_subsys_id),
+			    struct quota_cgroup, css);
+}
+
+static int
+quota_policylist_copy(struct list_head *dest, struct list_head *orig)
+{
+	struct quota_policy_item *pi, *tmp, *new;
+
+	list_for_each_entry(pi, orig, list) {
+		new = kmemdup(pi, sizeof(*pi), GFP_KERNEL);
+		if (!new)
+			goto free_and_exit;
+		list_add_tail(&new->list, dest);
+	}
+
+	return 0;
+
+free_and_exit:
+	list_for_each_entry_safe(pi, tmp, dest, list) {
+		list_del(&pi->list);
+		kfree(pi);
+	}
+
+	return -ENOMEM;
+}
+
+/*
+ * If the parent exists, copy and inherit its quota policies.
+ */
+static struct cgroup_subsys_state *
+quota_create(struct cgroup_subsys *subsys, struct cgroup *cgrp)
+{
+	struct quota_cgroup *qc, *parent_qc;
+	struct cgroup *parent_cgroup;
+	int ret;
+
+	qc = kzalloc(sizeof(*qc), GFP_KERNEL);
+	if (!qc)
+		return ERR_PTR(-ENOMEM);
+
+	INIT_LIST_HEAD(&qc->policy_item_list);
+
+	parent_cgroup = cgrp->parent;
+	if (!parent_cgroup)
+		goto out;
+
+	parent_qc = cgroup_to_quota_cgroup(parent_cgroup);
+
+	mutex_lock(&quota_setquota_mutex);
+	ret = quota_policylist_copy(&qc->policy_item_list,
+				    &parent_qc->policy_item_list);
+	mutex_unlock(&quota_setquota_mutex);
+
+	if (ret) {
+		kfree(qc);
+		return ERR_PTR(ret);
+	}
+
+out:
+	return &qc->css;
+}
+
+static void quota_destroy(struct cgroup_subsys *subsys, struct cgroup *cgrp)
+{
+	struct quota_cgroup *qc;
+	struct quota_policy_item *pi, *temp;
+
+	qc = cgroup_to_quota_cgroup(cgrp);
+	list_for_each_entry_safe(pi, temp, &qc->policy_item_list, list) {
+		list_del(&pi->list);
+		kfree(pi);
+	}
+
+	kfree(qc);
+}
+
+/*
+ * FIXME: remove this routine later.
+ */
+static bool quota_policy_item_exist(struct quota_cgroup *qc, qid_t projid)
+{
+	struct quota_policy_item *pi;
+
+	rcu_read_lock();
+
+	list_for_each_entry(pi, &qc->policy_item_list, list) {
+		if (pi->project_id == projid) {
+			rcu_read_unlock();
+			return true;
+		}
+	}
+
+	rcu_read_unlock();
+	return false;
+}
+
+static struct quota_policy_item *
+lookup_cgroup_quota_policy_item(uint32_t projid)
+{
+	struct quota_cgroup *qc;
+	struct quota_policy_item *pi;
+
+	rcu_read_lock();
+	qc = task_to_quota_cgroup(current);
+
+	list_for_each_entry(pi, &qc->policy_item_list, list) {
+		if (pi->project_id == projid) {
+			rcu_read_unlock();
+			return pi;
+		}
+	}
+
+	rcu_read_unlock();
+	return NULL;
+}
+
+/*
+ * Setup project id, if the project id was already exists, change it
+ * accordingly. otherwise, add a new policy entry.
+ * FIXME: we might should not support project id changing on the fly.
+ */
+static int
+quota_set_project_id(struct quota_cgroup *qc, struct quota_policy_item *pi)
+{
+	struct quota_policy_item *picopy;
+
+	if (quota_policy_item_exist(qc, pi->project_id))
+		return -EPERM;
+
+	picopy = kmemdup(pi, sizeof(*pi), GFP_KERNEL);
+	if (!picopy)
+		return -ENOMEM;
+
+	picopy->state = QUOTA_OFF;
+	picopy->blk_limit_state = QUOTA_BLOCK_LIMIT_OFF;
+	picopy->ino_limit_state = QUOTA_INODE_LIMIT_OFF;
+
+	res_counter_init(&picopy->inores, NULL);
+	res_counter_init(&picopy->blkres, NULL);
+
+	list_add_tail_rcu(&picopy->list, &qc->policy_item_list);
+
+	return 0;
+}
+
+/*
+ * Remove a project quota from the list.
+ * FIXME - the related quota policy should be deactive first
+ * before this operation?
+ */
+static int quota_remove_project_id(struct quota_cgroup *qc, uint64_t val)
+{
+	struct quota_policy_item *pi, *temp;
+
+	list_for_each_entry_safe(pi, temp, &qc->policy_item_list, list) {
+		if (pi->project_id == val) {
+			list_del_rcu(&pi->list);
+			kfree_rcu(pi, rcu);
+			return 0;
+		}
+	}
+
+	return -EINVAL;
+}
+
+/*
+ * Attach a project quota ID to the container.
+ * Format: project_id_in_human_read_string:project_id_in_numeric
+ */
+static int
+quota_parse_set_project_id(struct quota_cgroup *qc, const char *buffer)
+{
+	char *p;
+	char *buf;
+	char *projid_s;
+	char *projid_human_s;
+	unsigned long projid;
+	struct quota_policy_item pi;
+	int retval = -EINVAL;
+
+	buf = kstrdup(buffer, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	p = strsep(&buf, ":");
+	if (!p)
+		goto out;
+
+	projid_human_s = p;
+	if (strlen(projid_human_s) > MAX_PROJECT_SID_LEN - 1)
+		goto out;
+
+	projid_s = &buf[0];
+	if (!projid_s)
+		goto out;
+
+	if (kstrtoul(projid_s, 10, &projid))
+		goto out;
+
+	memset(&pi, 0, sizeof(pi));
+	pi.project_id = projid;
+	projid_human_s[MAX_PROJECT_SID_LEN - 1] = '\0';
+	strcpy(pi.project_id_s, projid_human_s);
+
+	mutex_lock(&quota_setquota_mutex);
+	retval = quota_set_project_id(qc, &pi);
+	mutex_unlock(&quota_setquota_mutex);
+
+out:
+	kfree(buf);
+	return retval;
+}
+
+static int
+quota_set_limit(struct quota_cgroup *qc, uint32_t projid, int type,
+		uint64_t softlimit, uint64_t hardlimit)
+{
+	int retval = 0;
+	struct quota_policy_item *pi;
+
+	list_for_each_entry(pi, &qc->policy_item_list, list) {
+		if (pi->project_id != projid)
+			continue;
+
+		switch (type) {
+		case BLOCK_LIMIT:
+			retval = res_counter_set_soft_limit(&pi->blkres,
+							    softlimit);
+			if (retval)
+				break;
+			retval = res_counter_set_limit(&pi->blkres,
+						       hardlimit);
+			if (!retval)
+				pi->blk_limit_state = QUOTA_BLOCK_LIMIT_READY;
+			break;
+		case INODE_LIMIT:
+			retval = res_counter_set_soft_limit(&pi->inores,
+							    softlimit);
+			if (retval)
+				break;
+			retval = res_counter_set_limit(&pi->inores, hardlimit);
+			if (!retval)
+				pi->ino_limit_state = QUOTA_INODE_LIMIT_READY;
+			break;
+		default:
+			retval = -EINVAL;
+			break;
+		}
+	}
+
+	return retval;
+}
+
+/*
+ * Set limits to an existing project id.
+ * Format - project_id_numeric softlimit:hardlimit
+ */
+static int
+quota_parse_set_limit(struct quota_cgroup *qc, const char *buffer,
+		      enum quota_limit_type type)
+{
+	char *softlimit_s, *hardlimit_s;
+	char *p, *projid_s, *buf;
+	char *s[4];
+	unsigned long long softlimit, hardlimit;
+	unsigned long projid;
+	int i = 0;
+	int retval = -EINVAL;
+
+	buf = kstrdup(buffer, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	while ((p = strsep(&buf, " ")) != NULL) {
+		if (!*p)
+			continue;
+
+		s[i++] = p;
+
+		/* Prevent from inputing too many things */
+		if (i == 3)
+			break;
+	}
+
+	if (i != 2)
+		goto out;
+
+	projid_s = s[0];
+	if (kstrtoul(projid_s, 10, &projid))
+		goto out;
+
+	/*
+	 * Quota container policy
+	 * Initial setup:
+	 * The desired project id should setup firstly, hence
+	 * the related policy item should have already been
+	 * allocated. If not, fail the user.
+	 */
+	if (!quota_policy_item_exist(qc, projid))
+		goto out;
+
+	p = strsep(&s[1], ":");
+	if (p)
+		softlimit_s = p;
+	else
+		goto out;
+
+	hardlimit_s = s[1];
+	if (!hardlimit_s)
+		goto out;
+
+	retval = res_counter_diskspace_parse_write_strategy(softlimit_s,
+							    &softlimit);
+	if (retval)
+		goto out;
+
+	retval = res_counter_diskspace_parse_write_strategy(hardlimit_s,
+							    &hardlimit);
+	if (retval)
+		goto out;
+
+	mutex_lock(&quota_setquota_mutex);
+	retval = quota_set_limit(qc, projid, type, softlimit, hardlimit);
+	mutex_unlock(&quota_setquota_mutex);
+
+out:
+	kfree(buf);
+	return retval;
+}
+
+static int quota_cgroup_file_write(struct cgroup *cgrp, struct cftype *cft,
+				    const char *buf)
+{
+	struct quota_cgroup *qc;
+	int retval;
+
+
+	qc = cgroup_to_quota_cgroup(cgrp);
+	switch (cft->private) {
+	case QUOTA_SET_PROJECT_ID:
+		retval = quota_parse_set_project_id(qc, buf);
+		break;
+	case QUOTA_SET_BLOCK_LIMIT:
+		retval = quota_parse_set_limit(qc, buf, BLOCK_LIMIT);
+		break;
+	case QUOTA_SET_INODE_LIMIT:
+		retval = quota_parse_set_limit(qc, buf, INODE_LIMIT);
+		break;
+	case QUOTA_RESET_BLOCK_LIMIT:
+		retval = quota_parse_set_limit(qc, buf, BLOCK_LIMIT);
+		break;
+	case QUOTA_RESET_INODE_LIMIT:
+		retval = quota_parse_set_limit(qc, buf, INODE_LIMIT);
+		break;
+	default:
+		retval = -EINVAL;
+		break;
+	}
+
+	return retval;
+}
+
+/*
+ * Show all info related to a project quota tree.
+ * Includes project identifier, limits as well as the current usage statistics.
+ */
+static inline void
+print_project_verbose_info(struct seq_file *m, struct quota_policy_item *pi)
+{
+	struct res_counter *blk_res, *ino_res;
+
+	blk_res = &pi->blkres;
+	ino_res = &pi->inores;
+
+	seq_printf(m,
+		   "Project ID (%s:%u)\tstatus: %s\n"
+		   "  block_soft_limit\t%llu\n"
+		   "  block_hard_limit\t%llu\n"
+		   "  block_max_usage\t%llu\n"
+		   "  block_usage\t%llu\n"
+		   "  inode_soft_limit\t%llu\n"
+		   "  inode_hard_limit\t%llu\n"
+		   "  inode_max_usage\t%llu\n"
+		   "  inode_usage\t%llu\n",
+		   pi->project_id_s, pi->project_id,
+		   pi->state == QUOTA_ON ? "on" : "off",
+		   blk_res->soft_limit,
+		   blk_res->limit,
+		   blk_res->max_usage,
+		   blk_res->usage,
+		   ino_res->soft_limit,
+		   ino_res->limit,
+		   ino_res->max_usage,
+		   ino_res->usage);
+}
+
+/*
+ * Show the current project quota list with their status respectively.
+ */
+static inline void
+print_project_info(struct seq_file *m, struct quota_policy_item *pi)
+{
+	seq_printf(m, "Project ID (%s:%u)\tstatus: %s\n",
+		   pi->project_id_s, pi->project_id,
+		   pi->state == QUOTA_ON ? "on" : "off");
+}
+
+static int quota_cgroup_file_read(struct cgroup *cgrp, struct cftype *cft,
+				   struct seq_file *m)
+{
+	struct quota_cgroup *qc = cgroup_to_quota_cgroup(cgrp);
+	struct quota_policy_item *pi;
+	int type = cft->private;
+	int retval = 0;
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(pi, &qc->policy_item_list, list) {
+		switch (type) {
+		case QUOTA_SHOW_PROJECTS:
+			print_project_info(m, pi);
+			break;
+		case QUOTA_SHOW_PROJECTS_VERBOSE:
+			print_project_verbose_info(m, pi);
+			break;
+		default:
+			retval = -EINVAL;
+			break;
+		}
+	}
+
+	rcu_read_unlock();
+	return 0;
+}
+
+/*
+ * Active a project quota or deactive it.
+ * In either case, the corresponding quota limits will take affected
+ * immediately.
+ */
+static int quota_policy_active_deactive(struct quota_cgroup *qc, int filetype,
+					u64 val)
+{
+	struct quota_policy_item *pi;
+	int retval = -EINVAL;
+
+	list_for_each_entry(pi, &qc->policy_item_list, list) {
+		if (pi->project_id == val) {
+			pi->state = (filetype == QUOTA_ACTIVATE ?
+						 QUOTA_ON : QUOTA_OFF);
+			retval = 0;
+			break;
+		}
+	}
+
+	return retval;
+}
+
+static int
+quota_cgroup_file_write_u64(struct cgroup *cgrp, struct cftype *cft, u64 val)
+{
+	struct quota_cgroup;
+	int filetype, retval;
+
+	mutex_lock(&quota_setquota_mutex);
+
+	filetype = cft->private;
+	switch (filetype) {
+	case QUOTA_ACTIVATE:
+	case QUOTA_DEACTIVATE:
+		retval = quota_policy_active_deactive(
+				cgroup_to_quota_cgroup(cgrp), filetype, val);
+		break;
+	case QUOTA_REMOVE_PROJECT_ID:
+		retval = quota_remove_project_id(cgroup_to_quota_cgroup(cgrp),
+						 val);
+		break;
+	default:
+		retval = -EINVAL;
+		break;
+	}
+
+	mutex_unlock(&quota_setquota_mutex);
+	return retval;
+}
+
+static struct cftype quota_cgroup_files[] = {
+	{
+		.name = "add_project",
+		.private = QUOTA_SET_PROJECT_ID,
+		.write_string = quota_cgroup_file_write,
+	},
+	{
+		.name = "remove_project",
+		.private = QUOTA_REMOVE_PROJECT_ID,
+		.write_u64 = quota_cgroup_file_write_u64,
+	},
+	{
+		.name = "block_limit_in_bytes",
+		.private = QUOTA_SET_BLOCK_LIMIT,
+		.write_string = quota_cgroup_file_write,
+	},
+	{
+		.name = "reset_block_limit_in_bytes",
+		.private = QUOTA_RESET_BLOCK_LIMIT,
+		.write_string = quota_cgroup_file_write,
+	},
+	{
+		.name = "inode_limit",
+		.private = QUOTA_SET_INODE_LIMIT,
+		.write_string = quota_cgroup_file_write,
+	},
+	{
+		.name = "reset_inode_limit",
+		.private = QUOTA_RESET_INODE_LIMIT,
+		.write_string = quota_cgroup_file_write,
+	},
+	{
+		.name = "projects",
+		.private = QUOTA_SHOW_PROJECTS,
+		.read_seq_string = quota_cgroup_file_read,
+	},
+	{
+		.name = "all",
+		.private = QUOTA_SHOW_PROJECTS_VERBOSE,
+		.read_seq_string = quota_cgroup_file_read,
+	},
+	{
+		.name = "activate",
+		.private = QUOTA_ACTIVATE,
+		.write_u64 = quota_cgroup_file_write_u64,
+	},
+	{
+		.name = "deactivate", /* Deactivate a limit policy */
+		.private = QUOTA_DEACTIVATE,
+		.write_u64 = quota_cgroup_file_write_u64,
+	},
+};
+
+static int quota_populate(struct cgroup_subsys *subsys, struct cgroup *cgrp)
+{
+	return cgroup_add_files(cgrp, subsys, quota_cgroup_files,
+				ARRAY_SIZE(quota_cgroup_files));
+}
+
+static int quota_cgroup_do_charge(struct quota_policy_item *pi, int type,
+				  uint64_t num)
+{
+	struct res_counter *fail_res;
+	int retval = 0;
+
+	switch (type) {
+	case QUOTA_NEW_INODE:
+		retval = res_counter_charge(&pi->inores, num, &fail_res);
+		break;
+	case QUOTA_DROP_INODE:
+		res_counter_uncharge(&pi->inores, num);
+		break;
+	case QUOTA_NEW_BLOCK:
+		retval = res_counter_charge(&pi->blkres, num, &fail_res);
+		break;
+	case QUOTA_DROP_BLOCK:
+		res_counter_uncharge(&pi->blkres, num);
+		break;
+	default:
+		retval = -EINVAL;
+		break;
+	}
+
+	return retval;
+}
+
+/*
+ * Export this routine to the particular file system with project quota
+ * supports.  Just return if the specified project id does not attached
+ * to a cgroup, or if its quota policy does not yet be activated.
+ */
+void quota_cgroup_charge_pquota(int type, uint32_t projid, uint64_t num)
+{
+	struct quota_policy_item *pi;
+
+	pi = lookup_cgroup_quota_policy_item(projid);
+	if (!pi || pi->state == QUOTA_OFF)
+		return;
+
+	mutex_lock(&quota_docharge_mutex);
+	retval = quota_cgroup_do_charge(pi, type, num);
+	mutex_unlock(&quota_docharge_mutex);
+}
+EXPORT_SYMBOL(quota_cgroup_charge_pquota);
+
+/*
+ * Check if a particular file system operation could exceeding a quota
+ * limit policy.  Return -EDQUOT if it run out of quota per the related
+ * policy.
+ */
+int quota_cgroup_validate_pquota(int type, uint32_t projid, uint64_t num)
+{
+	unsigned long long usage, hardlimit;
+	struct quota_policy_item *pi;
+	int retval = 0;
+
+	pi = lookup_cgroup_quota_policy_item(projid);
+	if (!pi || pi->state == QUOTA_OFF)
+		goto out;
+
+	switch (type) {
+	case QUOTA_NEW_INODE:
+		usage = res_counter_read_u64(&pi->inores, RES_USAGE);
+		hardlimit = res_counter_read_u64(&pi->inores, RES_LIMIT);
+		break;
+	case QUOTA_NEW_BLOCK:
+		usage = res_counter_read_u64(&pi->blkres, RES_USAGE);
+		hardlimit = res_counter_read_u64(&pi->blkres, RES_LIMIT);
+		break;
+	default:
+		retval = -EINVAL;
+		goto out;
+	}
+
+	if (usage + num > hardlimit)
+		retval = -EDQUOT;
+
+out:
+	return retval;
+}
+EXPORT_SYMBOL(quota_cgroup_validate_pquota);
+
+static int __init init_cgroup_quota(void)
+{
+	return cgroup_load_subsys(&quota_subsys);
+}
+
+static void __exit exit_cgroup_quota(void)
+{
+	cgroup_unload_subsys(&quota_subsys);
+}
+
+module_init(init_cgroup_quota);
+module_exit(exit_cgroup_quota);
+MODULE_LICENSE("GPL");
diff --git a/include/linux/quota_cgroup.h b/include/linux/quota_cgroup.h
new file mode 100644
index 0000000..2ec98e7
--- /dev/null
+++ b/include/linux/quota_cgroup.h
@@ -0,0 +1,60 @@
+#ifndef __LINUX_QUOTA_CGROUP_H
+#define	__LINUX_QUOTA_CGROUP_H
+
+enum quota_policy_id {
+	QUOTA_SET_PROJECT_ID,
+	QUOTA_REMOVE_PROJECT_ID,
+	QUOTA_SET_BLOCK_LIMIT,
+	QUOTA_RESET_BLOCK_LIMIT,
+	QUOTA_SET_INODE_LIMIT,
+	QUOTA_RESET_INODE_LIMIT,
+	QUOTA_ACTIVATE,
+	QUOTA_DEACTIVATE,
+	QUOTA_SHOW_PROJECTS,
+	QUOTA_SHOW_PROJECTS_VERBOSE,
+};
+
+enum quota_limit_type {
+	BLOCK_LIMIT,
+	INODE_LIMIT,
+};
+
+enum quota_policy_state {
+	QUOTA_BLOCK_LIMIT_OFF,
+	QUOTA_BLOCK_LIMIT_READY,
+	QUOTA_INODE_LIMIT_OFF,
+	QUOTA_INODE_LIMIT_READY,
+	QUOTA_ON,
+	QUOTA_OFF,
+};
+
+enum quota_acct_id {
+	QUOTA_NEW_BLOCK,
+	QUOTA_DROP_BLOCK,
+	QUOTA_ACCT_BLOCK,
+	QUOTA_NEW_INODE,
+	QUOTA_DROP_INODE,
+	QUOTA_ACCT_INODE,
+};
+
+#ifdef CONFIG_CGROUP_QUOTA
+extern int quota_cgroup_validate_pquota(int type, uint32_t projid,
+					uint64_t num);
+extern int quota_cgroup_charge_pquota(int type, uint32_t projid,
+				      uint64_t num);
+#else /* !CONFIG_QUOTA_CGROUP */
+static inline int
+quota_cgroup_validate_pquota(int type, uint32_t projid, uint64_t num)
+{
+	return 0;
+}
+
+static inline int
+quota_cgroup_charge_pquota(int type, uint32_t projid, uint64_t num)
+{
+	return 0;
+}
+
+#endif /* !CONFIG_QUOTA_CGROUP */
+
+#endif /* __LINUX_QUOTA_CGROUP_H */
-- 
1.7.9

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
