Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E00A7C636D7
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Feb 2023 04:07:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjBMEHg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Feb 2023 23:07:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjBMEHd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Feb 2023 23:07:33 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C265AEC57
        for <linux-xfs@vger.kernel.org>; Sun, 12 Feb 2023 20:07:32 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31D1il3J012223;
        Mon, 13 Feb 2023 04:07:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=WZqkiQMS4D2unAFlzPzEHGvAJc0a6AZwRJ8NGlKO1Tg=;
 b=W7uGwOUXqORST5kYcOQA1x9coVJWqGseE4Qud5vu0hZvpVvSOJfoezgS3B5D92Zx18Pg
 CE75ZYIxx4ihJGNESynszmCE3qYTFtuaGqNzYr/7j8E+3zqh+MOIHZSHiO3sgxtuAp7J
 +ElqfDWECSDXnMXujRe1auhYUhPFhNht3z+8g2PU2eaoyM8W+ncz9kSwAsb4RjQEwY1e
 TZE1sD78Y6vh6x8QdUiu26y2/TEMNAbnimWZOuA94ELt6KWIGqZDSv0XhUUw58KLzIEc
 DI6nhJshvSQWqYvlzSwUdDExBsiKvMXzAqS/0IXBgTxjpuWwyW0U8BLCsUvm2bPqlmlo tA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np1t39v7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:07:26 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31D40CEN028884;
        Mon, 13 Feb 2023 04:07:25 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f3aabc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:07:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KB+GdbZmF+Y8wQfQqPXT6c4xERTXXa6AaREe8zeb/QWAmbZ7wBUWUjRyQVrYWVnyRPvMnrAgrgiUjoF+kVyspVhoenW5VBcCaOg1wAKvs0/dwhe5FZ81jIN/deEC+FZBHzsWSXJW7vg9Fl9uy89wyviTU2ZYZl5UeSPlUSXwu6DlmQNyCJ96oBi9qiSu/cBMQTZCvQZDHz8Irife6ucvGbF4mf2UuarpDku8BtZz/K4T0DBpIiyLDekAiz6URWu2fFKGtYz42gmgkezHdqzfgBSVVvb9gqmgGmq2u+CPCZpjNZgaeKA+3tdH4ETfK15NmFDjTvBEv+YyA0AZRAjjtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WZqkiQMS4D2unAFlzPzEHGvAJc0a6AZwRJ8NGlKO1Tg=;
 b=L20lJ7YkpW9HFeVM6qhUaFxGOKFYimHywyC73qLHxH/jOX2Bqa1M+TXVLeFtFJPZTcDLbMS8D0Eay8AxS28Hv3tM+gPvWtQssK+K82B/jIsC8RNQzoykXWizmoRjGdIdRd7luIuVZn07tp+rBjqJW8ZS465nM/371RQm0zjDZgYPOcQor+6kyuGVjVPM7jJNib/K9uOUxyyoHXyjG5OYVf27ZOBDY05naWIw4L+f4oM9863QRxOwm2u/kAkal5QfhJTYlGEIDQhJtJDmVXPVCkDMX/tqE8LspcYpcauKThsxPKXPWE8Lufg5ZLBJgbc/s52y2rGt33TI+0WMh+9oNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WZqkiQMS4D2unAFlzPzEHGvAJc0a6AZwRJ8NGlKO1Tg=;
 b=j/CYboU2kYgr/GD/3KHlePTQrvLQxqnPJItGBFScAsYZQMgM5hmn/cLsxQ0BodqvGq05Ww7wSUy1GZENw1d1T6/wf0GtMY/1SmhIUVGKQu5954eMw1+7z9/C4AM9zOcdwOJ/cXYGkMHx/t3U38gXQ1IkJLuUcvcP2suOkx1fMWg=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CH0PR10MB5225.namprd10.prod.outlook.com (2603:10b6:610:c5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.10; Mon, 13 Feb
 2023 04:07:20 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.009; Mon, 13 Feb 2023
 04:07:20 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 19/25] xfs: expose the log push threshold
