Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0NHXVQG123058 for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 11:33:31 -0600
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158]) by
	cuda.sgi.com with ESMTP id OywvaQqyHYLrF4dH for
	<xfs@oss.sgi.com>; Mon, 23 Jan 2012 09:33:30 -0800 (PST)
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Mon, 23 Jan 2012 10:33:30 -0700
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com
	[9.17.195.107])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 52BC83E40048
	for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 10:33:27 -0700 (MST)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	q0NHX9P0114954 for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 10:33:19 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id q0NHX5eA015169
	for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 10:33:05 -0700
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Mon, 23 Jan 2012 11:33:04 -0600
Message-Id: <20120123173304.31735.10706.sendpatchset@chandra-lucid.austin.ibm.com>
In-Reply-To: <20120123173243.31735.37262.sendpatchset@chandra-lucid.austin.ibm.com>
References: <20120123173243.31735.37262.sendpatchset@chandra-lucid.austin.ibm.com>
Subject: [PATCH 3/4] xfsprogs: Add qs_pquota to the fs_quota
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Chandra Seetharaman <sekharan@us.ibm.com>

>From 9de21fc22372c3ba65a38e259aa023a74d1cae36 Mon Sep 17 00:00:00 2001
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Tue, 13 Dec 2011 16:08:19 -0600
Subject: [PATCH 3/4] Add a new field qs_pquota to the data structure fs_quota_stat and also
 define a new version for the same.

Inform the kernel that the data structure is newer one and on return
from kernel check the version and act accordingly.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 include/xqm.h |    2 ++
 quota/state.c |    6 +++++-
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/include/xqm.h b/include/xqm.h
index 47f58a0..24e1ea0 100644
--- a/include/xqm.h
+++ b/include/xqm.h
@@ -124,6 +124,7 @@ typedef struct fs_disk_quota {
  * incore.
  */
 #define FS_QSTAT_VERSION	1	/* fs_quota_stat.qs_version */
+#define FS_QSTAT_VERSION_2	2	/* new field qs_pquota */
 
 /*
  * Some basic information about 'quota files'.
@@ -146,6 +147,7 @@ typedef struct fs_quota_stat {
 	__s32		qs_rtbtimelimit;/* limit for rt blks timer */
 	__u16		qs_bwarnlimit;	/* limit for num warnings */
 	__u16		qs_iwarnlimit;	/* limit for num warnings */
+	fs_qfilestat_t	qs_pquota;	/* project quota storage information */
 } fs_quota_stat_t;
 
 #endif	/* __XQM_H__ */
diff --git a/quota/state.c b/quota/state.c
index 42bffc0..678699f 100644
--- a/quota/state.c
+++ b/quota/state.c
@@ -152,6 +152,8 @@ state_quotafile_mount(
 	fs_quota_stat_t	s;
 	char		*dev = mount->fs_name;
 
+	bzero(&s, sizeof(struct fs_quota_stat));
+	s.qs_version = FS_QSTAT_VERSION_2;
 	if (xfsquotactl(XFS_GETQSTAT, dev, type, 0, (void *)&s) < 0) {
 		if (flags & VERBOSE_FLAG)
 			fprintf(fp, _("%s quota are not enabled on %s\n"),
@@ -168,7 +170,9 @@ state_quotafile_mount(
 				s.qs_flags & XFS_QUOTA_GDQ_ACCT,
 				s.qs_flags & XFS_QUOTA_GDQ_ENFD);
 	if (type & XFS_PROJ_QUOTA)
-		state_qfilestat(fp, mount, XFS_PROJ_QUOTA, &s.qs_gquota,
+		state_qfilestat(fp, mount, XFS_PROJ_QUOTA, 
+				(s.qs_version >= FS_QSTAT_VERSION_2) ?
+				&s.qs_pquota : &s.qs_gquota,
 				s.qs_flags & XFS_QUOTA_PDQ_ACCT,
 				s.qs_flags & XFS_QUOTA_PDQ_ENFD);
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
