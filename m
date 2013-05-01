Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D38317F37
	for <xfs@oss.sgi.com>; Tue, 30 Apr 2013 19:17:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 534A8AC006
	for <xfs@oss.sgi.com>; Tue, 30 Apr 2013 17:17:23 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	0BdRs43k1gd5G5oU for <xfs@oss.sgi.com>;
	Tue, 30 Apr 2013 17:17:17 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1UXKjS-0007LA-4v
	for xfs@oss.sgi.com; Wed, 01 May 2013 10:17:14 +1000
Date: Wed, 1 May 2013 10:17:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 9/8] libxlog: fix log buffer alignment
Message-ID: <20130501001714.GH10481@dastard>
References: <20130430121300.GB10481@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130430121300.GB10481@dastard>
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
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

The libxlog sync changed the way log buffers used in recovery are
aligned to sector sizes. The old code used to check for a zero log
sector size and not do any alignment - this check was removed from
the kernel code because there is always log sector size configured.
It turns out that userspace *never* sets the log sector size, so
userspace has always simply ignored the alignment in log replay
(oops!).

This problem manifested itself as detecting a freshly mkfs'd
filesystem as having a totally zeroed log and hence xfs_check was
emitting output and hence xfstests was refusing to run.

This patch correctly configures the callers that use the log
recovery code so that the log sector size is set appropriately and
ensures that log recovery operates as expected.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/sb.c                   |    5 +++++
 libxlog/xfs_log_recover.c |    5 ++++-
 logprint/logprint.c       |    6 ++++++
 repair/phase2.c           |    4 ++++
 4 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/db/sb.c b/db/sb.c
index d83db9c..4da1f6a 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -235,10 +235,15 @@ sb_logcheck(void)
 		x.logdev = x.ddev;
 	x.logBBsize = XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
 	x.logBBstart = XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart);
+	x.lbsize = BBSIZE;
+	if (xfs_sb_version_hassector(&mp->m_sb))
+		x.lbsize <<= (mp->m_sb.sb_logsectlog - BBSHIFT);
+
 	log.l_dev = (mp->m_sb.sb_logstart == 0) ? x.logdev : x.ddev;
 	log.l_logsize = BBTOB(log.l_logBBsize);
 	log.l_logBBsize = x.logBBsize;
 	log.l_logBBstart = x.logBBstart;
+	log.l_sectBBsize  = BTOBB(x.lbsize);
 	log.l_mp = mp;
 
 	if (xlog_find_tail(&log, &head_blk, &tail_blk)) {
diff --git a/libxlog/xfs_log_recover.c b/libxlog/xfs_log_recover.c
index ad53e86..028d1e3 100644
--- a/libxlog/xfs_log_recover.c
+++ b/libxlog/xfs_log_recover.c
@@ -21,7 +21,10 @@
 #define xfs_readonly_buftarg(buftarg)			(0)
 
 /* avoid set-but-unused var warning. gcc is not very bright. */
-#define xlog_clear_stale_blocks(log, taillsn)		((taillsn) = (taillsn))
+#define xlog_clear_stale_blocks(log, taillsn)		({ \
+	(taillsn) = (taillsn); \
+	(0); \
+})
 
 
 /*
diff --git a/logprint/logprint.c b/logprint/logprint.c
index 813424a..3fbcdba 100644
--- a/logprint/logprint.c
+++ b/logprint/logprint.c
@@ -94,6 +94,10 @@ logstat(xfs_mount_t *mp)
 
 		x.logBBsize = XFS_FSB_TO_BB(mp, sb->sb_logblocks);
 		x.logBBstart = XFS_FSB_TO_DADDR(mp, sb->sb_logstart);
+		x.lbsize = BBSIZE;
+		if (xfs_sb_version_hassector(sb))
+			x.lbsize <<= (sb->sb_logsectlog - BBSHIFT);
+
 		if (!x.logname && sb->sb_logstart == 0) {
 			fprintf(stderr, _("    external log device not specified\n\n"));
 			usage();
@@ -105,6 +109,7 @@ logstat(xfs_mount_t *mp)
 		stat(x.dname, &s);
 		x.logBBsize = s.st_size >> 9;
 		x.logBBstart = 0;
+		x.lbsize = BBSIZE;
 	}
 
 
@@ -235,6 +240,7 @@ main(int argc, char **argv)
 	log.l_logsize     = BBTOB(x.logBBsize);
 	log.l_logBBstart  = x.logBBstart;
 	log.l_logBBsize   = x.logBBsize;
+	log.l_sectBBsize  = BTOBB(x.lbsize);
 	log.l_mp          = &mount;
 
 	switch (print_operation) {
diff --git a/repair/phase2.c b/repair/phase2.c
index 23b457a..382cd7b 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -47,11 +47,15 @@ zero_log(xfs_mount_t *mp)
 		x.logdev = x.ddev;
 	x.logBBsize = XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
 	x.logBBstart = XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart);
+	x.lbsize = BBSIZE;
+	if (xfs_sb_version_hassector(&mp->m_sb))
+		x.lbsize <<= (mp->m_sb.sb_logsectlog - BBSHIFT);
 
 	log.l_dev = logdev;
 	log.l_logsize = BBTOB(x.logBBsize);
 	log.l_logBBsize = x.logBBsize;
 	log.l_logBBstart = x.logBBstart;
+	log.l_sectBBsize  = BTOBB(x.lbsize);
 	log.l_mp = mp;
 	if (xfs_sb_version_hassector(&mp->m_sb)) {
 		log.l_sectbb_log = mp->m_sb.sb_logsectlog - BBSHIFT;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
