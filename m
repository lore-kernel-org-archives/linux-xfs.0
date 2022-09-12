Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22EFBC6FA83
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Sep 2022 13:28:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiILN2S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Sep 2022 09:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiILN2R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Sep 2022 09:28:17 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8457C303EB
        for <linux-xfs@vger.kernel.org>; Mon, 12 Sep 2022 06:28:15 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28CDEL2T005969;
        Mon, 12 Sep 2022 13:28:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=4Zmy04lYm4DR5n31c6C23WYhwaCLSZddkNq+TuFxiT8=;
 b=2dguN6Ppz4v4jMGHP8JP7XQFw1REEy2t03x+5rk5AqOp75tKRv8wPwCvsj50oXvKnzH2
 8khkHOLmRgNE+4dL/Thc/rQYXSq+AhQjwxNqGwhwRREsHrgZNXIigZd9cj489912APtB
 MckIRaKGHuYWBdrwSYeexG2CEeHfHKfUrodUmhOmT1VR2kKXHuhzgbB+xSC2T402+NcD
 Z2a8YN1Vr5lJf0bJBmNzpjoLG7S/VlvNECStwY5rwckdmu+LczA9hktquhA5jwCEX56v
 fYMc2qINbF/TvhrIO1fpupY9C/Ct6DtEKhUVVpYHDUmvG+bXemxv4pDY/fdiUbmeYXEV RA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jgjf9ueax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 13:28:07 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28CCEg8i023734;
        Mon, 12 Sep 2022 13:28:06 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jgh12jayn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 13:28:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TATMUSy5xjMWDyu1ThvwRA3lBW37IzGtazyTYs3+bFP5zt+WPJ+ZjHzRHNz0YNNlc86Wf10e/txwcX2eh/xVUx91kuJi9OWRH54qmVcjDLhOhWHWOcZsoAQvhVLCr9yf+CDPU/prTE5lYcuzqddNkyL6tTkm/k6UH9MfvE5T5s4uxIfBGTiYJqJuxSVxiTWNv0X2Zgf6O6/hqpoTUSUgvmoyew9kv0EUuzurt4s+w+NoEo4ZKIGn926EliVtM518lnYz2f3WMOgRYJrLnuvfAVMOwvGaAZa9r08UMXWhg/79nWu6YLJlDj0XDxg8ToKZKRYub4BUlC4mbkjpMznT2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Zmy04lYm4DR5n31c6C23WYhwaCLSZddkNq+TuFxiT8=;
 b=mAHw0npxx9lo8SmNyX5nbrWqc/m0ilVSlGBfV4SsjJGA860mXpM8aAXh/GJmOtoc3lHfQjJeFLnGnNN87PH1i8gmCJEucAmEnoFW9q4NagvU037oBQntvRGHqx081sbgeK+nkSb5IO4vt7RufKdz7l49sSpK3ZU9oaxttmSQb561N4NnN8CuNiXpOVzERA6Z8hBUqEJgjxzesc4lsB1Q9SCW1jwFUN31LzniXVhaGxqirlL3rnFyW1KYAuCU5Z4opzBDBSlpJYI446IY89TUI0Y0zu6BeeOUwOYoAU8Q06OsXL1F4Xn/G1ChAheviiUSle15etxthb0or0PM31A9jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Zmy04lYm4DR5n31c6C23WYhwaCLSZddkNq+TuFxiT8=;
 b=ACZ1qQLFav6i7W1cGbuzUPdglScXa04QerwcGFINWmKXJ6yPQLvkY1dBGyrR7Qn7zcuf2vfkX7NPmSDK+6FmKOa+CmMBeeutdG+twOz8EA4eQ1LS8gXbJURcmGiKFkEIww187BJ4ynoTJrxm0DUEBFTuDy+OkcV8iYxmHCp1Z5k=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by MN2PR10MB4173.namprd10.prod.outlook.com (2603:10b6:208:1d1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Mon, 12 Sep
 2022 13:28:04 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::709d:1484:641d:92dc]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::709d:1484:641d:92dc%4]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 13:28:04 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 02/18] iomap: iomap that extends beyond EOF should be marked dirty
Date:   Mon, 12 Sep 2022 18:57:26 +0530
Message-Id: <20220912132742.1793276-3-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220912132742.1793276-1-chandan.babu@oracle.com>
References: <20220912132742.1793276-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0224.apcprd06.prod.outlook.com
 (2603:1096:4:68::32) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MN2PR10MB4173:EE_
