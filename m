Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F615C4332F
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Nov 2022 09:02:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbiKGJCy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Nov 2022 04:02:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbiKGJCx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Nov 2022 04:02:53 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EDBD12AFA
        for <linux-xfs@vger.kernel.org>; Mon,  7 Nov 2022 01:02:52 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A78uatg012294
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:02:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=q5KRAzVkZpM1zPPDkY7MXbl0kqn1n4tp+ZgYkKUpynI=;
 b=jo+EkV1t/KLriw3gYZAmJPJTMpBCCV59lEpGRK2T4aDxMp4yWA+OW/g6SSUHIsJISSoN
 nD4MsT0M/U6ZDv4DE1/VbdOpQo4/VmXPw2C5KLBJnm4Mhc3kfdoSd6Xmz0nMNa93zvU4
 s5z67VNPzVf6CqAv5vYY7RfkrY0Kdi93ZEBRxs9uhQr0A11RhYjdVsUF0athezo37ClZ
 xC1/yDV1bvkjDi5KlYbeLTjOchjE4//vDVuKdm80B2s2JXiQzmkXBnsBmhDf7MqZLiav
 mVhje0BqsLT3bjBK+ywOK+obgHseeEUXqDe6pATWfBVCMoqn+rmGe8l/S4AHqMn0TzEe 5A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngkfu7tq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:02:51 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A77KaVf025118
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:02:50 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2048.outbound.protection.outlook.com [104.47.57.48])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcqek67k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:02:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m4BYmxMRNP9+hqg6OYI7TkdcdxNTIY32+GfCE+5g8rTwT2Sp56uSph4z5hIFhn1Z6eWEr42iGKPZAsFdpQY87OdGhLgGxxaLxdRiNdMyEU0LykdtsqkLaBn4yJ2vDTorNFBSRTWn+x3QDdbxl4lb8qRBE6E8t3u2Q7o0qRHvZSdTdknOM9MteoamTIKQqHiifP1x7m7TLKElQhLnI60KHEChjOewgO/k/iKClBPR97w3zVSmTI01+HUDyzGvRLKJ8YSWicx6O1OnvfMoaZlhf4YK9v1HxgJ39rD62xvJgTAH/lDlfQVc+fheg4viuCaKcuUyz1pMzOcjWS/XHGlkhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q5KRAzVkZpM1zPPDkY7MXbl0kqn1n4tp+ZgYkKUpynI=;
 b=SP7y4CW+geaGWSsQCRnlpxwAPak7EcLnhudNQrsU3w1mL3yPbJOJS6bPUSps6Ien9eaH/SxJh1HWVRODVxG4xWmKWPNXb7D/RQh5VVq3HhCSDy70U0ddGiYh5ZBtrJyeFDaL9+pn5jvKH+YY+DE3OciL3yOpGFGYesAFsgamF8HVOo+/w2mjPmcAK9qDRhlh1iwuS4Mk9FMlcxlzhg9159pR5CvWZYGqXnWK5XZA8Svvt+a3AOhnVl87aAehtz5Kj7pcrfHHcCNUKIT6DQgRDNpdkCQqirgqINU9wM+sNNR5NNTxZO8pnHr1o81wE20Z+19uwBH/F9c71ZecCfEXjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q5KRAzVkZpM1zPPDkY7MXbl0kqn1n4tp+ZgYkKUpynI=;
 b=M+toBXHBr9t+BPijG3oVltTsHd0dDm4MkmNyuNMkus6IYenhcDS4AlvLMVPXxxfstFyyCD9lb7sEa9pyARq2v71vS0D10iX59Fubww3y/u6NcKMmn5lSRUpc2hJRaqXnq10QnJOX/V1IfnPMC3HFM+fxvs+ctF2SeqUivWCVrvA=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB5848.namprd10.prod.outlook.com (2603:10b6:510:149::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Mon, 7 Nov
 2022 09:02:48 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%4]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 09:02:48 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 03/26] xfs: Hold inode locks in xfs_ialloc
