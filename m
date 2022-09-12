Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D560C6FA83
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Sep 2022 13:28:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiILN2l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Sep 2022 09:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiILN2k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Sep 2022 09:28:40 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B85E72FFEB
        for <linux-xfs@vger.kernel.org>; Mon, 12 Sep 2022 06:28:39 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28CDEUf0030583;
        Mon, 12 Sep 2022 13:28:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=PtZk6Md02YUGihWflXrBBk2bAh22V1q3skAQPVFhO4I=;
 b=jVP/JX52F7i3fok1RrrSqp1WjYpR2ChHb9a15jknssyLPnp1Jo7s/fOCNFHwSwNuCoAU
 1naNZfYI4Y76y6ociKSyuXzwuKlesu+PRdXgDjsQG1johBHSHVomt0Xf3YesDrZx3NqM
 zHJN3JVUsLG5rNRUd/5wR7TgMKwyhbgrca8vEbU5fUB06sAE8Xj2Y1EYGw+D1tA8dNGe
 HU1D4OKIx+P0ACYiexpv4pPhO8y0LP71YnqF39UyX7ZAth/ElxbazMfEPFnbYAVBYkqM
 Vxnwr2E6Dlz/gPKADswrg4nYi30RaP2WQTmxLASvx+ZUVFvXaWX9jkNyjHRpMXLh4yHo Gw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jghc2kgt1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 13:28:36 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28CCEgju010223;
        Mon, 12 Sep 2022 13:28:35 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jgh18tqxc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 13:28:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oe1j7LBW3nRzphnn4XoO5F/3btvfUhJIn2Q3Tcr8aM8Gw3apJsQ/pgNy9xotA+lZoWE2CVIwdVwyyIAdtr1oetK/YFd/s0OdIbbs1BN7kyR3xo1q3nMlwt1ucO0HCiJ5v8s7cdzxBAs8z7FJ9kU3XNoymU5qj6lm19NUjnzVe4JY7ovyFhSQ0sCafooNvbldRh5iN76Zt0NGEWjKJ71xSmj9B23o/jITLE7Cc1qfDSm/PtbjEw4WqT5/Lk4wC7j1cYRcZ4lVZd1At3JcH36AabSJKQdmO820YNq9wlUbnySd6+oaR5hQLAIH1qGQmbBAnX1XmE83enwQ6gdh2WZonQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PtZk6Md02YUGihWflXrBBk2bAh22V1q3skAQPVFhO4I=;
 b=gT4ju3mmz4UOCQUxlnVFNAmpB/lZIrz8SdCbi+bWF8fd5ikHvN6fqDdbrB4YEfdo93odK61e9JvBgoGu8MQvKzxtnVZLMNOvdS27eHsICF8R/z7EVTn7O6slzpnTJ+WecOGPHSxQqspmN+KS/Ym59VeZXcV+zq+bjvqfK4nkOlp79QEajLJ7zEe4rejElgdCgGZkQ3xfpHrVjRE0MCKFiuHHGFV64uBalO3qRZWX1sIcmRT3gyzgNFty0ACc0HZgIC1GU53+0gL9847NziM0ki0NGxnRaaxmXYbDSTlFG3DOTe4elC6KuQUrHxexQ2edjIR9aGd+0AnOWBtM98d6FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PtZk6Md02YUGihWflXrBBk2bAh22V1q3skAQPVFhO4I=;
 b=OCdeHck2duvpoRHnMWPGryps0GJDzkYAvsFzmLcg6TvC1mObMGSWlNDdNfr+FP4AWpyYRV/ubRBtMSACeKNZfhNQyuhVKxx9J4oJHZAqhPKHMjqbZTHDucmgPzhuCQoVxCCUAjgRNZlTTM1YwqSkY3KKbH7FNB24WMyg2Vkaqyc=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SA1PR10MB5888.namprd10.prod.outlook.com (2603:10b6:806:22b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Mon, 12 Sep
 2022 13:28:34 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::709d:1484:641d:92dc]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::709d:1484:641d:92dc%4]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 13:28:34 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 06/18] xfs: add missing assert in xfs_fsmap_owner_from_rmap
