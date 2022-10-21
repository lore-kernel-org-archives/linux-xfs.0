Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A481DFA3742
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Oct 2022 22:30:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiJUWaA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Oct 2022 18:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbiJUW34 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Oct 2022 18:29:56 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9344350B8D
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 15:29:50 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29LLDuOb010112
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=8wPt2tjtJcmVrCgo1Cxb8yGm2KdG9I7Rj8vUSswuV90=;
 b=vN+GJtHBszLYOS5X0q8qUByel8CniSYZ9mkPiodrGXsS7+maO5+P9PQ+TWzFRSXrk2LN
 lPG83ZwRS+Lyl7KFoxF3bXbj8iShxMd2kcYbyY2e63dMDJQsuTl0MRCxjWTt3fNVU8bA
 eyMNFt5hr0F7klcbzOHjMiQSZEbZi+60pCK8brPzFixcg5o6o2apDRYiGByTPHLKc/re
 W2XbIumjaHxRTwNyp+1hfhQRKTjRLXO3LXHz2JCx7a5QxTi6OztUq+9IAbVzSLFpGpfM
 iA13Hw7z1tbZv7BRko+7SPlH+MDF69L/A0HsbnSUd1C1z0GqmH4DwAGNGvrgh4fzWqKl Og== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k99ntpm0x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:49 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29LLPxnk016974
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:47 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2047.outbound.protection.outlook.com [104.47.57.47])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hub8j97-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NO+EIlZ8p5ltSvjzg3nmSvmUMxUIxixrKEmDXPEaEcV06gQpsP0ctNqtcIc5zKRWLj8/8Bgkz1D/zB5zaWrx1HBpUCXnmDT9XqCxfo4u3k0LNESb8fxU6lbTMnOmEQj8Nzc8qUcxzeDEgV+2lNggrnwpt5RBrqtSaNyXfQ+Hl7bK8mmuIr7fQFSbk278O728lFscFE+tlDqtw+RD5hPSdDEl27wegRDzjXXdtqktti3497uMKSyIBpGfyNjk5b3IrYh8/DgGHZ05rOJEknmY+JLsom6aAlX8t0Q9Jzq1cpYH6qNPjmlV7UMVcMbBndWlp054ytZXbr+owwvWY9YS3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8wPt2tjtJcmVrCgo1Cxb8yGm2KdG9I7Rj8vUSswuV90=;
 b=ICyEYo5ieH/7uC2OaCj0k7DzZ9HPuzjpnoeyy7G78u0JF4ayD21CEFZF0PemnHWmpypYLVfd0jVYsrcjULv8xd7wSCXe8SJokiZHl4hbNqWn4rlQ35BnSDKzjWjV/2/NCX5goCK38CE7GGKj6OL7F7jgxrSYWmW/hM9rAfzk6Ri0l7m8v3hAsVR+3lVWuov8MGuNAjKbVacoC5LUOttxS3dNCWzdW3hePbhI6VUeeIer2SqRaDuJBe7hhkmeg0fqdcY+qTbcvBL25uTmBucZbcDSm36qiG+p9Vu5K88aCukpDPrK2CoTMbjUkPf3hCgAVS7F5hr1U1Qkf0ym8jZhSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8wPt2tjtJcmVrCgo1Cxb8yGm2KdG9I7Rj8vUSswuV90=;
 b=ZIHS2KYg7Lxt2dUmII3DaL6DE79SzwBRherrp7jm7BPaytxQd0aSV0lOcr+8a/7kvMDsJclVl8Tp10+zhea/rrK7j32zfp0ubY8xLdSehlSK1CgmYJMQyg4ykmOUXiAH9axJXUAwyV9J5Bd+HVR6/SkkGaCpxxyP0TLoPtTloAw=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CO1PR10MB4433.namprd10.prod.outlook.com (2603:10b6:303:6e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Fri, 21 Oct
 2022 22:29:46 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5723.035; Fri, 21 Oct 2022
 22:29:46 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 06/27] xfs: Expose init_xattrs in xfs_create_tmpfile
