Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41644C7EE2F
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 09:01:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236253AbjEWJBQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 05:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235537AbjEWJBO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 05:01:14 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3A86102
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 02:01:13 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34N6EBVQ032759;
        Tue, 23 May 2023 09:01:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=/8u15Jh1AadZ7uP9o0wFKSIhTaau/NjPrOnsopZcqUI=;
 b=owXEqL88evE/Q65fzgWEjP7aNO5W5MdP+/A6WJWTnFxUo83b+D5JZLqp7o7+73hVm5kG
 aSzmU8ePqq8EQsQRZqyCv3lLECjtxVnrwnwmKxDQpJOGxKl1aqtrAwke0YHg/fOSGusO
 8CWYMScNjzWgJif3Flzqxdkk+I7Fv+kQ34z+rmaGrs4n7uz5v3DEijWHd0sjl4nnrmSZ
 ydzuoZV/e8L1TUa9AxOTJYnJP8FjO7KcYT8chUT7kZ5iP4cKviKvydFdNCW7IKoyrQ68
 Bx1lwzTKOeSGqnnFsLHZAWii+xTbhFEpRag19vfM9fc4puMDRkk+wnttSSPWSNjbDBZh sg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qpp44mjh4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 09:01:10 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34N6wqRN028906;
        Tue, 23 May 2023 09:01:10 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk2aj7d4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 09:01:09 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34N8xwrZ007681;
        Tue, 23 May 2023 09:01:08 GMT
Received: from chanbabu-fstest.osdevelopmeniad.oraclevcn.com (chanbabu-fstesting.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.250.50])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3qqk2aj76a-7;
        Tue, 23 May 2023 09:01:08 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     cem@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: [PATCH 06/24] metadump: Dump external log device contents
Date:   Tue, 23 May 2023 14:30:32 +0530
Message-Id: <20230523090050.373545-7-chandan.babu@oracle.com>
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
X-Proofpoint-GUID: uj-Wg4MaFFPwiEwLXnNW3i2czRn4DnOT
X-Proofpoint-ORIG-GUID: uj-Wg4MaFFPwiEwLXnNW3i2czRn4DnOT
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

metadump will now read and dump from external log device when the log is
placed on an external device and metadump v2 is supported by xfsprogs.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/metadump.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index e7a433c21..62a36427d 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2921,7 +2921,7 @@ copy_sb_inodes(void)
 }
 
 static int
-copy_log(void)
+copy_log(enum typnm log_type)
 {
 	struct xlog	log;
 	int		dirty;
@@ -2934,7 +2934,7 @@ copy_log(void)
 		print_progress("Copying log");
 
 	push_cur();
-	set_cur(&typtab[TYP_LOG], XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
+	set_cur(&typtab[log_type], XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
 			mp->m_sb.sb_logblocks * blkbb, DB_RING_IGN, NULL);
 	if (iocur_top->data == NULL) {
 		pop_cur();
@@ -3038,6 +3038,7 @@ metadump_f(
 	char 		**argv)
 {
 	xfs_agnumber_t	agno;
+	enum typnm	log_type;
 	int		c;
 	int		start_iocur_sp;
 	int		outfd = -1;
@@ -3110,9 +3111,13 @@ metadump_f(
 	}
 
 	/* If we'll copy the log, see if the log is dirty */
-	if (mp->m_sb.sb_logstart) {
+	if (mp->m_logdev_targp == mp->m_ddev_targp || metadump.version == 2) {
+		log_type = TYP_LOG;
+		if (mp->m_logdev_targp != mp->m_ddev_targp)
+			log_type = TYP_ELOG;
+
 		push_cur();
-		set_cur(&typtab[TYP_LOG],
+		set_cur(&typtab[log_type],
 			XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
 			mp->m_sb.sb_logblocks * blkbb, DB_RING_IGN, NULL);
 		if (iocur_top->data) {	/* best effort */
@@ -3185,9 +3190,10 @@ metadump_f(
 	if (!exitcode)
 		exitcode = !copy_sb_inodes();
 
-	/* copy log if it's internal */
-	if ((mp->m_sb.sb_logstart != 0) && !exitcode)
-		exitcode = !copy_log();
+	/* copy log */
+	if (!exitcode && (mp->m_logdev_targp == mp->m_ddev_targp ||
+				metadump.version == 2))
+		exitcode = !copy_log(log_type);
 
 	/* write the remaining index */
 	if (!exitcode)
-- 
2.39.1

