Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16AD3C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Sep 2021 10:11:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E973760F25
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Sep 2021 10:11:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233724AbhITKNW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Sep 2021 06:13:22 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:56164 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233597AbhITKNV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Sep 2021 06:13:21 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KA42dJ019667;
        Mon, 20 Sep 2021 10:11:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=NzeMW0K2Lj0TPxd5ibUnl5LRmj2OP3BwZVFsJKiLN4I=;
 b=bY0FL6S0CbJDqGgnQ70Nt3FSqJwX64JdXhn8NMsz3S8lyxE3tw7lLlnMGAibcrJVhXoB
 vDEeSvs8bP0EFTaCL9HenVt4PsXx+7T2f69+JubjRGS8HXO3DfHmzAsFGnmYogqEttda
 FrU/pD386Y7o4+SePw/YePQmqnnhpz7RzmNP0tsCD/6UUvHNWwTDt36QnOo264hU4v10
 nDQq+2parfiZCi1QV7OwPFjNrPtcV4d99KqTErxv/8LPx5Mp+JogmwJQNt6CH3149WDj
 SLoBqnWNF1HEYld7v6IvsGfsoXoMuDw8mKPkMlYYXqDzIQ7RKoA5w/X+7n61JmKWZdLJ 6g== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2020-01-29;
 bh=NzeMW0K2Lj0TPxd5ibUnl5LRmj2OP3BwZVFsJKiLN4I=;
 b=G3ryWBfDcE/Js13gMcRDrn+k7gMpIqeDNLb2Sj+G7NoMvs0FEz1cgdwc2hVWdLxHWptS
 es2yX19hPcuxPRNCy3urpaKDug3X9QPO3diAhXx8/1dHw5J4BNs/hCg5SgfjMzk/wfp5
 v4TdIQ164IXv49skEnQJJ1p8MlpLwl1UGtFImsVsQjNWwmo9tIXoHMKUeCdeyQgD0eCD
 ricSTsW5Sa5sXDn6k+Q1kuUezbhHz0SB+Av7XnVzaUMdbJqyz2Bk5CEp8dIBRpjyMQMJ
 jTkd6rCyOPin6Geprhoa5I2wrK33ZZmlVmcu8axbxDVSp8HneYArqF1Age5zJmTINlFc fA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b66j2hsdn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 10:11:53 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18KABT41050377;
        Mon, 20 Sep 2021 10:11:52 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by userp3030.oracle.com with ESMTP id 3b557vb223-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 10:11:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kK5JIbRWYKHKT5yiuiSy0gsyNW31j/K++agtc/0c1TNyWzYfQlj40XH+0s7YNph0DE0KuuNvB6NgIUvQZbl7beQkTZUhSBUPaOKJnXgVg7RbDIpvesWQv0DR8OATDtC1ZKlI8sV8j2VLg26CRZ4DFeSi2y/M9ZzpIsNhI+Dsqm5RniiDauqm4Y2T37Mdvlet0jU7q+VFiWVXY1n7bkv8zWxKp+91ORxS8quReIaNK8NMn2n2XHizjTV8oAHU/xArIRF/6ZC+Lm+EhOMIEbdrvPSkO1jVGzy34PAzgtMShmCd+l4EmnrsD0GJXz+1xiVpzN/A4xEzm+OuRHNtDZ7EQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=NzeMW0K2Lj0TPxd5ibUnl5LRmj2OP3BwZVFsJKiLN4I=;
 b=CXogg1btgbvzDAxtXjyn/tU144jrnbz9a36QkmUmAyV7VMU3i23ivt/5YNB635BVr1QQzmfmMqZ1QGzOqyQmNLaE6KL3GwTLMQmE4D9JvtrpYKbtM2BHOn+IT7Hk8U0L9sZY52YLsFOP54nwLxyKnoPZ1e2HgvwGPuxduVB0x0tYYRf7gRc00gk72EEPCbsk+OW1aypSX0hoZ9RXWuPHt/XflS7lbH5DPvJ3MH2YFzWA9qPkRykI2HuvxnjThQ4ec+A4mgznw7mHdR27xDGAoB7lHVTtL1Fdl2u7YnaRwiRDgrPjUV9XfKOxuw4BNBong7UuYI6Q40rfaLFw7dRrTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NzeMW0K2Lj0TPxd5ibUnl5LRmj2OP3BwZVFsJKiLN4I=;
 b=jfLkkgAmIOmY+PXe54/bWDvgfuFtFIKX+UeAvPr2SeNR3/HC1QiElApNVaROdN6B8MPr9ICFGqO1qbsaV09/9DoeiU4OflPLzuuM+T02p/E7aIyvYdHQbsNAUZlUjlf+YLmcLVQbDGw/FWEBTQBtrXrG6WgeL9+PAdBGKPJAk7Y=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4540.namprd10.prod.outlook.com (2603:10b6:806:110::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Mon, 20 Sep
 2021 10:11:50 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.018; Mon, 20 Sep 2021
 10:11:50 +0000
References: <163192854958.416199.3396890438240296942.stgit@magnolia>
 <163192861018.416199.11733078081556457241.stgit@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandanrlinux@gmail.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/14] xfs: dynamically allocate cursors based on maxlevels
