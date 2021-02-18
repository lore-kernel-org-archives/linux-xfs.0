Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB3B8C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:46:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7668C64EB8
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:46:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhBRSqS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:46:18 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:44186 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232658AbhBRQrB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:47:01 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGUNEx180452
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=KXWgDusG8RQtQBjveJi1uK3rx0ccdLVbk4hSImrcpyY=;
 b=YdUPJy4jO+MLSrXSnTboD3tkt2klPBTFgTph4pSFShosTX+LFLsxVYL+1bZh5JKdXN2J
 R1D1krJ3oWoV4WE34T9O91p/25c722Gl7wFvdu0C22Hpeqc9MEyVnL/U7jmGxXbWfJF1
 ggy48+7B/V78cqYaNX+BXVaDPJnE8Mv8BwfWZR2sEtpkQghsdkwzFRExF3synGAt3acw
 MFNvB6A3iqhWZbBcWLzpnMgiCA1Fy0iMhZArB7HO4kuq8LtgvIVJvbMfRlotc4NgAfIS
 C8uJzqPJtx48sa5cesH7cpHxCLw4Wru6JjUfr3rfVirOdOddUdswQmtIQ/ENFfQmyXlJ xw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 36p7dnph1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGUCaE032333
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:42 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by userp3030.oracle.com with ESMTP id 36prq0q51j-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DIeNpqc3xVo2rTeWFAtzcKGCoNMorbjZQmJSaPuMMqxrquyjfNJX2E/sqJ5cXOI1T83ilOAXESQCdFLruCv6Le3VG2weM+zn3hEcc8i+6cJgUBa+So9m7Nfp7mUWa5bbNREK/a4MfrJuooS5k1n1w3FUq+7TCHcqFIjFNOhQNwDUt8nJ6Fg4fl0fTRAIhys/14G00uhKjc9vDS8l+JAP8dIV8XF5Ik8I9/Vr2g4IPZDahuMCVPKHEvbx7U4+md/Na+8JMJpizjCUaUmcn5TduorWmJ2ldV1HSqGcroYuLrReQwHyFgcO41uutm5RDyqx8ZkGs6M0jkRW5D5kHeoNOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KXWgDusG8RQtQBjveJi1uK3rx0ccdLVbk4hSImrcpyY=;
 b=Z7ylDhLahqYPG8xPRNQJwzLk6lPqVzzXRvjuWKP4xxhoUMjLuxM1ck7eIleTwlJnx6g56G9ZE/uDsvkMusXCIPyDCl7OpBoNYKc0ROMPNDsQ46BPb0/WgENnyAKdtbNan1eEtzRpcvptieb+8LoCTxNbt7eKBrOu2meDknzl/2qc00SSiMZCrcGVm3gWhBUfjHNV/gttPale0TtFbuu+sdus6Um1U5UOyjT2VRmEGstTXoRuQX3QKwJcr3Hs1jEw+IBDttndfxmq/o7vbGjndKhfFB7ZfQNO8mQRxx9eifiCzQxJ5pO3y9tqP6Gzq9WhbM/eNzT/+BcmHmit4Y2esQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KXWgDusG8RQtQBjveJi1uK3rx0ccdLVbk4hSImrcpyY=;
 b=yQrEwYL05kGItWqcihL0IScyVWB/CHP2XlX9gQXl1D1eK0JgAzy7ma3vplBnPmQ9IfuANOyyfY4g+vUXMebvQ8NRCPfQ64jXuWIfe5JNQ/DRxhvc6Hvs4KGNaAnRcpKYzt8y7PAZ5N3zzSz40IhIPeVISeBVxqbVXE4CWR1jbi0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4290.namprd10.prod.outlook.com (2603:10b6:a03:203::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Thu, 18 Feb
 2021 16:45:38 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:45:38 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 16/37] xfsprogs: Introduce error injection to allocate only minlen size extents for files