X-MS-Office365-Filtering-Correlation-Id: 0eddec32-e555-4357-65cb-08da94c29f43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jliWKJzwXgpHs+pYYvHGSNpS7/aCAI5TtvKW7KhcUhLHGn8wE5pP0Z04Rlh/Lr3lrOU0LLmJRJTVPKSvG4NwugfNuRMeI0yHGgxKX9S2p82bFMh1UJPUqijaCwmAfIpya7CLU1EnW9Ea/pMjLJBnXYgf6IWWj0gwTXNN/h60GwHzbQNaHSy48CZJ/EoRa1U1iaOiC2XGMGAbahyn+JVZGH63jho/IRkNiaZobFh0slJTFG/bMbf5v/EF33hhrWoMg4O7uoNPRToWfdY7JD9g3dOF6B8C/QD/wagpXDUJLjGyYjt0ZhLNOP3+x5ULWS3tcbCX0yMAV2M4gU5ZNlKDXceyuYVgsvBY1FuD/9l04b5/4SXKtIZ6nKhcJe6+K+VnL0Q22qwDmG57WJ11Ilap6l63YuuORV3IrhOKNh9Yanp3NwjV82MJZm2Xvk1Slrx2WO0OvOQe86rJctM8jVeNyIk9yipAUGbsPIuEbFetuPwFHrDD4b9TmwEfKe4JO8kv6bACn2jkhPijoSw6rxsKTr7p7mIqLXrsTbuPWRPoChQJUyNac/E2Uy5/rZ6ig0bg5u2kOGbMzmsbfxMlsa13zFhDXt00DzVis5L03A1bIMpYc4VO452sTactHQwK/1JDxyMynS713o5SDymPVMTUP8eI+squFwf7tZUn/rQZj8lexQ/ktOYMZ4hnHl+ZTcG0v7E+ZXGh+c4ZImDsraUN5f5AJ2Q9/+nXVtG3U4eZtV9Yk+mrGtZDUzPJsnybU2PE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(39860400002)(376002)(346002)(136003)(316002)(6916009)(38100700002)(6512007)(2906002)(5660300002)(8936002)(66946007)(66476007)(66556008)(8676002)(4326008)(186003)(6506007)(2616005)(1076003)(478600001)(26005)(83380400001)(41300700001)(6666004)(6486002)(36756003)(86362001)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ttlmOyxx5qZcmhLjCOFwbaWiCj+I9uG31N/OaOjjcbbdZ3UGYRfPwMs44qEB?=
 =?us-ascii?Q?0dvzFjwcOayrnjLlY5+PTjdbkmJgpexsv+18czqd3iWcRkBXujTa1PMz3G2Z?=
 =?us-ascii?Q?SOmvBlwgquAZN1Jszpd3Y38z7lhAo7V2BU8TN04KYXc5dZZTAqTw9m8GelBE?=
 =?us-ascii?Q?BxGiS7icHFVIwwUOCGJQ42fkTrG/buR8l8V92bpstFBULAaqhAy6tRAZ0dai?=
 =?us-ascii?Q?f40Rj36CwOD9RTVs3IpS86409EiOMamUenTBtaFT0TE1lGGy7XPB7DkSMd++?=
 =?us-ascii?Q?6U+326/SLFlFp+QDBaJjzNjsdUaEXN+rITnAOpeMGdCqDmXBN9RJ7jMhGbC7?=
 =?us-ascii?Q?IdbrmT4/9daHOcHmDZj4H7fdUc2K1SC7Plqb9fG9n3GpBPEt0Z1KoT2kd/wp?=
 =?us-ascii?Q?RiWTkgiOWrW0SSb4mHSwVdfJM3Gc/MrQhvOs2r2vmRP34JdO+GgyNuDlqQbX?=
 =?us-ascii?Q?gWdoQ3S7ye5PtOFTEzf2sITPjHR9NYVJV99cZVql98cQd03WfrSVt6/eWe61?=
 =?us-ascii?Q?U1g3WN2w4XSVuFS3UXZy4JPaxjlfkSTDYxItg5u5juzhtBCs6AsRxMxB0riP?=
 =?us-ascii?Q?NsrB7bHOvN85/HcKrlfzXJojwECRdpkl1xRPNuvKdH8Lz+f9ZJfcVkGPTtmH?=
 =?us-ascii?Q?1fNwvlvkkNlAlJtj+pOBh/4X6RvoEnwCrPFHoMb8tY33FKU4KnjZNBL18BAN?=
 =?us-ascii?Q?sa+ghN9R7BlH8EgEYfG3vrtM2AlIQeDZejeME9/Kqgfmcap8nciH2s/IbqLs?=
 =?us-ascii?Q?7Jovkpf3c4gSDk3+pf1yy0e64MrQ75HJ09UfAN7bOyLzYRfgnfVsAuPzR7yJ?=
 =?us-ascii?Q?tYkwyWyRCYiRraf50tnMDaiJdujkC5bZvFH22rz0+XLDlGYjghZ016Ct0Tja?=
 =?us-ascii?Q?nJfGg6Q5KQjTF8ytpphN9cPgILgwTlrEMNI31XhDxczpgP2EuTA4LtgLi3GT?=
 =?us-ascii?Q?dS/n8aDIZKDut2lDqAjh8ia37/hqgbZLyxlTgd5oNFYAqPW5fQDCzHU24KK/?=
 =?us-ascii?Q?Xc5F+opGB/v/Vu7vKz60gLKF1IEW58d/mACeF3E10bOkbTp3veCjezs+dYs7?=
 =?us-ascii?Q?jD6rNzzBuvKJ54UDZgIbiCXBtrCHfRoC9/0+n5PFJfvM2DLnQUwB9HYQDwXo?=
 =?us-ascii?Q?Up5FLf4V7fejNLRVx5qyZW8sUxudGKPQzLULtjy/h1RxrMx9m/ueSlnlHqlf?=
 =?us-ascii?Q?8wGItYM4LRV+qmGm3T3kbkCsbmAn1vlaxcSta9nq8ZDmDlNZE5RBym3arrh7?=
 =?us-ascii?Q?funbSa4wkYgo1uYQA7JdU8F0zmoZLPmceZUOqlUc9Y6gShpDls9PStTcpqVH?=
 =?us-ascii?Q?E/rEfKt++PwIJjHxtJkrECYAU5B0OpnURlyvO77v4jRazakamTId3Xo8t179?=
 =?us-ascii?Q?6SD8B3r3edUmKrZeM9Zx+94IDUCIq2B+Pr9Sb+rN9D8fPfX4jq50H1uTykRX?=
 =?us-ascii?Q?UjlcltrOIib+srEZj34Tk8pRPS2bOZzn9ESfIG3vhrbITA7KDimMAdgO7h1t?=
 =?us-ascii?Q?sUP6ZqfN66EptyvI0FtjhJQ9GzN9wmWCgl0ijj4b5VoPqq8LUQ5N3BpZNT/d?=
 =?us-ascii?Q?oh23HF0kHzNitAm847FQJu29GILTPFgCkfsRwzUgLx8R3FDkaYW2nl5j0J9J?=
 =?us-ascii?Q?Xg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0eddec32-e555-4357-65cb-08da94c29f43
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 13:28:04.5719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IZSNF6BFoC0uiGVWD4M64OhUHMARjpMYg52FsWxkf1WBhPdaZHvAX/z4YVksEV2fgyo7BsztnHyYuhWccR0Cbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4173
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_09,2022-09-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209120045
X-Proofpoint-GUID: YtvNd1-pFftym6kbVKAZ-zXXip1Pmu8L
X-Proofpoint-ORIG-GUID: YtvNd1-pFftym6kbVKAZ-zXXip1Pmu8L
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

