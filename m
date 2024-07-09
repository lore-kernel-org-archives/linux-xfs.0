Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE05C182A66
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jul 2024 19:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720552240; cv=none; b=fFa7T6G7cWTP3GGeuEAIyAGNZkdmLNlvWB18zsMBhD00UhBGhIau030y45+GD0j+WraRHABs4F6ei+Ub/oB2i8/QhWt3P7ESJlTMx49rvKdNSAEeewCyUCLVQmzsVFnmrbY5MJc7gvoACxF3KBgyzsQoSsoS1trEcvHkaVHu0bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720552240; c=relaxed/simple;
	bh=ehEm9I4nQlDJly+S0ymwSvkUuAGnob6VmXHrv/iYiNY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aQC3cEgphterYrDMIR1v7lVk7epFrExcZaSMEPcTdD2Gag/n+0O3tp4BJSgTnEYUSdzc4U/+8lxIFMY/M0BUb6nDB8cHi77IZdGYjb07itL7N+n8d7ZZUmPVRPhrtHu8ZO0LcDXhQxx1GaJylhdDiYpUD/1tsjUZeYmhyZv6BH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=izSAo157; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="izSAo157"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 469FtaPs005761
	for <linux-xfs@vger.kernel.org>; Tue, 9 Jul 2024 19:10:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=corp-2023-11-20; bh=3
	TZmsd36ctSHK3/VgqYPCTn9ThtuP4lWsO06N633U0w=; b=izSAo157u/A3UuFwd
	spSKHY7iYu8SHz8UlbDLVsjLomkzR8lTr7rJapx9Tr8a1wAHG74Yp1ABO7CIjzrE
	rk9arRldycc+NNNIh4172TAULy+ZX3lKQqGAW/Ac3M1zG7Ty8+FPnxr0tTok9WeN
	39ljsvYSfQXHmlOD2YaGRiSTtQ6BqBtbutGUHNW/hZvu955hAoRlUxFj8tHsaFV4
	y7lp45mU5RlyYpBcPxqPRGzwYsuS/StN7qLwCSxS4nR2/tLVv9tRlqPLdW2jwId/
	4tqzN/YekDGH3I57KRL3GEMrlrmNE2o4Es3Td/3OoeQaBX9Dv+4isYqKwUxMvLoc
	VPMsQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 407emsw4qv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 09 Jul 2024 19:10:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 469Hf1oA014442
	for <linux-xfs@vger.kernel.org>; Tue, 9 Jul 2024 19:10:37 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 407txhepsa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 09 Jul 2024 19:10:37 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 469JAUPe024440
	for <linux-xfs@vger.kernel.org>; Tue, 9 Jul 2024 19:10:36 GMT
Received: from wwg-mac.us.oracle.com (dhcp-10-159-146-188.vpn.oracle.com [10.159.146.188])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 407txhepkm-9;
	Tue, 09 Jul 2024 19:10:36 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: linux-xfs@vger.kernel.org
Cc: wen.gang.wang@oracle.com
Subject: [PATCH 8/9] spaceman/defrag: readahead for better performance
Date: Tue,  9 Jul 2024 12:10:27 -0700
Message-Id: <20240709191028.2329-9-wen.gang.wang@oracle.com>
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
X-Proofpoint-GUID: 2ZbAIpBVkUZWQWHToUr52CbIIxnRG-au
X-Proofpoint-ORIG-GUID: 2ZbAIpBVkUZWQWHToUr52CbIIxnRG-au

Reading ahead take less lock on file compared to "unshare" the file via ioctl.
Do readahead when defrag sleeps for better defrag performace and thus more
file IO time.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 spaceman/defrag.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/spaceman/defrag.c b/spaceman/defrag.c
index 415fe9c2..ab8508bb 100644
--- a/spaceman/defrag.c
+++ b/spaceman/defrag.c
@@ -331,6 +331,18 @@ defrag_fs_limit_hit(int fd)
 }
 
 static bool g_enable_first_ext_share = true;
+static bool g_readahead = false;
+
+static void defrag_readahead(int defrag_fd, off64_t offset, size_t count)
+{
+	if (!g_readahead || g_idle_time <= 0)
+		return;
+
+	if (readahead(defrag_fd, offset, count) < 0) {
+		fprintf(stderr, "readahead failed: %s, errno=%d\n",
+			strerror(errno), errno);
+	}
+}
 
 static int
 defrag_get_first_real_ext(int fd, struct getbmapx *mapx)
@@ -578,6 +590,8 @@ defrag_xfs_defrag(char *file_path) {
 
 		/* checks for EoF and fix up clone */
 		stop = defrag_clone_eof(&clone);
+		defrag_readahead(defrag_fd, seg_off, seg_size);
+
 		if (sleep_time_us > 0)
 			usleep(sleep_time_us);
 
@@ -698,6 +712,7 @@ static void defrag_help(void)
 " -i idle_time       -- time in ms to be idle between segments, 250ms by default\n"
 " -n                 -- disable the \"share first extent\" featue, it's\n"
 "                       enabled by default to speed up\n"
+" -a                 -- do readahead to speed up defrag, disabled by default\n"
 	));
 }
 
@@ -709,7 +724,7 @@ defrag_f(int argc, char **argv)
 	int	i;
 	int	c;
 
-	while ((c = getopt(argc, argv, "s:f:ni")) != EOF) {
+	while ((c = getopt(argc, argv, "s:f:nia")) != EOF) {
 		switch(c) {
 		case 's':
 			g_segment_size_lmt = atoi(optarg) * 1024 * 1024 / 512;
@@ -731,6 +746,10 @@ defrag_f(int argc, char **argv)
 			g_idle_time = atoi(optarg) * 1000;
 			break;
 
+		case 'a':
+			g_readahead = true;
+			break;
+
 		default:
 			command_usage(&defrag_cmd);
 			return 1;
-- 
2.39.3 (Apple Git-146)

