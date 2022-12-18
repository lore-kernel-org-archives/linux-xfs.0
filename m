Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7F0DC4332F
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Dec 2022 10:03:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbiLRKD2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Dec 2022 05:03:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbiLRKDT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Dec 2022 05:03:19 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 784EE6333
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 02:03:18 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BI2xPk1023317
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=I8sRiT8HegoLo3XD+Hnm8N4HbjY6M5kTI37zdnr8ZWA=;
 b=18YqxdSC4o9axrLhyk+trjPP74Ub20f2CIZNmeHLY01BaXnbbVTuh2+6MvJXG+rcsVW4
 oHonUoihpf5x9B2NY5SIU9/3tDsq1qk7PJAae519Dk10xppskIO6fijZQT9Xx8k5QBkY
 8bRmy81KhPjBmnfmragYrOZsPa1eopwieRILTEqyga6SIU5NrVNxpF8WCGRnkR/VVXk/
 3WPX/OeUYRluH6ttM1cSkS1uaSOaT5FuJBm/R7mBbZn4BoP74itEpUm5E9hjJ+YqR4S9
 m7Qo+m/4fAS+3UByO0Vk/cFl+y/GxdI8XmS5OaBOAmwx+fAC4AXMWT9Y+66K2Hirtjym 7A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tp1911-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:18 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BI8PpxY006839
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:16 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mh478n3nj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PtX23P2rm4Qx4HoXCWGVgWXXJ5nlgFUMq3VRJ2pFa+BinUaJ1QqmA9XqAiPWhprHMeIQwbuintuRsKDjihq4xwtCRscvIJKI1s/TT7rGb2iVwJU2vxzbta8YVynZ0DVGFne3/y9SyawsSMnP6lm82bjVcr4ARTJFpDK8jFLtMB78qvdpsh3vJll9geReHVgcNajVZWtlf2fEXWWbK1BOhniH8QcXImzD/FoONtaF2t1TczMAPCmAI6y4BWdIUcPeBLNroUVjAbJhP5IskXf6GpVAoBT3sQvOiNivo/3P4OAQXvGEPR/bBPL1ljbUZioUhMWDtgtpaGy4bHC/z43zcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I8sRiT8HegoLo3XD+Hnm8N4HbjY6M5kTI37zdnr8ZWA=;
 b=dVO7yUvy8MTiCZRvNpybW9GPFUEQft+4e4xDK0jzFjaUSeZpdHNQETeUCkdLxMJ0dN5sauvHxSIGq85woDzMetiVyy9i3NpRa0M0iOr/7jnj6ZnKtLdy07EXP9XTBlQ0rRSrCODsUkw4bwBcEgY7hIK2bVeKn1QL1n2HwO7bZgnf8NrgSyhpPSegQIbRLAGmd1/cmabvu4n3DS2jxkMpySWT8NyeM6el9v3ACfRvHD58dWQdfDMKO/HbhfpPsR5WURkTRcRS0+5Cu6fSgpt5FAHxgfEl5KgskPz8XhB885MicVad59WNrzjLQcB6+wFrQZcNkCpM1wFhEPU8SH5ZQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I8sRiT8HegoLo3XD+Hnm8N4HbjY6M5kTI37zdnr8ZWA=;
 b=O1RD9BUcowd7Lp2DbYXyiSE7E0SWxBern4sjKM4HduBIcbVi0BNDA2nEky8aOV98Usezx9trb0gz6QQ2MkmwDM4FKwKL+KHH3zlJYF1qWzj2UyUbpBT3/O68jMWNLThbnhFhwD6Tlaf1R7Ii5iZMNWJY8Akh/CDQDLB87Cb2DO8=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4536.namprd10.prod.outlook.com (2603:10b6:510:40::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Sun, 18 Dec
 2022 10:03:15 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5924.016; Sun, 18 Dec 2022
 10:03:15 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 04/27] xfs: Hold inode locks in xfs_ialloc
Date:   Sun, 18 Dec 2022 03:02:43 -0700
Message-Id: <20221218100306.76408-5-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221218100306.76408-1-allison.henderson@oracle.com>
References: <20221218100306.76408-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0057.namprd11.prod.outlook.com
 (2603:10b6:a03:80::34) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4536:EE_
