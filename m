Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CD77C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Sep 2021 10:09:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35BD860E9C
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Sep 2021 10:09:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235599AbhITKKq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Sep 2021 06:10:46 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:20650 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235642AbhITKKp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Sep 2021 06:10:45 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KA6cXh008278;
        Mon, 20 Sep 2021 10:09:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=P35ORkvnNH97kWmXIQSPmJiTCcZabzezH2X5HVLiXH4=;
 b=LJPmRHukkVr2FsdDO4ZpCVeq3eFCpEfaAjUZ5FlLfMg0G6pD5Gs5AlZDhalaQQ1wqcKY
 r6MkW/z0i/cJ1H6eXpDPJeCq5I/u/ZWq6zxp8Qqb6pxZgKT2IDofWwHEFF/mOhBo/1QZ
 JlwWkc/sxbXsHzlRkx8ZK14I2FNfhaOO9FQXlAkfD5LlX8LPw4hzQ5BW2PqdVXYRCEof
 qLwujYov0pQy4ZPEiYWOK3qecMAS6XHTMBIs9BUJQKnbnlTiGdf7GB/4PLSYRSn009Pi
 WVnXabpuBGfJ6xt1A1VdWm+rh5gY7hMYCb8cqn/S5/dRUlZvqetD1KMvE0e0LF34xMWb Uw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2020-01-29;
 bh=P35ORkvnNH97kWmXIQSPmJiTCcZabzezH2X5HVLiXH4=;
 b=P/wwY1BXmx14nKERXvd/qG+9tIW2fCyHnTQZWDeuch7iEa0g4HC8K2Q5zzoXKEWjbecB
 5ZO+2dHg90qBlhLQae+05FU3DhJKsEiP1MOrAquc+OCRaxv/K3BNq5NZQyZ5oXjkYt8S
 TuXiIHEN+G850NLi92HTN3jAR2dETx2VkOpy0XQYjtsmjujF/EMKwwznxjVy1j2oeiBM
 ODbGyfe9+ByFfVrUSVnqNsIAUiHCzGDva2nryybLokUTkKOSpC1vOP3+DuhGaOsqdXml
 sl4P40w8umV4VfxjqnsW1LK+X/gxD7G4iE2D4y4bBK8hh31/O7TZhU0puOotHPgZzFJk Bg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b66hnhs7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 10:09:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18KA5Uht031714;
        Mon, 20 Sep 2021 10:09:16 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by userp3030.oracle.com with ESMTP id 3b557vayjq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 10:09:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GePtgsIfrugDCZeg76AmwgkvXCEREH+N/uc3FaFlqsGRiNVh80DqMP+UMj3GyuBEGuGxDJi0rtWlWd9z1TStQQpdvjTAr7jAI6W7qliNoIQKjmAwJJx1z5XT6I7DD2ZuNtk09/tE5hldpmpwhYsBXgMlLI0tzzaTDW9hF1i0dfTxCjMyapOiZnDPKaQ6isB2rWadU8DaoTbNQh2L687zIHEj5+wpYA6ciVMtPqP4CnS0sAb/MjVYKhrVgkmhpxBZSiWIeqvv0Wb3zlkMlEbe0TPL0YGxs3iEEWLvuYZELljZfnwsGd1K5a4oW16/n8WA+hvvIMaAkHmSCrC1tSvZPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=P35ORkvnNH97kWmXIQSPmJiTCcZabzezH2X5HVLiXH4=;
 b=H/IN2BSwlj28szsIiINy+0+dcAIdj3xUWldHevQc/PvDKAvUKPzbODtE+n+JKmjSiCVX2Oelj3uBAXmFfqcdBswX812qKb73B8z0k6g+3OP8b5xNFn5N3PthZBXEWzQ9hLtZnpa+ndwlTMjjy4QhemUkUUtxeQ3fjRmrR+NBWR0wOF/CZksKBlRuqQb688iPNUyjaXjmxOrowVkm5WY/wQulWay/S0AvlBDq+SMr6mJiDw6loNxSu4xLy6TD/LCb9wUaRkqyf/20emLh4xOko9xmCDcF3sHF7XVE2F1CPeD4+SRz62bKC7OfyC/teflMfUrVGQxLA5slBpXtt5yUFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P35ORkvnNH97kWmXIQSPmJiTCcZabzezH2X5HVLiXH4=;
 b=MnIVYM5lZ5w5678uZYuMNGRYjNDF++jkQdmcKSRTamy+XWdZya7OUzo6fG2QsjBBiPgSitnDErWvdVzzFWuURvKCU+NloxLi6H2dB0oQjMqZ8E4Z/SG3KAC+ubmbTsrX4nbmfz43IRzm2/QKdzEdxUE036G7HFokmSuVnhMnRfg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4410.namprd10.prod.outlook.com (2603:10b6:806:fb::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.17; Mon, 20 Sep
 2021 10:09:13 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.018; Mon, 20 Sep 2021
 10:09:13 +0000
References: <163192854958.416199.3396890438240296942.stgit@magnolia>
 <163192856086.416199.10504751435007741959.stgit@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandanrlinux@gmail.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/14] xfs: don't allocate scrub contexts on the stack
