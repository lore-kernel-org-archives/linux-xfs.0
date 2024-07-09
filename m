Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08309182A4F
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jul 2024 19:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720552239; cv=none; b=IBl5Ixhe0QJiXQ2Q256f7Ykn5OAZWjtzRdyT7z3gAVMWAJfs0mNiyMy2KRS897Gdu1A2pNqPIbdDTKq5cVFvA15mT7J8LnPuvQlbH/gVjVwnJ0WRokKfuOn9gNj5IT2j0H7RPt6WT3kexj/HEfRgUUVO+0rJoO1Z8BbIu4tovns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720552239; c=relaxed/simple;
	bh=dePsrq2fmZK09Ey35ANhhuTru+k/5JjGv0XRUhRs5js=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RFifVkMY/P4FqJxUNcsZBxiF0Bqd33nVSwp5J9E+XeGBmvfT795dd8/QTv4ERdPW7UBQ4eS3gqvkarG4RcNb7aWOt8JnAGpHd6+RDJfWKVRwZkTat3P+rL6mzOOT9Db81MBp5BRIbh42P7EzN6VS+CKTqR4ps6nJqRLjfL85fdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Z4lpzmca; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Z4lpzmca"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 469Fta9t031057
	for <linux-xfs@vger.kernel.org>; Tue, 9 Jul 2024 19:10:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=corp-2023-11-20; bh=r
	jgPPTfJNj2JOGyAEHszdU1xzx289N8m+gLdBdmHb5A=; b=Z4lpzmca5ZMMp4cz7
	dUXZCNPiq+lk3FX1+vb8Ynz3+YAP1Zf2o2yPFQSo8XWr4TLcZopKS2iRPU0BFGDQ
	jeHlUdospno2McOkvQIa5Q0YuSXLE+XM+rthsSX9jpCWhdbEPLscQIuEXJAx4xSZ
	5DBvedenkCZBB20LftrizL+Hh/UHi7PAUmVikdg9BEM4Mp/Fr/tb/+iRmDAh+4SQ
	zAUzRYOe7Ic0shr1lffLi8Mo9jgXjPcCxbgqe3hw7dB9GY2FTyduwPYS5ugFVkx/
	+ICU8NDeb33DQEdym3GEJmXn2fVwf3UZ9hvnrlB4FtpBlplhNcsTGlUFuG5snCss
	BsUpQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 406wky5tmj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 09 Jul 2024 19:10:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 469IDThQ014345
	for <linux-xfs@vger.kernel.org>; Tue, 9 Jul 2024 19:10:35 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 407txhepr2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 09 Jul 2024 19:10:35 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 469JAUPa024440
	for <linux-xfs@vger.kernel.org>; Tue, 9 Jul 2024 19:10:35 GMT
Received: from wwg-mac.us.oracle.com (dhcp-10-159-146-188.vpn.oracle.com [10.159.146.188])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 407txhepkm-7;
	Tue, 09 Jul 2024 19:10:35 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: linux-xfs@vger.kernel.org
Cc: wen.gang.wang@oracle.com
Subject: [PATCH 6/9] spaceman/defrag: workaround kernel xfs_reflink_try_clear_inode_flag()
Date: Tue,  9 Jul 2024 12:10:25 -0700
Message-Id: <20240709191028.2329-7-wen.gang.wang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20240709191028.2329-1-wen.gang.wang@oracle.com>
References: <20240709191028.2329-1-wen.gang.wang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-09_08,2024-07-09_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2407090129
X-Proofpoint-ORIG-GUID: a5_beDO4pSJ2mirs93ekUhp2qxuUGPpG
X-Proofpoint-GUID: a5_beDO4pSJ2mirs93ekUhp2qxuUGPpG

xfs_reflink_try_clear_inode_flag() takes very long in case file has huge number
of extents and none of the extents are shared.

workaround:
share the first real extent so that xfs_reflink_try_clear_inode_flag() returns
quickly to save cpu times and speed up defrag significantly.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 spaceman/defrag.c | 174 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 172 insertions(+), 2 deletions(-)

