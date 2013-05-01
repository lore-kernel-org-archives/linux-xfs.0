Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AA3B37F80
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 10:58:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4D252304064
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 08:58:42 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 0psa1JuCxfZ3ZYvv (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 01 May 2013 08:58:39 -0700 (PDT)
Message-ID: <51813BA5.3070306@oracle.com>
Date: Wed, 01 May 2013 23:58:29 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: fix log space reservation calculation if log stripe
	unit is specified
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Cc: Dave Chinner <dchinner@redhat.com>

Hello,

About two weeks ago, Dave has found an issue by running xfstests/297.
http://oss.sgi.com/archives/xfs/2013-03/msg00273.html

According to our previous discussion, if the log stripe unit is configured, we should
take it into account as it will dynamically increase the log reservation twice of it
per ticket.

This patch is trying to fix it by checking the given log space against the maximum
request among those transactions(this procedure is implemented similar to xfsprogs/mkfs/maxres.c),
because the fundamental limit is that no single transaction can be larger than half of the log.
Also, looks at least another two log stripe unit should be added when calculating the minimum log
space, or else I can simply trigger a DEAD LOOP via create large number of files, I think I need
some time to digest Dave's comments posted on original bug ticket, i.e.
>> The question is this: how much space do we need to reserve. I'm
>> thinking a minimum of 4*lsu - 2*lsu for the existing CIL context, and
>> another 2*lsu for any queued ticket waiting for space to come
>> available.


Put simply, with this fix, mount a partition with an improper log space setup vs log stripe
unit will failed although mkfs still works. Ah, maybe we can improve the user space xfs_mkfs
with some pre-checkup similar to the implementation inside kernel?  Besides that, it will
drop a warning to syslog and the suggested log space for the given log stripe unit is shown
there, which looks like the following:

# mkfs.xfs -f -b size=512 -d agcount=16,su=256k,sw=12 -l su=256k,size=2560b /dev/sdb1
meta-data=/dev/sdb1              isize=256    agcount=16, agsize=524288 blks
         =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=512    blocks=8388608, imaxpct=25
         =                       sunit=512    swidth=6144 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=512    blocks=2560, version=2
         =                       sectsz=512   sunit=512 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
 
# mount /dev/sdb1 /xfs1
mount: wrong fs type, bad option, bad superblock on /dev/sdb1,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

# dmesg:
.......
XFS (sdb1): log space of 2560 blocks too small, minimum request 6656
XFS (sdb1): log space validation failed
XFS (sdb1): log mount failed


Tests:
Ran some cases in xfstests as well as a few self-defined Bonnie++/FIO tests with above
configuration(6656 log blocks), looks the current fix works, at least no crash to me. :)

But I have not yet dig into the detailed of how the suggested minimum log space would
affect the performance, given that the AIL push thresholds is defined to 25% of the log
space, a small logs might introduce IO overheads for pushing AIL too frequently.
In addition, considering the backgroup CIL commit threshold is 1/8 of the log, this would
also impact the log IO throughput IMHO.  Maybe we can figure out an optimized log space
combine those two cases and drop it to syslog along with the minimum size?


To Dave,

