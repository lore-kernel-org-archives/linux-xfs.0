Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BA94C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Sep 2021 10:09:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D9F160E9C
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Sep 2021 10:09:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235721AbhITKLI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Sep 2021 06:11:08 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:34912 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235710AbhITKLE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Sep 2021 06:11:04 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18K7xPwk028077;
        Mon, 20 Sep 2021 10:09:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=xeEHnA4ypW7leo+pszPdKqfFL+td7pojjxHxdNTw/xo=;
 b=IkeU8rn7JokQTAW1YauroQQCWiskWMVJIaDXgZHk4fSEyDJ2shzCGfq5SprWkjgU6pd9
 J2rDSeF/KwTPyeWrU0PgslGKD3Q4eGbu/OPdCW1ZqzgplCt92ve2Wk0GJhAmXG/l7/vo
 11IqCkaKeNPm5x257Xa2oThK5OgGvEicREkpYGqsBbPLwqF3KyY34M1yTuRwVB604qBY
 Jm6eoA5juARBUotHknhGxKrl33HkMsGPjtYgEktr7M/42wheYgNBjXx05/8wgYkgsHGU
 NfAHWzIPFbnDRik1gxkwxnKNS4s2YFEhBaBfpBOJ/9EEZ3XEmV2OxlsjcX7VcT07b9AK nA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2020-01-29;
 bh=xeEHnA4ypW7leo+pszPdKqfFL+td7pojjxHxdNTw/xo=;
 b=qfkPAGGiyoWriMXBiyzrs7rwxfbY+qvrOeDtADmK/YJ8Fzz2+H5vH004K6xjZfuXHaNZ
 uaWqiyBAR699oQV3IUKid1mxjWK+91bVjvEERt+Rc7M+d+Qi3+2jL2g3ewPv6ESujKQ/
 XoiIJTLLpq1O8t68CTyJ3mBv396BD7wn6C0uukcDSvfz3krj8r5+HkVNZMPcMVotEe1B
 7d7Uj/jRxBh/6zkaJG3pJXjJpjOxZhDY96NXYH8qbRnTPqczhh81rvhZket9hpNH/EJu
 WOO8NKU9XN3FaVh529bO6sVmgQXbJAYIPwFW9n+t3rjFaUHZZfkjJV51c/KNkSRylz02 ZA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b65mr9tnk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 10:09:35 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18KA4q6T034439;
        Mon, 20 Sep 2021 10:09:34 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by aserp3030.oracle.com with ESMTP id 3b565cd8g5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 10:09:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jhS1BSQWS96xahmL/2kRnL9DTHgm8PSNw2HCrmTu6U6xmTXzEIf5khP7A8bJbUhqBhiUImdd9SdhO/MY9XaRP99GEeIwLNj7dPhpqwccLIccYPggP9a8j0zESdGRYNMVrgax8i5XbUCBOoyVizpW8Fe8NloJNHzgBpXRW+o8HoBAWt1MGDoeYsuFw/CirW0bAxGzBpDcZl5nKHD+7Y92XMj/+vk2FiPzKb0N8Mk8CS67zrPOOoWHUbKcDBhIAXRc7kukOej5MMxy6HaCwv+kgMSJzCCnSVPXF9Fo3m2AUXXyEu7z5lFDSXtBBc3sQ+CXf1oPBwsR8aeFfsB4oGylmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=xeEHnA4ypW7leo+pszPdKqfFL+td7pojjxHxdNTw/xo=;
 b=cH1zSvmlur4yi7YykDDOe0hUgbCiMw2BaXLNnFNOei1lf+l2VklyOg47gs/E+T6vaNOip2uLFJgpIgfqV94MkOcCHS04UWqFfnOYcdI1bvXmi7e/YfFJ3mLkLbbZDeAzVXtPnIZ6sBo0Padj0dgIlIhSmFQAx20WY1ecSmY0U4Thhg7KGzhmHQ5HuPTichXu/fXsxprTHtuBuxn9FhApp0StZDPQOoLS9dev4NBp+NejgxY10/vxC2jexTF3+VQSzmvOXAka+nUIz8h0LMu6Wp6iuOz6bG6DbVDHpbfg5uYdOTAtHrumkgptns+U/bTSL0wVlhBVjd5paSYGft3oxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xeEHnA4ypW7leo+pszPdKqfFL+td7pojjxHxdNTw/xo=;
 b=vZDT0zZ/Zvm+g/YsRn/NxHdMFag0tK7o0CdIoPz9hUbjRIMNzbjr4oL1W8R48BS0A6uL91hurpgoPKZZb2sSSB+l4z6WinNICqgjKUqXyAXQJTD2aMSMqYkc/DRcxXEucpi4skiarzOz5C1uvqfz3AB+G3h5NAcDu3UNx1WjUJI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4410.namprd10.prod.outlook.com (2603:10b6:806:fb::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.17; Mon, 20 Sep
 2021 10:09:33 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.018; Mon, 20 Sep 2021
 10:09:33 +0000
References: <163192854958.416199.3396890438240296942.stgit@magnolia>
 <163192856634.416199.12496831484611764326.stgit@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandanrlinux@gmail.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/14] xfs: dynamically allocate btree scrub context
 structure