Date:   Mon, 13 Feb 2023 09:34:39 +0530
Message-Id: <20230213040445.192946-20-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230213040445.192946-1-chandan.babu@oracle.com>
References: <20230213040445.192946-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWP286CA0009.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:178::7) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CH0PR10MB5225:EE_
X-MS-Office365-Filtering-Correlation-Id: 392da61e-f4d5-4edb-ea6e-08db0d77cda1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kpfSrKL3fecIugWXLXlqj/WI5S3OK+pYRAUN06pwAvuU+7347zrBK7lERDV+IS3WOsFZO25eddz4wrmco5i7vTib20IVpDkzreKOdyVayt1Lt+dOE8ViTGWnwOEHnOnexQt9qMVHBkfbS/ZzKsLQIgh5jF4/jPxiPS+hnGs3IL4BRTZMzZBPW8mqe7LazoAj+NTsIWSIXv43kDwyly4Ik4hSo7w5DRwUGOuuFfpSxMvDQkrSdYO4KS0z9LPq+VaaCP2VhyoHQr7kW1rrZOjVN4+s5YlJqsmeVI8v8ZzMnLzK4xZMvVskwncTqu6ZfEseFFErJ29N2TDSxSWz+Mb4MLWpkYYdlN5wjWgAHeKIARic+CycBX7F9g5Pb7pK7+eZqDTh1P7TJgmNztgqoWRCo5J/EIrqZ4n/ngvjx5RnJ0VE4af2+lYB5oH21+n0sGDKQ4L83o86qqEce7KMisJ1zscikPzJcSLgkBL7X4iLGhqhRtoF4yA4lDXEEU+x/H6hrzb8u1RNuSBfRy9cYm0IaEavKtHrWSybe4ZCrujt7Eck2nwAmQjdcNDCQVbU3nR2gL2jlVkRUaW648ZI6XUP22BT0Mmrw1wqlfOyA+Gq31kt0Zo5mZbKCW6VQ8g8adGSaHjUKrWG1g2wamyid5goXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(376002)(39860400002)(136003)(451199018)(2906002)(8936002)(36756003)(5660300002)(86362001)(2616005)(83380400001)(6916009)(4326008)(316002)(38100700002)(66556008)(66946007)(66476007)(41300700001)(8676002)(6486002)(478600001)(6666004)(6512007)(1076003)(6506007)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0QeMcMI8NvuvHFWyhNQAELn/G8t+lpECXZdF1oQpjrQlCZnZLs9syrLIyFpY?=
 =?us-ascii?Q?eXDajDVJK81pjYGAT84zzTVn62iKutoYaM2oKhVuJSXux8enUoSfGhVZxkqg?=
 =?us-ascii?Q?t2VbjOSFQGzcOQpzQBk/HoWy/djMi+XWJcxtEf9SW2r/e1O8z88An43RC5n2?=
 =?us-ascii?Q?mnGRm5zwk8q8lpbJ0WZF8h/PdcSJzFgWVMZZHxXDD6lRnUs5pUpQ4lJBa7Z0?=
 =?us-ascii?Q?b1WP/DugVUcdyhHFVBZYyOAbl6p7k5f8ljRZ3q2cwYrHElK28i/Jo160836U?=
 =?us-ascii?Q?Qi2JxgSBTOXr2Q0KFBoa0NNP/znskFz0HDVaAltG+iyXV/jabYG7G0IS9/fX?=
 =?us-ascii?Q?91B/amvC5sNlrz9l+bAq0jOzP1OJZ4jg3QurQjZ91TckgdZVDOIJE1++ULFc?=
 =?us-ascii?Q?A1FMtoav+F+keFdQc1YLlYHZz/btrh5Tc9jaaIWE4Jxu0myzmMZYnnHaP5v3?=
 =?us-ascii?Q?6sc09p6b3J7ZJyEZrgwiEBXFi9dGC6Lc38A1pBuIDKkoO2u97TCzD+SUvb9X?=
 =?us-ascii?Q?r9agm4mmzMKkkhBPtafGwTKQ0Vek7P3HKfU3X0EfEDtfkFzkOM/mYPCIRmff?=
 =?us-ascii?Q?1TAXduNfgR6Qib8tfx5EdPx744VJy8zONx3Nxxyxd1WXUWWc1ZZOJxIdkomW?=
 =?us-ascii?Q?gFCqQl+c73IsR3arZ8ZeEhXUqEPqwF7Qz1yErvgVzAb4WmCTQaVMHtMjRX/L?=
 =?us-ascii?Q?t8ZP755pwuzZNbIcVufpXRrCJa0OtxnZuhVymW0PJ8ghy9Q44XPX4+r6xzDC?=
 =?us-ascii?Q?AcvN495tly4kA+tO/zKhS9wEVIH42ev5Z9K6bumJXUYBBwZN7d0tkKR3e1UZ?=
 =?us-ascii?Q?B6veKoMA2pun9N0DxDWkYd2YXMt7fNZ2hUC9CAwFIHDqoCeoJ80F8NMVMsp/?=
 =?us-ascii?Q?prwnSqihMBTHCzEtj20gr3YH1QC51ZExP0vh46H/17VsnnuWu09SA7tu27DE?=
 =?us-ascii?Q?Kb6BRA9s8dXDKpDnSEeGTbnFUvtMQ/C1NLlVQBqH20oEnrx6VdLOFHMEbLjD?=
 =?us-ascii?Q?aB+Z7sRvdYooIvPOif4ZETP/g1KtkIOTfzOltiGWL6dSqcfkmX9ofxx9g+by?=
 =?us-ascii?Q?IA+6V5J6wIwbFf3tRMsvwE0Eu9aUXtI+g2nd5zN5jO/ANs6nBTn5cDUJOdap?=
 =?us-ascii?Q?AdZDH3/xCDEOJvkhwEYBW5pBhorMsVQ0eAfkYNMuNc7j7srjER4eEy5SZTWx?=
 =?us-ascii?Q?Iovn9PPb59d23ZifcmXFH4ioJjk1wOQvPf1HCrAkyboFNrkUOG1JzMcXZwrd?=
 =?us-ascii?Q?MP/fQSDNPSY61VLaZjwWq8R45dyOdWsN5Cu0Jz1m+J0VnkZtcHLL0hD7cs+c?=
 =?us-ascii?Q?1xhbpB1Rey3UzAvr0oKnr1vcoE7hROL8gq2WZ4lIkkwZ9kj444EcL5E2XAKf?=
 =?us-ascii?Q?zEVK4BGh2qIm8YCjdU4xi2VsWSlVJAZJ/OIA5LYbB4VxnFHn5v93mUjSY4V7?=
 =?us-ascii?Q?8g+AxECEG4hhgcxCvtVg0T66Chem4WWiIwg99qhgxiJfgN3FUDArc/wx0+ik?=
 =?us-ascii?Q?FK0/lSRBruN5NaxqSVGbfLNp7vKfI9m9prSDUdO/Smz7+Srq/gC2iOHiGzJn?=
 =?us-ascii?Q?r/3RHrYMB0TCle/nzUvGL+leg7TMu/39eZOQhcRbZ6hYgCfRgJOX1/cvgp/s?=
 =?us-ascii?Q?7g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: /TnYb6EBPI7Fv0XriBS15KcOq+5iKEeQGd4VZ1Jfi/HeJxfjrXr8PzpnYUn75EbwDGZzsnhZ6hGPxcOVkS9e4kYL8flm9EdIbfo+mio5H6YaPPVpW+31gAu8iJM8fln0kNxryddeggosBVN1C0ck0zdlRL6daHUPYB24AcUmYz6eUMiRvfMYjz2QcjfD14dUvEboTjA5mhrCutVX+A8iZJ7QAfI8w1TzvxBIs/OVHKC2cOtlZn1+FLJpI+KDI8rEGKhZQ6rEzxBkzCBcGyUvfZLxOrCLL48P29DXg3Ii+mckspGYax5NSSrjxJsACClUsURFk+cnLzzRn2cq2dCzQhArqtMHvXJnAfLmjKwZbyL0HO67zk7apwZff1DC4X3xnA6LeumAvtSN6b3W9RtVCpjUKeLjQvJiioXF+LHe4U/mPf7NMdp2PgkLdV+BxBbG/fdJWy9syxZGqLnzeVAI1bFAHR1qB+I5V8yglkbkwEfIQ9DZpErecvlaABAOX+2z5BC/XU4SwS7LXEqqx6+QveEpT9BcS3roVFZlpN1mKMODrqvPZu7Cwj8u9XQvaJjYct2J2R5dwtJjiE9sCgn4rKNAdiY4Apxop6MhBhDGDMXzI6w43AqboheJc4C2JE+sf44R3p0CVCqOnSoPGkyszqVyReZ3MjZQQAAK+RQuLHoZANZQ403xcGWnA/tadEWL0RxvhfTL9zp81sL1lwent+G+eWJHggDbCriI3PkSG5s/Kq8OuXshLUMhqLbFBjMdbOhKCmkTvY25CxTrHwTiG4VXFSI6Ca+nQQ0O6WdPZiuBxtY4o2IZWHiwZxGzO4Fi
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 392da61e-f4d5-4edb-ea6e-08db0d77cda1
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 04:07:20.7454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8L7qa7mTwh32zrlhyz41jDLH7uhKYj/qwMfaZqCeWg6hAjEnhQ2Qf2wZm5tTulHa8Sg1CbLzrgZqoB9EjLsnig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5225
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-12_12,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302130036
X-Proofpoint-GUID: 9Atrs8HzTQXwO-ronmbZ2ZOGsOFwVE7G
X-Proofpoint-ORIG-GUID: 9Atrs8HzTQXwO-ronmbZ2ZOGsOFwVE7G
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit ed1575daf71e4e21d8ae735b6e687c95454aaa17 upstream.