Sorry for the delay in drop this patch since I have mentioned that I'll post a fix
last night.  However, I have ran into an issue when testing it by creating/removing a
tons of files in parallel at that time :(


---
 fs/xfs/xfs_log.c   |  130 ++++++++++++++++++++++++++++++++++-------
 fs/xfs/xfs_log.h   |    3 +
 fs/xfs/xfs_mount.c |    1 +
 fs/xfs/xfs_mount.h |   61 +++++++++++---------
 fs/xfs/xfs_trans.c |  163 +++++++++++++++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_trans.h |   61 ++++++++++----------
 6 files changed, 314 insertions(+), 105 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index eec226f..3efd1d2 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -598,6 +598,64 @@ xfs_log_release_iclog(
 }
  /*
+ * Check if the specified log space is sufficient for a file system
+ * with a given log strip unit.
+ */
+STATIC int
+xfs_mount_validate_log_size(
+	struct xfs_mount	*mp)
+{
+	struct xlog		*log = mp->m_log;
+	struct xfs_trans_res	tres;
+	int			unit_bytes;
+	int			min_lblks, lsu = 0;
+
+	xfs_max_trans_res_by_mount(mp, &tres);
+
+	/*
+	 * Figure out the total space needed for the maximum transaction
+	 * log space reservation by adding some extra spaces which should
+	 * be taken into account.
+	 */
+	unit_bytes = xlog_ticket_unit_res(log, &tres);
+	if (tres.tr_cnt > 1)
+		unit_bytes = unit_bytes * tres.tr_cnt;
+
+	min_lblks = BTOBB(unit_bytes);
+	/*
+	 * FIXME: why we should add another 2 log strip units if it
+	 * is specified?  As per my tryout, creat a dozens dirs/files
+	 * on a partition without another 2 log strip units will
+	 * cause DEAD LOOP, it's fine if taken this into account.
+	 *
+	 * As per Dave's comments:
+	 * I'm thinking a minimum of 4*lsu - 2*lsu for the existing
+	 * CIL context, and another 2*lsu for any queued ticket
+	 * waiting for space to come available.
+	 */
+	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb) &&
+	    log->l_mp->m_sb.sb_logsunit > 1)
+		lsu = BTOBB(log->l_mp->m_sb.sb_logsunit);
+
+	/*
+	 * The fundamental limit is that no single transaction can be
+	 * larger than half the size of the log space, take another
+	 * two log strip unit account as well.
+	 */
+	if ((log->l_logBBsize >> 1) < (min_lblks + lsu)) {
+		xfs_warn(mp,
+	"log space of %d blocks too small, minimum request %d",
+			 log->l_logBBsize,
+			 roundup((int)min_lblks << 1, (int)lsu) +
+			 2 * lsu);
+
+		return XFS_ERROR(EINVAL);
+	}
+
+	return 0;
+}
+
+/*
  * Mount a log filesystem
  *
  * mp		- ubiquitous xfs mount point structure
@@ -630,6 +688,12 @@ xfs_log_mount(
 		goto out;
 	}
 +	error = xfs_mount_validate_log_size(mp);
+	if (error) {
+		xfs_warn(mp, "log space validation failed");
+		goto out_free_log;
+	}
+
 	/*
 	 * Initialize the AIL now we have a log.
 	 */
@@ -3377,24 +3441,23 @@ xfs_log_ticket_get(
 }
  /*
- * Allocate and initialise a new log ticket.
+ * Figure out how many bytes would be reserved totally per ticket.
+ * Especially, take log strip unit into account if it is specified.
+ *
+ * FIXME: this is totally copied from xlog_ticket_alloc(), it's better
+ * to introduce a new helper to calculate the extra space reservation
+ * that can be shared with xlog_ticket_alloc() if the current though
+ * is reasonable.
  */
