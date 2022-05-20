Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FE5BC433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 20 May 2022 19:00:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347982AbiETTAv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 May 2022 15:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350003AbiETTAs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 May 2022 15:00:48 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE5CFD1
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 12:00:45 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KFn6pO022606
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=zifJD990rwJu33QYI4T4PvvdJtkr+k7+218gcEBuu/c=;
 b=FirI3OnmBZylsjPaoSl2bohaI8kog+i4zjqp/JbMMS4CyWECV4kaip2ojdt0QUDNpFBI
 2ZAfUeVD+oSDkBwe67xTrUbyjwLLJkdgYmsBiGVv9SyFZTjCeHigQwrRwRdhJ6+HAS9D
 aRyAGBZ4g8ypgGVdPYzd9IVINSHu3c/MCO9aUPu8/6FhS1WeYFYaSx0+yp+zQpZOBacf
 yWe68B4VxBPhQHHLwkMxd5cErUGZXkiohueuTkot994nKoQRU6Chph83mSSd5VbZDX31
 xM++24JqFOTeczOjc5A+n4db2Zo9g/UNRUHnhlSHPhOCM68lXTLwGNNNmwSK7IGB0ldh 3g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g2310yw7y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:45 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24KIo9tw034597
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:44 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g22v6mhfm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b+IF9GNEvbiqy0yy/JwMKV4lsnEg3T/nVrl8S3y+hXrpFSWstu5YNNsFVENE9whQ6jV+lJZUzb0wTqOuj2jI8vW4yj9ZPzlmAxfM4hWI6xyLzMNL3PUcaTrZI7RJb+5RiTLLebJaLIdFtiqyirVMRlpeNqVx7dogm6AoHe+2zzTHSXPQi4xwN8defw5IhdiwuZG8yOd7nWXx+z1gWPz9KIqFe3Pne7j154A09hH2UXKfaMtBfUTbhlQ09clSAxoW8QwfFNnUObu8vH02q8PcsDRvKkeMq+eQjSCoF36hknE6QU+DhP3OJNpGmNzfph/GK8M9j1bTrlKphRrJJjJUlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zifJD990rwJu33QYI4T4PvvdJtkr+k7+218gcEBuu/c=;
 b=Dc/m9iG7HKgMr6mvdXYHHh9hGS/SoSxoha8lUZDwC0ZHG9VmC7zhhQyUKOI9k3y+UMfIT/S9u7724MBfQvmxc1esq8DQ/iuQUyw10oIDtWJ/mjg0MW2nkyY8uQyULHKQTESZV42sZsmpPBb2e6+ZmEUaNz7lrlOKr2AHfCn3lyuBAx2KsTyLcnY2tm3aG4VWCnoHT2iXK58U7exccbXa1zRY1wCCFLWeF1JxuDUeMMSnMNYkJOnIGXqb+SuRAXAxW8sYGJe7izNo8W6hLMAhX5NuzpxaYukSiu2to9DQ6qWKrlFSzeLfPY2E0JofvZz7VlCUw1X72szU15yAZBuddA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zifJD990rwJu33QYI4T4PvvdJtkr+k7+218gcEBuu/c=;
 b=qrxLdEBdzCnGnuiJ8LMNc2zOPS9+lh7x0y5YHRHpHXGntFfAiH1zJGRjXqKfgG2ZopFsUETRFQmGi/pnhXvf4sw55O4GhwEKJFossv41FN+LWdbgpeLI/qgNHNktDX0unrXtv037judnE1OdLW5W0OPJLtkUAivKA33k/3jrA9Q=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3399.namprd10.prod.outlook.com (2603:10b6:a03:15b::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Fri, 20 May
 2022 19:00:42 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311%4]) with mapi id 15.20.5273.018; Fri, 20 May 2022
 19:00:42 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 06/18] xfsprogs: Return from xfs_attr_set_iter if there are no more rmtblks to process
