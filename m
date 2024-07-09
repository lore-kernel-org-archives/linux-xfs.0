Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60491DFCF
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jul 2024 19:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720552238; cv=none; b=ZCCJRatysIhwtX4b4KlxabsVrrTClmFP0oh266S1XYvT8TnJhRnsgCjsHLqaYMJpSOPYrsXGYWhziTa6orWNPv4aMs+UXQ12qvTJB7CxIuUROcbRlt3viFQQzYYPOTgkUmYoQ96xzf4YUhOlYWFMO2u5JEWlM4hB1k3++07UwRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720552238; c=relaxed/simple;
	bh=I6q0X+FkzCRRcGbSML6QjVbmtow8kfix+hIZpgsNF84=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GyYIaKJ2/cydz6YdxcDSBgeyxkDTRXteRruLuhK3T01IG2ebgD9S2XFrWKRmgJLCbgqAwVYg/5rvqvkXIjatVq9otUaYBvD7MHr4ZYuEPGGzd/4OEDfYyh+4Y0HI5n9dxHQ/H5UXnyLJKEujEcEVBSZaATM2n7c5BpzMi/tIxYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ot6u4eYd; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ot6u4eYd"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 469FtXdx007676
	for <linux-xfs@vger.kernel.org>; Tue, 9 Jul 2024 19:10:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=corp-2023-11-20; bh=9
	jSEX+0XdpBeyyiD1IqAqe6jqB3Xfd7ggL7jODDEOwk=; b=ot6u4eYdytAiN1YXX
	EIUizTQC8OgmJO1D0FE74FYyj+3D5Spo+3ZRlblmGNFlLwNXD1E+SHBaFghwhrPP
	8CQSnKGHNOqrEe2p+o0WZjOCA40naKCO/SEogJ7N2oPj0TFPNXIGVa7JyBPtsErO
	tkTXecQcxoAkav4HXWde4u1QVKR2241WrWL+c3zN88nYVid+Q+HqBGVzZpLZiIOn
	ciz+el3q+Q3NPFDN/n2aGrLd5Z2tXS0UatXtfMfERakppLRaboxslN7cv1PFAWba
	SNEymrIuG5Y7AJubUq8XLPlQ4t8iPaFIwys+uLdLqGubFlXen+ErsZ+MjjyeP9Va
	J34Tw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 406wgpwsrq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 09 Jul 2024 19:10:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 469IbRn7013648
	for <linux-xfs@vger.kernel.org>; Tue, 9 Jul 2024 19:10:34 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 407txhepqb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 09 Jul 2024 19:10:34 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 469JAUPY024440
	for <linux-xfs@vger.kernel.org>; Tue, 9 Jul 2024 19:10:34 GMT
Received: from wwg-mac.us.oracle.com (dhcp-10-159-146-188.vpn.oracle.com [10.159.146.188])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 407txhepkm-6;
	Tue, 09 Jul 2024 19:10:34 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: linux-xfs@vger.kernel.org
Cc: wen.gang.wang@oracle.com
Subject: [PATCH 5/9] spaceman/defrag: exclude shared segments on low free space
Date: Tue,  9 Jul 2024 12:10:24 -0700
Message-Id: <20240709191028.2329-6-wen.gang.wang@oracle.com>
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
X-Proofpoint-ORIG-GUID: B_LsGquCZCiDTAMU2uCgYITbb5ec8d87
X-Proofpoint-GUID: B_LsGquCZCiDTAMU2uCgYITbb5ec8d87

On some XFS, free blocks are over-committed to reflink copies.
And those free blocks are not enough if CoW happens to all the shared blocks.

This defrag tool would exclude shared segments when free space is under shrethold.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 spaceman/defrag.c | 46 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 43 insertions(+), 3 deletions(-)

diff --git a/spaceman/defrag.c b/spaceman/defrag.c
index 61e47a43..f8e6713c 100644
--- a/spaceman/defrag.c
+++ b/spaceman/defrag.c
@@ -304,6 +304,29 @@ void defrag_sigint_handler(int dummy)
 	printf("Please wait until current segment is defragmented\n");
 };
 
+/*
+ * limitation of filesystem free space in bytes.
+ * when filesystem has less free space than this number, segments which contain
+ * shared extents are skipped. 1GiB by default
+ */
+static long	g_limit_free_bytes = 1024 * 1024 * 1024;
+
+/*
+ * check if the free space in the FS is less than the _limit_
+ * return true if so, false otherwise
+ */
+static bool
+defrag_fs_limit_hit(int fd)
+{
+	struct statfs statfs_s;
+
+	if (g_limit_free_bytes <= 0)
+		return false;
+
+	fstatfs(fd, &statfs_s);
+	return statfs_s.f_bsize * statfs_s.f_bavail < g_limit_free_bytes;
+}
+
 /*
  * defragment a file
  * return 0 if successfully done, 1 otherwise
@@ -377,6 +400,15 @@ defrag_xfs_defrag(char *file_path) {
 		if (segment.ds_nr < 2)
 			continue;
 
+		/*
+		 * When the segment is (partially) shared, defrag would
+		 * consume free blocks. We check the limit of FS free blocks
+		 * and skip defragmenting this segment in case the limit is
+		 * reached.
+		 */
+		if (segment.ds_shared && defrag_fs_limit_hit(defrag_fd))
+			continue;
+
 		/* to bytes */
 		seg_off = segment.ds_offset * 512;
 		seg_size = segment.ds_length * 512;
@@ -478,7 +510,11 @@ static void defrag_help(void)
 "can be served durning the defragmentations.\n"
 "\n"
 " -s segment_size    -- specify the segment size in MiB, minmum value is 4 \n"
-"                       default is 16\n"));
+"                       default is 16\n"
+" -f free_space      -- specify shrethod of the XFS free space in MiB, when\n"
+"                       XFS free space is lower than that, shared segments \n"
+"                       are excluded from defragmentation, 1024 by default\n"
+	));
 }
 
 static cmdinfo_t defrag_cmd;
@@ -489,7 +525,7 @@ defrag_f(int argc, char **argv)
 	int	i;
 	int	c;
 
-	while ((c = getopt(argc, argv, "s:")) != EOF) {
+	while ((c = getopt(argc, argv, "s:f:")) != EOF) {
 		switch(c) {
 		case 's':
 			g_segment_size_lmt = atoi(optarg) * 1024 * 1024 / 512;
@@ -499,6 +535,10 @@ defrag_f(int argc, char **argv)
 					g_segment_size_lmt);
 			}
 			break;
+		case 'f':
+			g_limit_free_bytes = atol(optarg) * 1024 * 1024;
+			break;
+
 		default:
 			command_usage(&defrag_cmd);
 			return 1;
@@ -516,7 +556,7 @@ void defrag_init(void)
 	defrag_cmd.cfunc	= defrag_f;
 	defrag_cmd.argmin	= 0;
 	defrag_cmd.argmax	= 4;
-	defrag_cmd.args		= "[-s segment_size]";
+	defrag_cmd.args		= "[-s segment_size] [-f free_space]";
 	defrag_cmd.flags	= CMD_FLAG_ONESHOT;
 	defrag_cmd.oneline	= _("Defragment XFS files");
 	defrag_cmd.help		= defrag_help;
-- 
2.39.3 (Apple Git-146)