-struct xlog_ticket *
-xlog_ticket_alloc(
-	struct xlog	*log,
-	int		unit_bytes,
-	int		cnt,
-	char		client,
-	bool		permanent,
-	xfs_km_flags_t	alloc_flags)
+int
+xlog_ticket_unit_res(
+	struct xlog		*log,
+	struct xfs_trans_res	*tres)
 {
-	struct xlog_ticket *tic;
-	uint		num_headers;
-	int		iclog_space;
-
-	tic = kmem_zone_zalloc(xfs_log_ticket_zone, alloc_flags);
-	if (!tic)
-		return NULL;
+	uint			unit_bytes = tres->tr_res;
+	int			total_bytes = unit_bytes;
+	int			iclog_space;
+	uint			num_headers;
  	/*
 	 * Permanent reservations have up to 'cnt'-1 active log operations
@@ -3459,8 +3522,8 @@ xlog_ticket_alloc(
  	/* add extra header reservations if we overrun */
 	while (!num_headers ||
-	       howmany(unit_bytes, iclog_space) > num_headers) {
-		unit_bytes += sizeof(xlog_op_header_t);
+	       howmany(total_bytes, iclog_space) > num_headers) {
+		total_bytes += sizeof(xlog_op_header_t);
 		num_headers++;
 	}
 	unit_bytes += log->l_iclog_hsize * num_headers;
@@ -3478,11 +3541,38 @@ xlog_ticket_alloc(
 		unit_bytes += 2*BBSIZE;
         }
 +	return unit_bytes;
+}
+
+/*
+ * Allocate and initialise a new log ticket.
+ */
+struct xlog_ticket *
+xlog_ticket_alloc(
+	struct xlog	*log,
+	int		unit_bytes,
+	int		cnt,
+	char		client,
+	bool		permanent,
+	xfs_km_flags_t	alloc_flags)
+{
+	struct xlog_ticket *tic;
+	struct xfs_trans_res tres;
+	int		unit_res;
+
+	tic = kmem_zone_zalloc(xfs_log_ticket_zone, alloc_flags);
+	if (!tic)
+		return NULL;
+
+	tres.tr_res = unit_bytes;
+	tres.tr_cnt = cnt;
+	unit_res = xlog_ticket_unit_res(log, &tres);
+
 	atomic_set(&tic->t_ref, 1);
 	tic->t_task		= current;
 	INIT_LIST_HEAD(&tic->t_queue);
-	tic->t_unit_res		= unit_bytes;
-	tic->t_curr_res		= unit_bytes;
+	tic->t_unit_res		= unit_res;
+	tic->t_curr_res		= unit_res;
 	tic->t_cnt		= cnt;
 	tic->t_ocnt		= cnt;
 	tic->t_tid		= random32();
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 5caee96..d3f7187 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -119,11 +119,13 @@ typedef struct xfs_log_callback {
 #ifdef __KERNEL__
 /* Log manager interfaces */
 struct xfs_mount;
+struct xlog;
 struct xlog_in_core;
 struct xlog_ticket;
 struct xfs_log_item;
 struct xfs_item_ops;
 struct xfs_trans;
+struct xfs_trans_res;
  void	xfs_log_item_init(struct xfs_mount	*mp,
 			struct xfs_log_item	*item,
@@ -184,6 +186,7 @@ bool	xfs_log_item_in_current_chkpt(struct xfs_log_item *lip);
 void	xfs_log_work_queue(struct xfs_mount *mp);
 void	xfs_log_worker(struct work_struct *work);
 void	xfs_log_quiesce(struct xfs_mount *mp);
+int	xlog_ticket_unit_res(struct xlog *log, struct xfs_trans_res *tres);
  #endif
 #endif	/* __XFS_LOG_H__ */
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 2836ef6..cb67f96 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -20,6 +20,7 @@
 #include "xfs_types.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
+#include "xfs_log_priv.h"
 #include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 8145412..3f9a73c 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -18,35 +18,40 @@
 #ifndef __XFS_MOUNT_H__
 #define	__XFS_MOUNT_H__
 +typedef struct xfs_trans_res {
+	uint	tr_res;
+	int	tr_cnt;
+} xfs_tr_t;
+
 typedef struct xfs_trans_reservations {
-	uint	tr_write;	/* extent alloc trans */
-	uint	tr_itruncate;	/* truncate trans */
-	uint	tr_rename;	/* rename trans */
-	uint	tr_link;	/* link trans */
-	uint	tr_remove;	/* unlink trans */
-	uint	tr_symlink;	/* symlink trans */
-	uint	tr_create;	/* create trans */
-	uint	tr_mkdir;	/* mkdir trans */
-	uint	tr_ifree;	/* inode free trans */
-	uint	tr_ichange;	/* inode update trans */
-	uint	tr_growdata;	/* fs data section grow trans */
-	uint	tr_swrite;	/* sync write inode trans */
-	uint	tr_addafork;	/* cvt inode to attributed trans */
-	uint	tr_writeid;	/* write setuid/setgid file */
-	uint	tr_attrinval;	/* attr fork buffer invalidation */
-	uint	tr_attrsetm;	/* set/create an attribute at mount time */
-	uint	tr_attrsetrt;	/* set/create an attribute at runtime */
-	uint	tr_attrrm;	/* remove an attribute */
-	uint	tr_clearagi;	/* clear bad agi unlinked ino bucket */
-	uint	tr_growrtalloc;	/* grow realtime allocations */
-	uint	tr_growrtzero;	/* grow realtime zeroing */
-	uint	tr_growrtfree;	/* grow realtime freeing */
-	uint	tr_qm_sbchange;	/* change quota flags */
-	uint	tr_qm_setqlim;	/* adjust quota limits */
-	uint	tr_qm_dqalloc;	/* allocate quota on disk */
-	uint	tr_qm_quotaoff;	/* turn quota off */
-	uint	tr_qm_equotaoff;/* end of turn quota off */
-	uint	tr_sb;		/* modify superblock */
+	xfs_tr_t	tr_write;	/* extent alloc trans */
+	xfs_tr_t	tr_itruncate;	/* truncate trans */
+	xfs_tr_t	tr_rename;	/* rename trans */
+	xfs_tr_t	tr_link;	/* link trans */
+	xfs_tr_t	tr_remove;	/* unlink trans */
+	xfs_tr_t	tr_symlink;	/* symlink trans */
+	xfs_tr_t	tr_create;	/* create trans */
+	xfs_tr_t	tr_mkdir;	/* mkdir trans */
+	xfs_tr_t	tr_ifree;	/* inode free trans */
+	xfs_tr_t	tr_ichange;	/* inode update trans */
+	xfs_tr_t	tr_growdata;	/* fs data section grow trans */
+	xfs_tr_t	tr_swrite;	/* sync write inode trans */
+	xfs_tr_t	tr_addafork;	/* cvt inode to attributed trans */
+	xfs_tr_t	tr_writeid;	/* write setuid/setgid file */
+	xfs_tr_t	tr_attrinval;	/* attr fork buffer invalidation */
+	xfs_tr_t	tr_attrsetm;	/* set/create an attribute at mount time */
+	xfs_tr_t	tr_attrsetrt;	/* set/create an attribute at runtime */
+	xfs_tr_t	tr_attrrm;	/* remove an attribute */
+	xfs_tr_t	tr_clearagi;	/* clear bad agi unlinked ino bucket */
+	xfs_tr_t	tr_growrtalloc;	/* grow realtime allocations */
+	xfs_tr_t	tr_growrtzero;	/* grow realtime zeroing */
+	xfs_tr_t	tr_growrtfree;	/* grow realtime freeing */
+	xfs_tr_t	tr_qm_sbchange;	/* change quota flags */
+	xfs_tr_t	tr_qm_setqlim;	/* adjust quota limits */
+	xfs_tr_t	tr_qm_dqalloc;	/* allocate quota on disk */
+	xfs_tr_t	tr_qm_quotaoff;	/* turn quota off */
+	xfs_tr_t	tr_qm_equotaoff;/* end of turn quota off */
+	xfs_tr_t	tr_sb;		/* modify superblock */
 } xfs_trans_reservations_t;
  #ifndef __KERNEL__
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 2fd7c1f..f2b18a5 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -43,6 +43,7 @@
 #include "xfs_inode_item.h"
 #include "xfs_log_priv.h"
 #include "xfs_buf_item.h"
+#include "xfs_attr_leaf.h"
 #include "xfs_trace.h"
  kmem_zone_t	*xfs_trans_zone;
@@ -645,34 +646,140 @@ xfs_trans_init(
 {
 	struct xfs_trans_reservations *resp = &mp->m_reservations;
 -	resp->tr_write = xfs_calc_write_reservation(mp);
-	resp->tr_itruncate = xfs_calc_itruncate_reservation(mp);
-	resp->tr_rename = xfs_calc_rename_reservation(mp);
-	resp->tr_link = xfs_calc_link_reservation(mp);
-	resp->tr_remove = xfs_calc_remove_reservation(mp);
-	resp->tr_symlink = xfs_calc_symlink_reservation(mp);
-	resp->tr_create = xfs_calc_create_reservation(mp);
-	resp->tr_mkdir = xfs_calc_mkdir_reservation(mp);
-	resp->tr_ifree = xfs_calc_ifree_reservation(mp);
-	resp->tr_ichange = xfs_calc_ichange_reservation(mp);
-	resp->tr_growdata = xfs_calc_growdata_reservation(mp);
-	resp->tr_swrite = xfs_calc_swrite_reservation(mp);
-	resp->tr_writeid = xfs_calc_writeid_reservation(mp);
-	resp->tr_addafork = xfs_calc_addafork_reservation(mp);
-	resp->tr_attrinval = xfs_calc_attrinval_reservation(mp);
-	resp->tr_attrsetm = xfs_calc_attrsetm_reservation(mp);
-	resp->tr_attrsetrt = xfs_calc_attrsetrt_reservation(mp);
-	resp->tr_attrrm = xfs_calc_attrrm_reservation(mp);
-	resp->tr_clearagi = xfs_calc_clear_agi_bucket_reservation(mp);
-	resp->tr_growrtalloc = xfs_calc_growrtalloc_reservation(mp);
-	resp->tr_growrtzero = xfs_calc_growrtzero_reservation(mp);
-	resp->tr_growrtfree = xfs_calc_growrtfree_reservation(mp);
-	resp->tr_qm_sbchange = xfs_calc_qm_sbchange_reservation(mp);
-	resp->tr_qm_setqlim = xfs_calc_qm_setqlim_reservation(mp);
-	resp->tr_qm_dqalloc = xfs_calc_qm_dqalloc_reservation(mp);
-	resp->tr_qm_quotaoff = xfs_calc_qm_quotaoff_reservation(mp);
-	resp->tr_qm_equotaoff = xfs_calc_qm_quotaoff_end_reservation(mp);
-	resp->tr_sb = xfs_calc_sb_reservation(mp);
+	resp->tr_write.tr_res = xfs_calc_write_reservation(mp);
+	resp->tr_write.tr_cnt = XFS_WRITE_LOG_COUNT;
+
+	resp->tr_itruncate.tr_res = xfs_calc_itruncate_reservation(mp);
+	resp->tr_itruncate.tr_cnt = XFS_ITRUNCATE_LOG_COUNT;
+
+	resp->tr_rename.tr_res = xfs_calc_rename_reservation(mp);
+	resp->tr_rename.tr_cnt = XFS_RENAME_LOG_COUNT;
+
+	resp->tr_link.tr_res = xfs_calc_link_reservation(mp);
+	resp->tr_link.tr_cnt = XFS_LINK_LOG_COUNT;
+
+	resp->tr_remove.tr_res = xfs_calc_remove_reservation(mp);
+	resp->tr_remove.tr_cnt = XFS_REMOVE_LOG_COUNT;
+
+	resp->tr_symlink.tr_res = xfs_calc_symlink_reservation(mp);
+	resp->tr_symlink.tr_cnt = XFS_SYMLINK_LOG_COUNT;
+
+	resp->tr_create.tr_res = xfs_calc_create_reservation(mp);
+	resp->tr_create.tr_cnt = XFS_CREATE_LOG_COUNT;
+
+	resp->tr_mkdir.tr_res = xfs_calc_mkdir_reservation(mp);
+	resp->tr_mkdir.tr_cnt = XFS_CREATE_LOG_COUNT;
+
+	resp->tr_ifree.tr_res = xfs_calc_ifree_reservation(mp);
+	resp->tr_ifree.tr_cnt = XFS_INACTIVE_LOG_COUNT;
+
+	resp->tr_ichange.tr_res = xfs_calc_ichange_reservation(mp);
+	resp->tr_ichange.tr_cnt = 0;
+
+	resp->tr_growdata.tr_res = xfs_calc_growdata_reservation(mp);
+	resp->tr_growdata.tr_cnt = 0;
+
+	resp->tr_swrite.tr_res = xfs_calc_swrite_reservation(mp);
+	resp->tr_swrite.tr_cnt = 0;
+
+	resp->tr_writeid.tr_res = xfs_calc_writeid_reservation(mp);
+	resp->tr_writeid.tr_cnt = 0;
+
+	resp->tr_addafork.tr_res = xfs_calc_addafork_reservation(mp);
+	resp->tr_addafork.tr_cnt = XFS_ADDAFORK_LOG_COUNT;
+
+	resp->tr_attrinval.tr_res = xfs_calc_attrinval_reservation(mp);
+	resp->tr_attrinval.tr_cnt = XFS_ATTRINVAL_LOG_COUNT;
+
+	resp->tr_attrsetm.tr_res = xfs_calc_attrsetm_reservation(mp);
+	resp->tr_attrsetm.tr_cnt = XFS_ATTRSET_LOG_COUNT;
+
+	resp->tr_attrsetrt.tr_res = xfs_calc_attrsetrt_reservation(mp);
+	resp->tr_attrsetrt.tr_cnt = XFS_ATTRSET_LOG_COUNT;
+
+	resp->tr_attrrm.tr_res = xfs_calc_attrrm_reservation(mp);
+	resp->tr_attrrm.tr_cnt = XFS_ATTRRM_LOG_COUNT;
+
+	resp->tr_clearagi.tr_res = xfs_calc_clear_agi_bucket_reservation(mp);
+	resp->tr_clearagi.tr_cnt = 0;
+
+	resp->tr_growrtalloc.tr_res = xfs_calc_growrtalloc_reservation(mp);
+	resp->tr_growrtalloc.tr_cnt = 0;
+
+	resp->tr_growrtzero.tr_res = xfs_calc_growrtzero_reservation(mp);
+	resp->tr_growrtzero.tr_cnt = 0;
+
+	resp->tr_growrtfree.tr_res = xfs_calc_growrtfree_reservation(mp);
+	resp->tr_growrtfree.tr_cnt = 0;
+
+	resp->tr_qm_sbchange.tr_res = xfs_calc_qm_sbchange_reservation(mp);
+	resp->tr_qm_sbchange.tr_cnt = XFS_DEFAULT_LOG_COUNT;
+
+	resp->tr_qm_setqlim.tr_res = xfs_calc_qm_setqlim_reservation(mp);
+	resp->tr_qm_setqlim.tr_cnt = XFS_DEFAULT_LOG_COUNT;
+
+	resp->tr_qm_dqalloc.tr_res = xfs_calc_qm_dqalloc_reservation(mp);
+	resp->tr_qm_dqalloc.tr_cnt = XFS_WRITE_LOG_COUNT;
+
+	resp->tr_qm_quotaoff.tr_res = xfs_calc_qm_quotaoff_reservation(mp);
+	resp->tr_qm_quotaoff.tr_cnt = XFS_DEFAULT_LOG_COUNT;
+
+	resp->tr_qm_equotaoff.tr_res = xfs_calc_qm_quotaoff_end_reservation(mp);
+	resp->tr_qm_equotaoff.tr_cnt = XFS_DEFAULT_LOG_COUNT;
+
+	resp->tr_sb.tr_res = xfs_calc_sb_reservation(mp);
+	resp->tr_sb.tr_cnt = XFS_DEFAULT_LOG_COUNT;
+}
+
+STATIC void
+xfs_max_attrsetm_trans_res_adjust(
+	struct xfs_mount	*mp)
+{
+	int			local;
+	int			size;
+	int			nblks;
+	int			res;
+
+	/*
+	 * Determine space the maximal sized attribute will use,
+	 * to calculate the largest reservatoin size needed.
+	 */
+	size = xfs_attr_leaf_newentsize(MAXNAMELEN, 64 * 1024,
+					mp->m_sb.sb_blocksize, &local);
+	ASSERT(!local);
+	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
+	nblks += XFS_B_TO_FSB(mp, size);
+	nblks += XFS_NEXTENTADD_SPACE_RES(mp, size, XFS_ATTR_FORK);
+	res = XFS_ATTRSETM_LOG_RES(mp) + XFS_ATTRSETRT_LOG_RES(mp) * nblks;
+	mp->m_reservations.tr_attrsetm.tr_res = res;
+}
+
+/*
+ * Figure out the total log space a transaction would required in terms
+ * of the pre-calculated values which are done at mount time, then find
+ * out and return the maximum reservation among them.
+ */
+void
+xfs_max_trans_res_by_mount(
+	struct xfs_mount		*mp,
+	struct xfs_trans_res		*mres)
+{
+	struct xfs_trans_reservations	*resp = &mp->m_reservations;
+	struct xfs_trans_res		*p, *tres = NULL;
+	int				res;
+
+	for (res = 0, p = (struct xfs_trans_res *)resp;
+	     p < (struct xfs_trans_res *)(resp + 1); p++) {
+		int	tmp = p->tr_cnt > 1 ? p->tr_res * p->tr_cnt :
+					      p->tr_res;
+		if (res < tmp) {
+			res = tmp;
+			tres = p;
+		}
+	}
+
+	ASSERT(tres != NULL);
+	*mres = *tres;
 }
  /*
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index cd29f61..b304bb8 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -19,6 +19,7 @@
 #define	__XFS_TRANS_H__
  struct xfs_log_item;
+struct xfs_trans_res;
  /*
  * This is the structure written in the log at the head of
@@ -232,39 +233,39 @@ struct xfs_log_item_desc {
 	 XFS_DAENTER_BMAPS(mp, XFS_DATA_FORK) + 1)
  -#define	XFS_WRITE_LOG_RES(mp)	((mp)->m_reservations.tr_write)
-#define	XFS_ITRUNCATE_LOG_RES(mp)   ((mp)->m_reservations.tr_itruncate)
-#define	XFS_RENAME_LOG_RES(mp)	((mp)->m_reservations.tr_rename)
-#define	XFS_LINK_LOG_RES(mp)	((mp)->m_reservations.tr_link)
-#define	XFS_REMOVE_LOG_RES(mp)	((mp)->m_reservations.tr_remove)
-#define	XFS_SYMLINK_LOG_RES(mp)	((mp)->m_reservations.tr_symlink)
-#define	XFS_CREATE_LOG_RES(mp)	((mp)->m_reservations.tr_create)
-#define	XFS_MKDIR_LOG_RES(mp)	((mp)->m_reservations.tr_mkdir)
-#define	XFS_IFREE_LOG_RES(mp)	((mp)->m_reservations.tr_ifree)
-#define	XFS_ICHANGE_LOG_RES(mp)	((mp)->m_reservations.tr_ichange)
-#define	XFS_GROWDATA_LOG_RES(mp)    ((mp)->m_reservations.tr_growdata)
-#define	XFS_GROWRTALLOC_LOG_RES(mp)	((mp)->m_reservations.tr_growrtalloc)
-#define	XFS_GROWRTZERO_LOG_RES(mp)	((mp)->m_reservations.tr_growrtzero)
-#define	XFS_GROWRTFREE_LOG_RES(mp)	((mp)->m_reservations.tr_growrtfree)
-#define	XFS_SWRITE_LOG_RES(mp)	((mp)->m_reservations.tr_swrite)
+#define	XFS_WRITE_LOG_RES(mp)	((mp)->m_reservations.tr_write.tr_res)
+#define	XFS_ITRUNCATE_LOG_RES(mp)   ((mp)->m_reservations.tr_itruncate.tr_res)
+#define	XFS_RENAME_LOG_RES(mp)	((mp)->m_reservations.tr_rename.tr_res)
+#define	XFS_LINK_LOG_RES(mp)	((mp)->m_reservations.tr_link.tr_res)
+#define	XFS_REMOVE_LOG_RES(mp)	((mp)->m_reservations.tr_remove.tr_res)
+#define	XFS_SYMLINK_LOG_RES(mp)	((mp)->m_reservations.tr_symlink.tr_res)
+#define	XFS_CREATE_LOG_RES(mp)	((mp)->m_reservations.tr_create.tr_res)
+#define	XFS_MKDIR_LOG_RES(mp)	((mp)->m_reservations.tr_mkdir.tr_res)
+#define	XFS_IFREE_LOG_RES(mp)	((mp)->m_reservations.tr_ifree.tr_res)
+#define	XFS_ICHANGE_LOG_RES(mp)	((mp)->m_reservations.tr_ichange.tr_res)
+#define	XFS_GROWDATA_LOG_RES(mp)    ((mp)->m_reservations.tr_growdata.tr_res)
+#define	XFS_GROWRTALLOC_LOG_RES(mp)	((mp)->m_reservations.tr_growrtalloc.tr_res)
+#define	XFS_GROWRTZERO_LOG_RES(mp)	((mp)->m_reservations.tr_growrtzero.tr_res)
+#define	XFS_GROWRTFREE_LOG_RES(mp)	((mp)->m_reservations.tr_growrtfree.tr_res)
+#define	XFS_SWRITE_LOG_RES(mp)	((mp)->m_reservations.tr_swrite.tr_res)
 /*
  * Logging the inode timestamps on an fsync -- same as SWRITE
  * as long as SWRITE logs the entire inode core
  */
-#define XFS_FSYNC_TS_LOG_RES(mp)        ((mp)->m_reservations.tr_swrite)
-#define	XFS_WRITEID_LOG_RES(mp)		((mp)->m_reservations.tr_swrite)
-#define	XFS_ADDAFORK_LOG_RES(mp)	((mp)->m_reservations.tr_addafork)
-#define	XFS_ATTRINVAL_LOG_RES(mp)	((mp)->m_reservations.tr_attrinval)
-#define	XFS_ATTRSETM_LOG_RES(mp)	((mp)->m_reservations.tr_attrsetm)
-#define XFS_ATTRSETRT_LOG_RES(mp)	((mp)->m_reservations.tr_attrsetrt)
-#define	XFS_ATTRRM_LOG_RES(mp)		((mp)->m_reservations.tr_attrrm)
-#define	XFS_CLEAR_AGI_BUCKET_LOG_RES(mp)  ((mp)->m_reservations.tr_clearagi)
-#define XFS_QM_SBCHANGE_LOG_RES(mp)	((mp)->m_reservations.tr_qm_sbchange)
-#define XFS_QM_SETQLIM_LOG_RES(mp)	((mp)->m_reservations.tr_qm_setqlim)
-#define XFS_QM_DQALLOC_LOG_RES(mp)	((mp)->m_reservations.tr_qm_dqalloc)
-#define XFS_QM_QUOTAOFF_LOG_RES(mp)	((mp)->m_reservations.tr_qm_quotaoff)
-#define XFS_QM_QUOTAOFF_END_LOG_RES(mp)	((mp)->m_reservations.tr_qm_equotaoff)
-#define XFS_SB_LOG_RES(mp)		((mp)->m_reservations.tr_sb)
+#define XFS_FSYNC_TS_LOG_RES(mp)        ((mp)->m_reservations.tr_swrite.tr_res)
+#define	XFS_WRITEID_LOG_RES(mp)		((mp)->m_reservations.tr_swrite.tr_res)
+#define	XFS_ADDAFORK_LOG_RES(mp)	((mp)->m_reservations.tr_addafork.tr_res)
+#define	XFS_ATTRINVAL_LOG_RES(mp)	((mp)->m_reservations.tr_attrinval.tr_res)
+#define	XFS_ATTRSETM_LOG_RES(mp)	((mp)->m_reservations.tr_attrsetm.tr_res)
+#define XFS_ATTRSETRT_LOG_RES(mp)	((mp)->m_reservations.tr_attrsetrt.tr_res)
+#define	XFS_ATTRRM_LOG_RES(mp)		((mp)->m_reservations.tr_attrrm.tr_res)
+#define	XFS_CLEAR_AGI_BUCKET_LOG_RES(mp)  ((mp)->m_reservations.tr_clearagi.tr_res)
+#define XFS_QM_SBCHANGE_LOG_RES(mp)	((mp)->m_reservations.tr_qm_sbchange.tr_res)
+#define XFS_QM_SETQLIM_LOG_RES(mp)	((mp)->m_reservations.tr_qm_setqlim.tr_res)
+#define XFS_QM_DQALLOC_LOG_RES(mp)	((mp)->m_reservations.tr_qm_dqalloc.tr_res)
+#define XFS_QM_QUOTAOFF_LOG_RES(mp)	((mp)->m_reservations.tr_qm_quotaoff.tr_res)
+#define XFS_QM_QUOTAOFF_END_LOG_RES(mp)	((mp)->m_reservations.tr_qm_equotaoff.tr_res)
+#define XFS_SB_LOG_RES(mp)		((mp)->m_reservations.tr_sb.tr_res)
  /*
  * Various log count values.
@@ -526,6 +527,8 @@ int		xfs_trans_commit(xfs_trans_t *, uint flags);
 void		xfs_trans_cancel(xfs_trans_t *, int);
 int		xfs_trans_ail_init(struct xfs_mount *);
 void		xfs_trans_ail_destroy(struct xfs_mount *);
+void		xfs_max_trans_res_by_mount(struct xfs_mount *,
+					   struct xfs_trans_res *);
  extern kmem_zone_t	*xfs_trans_zone;
 extern kmem_zone_t	*xfs_log_item_desc_zone;
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
