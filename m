Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A190C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Sep 2021 10:11:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AFAE60F25
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Sep 2021 10:11:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235691AbhITKNH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Sep 2021 06:13:07 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:29810 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235607AbhITKNG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Sep 2021 06:13:06 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KA7199008283;
        Mon, 20 Sep 2021 10:11:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Boby2SKU2OJ9CapDzQD5tfkBZpaqf893taWsctVCFsc=;
 b=jRmCgIdyRWB3u3GfsuAQK0ThoYXxt+chabBQr92+4AEGvd3fT/nGpYzc9HUnmLfXE+HM
 zPK3lHmbpfz0fEDlLXm/UO5/leJh2HkphEssuVR0brkrd9Pq8I6fXvV23DV/1n2BuXy5
 FH/SSvqnlwgTJ06kBt2+p4ssNTfT4128s4q+pr8oBg+eeGN3t8An4maSEOLFxxkswe13
 xSqQJQQdqEIpkxT9HAecgl+7R6DIjS0NJ8s3tpN+h8dQa34Ai8Eeaz6kfEWdFr6f2OOi
 kBbXKaLbRHzXIpSfahNqyyrkDzghO5rSAlqBiDbdjiIMEcSK97iMfNLgrmIjR9D+0T2I IA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Boby2SKU2OJ9CapDzQD5tfkBZpaqf893taWsctVCFsc=;
 b=B7uI5UIoTHcIzkHS0XYqc8tIOIeenupBQ4Yj+kllxJxXebyR37fYMPy9hOBPVMFS4Pi7
 p6ZCvlURJo0MeXSVQyJAXBwDBipR015k0CUjf+0EzJmWbYym4U0EZNsdsarPEkifG4C0
 VMAmaNMU/dpJXo+vxoMvL6ndJPXeRo+bThMYCZCS0ygdtyw2RTkwKUfszNF2M2j1KFvo
 3+HjtaKEmSG0fAe6x/58XKNnqDh/Z5oAdss9hzm/I6aiC8vx70kHFfAEhmaiAUBWLIoT
 G/MY+cTGKZut1S8pdnAj95skh27XJm1lUyXHVUKOzqlFgyzwRi/fsAhfc6CXAhMZg4cT EQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b66hnhse9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 10:11:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18KAAidr116098;
        Mon, 20 Sep 2021 10:11:38 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by aserp3020.oracle.com with ESMTP id 3b57x3u02g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 10:11:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AvBY+KEo8PgIJdUbKkelqOHhTUwrV/E447ATbNfQU8pH9cFbMJjadn01OF0igDcliWG5pVL1ZMJilRXd7pwuIyJwKscOJhEI9yBWfYcplAI5jAIURfdgHrmLSTlREfEAiMIJVSU0qvRP5rxCEDasXl9HQShJrHe8xf9E3+FeyT1Unjd+Pq5RDG7FQAeNi9Mbf4KObR4nOTXXYzE63USNHY9CkaWE6U89okU5cCYqaCOvYYguGEpo6a4RKSV0FNo3EkyTqew2CXgwZzQqCJC9FZhn0zr+nsgR4b1Eq66P1Vvq44yJmGTgoe4yJUPEKCLg0RqYfsxTY38cVcdjEk+2Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Boby2SKU2OJ9CapDzQD5tfkBZpaqf893taWsctVCFsc=;
 b=U/FYAjDhZpNraXYn7ATXVFOT9Sw6DHddWTbVO30Qxb0YjU1euChB4SdST6Xcij/t/Ttzgoo0PlnFP5UjnPA8KtODlkxieSasGLzda5vLZGuV0tOEJBDtwnLTgC5W84ttR+sohdk3y0dofg+vvZxFpFNXMFYBHO/8Tj2g5C1EcHx7JN4029tDMLteR6gL5XgyKX1Yn4a9CfkyV53pvJvRHIWpheydvMbTRypfnDGi+PbwckKzoVRrzfzTo+eaxJLEob/F8QierQwIjznjT9KZz8+a5Pfx9IomF2CAsmy3tv+KBTgNK0ZOWrTiqWX9IAWFeiPP8mf0QKKBDzDgFkv5DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Boby2SKU2OJ9CapDzQD5tfkBZpaqf893taWsctVCFsc=;
 b=Vd72Sh2/64lPHiKebG3BuFbT6Uo7Q9oPTOO7RxbuzRqTq6Vv95aA/Wf8QBU0lNq3Pmz63Z3Mp8APfT8rYG+j4L4c/eafLGOIMW/WJFq2wMhmpWwqhEs7HiZ084P1EtQyOl8WwatpZ4UU0mh08N4LRIlbFIzp/8ZhokKrdekcSO4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4540.namprd10.prod.outlook.com (2603:10b6:806:110::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Mon, 20 Sep
 2021 10:11:36 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.018; Mon, 20 Sep 2021
 10:11:36 +0000
References: <163192854958.416199.3396890438240296942.stgit@magnolia>
 <163192860467.416199.3157992669504614921.stgit@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandanrlinux@gmail.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/14] xfs: encode the max btree height in the cursor