Date:   Mon, 12 Sep 2022 18:57:30 +0530
Message-Id: <20220912132742.1793276-7-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220912132742.1793276-1-chandan.babu@oracle.com>
References: <20220912132742.1793276-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0025.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::13) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SA1PR10MB5888:EE_
X-MS-Office365-Filtering-Correlation-Id: bf664f48-692b-4857-82c9-08da94c2b137
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /yNPgZNvOsQQQFZ6m9IQhlsgiyXM+MNVsXYiBjlM4KsJdQEQRhp3/nCxG143afXTpg0kaUyYJcwLTc4scVsLzfcdzl6TMHjY3o6EGwS8mcM5hIdrMsN7XSe3WDW2quilOClljtWRAwFPjF14iPEZock/u/xwV1TjKf23pa68VNQ3FOX0BVuBN/c8XTKQUqykCEpwp5nqt5TK2en2yQNy59ym4/qyDQp3XNYUFnyQu8DcGzTVucC6OMvkUDQEaUqBrLhoM+eTuoJDUvVRg9a2D1T95IBlS7Ow2m3uPd5XzIJa0rGHVM/WkKPovi/lRHd40+lCXEZWzInf/NRfx8oSM5mDK2H8w1R/wzPp4UeA6jUtWGWJcmrSZVke5sHf1J6Eq5lqGEwK2Yz8VuTBnEtsEw2sXHukvWHBF/pRFHb3+mCTt6zz8NFGNUldf+h+I3hKHG08EFqQ77E0BulZjvc5y7YfBk9jOHSTGTWc64Hbbc+Tf9Y/NKtMKn/OzCNvsC91w7jPInh1W4U74cxW87mkxGA2jmdnJKX/XSQ1T8nWCiQWxjZdvfRPCvvnhllyk7uEHLrIMu4LeX0co0Ip1TqmAb8CYdwKcrHCfcdoHxaZ9mIyl8hhMK/I38yvoyG9CvlSKl2zZ4Ro2lPFIb892pSU/gO4gC/0w8FAO4+ay0Dk9ah2S35pHEtHIii9RIc+sPt1rmdTjd9/ubwEbNqe5aH4Vw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(396003)(376002)(136003)(39860400002)(6486002)(36756003)(316002)(6666004)(8936002)(6916009)(6506007)(478600001)(41300700001)(186003)(2906002)(1076003)(2616005)(38100700002)(66556008)(26005)(6512007)(66476007)(8676002)(4326008)(66946007)(5660300002)(4744005)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yed/8alAKcM6LRMnd75j0DUCRFapUmkt8T8cF1O4cFMK63EF14aXdxyLs5Z7?=
 =?us-ascii?Q?Lek2bO7se5LQMbikNC2DmqHUmg1U4AOQztqWZEX/VY72FU33E8ZTVNtMji/l?=
 =?us-ascii?Q?nyqPD49uuXfscF1/6+89XI1T7ZL1UJ6clSo8kl4Y4VvOkR998YNdFYuRV5Vt?=
 =?us-ascii?Q?vs9eENoq/j3woig5omHLs7sXGGIRcEPt614OtCsaQskXL2okvSnV0HNreZJB?=
 =?us-ascii?Q?qqeSy10S++uzHEev2sRdE1CCcYzjzrm4Pe+ZMnLIsX8PYMYjfj8d5PN1lWzg?=
 =?us-ascii?Q?dgCvSk8FvSXcGOCe1V5juD/I2thwv5u8CEYMWZAZnnY/svNpLziK7ZWa0JNg?=
 =?us-ascii?Q?wO37cmwVl0MF4mZegv+1Kz0j6q05y5+vgs3tQDky2i3d524c3swPzv7i8mZH?=
 =?us-ascii?Q?JOWTTOMh65ZKU58x72q6I5lbhNJYXHIl5PkNTGzm1PewMgxoYjVtiTUbSV9Z?=
 =?us-ascii?Q?JvX0WycBCq4yFuoNa68Zq42oNNOTUCRPvRo0iKimo3CWkiHLnF59MoSU3BeS?=
 =?us-ascii?Q?TqHC9wVIk2p+Dw4g6JE52y3OnyhqTnGOvvuXtaqu99eOqZtISUM3/UiV7h5y?=
 =?us-ascii?Q?bn7TuNe84Bc1eiWF3Z/JlO3I+yn0F5nsulHXcilGGuDdI9JV8z9Dy+wYy51S?=
 =?us-ascii?Q?u5cNdswSbXMrFZ79CcJXzdGr6scPHSApPecJizNR/TA7T9vFu96HCnP4haRh?=
 =?us-ascii?Q?dCqzwofnFI7HdKUsrs0yv36GvzLYbULcupCipGPONbk8S3KoogIrhVDlrhD+?=
 =?us-ascii?Q?3adVrOO/7Vm/GgEMYyL1UahgVlOxbcBB3TXuhE+T84MEqoJiVnhmRJUHS0Yh?=
 =?us-ascii?Q?3XwstJztZmXX7C8uGQjDwu8ufUAbbKSu+XfPA10CHO0A6KatWqb0hOAbjl0u?=
 =?us-ascii?Q?P6/J3SyEuI+L1tqU2sIeLSZ+UwHkK66Tb386gZqpe5A/iG5LsyEU/BBdU/ef?=
 =?us-ascii?Q?a5yY/ZkGrqCdlXlEwE1tN8Y9iMzGC1URfvBrl6fYCtYS/hrCPcyV17C0ztQS?=
 =?us-ascii?Q?YnEaxsD080mRESdGiZ4qITrJXdWCxMYYXVg3JLVBjtpItsokp1rrCjL+PE6K?=
 =?us-ascii?Q?zw0w4wyuDGblThTHdRZWZ9bNG+CnSexvB3sZCxry4vKZTNJydx4StIndEZ4F?=
 =?us-ascii?Q?dKbeXtXvftDWs/hUuwutFfmF20wn4SZtigUEYorKboyi2oKY7pEgwtsA5DVQ?=
 =?us-ascii?Q?iobZzGwwK+EafPjIeIUVYZffwlqTiD+sXoBa1nfmMsJ4rBYwjKgnZTSgjj/s?=
 =?us-ascii?Q?15sJvoEsDcLGYQzJ/vkHiEOe6I1pQ6PJpZijPNKLgH3/1CnME1/XBafKFp5m?=
 =?us-ascii?Q?MAzkU0YstGRNnD0YkIIohrw/0XLHnUYqn+plmITy48QoF/ik3euubrJz5F3T?=
 =?us-ascii?Q?wf4z81ucFxOch2HKRiDnrkeBNBYsCkv4g/gqLCCXCTecpSEc/2h8EQ+RL2yj?=
 =?us-ascii?Q?YgrmXb1IBHPSGWkb9YBnZX4xBvuU7xkzIazwZnDbruUCnUt3ZVGmzzf8X+HR?=
 =?us-ascii?Q?CPKLeknjRA+zRWGbPsicizebra5la0Nq4FBgo2s/eu3zxt65jw8d8r3fyxvk?=
 =?us-ascii?Q?KjedlWDUY07y8RZnhM/2N6471tryG/LpRlkcRFfjeC731HUXhPbep0egsNL6?=
 =?us-ascii?Q?3Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf664f48-692b-4857-82c9-08da94c2b137
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 13:28:34.5055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j1wZ6SGTXW8vFZ9YOgPaQqF5E05YS0VKa9g8dnbXR2+Nty0Lj4DaiwEiGj7LFRTsnvChjWGvB4l+nvWj0x7VMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5888
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_09,2022-09-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209120045
X-Proofpoint-ORIG-GUID: l-l_t62BQeER04QRoO-kVhG-HkLjMlzx
X-Proofpoint-GUID: l-l_t62BQeER04QRoO-kVhG-HkLjMlzx
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 110f09cb705af8c53f2a457baf771d2935ed62d4 upstream.

The fsmap handler shouldn't fail silently if the rmap code ever feeds it
a special owner number that isn't known to the fsmap handler.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_fsmap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 01c0933a4d10..79e8af8f4669 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -146,6 +146,7 @@ xfs_fsmap_owner_from_rmap(
 		dest->fmr_owner = XFS_FMR_OWN_FREE;
 		break;
 	default:
+		ASSERT(0);
 		return -EFSCORRUPTED;
 	}
 	return 0;
-- 
2.35.1

