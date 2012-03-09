Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q29ELiha236789 for <xfs@oss.sgi.com>; Fri, 9 Mar 2012 08:21:44 -0600
Message-ID: <4F59E799.6030409@oracle.com>
Date: Fri, 09 Mar 2012 19:20:57 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [RFC PATCH v1 1/4] cgroup quota: add disk space parse strategy to
	res_counter
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

Introduce a new disk space parse strategy routine for cgroup quota supports.
disk_space_parse() is simply copied from mmparse() with Petabytes and Terabytes parse.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 include/linux/res_counter.h |    3 ++
 kernel/res_counter.c        |   58 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+), 0 deletions(-)

diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
index c9d625c..f8ce315 100644
--- a/include/linux/res_counter.h
+++ b/include/linux/res_counter.h
@@ -79,6 +79,9 @@ typedef int (*write_strategy_fn)(const char *buf, unsigned long long *val);
 int res_counter_memparse_write_strategy(const char *buf,
 					unsigned long long *res);
 
+int res_counter_diskspace_parse_write_strategy(const char *buf,
+					       unsigned long long *res);
+
 int res_counter_write(struct res_counter *counter, int member,
 		      const char *buffer, write_strategy_fn write_strategy);
 
diff --git a/kernel/res_counter.c b/kernel/res_counter.c
index 34683ef..42c1623 100644
--- a/kernel/res_counter.c
+++ b/kernel/res_counter.c
@@ -145,6 +145,64 @@ u64 res_counter_read_u64(struct res_counter *counter, int member)
 }
 #endif
 
+/*
+ * Copy from memparse(), add terabytes, petabytes parse support.
+ */
+unsigned long long disk_space_parse(const char *ptr, char **retptr)
+{
+	char *endptr; /* local pointer to end of parsed string */
+	unsigned long long ret = kstrtoull(ptr, &endptr, 0);
+
+	switch (*endptr) {
+	case 'P':
+	case 'p':
+		ret <<= 10;
+	case 'T':
+	case 't':
+		ret <<= 10;
+	case 'G':
+	case 'g':
+		ret <<= 10;
+	case 'M':
+	case 'm':
+		ret <<= 10;
+	case 'K':
+	case 'k':
+		ret <<= 10;
+		endptr++;
+	default:
+		break;
+	}
+
+	if (retptr)
+		*retptr = endptr;
+
+	return ret;
+}
+
+int res_counter_diskspace_parse_write_strategy(const char *buf,
+					       unsigned long long *res)
+{
+	char *end;
+
+	/* return RESOURCE_MAX(unlimited) if "-1" is specified */
+	if (*buf == '-') {
+		*res = kstrtoull(buf + 1, &end, 10);
+		if (*res != 1 || *end != '\0')
+			return -EINVAL;
+		*res = RESOURCE_MAX;
+		return 0;
+	}
+
+	/* FIXME - make memparse() take const char* args */
+	*res = disk_space_parse((char *)buf, &end);
+	if (*end != '\0')
+		return -EINVAL;
+
+	/* FIXME - need to return *res as block aligned? */
+	return 0;
+}
+
 int res_counter_memparse_write_strategy(const char *buf,
 					unsigned long long *res)
 {
-- 
1.7.9

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