Date:   Fri, 21 Oct 2022 15:29:15 -0700
Message-Id: <20221021222936.934426-7-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221021222936.934426-1-allison.henderson@oracle.com>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0095.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::10) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|CO1PR10MB4433:EE_
X-MS-Office365-Filtering-Correlation-Id: f3d95b0e-9e2f-4fdd-e41e-08dab3b3c239
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PuEq2SqyIxG2Nzj+RUuuO2Ol9Pv88haiHrR0ByRXt1IYEsklO/d7kgak1uaHU9rMzcDfSyxDrwT1z+PnK5v7/CskpIB/hpSx9d63dQh9AiGPTzooyUNtmry/+RV+L23EaLs3bn7gJrlBWyN7E83d6nIzVeqhUWDmSih4q5hz3LLcdceGJ6ZzQy+T/0cTUDMRJ1LJ9ST9BYmnPry4Gv+RBjcNTvAEsLwdc2hJ+sboySkkU+cdUlIlchr0cY3wLW/aygAUqidyo2qx72BOiVuqudGrY5Zdg6xm4kECpbJspxcc6GQ7P71bJZuby8NkSbqBypvyVxU9HdoRS6xEZprBKJT8ZfknhMgkple58mPs4o5pnbdz7qVH+Y9gomcpXNA8ZdP7FJDwPWVswl6dmQDqbDKG4kWwYO2Ofh5OrR4nnofdZBqBELHf1tHr0rhDa/HRwrrfZwbeEdrfSbnUKyifZyk/F7MqFHC5FQLu3GL1lXzRAz1V/puIBgx8h/OcZ5J1aQgy1schcchkfe8kCL7uFdHd6SNBLCvnj7u/rPIcy8A7FRyUnISRx+HtRwZvN5VykA3O83yWri5inuP0/D4JMgRz7yM5vBPgHV2AqSJP4ZPdkuHcIMR9Mr/zs8qtTe6v3DMJ0pqSpZ+hn+TajFkPL0dcuroKh6AiEMcmlr22tVePt+JFHyfAXag/6RtaTfAt0HIrzkAuyAOEWONGHzii0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(39860400002)(136003)(366004)(376002)(451199015)(36756003)(38100700002)(5660300002)(86362001)(6666004)(8936002)(83380400001)(6916009)(2616005)(6512007)(316002)(8676002)(6506007)(66946007)(478600001)(6486002)(66556008)(2906002)(1076003)(9686003)(41300700001)(66476007)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rx/Y0AqpLdwWbLgwfrPITZRrWAiWbVKh0JgAivhHVsD8lnaRdxhO87Glb0Od?=
 =?us-ascii?Q?M/f79mFp52cv6ZfPVwtf4IPSc9FJ61ImPDxLNNO5G/8N9Qd62NdfyPLosFfs?=
 =?us-ascii?Q?QgxrGaNgCIuDuYOr/D+8NIBCt8YCqvBY/zdgn/Gy3ZSMe7jM8iCLaWgS5e6t?=
 =?us-ascii?Q?7FEGOcdT+gmFwfqvbV0vSCpn8Sla76qMM3WmHpu1trr8qXE5v3wpvjZOHhz7?=
 =?us-ascii?Q?CA/22aQ4GSrGBpyZRKeJhvPuhOOlYwbj4ULcqZ89MwrIPQyKu/wMrrIJBW1C?=
 =?us-ascii?Q?r22NOGvXno6ReCpAqo80Ous404JckDxrHa6pXPzyLxDELxlssZ284tY6UIlI?=
 =?us-ascii?Q?gGOQmu3NCEhCJQDsq6ru1oPFYxXZgWiJ9l1fasbS02QZWBtCecxuTIToxLEF?=
 =?us-ascii?Q?Dvv7SubUl1g+RZVhcd7yJRu/kMAIc4w1EnhK7Pyc5Kzl7HyI+7ROyCzoNr45?=
 =?us-ascii?Q?YdJjQ5gj89Yuf0Bfd9OASG48B6taK5pf29BGdYzVJ1cFl7A9wkuvR8LtP8M4?=
 =?us-ascii?Q?4+2p+pAM4zrocI1xofCeQ4GdkQHJg07rnVM9xHHdEruXvMMd98V2NKuJUr/r?=
 =?us-ascii?Q?+PGYf0cyF3o1hCZCbJYfFyfMi7LyuLNZWcZEu620nPp9avbf1btz2yVR3SVg?=
 =?us-ascii?Q?BT4usX2S7kqxRYwKAvkgFok0eV98TmwzMZz/tzN4QeZlWeVH/3EkPjtYq9Dz?=
 =?us-ascii?Q?CdFDWWfTM24Auaor6ti4KAcrNd8hfv9xvP/+j8x6Ff70LMkAXHBuT7bT5FKv?=
 =?us-ascii?Q?xVQcg4x/a2aoYt4X4FVBi4dPthMa7wz95AGBixR8I1pagQLRkBCXqtsBA/fc?=
 =?us-ascii?Q?ItzDDzRmbxdmbqH/JIhE5oEt+2mvzbyB4NFA9i6GmcTDAdgnquIhWZsRgFRH?=
 =?us-ascii?Q?/vqR9Bl+6Yky6BS2FBjgwVaOZzqmCEkrZYQJr9HrGZCr0sl4fUaV7zwCVrIL?=
 =?us-ascii?Q?f8lu+rSTjOlxdxwImkul6hc/RkUiau0dWS2UvUTeRfy0v9Zfepk6kLsIMAy2?=
 =?us-ascii?Q?9oXEcK+aw/yp482mQGqmvPPD5Eh2bi2jQ2KDlVvH2Jzhexkms/lEluzuDJaG?=
 =?us-ascii?Q?OsnzMLQuToq1kkxx2IYhseek+m9PA4unIk3MkJ2v/YqeP6Stjnlm+nB8CHEG?=
 =?us-ascii?Q?CH9l6BX69y8dsADEfdWfCPmNGBXS7drz5ybdh0io5IcCNkZDpXJCn5jQfkCG?=
 =?us-ascii?Q?sQZx+z/zP5Y7O2S6ZhNFpu1SwnM3sEsNUh0zsjUdZUDTs70qSLC/YgaNMDoU?=
 =?us-ascii?Q?AnHqMbLS/ku/d/VagnTlbQ6mzz+KGHzxnTASf+w1+bari+HV4eKbUSjYWtdc?=
 =?us-ascii?Q?QAuGUey0OOOoqCZjMo8WB68i+oTpMKONTHVt3Kna6euRmzjPO3bBKEilNZlh?=
 =?us-ascii?Q?2o4uKPXwnwt2nsFfavx86nRBiiGC/a4EbjN1e1TpByqlFTUOENO4Lh1JNguf?=
 =?us-ascii?Q?7h5nzb87tOvGoIHwmCEo2cYT49YwUtvlJHpbl2+6CRd/pFt53Fio0ICBPlSh?=
 =?us-ascii?Q?hNsOjkjB4JCGdOIcT6TDE77VwiuF880erVCP/EZoLAA0FyK+/ntxTwq5xMHR?=
 =?us-ascii?Q?j+2Rhmm/JbFUqbltaJviyhdX+xsn9fB4j7fYi/341iAxB/wJYTs3ePHGFjez?=
 =?us-ascii?Q?uQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3d95b0e-9e2f-4fdd-e41e-08dab3b3c239
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 22:29:46.6545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fkin1ijlGuZIGo2Iajyr9gDVQJsSIl3ge/FbeNdHzW8EK7GjmGLgKZ/ZdEEzH/LsC9g92Cgo1pMEWTioZmfhUynProOdET14WpD2iDy0lfs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4433
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 spamscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210210131
X-Proofpoint-ORIG-GUID: 96IVV3tvM1uyf7ER4WFMBv79FC9p9R6A
X-Proofpoint-GUID: 96IVV3tvM1uyf7ER4WFMBv79FC9p9R6A
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Tmp files are used as part of rename operations and will need attr forks
initialized for parent pointers.  Expose the init_xattrs parameter to
the calling function to initialize the fork.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_inode.c | 5 +++--
 fs/xfs/xfs_inode.h | 2 +-
 fs/xfs/xfs_iops.c  | 3 ++-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 44b68fa53a72..8b3aefd146a2 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1108,6 +1108,7 @@ xfs_create_tmpfile(
 	struct user_namespace	*mnt_userns,
 	struct xfs_inode	*dp,
 	umode_t			mode,
+	bool			init_xattrs,
 	struct xfs_inode	**ipp)
 {
 	struct xfs_mount	*mp = dp->i_mount;
@@ -1148,7 +1149,7 @@ xfs_create_tmpfile(
 	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
 	if (!error)
 		error = xfs_init_new_inode(mnt_userns, tp, dp, ino, mode,
-				0, 0, prid, false, &ip);
+				0, 0, prid, init_xattrs, &ip);
 	if (error)
 		goto out_trans_cancel;
 
@@ -2748,7 +2749,7 @@ xfs_rename_alloc_whiteout(
 	int			error;
 
 	error = xfs_create_tmpfile(mnt_userns, dp, S_IFCHR | WHITEOUT_MODE,
-				   &tmpfile);
+				   false, &tmpfile);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 2eaed98af814..5735de32beeb 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -478,7 +478,7 @@ int		xfs_create(struct user_namespace *mnt_userns,
 			   umode_t mode, dev_t rdev, bool need_xattr,
 			   struct xfs_inode **ipp);
 int		xfs_create_tmpfile(struct user_namespace *mnt_userns,
-			   struct xfs_inode *dp, umode_t mode,
+			   struct xfs_inode *dp, umode_t mode, bool init_xattrs,
 			   struct xfs_inode **ipp);
 int		xfs_remove(struct xfs_inode *dp, struct xfs_name *name,
 			   struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 2e10e1c66ad6..10a5e85f2a70 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -200,7 +200,8 @@ xfs_generic_create(
 				xfs_create_need_xattr(dir, default_acl, acl),
 				&ip);
 	} else {
-		error = xfs_create_tmpfile(mnt_userns, XFS_I(dir), mode, &ip);
+		error = xfs_create_tmpfile(mnt_userns, XFS_I(dir), mode, false,
+					   &ip);
 	}
 	if (unlikely(error))
 		goto out_free_acl;
-- 
2.25.1