Date:   Thu, 18 Feb 2021 09:44:51 -0700
Message-Id: <20210218164512.4659-17-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218164512.4659-1-allison.henderson@oracle.com>
References: <20210218164512.4659-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR11CA0088.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by BYAPR11CA0088.namprd11.prod.outlook.com (2603:10b6:a03:f4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:45:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3099928f-7ecf-48cd-26c7-08d8d42c9ef3
X-MS-TrafficTypeDiagnostic: BY5PR10MB4290:
X-Microsoft-Antispam-PRVS: <BY5PR10MB429064E3221347B17A75963B95859@BY5PR10MB4290.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BdbvQ8oOS0T0TBgaBUQj8AbUjDyf1EV4gcXc4yT/7abbrNshWajRsLzpKkxyqPKFXspjT2nI9b16jriIZQi1J6hl0vffGTdhdz8w8MVJzZLD7dcJiNOmdxUMA/Yarc9GuqV16Btiq0TSWoYn+k23XLX/vEO8dsx91rawf3AxBe3ZKSKJkGaNoMDppuPzcgqnVMMJZnPr5Fbyb5FGW2ob8JMiTdHP74m74llXsIWa1VEKfwY+CYUJKdvIpWFemSibXrZH22Ups7na7RJYrZISM5edttdMxuLvN2Q3d29O7eFvNviQUwysT+281NjYh3r1uhA08rJNDnDeMm82n5IAhJrD7aNAVp8w5D+dtJ1clzCtz8vENZ5mVDl5KEoHLZSCnyHlzny66BR9/zDWpMYHQUXfTYOS8Q0uGxkyjWqOonDruswJI4Bb10cz5WA/gDvk3xRYzdF0VagC0dn/8ldyHFLUW+ZVfN1/JmUK5CMGu+NUEqNa8tbuKsRYxx61oIZvaxnt4v3uqG5JDmRGZooiChLkpmH6/fzQg2H3LGdBjZ5KqM5e2Qm+XVML4XKb1RHLNDz0HQvSsfHizNlk12YTiA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(376002)(39860400002)(366004)(6512007)(52116002)(6916009)(1076003)(2906002)(316002)(26005)(6666004)(86362001)(8936002)(478600001)(8676002)(44832011)(6506007)(36756003)(66946007)(66476007)(186003)(66556008)(69590400012)(2616005)(5660300002)(83380400001)(956004)(16526019)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?mYI81y3EPNIA1LHldRJiJwrvIlfsGv+fNUKVNbIbKI0MJCsY8zvixasMHZ7E?=
 =?us-ascii?Q?maygHV0Y/SuJ69fyd2ik/iEnb9Ff7O3hpjG7SLQsOkoVLl5Rmsxh3xuJGlBp?=
 =?us-ascii?Q?t0b65EoLGyqH0nP8ulqSWAeDQWh3tRZG95l7VaiNe1+tyoTLJmtjYKCdOWan?=
 =?us-ascii?Q?KVPsTgjKBFjtO+JuTi9xhkk/DTRBcs2sNMkuVwzjd1JxEYWaoPB//Srf5IM+?=
 =?us-ascii?Q?xCLzrCbv8LiL7mpw1xbjS8tuy8ZJOiwuPi3yAVNCgzimvA30xXeQxNDQY9MG?=
 =?us-ascii?Q?D7nzDVEyAf8+1tw9uoUM7lvVrEPCywmHMt8Rvb+qWn8OGp9CH0KidSUFCwc6?=
 =?us-ascii?Q?5Hc1Suhm7rKKRxDV5lIYQBVXPoEHJmXn8mxG8uleTug2EDd2jcdDVOyYYbLy?=
 =?us-ascii?Q?w5gszlVELTTixoRTRJki2gk+Im7ThzjHyN7FHRU3MerG+GLwKlXTvhCPVWU6?=
 =?us-ascii?Q?0YXqJLKRfXCn+5ivtvsSMSy4FPAb1zKt6rQZA6pSb3BuFM3qgZd+BjKlL5W5?=
 =?us-ascii?Q?8LU936zPandkKOvF2+WVxCfL+qmx4Ug3hHXsl8O7p5mi4OVOLC1vJK5bYGYw?=
 =?us-ascii?Q?3DH+3Nyi0GLA6d8GxNRENmLzreHS9UfBqEKWKIb+wNgURvreNfRL85JZE4Gy?=
 =?us-ascii?Q?TeyBThe9J5ayLE02QZfuRa7w44HIbSTaVM0/sNagtIdMAB1ryEo4Sue2XUOO?=
 =?us-ascii?Q?uPY3OPIJE1/mypfBcupzuv4Cfj6Of5qna3/NIv7qf1TtuL5D3x+1v4ETBxJd?=
 =?us-ascii?Q?p8cYovtmmEQSeitqgoPL8ZWjAQPicDGy+1Nksntiq6HuKdm4boKDK5fNQSpu?=
 =?us-ascii?Q?jYx/tyw8sr63aB1wSE2JM3V0ruwhuZuYKudi+aRTBi7MuBluS+K296UdgdaO?=
 =?us-ascii?Q?5ArIMJTEJlf4pac5b9Y8rsJJsoLv0BXaCRk8dgZO2epECn8+vEG9FttiKU0z?=
 =?us-ascii?Q?WOns829Q7M1LVeX6QaUkwzAqBBuBHnRSCXzuF/gi6njo0WmX8WVKR1WYDZqS?=
 =?us-ascii?Q?IFHVp8UphxVEwi3sFLrMdqJKL1kgMbzZaDczd2vTxbymZqxjTawR4I6boL4A?=
 =?us-ascii?Q?TrB3r9cTuJcx/MLABdd3+ovDorWQ4qRzHZE3I2K5Xt+5sQpucpfnUbi3Hq3/?=
 =?us-ascii?Q?pMkF9cjSEzimpUw0pSYOLj65O2Xv1wUpOcCNEdT5HerDQeyQO8Hkrw0q6E2S?=
 =?us-ascii?Q?AsVLOmlDbWRvCe8SnQR1J4mfggwchNWKaA42MfghigjCIonu04dBXS55vZpm?=
 =?us-ascii?Q?MPx+r6PbAG44DmcfT+mB56cydfFqc7XcB3Cs4FfNKETT5Kio3c7kxcki+m3L?=
 =?us-ascii?Q?wZaqSX3HSmSR9BA9AySV4t8Y?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3099928f-7ecf-48cd-26c7-08d8d42c9ef3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:45:38.5291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5U/exBJg6mxPKAA2Aup+ULqbahECCmAG00Zo4sCrISgAv0Tb6elDa+F6MLRrXQS4sUeh+T+YNW1cf4WaX5r4zyr2uiTpqR//Y7DhgREdrk0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4290
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 spamscore=0 adultscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102180141
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Chandan Babu R <chandanrlinux@gmail.com>

Source kernel commit: 301519674699aa9b80a15b2b2165e08532b176e6

This commit adds XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT error tag which
helps userspace test programs to get xfs_bmap_btalloc() to always
allocate minlen sized extents.

This is required for test programs which need a guarantee that minlen
extents allocated for a file do not get merged with their existing
neighbours in the inode's BMBT. "Inode fork extent overflow check" for
Directories, Xattrs and extension of realtime inodes need this since the
file offset at which the extents are being allocated cannot be
explicitly controlled from userspace.

One way to use this error tag is to,
1. Consume all of the free space by sequentially writing to a file.
2. Punch alternate blocks of the file. This causes CNTBT to contain
sufficient number of one block sized extent records.
3. Inject XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT error tag.
After step 3, xfs_bmap_btalloc() will issue space allocation
requests for minlen sized extents only.

ENOSPC error code is returned to userspace when there aren't any "one
block sized" extents left in any of the AGs.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>

achender:
	Amended io/inject.c with error tag name to avoid compiler errors

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 io/inject.c           |   1 +
 libxfs/xfs_alloc.c    |  50 ++++++++++++++++++++
 libxfs/xfs_alloc.h    |   3 ++
 libxfs/xfs_bmap.c     | 124 ++++++++++++++++++++++++++++++++++++++++----------
 libxfs/xfs_errortag.h |   4 +-
 5 files changed, 157 insertions(+), 25 deletions(-)

diff --git a/io/inject.c b/io/inject.c
index ff66b41..4bd4138 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -56,6 +56,7 @@ error_tag(char *name)
 		{ XFS_ERRTAG_IUNLINK_FALLBACK,		"iunlink_fallback" },
 		{ XFS_ERRTAG_BUF_IOERROR,		"buf_ioerror" },
 		{ XFS_ERRTAG_REDUCE_MAX_IEXTENTS,	"reduce_max_iextents"},
+		{ XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT,	"bmap_min_extent"},
 		{ XFS_ERRTAG_MAX,			NULL }
 	};
 	int	count;
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 0bef9f0..63e15bb 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -2470,6 +2470,47 @@ xfs_defer_agfl_block(
 	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_AGFL_FREE, &new->xefi_list);
 }
 