commit 7684e2c4384d5d1f884b01ab8bff2369e4db0bff upstream.

When doing a direct IO that spans the current EOF, and there are
written blocks beyond EOF that extend beyond the current write, the
only metadata update that needs to be done is a file size extension.

However, we don't mark such iomaps as IOMAP_F_DIRTY to indicate that
there is IO completion metadata updates required, and hence we may
fail to correctly sync file size extensions made in IO completion
when O_DSYNC writes are being used and the hardware supports FUA.

Hence when setting IOMAP_F_DIRTY, we need to also take into account
whether the iomap spans the current EOF. If it does, then we need to
mark it dirty so that IO completion will call generic_write_sync()
to flush the inode size update to stable storage correctly.

Fixes: 3460cac1ca76 ("iomap: Use FUA for pure data O_DSYNC DIO writes")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
[darrick: removed the ext4 part; they'll handle it separately]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_iomap.c    | 7 +++++++
 include/linux/iomap.h | 2 ++
 2 files changed, 9 insertions(+)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 239c9548b156..26cf811f3d96 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1055,6 +1055,13 @@ xfs_file_iomap_begin(
 	trace_xfs_iomap_alloc(ip, offset, length, XFS_DATA_FORK, &imap);
 
 out_finish:
+	/*
+	 * Writes that span EOF might trigger an IO size update on completion,
+	 * so consider them to be dirty for the purposes of O_DSYNC even if
+	 * there is no other metadata changes pending or have been made here.
+	 */
+	if ((flags & IOMAP_WRITE) && offset + length > i_size_read(inode))
+		iomap->flags |= IOMAP_F_DIRTY;
 	return xfs_bmbt_to_iomap(ip, iomap, &imap, shared);
 
 out_found:
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 53b16f104081..74e05e7b67f5 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -32,6 +32,8 @@ struct vm_fault;
  *
  * IOMAP_F_DIRTY indicates the inode has uncommitted metadata needed to access
  * written data and requires fdatasync to commit them to persistent storage.
+ * This needs to take into account metadata changes that *may* be made at IO
+ * completion, such as file size updates from direct IO.
  */
 #define IOMAP_F_NEW		0x01	/* blocks have been newly allocated */
 #define IOMAP_F_DIRTY		0x02	/* uncommitted metadata */
-- 
2.35.1