In-reply-to: <163192861018.416199.11733078081556457241.stgit@magnolia>
Message-ID: <878rzr7ept.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Mon, 20 Sep 2021 15:26:14 +0530
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0013.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:c::23) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (223.182.249.90) by MAXPR0101CA0013.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:c::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Mon, 20 Sep 2021 10:11:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 24761830-db1d-4256-d622-08d97c1f0fc4
X-MS-TrafficTypeDiagnostic: SA2PR10MB4540:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4540D650A50C067E2F232B60F6A09@SA2PR10MB4540.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yjswezpcrJnMxvp/F3Wvk3A+5ImbeV1JW6Wl6eqtngHFXMc73r0c9VLzR3IFGcwJI2j18d8GToZRl+gdGnpgY9euwj6pQCEsLIgLzSkfn6JQ1dzkBAslX5su4vP8dI8YfgXz8nmSQusfdTz2uX2zeLG7WkvDbklEDPY+b6OsFcHQJS9u7tBuBHcc6ye9HVxVEnYtJFeymoNEZ+xo1qiv9U7EuSGMKiy6KVqpVYfH3ELOL7G2TsjDbnRrjZts7qGDEl+jwAI1fyn/wV+1FiqKgISl5VeDywQeriB+ijMyP+bd4rwIjNArNwwJvFOpTi/wovFFqSRheuY5u3niL7CEPPrG+XL33DIKQOJWtyxRtwz/TO+GJ3mmnJWBCxrX/ju9XOKQgReQOGD/LT0bqzOTHZJ6acMJnoMal9X0++ocIaRr5Ei+TTHfRkgd07xAeNCcmIQbeVArh6GAojXPFsr5LpZPy4AzRHqHGYf2BnSBrpCvAaUo/khxOqqbpn8JKQ2YuHfX7nQudWNLlvK96K0F9n1EUCh+F1s05DU4Z1y703lFqoc7fCfwqLEPl5trzLdTq700+uTos1jfRxntS2MroCs3b3KCTrlljkbqYf2bIakfLc0Y4dN94qNATQQQLw2L0CHp6E1KGWTUpsq1FXDYpqvtpKHrYhTq8UqVjaXVDsQg7RtKSNLGjSjOdGN+OBGe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(316002)(4326008)(33716001)(26005)(52116002)(53546011)(6916009)(86362001)(6496006)(38100700002)(8676002)(6486002)(508600001)(5660300002)(38350700002)(66946007)(956004)(186003)(66476007)(83380400001)(9686003)(66556008)(2906002)(8936002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oo51H3KLgPUJE+47Y7c3jqgmrrDJ1kTOWUK8mI/5CHZngC+pt8dm7zUE8OeC?=
 =?us-ascii?Q?5ocKFN/c/djBoTjeqAleXLMO99yLMTJUa3vW9O5BbfNzY5UY8sZGpCE/aEW+?=
 =?us-ascii?Q?YcZLLJ400+FF7vh5kegBzEnJnSaZt6B/0a5MRqNMJHR7tS4bRZvGC4hGrk0+?=
 =?us-ascii?Q?L0bhkmhd46EwyGRQNeZfBX2JuxmcHz6v7n6dqA0cn/8uCj8/GUArh+oZDZbC?=
 =?us-ascii?Q?ilB3+iF711m8iq5ULyrgtIYw6vIaOTpXGtnpUzow42XBIqTAq+akxsPVCU5l?=
 =?us-ascii?Q?3oOJnFbiXYRHhNYM9FsFUWASVYJcczqBzgjONopfeDEaCc62hCaOhApXCZ41?=
 =?us-ascii?Q?rB5SqE1fpQlC3FyZoedU8iKjZBhA/EPvGnZOOa5EHPRaaZcUFfcCicg6S79S?=
 =?us-ascii?Q?aDibaYnw1JXIKHMqa43syKX95to9f9aQ6GZO9EqrM/pAVYp1JJ8Wisu+ztD/?=
 =?us-ascii?Q?E+zin5Sh3iDVMUIaZq7Ecjfj41hjmJQva8MpLyjXLuUK3aXWkGk8bPp0xBU7?=
 =?us-ascii?Q?B6O9ltP5V1KTjnLrvFAYQ28oMA5js/4ruoDVsh6GVXYPMwZ6sRcqAf+uV792?=
 =?us-ascii?Q?eFzSRoBhXJrP05HE73FOEGCMnkTBazNdsV1P+nd2kxdCEo2K7iLSmdidUpQM?=
 =?us-ascii?Q?S/cBOuTYYSsljqoHdirc2EDj8Su7Oy0XCLTd6taZXRqd6ZzdYHTKq0mfaaCp?=
 =?us-ascii?Q?cBs62CM8xgktXVENy4VP+AOfZs+Z1VYk236ZRt66hAwn4VqEJuxIvQ3v4o9W?=
 =?us-ascii?Q?0e4FsT+K18m0O5Se6EN4YDvjTZgz9zJyaBHxM2QEoq54esmNOSdA/n/EJ5YR?=
 =?us-ascii?Q?+LHSIX9KWgiZ/x6hXC0TiG+5Xp5Ld7bfEK0cxUkBSWasmL9NRq5TeKAYY++9?=
 =?us-ascii?Q?grqxUzvUj3ERFeu+8coCOp3lsiFrIJXQ779nQiYcf+WBUgpQQXijBxL1H9ir?=
 =?us-ascii?Q?NqT9yFTs4CBCre+87QJGDvcX13lq76iMIfFM8C83awEA/Qm8pin06NKtf20u?=
 =?us-ascii?Q?uXjQChsykoMWLPO8vOae4wF32Be8MDSHLGVupTJdrxcgdrETcmlyYz8CwL30?=
 =?us-ascii?Q?ylkL8L96vdCB5098KSbVpaW8Y3+qQiLB5gnxM6T/2MSj/fVJYLbPlPjA7hV6?=
 =?us-ascii?Q?0M34ogrCO3qM+gwynOMmKVQOUE/iiPH1oiFjlxkXrrHSAvdv6fd5ezgpruhR?=
 =?us-ascii?Q?iOwzzREuGW74VnIm+nZimtN5wfYaWGqKB5IWfTubByYDwdOcXxWw09n/zGDj?=
 =?us-ascii?Q?DEPiQzY75gY3sCSO808m78DFSH7eyil0Sj1E0ACOZXf+H3cljTj5p57f0tyI?=
 =?us-ascii?Q?fholeRxkeyXjUXjpvtoZfdl+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24761830-db1d-4256-d622-08d97c1f0fc4
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2021 10:11:50.3031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lRKPRP+2VaFVDTXUvoM6WdHu+CSVWUWkTvmczJUZZCSb2s5PrzCXm1s8epx3s1nJIJktITqKBtKATkByez+MZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4540
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10112 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 spamscore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109200063
X-Proofpoint-GUID: wtL8d-EosaGl-yaHIjmT6WvUjvmXkAmj
X-Proofpoint-ORIG-GUID: wtL8d-EosaGl-yaHIjmT6WvUjvmXkAmj
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 18 Sep 2021 at 07:00, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Replace the statically-sized btree cursor zone with dynamically sized
> allocations so that we can reduce the memory overhead for per-AG bt
> cursors while handling very tall btrees for rt metadata.
>

Looks good.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_btree.c |   40 ++++++++++++++++++++++++++++++++--------
>  fs/xfs/libxfs/xfs_btree.h |    2 --
>  fs/xfs/xfs_super.c        |   11 +----------
>  3 files changed, 33 insertions(+), 20 deletions(-)
>
>
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 2486ba22c01d..f9516828a847 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -23,11 +23,6 @@
>  #include "xfs_btree_staging.h"
>  #include "xfs_ag.h"
>  
> -/*
> - * Cursor allocation zone.
> - */
> -kmem_zone_t	*xfs_btree_cur_zone;
> -
>  /*
>   * Btree magic numbers.
>   */
> @@ -379,7 +374,7 @@ xfs_btree_del_cursor(
>  		kmem_free(cur->bc_ops);
>  	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS) && cur->bc_ag.pag)
>  		xfs_perag_put(cur->bc_ag.pag);
> -	kmem_cache_free(xfs_btree_cur_zone, cur);
> +	kmem_free(cur);
>  }
>  
>  /*
> @@ -4927,6 +4922,32 @@ xfs_btree_has_more_records(
>  		return block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK);
>  }
>  
> +/* Compute the maximum allowed height for a given btree type. */
> +static unsigned int
> +xfs_btree_maxlevels(
> +	struct xfs_mount	*mp,
> +	xfs_btnum_t		btnum)
> +{
> +	switch (btnum) {
> +	case XFS_BTNUM_BNO:
> +	case XFS_BTNUM_CNT:
> +		return mp->m_ag_maxlevels;
> +	case XFS_BTNUM_BMAP:
> +		return max(mp->m_bm_maxlevels[XFS_DATA_FORK],
> +			   mp->m_bm_maxlevels[XFS_ATTR_FORK]);
> +	case XFS_BTNUM_INO:
> +	case XFS_BTNUM_FINO:
> +		return M_IGEO(mp)->inobt_maxlevels;
> +	case XFS_BTNUM_RMAP:
> +		return mp->m_rmap_maxlevels;
> +	case XFS_BTNUM_REFC:
> +		return mp->m_refc_maxlevels;
> +	default:
> +		ASSERT(0);
> +		return XFS_BTREE_MAXLEVELS;
> +	}
> +}
> +
>  /* Allocate a new btree cursor of the appropriate size. */
>  struct xfs_btree_cur *
>  xfs_btree_alloc_cursor(
> @@ -4935,13 +4956,16 @@ xfs_btree_alloc_cursor(
>  	xfs_btnum_t		btnum)
>  {
>  	struct xfs_btree_cur	*cur;
> +	unsigned int		maxlevels = xfs_btree_maxlevels(mp, btnum);
>  
> -	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
> +	ASSERT(maxlevels <= XFS_BTREE_MAXLEVELS);
> +
> +	cur = kmem_zalloc(xfs_btree_cur_sizeof(maxlevels), KM_NOFS);
>  	cur->bc_tp = tp;
>  	cur->bc_mp = mp;
>  	cur->bc_btnum = btnum;
>  	cur->bc_blocklog = mp->m_sb.sb_blocklog;
> -	cur->bc_maxlevels = XFS_BTREE_MAXLEVELS;
> +	cur->bc_maxlevels = maxlevels;
>  
>  	return cur;
>  }
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index 6075918efa0c..ae83fbf58c18 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -13,8 +13,6 @@ struct xfs_trans;
>  struct xfs_ifork;
>  struct xfs_perag;
>  
> -extern kmem_zone_t	*xfs_btree_cur_zone;
> -
>  /*
>   * Generic key, ptr and record wrapper structures.
>   *
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 30bae0657343..25a548bbb0b2 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1965,17 +1965,11 @@ xfs_init_zones(void)
>  	if (!xfs_bmap_free_item_zone)
>  		goto out_destroy_log_ticket_zone;
>  
> -	xfs_btree_cur_zone = kmem_cache_create("xfs_btree_cur",
> -				xfs_btree_cur_sizeof(XFS_BTREE_MAXLEVELS),
> -					       0, 0, NULL);
> -	if (!xfs_btree_cur_zone)
> -		goto out_destroy_bmap_free_item_zone;
> -
>  	xfs_da_state_zone = kmem_cache_create("xfs_da_state",
>  					      sizeof(struct xfs_da_state),
>  					      0, 0, NULL);
>  	if (!xfs_da_state_zone)
> -		goto out_destroy_btree_cur_zone;
> +		goto out_destroy_bmap_free_item_zone;
>  
>  	xfs_ifork_zone = kmem_cache_create("xfs_ifork",
>  					   sizeof(struct xfs_ifork),
> @@ -2105,8 +2099,6 @@ xfs_init_zones(void)
>  	kmem_cache_destroy(xfs_ifork_zone);
>   out_destroy_da_state_zone:
>  	kmem_cache_destroy(xfs_da_state_zone);
> - out_destroy_btree_cur_zone:
> -	kmem_cache_destroy(xfs_btree_cur_zone);
>   out_destroy_bmap_free_item_zone:
>  	kmem_cache_destroy(xfs_bmap_free_item_zone);
>   out_destroy_log_ticket_zone:
> @@ -2138,7 +2130,6 @@ xfs_destroy_zones(void)
>  	kmem_cache_destroy(xfs_trans_zone);
>  	kmem_cache_destroy(xfs_ifork_zone);
>  	kmem_cache_destroy(xfs_da_state_zone);
> -	kmem_cache_destroy(xfs_btree_cur_zone);
>  	kmem_cache_destroy(xfs_bmap_free_item_zone);
>  	kmem_cache_destroy(xfs_log_ticket_zone);
>  }


-- 
chandan