diff --git a/spaceman/defrag.c b/spaceman/defrag.c
index f8e6713c..b5c5b187 100644
--- a/spaceman/defrag.c
+++ b/spaceman/defrag.c
@@ -327,6 +327,155 @@ defrag_fs_limit_hit(int fd)
 	return statfs_s.f_bsize * statfs_s.f_bavail < g_limit_free_bytes;
 }
 
+static bool g_enable_first_ext_share = true;
+
+static int
+defrag_get_first_real_ext(int fd, struct getbmapx *mapx)
+{
+	int			err;
+
+	while (1) {
+		err = defrag_get_next_extent(fd, mapx);
+		if (err)
+			break;
+
+		defrag_move_next_extent();
+		if (!(mapx->bmv_oflags & BMV_OF_PREALLOC))
+			break;
+	}
+	return err;
+}
+
+static __u64 g_share_offset = -1ULL;
+static __u64 g_share_len = 0ULL;
+#define SHARE_MAX_SIZE 32768  /* 32KiB */
+
+/* share the first real extent with scrach */
+static void
+defrag_share_first_extent(int defrag_fd, int scratch_fd)
+{
+#define OFFSET_1PB 0x4000000000000LL
+	struct file_clone_range clone;
+	struct getbmapx mapx;
+	int	err;
+
+	if (g_enable_first_ext_share == false)
+		return;
+
+	err = defrag_get_first_real_ext(defrag_fd, &mapx);
+	if (err)
+		return;
+
+	clone.src_fd = defrag_fd;
+	clone.src_offset = mapx.bmv_offset * 512;
+	clone.src_length = mapx.bmv_length * 512;
+	/* shares at most SHARE_MAX_SIZE length */
+	if (clone.src_length > SHARE_MAX_SIZE)
+		clone.src_length = SHARE_MAX_SIZE;
+	clone.dest_offset = OFFSET_1PB + clone.src_offset;
+	/* if the first is extent is reaching the EoF, no need to share */
+	if (clone.src_offset + clone.src_length >= g_defrag_file_size)
+		return;
+	err = ioctl(scratch_fd, FICLONERANGE, &clone);
+	if (err != 0) {
+		fprintf(stderr, "cloning first extent failed: %s\n",
+			strerror(errno));
+		return;
+	}
+
+	/* safe the offset and length for re-share */
+	g_share_offset = clone.src_offset;
+	g_share_len = clone.src_length;
+}
+
+/* re-share the blocks we shared previous if then are no longer shared */
+static void
+defrag_reshare_blocks_in_front(int defrag_fd, int scratch_fd)
+{
+#define NR_GET_EXT 9
+	struct getbmapx mapx[NR_GET_EXT];
+	struct file_clone_range clone;
+	__u64	new_share_len;
+	int	idx, err;
+
+	if (g_enable_first_ext_share == false)
+		return;
+
+	if (g_share_len == 0ULL)
+		return;
+
+	/*
+	 * check if previous shareing still exist
+	 * we are done if (partially) so.
+	 */
+	mapx[0].bmv_offset = g_share_offset;
+	mapx[0].bmv_length = g_share_len;
+	mapx[0].bmv_count = NR_GET_EXT;
+	mapx[0].bmv_iflags = BMV_IF_NO_HOLES | BMV_IF_PREALLOC;
+	err = ioctl(defrag_fd, XFS_IOC_GETBMAPX, mapx);
+	if (err) {
+		fprintf(stderr, "XFS_IOC_GETBMAPX failed %s\n",
+			strerror(errno));
+		/* won't try share again */
+		g_share_len = 0ULL;
+		return;
+	}
+
+	if (mapx[0].bmv_entries == 0) {
+		/* shared blocks all became hole, won't try share again */
+		g_share_len = 0ULL;
+		return;
+	}
+
+	if (g_share_offset != 512 * mapx[1].bmv_offset) {
+		/* first shared block became hole, won't try share again */
+		g_share_len = 0ULL;
+		return;
+	}
+
+	/* we check up to only the first NR_GET_EXT - 1 extents */
+	for (idx = 1; idx <= mapx[0].bmv_entries; idx++) {
+		if (mapx[idx].bmv_oflags & BMV_OF_SHARED) {
+			/* some blocks still shared, done */
+			return;
+		}
+	}
+
+	/*
+	 * The previously shared blocks are no longer shared, re-share.
+	 * deallocate the blocks in scrath file first
+	 */
+	err = fallocate(scratch_fd,
+		FALLOC_FL_PUNCH_HOLE|FALLOC_FL_KEEP_SIZE,
+		OFFSET_1PB + g_share_offset, g_share_len);
+	if (err != 0) {
+		fprintf(stderr, "punch hole failed %s\n",
+			strerror(errno));
+		g_share_len = 0;
+		return;
+	}
+
+	new_share_len = 512 * mapx[1].bmv_length;
+	if (new_share_len > SHARE_MAX_SIZE)
+		new_share_len = SHARE_MAX_SIZE;
+
+	clone.src_fd = defrag_fd;
+	/* keep starting offset unchanged */
+	clone.src_offset = g_share_offset;
+	clone.src_length = new_share_len;
+	clone.dest_offset = OFFSET_1PB + clone.src_offset;
+
+	err = ioctl(scratch_fd, FICLONERANGE, &clone);
+	if (err) {
+		fprintf(stderr, "FICLONERANGE failed %s\n",
+			strerror(errno));
+		g_share_len = 0;
+		return;
+	}
+
+	g_share_len = new_share_len;
+ }
+
 /*
  * defragment a file
  * return 0 if successfully done, 1 otherwise
@@ -377,6 +526,12 @@ defrag_xfs_defrag(char *file_path) {
 
 	signal(SIGINT, defrag_sigint_handler);
 
+	/*
+	 * share the first extent to work around kernel consuming time
+	 * in xfs_reflink_try_clear_inode_flag()
+	 */
+	defrag_share_first_extent(defrag_fd, scratch_fd);
+
 	do {
 		struct timeval t_clone, t_unshare, t_punch_hole;
 		struct defrag_segment segment;
@@ -454,6 +609,15 @@ defrag_xfs_defrag(char *file_path) {
 		if (time_delta > max_unshare_us)
 			max_unshare_us = time_delta;
 
+		/*
+		 * if unshare used more than 1 second, time is very possibly
+		 * used in checking if the file is sharing extents now.
+		 * to avoid that happen again we re-share the blocks in front
+		 * to workaround that.
+		 */
+		if (time_delta > 1000000)
+			defrag_reshare_blocks_in_front(defrag_fd, scratch_fd);
+
 		/*
 		 * Punch out the original extents we shared to the
 		 * scratch file so they are returned to free space.
@@ -514,6 +678,8 @@ static void defrag_help(void)
 " -f free_space      -- specify shrethod of the XFS free space in MiB, when\n"
 "                       XFS free space is lower than that, shared segments \n"
 "                       are excluded from defragmentation, 1024 by default\n"
+" -n                 -- disable the \"share first extent\" featue, it's\n"
+"                       enabled by default to speed up\n"
 	));
 }
 
@@ -525,7 +691,7 @@ defrag_f(int argc, char **argv)
 	int	i;
 	int	c;
 
-	while ((c = getopt(argc, argv, "s:f:")) != EOF) {
+	while ((c = getopt(argc, argv, "s:f:n")) != EOF) {
 		switch(c) {
 		case 's':
 			g_segment_size_lmt = atoi(optarg) * 1024 * 1024 / 512;
@@ -539,6 +705,10 @@ defrag_f(int argc, char **argv)
 			g_limit_free_bytes = atol(optarg) * 1024 * 1024;
 			break;
 
+		case 'n':
+			g_enable_first_ext_share = false;
+			break;
+
 		default:
 			command_usage(&defrag_cmd);
 			return 1;
@@ -556,7 +726,7 @@ void defrag_init(void)
 	defrag_cmd.cfunc	= defrag_f;
 	defrag_cmd.argmin	= 0;
 	defrag_cmd.argmax	= 4;
-	defrag_cmd.args		= "[-s segment_size] [-f free_space]";
+	defrag_cmd.args		= "[-s segment_size] [-f free_space] [-n]";
 	defrag_cmd.flags	= CMD_FLAG_ONESHOT;
 	defrag_cmd.oneline	= _("Defragment XFS files");
 	defrag_cmd.help		= defrag_help;
-- 
2.39.3 (Apple Git-146)