+#ifdef DEBUG
+/*
+ * Check if an AGF has a free extent record whose length is equal to
+ * args->minlen.
+ */
+STATIC int
+xfs_exact_minlen_extent_available(
+	struct xfs_alloc_arg	*args,
+	struct xfs_buf		*agbp,
+	int			*stat)
+{
+	struct xfs_btree_cur	*cnt_cur;
+	xfs_agblock_t		fbno;
+	xfs_extlen_t		flen;
+	int			error = 0;
+
+	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, agbp,
+			args->agno, XFS_BTNUM_CNT);
+	error = xfs_alloc_lookup_ge(cnt_cur, 0, args->minlen, stat);
+	if (error)
+		goto out;
+
+	if (*stat == 0) {
+		error = -EFSCORRUPTED;
+		goto out;
+	}
+
+	error = xfs_alloc_get_rec(cnt_cur, &fbno, &flen, stat);
+	if (error)
+		goto out;
+
+	if (*stat == 1 && flen != args->minlen)
+		*stat = 0;
+
+out:
+	xfs_btree_del_cursor(cnt_cur, error);
+
+	return error;
+}
+#endif
+
 /*
  * Decide whether to use this allocation group for this allocation.
  * If so, fix up the btree freelist's size.
@@ -2541,6 +2582,15 @@ xfs_alloc_fix_freelist(
 	if (!xfs_alloc_space_available(args, need, flags))
 		goto out_agbp_relse;
 
+#ifdef DEBUG
+	if (args->alloc_minlen_only) {
+		int stat;
+
+		error = xfs_exact_minlen_extent_available(args, agbp, &stat);
+		if (error || !stat)
+			goto out_agbp_relse;
+	}
+#endif
 	/*
 	 * Make the freelist shorter if it's too long.
 	 *
diff --git a/libxfs/xfs_alloc.h b/libxfs/xfs_alloc.h
index 6c22b12..a4427c5 100644
--- a/libxfs/xfs_alloc.h
+++ b/libxfs/xfs_alloc.h
@@ -75,6 +75,9 @@ typedef struct xfs_alloc_arg {
 	char		wasfromfl;	/* set if allocation is from freelist */
 	struct xfs_owner_info	oinfo;	/* owner of blocks being allocated */
 	enum xfs_ag_resv_type	resv;	/* block reservation to use */
