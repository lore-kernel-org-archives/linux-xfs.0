Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59D3182A4F
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jul 2024 19:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720552237; cv=none; b=Kwp3MxqagB1FGurQOdfuzMmBlQkLjxgWi+DHhTU+nn4aHOk/U19aB2QUdMAVUyHYfSBzDP/V8UbLQRN2eHZdjjnxpvjGQLrIb35vel5U1e9xKzYqLAw/2GoU2SHw9TRtshPSNx5wilkiWGIM0XRXRB9pPXp7O64A9zl2XZyZXvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720552237; c=relaxed/simple;
	bh=FNzmH1f5m/6EBRbYEzn81FQYR4LBtc7MLcFXBYilf5s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QtEI4vpEY8h5Av2OwMHWWH26iwfnoER1ufcE6h8QQ55SdbcGUwoUqYKG4ibov6kipr4ygWZEFoiwjT64eKzLffB1G91J3NBJEu+fgl1DcUz5mfPpDaiY3V+dO5GpRIIqqgb3PPI56o+YvknsEGcg3qLOr2nfdF7FvjC3ocLlZzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CSw1+kTl; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CSw1+kTl"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 469FtaRI014970
	for <linux-xfs@vger.kernel.org>; Tue, 9 Jul 2024 19:10:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=corp-2023-11-20; bh=f
	QmaLNv8ODP5SlOT32W+TB7caAFosKkm11a4RV196gw=; b=CSw1+kTlCTlMKCraj
	VH/eVN1APFt0LovZMG+7CYUDxAeYbNXXTZSqkcKiqfU9otLbHLmqbSN2rNmC41Dk
	ySLt7Lw2Bbid9ZOD1j14CGZkpoA1MSnBOA0B9d3+hOhICAvhFNYRRBgA+n08KQzn
	rAdVAdYt2+yKU5US9qy7g7ZejMm78/N9Sno9q689I4pOt2NLlL1g0pMjvBjxsOuv
	uAE8d7XJod0JwFp9V9RskHjQT+unVMJWsDwVMz13yvPtjGRe18pSh2Qo6SVUyNsp
	BeJrEQ3N7pypIKD+ZYhFPSx3QWJD4qJH4cscLwuUCNHrEhVaWBB5CqAbT23tyG+W
	LlOlA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 406wt8dq2j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 09 Jul 2024 19:10:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 469IDmWJ014129
	for <linux-xfs@vger.kernel.org>; Tue, 9 Jul 2024 19:10:33 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 407txhepph-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 09 Jul 2024 19:10:33 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 469JAUPW024440
	for <linux-xfs@vger.kernel.org>; Tue, 9 Jul 2024 19:10:33 GMT
Received: from wwg-mac.us.oracle.com (dhcp-10-159-146-188.vpn.oracle.com [10.159.146.188])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 407txhepkm-5;
	Tue, 09 Jul 2024 19:10:32 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: linux-xfs@vger.kernel.org
Cc: wen.gang.wang@oracle.com
Subject: [PATCH 4/9] spaceman/defrag: ctrl-c handler
Date: Tue,  9 Jul 2024 12:10:23 -0700
Message-Id: <20240709191028.2329-5-wen.gang.wang@oracle.com>
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
X-Proofpoint-GUID: GPyls3ljBARhBd3FVKM4tu0tgydYOYf8
X-Proofpoint-ORIG-GUID: GPyls3ljBARhBd3FVKM4tu0tgydYOYf8

Add this handler to break the defrag better, so it has
1. the stats reporting
2. remove the temporary file

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 spaceman/defrag.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/spaceman/defrag.c b/spaceman/defrag.c
index 9f11e36b..61e47a43 100644
--- a/spaceman/defrag.c
+++ b/spaceman/defrag.c
@@ -297,6 +297,13 @@ get_time_delta_us(struct timeval *pre_time, struct timeval *cur_time)
 	return us;
 }
 
+static volatile bool usedKilled = false;
+void defrag_sigint_handler(int dummy)
+{
+	usedKilled = true;
+	printf("Please wait until current segment is defragmented\n");
+};
+
 /*
  * defragment a file
  * return 0 if successfully done, 1 otherwise
@@ -345,6 +352,8 @@ defrag_xfs_defrag(char *file_path) {
 		goto out;
 	}
 
+	signal(SIGINT, defrag_sigint_handler);
+
 	do {
 		struct timeval t_clone, t_unshare, t_punch_hole;
 		struct defrag_segment segment;
@@ -434,7 +443,7 @@ defrag_xfs_defrag(char *file_path) {
 		if (time_delta > max_punch_us)
 			max_punch_us = time_delta;
 
-		if (stop)
+		if (stop || usedKilled)
 			break;
 	} while (true);
 out:
-- 
2.39.3 (Apple Git-146)

