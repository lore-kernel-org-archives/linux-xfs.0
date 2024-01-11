Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9579C15CA
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jan 2024 17:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="B8zUHNt2"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40BGmvWm017262
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jan 2024 17:40:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2023-11-20; bh=fsHtmJKDdm4L+iidbzoWjYg10vV0HAjp5bh/Myw1YOo=;
 b=B8zUHNt2/odlhH0o+eb07BwDKt8u7LMv6SrlJrYYSXInE/E5afLUZ28BUFWXZS/kCRFH
 uMYgE83acdviyEXha/b48iFbVdkWyMnXzxuILeb6xCM2ezEhA7zoho2aL2np2lADySve
 iI8TT9pQyPtIPRxrXo98wMId32ZU0OrZ9w7zDp70RgZ8VAEBt6/zCROW4tATRx/Q2IU+
 sU+ch+fRYegDSRzLbgTURuFBJEho72BS37DR4w6i37sMdqb8qB601YewJy2XBW09mXNq
 yRTpf1An2tCG2lIx47iSRDpYAF/CPdY2sNyDFnkKcVWCewh/AE+mRh8AyvIFxGMxRLYK fQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vjcbkh7mk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jan 2024 17:40:15 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40BH9hMM035903
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jan 2024 17:40:14 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vfuu80mmn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jan 2024 17:40:14 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40BHeEQG033587
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jan 2024 17:40:14 GMT
Received: from wwg-mac.us.oracle.com (dhcp-10-159-138-212.vpn.oracle.com [10.159.138.212])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3vfuu80mkd-1;
	Thu, 11 Jan 2024 17:40:14 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: linux-xfs@vger.kernel.org
Cc: wen.gang.wang@oracle.com
Subject: [PATCH 2/2] xfsprogs: modify spaceman man page for defrag
Date: Thu, 11 Jan 2024 09:40:13 -0800
Message-Id: <20240111174013.50501-1-wen.gang.wang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-145)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-11_09,2024-01-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=993 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401110139
X-Proofpoint-ORIG-GUID: 5dEX_CANDil5BrkkShPPGRL75yQDABlA
X-Proofpoint-GUID: 5dEX_CANDil5BrkkShPPGRL75yQDABlA

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 man/man8/xfs_spaceman.8 | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/man/man8/xfs_spaceman.8 b/man/man8/xfs_spaceman.8
index ece840d7..87324f21 100644
--- a/man/man8/xfs_spaceman.8
+++ b/man/man8/xfs_spaceman.8
@@ -24,6 +24,28 @@ arguments may be given. The commands are run in the sequence given,
 then the program exits.
 
 .SH COMMANDS
+.TP
+.BI "defrag [-i interval] [-e nr_ext]"
+.B defrag
+defragments the specified XFS file. It requires
+.B reflink
+feature enabled in the file system.
+This command defragments the file segment by segment. In the betweens of segments, file reads/writes are served in parallel.
+The command takes the following options:
+.RS 1.0i
+.PD 0
+.TP 0.4i
+.B \-i interval
+The time in ms to sleep between defragmenting two segments in the file. This is used to balance defragmenting and file IOs. The default value is 0.
+
+.TP
+.B \-e nr_ext
+Specifies the number of extents in segment, only the segments with more extents than
+.B nr_ext
+are defragmenting targets. Properly setting this value bigger can defragment the most fragmented parts of the file in shorter time. The default value is 1.
+.PD
+.RE
+
 .TP
 .BI "freesp [ \-dgrs ] [-a agno]... [ \-b | \-e bsize | \-h bsize | \-m factor ]"
 With no arguments,
-- 
2.39.3 (Apple Git-145)

