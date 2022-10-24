Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECDC4C38A2D
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 04:56:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbiJXE4K (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 00:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbiJXE4I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 00:56:08 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EC403136C
        for <linux-xfs@vger.kernel.org>; Sun, 23 Oct 2022 21:56:07 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29NLuAXJ013432;
        Mon, 24 Oct 2022 04:56:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=IdjiryPbgOrV7HovzflPVozqC+o+sS1ZBSWyQakrdtk=;
 b=gN52nHx3wvz+qv81NyG7K3Q0M4s5PWmmUW1+tPH2kQ3yi7g/WWILwys+fDJzc+yo1CjP
 9slwMSYzKLxDqwbQlomCpvVI/dhAFSgk8dgRGbED9AKHfNDjT8pU5y1WPv0E1R+b7fxx
 IDWnaW+58At/EFMJQUA/iFPP0rZd7zIXFbCIJv5c3Wqr6MGER1hq/wfwxeoCSLIo7iZo
 Yn9fnkqy/crAF0N2bZSS1+a3AsafVW96Fugcg+VI9rFMvEn8glUyOFsaWfei/L1g8jwa
 9lMyf3j7741+VBHdFdJrkV12Wy78c+sGC5sRc+I3ysrxHDxPlKsyeFCQETYV+BJ4vY1U dw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc7a2tns0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:56:00 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29NNoxTI016299;
        Mon, 24 Oct 2022 04:55:59 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y9m3b7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:55:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DBOob02mX/dl6Wiy1W9uo6Ukymn1dqNXMJQvrmFkD/D311AMxZhFtu79nnlirYZCNXVUFeys7pD3++O65W6BxI6lfS+fxg3dDozKEW8bpPAfmzPnZcIfU3O0jr/fDdBUIFAtuf3pYEwNQEzmZ4PonKTLDAdwaNpOwOliiU+1+NNmcsrsbtfd0OHMulz1qtOwksN0q7jjEPVl5VxeVFXYQmriI2LS7RLXvBimof4eHQg19/QjanmiE4UalCd3vKZpEznWquyr25wPhPqK5fCBWacHddonWHCm4Q1QT4W7S7Xsju49y8WOi1fJfwhXCFueAhPrUnANdfOHQS2f6neb0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IdjiryPbgOrV7HovzflPVozqC+o+sS1ZBSWyQakrdtk=;
 b=iWoBLfn+5I2LEZHTQPLGHTWZ4LSXEelDGqEQitFDAK3ZI7yvMIGy012JhVMxSjM8GoFCKM3LyWYzIV1gr4MDfhkoi9l8B/KMEpJeYwFwH08XTPxqRA8Xv80fr2O6ld8j+rHJ2Y2GV5/jSxWFwBoZ47Bm0y/v2Nei8u+Ld5qOuQ33DT8uno9y2HuDld2PjnzCs2e4HFoUeCKM1I/EljagAdjbKMOrkX7jFjjmhzwI/w0KF6qUUbRY/h6SntcCOXQEtM8/W2V/FQG21kosHWLuTRvem8wrVmdjU5oic2nrMaSgV4iyxHN9UDpCI03loP/uHxF59kSFCMIp5eYosHQxLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IdjiryPbgOrV7HovzflPVozqC+o+sS1ZBSWyQakrdtk=;
 b=dSDwccBJYh1UH6GYGb0nH64+/enskkia1bMkHu1ADdDzviIZ4Fw9zNP2pnLjrBRQ729CxuClbGog4/jew0qksL9CGPIjlXU5ZAftZJPQT8F7gmj8TlwlG/aa+QUnXav6q7era7iYHtpitAPEZlneKHQgNSPG8bbLn0YA4SBnSvQ=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CH0PR10MB4906.namprd10.prod.outlook.com (2603:10b6:610:c6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Mon, 24 Oct
 2022 04:55:58 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Mon, 24 Oct 2022
 04:55:58 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 21/26] xfs: don't write a corrupt unmount record to force summary counter recalc
Date:   Mon, 24 Oct 2022 10:23:09 +0530
Message-Id: <20221024045314.110453-22-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221024045314.110453-1-chandan.babu@oracle.com>
References: <20221024045314.110453-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SGXP274CA0022.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::34)
 To SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CH0PR10MB4906:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e8dce45-88fb-4a40-5786-08dab57c0a71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YvtUAEQeXb91f1Zhp5Bgm6HMxfJf/LOw5mlR7O1J9JEs403lDCQ/Y2Wj92bmO+PEXeps4tAFNdQYvRprcMPGBnlvcya7ouLXCZRsacRfob0xzz+9RPiyorsPzaqKr3EQeLZ94inKR2ATZ7SNS5NgQ1dx9jPEce6/YCzfuv+Un5zK47bUGyJU9UA0Loczk6hg0g0XZUGaOtKHNpmXvAAr+4yvAbt23bOF6MIaNz4v6TN5tih2gAoHku9JQf1p92S0yWa6p5X31wi82CHcSV9l6XFRs1ibSCk2jywH3GCheMDUFrD8pwaHN6kfVaVCxyjD4nvZUjR7Rh8nehllUKgPwULkRKqrYlgidHGW7uYwNF/14BS2+TsEZft07KAJX0Pevap1Hc3YOD3igJx9+5UMikHOzNDcsvKqChlOSapm7wH3tJ16wFC4QYUQeEApmQHHEpmXFzgZJGdUIfL3vIlO93+yPzOer+/cC1FZqmraomtDYijZOJg8AezmMq6q4QKDjCkgBWD9fZO99jSFgBAbLtupjLMzB9W0aaKf3v0qtb9M3vna+QpgUY4Pem/4N/Q3wSoSMjA2dgAfFskWddZgPARWRe+gBqH3HWcuTyW5E6GzzhQnKBbz488QyJo6ZsBJmsoYB039aCgHe3bQXPtK9KKJS5zYGn1YApxilSvYOCbnD+2ZUkh3dPzXIFbTLRVWYPfz+2vUfPuCK14CmD/y/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(376002)(366004)(451199015)(2616005)(1076003)(66556008)(66946007)(66476007)(5660300002)(6506007)(186003)(6666004)(83380400001)(36756003)(6486002)(4326008)(478600001)(8676002)(38100700002)(86362001)(41300700001)(8936002)(6916009)(2906002)(26005)(6512007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cLDfpd1SegVGPr9wc6nGvY79ivKPZtEC6HkOf1Ppn7Js0Rqw3O81Ke1ItOHm?=
 =?us-ascii?Q?FBntbCauNA9+kPanhFGJUWzFNrxHSM2FCjrkihn/InDw4ub+8yPUHb9MgCdk?=
 =?us-ascii?Q?oMUsGUfhrFtvXxczKqWpBPWl4QdNq3A250DQQctbl3kwxkHvu13sLsfcRioP?=
 =?us-ascii?Q?Rte9qdyBklBgoYjgjC9b80jnhRS4C8NOiE2psK0kJAlr7ebaSuIxwrBWKN76?=
 =?us-ascii?Q?ZDa+6FpBa6r/V+GHup4s5DvCYCRV/N8fXg5mfGFEyB+yNODb8hNaJ7V7xrTb?=
 =?us-ascii?Q?aSyI1SJ4lCym02bXqblSVCRefxTagxF+4B5vFNUGU9rpKr18mtlWNSraLkb1?=
 =?us-ascii?Q?x1s9vlhzM+uqtvGTASfyou7CdcAWt6kf8+d2U5MWfFLx3yHfWgUOu3JL2ueD?=
 =?us-ascii?Q?ST5SX1Bln3yXeq5JZe+dmFiTcRiXAHL6gyQlcrIWJKjzkzurw+KPfWE0mdym?=
 =?us-ascii?Q?x+l0Sfz2GQihW6QIu2c+4wSi7le1Hdh7PLjizGIfKnyoqQ7ldp0dKjsh9GLe?=
 =?us-ascii?Q?DqCI8TGv0h9XlTuvvoaV6gp4M48gliR8S61pr1FGbYi3yxyagC7gx6Y5KFRo?=
 =?us-ascii?Q?2GRh9uS11CSumh2XU76hJX5sT55gtFjgJ2kzjymgalFMAMFwxDtMJXlYOpK0?=
 =?us-ascii?Q?gy996N7XQc3EfxLpqZlcxDiBEzziCJyC02G7jvdHXchriz0ice3FhpvLa2jN?=
 =?us-ascii?Q?doj2g0i8rU39FCz7Xzix4Weud0tPaUl8lsVrBbPIwMnqECMecPiR7ydhqpDW?=
 =?us-ascii?Q?hsNXMiPP4p0bMqtRJZ6vi0wgfxUNmbJ8+JpV6SnbJZD/qsqPnuIeERsRX026?=
 =?us-ascii?Q?2Kl1jjV6XiuDa+GUu07gx7S35Ito6zJ1OzRTNqKI8Cu+X2m2D7SWKPV/DXkD?=
 =?us-ascii?Q?LFs5fBPlJQVd1M9sgfZp8ydfceJg0cZOiR36mRWMCfaQJ6PfxHvAkvG4uON5?=
 =?us-ascii?Q?vhk3hqtiCNKVJsVU6Gn/1KYN9h/MNh+2PsomfK59xBDFcWao4y97No7IMsY7?=
 =?us-ascii?Q?c4culLZVxUDiKH9SbxkwNA667nTwFnpsuyt2CmV0OPnAW17JlRtbKA1sXLoy?=
 =?us-ascii?Q?sbFl20LksausHwYf+pnE8NtDUnaOeKlXM44av/voACfwflJUfbFbJ0OvhfUZ?=
 =?us-ascii?Q?ReOhR+oIJaOjAQmoOSUZzsdOmOPRm9gXdyZZ0PXuvAZENaJmWI5eZ9ikNJWJ?=
 =?us-ascii?Q?IIpwvl7Z/OmHWE7PqkiNrRQgBawU5E2tHAz4KIpSSqg1h0/Bg9/q8+E2yx63?=
 =?us-ascii?Q?+8FLWhTgVVZQ7sNCu7swSp7rRfTd1maQqQwXr3LlBPVtff+/qQPAkX1cVbJr?=
 =?us-ascii?Q?sOnrutVPoaauVUirIuiaDFS3vgPz77A6NDZCb26j6TkdLwzjrX9VvhfASYX/?=
 =?us-ascii?Q?rmB9A07XpuWdYHoiGLondudUQAGXoDzNWfT4irpYzih4VnYUv69syQ+58CF8?=
 =?us-ascii?Q?nA5LgewqizBMZTywVfa4T/QDMC6jfMclkxRXrxOTeSsprg7TpcVzv1nzCaWP?=
 =?us-ascii?Q?A0dgD8+PSGV8a48mkGIRaj3GJmupYYqtZPiGkdrnjipDa4tn2LT6pppbfKnC?=
 =?us-ascii?Q?C9BZiMurNNHpJA4T55oHS1dwfqG7rTzylevXLrO6KgnrTlswslxV2NHWxsIZ?=
 =?us-ascii?Q?UA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e8dce45-88fb-4a40-5786-08dab57c0a71
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 04:55:58.3056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j41TC0td2eNuEgPWBiiVrNlIt2DRed8htU9YWOqKSCPtkLG6lyONaEt0BA1YbWKf5G0pv5Jq+adLq4G/JcVDFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4906
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-23_02,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210240031
X-Proofpoint-GUID: N-fJVqdlEk0oOCYvB-f-ZSgxLkhKEJmQ
X-Proofpoint-ORIG-GUID: N-fJVqdlEk0oOCYvB-f-ZSgxLkhKEJmQ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 5cc3c006eb45524860c4d1dd4dd7ad4a506bf3f5 upstream.

[ Modify fs/xfs/xfs_log.c to include the changes at locations suitable for
  5.4-lts kernel ]

In commit f467cad95f5e3, I added the ability to force a recalculation of
the filesystem summary counters if they seemed incorrect.  This was done
(not entirely correctly) by tweaking the log code to write an unmount
record without the UMOUNT_TRANS flag set.  At next mount, the log
recovery code will fail to find the unmount record and go into recovery,
which triggers the recalculation.

What actually gets written to the log is what ought to be an unmount
record, but without any flags set to indicate what kind of record it
actually is.  This worked to trigger the recalculation, but we shouldn't
write bogus log records when we could simply write nothing.

Fixes: f467cad95f5e3 ("xfs: force summary counter recalc at next mount")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_log.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 7b0d9ad8cb1a..63c0f1e9d101 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -837,19 +837,6 @@ xfs_log_write_unmount_record(
 	if (error)
 		goto out_err;
 
-	/*
-	 * If we think the summary counters are bad, clear the unmount header
-	 * flag in the unmount record so that the summary counters will be
-	 * recalculated during log recovery at next mount.  Refer to
-	 * xlog_check_unmount_rec for more details.
-	 */
-	if (XFS_TEST_ERROR(xfs_fs_has_sickness(mp, XFS_SICK_FS_COUNTERS), mp,
-			XFS_ERRTAG_FORCE_SUMMARY_RECALC)) {
-		xfs_alert(mp, "%s: will fix summary counters at next mount",
-				__func__);
-		flags &= ~XLOG_UNMOUNT_TRANS;
-	}
-
 	/* remove inited flag, and account for space used */
 	tic->t_flags = 0;
 	tic->t_curr_res -= sizeof(magic);
@@ -932,6 +919,19 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 	} while (iclog != first_iclog);
 #endif
 	if (! (XLOG_FORCED_SHUTDOWN(log))) {
+		/*
+		 * If we think the summary counters are bad, avoid writing the
+		 * unmount record to force log recovery at next mount, after
+		 * which the summary counters will be recalculated.  Refer to
+		 * xlog_check_unmount_rec for more details.
+		 */
+		if (XFS_TEST_ERROR(xfs_fs_has_sickness(mp, XFS_SICK_FS_COUNTERS),
+				mp, XFS_ERRTAG_FORCE_SUMMARY_RECALC)) {
+			xfs_alert(mp,
+				"%s: will fix summary counters at next mount",
+				__func__);
+			return 0;
+		}
 		xfs_log_write_unmount_record(mp);
 	} else {
 		/*
-- 
2.35.1