Separate the computation of the log push threshold and the push logic in
xlog_grant_push_ail.  This enables higher level code to determine (for
example) that it is holding on to a logged intent item and the log is so
busy that it is more than 75% full.  In that case, it would be desirable
to move the log item towards the head to release the tail, which we will
cover in the next patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_icreate_item.c |  1 +
 fs/xfs/xfs_log.c          | 40 +++++++++++++++++++++++++++++----------
 fs/xfs/xfs_log.h          |  2 ++
 3 files changed, 33 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
index 3ebd1b7f49d8..7d940b289db5 100644
--- a/fs/xfs/xfs_icreate_item.c
+++ b/fs/xfs/xfs_icreate_item.c
@@ -10,6 +10,7 @@
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
 #include "xfs_icreate_item.h"
+#include "xfs_log_priv.h"
 #include "xfs_log.h"
 
 kmem_zone_t	*xfs_icreate_zone;		/* inode create item zone */
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 63c0f1e9d101..ebbf9b9c8504 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1537,14 +1537,14 @@ xlog_commit_record(
 }
 
 /*
- * Push on the buffer cache code if we ever use more than 75% of the on-disk
- * log space.  This code pushes on the lsn which would supposedly free up
- * the 25% which we want to leave free.  We may need to adopt a policy which
- * pushes on an lsn which is further along in the log once we reach the high
- * water mark.  In this manner, we would be creating a low water mark.
+ * Compute the LSN that we'd need to push the log tail towards in order to have
+ * (a) enough on-disk log space to log the number of bytes specified, (b) at
+ * least 25% of the log space free, and (c) at least 256 blocks free.  If the
+ * log free space already meets all three thresholds, this function returns
+ * NULLCOMMITLSN.
  */
