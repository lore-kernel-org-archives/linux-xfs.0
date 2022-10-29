Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B13DC38A02
	for <linux-xfs@archiver.kernel.org>; Sat, 29 Oct 2022 13:58:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbiJ2N6M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 29 Oct 2022 09:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiJ2N6J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 29 Oct 2022 09:58:09 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 087714E19B
        for <linux-xfs@vger.kernel.org>; Sat, 29 Oct 2022 06:58:06 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29T7BLvI023363;
        Sat, 29 Oct 2022 13:58:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=115zXclkObT7m50GRjyfAGg+Mi69ixFypCtwcggn2tk=;
 b=NMOL7tuisUjW00W1AO69G1RjCC743NjG4E6pTvQdX9i51IXpdtvwaNb/SLd7v5eR5xYi
 FSFXhNoMPoTDenYjebbP8QjsnTMGlpmC9FTdCfK/S70MvDXfy0hkv90GM3Uh6VKL/lYB
 fummTV7z/lDRQIroj1tnxbacj4n3rynk8I/Rwo0l2ceYL84jdFBYSL0Pv3Fbjm8ya3tU
 KyujbKg1E5rGxiGytGmBNLa2GFREI57fH5x7Nb7reZwABwRWagkPzPKiXoZkuxlZ8RWv
 ibdFgViFuBkwYtBXDtZHu1BezbWse0Q4SWpT9VDhmWFbFJCuEcWvYtVoqybJ0RgMszfK gg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgvqt8h97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 29 Oct 2022 13:58:02 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29T8AVhP010830;
        Sat, 29 Oct 2022 13:58:01 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kgtm7uyyc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 29 Oct 2022 13:58:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cqc+fheh3s6ZhVNY0Y2wkEMmTu3Sot+ZhMefZnHbWgN/0JzH71v6/7/yuTJoakngMlaQX5vN1gdjW6umvu9bQ3lwI3twbH/nZGXfEjQ5s/l//sfBVVC/LwIT+pgMSOMqR+g1cgn5FtLs6es/fYWd7BEfBvsQSX51vcSO0v53QMpOYFq5EfOX+546D2WyYTeSeBFNoFvSzrYnIasTsP4BK5PRGPuSE/1RH1vyCvWs9p+H4uUYPd9C4h+h1K94e6oXTh5AiA8CQJN/jFq05N7MD29ytwSXws4EZqIrCUleG3igflS10gpZq0V4VTPKMoTtUV3UKYqFXiFu5RrzgSr/jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=115zXclkObT7m50GRjyfAGg+Mi69ixFypCtwcggn2tk=;
 b=En9KL6ixRE8mRWw8vSPVBzjswJAll0nLHpEpj2lFqjxTP3A3556vdizDHHXjI2LshdzrFtwi+mZWq/AgHdvqjUXjpi6dTBUoIOw4WSU6G20Gnt4eA8gddDspdOI1ZUUKmDLS2FMNcmbAIBLZ1SzW78bSigLMsh7UztEtQnhSZAqwh6bh9gnv8QeDJg9Choto/YEEeFB/SyVrUtupNJlpu84WlWlMQKh/HHCntCmsn/HWwWh27fYp9yvNp3hWUwzKlzfsBV5FOQN85CppUkhnI4rKtz56g+NTN0i8mMelvOSskjp8twykFPNQnDAQXuX/DMUm00KRnZ96wV6Dd9DdZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=115zXclkObT7m50GRjyfAGg+Mi69ixFypCtwcggn2tk=;
 b=s44cWrONIxvfygtX+BTaF+tdVr3b7vgYC/vxa7H3RPJVKMbHQhemPn1LRhqJVgqEW+sXIDU3nn8d+lZutknHwhcrT7ua6MmMrB7qhVGIID202l0Kik8HnBWLUnESoYhV7krae7p5vKyC6R18D++G/OjeJHVMf/tNG2Ji+4JW6gM=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SA1PR10MB5843.namprd10.prod.outlook.com (2603:10b6:806:22b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Sat, 29 Oct
 2022 13:57:59 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::4b19:b0f9:b1c4:c8b1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::4b19:b0f9:b1c4:c8b1%3]) with mapi id 15.20.5769.015; Sat, 29 Oct 2022
 13:57:59 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 1/3] xfs: finish dfops on every insert range shift iteration
