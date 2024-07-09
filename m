Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DEA182A6A
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jul 2024 19:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720552244; cv=none; b=qwAuzzcFhaphlGj9BHG5MXVJ64KiJI99y/gWVqSxxeTKv1UsaSpnU2eqY0+qH7YwWYH2kudPZOj1TUR8Emw1eRTeRtKeStxedUevt6waJzMxILPBmdnDehbAMYoFUw0eCGJjhho0hYjPluWq5D1Yk9cHXeepN0cl2xxbmqIOlFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720552244; c=relaxed/simple;
	bh=0dsngSlkU3j83pK459H65qI6O2WohWO7ui5rcbdTRAw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=t0A87DYIQfGYjAeM2Aut8ziLwvBispAh9CfCMz36RDaEcvXgKlxi3aDhF+mURgN2H6cLZ7nTNyclnpKpabgekvzQt5OMjlm0kO1RiONUHmZd6sRY+mO9JjkA0xbXHWjdE18OueDFT2SLjUP0h5Ldx5i5FsisF6rwISGvtF32vwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Bd+yM6tf; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Bd+yM6tf"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 469FtVNI027834
	for <linux-xfs@vger.kernel.org>; Tue, 9 Jul 2024 19:10:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=corp-2023-11-20; bh=D
	Fyxzp2jMdJNwUDCiZDRHdA8MTj1yAm7R/veI9G0X9s=; b=Bd+yM6tfYqtFoXZSi
	/GIBTCuJkw3Ui2AIv/NZ664eVSC6b81L3qI3On9ee9pD7JvIwiitn3dsW5VUcyOv
	rvsNRwKccArYyhPmWch11WzjkgeDw5F46gnpg1aTVO2DBKIFEv3uNQvZurWBqhFf
	1Lq34l95Ux4Fkpyva54RBM3WTZRwggfmHn6nJui+I+8Q09lO3c4RgUmS2/INuFE4
	2dJ2acxnqblNlbtxe9PQvVJyNwng2KQWXnBtgl+EEiaEc3sg2LACFAqJjH41S7iZ
	HWIDUCtQHNBeBKOwlYJ6Ug0ntIRKKEX32/1R2g02/E/103KRdu0L5jmS59tO4AN7
	lh8jQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 406xfsnsg4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 09 Jul 2024 19:10:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 469J6JB1013665
	for <linux-xfs@vger.kernel.org>; Tue, 9 Jul 2024 19:10:38 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 407txhept1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 09 Jul 2024 19:10:38 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 469JAUPg024440
	for <linux-xfs@vger.kernel.org>; Tue, 9 Jul 2024 19:10:37 GMT
Received: from wwg-mac.us.oracle.com (dhcp-10-159-146-188.vpn.oracle.com [10.159.146.188])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 407txhepkm-10;
	Tue, 09 Jul 2024 19:10:37 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: linux-xfs@vger.kernel.org
Cc: wen.gang.wang@oracle.com
Subject: [PATCH 9/9] spaceman/defrag: warn on extsize
Date: Tue,  9 Jul 2024 12:10:28 -0700
Message-Id: <20240709191028.2329-10-wen.gang.wang@oracle.com>
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
 mlxlogscore=833 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2407090129
X-Proofpoint-ORIG-GUID: tP4VAaza0L4jqioYOhfCBVbP0ckWhIQQ
X-Proofpoint-GUID: tP4VAaza0L4jqioYOhfCBVbP0ckWhIQQ

According to current kernel implemenation, non-zero extsize might affect
the result of defragmentation.
Just print a warning on that if non-zero extsize is set on file.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 spaceman/defrag.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/spaceman/defrag.c b/spaceman/defrag.c
index ab8508bb..b6b89dd9 100644
--- a/spaceman/defrag.c
+++ b/spaceman/defrag.c
@@ -526,6 +526,18 @@ defrag_xfs_defrag(char *file_path) {
 		goto out;
 	}
 
+       if (ioctl(defrag_fd, FS_IOC_FSGETXATTR, &fsx) < 0) {
+               fprintf(stderr, "FSGETXATTR failed %s\n",
+                       strerror(errno));
+               ret = 1;
+               goto out;
+       }
+
+       if (fsx.fsx_extsize != 0)
+               fprintf(stderr, "%s has extsize set %d. That might affect defrag "
+                       "according to kernel implementation\n",
+                       file_path, fsx.fsx_extsize);
+
 	clone.src_fd = defrag_fd;
 
 	defrag_dir = dirname(file_path);
-- 
2.39.3 (Apple Git-146)

