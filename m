Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21941C7EE26
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 09:01:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236288AbjEWJB2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 05:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236241AbjEWJBZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 05:01:25 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0ED7109
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 02:01:23 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34N6ElTZ032489;
        Tue, 23 May 2023 09:01:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=pytTGB1l4OFgcfUHTFl2Nyv1AwW4714yCeUjB6vtviE=;
 b=Yraxi2UUHZfJ0PleitWmcBruCI6V13SJbV2NbTaVubgtHat4ymvd4EG/Pfv0BS5MieiK
 q3xdhvcuqVVIKir4Rk2lI3bVStzzQToVSm/Zh6udTeHp+EIopAQqGk1EdfyB6WpMFR7V
 e0noSqU2UBhagr3WtzjVJg9jd0SoGu0f1C/ACrQNXojMjn2T1W5+hXFs0GNn/K1EW1tG
 alhvzG3PprajPiJYgZssnUmqTqM+ovnZsQ2pWJx5HBZ0hnQ0gPfTK0Ds/DYkgztNZJ1L
 bdBJo0lvrLdT4t5iT8cOr//E7xS10PS3V7tnKX1WuBwR6cwpz59DGWMFmgDa6EWN1juP qQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qpp5bmmdm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 09:01:20 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34N6oEtL028934;
        Tue, 23 May 2023 09:01:20 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk2aj7r7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 09:01:20 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34N8xws1007681;
        Tue, 23 May 2023 09:01:19 GMT
Received: from chanbabu-fstest.osdevelopmeniad.oraclevcn.com (chanbabu-fstesting.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.250.50])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3qqk2aj76a-20;
        Tue, 23 May 2023 09:01:19 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     cem@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: [PATCH 19/24] mdrestore: Introduce mdrestore v1 operations
