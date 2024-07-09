Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42352182A52
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jul 2024 19:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720552239; cv=none; b=Jv9kI+qDN/MKJ1nGUsrIIBQi5pXxpfv1COdOEgny75hVVMyRS8dsDfIwLMXcQ5/nDBLUmS9YiNFyUAAn24r3bTWjGONH8y6Q+CPrFiXCTT1xswxqdS1jCzDwyW1z7856BWcR4Vke1Gc6m6Pa1d7RyaNnnzew0HDGLTV+pbJb4rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720552239; c=relaxed/simple;
	bh=jNdSGNnxYVWlWWVZ3VlOxE93Yy+DgiQM9jMw/bRqNTs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YvZ1z2crdIxAbIWGxTVDAv1rwe13x6BEmGMkYpSBsy82HEg9hI984bONfe+yhJZ3VeIBjQmX8HQbjn2yKZ66qxKiO3p8GMTITqP4oGyI9oEifiCfhnphv2DzE6m/xX0iWdMjcl0asPen65iwa/+glR18jwqc/peJU8krVOyfg68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KkoNe+F6; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KkoNe+F6"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 469FtUUL003165
	for <linux-xfs@vger.kernel.org>; Tue, 9 Jul 2024 19:10:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=corp-2023-11-20; bh=f
	mltrwphEUrMVDHzYN30wxGU+PQbTJKuwsnCJxCwTOo=; b=KkoNe+F6QSqtFN/lB
	2H987r3DclC+BWQTVn92m1uRMWM5rTStgPOJW+YOgCqinPlRe8eTidec4FokF83o
	rz2NTcTKAudHfPXYiiJPR05aBjnR+oQ/8boQCAkumV0QcNOBsb/vpDv5B90KtHod
	t2/a1JMCuC6ymKeb7P4atmQ4MKzjdcJHGRbzDwuVpFM7klzrUbKvsOlx8kXoYOVZ
	lf8YFCH4SkSj4u9GBKZ1UmMDldZl58ewuNzfwHPTb5a81Em50NmN7p/yXox8kU/V
	u6h5ZIVXH9iO2wNXwj6FyTEN6yI+zVveXKxANCFkHr6TR6Ci+EAySU2WfOYshkxC
	Pa/SQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 406wknnsas-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 09 Jul 2024 19:10:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 469IIwoA014343
	for <linux-xfs@vger.kernel.org>; Tue, 9 Jul 2024 19:10:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 407txheprp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 09 Jul 2024 19:10:36 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 469JAUPc024440
	for <linux-xfs@vger.kernel.org>; Tue, 9 Jul 2024 19:10:36 GMT
Received: from wwg-mac.us.oracle.com (dhcp-10-159-146-188.vpn.oracle.com [10.159.146.188])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 407txhepkm-8;
	Tue, 09 Jul 2024 19:10:35 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: linux-xfs@vger.kernel.org
Cc: wen.gang.wang@oracle.com
Subject: [PATCH 7/9] spaceman/defrag: sleeps between segments
Date: Tue,  9 Jul 2024 12:10:26 -0700
Message-Id: <20240709191028.2329-8-wen.gang.wang@oracle.com>
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
X-Proofpoint-GUID: 1m7Jffp0XgCCCf5aEWUdoDXVx2JilUU_
X-Proofpoint-ORIG-GUID: 1m7Jffp0XgCCCf5aEWUdoDXVx2JilUU_

Let user contol the time to sleep between segments (file unlocked) to
balance defrag performance and file IO servicing time.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 spaceman/defrag.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/spaceman/defrag.c b/spaceman/defrag.c
index b5c5b187..415fe9c2 100644
--- a/spaceman/defrag.c
+++ b/spaceman/defrag.c
@@ -311,6 +311,9 @@ void defrag_sigint_handler(int dummy)
  */
 static long	g_limit_free_bytes = 1024 * 1024 * 1024;
 
+/* sleep time in us between segments, overwritten by paramter */
+static int		g_idle_time = 250 * 1000;
+
 /*
  * check if the free space in the FS is less than the _limit_
  * return true if so, false otherwise
@@ -487,6 +490,7 @@ defrag_xfs_defrag(char *file_path) {
 	int	scratch_fd = -1, defrag_fd = -1;
 	char	tmp_file_path[PATH_MAX+1];
 	struct file_clone_range clone;
+	int	sleep_time_us = 0;
 	char	*defrag_dir;
 	struct fsxattr	fsx;
 	int	ret = 0;
@@ -574,6 +578,9 @@ defrag_xfs_defrag(char *file_path) {
 
 		/* checks for EoF and fix up clone */
 		stop = defrag_clone_eof(&clone);
+		if (sleep_time_us > 0)
+			usleep(sleep_time_us);
+
 		gettimeofday(&t_clone, NULL);
 		ret = ioctl(scratch_fd, FICLONERANGE, &clone);
 		if (ret != 0) {
@@ -587,6 +594,10 @@ defrag_xfs_defrag(char *file_path) {
 		if (time_delta > max_clone_us)
 			max_clone_us = time_delta;
 
+		/* sleeps if clone cost more than 500ms, slow FS */
+		if (time_delta >= 500000 && g_idle_time > 0)
+			usleep(g_idle_time);
+
 		/* for defrag stats */
 		nr_ext_defrag += segment.ds_nr;
 
@@ -641,6 +652,12 @@ defrag_xfs_defrag(char *file_path) {
 
 		if (stop || usedKilled)
 			break;
+
+		/*
+		 * no lock on target file when punching hole from scratch file,
+		 * so minus the time used for punching hole
+		 */
+		sleep_time_us = g_idle_time - time_delta;
 	} while (true);
 out:
 	if (scratch_fd != -1) {
@@ -678,6 +695,7 @@ static void defrag_help(void)
 " -f free_space      -- specify shrethod of the XFS free space in MiB, when\n"
 "                       XFS free space is lower than that, shared segments \n"
 "                       are excluded from defragmentation, 1024 by default\n"
+" -i idle_time       -- time in ms to be idle between segments, 250ms by default\n"
 " -n                 -- disable the \"share first extent\" featue, it's\n"
 "                       enabled by default to speed up\n"
 	));
@@ -691,7 +709,7 @@ defrag_f(int argc, char **argv)
 	int	i;
 	int	c;
 
-	while ((c = getopt(argc, argv, "s:f:n")) != EOF) {
+	while ((c = getopt(argc, argv, "s:f:ni")) != EOF) {
 		switch(c) {
 		case 's':
 			g_segment_size_lmt = atoi(optarg) * 1024 * 1024 / 512;
@@ -709,6 +727,10 @@ defrag_f(int argc, char **argv)
 			g_enable_first_ext_share = false;
 			break;
 
+		case 'i':
+			g_idle_time = atoi(optarg) * 1000;
+			break;
+
 		default:
 			command_usage(&defrag_cmd);
 			return 1;
@@ -726,7 +748,7 @@ void defrag_init(void)
 	defrag_cmd.cfunc	= defrag_f;
 	defrag_cmd.argmin	= 0;
 	defrag_cmd.argmax	= 4;
-	defrag_cmd.args		= "[-s segment_size] [-f free_space] [-n]";
+	defrag_cmd.args		= "[-s segment_size] [-f free_space] [-i idle_time] [-n]";
 	defrag_cmd.flags	= CMD_FLAG_ONESHOT;
 	defrag_cmd.oneline	= _("Defragment XFS files");
 	defrag_cmd.help		= defrag_help;
-- 
2.39.3 (Apple Git-146)

