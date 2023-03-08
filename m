Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF7FBC74A44
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Mar 2023 22:38:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbjCHWi3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Mar 2023 17:38:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbjCHWiX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2023 17:38:23 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9CC95ADC6
        for <linux-xfs@vger.kernel.org>; Wed,  8 Mar 2023 14:38:21 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328JwkmO018336
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=u8ANFXJemEPEl5G2uQUXpknnREMAMf1WLaiUz9lWhI8=;
 b=GaN68NMPLElFudSZjq7UAfs2Ia4vy3aHMyb073gIaqpoJkyEbSkWpb6+pcLZeV+/cadv
 zQaeN5NygKI4I07NzJGkWVNUqIvkEmujKCH58+B74M2JP1HnYx/xu3X54duJjvtne0O3
 YuNzUaNJlOKx1Yr3w/Y8BRafvImVPZ7WyTEwmQ0g4ipcE9XrcfMFrEm46NxOvH50Nr2F
 gZ58+DFXvpLGMVFkGFqbTx3zvR5kZuuEVWDtDvmreC/T6jCsrh9pbFas2gZMgFvkR4Tp
 BTpLWeaT892nVVbm472yN7cprU2McZ2KsAjVXZ8YDs9Y3OLbTufWya5iu8cU6UX+lwFB AQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p417chcxf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:20 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 328LwZ8I007136
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:20 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6g4gd1m7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dn8VwsptsyGdjslkdEquIGzQP5UtqnzyNnNMkR2ll/F4m/j9EjbfKpOz+oZleJ+myYqq9YQalL68jVuiHpKQZb0hJmObom5Q/dxTuFoK4yWeMYDU61XtGhfJvmz28WJnyIZ4FwX2dtoFs1k8M3ybw4Qcdo5lTfEfuwZuZWkKnawAvuyvWiHUXa8A1Ddj1LbbteQVsndgaSsZ/mqf7NXuSsuMYQqst2rvn7Dnef5bD6gAG/xt8y5SPjisIrfOvSugBZMd0blUoMde6iGx8I6Ngi04r2kMpLFpmiamHQCpPZjpxxTYCet2cwJ5ynKcxRZOuWRvZv1NLTS/lccZhXD9vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u8ANFXJemEPEl5G2uQUXpknnREMAMf1WLaiUz9lWhI8=;
 b=kVlj6POb//FlNZjPXRdSzuhNJpd8PbMM2IWr5gRtHzz5OZat/xnSJ6PQew2U8zThZoEegZTidASHou8wK4ZVmLMRGyWG10TDes9efOzHXMzQ4silaE9A2QyiE3bgQ9QRqYbMEe02+EvNCOu1TC/oxVcck7q6FpqynzOX6K4sz2gArasVLJrPylBLhSwr8XoPhkswK+TguIBbz7UZdroZznJo+bQQQq5Wv0ZeFlCrMgAzLGDtVvFRHVIYUfnKCBG1iRcLrxLjjHHZf0sYVTmH4BTpy8d/1kYzV5JYXXntuZYVvk0jptjxbz/jspiKWVyk/isD1nxD4B7cXnCKuFclaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u8ANFXJemEPEl5G2uQUXpknnREMAMf1WLaiUz9lWhI8=;
 b=DftVkn8UjgJ9+a+mTUyj6pzMs1+8YDkm6gSKezdihSRGPid1D7GgYlgzJs9zMxsQposv9dVIVfDkZ1gj5U1sBUEKKjGdA5xsJvGgEtNhiAn0q4fy83M077DAEEmasLMObhoAD4d0bt9o/FfGSkET2O57718RVn3dkM9kaPAEC7c=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB5708.namprd10.prod.outlook.com (2603:10b6:510:146::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.27; Wed, 8 Mar
 2023 22:38:18 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06%8]) with mapi id 15.20.6178.017; Wed, 8 Mar 2023
 22:38:18 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 12/32] xfs: define parent pointer xattr format
