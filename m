Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33452C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Sep 2021 10:09:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14B6B60E9C
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Sep 2021 10:09:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233090AbhITKLU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Sep 2021 06:11:20 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:55560 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235691AbhITKLT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Sep 2021 06:11:19 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18K7v3dx028074;
        Mon, 20 Sep 2021 10:09:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=gR+Ro2t2x6/oizji9JCPS6gSTAhxEhv+dJtOdwu5BrE=;
 b=StgJOePxw8SpO2TuM9VfOanXCcsMHX0HNUu4nV6cZrfqzTL8XwLwY/V7T7UMoMyT5ZSi
 CygP2ScV70yJ9+4BTWJoitnx0SnrmX32AMIwmyB3vxqrmL2f2i5IBs53/gFpy8/AAOq2
 hc/JJh7WCnH0sNPfXy+Dz7MrCy3NprEOb8Qq1cZujrLz0DTCzCiHt6EW9V+/Ni39Qklp
 ZTOPie3XlZ030Nq+NcGQqYJRMM+PaApVr8BOgEYs/UAUIYgxOGVgIMPAwdW8Lq5Y479U
 pM9hfsBfnuck8/qEul2kk6mAwamrciZgv846G7JOOuVO/QiPDusUj31jpTh2XyVGoAIs MQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2020-01-29;
 bh=gR+Ro2t2x6/oizji9JCPS6gSTAhxEhv+dJtOdwu5BrE=;
 b=JGKiCBqicCw2JAhWvLJm3gDW1bJwyqqxKv9FzO7wC60C5NFSS8GzuBb82qd2TWAGWK23
 CNGwSBJlvOxxCFntpXWOIL8ybbI1GziiH0K+S8WdUc0FtZxofcLBXZDWGbQHHb22SWEA
 mhJJozHTt9hmf2qWGAYhD8uVpKcKRvrYXU25KjdfgqorUPNpy6gNn32G8e+X3j7ZOeBC
 00lL6dkS6GpyMNvSnmq6VNnUhCrWcrbpdJLa6HUCYwAYYjzbhxLDDeZnLcvDX0D+6i52
 vRjosqupNB4OVHnrMavSsGmX+GC871gLe1Sxu4zs+71WtyiWrYnI/GS2wSYOf4Tj9N2X nw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b65mr9tp2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 10:09:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18KA4hnl096435;
        Mon, 20 Sep 2021 10:09:50 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by aserp3020.oracle.com with ESMTP id 3b57x3tx80-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 10:09:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UoDJi3sXj0+BFvLDsNRHIP7PBOC+FOVHV/KuzzBmfHfmFGvT22EsMo25uletiI3L29kY6aBZbNSfMdKWF/mMCO6bPBkbBceCZHUl4pCVKnfC2w5WDAPbm+p1OeJqKZoJLHFPqei73/2DgZXoFwV9AjH5VcADZlCKFbtBtf/uUyylHmOlSabz8uh7177IkhaYSdlaqNzA8398345/TyDFPbd268N8IOHvvjcP+AYQZ/leGp5ZSlNavnmZhVPEFNHa4rQfUGeZqByyvYWvHBCtqd5g7boPafbh3r7ZzLmDcuyHAGp9Ixf9/r6VkgwY6hgZpFQok7B7f+1YWHQFmN3jMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=gR+Ro2t2x6/oizji9JCPS6gSTAhxEhv+dJtOdwu5BrE=;
 b=klHwtT8qtHK+UkLYFapWVirJ8nS9i4NKpfGv7aX9C9C7Tb714Y7uqURqpmAmtu8RDrCpLPvh683R4awuDFMkvUPoWCYfCgsQuUsPIqCYYl6qTEKCIHwXZ7iEI7yL5u5mWwi5c0DRVk/hIBhYnJBuQsuYlcV/8dO6TW5jiElk/VUGhq8G2tk64WfBtBn7eFv33rq471yM1ZO70r8huSLI9IblnpogoZdetZ3MdcgNrQMLBXP+tZEgMEFYXtzmql6rQkZsRIap1K2BB5tckXksL6luJXw9KWc499oAgB27pWvgp6Z96DLd2G+55hbQxcPSUKf+bAbUf0U4J6n99IwURw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gR+Ro2t2x6/oizji9JCPS6gSTAhxEhv+dJtOdwu5BrE=;
 b=JmrQ06uwmD7WA3XVFqByxem8sulHqCwjBPK3Yy/rEsFf2x13R3hw2wEEpY+nXsvNMjftORXZq2H01pnKhaDdGU2cIVrKekIGpG0J5xWYvGHZ/loBuv0cqDlwgslVFTmhKHZbrCJi0qoW3m3HlY+cBKfjCjcVj5y4y+0SJVeem+0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4410.namprd10.prod.outlook.com (2603:10b6:806:fb::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.17; Mon, 20 Sep
 2021 10:09:49 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.018; Mon, 20 Sep 2021
 10:09:48 +0000
References: <163192854958.416199.3396890438240296942.stgit@magnolia>
 <163192857182.416199.9310383108874723785.stgit@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandanrlinux@gmail.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/14] xfs: stricter btree height checking when looking
 for errors