In-reply-to: <163192860467.416199.3157992669504614921.stgit@magnolia>
Message-ID: <87bl4n7eqh.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Mon, 20 Sep 2021 15:25:50 +0530
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0068.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::30) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (223.182.249.90) by MAXPR0101CA0068.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:e::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Mon, 20 Sep 2021 10:11:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b7a4a191-fca1-42d5-e4b2-08d97c1f073d
X-MS-TrafficTypeDiagnostic: SA2PR10MB4540:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4540FD788D4FDD3952AC8F25F6A09@SA2PR10MB4540.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YBciz3vc1lmI78qaVnBxExtCvlj0czRSn8Lkku8rRTJSfqxPHiqs8qr1tatyYddWrq3tCau0MXZdEYheNn0OW6ZfBun1o1NN+K+wZ1LU02ARz4/WyTlsFPB9Llnw1PIuPYouHuBkVE+OgNjcLFndNvXW4yJ/r4wtiLc2oLz7286W+3B5utskq+s8qPz/XZ8hscq/hwopg736EkwBF1sQY9/HX4TMYz4u1oScAO3mkoin+M80+VKn/DSaCjTgFDPk1pgp34bjGqYsQWDIlodWUyMKH4NTZ3omSOhqvgj2VrzZoU56jTBhlGiUaxwA8xFyPOZaT0ZBe0xvTikPgWxXtJMwFGMH9BfW+wlny+4VyqM8WKdBl2z8pcV4tGU0T6bD0fO/3dz6Q03KclEsrAOk6q5xBLflkP7QmqQK5INIYGvgbgM6iTjNDDtnrJ7p0hs+Z3ljx/Fcf4krd9PSPMlSkcRrV2kbyvniWeVnBnsDG+oJ2K2m7+kOYbzXifbNOW99uRf0vgRpFgHEkN2QS6EqxV3cR7DBe2v49HMy4aTNJ8omLAx+2p0/2q3fgoyu3uMr4Y8ZMCIN5sbn6oo4f4G3QpFZdDlF3MzvQq1vw2FZVCG3lrkKzQ97My5bIaOrge1dehUm46XLymMutoA8NQzEHYFEFZb/mo6gvD/u5/ghW0wg1/OIVGpg4NgI3d8rTA730RNqptTCXq3BGBos3w0bZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(316002)(4326008)(33716001)(26005)(52116002)(53546011)(6916009)(86362001)(6496006)(38100700002)(8676002)(6486002)(508600001)(5660300002)(38350700002)(66946007)(956004)(186003)(66476007)(83380400001)(9686003)(66556008)(2906002)(8936002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IB+6yrJelU4/PWv94A9I5HQ5hFQsPIu++mfJZ8JeP7qynXvEOomn0VzmviCe?=
 =?us-ascii?Q?BPICjCRJbjLsvrs8WFTtF5oEfsr4+WFlwRnbL1Lx79bONLdWrZsvezc+Y/kZ?=
 =?us-ascii?Q?JwMMhwvVKGtTzlL4NTHLJ0BKjzJfeWgccF4jyV6GNazBhKHU+NuPfoI3A2bs?=
 =?us-ascii?Q?TAAxJTrc/iF7T4pFVDI9iijC5dDjWMVcvO3xfDXYLp7GUauxxHxy89JBYiBZ?=
 =?us-ascii?Q?pOy47PvCWujLG51nm7Tsta6IN0oA3hXKCOvEOyGbKFiX4yu4nANoCJ0pbFP1?=
 =?us-ascii?Q?2APQNm7nxiph03/jZARJtGWmKRu2pCkOeOc5uVExRuqWCgeYs7o63r0eKmtS?=
 =?us-ascii?Q?Meh1zRdSGQP11hr2P9RJZTkCBmVUVuWxz4cxcxwlI+RLxi+nF+0fNb4qyqtq?=
 =?us-ascii?Q?TZUYohyjo0xG5CeBaxpUYWe56sBLuO/c3NKGXZcvO/limoAyeWawaBONWa7D?=
 =?us-ascii?Q?OaySokl+5M/d6cC/7WWQxk0IwCVXvy1qB2qKbMWFW4CMdboynN4a3Eil/vtL?=
 =?us-ascii?Q?pa++uKdgoq3Yy7S/z6mPLwvldAh4powyFCyTR77ACAK4eb1nEsmYembHpzVp?=
 =?us-ascii?Q?/69sOXGHSB5zD7uc1B0qKSEA2r9Hm8UnIFuMwmjtxSCjHgvrmbZToNn8d+jq?=
 =?us-ascii?Q?DWt/iP51E+MQb5EMek6YV7NJni+qwblkGKTFAvqBwWkkm1MCbzEFzJ/kB59V?=
 =?us-ascii?Q?a774tUxuae7EHNbF5NKL2wnAozsjBLOEnO1bLibk3v/fiBelZe3Pg2Lo8PoC?=
 =?us-ascii?Q?XSLl+lpjgCcKxnoPm4aGmve8sJhpAV3dsEr0r0kr4d6Ee4Ncano3Fb9d+bWI?=
 =?us-ascii?Q?sJvRKrLaBrxSIOgiKyjGyFakayQw6cPWUKpV1iDFJQhk+A3gzALgWZCizX0Y?=
 =?us-ascii?Q?A4DlvEiGeKOHoi/7qef6n75az7e6TfvxWT+SS1xx17R2vMS4V+u1k5uxEUjn?=
 =?us-ascii?Q?AvF4V0C3hc2i3NpHsVqcrAf2BrGaHKflzNyJM711NMd0lp8xTcQ5skVaRFhD?=
 =?us-ascii?Q?XSdGZSBQL3MKlAnyEEd/ft9DOXpySchQogtgQMCjlvrDdT4gZNPfS6UuSVms?=
 =?us-ascii?Q?4o18GQem2t9fPuIQhwF15yjU6WpTFKu+/urpw6MXM5nIdBl2Uw5JEgi0TINf?=
 =?us-ascii?Q?dj9y/SnzxM1BRzVW6mP6Thj7KfZGwn1ezhyWmUxMBwct3LAMUW0bzoSBmHMw?=
 =?us-ascii?Q?8DRVFsaG2NPp631x2hp0SMOWGe5rMAME/Ykr3MvlDTtE+ouSOaLjaydMWi64?=
 =?us-ascii?Q?lJ8MNfR/UKOW2uhPKsadQPN+pk0pFXjspajTNfsg6NsE5JC5E1IaQ4qOD4xU?=
 =?us-ascii?Q?t3J9psfOSYAeh8c3JQqWQXdm?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7a4a191-fca1-42d5-e4b2-08d97c1f073d
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2021 10:11:35.9969
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yGN0VNBKA+pPXtvwlah0XBBy8VYszmqfZnasxw6J2hiDlv48ztjegwmEdugbC0LyjoyuUF6AMcaTic6X8HMuhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4540
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10112 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109200063
X-Proofpoint-GUID: 271ESS6FMXnAQ-IfjIGb-B0C2ydwyqAH
X-Proofpoint-ORIG-GUID: 271ESS6FMXnAQ-IfjIGb-B0C2ydwyqAH
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 18 Sep 2021 at 07:00, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Encode the maximum btree height in the cursor, since we're soon going to
> allow smaller cursors for AG btrees and larger cursors for file btrees.
>

Looks good.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_bmap.c          |    2 +-
>  fs/xfs/libxfs/xfs_btree.c         |    5 +++--
>  fs/xfs/libxfs/xfs_btree.h         |    3 ++-
>  fs/xfs/libxfs/xfs_btree_staging.c |   10 +++++-----
>  4 files changed, 11 insertions(+), 9 deletions(-)
>
>
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 644b956301b6..2ae5bf9a74e7 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -239,7 +239,7 @@ xfs_bmap_get_bp(
>  	if (!cur)
>  		return NULL;
>  
> -	for (i = 0; i < XFS_BTREE_MAXLEVELS; i++) {
> +	for (i = 0; i < cur->bc_maxlevels; i++) {
>  		if (!cur->bc_levels[i].bp)
>  			break;
>  		if (xfs_buf_daddr(cur->bc_levels[i].bp) == bno)
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 70785004414e..2486ba22c01d 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -2933,7 +2933,7 @@ xfs_btree_new_iroot(
>  	be16_add_cpu(&block->bb_level, 1);
>  	xfs_btree_set_numrecs(block, 1);
>  	cur->bc_nlevels++;
> -	ASSERT(cur->bc_nlevels <= XFS_BTREE_MAXLEVELS);
> +	ASSERT(cur->bc_nlevels <= cur->bc_maxlevels);
>  	cur->bc_levels[level + 1].ptr = 1;
>  
>  	kp = xfs_btree_key_addr(cur, 1, block);
> @@ -3097,7 +3097,7 @@ xfs_btree_new_root(
>  	xfs_btree_setbuf(cur, cur->bc_nlevels, nbp);
>  	cur->bc_levels[cur->bc_nlevels].ptr = nptr;
>  	cur->bc_nlevels++;
> -	ASSERT(cur->bc_nlevels <= XFS_BTREE_MAXLEVELS);
> +	ASSERT(cur->bc_nlevels <= cur->bc_maxlevels);
>  	*stat = 1;
>  	return 0;
>  error0:
> @@ -4941,6 +4941,7 @@ xfs_btree_alloc_cursor(
>  	cur->bc_mp = mp;
>  	cur->bc_btnum = btnum;
>  	cur->bc_blocklog = mp->m_sb.sb_blocklog;
> +	cur->bc_maxlevels = XFS_BTREE_MAXLEVELS;
>  
>  	return cur;
>  }
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index 6540c4957c36..6075918efa0c 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -235,9 +235,10 @@ struct xfs_btree_cur
>  	struct xfs_mount	*bc_mp;	/* file system mount struct */
>  	const struct xfs_btree_ops *bc_ops;
>  	uint			bc_flags; /* btree features - below */
> -	union xfs_btree_irec	bc_rec;	/* current insert/search record value */
> +	uint8_t		bc_maxlevels;	/* maximum levels for this btree type */
>  	uint8_t		bc_nlevels;	/* number of levels in the tree */
>  	uint8_t		bc_blocklog;	/* log2(blocksize) of btree blocks */
> +	union xfs_btree_irec	bc_rec;	/* current insert/search record value */
>  	xfs_btnum_t	bc_btnum;	/* identifies which btree type */
>  	int		bc_statoff;	/* offset of btre stats array */
>  
> diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
> index cc56efc2b90a..dd75e208b543 100644
> --- a/fs/xfs/libxfs/xfs_btree_staging.c
> +++ b/fs/xfs/libxfs/xfs_btree_staging.c
> @@ -657,12 +657,12 @@ xfs_btree_bload_compute_geometry(
>  	 * checking levels 0 and 1 here, so set bc_nlevels such that the btree
>  	 * code doesn't interpret either as the root level.
>  	 */
> -	cur->bc_nlevels = XFS_BTREE_MAXLEVELS - 1;
> +	cur->bc_nlevels = cur->bc_maxlevels - 1;
>  	xfs_btree_bload_ensure_slack(cur, &bbl->leaf_slack, 0);
>  	xfs_btree_bload_ensure_slack(cur, &bbl->node_slack, 1);
>  
>  	bbl->nr_records = nr_this_level = nr_records;
> -	for (cur->bc_nlevels = 1; cur->bc_nlevels <= XFS_BTREE_MAXLEVELS;) {
> +	for (cur->bc_nlevels = 1; cur->bc_nlevels <= cur->bc_maxlevels;) {
>  		uint64_t	level_blocks;
>  		uint64_t	dontcare64;
>  		unsigned int	level = cur->bc_nlevels - 1;
> @@ -703,7 +703,7 @@ xfs_btree_bload_compute_geometry(
>  			 * block-based btree level.
>  			 */
>  			cur->bc_nlevels++;
> -			ASSERT(cur->bc_nlevels <= XFS_BTREE_MAXLEVELS);
> +			ASSERT(cur->bc_nlevels <= cur->bc_maxlevels);
>  			xfs_btree_bload_level_geometry(cur, bbl, level,
>  					nr_this_level, &avg_per_block,
>  					&level_blocks, &dontcare64);
> @@ -719,14 +719,14 @@ xfs_btree_bload_compute_geometry(
>  
>  			/* Otherwise, we need another level of btree. */
>  			cur->bc_nlevels++;
> -			ASSERT(cur->bc_nlevels <= XFS_BTREE_MAXLEVELS);
> +			ASSERT(cur->bc_nlevels <= cur->bc_maxlevels);
>  		}
>  
>  		nr_blocks += level_blocks;
>  		nr_this_level = level_blocks;
>  	}
>  
> -	if (cur->bc_nlevels > XFS_BTREE_MAXLEVELS)
> +	if (cur->bc_nlevels > cur->bc_maxlevels)
>  		return -EOVERFLOW;
>  
>  	bbl->btree_height = cur->bc_nlevels;


-- 
chandan