In-reply-to: <163192856634.416199.12496831484611764326.stgit@magnolia>
Message-ID: <87v92v7etp.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Mon, 20 Sep 2021 15:23:54 +0530
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0008.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:21::18) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (223.182.249.90) by MA1PR0101CA0008.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:21::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Mon, 20 Sep 2021 10:09:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c47f6409-37f1-4adb-6213-08d97c1ebe0f
X-MS-TrafficTypeDiagnostic: SA2PR10MB4410:
X-Microsoft-Antispam-PRVS: <SA2PR10MB441062C9E05FE358456E3923F6A09@SA2PR10MB4410.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XpbE9QU71WPYxhUqvzYLuvzBG4X5F8m42EiZODB+WCxWNOOEZuBfSnOQU8PLt0DY8yB490LgVAwR+MHTFSJC60LBw5V6FbZ/svjsGdT287iegLnYG3dlHcaRfK0CIrjAVUpDDqimG14zd8jqd1IzcnyhpqCi1mo9Haly0XDqMBByDFwlPLMEh1eMejMJGZ/Qr2n/GFjkz4UiZiey5FQRBRlo8xPzmd+lDZm8tvWjjjc5Eiop5W812k1HPo3gTlO6ffA3GOAUMsSggzvbW+0/tBvJUGLNIRYlcED06vws0fXmRrE47vYJlqSv+M3pmtAxHuUVE6kHfQhPngixg8XMnrAzOvOp9fv45hLzDR0dL6KB7Uy4DvyqFEJTOMHslW7pn666s4fN2YMB0YsOMejWzwcQ5lLSyDO3ZOBPRzudUs7oEdhYYCT9DD72hDp7RS89bSZExTqJpCOpGpaZyt68YJvuDMHfJlnwQ3AvJt9ZcmnfFhlQJuD1tYDJtuzPaYD0L/ROBJ7cLs5tZkNvlOyIlAbeTKKPPKIEdd6VALxA1MBdsbUlWD50fPTL3C5Ghd41j8x5Xg87/zepMhzkpY+kPYqRuY9DzXZxiqqbGu3F25T6tqsc5Fd6Mm1BL1glQdPWczwPrVSj8aaVcgnlVBUCcMETOSUmN7etBYlrPL5I7umaal//GlKgy8rlaMju1VLKB76v4QCCz/3uhrVDhXUitg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(9686003)(83380400001)(186003)(26005)(6486002)(53546011)(66476007)(66556008)(6496006)(38100700002)(38350700002)(6666004)(52116002)(956004)(8936002)(4326008)(66946007)(2906002)(508600001)(316002)(5660300002)(6916009)(8676002)(33716001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JbdiHe/f1/m0ZraaYpxEMCF4n2xDwxq6FWZTt1Dl33LmTtCXKAxfRxdcgfAE?=
 =?us-ascii?Q?v+X4Nn+y60IoSvuEmQDUpyqvN0rrgMb87+F6rAEeTwJmCKEFAs/7H44V8aLd?=
 =?us-ascii?Q?mvQkgk71pCFxfue80PDXec0bjB3NE0iLo+fo208A1L/zNA5nuhorZrtQNFeG?=
 =?us-ascii?Q?rB/lrUI/bLoxiU73uAg9I2rI4qhd/yq6RwMmqa+3RB2FvrIFEhGspP6RdlAX?=
 =?us-ascii?Q?KFo/8vI5XUhs8xICKANIEOMa/FptfkL22TEVzFOouTuLE5vRq0cV7x9a8F0v?=
 =?us-ascii?Q?B6H1VDDzN2jtJ0xtt+/Yy0X5o+HrsYTL8Tg2nH0jIAWOnoyF78a+3DR/3STF?=
 =?us-ascii?Q?8F311WQPAQoktROCJmMWN5yRQUkQyJh8C8y/5XDc6UxXwezvysOaSZd00KHi?=
 =?us-ascii?Q?hYWsvA5lfj8oCjo4dpXHTIVFmP62JgOvh9euvOjpbNaxmi1I/av77dda/1ME?=
 =?us-ascii?Q?bVuvvfW/3iay7VxTKrvMnpSDvSKChccLy4aHIyx9VDJWfxyn3zQPugmNolQA?=
 =?us-ascii?Q?3e4bnUD3mS37uoBw0DwJk/XEO6kzfwMElCx6OSIf3lrxJ2imD/+If6JLfAF8?=
 =?us-ascii?Q?nr+jYODVqutDNKCkSnyhP/n+GMKxoIMfJNW0p9Y/VrTWN2nElOYpGviHWJ2w?=
 =?us-ascii?Q?7SworxtZlkCavfS1YXVyu09g0gbCVKZwgq/j3baqGZClE0HET/WQw505tLX/?=
 =?us-ascii?Q?Ug4DXEnqj9Qq6RG16JpiBH4t+qdyLtIBMvBkGIH6ps5Sx6gHudaLYVJekDUA?=
 =?us-ascii?Q?e4BMDSKQSt16IsYGNbMXNNSGpGuduFBxyIJ8tVkjw4P5XHnh+WlKnitaX+qL?=
 =?us-ascii?Q?nTJZ9E32yAdlONTcHYcRVGUncJ6JJHAQp6+fRRyl9eBenlU8iPFmhMUk3PET?=
 =?us-ascii?Q?ZCVrS7jmEMT8cUflbR7Z9x/191WamGqCf3oBeUE8BxVuwY345v/jXrk1yy8j?=
 =?us-ascii?Q?g3Jka/WFKpnOY9ki5TUnw7/YWOIvHMZ2EFist5Mvh2d/tF4IpW2jpdOBe/uW?=
 =?us-ascii?Q?0EzY+QehQuTrWY7y6RTg/QxqQ49QxrKdZ97qIcXTONxkhxWI/mTn0pGUi0EN?=
 =?us-ascii?Q?qkqHob6ahKa31Y6xlcx2VrUCXQnFRXpQUwdrxmI/S9psvF7zqlBJAnFRPCJd?=
 =?us-ascii?Q?UcEmnqoRVflgF3paHJaq9j4iuGlRNfBU41RZR/Uan4JYEKmlAGa2AAIRpUXe?=
 =?us-ascii?Q?0UlEI8AzURVTzwA5KyXwFwaRtOZ24jTOfqZWqXy66lWuVRrvMocEAYOyWyS9?=
 =?us-ascii?Q?ifum6bk/CqTGb0CiROhucOqdht+12DmBFCNCbSBiEq+wT329LbTRpE1cl1ry?=
 =?us-ascii?Q?qcdhI6TiM4l6VBB0aZIgOm7K?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c47f6409-37f1-4adb-6213-08d97c1ebe0f
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2021 10:09:33.2254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LtahsMyuxHNy4RviZyefpnMxQalSvd+K5YDEzAOrubnFD/bLyJnXuevQvza3iQ7vIRhCTD6hU1v8GLvhUQuDpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4410
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10112 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109200062
X-Proofpoint-GUID: _Mzkw5V0rnrmxsXc8vdnYdiWhlc0psWo
X-Proofpoint-ORIG-GUID: _Mzkw5V0rnrmxsXc8vdnYdiWhlc0psWo
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 18 Sep 2021 at 06:59, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Reorganize struct xchk_btree so that we can dynamically size the context
> structure to fit the type of btree cursor that we have.  This will
> enable us to use memory more efficiently once we start adding very tall
> btree types.