In-reply-to: <163192856086.416199.10504751435007741959.stgit@magnolia>
Message-ID: <87y27r7eu9.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Mon, 20 Sep 2021 15:23:34 +0530
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0009.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:21::19) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (223.182.249.90) by MA1PR0101CA0009.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:21::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Mon, 20 Sep 2021 10:09:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4364f1c2-290c-4d02-a04c-08d97c1eb24c
X-MS-TrafficTypeDiagnostic: SA2PR10MB4410:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4410AEAAC3159AD66DDCB89AF6A09@SA2PR10MB4410.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zjznetUcXQYM5qYWNr6zVNl0yUAXuzC0LS1jD8Fu0txRu0mqSigH8SW89LLi/5cGHnaegVs8yN1LtF7EbuCzIANVpmo0SmLcB+oD72K2QP6PiwDMtL8MymOearqwgR5Q71EZnGmUVHqEZGZPCyu9KQwFmdYpmWNTLPVC8IIyvruF6cR6/ubfPbNFjj5wC2fWcYMzEq9kL8t/MARYtH9du/3COkY7H5FJYUspe5jvyTLDhIb0fxR1RV2ZPtZn9TGMOMmTg211nB6k2YwISeFN6FQMwBxcnyWbHAeSqg5TETi8/oIik5EgRSxU2E99aVls0YNbCWHcGDA0wKaYfs3oeAUAB44EY9nOEIt3qpOLkqJ+L+PT4gLOFJm0jco+PDD+K53rylvRo9VHOI1/b90EyhpSCXHN/wPaUxucibWgY2waO2Z/NkYIU6DwLyV1f9je2KefEdF5zgbV+RGozKsZ1HBKEjA0xcK4A0Kb4PtI2AZ/VHHdYwiI6wtaaUlxMyPMUzSzfrSaCHYHawyFAitAzuXwq8ljCfIUZeLPrXKGi9AP8kCgIhECIPecXCGNcRXtov30aKebbizekgYnJbkn868LNJfG0I6bM5Lu4Cd/L6xHNn3kvKCTi1/zREzUuIeEE0a6fkuX3WsJ4vVrf5Wu1uWsUVv2gfHQ9tz0zLpjG27lY/TSB1XH54xrfVmKnLB1e9gAR38z7JHAtFzcm72Gyg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(9686003)(83380400001)(186003)(26005)(6486002)(53546011)(66476007)(66556008)(6496006)(38100700002)(38350700002)(6666004)(52116002)(956004)(8936002)(4326008)(66946007)(2906002)(508600001)(30864003)(316002)(5660300002)(6916009)(8676002)(33716001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ou0gp9+2HrQWbbborVm/pOIALPsg156KhRKYAMl42SCsPD1Etyof9qteFV63?=
 =?us-ascii?Q?WwbpG6apNaI9kFYXD401HcjH4vgn7cgiabaRW3/8PfI6QQSmD8Qpph44UEfM?=
 =?us-ascii?Q?0pklrAInIh47+nczzZq2D/5Slsb8lfUSMm73nGLE1VLPQNepa0uFwMA/TZ2b?=
 =?us-ascii?Q?ufnR4AGoH4zYsNsbAq/sgxySoT6cK1iF56o3SjQgisSsFQjqcAjIiYm0LoOV?=
 =?us-ascii?Q?tW2bLUSPmIkmF+K9Ft4LLGR77Y5q6BIPB7Cbxm/0wuyOaIXTLnDxI3FTLobE?=
 =?us-ascii?Q?ubDXv5N2sZKxlqqcH613JhZJOjFB7LNqZr6+H7owS5IzGLQ8elt6y4OvRoF4?=
 =?us-ascii?Q?xVpK/KgoEzVUOkCrcSRjhzYxUlyyeEzMYNS2hFSYzrT4Xgh4GEwp4wCASizg?=
 =?us-ascii?Q?IlfSWaWlUPAvkoYyUGSBgtLDfk5KH4QAcmECMt4AACV7GmfrW1KOCxMZtuXc?=
 =?us-ascii?Q?4kvMKNkEln6hragrdp97JSSGMPoZLn5SY7UZFkraJ3fzOTNz+gfGqLDio5Xj?=
 =?us-ascii?Q?b11C8aAlmFZW2r/oE9f9fG/e8tN+m2uaPm+fW85Rxr51gSXzjtHHujROaaNm?=
 =?us-ascii?Q?2XsPXrbPL5hx8yo1DkFKRXaRWiceSrEMKKR0uVqz2Zs2agVjQI37aXSmxf0Z?=
 =?us-ascii?Q?EwKJi+fomJB+hWX/nMhDkxEipXOC5LndID7YMyZRD7/6SEi5YlIigkCF+Fby?=
 =?us-ascii?Q?ZZY69z7GL5PYnMi6qN/Kq+Trq9v/U3xgkB2zyMaeoVChVuAX6C3MqBOy2ZlQ?=
 =?us-ascii?Q?5Yo1wl5QM4wAhbiUotvLFHxRHLZfA9HM18jHt/Mugv8R67CiBCrvObHui5iZ?=
 =?us-ascii?Q?xXeXoek8Wj5dYruWpYKAeFos1IY42oYrc7b+7s2vfqTWOKsQ4wqMhLV25Cq3?=
 =?us-ascii?Q?SXq881AlDchVDa3NaQdjqX7+8tbcI+CeBko8J/WM3jgauwPqrLmnsTP8x4GB?=
 =?us-ascii?Q?36h7kojxIogyJL4cqLINQJR9P6klTnrUuNBjdflEsi9YadzvCu1IHtmfPU0T?=
 =?us-ascii?Q?Aaui0FPP9pD4PzLq1yvfoxIFbba53+yqC1B3WPb48vigpvaxOJ+DiU63avIh?=
 =?us-ascii?Q?4bpmvhLofk9DoG2xcyXDMM1OIicD1N86fKtFlJuMt+kY00dLM2QhidKKuLpo?=
 =?us-ascii?Q?PXn+9hUVFhvWG8qHZMD+dClPEjvT1NYZWQQBhWTpNvc8wewKiB6N3QAjzU2U?=
 =?us-ascii?Q?Zw5Dpt5HMCqbHbbTJf1wR3W9BJsfujf8vUyUk9yVcLnTLW5OHyhuUi8NAjCl?=
 =?us-ascii?Q?Zq8PslvG/o8NpBeRu1Rqsj75xrR8sL77k9uB/Q+A9Iwsvn2J9XF6W72Z5qGe?=
 =?us-ascii?Q?2jHO+7qJI6xaTefeLAI47sj3?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4364f1c2-290c-4d02-a04c-08d97c1eb24c
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2021 10:09:13.7619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wyE4BNMX3OdkyfRTF2MX8X+cvu7eT1qYmCV14XQpd/4PtdgsulbKVUufSM+Vva0trcRK0/SH+pmoQJAra5xflA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4410
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10112 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 spamscore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109200062
X-Proofpoint-GUID: ZXnPiCIxJMcm3buXc7pCqb3rp0Bi-J87
X-Proofpoint-ORIG-GUID: ZXnPiCIxJMcm3buXc7pCqb3rp0Bi-J87
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 18 Sep 2021 at 06:59, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Convert the on-stack scrub context, btree scrub context, and da btree
> scrub context into a heap allocation so that we reduce stack usage and
> gain the ability to handle tall btrees without issue.
>
> Specifically, this saves us ~208 bytes for the dabtree scrub, ~464 bytes
> for the btree scrub, and ~200 bytes for the main scrub context.
>

Apart from the nits pointed below, the remaining changes look good to me.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>


> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/btree.c   |   54 ++++++++++++++++++++++++------------------
>  fs/xfs/scrub/btree.h   |    1 +
>  fs/xfs/scrub/dabtree.c |   62 ++++++++++++++++++++++++++----------------------
>  fs/xfs/scrub/scrub.c   |   60 ++++++++++++++++++++++++++--------------------
>  4 files changed, 98 insertions(+), 79 deletions(-)
>
>
> diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
> index eccb855dc904..26dcb4691e31 100644
> --- a/fs/xfs/scrub/btree.c
> +++ b/fs/xfs/scrub/btree.c
> @@ -627,15 +627,8 @@ xchk_btree(
>  	const struct xfs_owner_info	*oinfo,
>  	void				*private)
>  {
> -	struct xchk_btree		bs = {
> -		.cur			= cur,
> -		.scrub_rec		= scrub_fn,
> -		.oinfo			= oinfo,
> -		.firstrec		= true,
> -		.private		= private,
> -		.sc			= sc,
> -	};
>  	union xfs_btree_ptr		ptr;
> +	struct xchk_btree		*bs;
>  	union xfs_btree_ptr		*pp;
>  	union xfs_btree_rec		*recp;
>  	struct xfs_btree_block		*block;
> @@ -646,10 +639,24 @@ xchk_btree(
>  	int				i;
>  	int				error = 0;
>  
> +	/*
> +	 * Allocate the btree scrub context from the heap, because this
> +	 * structure can get rather large.
> +	 */
> +	bs = kmem_zalloc(sizeof(struct xchk_btree), KM_NOFS | KM_MAYFAIL);
> +	if (!bs)
> +		return -ENOMEM;
> +	bs->cur = cur;
> +	bs->scrub_rec = scrub_fn;
> +	bs->oinfo = oinfo;
> +	bs->firstrec = true;
> +	bs->private = private;
> +	bs->sc = sc;
> +
>  	/* Initialize scrub state */
>  	for (i = 0; i < XFS_BTREE_MAXLEVELS; i++)
> -		bs.firstkey[i] = true;
> -	INIT_LIST_HEAD(&bs.to_check);
> +		bs->firstkey[i] = true;
> +	INIT_LIST_HEAD(&bs->to_check);
>  
>  	/* Don't try to check a tree with a height we can't handle. */
>  	if (cur->bc_nlevels > XFS_BTREE_MAXLEVELS) {
> @@ -663,9 +670,9 @@ xchk_btree(
>  	 */
>  	level = cur->bc_nlevels - 1;
>  	cur->bc_ops->init_ptr_from_cur(cur, &ptr);
> -	if (!xchk_btree_ptr_ok(&bs, cur->bc_nlevels, &ptr))
> +	if (!xchk_btree_ptr_ok(bs, cur->bc_nlevels, &ptr))
>  		goto out;
> -	error = xchk_btree_get_block(&bs, level, &ptr, &block, &bp);
> +	error = xchk_btree_get_block(bs, level, &ptr, &block, &bp);
>  	if (error || !block)
>  		goto out;
>  
> @@ -678,7 +685,7 @@ xchk_btree(
>  			/* End of leaf, pop back towards the root. */
>  			if (cur->bc_ptrs[level] >
>  			    be16_to_cpu(block->bb_numrecs)) {
> -				xchk_btree_block_keys(&bs, level, block);
> +				xchk_btree_block_keys(bs, level, block);
>  				if (level < cur->bc_nlevels - 1)
>  					cur->bc_ptrs[level + 1]++;
>  				level++;
> @@ -686,11 +693,11 @@ xchk_btree(
>  			}
>  
>  			/* Records in order for scrub? */
> -			xchk_btree_rec(&bs);
> +			xchk_btree_rec(bs);
>  
>  			/* Call out to the record checker. */
>  			recp = xfs_btree_rec_addr(cur, cur->bc_ptrs[0], block);
> -			error = bs.scrub_rec(&bs, recp);
> +			error = bs->scrub_rec(bs, recp);
>  			if (error)
>  				break;
>  			if (xchk_should_terminate(sc, &error) ||
> @@ -703,7 +710,7 @@ xchk_btree(
>  
>  		/* End of node, pop back towards the root. */
>  		if (cur->bc_ptrs[level] > be16_to_cpu(block->bb_numrecs)) {
> -			xchk_btree_block_keys(&bs, level, block);
> +			xchk_btree_block_keys(bs, level, block);
>  			if (level < cur->bc_nlevels - 1)
>  				cur->bc_ptrs[level + 1]++;
>  			level++;
> @@ -711,16 +718,16 @@ xchk_btree(
>  		}
>  
>  		/* Keys in order for scrub? */
> -		xchk_btree_key(&bs, level);
> +		xchk_btree_key(bs, level);
>  
>  		/* Drill another level deeper. */
>  		pp = xfs_btree_ptr_addr(cur, cur->bc_ptrs[level], block);
> -		if (!xchk_btree_ptr_ok(&bs, level, pp)) {
> +		if (!xchk_btree_ptr_ok(bs, level, pp)) {
>  			cur->bc_ptrs[level]++;
>  			continue;
>  		}
>  		level--;
> -		error = xchk_btree_get_block(&bs, level, pp, &block, &bp);
> +		error = xchk_btree_get_block(bs, level, pp, &block, &bp);
>  		if (error || !block)
>  			goto out;
>  
> @@ -729,13 +736,14 @@ xchk_btree(
>  
>  out:
>  	/* Process deferred owner checks on btree blocks. */
> -	list_for_each_entry_safe(co, n, &bs.to_check, list) {
> -		if (!error && bs.cur)
> -			error = xchk_btree_check_block_owner(&bs,
> -					co->level, co->daddr);
> +	list_for_each_entry_safe(co, n, &bs->to_check, list) {
> +		if (!error && bs->cur)
> +			error = xchk_btree_check_block_owner(bs, co->level,
> +					co->daddr);
>  		list_del(&co->list);
>  		kmem_free(co);
>  	}
> +	kmem_free(bs);
>  
>  	return error;
>  }
> diff --git a/fs/xfs/scrub/btree.h b/fs/xfs/scrub/btree.h
> index b7d2fc01fbf9..d5c0b0cbc505 100644
> --- a/fs/xfs/scrub/btree.h
> +++ b/fs/xfs/scrub/btree.h
> @@ -44,6 +44,7 @@ struct xchk_btree {
>  	bool				firstkey[XFS_BTREE_MAXLEVELS];
>  	struct list_head		to_check;
>  };
> +
>  int xchk_btree(struct xfs_scrub *sc, struct xfs_btree_cur *cur,
>  		xchk_btree_rec_fn scrub_fn, const struct xfs_owner_info *oinfo,
>  		void *private);
> diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
> index 8a52514bc1ff..b962cfbbd92b 100644
> --- a/fs/xfs/scrub/dabtree.c
> +++ b/fs/xfs/scrub/dabtree.c
> @@ -473,7 +473,7 @@ xchk_da_btree(
>  	xchk_da_btree_rec_fn		scrub_fn,
>  	void				*private)
>  {
> -	struct xchk_da_btree		ds = {};
> +	struct xchk_da_btree		*ds;
>  	struct xfs_mount		*mp = sc->mp;
>  	struct xfs_da_state_blk		*blks;
>  	struct xfs_da_node_entry	*key;
> @@ -486,32 +486,35 @@ xchk_da_btree(
>  		return 0;
>  
>  	/* Set up initial da state. */
> -	ds.dargs.dp = sc->ip;
> -	ds.dargs.whichfork = whichfork;
> -	ds.dargs.trans = sc->tp;
> -	ds.dargs.op_flags = XFS_DA_OP_OKNOENT;
> -	ds.state = xfs_da_state_alloc(&ds.dargs);
> -	ds.sc = sc;
> -	ds.private = private;
> +	ds = kmem_zalloc(sizeof(struct xchk_da_btree), KM_NOFS | KM_MAYFAIL);
> +	if (!ds)
> +		return -ENOMEM;
> +	ds->dargs.dp = sc->ip;
> +	ds->dargs.whichfork = whichfork;
> +	ds->dargs.trans = sc->tp;
> +	ds->dargs.op_flags = XFS_DA_OP_OKNOENT;
> +	ds->state = xfs_da_state_alloc(&ds->dargs);
> +	ds->sc = sc;
> +	ds->private = private;
>  	if (whichfork == XFS_ATTR_FORK) {
> -		ds.dargs.geo = mp->m_attr_geo;
> -		ds.lowest = 0;
> -		ds.highest = 0;
> +		ds->dargs.geo = mp->m_attr_geo;
> +		ds->lowest = 0;
> +		ds->highest = 0;
>  	} else {
> -		ds.dargs.geo = mp->m_dir_geo;
> -		ds.lowest = ds.dargs.geo->leafblk;
> -		ds.highest = ds.dargs.geo->freeblk;
> +		ds->dargs.geo = mp->m_dir_geo;
> +		ds->lowest = ds->dargs.geo->leafblk;
> +		ds->highest = ds->dargs.geo->freeblk;
>  	}
> -	blkno = ds.lowest;
> +	blkno = ds->lowest;
>  	level = 0;
>  
>  	/* Find the root of the da tree, if present. */
> -	blks = ds.state->path.blk;
> -	error = xchk_da_btree_block(&ds, level, blkno);
> +	blks = ds->state->path.blk;
> +	error = xchk_da_btree_block(ds, level, blkno);
>  	if (error)
>  		goto out_state;
>  	/*
> -	 * We didn't find a block at ds.lowest, which means that there's
> +	 * We didn't find a block at ds->lowest, which means that there's
>  	 * no LEAF1/LEAFN tree (at least not where it's supposed to be),
>  	 * so jump out now.
>  	 */
> @@ -523,16 +526,16 @@ xchk_da_btree(
>  		/* Handle leaf block. */
>  		if (blks[level].magic != XFS_DA_NODE_MAGIC) {
>  			/* End of leaf, pop back towards the root. */
> -			if (blks[level].index >= ds.maxrecs[level]) {
> +			if (blks[level].index >= ds->maxrecs[level]) {
>  				if (level > 0)
>  					blks[level - 1].index++;
> -				ds.tree_level++;
> +				ds->tree_level++;
>  				level--;
>  				continue;
>  			}
>  
>  			/* Dispatch record scrubbing. */
> -			error = scrub_fn(&ds, level);
> +			error = scrub_fn(ds, level);
>  			if (error)
>  				break;
>  			if (xchk_should_terminate(sc, &error) ||
> @@ -545,17 +548,17 @@ xchk_da_btree(
>  
>  
>  		/* End of node, pop back towards the root. */
> -		if (blks[level].index >= ds.maxrecs[level]) {
> +		if (blks[level].index >= ds->maxrecs[level]) {
>  			if (level > 0)
>  				blks[level - 1].index++;
> -			ds.tree_level++;
> +			ds->tree_level++;
>  			level--;
>  			continue;
>  		}
>  
>  		/* Hashes in order for scrub? */
> -		key = xchk_da_btree_node_entry(&ds, level);
> -		error = xchk_da_btree_hash(&ds, level, &key->hashval);
> +		key = xchk_da_btree_node_entry(ds, level);
> +		error = xchk_da_btree_hash(ds, level, &key->hashval);
>  		if (error)
>  			goto out;
>  
> @@ -564,11 +567,11 @@ xchk_da_btree(
>  		level++;
>  		if (level >= XFS_DA_NODE_MAXDEPTH) {
>  			/* Too deep! */
> -			xchk_da_set_corrupt(&ds, level - 1);
> +			xchk_da_set_corrupt(ds, level - 1);
>  			break;
>  		}
> -		ds.tree_level--;
> -		error = xchk_da_btree_block(&ds, level, blkno);
> +		ds->tree_level--;
> +		error = xchk_da_btree_block(ds, level, blkno);
>  		if (error)
>  			goto out;
>  		if (blks[level].bp == NULL)
> @@ -587,6 +590,7 @@ xchk_da_btree(
>  	}
>  
>  out_state:
> -	xfs_da_state_free(ds.state);
> +	xfs_da_state_free(ds->state);
> +	kmem_free(ds);
>  	return error;
>  }
> diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
> index 51e4c61916d2..0569b15526ea 100644
> --- a/fs/xfs/scrub/scrub.c
> +++ b/fs/xfs/scrub/scrub.c
> @@ -461,15 +461,10 @@ xfs_scrub_metadata(
>  	struct file			*file,
>  	struct xfs_scrub_metadata	*sm)
>  {
> -	struct xfs_scrub		sc = {
> -		.file			= file,
> -		.sm			= sm,
> -	};
> +	struct xfs_scrub		*sc;
>  	struct xfs_mount		*mp = XFS_I(file_inode(file))->i_mount;
>  	int				error = 0;
>  
> -	sc.mp = mp;
> -
>  	BUILD_BUG_ON(sizeof(meta_scrub_ops) !=
>  		(sizeof(struct xchk_meta_ops) * XFS_SCRUB_TYPE_NR));
>  
> @@ -489,59 +484,68 @@ xfs_scrub_metadata(
>  
>  	xchk_experimental_warning(mp);
>  
> -	sc.ops = &meta_scrub_ops[sm->sm_type];
> -	sc.sick_mask = xchk_health_mask_for_scrub_type(sm->sm_type);
> +	sc = kmem_zalloc(sizeof(struct xfs_scrub), KM_NOFS | KM_MAYFAIL);
> +	if (!sc) {
> +		error = -ENOMEM;
> +		goto out;
> +	}
> +
> +	sc->mp = mp;
> +	sc->file = file;
> +	sc->sm = sm;
> +	sc->ops = &meta_scrub_ops[sm->sm_type];
> +	sc->sick_mask = xchk_health_mask_for_scrub_type(sm->sm_type);
>  retry_op:
>  	/*
>  	 * When repairs are allowed, prevent freezing or readonly remount while
>  	 * scrub is running with a real transaction.
>  	 */
>  	if (sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) {
> -		error = mnt_want_write_file(sc.file);
> +		error = mnt_want_write_file(sc->file);
>  		if (error)
>  			goto out;

The above should be "goto out_sc" ...

>  	}
>  
>  	/* Set up for the operation. */
> -	error = sc.ops->setup(&sc);
> +	error = sc->ops->setup(sc);
>  	if (error)
>  		goto out_teardown;
>  
>  	/* Scrub for errors. */
> -	error = sc.ops->scrub(&sc);
> -	if (!(sc.flags & XCHK_TRY_HARDER) && error == -EDEADLOCK) {
> +	error = sc->ops->scrub(sc);
> +	if (!(sc->flags & XCHK_TRY_HARDER) && error == -EDEADLOCK) {
>  		/*
>  		 * Scrubbers return -EDEADLOCK to mean 'try harder'.
>  		 * Tear down everything we hold, then set up again with
>  		 * preparation for worst-case scenarios.
>  		 */
> -		error = xchk_teardown(&sc, 0);
> +		error = xchk_teardown(sc, 0);
>  		if (error)
>  			goto out;

... also, the one above.

> -		sc.flags |= XCHK_TRY_HARDER;
> +		sc->flags |= XCHK_TRY_HARDER;
>  		goto retry_op;
>  	} else if (error || (sm->sm_flags & XFS_SCRUB_OFLAG_INCOMPLETE))
>  		goto out_teardown;
>  
> -	xchk_update_health(&sc);
> +	xchk_update_health(sc);
>  
> -	if ((sc.sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) &&
> -	    !(sc.flags & XREP_ALREADY_FIXED)) {
> +	if ((sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) &&
> +	    !(sc->flags & XREP_ALREADY_FIXED)) {
>  		bool needs_fix;
>  
>  		/* Let debug users force us into the repair routines. */
>  		if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_FORCE_SCRUB_REPAIR))
> -			sc.sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
> +			sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
>  
> -		needs_fix = (sc.sm->sm_flags & (XFS_SCRUB_OFLAG_CORRUPT |
> -						XFS_SCRUB_OFLAG_XCORRUPT |
> -						XFS_SCRUB_OFLAG_PREEN));
> +		needs_fix = (sc->sm->sm_flags & (XFS_SCRUB_OFLAG_CORRUPT |
> +						 XFS_SCRUB_OFLAG_XCORRUPT |
> +						 XFS_SCRUB_OFLAG_PREEN));
>  		/*
>  		 * If userspace asked for a repair but it wasn't necessary,
>  		 * report that back to userspace.
>  		 */
>  		if (!needs_fix) {
> -			sc.sm->sm_flags |= XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED;
> +			sc->sm->sm_flags |= XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED;
>  			goto out_nofix;
>  		}
>  
> @@ -549,26 +553,28 @@ xfs_scrub_metadata(
>  		 * If it's broken, userspace wants us to fix it, and we haven't
>  		 * already tried to fix it, then attempt a repair.
>  		 */
> -		error = xrep_attempt(&sc);
> +		error = xrep_attempt(sc);
>  		if (error == -EAGAIN) {
>  			/*
>  			 * Either the repair function succeeded or it couldn't
>  			 * get all the resources it needs; either way, we go
>  			 * back to the beginning and call the scrub function.
>  			 */
> -			error = xchk_teardown(&sc, 0);
> +			error = xchk_teardown(sc, 0);
>  			if (error) {
>  				xrep_failure(mp);
> -				goto out;
> +				goto out_sc;
>  			}
>  			goto retry_op;
>  		}
>  	}
>  
>  out_nofix:
> -	xchk_postmortem(&sc);
> +	xchk_postmortem(sc);
>  out_teardown:
> -	error = xchk_teardown(&sc, error);
> +	error = xchk_teardown(sc, error);
> +out_sc:
> +	kmem_free(sc);
>  out:
>  	trace_xchk_done(XFS_I(file_inode(file)), sm, error);
>  	if (error == -EFSCORRUPTED || error == -EFSBADCRC) {


-- 
chandan