X-MS-Office365-Filtering-Correlation-Id: f73f55ea-b3f8-41d8-f45e-08dae0df147c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v6Ll9/bQGUvVm2GjUL9mGvrTTPnP9Fd13/nALPwXLIakmdlfJAylxgNkiPdrMObTcxL7C15Rvr+A+CrvCqmbbSejEkPJpX0PkXXj3vxvaVUKh9jhUmWkqLK8k/ENAfUGD5eqH7taWHk9oZPctMJTfCF/QaB9znRBKplHB9jEobfToQMgoqmbBVUaOfWzZaOjACSPNu/Lng93BkblXdUqLrdEdCDxSdvnlya980LA2Og7ojq8cqVKSXg0dAuMOWiIAh9p+QM/TEA+spzzEHldrVgOwozDbElc41+oZ7ETQ6X294T1IwRJ/HnQnCt3YDPzzKW/lGrZl40Cevt44jnCP/ak/CitJpT1JiizyOWXOly4ofOgjVunKoLseVfdmx2IZI3a2JABYO26y8lJdHz6Pd4+L0fSr6B9ORKL9JbuS0UDe57hA1BdTEF0QG0V/IS9hHWQzk9p1/LW3cOYhLJngIS2hvr4W90JnOIBdrU5tlljoGPQmaADSPlW+UM/10LxWZL3TCBrZCskmKnT4dGXsn/DF3aEzfMocAx9iL0CJ0mEYV5V7zGVpBxUoGQx7X0q4YWwpKd8uagVrLRg52H1biD9s2ppC9snd6KjJJQSF0BDrHTz5vSuAWXyvj0SwNUe9oQMC4fO2vs9jAGAPwzK9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199015)(83380400001)(38100700002)(86362001)(66476007)(2906002)(8676002)(66556008)(5660300002)(66946007)(8936002)(41300700001)(1076003)(9686003)(26005)(186003)(6512007)(6506007)(6666004)(2616005)(6916009)(316002)(478600001)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Zuoh13qnwtVuWJIBR+/pNPWva5W3IgZdRIthg3N+PjoVxDl+zK7nOYWjoQjl?=
 =?us-ascii?Q?N8fvbbBzJyH5Yx0D6T74fz4ggQ5+N3RQr4zu70SdXeFwGmoEBnp1di02MWyK?=
 =?us-ascii?Q?PmrE6+e7xDDSNoSbM1Rp1s/5jzyx2xuepRVAgMG0OsN7UqX9Z6jQcC/JCPFD?=
 =?us-ascii?Q?U2bLzIPIbgJ8aaCZOD8btk/X/cDn5MROP/R5yQHZ2Q6Fjp8zQ+Lno110CHGj?=
 =?us-ascii?Q?xyiIizCzpALhJksDhaDTSSLGtT/gjsLSv2DQuajCpA+6JouzkVpLzGEhqSfs?=
 =?us-ascii?Q?D/r4UhHSkm39OzQxfLPv/acL1fNuF1y5N6Ft7ypVWq9iubDqZWALVB6u7s8n?=
 =?us-ascii?Q?YcSh/JOiuuNXVrxpcKrB1ZtnGxAQh/BvOBPkjdFtjecruVohyYvHL020EaEb?=
 =?us-ascii?Q?BkcAnmH2fQiJ9iHqVZDEa2Wz+O42+dJTHb5D1DEHDMCUYMoP9ERkLI2GzON3?=
 =?us-ascii?Q?M3lJIc966TIzOcCJu5yFZ7TbTlt797D49Sf3fka8bA/xeTARc66YqIv9jmwV?=
 =?us-ascii?Q?JA+nV9eDkWgWF/x2u7Z8sKrnSSHyXCkxW34oTyep/5F23f3/p5kz0LqzYfoX?=
 =?us-ascii?Q?J2sKyRVpezXw6+DArTnmU94XbkogSqkva6rUp41x8kXTv8c5y7wU9xsssJZx?=
 =?us-ascii?Q?RbLl5YtXHynTwTfV+LHRiMmtIAj1wmNBqLufBtElMXFCQmIu+hOpqURSbBjf?=
 =?us-ascii?Q?T+c12+4Vlf36tkX/Xm5Vg3F9wVn3fzowTHIauM0Kyqo41e7bGZ3RYtCD8E6L?=
 =?us-ascii?Q?/oVote+2KG1TJI8V+ThDReAMjp0icn/TcVI2yJPiMBh34v7votrPySbwVhVA?=
 =?us-ascii?Q?XrHTVlRp1IMOvcjlNkNwTcTOt2JhMF12XI81FtbEPdHB4WrZIzjEQItMO4Cb?=
 =?us-ascii?Q?WrqCK4IbG2dTJ6RG04V1W+/iAjVZ8ndDaVoP9EyIIFOPv2Li3sh+//kDJPSW?=
 =?us-ascii?Q?YoYsifd0hNOOpleoc4tGDB5ZYcUeDRaNmGXfW0uiTxFFU2ghQJilG4MqmKfL?=
 =?us-ascii?Q?2i0cBkcahR2rdagiROIRB1byq/AmYNzC8A530WuM0jGoPgjyeXyg+cPnt7gH?=
 =?us-ascii?Q?UzEfieYdHUVxnrDW4Kw/RBt9Q78PQUAJ7BhONGR2/cnKlogPVIFRU28sWoDf?=
 =?us-ascii?Q?gYoyNC5ffBhl02tcF1aYlbg6lbv4RNYEde6mK0CaR4y3SOux5G4yRFAkSzJv?=
 =?us-ascii?Q?sBGL6JwXZwuZBVw0AA4jWAHXNZNAULaf/vHAvkXNbOEF4sWAHWFYz2Z8x4kq?=
 =?us-ascii?Q?JWhlW1+++MzXJzSRcELcfMb8oFXYgKIbUaqS/3CVDWwvfN+Zg+rQhicyBcJ7?=
 =?us-ascii?Q?3U1O8fqrq3WbyoirdMTfJdSGGYc9DiN8RbBoJ/zrbcLUe1waaPgPNvrAmUtR?=
 =?us-ascii?Q?+5TlHw6yXSbMDTK9F7Hq2tRYrT1DVfO6DM/7/cYg4F5LwPwiQzW9qmxDus7D?=
 =?us-ascii?Q?F2j9F7z9uny3qzQx6kimfmUDut/XQNo1M68/0M+matcrCCsMKFSFoJugu2bN?=
 =?us-ascii?Q?LQHPrEDFWSr8Yw0H8k0U7L7dycrQldtnBEwsNHvxGmemV+TaMPewuHFfbxTG?=
 =?us-ascii?Q?Nu4NSDXo2M2U0tjfpvHuI5ij8EHRVcOvbJwLkuoInoZR+5AClSRjmGN84iF+?=
 =?us-ascii?Q?mg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f73f55ea-b3f8-41d8-f45e-08dae0df147c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2022 10:03:15.3189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uRobulx3c7i0xCjBh78Kk7R4ssKMFnF9+K/5QLD/5SdowNbZLemgZrOaA/kl8t9qcs2+JgqVRIEbF8oiVjsM65RPvorRt1kKR5ivzEjJS+0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4536
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-18_02,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212180095
X-Proofpoint-GUID: tZpTsHYn-XhqgdMNVPuc148TUCtFymZq
X-Proofpoint-ORIG-GUID: tZpTsHYn-XhqgdMNVPuc148TUCtFymZq
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
 fs/xfs/xfs_inode.c   | 8 +++++++-
 fs/xfs/xfs_qm.c      | 4 +++-
 fs/xfs/xfs_symlink.c | 3 +++
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 27532053a67b..772e3f105b7b 100644
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
@@ -1089,6 +1092,7 @@ xfs_create(
 	if (ip) {
 		xfs_finish_inode_setup(ip);
 		xfs_irele(ip);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	}
  out_release_dquots:
 	xfs_qm_dqrele(udqp);
@@ -1172,6 +1176,7 @@ xfs_create_tmpfile(
 	xfs_qm_dqrele(pdqp);
 
 	*ipp = ip;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return 0;
 
  out_trans_cancel:
@@ -1185,6 +1190,7 @@ xfs_create_tmpfile(
 	if (ip) {
 		xfs_finish_inode_setup(ip);
 		xfs_irele(ip);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	}
  out_release_dquots:
 	xfs_qm_dqrele(udqp);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index ff53d40a2dae..319a263d09e7 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -826,8 +826,10 @@ xfs_qm_qino_alloc(
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

