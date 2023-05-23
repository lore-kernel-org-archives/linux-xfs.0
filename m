Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF28BC7EE23
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 09:01:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236264AbjEWJBY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 05:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236241AbjEWJBU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 05:01:20 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF2D109
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 02:01:19 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34N6Emb3031422;
        Tue, 23 May 2023 09:01:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=E3kt5PJ/E5m7tyz+3l8qR0zaYihD6MltzUPUtcZ3kGs=;
 b=y0bNaqvptAQ/REqDgQrCodUQ3ZpWIljfJOdd5kdtGYKLYx9AF9Je0IdQtfueVeMofQC+
 wURn/mwW3XAYurY24dBLqTxfUsJvcZmljt/9TZbYndXeRKQap+cnKeuDIJElQnXuG3fI
 Oh+zkcMmZm+P29hX+/QltzW/AVWUTUIDJw+G8wqTgIWw+ygwQIhvZjOwTDEs6dtHAVBp
 PILMBk31wCMaUip9Q67XP7EdfrLtTedCE3wZhc2jO+GOIPsNlSNdJeXkNGFu14OvKsx6
 Xad6WNlAx4r0Zc6zY8+OQEs8+Kpg0K2TD7inKwqoirwHamRFLbjOn63DFVyMRll8Fy9/ Tg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qpp3mmn3t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 09:01:17 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34N8Yj96029074;
        Tue, 23 May 2023 09:01:16 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk2aj7mh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 09:01:16 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34N8xwrr007681;
        Tue, 23 May 2023 09:01:16 GMT
Received: from chanbabu-fstest.osdevelopmeniad.oraclevcn.com (chanbabu-fstesting.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.250.50])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3qqk2aj76a-16;
        Tue, 23 May 2023 09:01:16 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     cem@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: [PATCH 15/24] xfs_metadump.8: Add description for the newly introduced -v option
Date:   Tue, 23 May 2023 14:30:41 +0530
Message-Id: <20230523090050.373545-16-chandan.babu@oracle.com>
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
X-Proofpoint-ORIG-GUID: LqehGBj-8i9prZTgm4rS31IOHIhydtDI
X-Proofpoint-GUID: LqehGBj-8i9prZTgm4rS31IOHIhydtDI
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 man/man8/xfs_metadump.8 | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/man/man8/xfs_metadump.8 b/man/man8/xfs_metadump.8
index c0e79d779..23695c768 100644
--- a/man/man8/xfs_metadump.8
+++ b/man/man8/xfs_metadump.8
@@ -11,6 +11,9 @@ xfs_metadump \- copy XFS filesystem metadata to a file
 ] [
 .B \-l
 .I logdev
+] [
+.B \-v
+.I version
 ]
 .I source
 .I target
@@ -74,6 +77,9 @@ metadata such as filenames is not considered sensitive.  If obfuscation
 is required on a metadump with a dirty log, please inform the recipient
 of the metadump image about this situation.
 .PP
+The contents of an external log device can be dumped only when using the v2
+format. Metadump in v2 format can be generated by passing the "-v 2" option.
+.PP
 .B xfs_metadump
 should not be used for any purposes other than for debugging and reporting
 filesystem problems. The most common usage scenario for this tool is when
@@ -134,6 +140,10 @@ this value.  The default size is 2097151 blocks.
 .B \-o
 Disables obfuscation of file names and extended attributes.
 .TP
+.B \-v
+The format of the metadump file to be produced. Valid values are 1 and 2. The
+default metadump format is 1.
+.TP
 .B \-w
 Prints warnings of inconsistent metadata encountered to stderr. Bad metadata
 is still copied.
-- 
2.39.1

