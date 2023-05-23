Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABED3C7EE23
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 09:01:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236287AbjEWJBc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 05:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236276AbjEWJB2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 05:01:28 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E4E0102
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 02:01:27 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34N6Eq8L032516;
        Tue, 23 May 2023 09:01:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=17RjFe98fYH9lhA9/P4hVFVbpRpMBKdb+Oj2+Sl8c1M=;
 b=Rw4+5kzf62Z1tH0T2A6MmBruPSmdmukagjf3FtqY/b6wd53FC19KQSCzPm545chP3SmN
 FARfuGmGQwZpNdgkdaDMtyWX32eyScZcYVHTMNgC5jQDHHwHnM+1G91XDRzNmuqOVx9s
 r4b4jT5viOz5gcIdH+WHosDGkd4kKd3+Qy/OZfnj/mgi7MV90GtSrhLosHHuZi/9oxfe
 C0QO/3/jy42GbLzOfCRJPcJ4mKbk4qC3MXTIVkH2PRalhzgrVFoir0OWBxI3k1inRpN1
 aYgqk6Qf6m0XlUiRRt8wfeuL44pPCGEQF7EfDvadcgJjEmIASxsjiICXcInsYOPiqxjC FQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qpp5bmmea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 09:01:25 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34N918F4029093;
        Tue, 23 May 2023 09:01:24 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk2aj7vj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 09:01:24 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34N8xwsB007681;
        Tue, 23 May 2023 09:01:24 GMT
Received: from chanbabu-fstest.osdevelopmeniad.oraclevcn.com (chanbabu-fstesting.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.250.50])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3qqk2aj76a-25;
        Tue, 23 May 2023 09:01:23 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     cem@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: [PATCH 24/24] xfs_mdrestore.8: Add description for the newly introduced -l option
Date:   Tue, 23 May 2023 14:30:50 +0530
Message-Id: <20230523090050.373545-25-chandan.babu@oracle.com>
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
X-Proofpoint-GUID: pqBNt5mlZlcy6pahrEhZCVG8DPcCW7kE
X-Proofpoint-ORIG-GUID: pqBNt5mlZlcy6pahrEhZCVG8DPcCW7kE
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 man/man8/xfs_mdrestore.8 | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/man/man8/xfs_mdrestore.8 b/man/man8/xfs_mdrestore.8
index 72f3b2977..a53ac84d0 100644
--- a/man/man8/xfs_mdrestore.8
+++ b/man/man8/xfs_mdrestore.8
@@ -5,6 +5,9 @@ xfs_mdrestore \- restores an XFS metadump image to a filesystem image
 .B xfs_mdrestore
 [
 .B \-gi
+] [
+.B \-l
+.I logdev
 ]
 .I source
 .I target
@@ -49,6 +52,11 @@ Shows metadump information on stdout.  If no
 is specified, exits after displaying information.  Older metadumps man not
 include any descriptive information.
 .TP
+.B \-l " logdev"
+Metadump in v2 format can contain metadata dumped from an external log. In
+such a scenario, the user has to provide a device to which the log device
+contents from the metadump file are copied.
+.TP
 .B \-V
 Prints the version number and exits.
 .SH DIAGNOSTICS
-- 
2.39.1