Date:   Fri, 20 May 2022 12:00:19 -0700
Message-Id: <20220520190031.2198236-7-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220520190031.2198236-1-allison.henderson@oracle.com>
References: <20220520190031.2198236-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0014.namprd04.prod.outlook.com
 (2603:10b6:a03:217::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b144af67-82d2-4a14-3886-08da3a9307c6
X-MS-TrafficTypeDiagnostic: BYAPR10MB3399:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB33996118C1D77EE71282609795D39@BYAPR10MB3399.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L1GTWMwLGajzwA31nr1KZnL19jdbQzxRWcNwipiev69vk+aKPK4sCZc3sRsVJUcgsQ+/aFL1dJyAi4nuT+FcHkcbrty2Is8/W30ifiej2JC0PpmAGnH9YKdbY/Y4l70CDoYQW+oMBQSdW3CWPaDoctxUWn6lbTZZPhqOHC5fA7PcE9MfuTOWD2p7lIVNHrQRBFgT9HkPobJ43/S1Yp6mTY4z0ylp7HqUKo9wvgy/jHBM2lL5LrkvGOmewOALxvfoCQQH5uKZRdj8DYpQKl6TkKwGLmtCux0bHbZ6CUvaFb1YQSd227L3XvIhMhVmCDduj1B7IA8QigUTGkXWFSO8STpWrJR4EFMwl1SjrNR2YYdF6HIgT+KShO1Usiwjk20eByl9ecgG5D6JvMbBzoaqkqO7IeZrW1l3qw3Rz1XWAXjW87msX8LkD6gPMsfL0wQSzgiQJWsj6/LC6jymTrDSPS2Vq92cCxet8Nf1TPTUp0JFXCgf76n/sI7Dbl/hedjTm9U/+n5RRfgj1MrXC+ZvIqDgvM+0Uq1KjEqTYaxKymrA4TkA5sIpbmc/gQ7WZYtJebyDEP9ZyByc8L33pbZJ+hTVgaF+F4QnaGX7LL5IQTc4CCTuWszIIo2csYPfoq/5GoQs0VJEjxPfddRx4Ct/JfzHOj0OkixOXfYpC0bax5RIQJ7Tw7JO8jeaOO4PVoukrEY5Cxhyb/a7i96/2AqH88MJnODuwnzrXQd69qNeF59E9Dkt7VhUFaLcVC76NoRmUSuGun0F5SE60jiuQivZKM9xAZAphFCvOuoIewfX7eE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(86362001)(6666004)(66556008)(1076003)(2906002)(66476007)(83380400001)(52116002)(26005)(6916009)(316002)(36756003)(6512007)(6506007)(66946007)(6486002)(8936002)(38100700002)(38350700002)(5660300002)(186003)(8676002)(508600001)(44832011)(29513003)(40753002)(133343001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W69NKBiZf3ogxRGPMKg872a+DUvL0r26zjy2Pml5tcYQ4KbUsQOVkOsi5/9R?=
 =?us-ascii?Q?LLLRGKBq/yuHWkn8jOWYvjtBh6WZRxJvoK5l3BvvWF2yvllVLJLIKjhqzXBn?=
 =?us-ascii?Q?VAfNPGU+2Xu0xj+lwqwCtwEXz3Ry/PPO+msq5RZjQBrueeBUa02Nzq7jKoD7?=
 =?us-ascii?Q?z2kuqpVs+Q6bjzW2Zp6ZVu69J0yvn5TigUhvDJpBbB6pz3vxj6+cABr53who?=
 =?us-ascii?Q?RQDcNTvEW1YTV1BWjctNq50fIHDqQRNwUOf+Me6bKvMykeIYBX3B2xlHYTUi?=
 =?us-ascii?Q?w+XlCo46p32C/lEwojaP8bbGs1Bg+KSVVHiFHd5vRvnzf7SrFYKzNUkL6LNI?=
 =?us-ascii?Q?5I6gg4TDra0Z+vHUKZQWyNaEg1HHyRd5njw3G4Wk7Bbxv0PAcq/wamHfWTnA?=
 =?us-ascii?Q?uga7kg6bz7vXaiCjYVvS0zRIEwKYDt3okE9l1Yu90WsjbCEcpJodDlkCMG7w?=
 =?us-ascii?Q?7rADfxGgy/j/HzqpR/AnoZan1NXork6dvQ/Xsaerdp3HXA1fj5UzZVjaz/WW?=
 =?us-ascii?Q?PbhllK7cXP89uZWbvrzrng0zh5b0HokTPeqvYtIC3neIboiqVRJi5BxENkvS?=
 =?us-ascii?Q?wUTurF23lsNU54tG3k6FWGYOAJAIf62fw0VeWlbcah0WrlZYiGkg9Wy5wXnl?=
 =?us-ascii?Q?u0dsjPHOIxq+74Yb/k3M056G5bJlh+QsxOE2Lih79U6GoGt+3tMtVWppf0s9?=
 =?us-ascii?Q?xrSKsK0TZlNKQNhEuUn05wi3/ZDooz4rLYGnSd2Dj+92idzMUumgC78Ysefx?=
 =?us-ascii?Q?2z5ipsxE+NL0C5bIgvV3ZXJKjh5wW8MgmEaMIfwKPa1kccKvl9kf4aau6LJ6?=
 =?us-ascii?Q?m09DZjuoMeC3SWZA0YENEpS2GWbdN1Ler1zwAdxAiRUDaf9mOJnv8AFHf7TG?=
 =?us-ascii?Q?ldqE3jyIg17XaUX23ia1/lua+aPOsml+sXC17Jj7YJQ5kq2DSGa0BoowtKJz?=
 =?us-ascii?Q?A7JJq+kw567SiCHI6Dunzoo7UM5gR+ITxPcDVxoL7iGr2RKDG2aEyzdQ838J?=
 =?us-ascii?Q?e0y9q14I5TkCKf0pK5qUCau/x0ggmZljjpentJ81Uuxc3lYV/aXgCVOrvWbX?=
 =?us-ascii?Q?DxLZwsTn7z3gx6l+L8ZuzL4CcQy1Qoqs/4Xjm4BgBvShC7UnIUMxZhMwvu2D?=
 =?us-ascii?Q?I25SVxibilIxnIFjaeviviHj34jdYZE1xQ8BDo3cyL8er0U2S9q0gAcG0lIT?=
 =?us-ascii?Q?FoMJuljSxXoQ4toEIB4wQ2Lg8w/r4vwr7773uAxj6mSUggTjk2jwu4W2CyQH?=
 =?us-ascii?Q?yPUmyp/u8VBIv7s1MOWDrH9zGtbLod4gYahdhC7pWHeFB+m9hwkZT5XJ9w1i?=
 =?us-ascii?Q?LT1wL642o8KftBB/+XXhyz7wX4M164/FSXp+Ha5AsIUmk1tK5J4tL7dxPw+0?=
 =?us-ascii?Q?FCrb+RenE3iyj3hMEZrhm8RNl96EcSM0AY2NeBWD7VHInzSXfzHBoLmXf/i3?=
 =?us-ascii?Q?Ul/1MwB1qc5N9/0L4Ymo2NOkPyERPZc1fdBSXzvi42fqqykLN/Z3gWiWlI49?=
 =?us-ascii?Q?EMw8qsI5JEnR++UH7UGXcFKy1vcjSmtnk9/nWwlb9LemGexmFbtu9xL/oitz?=
 =?us-ascii?Q?m0DhT5VQfzQCIGtRuyrJODwuzeznEQqHqER8YpwPZeDyh7YzJIti+zCb30N+?=
 =?us-ascii?Q?HBmTT0gaNi5pDSV2agoFCMhGnZjKDzmsRAQkwdpVktGHs1TPyjxxDAIPHkbX?=
 =?us-ascii?Q?IhhwHf9+0Y/o9V/dDN4st/vKoOMLgI1nc7DXWt7Eq535iQJqGqAVdk+uayl4?=
 =?us-ascii?Q?cea+wbZYTeoYmsVhsVrxcdU6E4XwXZM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b144af67-82d2-4a14-3886-08da3a9307c6
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 19:00:39.2474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zc6vl/eIvHU6KmfRW63aT5TYofVVF8bP7ScMQF9K2iwRlmCOLxhEUlDxCyKaZEg1LAxK0w2uB1T8uUS69CX0VkeKwAl/3xCfsrjKQ/WCTzI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3399
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-20_06:2022-05-20,2022-05-20 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 malwarescore=0 adultscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205200119
X-Proofpoint-ORIG-GUID: 95EWSkZ6-xLnMZwPYsLHWc6uS-xnsmme
X-Proofpoint-GUID: 95EWSkZ6-xLnMZwPYsLHWc6uS-xnsmme
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: 9a39cdabc172ef2de3f21a34e73cdc1d02338d79

During an attr rename operation, blocks are saved for later removal
as rmtblkno2. The rmtblkno is used in the case of needing to alloc
more blocks if not enough were available.  However, in the case
that no further blocks need to be added or removed, we can return as soon
as xfs_attr_node_addname completes, rather than rolling the transaction
with an -EAGAIN return.  This extra loop does not hurt anything right
now, but it will be a problem later when we get into log items because
we end up with an empty log transaction.  So, add a simple check to
cut out the unneeded iteration.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 9a9da4594d11..b6f6e1c10da8 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -412,6 +412,14 @@ xfs_attr_set_iter(
 			if (error)
 				return error;
 
+			/*
+			 * If addname was successful, and we dont need to alloc
+			 * or remove anymore blks, we're done.
+			 */
+			if (!args->rmtblkno &&
+			    !(args->op_flags & XFS_DA_OP_RENAME))
+				return 0;
+
 			dac->dela_state = XFS_DAS_FOUND_NBLK;
 		}
 		trace_xfs_attr_set_iter_return(dac->dela_state,	args->dp);
-- 
2.25.1