In-reply-to: <163192857182.416199.9310383108874723785.stgit@magnolia>
Message-ID: <87sfxz7et8.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Mon, 20 Sep 2021 15:24:11 +0530
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0143.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::13) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (223.182.249.90) by MA1PR01CA0143.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Mon, 20 Sep 2021 10:09:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21c39997-b791-4f6c-af96-08d97c1ec76c
X-MS-TrafficTypeDiagnostic: SA2PR10MB4410:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4410CFC5E04DB6F2383ED48BF6A09@SA2PR10MB4410.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gkz9aKn1IEXhwAmfyxfHAyvmmNkSGvBHP48q3wNwJ5U21IIXi5YjCZQuukP3G3/YYUB5SJ0bDnOOjKrTeWa6k2mgYe4TpxghKB+nNwOv28+Tmjlp/zda/RX6ix6tyd+R+euMHtVV3oZJPH45oMCvBrdFYe1+MEPtH65stziD1oh5XtLGUf345lAo5B55CzP7L213UnGqC/jGcI/fYEaOZ3/hWUkaXaEhGg5qRiuIGNFD6wBiXIWOrG2NgXUILlRYzloOvm0UbU4+ZgMrlqgKDUJom/bxWGhaDB132ITnirY5x1OiQnVv+dkfFCaf7yYWQdQ8/M0XP7uTOaMaSXNgpHyDPPIEjUxPNN80q9f1XCVku8WJZ9PdZVhKC9xpR6VbSI1TGD/lxyzkHvlcdFxg9VWV6TpvQZrN6GFUvcVsj84Pj5xVJJRkvVkfzDl3xVjgjEay3yR9g5kKYpKdOhSSgdzcVpc0liYOw/az3coa/VREKxDx7CapROh0htiJ2puF+HDxCSaLEvJNZ+AU55nKENpdaAJ0jBBCTIUXOktHhIB1TlusmsQoDx133Z3YEHoT4g3HP2FHNfILJyC0+GlApeKLy2GGEQAbwP/XkG+c1dr6bWtoQnp3NApORUxhQAXMtgXY2uIJQdx66E9sjn0rZ6DK9esLxypksOPAR5S571/2JPeTme1Rsb/GtSPfdIJm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(9686003)(83380400001)(186003)(26005)(6486002)(53546011)(66476007)(66556008)(6496006)(38100700002)(38350700002)(6666004)(52116002)(956004)(8936002)(4326008)(66946007)(2906002)(508600001)(316002)(5660300002)(6916009)(8676002)(33716001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yzmgxu233DgPq3ZpU2svtHiIMqcfaA8t33fNnn9rZ2MemNg93j+V8j+LMYRB?=
 =?us-ascii?Q?Zp7RCGq4pwUuO0e7iq5rT2NZq+xsa2hKU0oV9f1sbKJgCxlIc++2rR1eIx/A?=
 =?us-ascii?Q?ltUoFNOSr/9XVfBzx7IyLYOVIdjzNjMHlAwiwj0T+ek5/eeCwN+6UT0Bk4vn?=
 =?us-ascii?Q?AAeLLXrYdVAaNKo4JJn+PUsszgGMTzL4db7emnVaRLd88Gl4WSPslD1g/2+A?=
 =?us-ascii?Q?mLTDsX48b7fbAIwc9m1a+RklfHZNYgagnFi3YUKpoZ+hrAci9F1Zg6JRybIY?=
 =?us-ascii?Q?WUhkshmKwYiO1mHM8rYPG9s69YauWdE6b402Jz5tFi51RWEmGPZuf2hGbmQV?=
 =?us-ascii?Q?W/BQ0TFuL85cKED4SyWM4BHUh+dyrRx8jDE1KybsmWk8E2aztT/nC2YtLX0h?=
 =?us-ascii?Q?Ypr9hFu3mvGxoEogj2OfKXPqWUAor4BCFFYRS6/3CVjohAQyzhlXR9vuy8qW?=
 =?us-ascii?Q?qqGrKwu3ruo78JBRQoiLCLr4NS486rLBVToivcyeWea2sO1KUL2fZlhPiZLb?=
 =?us-ascii?Q?buD3lYqiAW+648khfTpezcwI3htXnMFFv6LgJV5176ZLDvx29hDd65Q3jpVa?=
 =?us-ascii?Q?BX9xA6KIPrwX+16TPn6x7tme8b3s5O/ciryY/INquyrvDbrgqH3BOX5eWiDG?=
 =?us-ascii?Q?ROCbz4s6WHTNXU6V57pJQtns1eXhzh4z/zaeQeJBfA/U53ivlLCF6ykPhaoK?=
 =?us-ascii?Q?DMHWROo9UTvNrCwwakeqRVmPxDN6ejks2XHh17btP0gWGWJwIXLEF2TEigVN?=
 =?us-ascii?Q?HWri0FkqTUB10U67ERqFQTQEpm99mPMr99WebebKVQ9Rkq/okglqRg25PFlH?=
 =?us-ascii?Q?PNa+zIkC0dOuw6WXEa+1zYnZ6A9Xaeksyra6V7dSK4NTd44uUheC+FuuA/fj?=
 =?us-ascii?Q?vFpXgbsNbKYjbRAowcwgr84LjzpeUCeYsGWJsoCAB4SvzcKLySLNhZ27+YkH?=
 =?us-ascii?Q?c+ZSfw8oYWx7R3inyGzQDgfVmAAY/KfQX6GOlu1qr8xUSV+/OcCslD0mWs+s?=
 =?us-ascii?Q?sV4nwIhNY3/R0IczfVhOLhgQjqIlvjp24URhloaThJ1pge2y3Fwes7/WT6gF?=
 =?us-ascii?Q?7IPu5Ryln0PLQg8bYk6MiDIqwtOcmxz9hGCtM5o/jhAqqR9tnfGFiree1Yqv?=
 =?us-ascii?Q?q/elnISUk96/JdOu7SYngzib6wI0aSTY0pxvunzrUpSzcGxgL4pw+nBGgg9R?=
 =?us-ascii?Q?ua53pAm30TT1V7zM06wNZ6rNh5Z0iq2bqlKvZzaGSxJIg9Xl9e0kT6AplCZj?=
 =?us-ascii?Q?1o/swm8CihXGCppVgdANUta7S1VQOOxDCPfjYvnB76Qxq4VprD2sqgMB+JZF?=
 =?us-ascii?Q?o05SCg0/XkU89Bk5nbcEsykV?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21c39997-b791-4f6c-af96-08d97c1ec76c
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2021 10:09:48.9314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uwNX5PZipWVSkSyiat27ZxYyK7X4P+GybTtShvUjhym5wxiQuTpiu1ddlUPQi2oEKDSEPiKHfSb8HPUlx/zPxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4410
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10112 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109200062
X-Proofpoint-GUID: DhqprdWa7PiwOuG-Mw6QtUONIPGwCm0g
X-Proofpoint-ORIG-GUID: DhqprdWa7PiwOuG-Mw6QtUONIPGwCm0g
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 18 Sep 2021 at 06:59, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Since each btree type has its own precomputed maxlevels variable now,
> use them instead of the generic XFS_BTREE_MAXLEVELS to check the level
> of each per-AG btree.

Looks good.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/agheader.c |   13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
>
>
> diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> index ae3c9f6e2c69..a2c3af77b6c2 100644
> --- a/fs/xfs/scrub/agheader.c
> +++ b/fs/xfs/scrub/agheader.c
> @@ -555,11 +555,11 @@ xchk_agf(
>  		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
>  
>  	level = be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]);
> -	if (level <= 0 || level > XFS_BTREE_MAXLEVELS)
> +	if (level <= 0 || level > mp->m_ag_maxlevels)
>  		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
>  
>  	level = be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]);
> -	if (level <= 0 || level > XFS_BTREE_MAXLEVELS)
> +	if (level <= 0 || level > mp->m_ag_maxlevels)
>  		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
>  
>  	if (xfs_has_rmapbt(mp)) {
> @@ -568,7 +568,7 @@ xchk_agf(
>  			xchk_block_set_corrupt(sc, sc->sa.agf_bp);
>  
>  		level = be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]);
> -		if (level <= 0 || level > XFS_BTREE_MAXLEVELS)
> +		if (level <= 0 || level > mp->m_rmap_maxlevels)
>  			xchk_block_set_corrupt(sc, sc->sa.agf_bp);
>  	}
>  
> @@ -578,7 +578,7 @@ xchk_agf(
>  			xchk_block_set_corrupt(sc, sc->sa.agf_bp);
>  
>  		level = be32_to_cpu(agf->agf_refcount_level);
> -		if (level <= 0 || level > XFS_BTREE_MAXLEVELS)
> +		if (level <= 0 || level > mp->m_refc_maxlevels)
>  			xchk_block_set_corrupt(sc, sc->sa.agf_bp);
>  	}
>  
> @@ -850,6 +850,7 @@ xchk_agi(
>  	struct xfs_mount	*mp = sc->mp;
>  	struct xfs_agi		*agi;
>  	struct xfs_perag	*pag;
> +	struct xfs_ino_geometry	*igeo = M_IGEO(sc->mp);
>  	xfs_agnumber_t		agno = sc->sm->sm_agno;
>  	xfs_agblock_t		agbno;
>  	xfs_agblock_t		eoag;
> @@ -880,7 +881,7 @@ xchk_agi(
>  		xchk_block_set_corrupt(sc, sc->sa.agi_bp);
>  
>  	level = be32_to_cpu(agi->agi_level);
> -	if (level <= 0 || level > XFS_BTREE_MAXLEVELS)
> +	if (level <= 0 || level > igeo->inobt_maxlevels)
>  		xchk_block_set_corrupt(sc, sc->sa.agi_bp);
>  
>  	if (xfs_has_finobt(mp)) {
> @@ -889,7 +890,7 @@ xchk_agi(
>  			xchk_block_set_corrupt(sc, sc->sa.agi_bp);
>  
>  		level = be32_to_cpu(agi->agi_free_level);
> -		if (level <= 0 || level > XFS_BTREE_MAXLEVELS)
> +		if (level <= 0 || level > igeo->inobt_maxlevels)
>  			xchk_block_set_corrupt(sc, sc->sa.agi_bp);
>  	}
>  


-- 
chandan