The changes look good to me from the perspective of functional correctness.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/btree.c |   38 +++++++++++++++++---------------------
>  fs/xfs/scrub/btree.h |   16 +++++++++++++---
>  2 files changed, 30 insertions(+), 24 deletions(-)
>
>
> diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
> index 26dcb4691e31..7b7762ae22e5 100644
> --- a/fs/xfs/scrub/btree.c
> +++ b/fs/xfs/scrub/btree.c
> @@ -141,9 +141,10 @@ xchk_btree_rec(
>  	trace_xchk_btree_rec(bs->sc, cur, 0);
>  
>  	/* If this isn't the first record, are they in order? */
> -	if (!bs->firstrec && !cur->bc_ops->recs_inorder(cur, &bs->lastrec, rec))
> +	if (bs->levels[0].has_lastkey &&
> +	    !cur->bc_ops->recs_inorder(cur, &bs->lastrec, rec))
>  		xchk_btree_set_corrupt(bs->sc, cur, 0);
> -	bs->firstrec = false;
> +	bs->levels[0].has_lastkey = true;
>  	memcpy(&bs->lastrec, rec, cur->bc_ops->rec_len);
>  
>  	if (cur->bc_nlevels == 1)
> @@ -188,11 +189,11 @@ xchk_btree_key(
>  	trace_xchk_btree_key(bs->sc, cur, level);
>  
>  	/* If this isn't the first key, are they in order? */
> -	if (!bs->firstkey[level] &&
> -	    !cur->bc_ops->keys_inorder(cur, &bs->lastkey[level], key))
> +	if (bs->levels[level].has_lastkey &&
> +	    !cur->bc_ops->keys_inorder(cur, &bs->levels[level].lastkey, key))
>  		xchk_btree_set_corrupt(bs->sc, cur, level);
> -	bs->firstkey[level] = false;
> -	memcpy(&bs->lastkey[level], key, cur->bc_ops->key_len);
> +	bs->levels[level].has_lastkey = true;
> +	memcpy(&bs->levels[level].lastkey, key, cur->bc_ops->key_len);
>  
>  	if (level + 1 >= cur->bc_nlevels)
>  		return;
> @@ -632,38 +633,33 @@ xchk_btree(
>  	union xfs_btree_ptr		*pp;
>  	union xfs_btree_rec		*recp;
>  	struct xfs_btree_block		*block;
> -	int				level;
>  	struct xfs_buf			*bp;
>  	struct check_owner		*co;
>  	struct check_owner		*n;
> -	int				i;
> +	size_t				cur_sz;
> +	int				level;
>  	int				error = 0;
>  
>  	/*
>  	 * Allocate the btree scrub context from the heap, because this
> -	 * structure can get rather large.
> +	 * structure can get rather large.  Don't let a caller feed us a
> +	 * totally absurd size.
>  	 */
> -	bs = kmem_zalloc(sizeof(struct xchk_btree), KM_NOFS | KM_MAYFAIL);
> +	cur_sz = xchk_btree_sizeof(cur->bc_nlevels);
> +	if (cur_sz > PAGE_SIZE) {
> +		xchk_btree_set_corrupt(sc, cur, 0);
> +		return 0;
> +	}
> +	bs = kmem_zalloc(cur_sz, KM_NOFS | KM_MAYFAIL);
>  	if (!bs)
>  		return -ENOMEM;
>  	bs->cur = cur;
>  	bs->scrub_rec = scrub_fn;
>  	bs->oinfo = oinfo;
> -	bs->firstrec = true;
>  	bs->private = private;
>  	bs->sc = sc;
> -
> -	/* Initialize scrub state */
> -	for (i = 0; i < XFS_BTREE_MAXLEVELS; i++)
> -		bs->firstkey[i] = true;
>  	INIT_LIST_HEAD(&bs->to_check);
>  
> -	/* Don't try to check a tree with a height we can't handle. */
> -	if (cur->bc_nlevels > XFS_BTREE_MAXLEVELS) {
> -		xchk_btree_set_corrupt(sc, cur, 0);
> -		goto out;
> -	}
> -
>  	/*
>  	 * Load the root of the btree.  The helper function absorbs
>  	 * error codes for us.
> diff --git a/fs/xfs/scrub/btree.h b/fs/xfs/scrub/btree.h
> index d5c0b0cbc505..7f8c54d8020e 100644
> --- a/fs/xfs/scrub/btree.h
> +++ b/fs/xfs/scrub/btree.h
> @@ -29,6 +29,11 @@ typedef int (*xchk_btree_rec_fn)(
>  	struct xchk_btree		*bs,
>  	const union xfs_btree_rec	*rec);
>  
> +struct xchk_btree_levels {
> +	union xfs_btree_key		lastkey;
> +	bool				has_lastkey;
> +};
> +
>  struct xchk_btree {
>  	/* caller-provided scrub state */
>  	struct xfs_scrub		*sc;
> @@ -39,12 +44,17 @@ struct xchk_btree {
>  
>  	/* internal scrub state */
>  	union xfs_btree_rec		lastrec;
> -	bool				firstrec;
> -	union xfs_btree_key		lastkey[XFS_BTREE_MAXLEVELS];
> -	bool				firstkey[XFS_BTREE_MAXLEVELS];
>  	struct list_head		to_check;
> +	struct xchk_btree_levels	levels[];
>  };
>  
> +static inline size_t
> +xchk_btree_sizeof(unsigned int levels)
> +{
> +	return sizeof(struct xchk_btree) +
> +				(levels * sizeof(struct xchk_btree_levels));
> +}
> +
>  int xchk_btree(struct xfs_scrub *sc, struct xfs_btree_cur *cur,
>  		xchk_btree_rec_fn scrub_fn, const struct xfs_owner_info *oinfo,
>  		void *private);


-- 
chandan