Date:   Tue, 23 May 2023 14:30:45 +0530
Message-Id: <20230523090050.373545-20-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230523090050.373545-1-chandan.babu@oracle.com>
References: <20230523090050.373545-1-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-23_05,2023-05-22_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305230074
X-Proofpoint-GUID: Eq7iB3DqkUGr4GqEnJtGkM-D_u87_Olc
X-Proofpoint-ORIG-GUID: Eq7iB3DqkUGr4GqEnJtGkM-D_u87_Olc
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In order to indicate the version of metadump files that they can work with,
this commit renames read_header(), show_info() and restore() functions to
read_header_v1(), show_info_v1() and restore_v1() respectively.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 mdrestore/xfs_mdrestore.c | 76 ++++++++++++++++++++++-----------------
 1 file changed, 43 insertions(+), 33 deletions(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 895e5cdab..5ec1a47b0 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -86,16 +86,26 @@ open_device(
 	return fd;
 }
 
-static void read_header(struct xfs_metablock *mb, FILE *src_f)
+static void
+read_header_v1(
+	void			*header,
+	FILE			*mdfp)
 {
-	if (fread(mb, sizeof(*mb), 1, src_f) != 1)
+	struct xfs_metablock	*mb = header;
+
+	if (fread(mb, sizeof(*mb), 1, mdfp) != 1)
 		fatal("error reading from metadump file\n");
 	if (mb->mb_magic != cpu_to_be32(XFS_MD_MAGIC_V1))
 		fatal("specified file is not a metadata dump\n");
 }
 
-static void show_info(struct xfs_metablock *mb, const char *mdfile)
+static void
+show_info_v1(
+	void			*header,
+	const char		*mdfile)
 {
+	struct xfs_metablock	*mb = header;
+
 	if (mb->mb_info & XFS_METADUMP_INFO_FLAGS) {
 		printf("%s: %sobfuscated, %s log, %s metadata blocks\n",
 			mdfile,
@@ -107,24 +117,15 @@ static void show_info(struct xfs_metablock *mb, const char *mdfile)
 	}
 }
 
-/*
- * restore() -- do the actual work to restore the metadump
- *
- * @src_f: A FILE pointer to the source metadump
- * @dst_fd: the file descriptor for the target file
- * @is_target_file: designates whether the target is a regular file
- * @mbp: pointer to metadump's first xfs_metablock, read and verified by the caller
- *
- * src_f should be positioned just past a read the previously validated metablock
- */
 static void
-restore(
-	FILE			*src_f,
-	int			dst_fd,
-	int			is_target_file,
-	const struct xfs_metablock	*mbp)
+restore_v1(
+	void		*header,
+	FILE		*mdfp,
+	int		data_fd,
+	bool		is_target_file)
 {
-	struct xfs_metablock	*metablock;	/* header + index + blocks */
+	struct xfs_metablock	*mbp = header;
+	struct xfs_metablock	*metablock;
 	__be64			*block_index;
 	char			*block_buffer;
 	int			block_size;
@@ -148,14 +149,15 @@ restore(
 	block_index = (__be64 *)((char *)metablock + sizeof(xfs_metablock_t));
 	block_buffer = (char *)metablock + block_size;
 
-	if (fread(block_index, block_size - sizeof(struct xfs_metablock), 1, src_f) != 1)
+	if (fread(block_index, block_size - sizeof(struct xfs_metablock), 1,
+			mdfp) != 1)
 		fatal("error reading from metadump file\n");
 
 	if (block_index[0] != 0)
 		fatal("first block is not the primary superblock\n");
 
 
-	if (fread(block_buffer, mb_count << mbp->mb_blocklog, 1, src_f) != 1)
+	if (fread(block_buffer, mb_count << mbp->mb_blocklog, 1, mdfp) != 1)
 		fatal("error reading from metadump file\n");
 
 	libxfs_sb_from_disk(&sb, (struct xfs_dsb *)block_buffer);
@@ -178,7 +180,7 @@ restore(
 	if (is_target_file)  {
 		/* ensure regular files are correctly sized */
 
-		if (ftruncate(dst_fd, sb.sb_dblocks * sb.sb_blocksize))
+		if (ftruncate(data_fd, sb.sb_dblocks * sb.sb_blocksize))
 			fatal("cannot set filesystem image size: %s\n",
 				strerror(errno));
 	} else  {
@@ -188,7 +190,7 @@ restore(
 		off64_t		off;
 
 		off = sb.sb_dblocks * sb.sb_blocksize - sizeof(lb);
-		if (pwrite(dst_fd, lb, sizeof(lb), off) < 0)
+		if (pwrite(data_fd, lb, sizeof(lb), off) < 0)
 			fatal("failed to write last block, is target too "
 				"small? (error: %s)\n", strerror(errno));
 	}
@@ -201,7 +203,7 @@ restore(
 			print_progress("%lld MB read", bytes_read >> 20);
 
 		for (cur_index = 0; cur_index < mb_count; cur_index++) {
-			if (pwrite(dst_fd, &block_buffer[cur_index <<
+			if (pwrite(data_fd, &block_buffer[cur_index <<
 					mbp->mb_blocklog], block_size,
 					be64_to_cpu(block_index[cur_index]) <<
 						BBSHIFT) < 0)
@@ -212,7 +214,7 @@ restore(
 		if (mb_count < max_indices)
 			break;
 
-		if (fread(metablock, block_size, 1, src_f) != 1)
+		if (fread(metablock, block_size, 1, mdfp) != 1)
 			fatal("error reading from metadump file\n");
 
 		mb_count = be16_to_cpu(metablock->mb_count);
@@ -222,7 +224,7 @@ restore(
 			fatal("bad block count: %u\n", mb_count);
 
 		if (fread(block_buffer, mb_count << mbp->mb_blocklog,
-								1, src_f) != 1)
+				1, mdfp) != 1)
 			fatal("error reading from metadump file\n");
 
 		bytes_read += block_size + (mb_count << mbp->mb_blocklog);
@@ -239,12 +241,18 @@ restore(
 				 offsetof(struct xfs_sb, sb_crc));
 	}
 
-	if (pwrite(dst_fd, block_buffer, sb.sb_sectsize, 0) < 0)
+	if (pwrite(data_fd, block_buffer, sb.sb_sectsize, 0) < 0)
 		fatal("error writing primary superblock: %s\n", strerror(errno));
 
 	free(metablock);
 }
 
+static struct mdrestore_ops mdrestore_ops_v1 = {
+	.read_header = read_header_v1,
+	.show_info = show_info_v1,
+	.restore = restore_v1,
+};
+
 static void
 usage(void)
 {
@@ -294,9 +302,9 @@ main(
 
 	/*
 	 * open source and test if this really is a dump. The first metadump
-	 * block will be passed to restore() which will continue to read the
-	 * file from this point. This avoids rewind the stream, which causes
-	 * restore to fail when source was being read from stdin.
+	 * block will be passed to mdrestore_ops->restore() which will continue
+	 * to read the file from this point. This avoids rewind the stream,
+	 * which causes restore to fail when source was being read from stdin.
  	 */
 	if (strcmp(argv[optind], "-") == 0) {
 		src_f = stdin;
@@ -308,10 +316,12 @@ main(
 			fatal("cannot open source dump file\n");
 	}
 
-	read_header(&mb, src_f);
+	mdrestore.mdrops = &mdrestore_ops_v1;
+
+	mdrestore.mdrops->read_header(&mb, src_f);
 
 	if (mdrestore.show_info) {
-		show_info(&mb, argv[optind]);
+		mdrestore.mdrops->show_info(&mb, argv[optind]);
 
 		if (argc - optind == 1)
 			exit(0);
@@ -322,7 +332,7 @@ main(
 	/* check and open target */
 	dst_fd = open_device(argv[optind], &is_target_file);
 
-	restore(src_f, dst_fd, is_target_file, &mb);
+	mdrestore.mdrops->restore(&mb, src_f, dst_fd, is_target_file);
 
 	close(dst_fd);
 	if (src_f != stdin)
-- 
2.39.1

