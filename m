Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58CE3C7EE2A
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 09:01:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236276AbjEWJBd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 05:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236289AbjEWJB2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 05:01:28 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 776ED100
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 02:01:26 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34N6EdCP031370;
        Tue, 23 May 2023 09:01:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=yGeEcD3s5TZmhmVzU4PTOjtr4di0yDyS1F6FHEviNm4=;
 b=PJ30Anh4ovPXinTxDgbtXEQKcWIk9EHNEjVyBCWwzCeUbFThJvYVbekFvK4yuYeApQEp
 fX3GExpV2oRQN/qtsk7i1WJLdGzcmHA/zeW3JIYNEVGOTHMxJaAJuFKZeAa4FkOM4LQQ
 ZnciQCpVB9G4MBSTdW7tfKcTDez4aZYr5BqLvZt+H9fF5Hd4Jp32dPVDYxUmG4O1E2QE
 gLbE5sdOUZZrpoeZcOrzRKuoTu4vsvYj+RTmqDDz7Gwa9L6YBLfoIqMXG81BhR3EiLTt
 9bX7N8/1ATZKco3BCCW+JLYjFowCy/W4lnoBhOlGgBaoAyjpNjQaBsQh5NV6yJXATbZk 6Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qpp3mmn4d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 09:01:23 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34N71J16029055;
        Tue, 23 May 2023 09:01:22 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk2aj7u0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 09:01:22 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34N8xws7007681;
        Tue, 23 May 2023 09:01:22 GMT
Received: from chanbabu-fstest.osdevelopmeniad.oraclevcn.com (chanbabu-fstesting.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.250.50])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3qqk2aj76a-23;
        Tue, 23 May 2023 09:01:22 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     cem@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: [PATCH 22/24] mdrestore: Define mdrestore ops for v2 format
