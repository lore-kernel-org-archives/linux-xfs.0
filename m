Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DBBEC433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Mar 2022 06:51:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbiCQGwl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Mar 2022 02:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbiCQGwk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Mar 2022 02:52:40 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1F6C7DE07
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 23:51:24 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22H3LSlc030869;
        Thu, 17 Mar 2022 06:51:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=q2aec01h6tcJ/ULrpbmAip3g4EhMkuLXW+aSwvKBnGo=;
 b=mjaMP83liStF4mG1xYwcHIyqQTPHXQwljblMN4IFVW8Fv/TBYs8rplUeijGVWGvktHBK
 AugzjQTVyMhFxBt6EIdlOqoMQrnmlDigTfZv8bE8KbETNWyGITVcHQi8GacwoL5XwJrD
 i/IEmn/aFbV2bFX9SZjZdcffilYsrHRW10c7vVu0zbXC3gKux5mVZCINt5ynjS0KQh8j
 Oi+Kmb2htpKjSkXi+uyhddNgRRy9bqJGTQOLD7nOMm5KBJMetT/nk8uf0YwxGlPjC2ur
 VQmg+bTHWJl0bpE/IGlZrmrZLvSPbcZNxXygNb9Ihj4uK9A3ciQdR7+imGJHZRd98GWx PA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3et5s6rcvs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Mar 2022 06:51:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22H6e5ma158257;
        Thu, 17 Mar 2022 06:51:22 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by aserp3020.oracle.com with ESMTP id 3et64m4gnn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Mar 2022 06:51:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SJARDJ0145EV30NM6cTAzrJrFaDXwtOxdKhtsbohVhiRI12FP3kEyYtG6p9pJThEHAhmBS0u7Zwk6HbByGHZ11X21Ee9s4JLj0gHDIdqyzXxec1I0yvxnuTkwvg2s2ChHQCx0HcghSPapfggiKEOUdTyGdo2dRBXFmeD3ido01BUABwoWrO2TTxaEo7lYKp5gR2LDAoK+w6A8ubhIDVTApRqhrlELh5NG/SlHAns2w5nTekDW89QXlT2dhBEC/gyOTv4B4+QXsN+ZvtOQBMgLzO3TbLvpLEABLXteVOBWVYlfJBGhnA448WdSpdZwCLcvH5wZ2t0Ndkg2GF2iKIX8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q2aec01h6tcJ/ULrpbmAip3g4EhMkuLXW+aSwvKBnGo=;
 b=erwjlN7D6NSuoCEx6DVxZ/vvhC5O+g17wPF5gGBaU5BvLQaAua9EWMnLoIVGlbRv8gBjmKk1Uuq5JMyd/q5sgICEp8gw6+KQvGSwuB9b9GaHF86XrXiUpvaMo23phH8s2JPq78zra7qHQpskm7Ecu/8Be5TFaHGndiNQROTSoOtAYzL0qDaT16b3+mzQJ0uHYWj/u/A2hA76Kv1HRUjsOppe2pyYn+Ryh5YcGuPX40mVlwxeNMn+HXy6x1IjH8BPCYmWYR3MkS+1HfWSGLQABD471LjkQow+Ritku/XQHERCH31cphBOgvkvokZskiJelLqwyRRI6V4xopz0vgJdJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q2aec01h6tcJ/ULrpbmAip3g4EhMkuLXW+aSwvKBnGo=;
 b=OFUfNRvzlvTcqOjofFsOwE60vjnzXwOf4mk0MzD/ENYqfWGpmE2EFi/g24m6GtH2Hc9qYGnLtqTQmBXFWhaTadqhxjWVW5jgLjzlNm7p7XL4vMplqFcsTc3DL7zbATCysQIVWGHj3lbv0lmwfaEw5qgCeBe9WxtZFoMd0D+/73w=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by PH0PR10MB4552.namprd10.prod.outlook.com (2603:10b6:510:42::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Thu, 17 Mar
 2022 06:51:20 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5081.017; Thu, 17 Mar 2022
 06:51:20 +0000
References: <20220317053907.164160-1-david@fromorbit.com>
 <20220317053907.164160-5-david@fromorbit.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: async CIL flushes need pending pushes to be
 made stable
In-reply-to: <20220317053907.164160-5-david@fromorbit.com>
Message-ID: <871qz1dqcf.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Thu, 17 Mar 2022 12:21:12 +0530
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0231.jpnprd01.prod.outlook.com
 (2603:1096:404:11e::27) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4940d5e9-ddbd-4c83-d45e-08da07e28b01
X-MS-TrafficTypeDiagnostic: PH0PR10MB4552:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB4552C1A901CC67E3790DEFF3F6129@PH0PR10MB4552.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KKjxb9RUsU/BH8evQZV67w6ZkvZwTkVQvi2lfTwDpa07eVdLI/SrqF+EH0WPxxfTGBtYz6A1sVSW5kzRoAi6g7RxtUJ1f2xMv3xk38WN0OO4aKuMpZtNd8hWW8WLFSmTkxx+1PJZYq44+kc611r5GwP/nQmfHIjAMMJZ78/XPCvVjz4Gerj/hxo/h8exhpcHn6gaahGwUjVbgkfIlDrsBsyHPJV+MfW2TTfMv3ztnb+WjQpID6PqvtQWHDLoGgBd3ZQ5LZyjZ0snF7OxwqI1X/W/dxJOhp1ztywXn6PXHRNE7b5DKCiPmDKjOrAqroT5MlUWXfIXEFo1ls8Oo3oLQTLhLjuUy4kwpQMyoFrvzKpoEgxw4aEP9IPUp+OjQ8OpuR3uH47q88r69KzHUZhU5xs3aSrUcowudxlE9D3Hxqvr2zvQbrL/e3Sw3NrUi/+T3kRhjMSBgA3QbieqbTe1XLob/59ffQ60blwKzxbHdYT0wNXpGdxpCGejWB9PTmqhJw4f1qhdL1z35ooCaGiTmKCDHaysK0ApDdcEMBrLJUj5eOciBFNtSn0ZaVXKgQz8xOO1ZUV+UP8402Nv9uVckDErmvygKHqqI8D91tFvDOhq7qKsVcyw6RKRAw2Po4TE7fo0lZ4iwsAMbSrfWaM9Js3FAX1bKFPWenQju/MHTClxLckwIhcdO+ilxdQU21V9pr3ZwkUiehq8zsfMlfbzJw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(6666004)(508600001)(4326008)(8676002)(66556008)(66946007)(66476007)(26005)(86362001)(5660300002)(38100700002)(186003)(53546011)(6486002)(6506007)(52116002)(8936002)(6512007)(6916009)(9686003)(2906002)(33716001)(316002)(38350700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BD+KQEFdUxj5zlV4sHZLbAR94hm1URgDNF83f27Vog2I/0LsPPhn++zOlOEa?=
 =?us-ascii?Q?iN0RpXhpFD/EOgthCH9u8dHPrF5gc2xysRwE5/YYCkWNKko0/dUQMOmdku4p?=
 =?us-ascii?Q?DnctqRZw1cZck+xiiZDqKGST8sDjbw0zGAxbojWdAGHMPs7WYi/yRf1XQhux?=
 =?us-ascii?Q?gW/WgVwctik55JLJR7SeBB+eNbz1a1NcyFfPkabfT6Apgmjr7sZHVdmQ5ipC?=
 =?us-ascii?Q?4e0hbjcjQSnQQoF9ORIH+ppMIZnkKOf3jwsdkakKp0Lplj/ilh9O2QRE7knt?=
 =?us-ascii?Q?J6cdL8IC1OFAO5u7vfcTlPcIJsjSn6Ddg6obmBxklm6L5GfPqQCKpcjJVoDH?=
 =?us-ascii?Q?Yh5pR797Zq1DGLR6vsKjBcrwMfRL5+tOEZA03EjrFdp/YXefbE9xmKyaVvAY?=
 =?us-ascii?Q?/COJYq0sJwbHl3HZx0G8bs4P9otTxQQ3BsblR35sCX40UzVSsa/Z7O94sRfI?=
 =?us-ascii?Q?0iCUo5okWHea1i0mWimZdTzuI3tWd91Upbg5s55ZeSqWG1mci0th5MV68k06?=
 =?us-ascii?Q?tr9iQuhnI2DNbHh25MeiJrADEoJyMrjFjDKWSgCIahTnB/l1Ffk8p28DRq+c?=
 =?us-ascii?Q?EOkOnm+yoV8bAJOGkDxuaCrfLkzz2yKlxvovSEc0BjX3jvnBm3JiL7b8FN5i?=
 =?us-ascii?Q?L/vwxx8YYl/OdZjfZKUeyS5qVAnCeRBP9LFZYBRI9xgGoHvcf4Woaih0Uqtm?=
 =?us-ascii?Q?eYlC0/B/hVqRGkypppPX93XAd/sOmRwkNp+Ru3WQbUlRZNLcHVnCkbTZ7HDQ?=
 =?us-ascii?Q?CbUgXYPJOgwYfYJaHkECyfyApd1+7l3KU9z7N6Xfy0+DN22oNy6HofBTTnvJ?=
 =?us-ascii?Q?xv5T1lYWqOvdbbwUWJ0YapnOMCPCxxzWVD6+W9pP1p2WxMNuiR4fTZuCWBNP?=
 =?us-ascii?Q?i69CnKiwK45UKsMx1/pcLDnNHHZ8HM1oc/SiI2RFZNdvqLyZQd/G7ymMjsa9?=
 =?us-ascii?Q?+XmUmaAPoc4Flm7dwC9sAv0+G5dIk92XRveLd4+DKT3vFJxO6CC/6Md0SDbp?=
 =?us-ascii?Q?qryHY7592GaxyKgPy53hgjPy6NAAaKsi+N4+jUzC1s02NvbPw984KU7dFaP9?=
 =?us-ascii?Q?FLjMkhXYYJEk8tyBanooHj92JNy7uQhvNXEIlbYDvtlU837KywGNnq2D+zsP?=
 =?us-ascii?Q?B41I2MeuFFqCl37b0RWKHnQAwn1Rp2ka9Hc8H6k0+84zJuVjh2SLvdM0AlkG?=
 =?us-ascii?Q?xUTdBhB81g5ftgFIiQbZxw84cOujVFFA78n+X1pYO0ThLeGeJp2gNwuc4Pz7?=
 =?us-ascii?Q?l4q6768qbyCotfpHE65p8K2XhG/YnK/bkW3lASSKk3ekK7rt2PPf/l9z6uTd?=
 =?us-ascii?Q?RUoPWGwUyQCkuAZCwfw+ykR5FfZ2BJiWxB+kfNJpJqofaSoY3J8BJHcuoZEZ?=
 =?us-ascii?Q?nVvMz52f3rmIkwKCcEnT9jGlNUYQPjbgvouNkaIN7agQ2TnmrZuXwQiz76XJ?=
 =?us-ascii?Q?Fz6ojaWX3yOt0+l/UFKUr+1V9MfywBNI6lCchSe1q2Aq4AS0fk0EkA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4940d5e9-ddbd-4c83-d45e-08da07e28b01
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2022 06:51:20.5641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5wJ5TcIdJAfvdvbo5fWp6MJoKPAvdlMBMHxNrXH+7bYAB2eqXtMXN6osazBb89pAKQEB3QsqZxPPrhMIbseQ5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4552
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10288 signatures=693715
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203170038
X-Proofpoint-GUID: ZKLkmJUvlkw87FEytD5__Ikqb_DOcVsJ
X-Proofpoint-ORIG-GUID: ZKLkmJUvlkw87FEytD5__Ikqb_DOcVsJ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 17 Mar 2022 at 11:09, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> When the AIL tries to flush the CIL, it relies on the CIL push
> ending up on stable storage without having to wait for and
> manipulate iclog state directly. However, if there is already a
> pending CIL push when the AIL tries to flush the CIL, it won't set
> the cil->xc_push_commit_stable flag and so the CIL push will not
> actively flush the commit record iclog.
>
> generic/530 when run on a single CPU test VM can trigger this fairly
> reliably. This test exercises unlinked inode recovery, and can
> result in inodes being pinned in memory by ongoing modifications to
> the inode cluster buffer to record unlinked list modifications. As a
> result, the first inode unlinked in a buffer can pin the tail of the
> log whilst the inode cluster buffer is pinned by the current
> checkpoint that has been pushed but isn't on stable storage because
> because the cil->xc_push_commit_stable was not set. This results in
> the log/AIL effectively deadlocking until something triggers the
> commit record iclog to be pushed to stable storage (i.e. the
> periodic log worker calling xfs_log_force()).
>
> The fix is two-fold - first we should always set the
> cil->xc_push_commit_stable when xlog_cil_flush() is called,
> regardless of whether there is already a pending push or not.
>
> Second, if the CIL is empty, we should trigger an iclog flush to
> ensure that the iclogs of the last checkpoint have actually been
> submitted to disk as that checkpoint may not have been run under
> stable completion constraints.

Looks like all the corner cases have been handled. Hence,

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Reported-and-tested-by: Matthew Wilcox <willy@infradead.org>
> Fixes: 0020a190cf3e ("xfs: AIL needs asynchronous CIL forcing")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_log_cil.c | 22 +++++++++++++++++++---
>  1 file changed, 19 insertions(+), 3 deletions(-)
>
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 747e62799dff..0baa07524ea2 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -1233,18 +1233,27 @@ xlog_cil_push_now(
>  	if (!async)
>  		flush_workqueue(cil->xc_push_wq);
>  
> +	spin_lock(&cil->xc_push_lock);
> +
> +	/*
> +	 * If this is an async flush request, we always need to set the
> +	 * xc_push_commit_stable flag even if something else has already queued
> +	 * a push. The flush caller is asking for the CIL to be on stable
> +	 * storage when the next push completes, so regardless of who has queued
> +	 * the push, the flush requires stable semantics from it.
> +	 */
> +	cil->xc_push_commit_stable = async;
> +
>  	/*
>  	 * If the CIL is empty or we've already pushed the sequence then
> -	 * there's no work we need to do.
> +	 * there's no more work that we need to do.
>  	 */
> -	spin_lock(&cil->xc_push_lock);
>  	if (list_empty(&cil->xc_cil) || push_seq <= cil->xc_push_seq) {
>  		spin_unlock(&cil->xc_push_lock);
>  		return;
>  	}
>  
>  	cil->xc_push_seq = push_seq;
> -	cil->xc_push_commit_stable = async;
>  	queue_work(cil->xc_push_wq, &cil->xc_ctx->push_work);
>  	spin_unlock(&cil->xc_push_lock);
>  }
> @@ -1342,6 +1351,13 @@ xlog_cil_flush(
>  
>  	trace_xfs_log_force(log->l_mp, seq, _RET_IP_);
>  	xlog_cil_push_now(log, seq, true);
> +
> +	/*
> +	 * If the CIL is empty, make sure that any previous checkpoint that may
> +	 * still be in an active iclog is pushed to stable storage.
> +	 */
> +	if (list_empty(&log->l_cilp->xc_cil))
> +		xfs_log_force(log->l_mp, 0);
>  }
>  
>  /*


-- 
chandan