-STATIC void
-xlog_grant_push_ail(
+xfs_lsn_t
+xlog_grant_push_threshold(
 	struct xlog	*log,
 	int		need_bytes)
 {
@@ -1570,7 +1570,7 @@ xlog_grant_push_ail(
 	free_threshold = max(free_threshold, (log->l_logBBsize >> 2));
 	free_threshold = max(free_threshold, 256);
 	if (free_blocks >= free_threshold)
-		return;
+		return NULLCOMMITLSN;
 
 	xlog_crack_atomic_lsn(&log->l_tail_lsn, &threshold_cycle,
 						&threshold_block);
@@ -1590,13 +1590,33 @@ xlog_grant_push_ail(
 	if (XFS_LSN_CMP(threshold_lsn, last_sync_lsn) > 0)
 		threshold_lsn = last_sync_lsn;
 
+	return threshold_lsn;
+}
+
+/*
+ * Push the tail of the log if we need to do so to maintain the free log space
+ * thresholds set out by xlog_grant_push_threshold.  We may need to adopt a
+ * policy which pushes on an lsn which is further along in the log once we
+ * reach the high water mark.  In this manner, we would be creating a low water
+ * mark.
+ */
+STATIC void
+xlog_grant_push_ail(
+	struct xlog	*log,
+	int		need_bytes)
+{
+	xfs_lsn_t	threshold_lsn;
+
+	threshold_lsn = xlog_grant_push_threshold(log, need_bytes);
+	if (threshold_lsn == NULLCOMMITLSN || XLOG_FORCED_SHUTDOWN(log))
+		return;
+
 	/*
 	 * Get the transaction layer to kick the dirty buffers out to
 	 * disk asynchronously. No point in trying to do this if
 	 * the filesystem is shutting down.
 	 */
-	if (!XLOG_FORCED_SHUTDOWN(log))
-		xfs_ail_push(log->l_ailp, threshold_lsn);
+	xfs_ail_push(log->l_ailp, threshold_lsn);
 }
 
 /*
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 84e06805160f..4ede2163beb2 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -146,4 +146,6 @@ void	xfs_log_quiesce(struct xfs_mount *mp);
 bool	xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
 bool	xfs_log_in_recovery(struct xfs_mount *);
 
+xfs_lsn_t xlog_grant_push_threshold(struct xlog *log, int need_bytes);
+
 #endif	/* __XFS_LOG_H__ */
-- 
2.35.1

