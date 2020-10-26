Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87C1DC55178
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:38:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C0B520872
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:38:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ykhaoguy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407229AbgJZXiI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:38:08 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56886 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407215AbgJZXiI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:38:08 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNOgRf164668;
        Mon, 26 Oct 2020 23:35:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=TKBib9/qsBYoEdZdqfK3VY8z6eHwVjQpfxdHJvcvZmw=;
 b=Ykhaoguyv6L2yw6befXUzxXEY2goqRQGAuf6BUDVgDhrH2QX7/4a1RvpDwCv5YYj3N+a
 /CqWvTvMM743vs3bjW4tZDpl7K1+qlqSk9/8YjFgCSWaWpaxNuTs1b91Cg07ZlIt9FBY
 /mvL+DIHWB10mnBhqEfSHjD64GRQFJGWh+BBUZ0jUyEbHxwq+UU44U1mscDiMaEIM7f/
 Ow15LJJ/jiOzGrI+jmXD6DeedqaKyzeP+cNcJGqecSrNmnVuaet80t88NrnKZvKv/1dW
 ttHtugAYGRrhuy7dgjTx8CMJRgHnn73ruBIvzTeFWUvZ0YTaTaJ5AYfjoI5QlsuWFlaV 8A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34dgm3vusp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:35:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPxC5110498;
        Mon, 26 Oct 2020 23:35:39 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 34cx5wfsk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:35:39 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09QNZdgE007906;
        Mon, 26 Oct 2020 23:35:39 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:35:39 -0700
Subject: [PATCH 14/26] xfs: redefine xfs_timestamp_t
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, Gao Xiang <hsiangkao@redhat.com>,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:35:37 -0700
Message-ID: <160375533788.881414.4015452916742062688.stgit@magnolia>
In-Reply-To: <160375524618.881414.16347303401529121282.stgit@magnolia>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Source kernel commit: 5a0bb066f60fa02f453d7721844eae59f505c06e

Redefine xfs_timestamp_t as a __be64 typedef in preparation for the
bigtime functionality.  Preserve the legacy structure format so that we
can let the compiler take care of masking and shifting.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Gao Xiang <hsiangkao@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/fprint.c              |   10 +++++----
 libxfs/libxfs_api_defs.h |    1 +
 libxfs/xfs_format.h      |   10 ++++++---
 libxfs/xfs_inode_buf.c   |   54 ++++++++++++++++++++++++++++++++--------------
 libxfs/xfs_inode_buf.h   |    2 ++
 repair/dinode.c          |    5 +++-
 6 files changed, 58 insertions(+), 24 deletions(-)