+#ifdef DEBUG
+	bool		alloc_minlen_only; /* allocate exact minlen extent */
+#endif
 } xfs_alloc_arg_t;
 
 /*
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 6a9485a..9209e4f 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -3545,34 +3545,101 @@ xfs_bmap_process_allocated_extent(
 	xfs_bmap_btalloc_accounting(ap, args);
 }
 
-STATIC int
-xfs_bmap_btalloc(
-	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
+#ifdef DEBUG
+static int
+xfs_bmap_exact_minlen_extent_alloc(
+	struct xfs_bmalloca	*ap)
 {
-	xfs_mount_t	*mp;		/* mount point structure */
-	xfs_alloctype_t	atype = 0;	/* type for allocation routines */
-	xfs_agnumber_t	fb_agno;	/* ag number of ap->firstblock */
-	xfs_agnumber_t	ag;
-	xfs_alloc_arg_t	args;
-	xfs_fileoff_t	orig_offset;
-	xfs_extlen_t	orig_length;
-	xfs_extlen_t	blen;
-	xfs_extlen_t	nextminlen = 0;
-	int		nullfb;		/* true if ap->firstblock isn't set */
-	int		isaligned;
-	int		tryagain;
-	int		error;
-	int		stripe_align;
+	struct xfs_mount	*mp = ap->ip->i_mount;
+	struct xfs_alloc_arg	args = { .tp = ap->tp, .mp = mp };
+	xfs_fileoff_t		orig_offset;
+	xfs_extlen_t		orig_length;
+	int			error;
 
 	ASSERT(ap->length);
+
+	if (ap->minlen != 1) {
+		ap->blkno = NULLFSBLOCK;
+		ap->length = 0;
+		return 0;
+	}
+
 	orig_offset = ap->offset;
 	orig_length = ap->length;
 
-	mp = ap->ip->i_mount;
+	args.alloc_minlen_only = 1;
 