Date:   Wed,  8 Mar 2023 15:37:34 -0700
Message-Id: <20230308223754.1455051-13-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230308223754.1455051-1-allison.henderson@oracle.com>
References: <20230308223754.1455051-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0051.namprd08.prod.outlook.com
 (2603:10b6:a03:117::28) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB5708:EE_
X-MS-Office365-Filtering-Correlation-Id: e8a346fd-a1d8-4eaa-a0c0-08db2025d062
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lpiFawkHtbxHJUwmk86O11IJLjtUR8N0QrNPngQMz7T8VNpCM6CFT986lbEEdqhruBr+KULvICIMZd+t6DQmG1mHdFBqseo8WTPwZOceP5tTdcBT/sQAY0hm66DGdbU7PxnmCXTCCAP2b4o/rBqa2rRP5oBjz5SBqZ4YD+ilzdQak+/0H+8eohLOdij+uplj6SiQQVSvVluw8ttrhEm4P0uECBph3jIt6fWZcNRHSuZ649Vw8K+xEI0GPf5sU4xlVmo81jPgXFSI+q7cWBWdGBYMEHEobj+mN7bC+/4k8V/8ovr8nmqmG8M94zB4dgdgF8TDiA9xYxmZ5pJ28Se3Qkr59aalox1UvGB6v51sm8WyR2Toz83BcmxaeIQrMFF2Vctz/EZc3R5IDih74RDPBv3+rn/UHgzwNTDYYSZO/pMBf1C+70LC0dCkpVQ6QG/IzenMuKw88QJjTwF+meLT55pFURhw26ONDTA3MYMuk+RYhhdbieu2JIhHgj1Lj20k++a+3dYWAZ8IKwIfQt0xL0LPblDgDtrkGxM5ot0L4OTUvNTvNdy2TFm8ADAzCHf2Hsr7RWIiUJ9iDJHHYmWjPXRzNFYXWmPqm2qS7uMYI/SUm2GMysUNW1GxCRCLUkOjYnVUL+L4OQ+G9G2ZzbpALg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(136003)(39860400002)(376002)(451199018)(36756003)(6666004)(478600001)(83380400001)(6486002)(6506007)(186003)(9686003)(1076003)(2616005)(6916009)(6512007)(8936002)(66476007)(66946007)(2906002)(66556008)(41300700001)(8676002)(86362001)(5660300002)(26005)(316002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5zXUtMtDQU8RC4ipEIhIZKSyVeD1Ap8vaNNhS/r1z31rOyNXjUX+WyzHBPmJ?=
 =?us-ascii?Q?czA3A7FDLwwuqpAE3C6EIWJK8TXZpT/pXmHisp36MCz53l9bfRc0O/7DORAJ?=
 =?us-ascii?Q?fi263Z8cfJflxrTqJwC9/jwChOgHsFdvzKL7OlW0+6eHwCKIRaeg2xR67nx+?=
 =?us-ascii?Q?meuGShbR9AhcY2kWEKFSVW4C8HLAdSMaq6dDoQFaCvXC789viy8nH8cQE4JX?=
 =?us-ascii?Q?ad+HAlnbhTgnSuRR/hfib5OzWgXGjMm7y93NNjVATqvjFC9qY3smfJbrKhqu?=
 =?us-ascii?Q?TrSRZnoGof/1ODsZlJDWQAh8yAWfYgnUnnj87tsOWBjH40hUje6/IBnzcWx2?=
 =?us-ascii?Q?+GxB9boEyYSrDnU6+w+oZhXP1UbJHJFVobSEztZjfh0roYdwEs8JFg8nOfRB?=
 =?us-ascii?Q?KyZzAzYNzsliqXAkqTn3oJ8gwJMOcu5tiEXU4mUDqhegbl3pt+fshFb6KT4d?=
 =?us-ascii?Q?tbMwJNTHBfDV/2w9EpUgFU1qdCi7HHi1iDLhMte3p8e2RQ+eM8AREuVjNYq3?=
 =?us-ascii?Q?BC1hBMcShENakqBG1dp7EaPWkH5QEECkvtqw/B3fZmRdT1yhvoHBH7ihp/53?=
 =?us-ascii?Q?eQUGuD9WrRd/nNWzcqZLBu9AgDmHOVgzQbdErF9vVAG1SHHDrNZBI0PwDzTm?=
 =?us-ascii?Q?gH1EheFnEQKilrh9zHhVPGg0HeXOfKq1Sb7MD3zvS9KxHTrFwl7a2I1v8Qhz?=
 =?us-ascii?Q?dfSPFcEoiESq56p9PMvcBEIc75XtG+aBI4NZfj3HiYamJeSlgZYpnwfAjYHS?=
 =?us-ascii?Q?176rr2V4DkAC5512wtw4mt4TY4AhdQnBYUeJx5EGcY9MHv57fr0AIDfosGj5?=
 =?us-ascii?Q?o2MqGog0EDa3LL2O+2zHZWlBov0YazZT+FNHCvV7dMaB8vqH1KlLwbMrSntz?=
 =?us-ascii?Q?RgUAzFe8vtdn8kc8wI5Warpzr1MyUq/PDjXCtPBFRI5j9OJbPYknGBgVEI7/?=
 =?us-ascii?Q?y+cMD+xPmPP5y+snFCzvh6qLTkcHph9g+CtCa8ATVd3+NI8mNfvK1DUD81U5?=
 =?us-ascii?Q?hBL+7P7R6M5jlm91a+0DXxYzUvSz/jNaLKOys4ejxn5PxyqIncVwBck7QsEi?=
 =?us-ascii?Q?6rdTSawFVoKTR+SwfkM5Msm8oi/s9+Skni7i8ktsx88PTqWihpqLkvU5I6sS?=
 =?us-ascii?Q?oxtliHSi9mV/6AJQEKe2VD3GWlAgDjzzvyfiQ3DP2rt5v6iGTvqdL3k6gOWC?=
 =?us-ascii?Q?GzUfai1CD+sd9nFgLvB5Ppw5Y1p4cQc+Fjkb/AKIOyp8E+cQ0DebQk3E1g1/?=
 =?us-ascii?Q?vzqPInvJkGQWly6syc8JRiWecGUylddmHiYJ6ge+XM1qUAcwAOJcV7c5uE6r?=
 =?us-ascii?Q?xGGUbEJhJ2YTbMj3hUFp5qbxOO0bOKbOJ+lWlvzw3UVLjuLxam+16nXf/e17?=
 =?us-ascii?Q?Y05IJRgAee28sMzgm5KIt7auj4UzIAT6SMGEhmoXyhoIo/VPnnljoIc+OAIQ?=
 =?us-ascii?Q?0gp5l1GPuwhfcuFXB5NBGpt7dm7D1v8IWbwpzF1jXrmbBwRakPGTw4okm9Ds?=
 =?us-ascii?Q?QyuIagMVEYo7/om/p2XfWq6RWOkCBinABQUJUQQYTIYcI7Fi1+ZEyW3ChDsg?=
 =?us-ascii?Q?6WbDETrWM7BoAiQOhbMg9AbL3WBiHZtJj4sAZ3yduq2xs7AC8PlWPDNj/x0t?=
 =?us-ascii?Q?wQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Tytdpe6SQ6YLU3i7sNbsDmygXP+JVwfe3kiWm6JksKXqG2u6z2/QgrlTCwtBqzeYEnaXe0qZBnR3TIViBjg6mB1g3aeL7TpRFF0hzR6kmkvLe+qUXJzgPamFmGVEsNphwVo7AQz6HBFBQVwO20OoGItrkHBpL7b7+27aKzFaxjmeE7By1fv2Au860HMZLu9pfDTELg/BmhQI93/6+GLK9HyZOk18XkDUA7VwQWgwqjL5wik+HBcw4xJTHwvxRZeKP9as+K//A9UOwaYx3Hd4gHQikUw7wQdnr97vmrC8383Od6CYPphZaAC5YltxYY2K7xNcVOlylXO5OxGMh/OCe5EjJBweHcFzJ3xj2Bok6IzZwcr2S844Oy37YGTgL3KmIOZjMgH9W/exJvAKbjXxhRohWe92IAazIRU6YZ6h09fQfclfrp19MlK5YCFPWQC5vJ64Qg4eRBKesXiRIqz0grGDQv8bs+dcu2sPbb4YDVvS4T4rmbz5c8IiZppIZtSyKuY783HES7hQqStzArVSWFZa/0aHGkuJzMZvzI4+N5t0V66txwvPc/NpZs+5yL38MDzUzGWgk9Xxye2y7b8emMLBlQ9+Jy1fa5vdftoJ3KbsOLQQxjhFWfXygBfKdoh56+3QRqdWwYjnUsPGPZTVmt3cww3JPkP7DA4tj8PfZ45NdHRJuyAwV/bgOfu7tohROfHC3J6yWb9AsjsLNoTCDfOw/WoEfRtQCNVO0Y4ltHBsSxrrXPK0uAYNuhdqwd35VEZIvyeIbhpO7n3+p1rkHg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8a346fd-a1d8-4eaa-a0c0-08db2025d062
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 22:38:18.6935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1c6btuXn3jdEPdvuCj/nWiwK35XgwhRDDjS3/KK47OGcp158+XRydidpLee5096M7GMpfWBKYuO3zxGHW1sdxqCY5L780LC4jaY9W/j7Y9g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5708
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_15,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303080190
X-Proofpoint-GUID: Y7jgHQ3exkjKyLHpTisw3nmYHbfExB4X
X-Proofpoint-ORIG-GUID: Y7jgHQ3exkjKyLHpTisw3nmYHbfExB4X
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

We need to define the parent pointer attribute format before we start
adding support for it into all the code that needs to use it. The EA
format we will use encodes the following information:

        name={parent inode #, parent inode generation, dirent offset}
        value={dirent filename}

The inode/gen gives all the information we need to reliably identify the
parent without requiring child->parent lock ordering, and allows
userspace to do pathname component level reconstruction without the
kernel ever needing to verify the parent itself as part of ioctl calls.

By using the dirent offset in the EA name, we have a method of knowing
the exact parent pointer EA we need to modify/remove in rename/unlink
without an unbound EA name search.

By keeping the dirent name in the value, we have enough information to
be able to validate and reconstruct damaged directory trees. While the
diroffset of a filename alone is not unique enough to identify the
child, the {diroffset,filename,child_inode} tuple is sufficient. That
is, if the diroffset gets reused and points to a different filename, we
can detect that from the contents of EA. If a link of the same name is
created, then we can check whether it points at the same inode as the
parent EA we current have.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_da_format.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 3dc03968bba6..b02b67f1999e 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -805,4 +805,29 @@ static inline unsigned int xfs_dir2_dirblock_bytes(struct xfs_sb *sbp)
 xfs_failaddr_t xfs_da3_blkinfo_verify(struct xfs_buf *bp,
 				      struct xfs_da3_blkinfo *hdr3);
 
+/*
+ * Parent pointer attribute format definition
+ *
+ * EA name encodes the parent inode number, generation and the offset of
+ * the dirent that points to the child inode. The EA value contains the
+ * same name as the dirent in the parent directory.
+ */
+struct xfs_parent_name_rec {
+	__be64  p_ino;
+	__be32  p_gen;
+	__be32  p_diroffset;
+};
+
+/*
+ * incore version of the above, also contains name pointers so callers
+ * can pass/obtain all the parent pointer information in a single structure
+ */
+struct xfs_parent_name_irec {
+	xfs_ino_t		p_ino;
+	uint32_t		p_gen;
+	xfs_dir2_dataptr_t	p_diroffset;
+	const char		*p_name;
+	uint8_t			p_namelen;
+};
+
 #endif /* __XFS_DA_FORMAT_H__ */
-- 
2.25.1