diff --git a/db/fprint.c b/db/fprint.c
index 996e9325ddcc..1e8a7b49efe6 100644
--- a/db/fprint.c
+++ b/db/fprint.c
@@ -123,6 +123,7 @@ fp_time(
 	int			base,
 	int			array)
 {
+	struct timespec64	tv;
 	xfs_timestamp_t		*ts;
 	int			bitpos;
 	char			*c;
@@ -137,7 +138,8 @@ fp_time(
 			dbprintf("%d:", i + base);
 
 		ts = obj + byteize(bitpos);
-		t = (int)be32_to_cpu(ts->t_sec);
+		tv = libxfs_inode_from_disk_ts(*ts);
+		t = tv.tv_sec;
 
 		c = ctime(&t);
 		dbprintf("%24.24s", c);
@@ -159,8 +161,8 @@ fp_nsec(
 	int			base,
 	int			array)
 {
+	struct timespec64	tv;
 	xfs_timestamp_t		*ts;
-	unsigned int		nsec;
 	int			bitpos;
 	int			i;
 
@@ -172,9 +174,9 @@ fp_nsec(
 			dbprintf("%d:", i + base);
 
 		ts = obj + byteize(bitpos);
-		nsec = (int)be32_to_cpu(ts->t_nsec);
+		tv = libxfs_inode_from_disk_ts(*ts);
 
-		dbprintf("%u", nsec);
+		dbprintf("%u", tv.tv_nsec);
 
 		if (i < count - 1)
 			dbprintf(" ");
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 7029d0e7daf7..40da71ab3163 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -116,6 +116,7 @@
 #define xfs_inobt_maxrecs		libxfs_inobt_maxrecs
 #define xfs_inobt_stage_cursor		libxfs_inobt_stage_cursor
 #define xfs_inode_from_disk		libxfs_inode_from_disk
+#define xfs_inode_from_disk_ts		libxfs_inode_from_disk_ts
 #define xfs_inode_to_disk		libxfs_inode_to_disk
 #define xfs_inode_validate_cowextsize	libxfs_inode_validate_cowextsize
 #define xfs_inode_validate_extsize	libxfs_inode_validate_extsize
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index a5bf27afdd44..ca11a3eb56dd 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -856,12 +856,16 @@ struct xfs_agfl {
  * seconds and nanoseconds; time zero is the Unix epoch, Jan  1 00:00:00 UTC
  * 1970, which means that the timestamp epoch is the same as the Unix epoch.
  * Therefore, the ondisk min and max defined here can be used directly to
- * constrain the incore timestamps on a Unix system.
+ * constrain the incore timestamps on a Unix system.  Note that we actually
+ * encode a __be64 value on disk.
  */
-typedef struct xfs_timestamp {
+typedef __be64 xfs_timestamp_t;
+
+/* Legacy timestamp encoding format. */
+struct xfs_legacy_timestamp {
 	__be32		t_sec;		/* timestamp seconds */
 	__be32		t_nsec;		/* timestamp nanoseconds */
-} xfs_timestamp_t;
+};
 
 /*
  * Smallest possible ondisk seconds value with traditional timestamps.  This
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index e3fdd71a0c63..1b9f63ebe9f9 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -154,6 +154,21 @@ xfs_imap_to_bp(
 	return 0;
 }
 
+/* Convert an ondisk timestamp to an incore timestamp. */
+struct timespec64
+xfs_inode_from_disk_ts(
+	const xfs_timestamp_t		ts)
+{
+	struct timespec64		tv;
+	struct xfs_legacy_timestamp	*lts;
+
+	lts = (struct xfs_legacy_timestamp *)&ts;
+	tv.tv_sec = (int)be32_to_cpu(lts->t_sec);
+	tv.tv_nsec = (int)be32_to_cpu(lts->t_nsec);
+
+	return tv;
+}
+
 int
 xfs_inode_from_disk(
 	struct xfs_inode	*ip,
@@ -208,12 +223,9 @@ xfs_inode_from_disk(
 	 * a time before epoch is converted to a time long after epoch
 	 * on 64 bit systems.
 	 */
-	inode->i_atime.tv_sec = (int)be32_to_cpu(from->di_atime.t_sec);
-	inode->i_atime.tv_nsec = (int)be32_to_cpu(from->di_atime.t_nsec);
-	inode->i_mtime.tv_sec = (int)be32_to_cpu(from->di_mtime.t_sec);
-	inode->i_mtime.tv_nsec = (int)be32_to_cpu(from->di_mtime.t_nsec);
-	inode->i_ctime.tv_sec = (int)be32_to_cpu(from->di_ctime.t_sec);
-	inode->i_ctime.tv_nsec = (int)be32_to_cpu(from->di_ctime.t_nsec);
+	inode->i_atime = xfs_inode_from_disk_ts(from->di_atime);
+	inode->i_mtime = xfs_inode_from_disk_ts(from->di_mtime);
+	inode->i_ctime = xfs_inode_from_disk_ts(from->di_ctime);
 
 	to->di_size = be64_to_cpu(from->di_size);
 	to->di_nblocks = be64_to_cpu(from->di_nblocks);
@@ -226,8 +238,7 @@ xfs_inode_from_disk(
 	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
 		inode_set_iversion_queried(inode,
 					   be64_to_cpu(from->di_changecount));
-		to->di_crtime.tv_sec = be32_to_cpu(from->di_crtime.t_sec);
-		to->di_crtime.tv_nsec = be32_to_cpu(from->di_crtime.t_nsec);
+		to->di_crtime = xfs_inode_from_disk_ts(from->di_crtime);
 		to->di_flags2 = be64_to_cpu(from->di_flags2);
 		to->di_cowextsize = be32_to_cpu(from->di_cowextsize);
 	}
@@ -249,6 +260,21 @@ xfs_inode_from_disk(
 	return error;
 }
 
+/* Convert an incore timestamp to an ondisk timestamp. */
+static inline xfs_timestamp_t
+xfs_inode_to_disk_ts(
+	const struct timespec64		tv)
+{
+	struct xfs_legacy_timestamp	*lts;
+	xfs_timestamp_t			ts;
+
+	lts = (struct xfs_legacy_timestamp *)&ts;
+	lts->t_sec = cpu_to_be32(tv.tv_sec);
+	lts->t_nsec = cpu_to_be32(tv.tv_nsec);
+
+	return ts;
+}
+
 void
 xfs_inode_to_disk(
 	struct xfs_inode	*ip,
@@ -268,12 +294,9 @@ xfs_inode_to_disk(
 	to->di_projid_hi = cpu_to_be16(from->di_projid >> 16);
 
 	memset(to->di_pad, 0, sizeof(to->di_pad));
-	to->di_atime.t_sec = cpu_to_be32(inode->i_atime.tv_sec);
-	to->di_atime.t_nsec = cpu_to_be32(inode->i_atime.tv_nsec);
-	to->di_mtime.t_sec = cpu_to_be32(inode->i_mtime.tv_sec);
-	to->di_mtime.t_nsec = cpu_to_be32(inode->i_mtime.tv_nsec);
-	to->di_ctime.t_sec = cpu_to_be32(inode->i_ctime.tv_sec);
-	to->di_ctime.t_nsec = cpu_to_be32(inode->i_ctime.tv_nsec);
+	to->di_atime = xfs_inode_to_disk_ts(inode->i_atime);
+	to->di_mtime = xfs_inode_to_disk_ts(inode->i_mtime);
+	to->di_ctime = xfs_inode_to_disk_ts(inode->i_ctime);
 	to->di_nlink = cpu_to_be32(inode->i_nlink);
 	to->di_gen = cpu_to_be32(inode->i_generation);
 	to->di_mode = cpu_to_be16(inode->i_mode);
@@ -292,8 +315,7 @@ xfs_inode_to_disk(
 	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
 		to->di_version = 3;
 		to->di_changecount = cpu_to_be64(inode_peek_iversion(inode));
-		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.tv_sec);
-		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.tv_nsec);
+		to->di_crtime = xfs_inode_to_disk_ts(from->di_crtime);
 		to->di_flags2 = cpu_to_be64(from->di_flags2);
 		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
 		to->di_ino = cpu_to_be64(ip->i_ino);
diff --git a/libxfs/xfs_inode_buf.h b/libxfs/xfs_inode_buf.h
index 89f7bea8efd6..3060ecd24a2e 100644
--- a/libxfs/xfs_inode_buf.h
+++ b/libxfs/xfs_inode_buf.h
@@ -58,4 +58,6 @@ xfs_failaddr_t xfs_inode_validate_cowextsize(struct xfs_mount *mp,
 		uint32_t cowextsize, uint16_t mode, uint16_t flags,
 		uint64_t flags2);
 
+struct timespec64 xfs_inode_from_disk_ts(const xfs_timestamp_t ts);
+
 #endif	/* __XFS_INODE_BUF_H__ */
diff --git a/repair/dinode.c b/repair/dinode.c
index 95e57b5318b5..c1d9d9727d62 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2167,9 +2167,12 @@ static void
 check_nsec(
 	const char		*name,
 	xfs_ino_t		lino,
-	struct xfs_timestamp	*t,
+	xfs_timestamp_t		*ts,
 	int			*dirty)
 {
+	struct xfs_legacy_timestamp *t;
+
+	t = (struct xfs_legacy_timestamp *)ts;
 	if (be32_to_cpu(t->t_nsec) < NSEC_PER_SEC)
 		return;
 