Date:   Mon,  7 Nov 2022 02:01:33 -0700
Message-Id: <20221107090156.299319-4-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221107090156.299319-1-allison.henderson@oracle.com>
References: <20221107090156.299319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0035.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::48) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB5848:EE_
X-MS-Office365-Filtering-Correlation-Id: 892fa6ae-0168-44cf-d819-08dac09ed7f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5hcRCVC7bQjN5VVOKScGWfc7lp3LsK0Pqi572vVVnVnFSvzaRmj/r8geaLAdd1t3OjkrsxEtKyMH74MRaF1wjDFL205vq18ay4e8N4XXkitE4dcW5mDyrJcwjmijAgzn8Y6DKezqQkMzVwB5wWaow8WWIPZfqvfJOzELRS1M9nB/ujPyfO7bQx75F9UH8P4kLxBtJ48gB2otjoziZRR5bLsWw2037ppEvYGwc1kcngY73H2WTyZaAd0sIhsUkv3sMXz6HrHytaW1IKwbQFp0uYCYfWHOPMrDjN7tiwEIPCrxocyOp5cnDTInxwryUifVUtyWlJRDUFNKQq3L1zbuxOHiE6tmI47DO30+wrccMbVlOP4RVRQ7SrE4VQtOBWWZbXyL8P1R5+kR0PPAVTl5bXFP9U0AmPM5vJ1NeSB526ICH0VeTFVpgLDf/CxGTI3pEaxmqu7lcrO36W11lqcEccOodXtm2SLGzOpEfnAMUN3DWl16ns4o9NA9CO2leofKH+INSXJtlMIt5MgLebhBvUb/486DOiOClA2XO89DWipFJ5sCZLdwbzztCyxrGIViZWdRZSYXM2CanUm0olnE09Jh4xpwvX5iTnfhDmMBxm+Jax1eqESczqhPZ9yK28ZJQF4jCHR0LIW/k5loyoX7L37kKrZlYdri08dz87Q9Na+PFV7jyXCmVZoKbLmjcxG+rrDPUcQlhjsGgzyTsJN9XA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199015)(36756003)(8676002)(66946007)(6916009)(66556008)(66476007)(83380400001)(2906002)(6486002)(41300700001)(5660300002)(8936002)(478600001)(6512007)(2616005)(186003)(1076003)(26005)(316002)(38100700002)(6666004)(86362001)(9686003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?noSNg3Ts42XZD+OWNptha1HjY0IVlvw12haP5qoOc4hs4xRRLxOGqvYNZH33?=
 =?us-ascii?Q?imzLmrfCDUUz2gfhhqdmjk+obS+kZYhChDdneRqmRQJa03uqVDVGbIvZGBcT?=
 =?us-ascii?Q?7VuCDTPOGNEC3oJ+deY/L3G7zbpwpFk+DcFJwXa+93/+VOuoUsqllLluNM4u?=
 =?us-ascii?Q?MgJub70N24NpmZUCsGB21Cxal3wjktrh7JHy5TN/CT4w5EXwEf2EBCej71JF?=
 =?us-ascii?Q?AP3J0p7F3Sf7h+uOk3hqzHJhGlKsoeibv7eR6slid21Dit4qeLxxiGUKT48h?=
 =?us-ascii?Q?RujwUxOn8EOvuhQXsEoW8cB4F8CufIgeRU784/S7PkUHR5mOTp1tAgWJtnsw?=
 =?us-ascii?Q?vXhDLI/IccWkBJzoz/cwkxb/Lr88kB0jmFU6XPqSc/ckD/xFjw8mc9koSyu/?=
 =?us-ascii?Q?X3YW7uAWQ32xIy3EIA5c/0Ti2pNd+qrsqIx/q3SU43ZFwkGA2884uC0EaPXt?=
 =?us-ascii?Q?bkzWDNhgFVsKAIuHyAmWe1uLjONssZIaNFxPIBf2jVd14h7sNH6WFeN/Kzuk?=
 =?us-ascii?Q?wFbEV6yCWcQcrEoGuM2Mm9ax8ErKgqfaCc0gQ5R7/YEp48vexIvJUC3syZbv?=
 =?us-ascii?Q?fzv0aSVVea0tDdxAuXdvHTwD1IMms0mrvsm6T7VaDn9wX2JUwkjQidPNrA3n?=
 =?us-ascii?Q?80DrbKTWmZvBpz4U9PPUBeFa+yoT+IGTdqIWvtNnM4hounArrIlev5ZD7fIb?=
 =?us-ascii?Q?I9hgq4XVDO/AOwZBmepyK/fZnAj3VjylQeaK+4laLwBl/RUDxqnCKbYCFix1?=
 =?us-ascii?Q?G3GWXlMlRrMmRiPCM8WNaZl649MesKi4MGbPcxlfk+zow/sbZ6ZQqWps8gu8?=
 =?us-ascii?Q?7OzMLY7v+SPORgVLDreip03+nTlEK4WacyTRkNc45a7KXuwpA/zt3FagweUQ?=
 =?us-ascii?Q?5sM7/L4PgyDywvi1s8fEiLOiSVpo2MYo+nZQqIk+8cGfweHoUR6pxwqKV1+L?=
 =?us-ascii?Q?ogi5oI2WswWirsOdvLi5idyw2ynoDNE3v5wjuBF+zsSXSol0XOKGhYhelghb?=
 =?us-ascii?Q?3+51ZII3AK5wqWWPMEH8KuLb7NOm8T+52juepNbSy21tkRbwG9M+QT4Hnhjg?=
 =?us-ascii?Q?4ruB3LAPACjNQE4la3R+zt0k1Y9gfsDs3wBXtuwhEyL16ocBarJNERj5+hFY?=
 =?us-ascii?Q?YOWwdVMi+M6bQqCvdFQ5Bq+/mjpsRAaS1wtvxGmCPSg2lsmvS5c/ZLK2jHZr?=
 =?us-ascii?Q?c5feinxEwN5c5Dqhprv+yEFORjnuARA251r8nMIunMDzQ2M710GNJhBIK2b8?=
 =?us-ascii?Q?UVHWYB9ENiSdeJlgeiKawwzKk7cy7XR1ypU1N4gFeqsMlR2p5vuDCjjiF7jv?=
 =?us-ascii?Q?OEjWWJjcUZt9Sqav9Ogq8hYMYcHmeUHD4GTmNnmJ1ItNjetcNMgjC3SOsK/+?=
 =?us-ascii?Q?fVhPCrYuYMmK2cbfZt19NExPmUfZ6OEAmfNp1gu0QHk4D9QUWdqVQw3Vyhd5?=
 =?us-ascii?Q?TXiP8fw3IIx51Rs9Q6+1wvcsG7BVr/unHweJin2Tel2U0XxOMY4N99RSDeFs?=
 =?us-ascii?Q?olHPOsIN1rbA+o1hfzDNwgXQUzHX9H0NdEbfPFMVqmy7HybPL2X9NYP6YXN1?=
 =?us-ascii?Q?zCESCtKstKkR//6rToe0fMusr8oBsdPlACL9RQy+RTPoeLu7DmJMnBUI0d82?=
 =?us-ascii?Q?VQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 892fa6ae-0168-44cf-d819-08dac09ed7f5
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 09:02:48.7862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NcWrZOhdHt3jAmRHg5MR+PKWLVn3z2ANe4ypcoHajx5p62jTjWISZ4Of+rbk8nlF6k6v5K2BawHM7M+p1mFZ4oc1BMawX9LgtnapJGUuGM8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5848
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 suspectscore=0 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211070076
X-Proofpoint-ORIG-GUID: IZLPSwVYk5U4j0hstv01mqvvUqZmv3DH
X-Proofpoint-GUID: IZLPSwVYk5U4j0hstv01mqvvUqZmv3DH
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Modify xfs_ialloc to hold locks after return.  Caller will be
responsible for manual unlock.  We will need this later to hold locks
across parent pointer operations

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_inode.c   | 6 +++++-
 fs/xfs/xfs_qm.c      | 4 +++-
 fs/xfs/xfs_symlink.c | 3 +++
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 2e7d43ad770e..eebbff3b5866 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -774,6 +774,8 @@ xfs_inode_inherit_flags2(
 /*
  * Initialise a newly allocated inode and return the in-core inode to the
  * caller locked exclusively.
+ *
+ * Caller is responsible for unlocking the inode manually upon return
  */
 int
 xfs_init_new_inode(
@@ -899,7 +901,7 @@ xfs_init_new_inode(
 	/*
 	 * Log the new values stuffed into the inode.
 	 */
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
 	xfs_trans_log_inode(tp, ip, flags);
 
 	/* now that we have an i_mode we can setup the inode structure */
@@ -1076,6 +1078,7 @@ xfs_create(
 	xfs_qm_dqrele(pdqp);
 
 	*ipp = ip;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return 0;
 
  out_trans_cancel:
@@ -1172,6 +1175,7 @@ xfs_create_tmpfile(
 	xfs_qm_dqrele(pdqp);
 
 	*ipp = ip;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return 0;
 
  out_trans_cancel:
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 18bb4ec4d7c9..96e7b4959721 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -818,8 +818,10 @@ xfs_qm_qino_alloc(
 		ASSERT(xfs_is_shutdown(mp));
 		xfs_alert(mp, "%s failed (error %d)!", __func__, error);
 	}
-	if (need_alloc)
+	if (need_alloc) {
 		xfs_finish_inode_setup(*ipp);
+		xfs_iunlock(*ipp, XFS_ILOCK_EXCL);
+	}
 	return error;
 }
 
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 8389f3ef88ef..d8e120913036 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -337,6 +337,7 @@ xfs_symlink(
 	xfs_qm_dqrele(pdqp);
 
 	*ipp = ip;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return 0;
 
 out_trans_cancel:
@@ -358,6 +359,8 @@ xfs_symlink(
 
 	if (unlock_dp_on_error)
 		xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	if (ip)
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }
 
-- 
2.25.1