Date:   Tue, 23 May 2023 14:30:48 +0530
Message-Id: <20230523090050.373545-23-chandan.babu@oracle.com>
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
X-Proofpoint-ORIG-GUID: Q9daB8SDOltDlLvxUb_dj8mHwouNTe1V
X-Proofpoint-GUID: Q9daB8SDOltDlLvxUb_dj8mHwouNTe1V
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds functionality to restore metadump stored in v2 format.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 mdrestore/xfs_mdrestore.c | 209 +++++++++++++++++++++++++++++++++++---
 1 file changed, 194 insertions(+), 15 deletions(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 615ecdc77..9e06d37dc 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -11,7 +11,8 @@ struct mdrestore_ops {
 	int (*read_header)(void *header, FILE *mdfp);
 	void (*show_info)(void *header, const char *mdfile);
 	void (*restore)(void *header, FILE *mdfp, int data_fd,
-			bool is_target_file);
+			bool is_data_target_file, int log_fd,
+			bool is_log_target_file);
 };
 
 static struct mdrestore {
@@ -148,7 +149,9 @@ restore_v1(
 	void		*header,
 	FILE		*mdfp,
 	int		data_fd,
-	bool		is_target_file)
+	bool		is_data_target_file,
+	int		log_fd,
+	bool		is_log_target_file)
 {
 	struct xfs_metablock	*mbp = header;
 	struct xfs_metablock	*metablock;
@@ -203,7 +206,7 @@ restore_v1(
 
 	((struct xfs_dsb*)block_buffer)->sb_inprogress = 1;
 
-	verify_device_size(data_fd, is_target_file, sb.sb_dblocks,
+	verify_device_size(data_fd, is_data_target_file, sb.sb_dblocks,
 			sb.sb_blocksize);
 
 	bytes_read = 0;
@@ -264,6 +267,163 @@ static struct mdrestore_ops mdrestore_ops_v1 = {
 	.restore = restore_v1,
 };
 
+static int
+read_header_v2(
+	void				*header,
+	FILE				*mdfp)
+{
+	struct xfs_metadump_header	*xmh = header;
+
+	rewind(mdfp);
+
+	if (fread(xmh, sizeof(*xmh), 1, mdfp) != 1)
+		fatal("error reading from metadump file\n");
+	if (xmh->xmh_magic != cpu_to_be32(XFS_MD_MAGIC_V2))
+		return -1;
+
+	return 0;
+}
+
+static void
+show_info_v2(
+	void				*header,
+	const char			*mdfile)
+{
+	struct xfs_metadump_header	*xmh;
+	uint32_t			incompat_flags;
+
+	xmh = header;
+	incompat_flags = be32_to_cpu(xmh->xmh_incompat_flags);
+
+	printf("%s: %sobfuscated, %s log, %s metadata blocks\n",
+		mdfile,
+		incompat_flags & XFS_MD2_INCOMPAT_OBFUSCATED ? "":"not ",
+		incompat_flags & XFS_MD2_INCOMPAT_DIRTYLOG ? "dirty":"clean",
+		incompat_flags & XFS_MD2_INCOMPAT_FULLBLOCKS ? "full":"zeroed");
+}
+
+static void
+restore_v2(
+	void			*header,
+	FILE			*mdfp,
+	int			data_fd,
+	bool			is_data_target_file,
+	int			log_fd,
+	bool			is_log_target_file)
+{
+	struct xfs_sb		sb;
+	struct xfs_meta_extent	xme;
+	char			*block_buffer;
+	int64_t			bytes_read;
+	uint64_t		offset;
+	int			prev_len;
+	int			len;
+
+	if (fread(&xme, sizeof(xme), 1, mdfp) != 1)
+		fatal("error reading from metadump file\n");
+
+	len = be32_to_cpu(xme.xme_len);
+	len <<= BBSHIFT;
+
+	block_buffer = calloc(1, len);
+	if (block_buffer == NULL)
+		fatal("memory allocation failure\n");
+
+	if (fread(block_buffer, len, 1, mdfp) != 1)
+		fatal("error reading from metadump file\n");
+
+	libxfs_sb_from_disk(&sb, (struct xfs_dsb *)block_buffer);
+
+	if (sb.sb_magicnum != XFS_SB_MAGIC)
+		fatal("bad magic number for primary superblock\n");
+
+	if (sb.sb_logstart == 0 && log_fd == -1)
+		fatal("External Log device is required\n");
+
+	((struct xfs_dsb *)block_buffer)->sb_inprogress = 1;
+
+	verify_device_size(data_fd, is_data_target_file, sb.sb_dblocks,
+			sb.sb_blocksize);
+
+	if (sb.sb_logstart == 0)
+		verify_device_size(log_fd, is_log_target_file, sb.sb_logblocks,
+				sb.sb_blocksize);
+
+	bytes_read = 0;
+
+	do {
+		int fd;
+
+		if (mdrestore.show_progress &&
+			(bytes_read & ((1 << 20) - 1)) == 0)
+			print_progress("%lld MB read", bytes_read >> 20);
+
+		offset = be64_to_cpu(xme.xme_addr) & XME_ADDR_DEVICE_MASK;
+		offset <<= BBSHIFT;
+
+		if (be64_to_cpu(xme.xme_addr) & XME_ADDR_DATA_DEVICE)
+			fd = data_fd;
+		else if (be64_to_cpu(xme.xme_addr) & XME_ADDR_LOG_DEVICE)
+			fd = log_fd;
+		else
+			ASSERT(0);
+
+		if (pwrite(fd, block_buffer, len, offset) < 0)
+			fatal("error writing to %s device at offset %llu: %s\n",
+				fd == data_fd ? "data": "log", offset,
+				strerror(errno));
+
+                if (fread(&xme, sizeof(xme), 1, mdfp) != 1) {
+			if (feof(mdfp))
+				break;
+			fatal("error reading from metadump file\n");
+		}
+
+		prev_len = len;
+		len = be32_to_cpu(xme.xme_len);
+		len <<= BBSHIFT;
+		if (len > prev_len) {
+			void *p;
+			p = realloc(block_buffer, len);
+			if (p == NULL) {
+				free(block_buffer);
+				fatal("memory allocation failure\n");
+			}
+			block_buffer = p;
+		}
+
+		if (fread(block_buffer, len, 1, mdfp) != 1)
+			fatal("error reading from metadump file\n");
+
+		bytes_read += len;
+	} while (1);
+
+	if (mdrestore.progress_since_warning)
+		putchar('\n');
+
+        memset(block_buffer, 0, sb.sb_sectsize);
+	sb.sb_inprogress = 0;
+	libxfs_sb_to_disk((struct xfs_dsb *)block_buffer, &sb);
+	if (xfs_sb_version_hascrc(&sb)) {
+		xfs_update_cksum(block_buffer, sb.sb_sectsize,
+				offsetof(struct xfs_sb, sb_crc));
+	}
+
+	if (pwrite(data_fd, block_buffer, sb.sb_sectsize, 0) < 0)
+		fatal("error writing primary superblock: %s\n",
+			strerror(errno));
+
+	free(block_buffer);
+
+	return;
+}
+
+static struct mdrestore_ops mdrestore_ops_v2 = {
+	.read_header = read_header_v2,
+	.show_info = show_info_v2,
+	.restore = restore_v2,
+};
+
 static void
 usage(void)
 {
@@ -276,11 +436,16 @@ main(
 	int 		argc,
 	char 		**argv)
 {
-	FILE		*src_f;
-	int		dst_fd;
-	int		c;
-	bool		is_target_file;
-	struct xfs_metablock	mb;
+	struct xfs_metadump_header	xmh;
+	struct xfs_metablock		mb;
+	FILE				*src_f;
+	char				*logdev = NULL;
+	void				*header;
+	int				data_dev_fd;
+	int				log_dev_fd;
+	int				c;
+	bool				is_data_dev_file;
+	bool				is_log_dev_file;
 
 	mdrestore.show_progress = 0;
 	mdrestore.show_info = 0;
@@ -327,13 +492,18 @@ main(
 			fatal("cannot open source dump file\n");
 	}
 
-	if (mdrestore_ops_v1.read_header(&mb, src_f) == 0)
+	if (mdrestore_ops_v1.read_header(&mb, src_f) == 0) {
 		mdrestore.mdrops = &mdrestore_ops_v1;
-	else
+		header = &mb;
+	} else if (mdrestore_ops_v2.read_header(&xmh, src_f) == 0) {
+		mdrestore.mdrops = &mdrestore_ops_v2;
+		header = &xmh;
+	} else {
 		fatal("Invalid metadump format\n");
+	}
 
 	if (mdrestore.show_info) {
-		mdrestore.mdrops->show_info(&mb, argv[optind]);
+		mdrestore.mdrops->show_info(header, argv[optind]);
 
 		if (argc - optind == 1)
 			exit(0);
@@ -341,12 +511,21 @@ main(
 
 	optind++;
 
-	/* check and open target */
-	dst_fd = open_device(argv[optind], &is_target_file);
+	/* check and open data device */
+	data_dev_fd = open_device(argv[optind], &is_data_dev_file);
+
+	log_dev_fd = -1;
+	if (logdev)
+		/* check and open log device */
+		log_dev_fd = open_device(logdev, &is_log_dev_file);
+
+	mdrestore.mdrops->restore(header, src_f, data_dev_fd, is_data_dev_file,
+				log_dev_fd, is_log_dev_file);
 
-	mdrestore.mdrops->restore(&mb, src_f, dst_fd, is_target_file);
+	close(data_dev_fd);
+	if (logdev)
+		close(log_dev_fd);
 
-	close(dst_fd);
 	if (src_f != stdin)
 		fclose(src_f);
 
-- 
2.39.1