-	memset(&args, 0, sizeof(args));
-	args.tp = ap->tp;
-	args.mp = mp;
+	xfs_bmap_compute_alignments(ap, &args);
+
+	if (ap->tp->t_firstblock == NULLFSBLOCK) {
+		/*
+		 * Unlike the longest extent available in an AG, we don't track
+		 * the length of an AG's shortest extent.
+		 * XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT is a debug only knob and
+		 * hence we can afford to start traversing from the 0th AG since
+		 * we need not be concerned about a drop in performance in
+		 * "debug only" code paths.
+		 */
+		ap->blkno = XFS_AGB_TO_FSB(mp, 0, 0);
+	} else {
+		ap->blkno = ap->tp->t_firstblock;
+	}
+
+	args.fsbno = ap->blkno;
+	args.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
+	args.type = XFS_ALLOCTYPE_FIRST_AG;
+	args.total = args.minlen = args.maxlen = ap->minlen;
+
+	args.alignment = 1;
+	args.minalignslop = 0;
+
+	args.minleft = ap->minleft;
+	args.wasdel = ap->wasdel;
+	args.resv = XFS_AG_RESV_NONE;
+	args.datatype = ap->datatype;
+
+	error = xfs_alloc_vextent(&args);
+	if (error)
+		return error;
+
+	if (args.fsbno != NULLFSBLOCK) {
+		xfs_bmap_process_allocated_extent(ap, &args, orig_offset,
+			orig_length);
+	} else {
+		ap->blkno = NULLFSBLOCK;
+		ap->length = 0;
+	}
+
+	return 0;
+}
+#else
+
+#define xfs_bmap_exact_minlen_extent_alloc(bma) (-EFSCORRUPTED)
+
+#endif
+
+STATIC int
+xfs_bmap_btalloc(
+	struct xfs_bmalloca	*ap)
+{
+	struct xfs_mount	*mp = ap->ip->i_mount;
+	struct xfs_alloc_arg	args = { .tp = ap->tp, .mp = mp };
+	xfs_alloctype_t		atype = 0;
+	xfs_agnumber_t		fb_agno;	/* ag number of ap->firstblock */
+	xfs_agnumber_t		ag;
+	xfs_fileoff_t		orig_offset;
+	xfs_extlen_t		orig_length;
+	xfs_extlen_t		blen;
+	xfs_extlen_t		nextminlen = 0;
+	int			nullfb; /* true if ap->firstblock isn't set */
+	int			isaligned;
+	int			tryagain;
+	int			error;
+	int			stripe_align;
+
+	ASSERT(ap->length);
+	orig_offset = ap->offset;
+	orig_length = ap->length;
 
 	stripe_align = xfs_bmap_compute_alignments(ap, &args);
 
@@ -4106,6 +4173,10 @@ xfs_bmap_alloc_userdata(
 			return xfs_bmap_rtalloc(bma);
 	}
 
+	if (unlikely(XFS_TEST_ERROR(false, mp,
+			XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT)))
+		return xfs_bmap_exact_minlen_extent_alloc(bma);
+
 	return xfs_bmap_btalloc(bma);
 }
 
@@ -4142,10 +4213,15 @@ xfs_bmapi_allocate(
 	else
 		bma->minlen = 1;
 
-	if (bma->flags & XFS_BMAPI_METADATA)
-		error = xfs_bmap_btalloc(bma);
-	else
+	if (bma->flags & XFS_BMAPI_METADATA) {
+		if (unlikely(XFS_TEST_ERROR(false, mp,
+				XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT)))
+			error = xfs_bmap_exact_minlen_extent_alloc(bma);
+		else
+			error = xfs_bmap_btalloc(bma);
+	} else {
 		error = xfs_bmap_alloc_userdata(bma);
+	}
 	if (error || bma->blkno == NULLFSBLOCK)
 		return error;
 
diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
index 1c56fcc..6ca9084 100644
--- a/libxfs/xfs_errortag.h
+++ b/libxfs/xfs_errortag.h
@@ -57,7 +57,8 @@
 #define XFS_ERRTAG_IUNLINK_FALLBACK			34
 #define XFS_ERRTAG_BUF_IOERROR				35
 #define XFS_ERRTAG_REDUCE_MAX_IEXTENTS			36
-#define XFS_ERRTAG_MAX					37
+#define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
+#define XFS_ERRTAG_MAX					38
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -99,5 +100,6 @@
 #define XFS_RANDOM_IUNLINK_FALLBACK			(XFS_RANDOM_DEFAULT/10)
 #define XFS_RANDOM_BUF_IOERROR				XFS_RANDOM_DEFAULT
 #define XFS_RANDOM_REDUCE_MAX_IEXTENTS			1
+#define XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT		1
 
 #endif /* __XFS_ERRORTAG_H_ */
-- 
2.7.4