Date:   Sat, 29 Oct 2022 19:27:30 +0530
Message-Id: <20221029135732.574729-2-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221029135732.574729-1-chandan.babu@oracle.com>
References: <20221029135732.574729-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0070.jpnprd01.prod.outlook.com
 (2603:1096:404:2b::34) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SA1PR10MB5843:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f4638e1-df42-4e2e-b840-08dab9b59660
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PaLS8cWrME2Qh6dtcM2O7SsyuAG8bUMRaboCFiMyeQyeVZh8KJ7UltgRDxZu3fKCVT2rp1WjxFojn5LKUKL7DUwLSg+dKFJTfyg0az145Ae2E1F8QeL6EXa5sxT9Md01AtzbI3BnbIKGUhYGgc47mwomTvi5fX6R1GEjswQ01e4mJ6VRHOMDQsr36Ho4Jeib4WtLPg8FhyE2a4qXKyS8pL37gnSRkykv/PhEAkCmIOqy/cPbdCFgWrbB6xrxr9Q32tkBEUwmAvTuke50FpVbxb8v7UmxbcwPemsf922BNF+kMifAXO+wdNegW4ZdHec+oZP0WU1GOwaWFoLoswbLqPzRoEiYTGk0WlMvB8YexEyIz8JqX97bFZyW6q4yLOsQmbGWoNcYddi1Jh/lKGSHBh0K2x0KckYtS5G7X5MejhxqnyUKatr1YQvmIHVQGRX2uxamM7CaUn2EWmlSXbLyqVE3SM7WXB6N7ajHWHDj9WW5IPJaH+wwS7KrauYJw4mHBBJAP/1bCLocozLAORUYil4tIWhbpStHCuclbK1X6dhMz3L7R9iLG/XKMQmIrjFRA8f8hLY7V5mXZdN40A13nQdU+I+mQNWpEnCOvxD3XTxbqsLXXXIdjs3sPEn0OgryzwznuuycRngxaHm13rGmz61/35bknatn/JvinmOlBGO3EYyKGAYAUwOD3bPDxYFQjsMGUTIe9DwLT2tJz5PizA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(376002)(136003)(396003)(346002)(451199015)(1076003)(83380400001)(66946007)(66476007)(2616005)(86362001)(6486002)(38100700002)(316002)(6916009)(186003)(6506007)(66556008)(41300700001)(478600001)(6666004)(5660300002)(6512007)(2906002)(8676002)(26005)(8936002)(36756003)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1nr5IcvIldIT6HZ2n8Enx41okNbXEIOcSDJ05Sipxpt7aS/QTJnhrMIGOCIf?=
 =?us-ascii?Q?pK+W8IHn0CkTYgTZ0kavMbAx1jddVxI4f9FSmpXN+ERt1pFXvKgFKVfsrbD4?=
 =?us-ascii?Q?kEsSbm2RZVAk1qJMgNGP8CGyTeAM8EJ/01Tvkjfr0b8GI6V8rUqoKpBgMBa0?=
 =?us-ascii?Q?f+s7zXU8IQwXYt13PvOuYQLUQjctivD12LpSc9Ip8Eh+yJz9qXeTliI8U9cY?=
 =?us-ascii?Q?yh7qca5LnsNsrUyVvBk4sNJJbT0ZJjlaAN4l0bd48ZWrVMqSjGDbrNinTW/k?=
 =?us-ascii?Q?pmfvPB0NIQQtwcPmiNjzXF9q4qn4ZW/UazUN5soQSA8EKxolom2fyVSzXR3g?=
 =?us-ascii?Q?KyW5oeJSY6Bh8LnkRJx/+1YBlQ6TyopRkC230M8Pr2nNMm6Fpd9zGE0L6dOj?=
 =?us-ascii?Q?92iOl9+Vp1iQxCy7HPkC7qWmnhl423+ienHwSzhev8ObnzQ8d+yUQY49dv/m?=
 =?us-ascii?Q?5E9pbe2y0asUCtTAOEBzn49NQQ2wR82Idqo9OEWF6n9JRQq9OfXh2tUqfGa2?=
 =?us-ascii?Q?2BKV/lncaDjcAq6EJsz0XFotcXRUlcNfSrsOfTc7C0h3MSF8BFs3kjp/90E1?=
 =?us-ascii?Q?GQeWy1j8jx+nIXv3Xvq5rGUoSwrnzAPZHwca+w2luK1hGUhgTDQGM34F6T4e?=
 =?us-ascii?Q?7y1plkEXNyAoQt/ZiRux6CFidY95iuXMG/Aj0SgxOq0mdXPkDPxTPOzla4z2?=
 =?us-ascii?Q?wLaCXUQOtsRa99q30LzdB7i5vm0ci8q6Vy6MwiJrAjWuBxDmHdK8PWHbl3ZC?=
 =?us-ascii?Q?XvLotyoNQFrSQ9oHvEQT0FSGb9q/j6ufDH6hBuvuoFIE1w9MjehYqgU1x0rQ?=
 =?us-ascii?Q?LHnni8b5o5GcBY0UnwNbF2KeJY353BUsguA5a9bhsqg5Sab3JTKvmNiSidfj?=
 =?us-ascii?Q?cJq7+mP5YPHCBbdh2dQxEqFE0kpPcYPMtTcaliW223xNS0tuHyw694j8JFwk?=
 =?us-ascii?Q?kIaQhmgJAv65UBpXB1sDaWYEdP7vfZmZSykYj1/TjJB8ftFX6tWbNH5Lw8uM?=
 =?us-ascii?Q?mWNTTLJLDXVhGtAXkShcVz7Br2Nyqwb4uUCacrwHGOIq+2E9AwCC5Gc5hHO1?=
 =?us-ascii?Q?mYNJH1q2xraNuoG4JsYFPhyr0VpFdMPdnE+TeROOhISl6fQB/ml4PnpjYXsI?=
 =?us-ascii?Q?I4yp7S2Pwu+ZcnYdSz+PnzXFgWfawM4wicLorugdf3L9pNMw3vgbMYszidt5?=
 =?us-ascii?Q?uFQsaeh8ZBCjQ0jttniJtRTRLhnJDUaP5wpOrqmHXpu9DGzSc8X5OOUGRZdb?=
 =?us-ascii?Q?TE9CWeHFvEbQTBwot72cyF9GUJsApj6ImRh2zwXIIxgmMNqwCDGNaj31Heiv?=
 =?us-ascii?Q?9n2b/hRIKcgeSBZaBxR7H8D1HOExitDbgdSaDER1XILl2gH023HqQCMzrCaV?=
 =?us-ascii?Q?ls6tx4bXs0X2cesaCmcF5DM/htXpjeO59IdFAIy8+nMC18PkBztJOjvkGb6+?=
 =?us-ascii?Q?oCGot4YdY1DVJG+lz5Uiu4afOqElpdcnELpEVlDoiq+qf3TDL+49RRICO443?=
 =?us-ascii?Q?q32KEZJWp5waDoSmlMYLF1+qt4mKZOW0c6t3pjaSjlsL4ljydmXn9qjIm0Ig?=
 =?us-ascii?Q?t4tuV6KXpNGWUB3oAXrFIUC6Jz10OHiLnz1Twua0iLlf4FA15uavquNOObvE?=
 =?us-ascii?Q?Fg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f4638e1-df42-4e2e-b840-08dab9b59660
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2022 13:57:59.1673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nofYmDSOVE/rLe4hQ+yCElQwEjPug503G7Jhz2q4xAN+EYsGeB3iBR3is8ehtIvSK2KL75lusRwXNTiyHohqow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5843
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-29_08,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2210290098
X-Proofpoint-GUID: h1JIucf4JDLzkczQTAG3IrcFRSsZUasw
X-Proofpoint-ORIG-GUID: h1JIucf4JDLzkczQTAG3IrcFRSsZUasw
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit 9c516e0e4554e8f26ab73d46cbc789d7d8db664d upstream.

The recent change to make insert range an atomic operation used the
incorrect transaction rolling mechanism. The explicit transaction
roll does not finish deferred operations. This means that intents
for rmapbt updates caused by extent shifts are not logged until the
final transaction commits. Thus if a crash occurs during an insert
range, log recovery might leave the rmapbt in an inconsistent state.
This was discovered by repeated runs of generic/455.

Update insert range to finish dfops on every shift iteration. This
is similar to collapse range and ensures that intents are logged
with the transactions that make associated changes.

Fixes: dd87f87d87fa ("xfs: rework insert range into an atomic operation")
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_bmap_util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 5b211cb8b579..12c12c2ef241 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1340,7 +1340,7 @@ xfs_insert_file_space(
 		goto out_trans_cancel;
 
 	do {
-		error = xfs_trans_roll_inode(&tp, ip);
+		error = xfs_defer_finish(&tp);
 		if (error)
 			goto out_trans_cancel;
 
-- 
2.35.1

