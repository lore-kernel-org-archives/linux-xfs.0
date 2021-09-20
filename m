Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A64D8C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Sep 2021 10:12:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CB7260F25
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Sep 2021 10:12:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233135AbhITKOT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Sep 2021 06:14:19 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:30492 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230289AbhITKOS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Sep 2021 06:14:18 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18K9lYjM006007;
        Mon, 20 Sep 2021 10:12:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=c3UlN6/gYRe43AHMHsf1Gtr9FQkL5eAxzRYVWpCou5A=;
 b=PxVjbssHokhj1ATjSvQiaQHlueUxqWwt0VZsZMdNyl4nsGaiSZttvzHSEPN+WIByYKr/
 DpYwh2pKqaA8B+UgfJ1y1gzy84t3pozW21zMfl2f8pa2h900XhjH1J/SdKEGv6S5IdL+
 gQ9Qm14T579OvaRzj1P7Fobd+G1NzCwhOauCiGrzgPfdvPme6aECq2Nmp9r0pv5HkoLZ
 K5D9pFCCCp1xvJ4O1nIiGqszrmJ8H4Tnsy9+Gn5mjCpeVCQt2EBtYvwRFfcJqO2HDZFX
 V6sWeSYdzQ6mRobmgcr1W49Wtr0mnGb87/PIi47pf0W0KydkMUju4S0+HsSHrI2C2cIb kw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2020-01-29;
 bh=c3UlN6/gYRe43AHMHsf1Gtr9FQkL5eAxzRYVWpCou5A=;
 b=RkR1z7XVBOy7UiVntmjMUuRIiG5iP4KD7drNDrDc8NGdmZ9V5PnSrmVpeD0rAZHrmR+C
 zwpcOv4CPjO3EC5YDk6KMlFEnOv2Qiltzr6k/2IzF4acJ5KoMWfjNRG0fPiB3YQUcMht
 yge6MXfa8D0ijYkIoEGqZFb0YdY4nznvusaTvpDcbJv2wsJwEPRsXCLrSL3pYtuZNSej
 A3dtstHZwZtJkCUcuSEzLR4d1vdZf+34i9v9/i1uti3ZO25FoxCQGUls2JQf7aQcFCPg
 h0l8ODkyC8Qwx6c7WAvIp5JH/f/OO3jcTNZaWoOchBKq1s9E1w73gNllbnMqQj2gamyN Pg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b6426a07u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 10:12:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18KA9tga085268;
        Mon, 20 Sep 2021 10:12:48 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by userp3020.oracle.com with ESMTP id 3b5svqfvtj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 10:12:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h7IwmlZgIWn02QFX2VObJL6T+jxMTyTlAcTbwM+JZRL2bll+U17g13qpa7Wu1ErtUWtFeq282idVPv5ra6IaXArIBlsoK5ZJLMQ/8u+yioRTsgc4lx9Z7ng7XR2WzW8GHKvF9N8ez/bUoKBOoj7kuPPHFBmZdEXbDTIXvf4uegTJgIr5KeGOqLpo7cBs4mXW9CiorB4p6Aw4XV8CPL2nwjPjBCcbwlhXvjraBtHSF4emR1fYoy+/Uoqz5ybupMjOUJC2C3GNdTJUu4+KzdN6Sc35IAxZE73e7oJa57a76GygVEm5zL+ezioPly/RXSGytgBuHAVVx5E4vlm62rOJrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=c3UlN6/gYRe43AHMHsf1Gtr9FQkL5eAxzRYVWpCou5A=;
 b=CE7wudSVmF0Xw8CtVzjeVQP0yHtlyEW4wouwn1pTjxyQYbI9jpE/TTDs3lRvChJSKrzy9hxY6Qw9qRSvVy9vENYRgh0YcoWzwLHeDO+MoJwNquZ2VXdJsb9LkeAgvy10b+FSDZBbYwkrbnFM67spebXNqpZ+Cg6WspdtTkqqbJAsgIk222FFFf2cxOlRuUOFqNck+A1cY6HAwwF3cW/0FMFoU/0PAg8Nwtq2YTmSAGjNbdFkS4/Bfa9RFSlFNVglbGIb/7Upf6spkkFDZoSfT3ay5e/+Zz5dMKDYxpSbR2Zj8jEbqvryYWtCCKr81kBfp2KUoEj95h47JjLaWJtdYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c3UlN6/gYRe43AHMHsf1Gtr9FQkL5eAxzRYVWpCou5A=;
 b=mo5uGAt3nzCnEUSFucSiyPsFVeb1QFT+GxpheKNrzV8zyvUNtD8ba5vKgHgK/dEKCim1C2fPzWKDCe8BsdkDtKGZOxvxi/UsiY/imqqmMT+LT1VKUZjxJECs0jC9jEZSxeo4X+WdFz8xRaUbs9P/DXeFmQjGJZge46B3cQNcizQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4540.namprd10.prod.outlook.com (2603:10b6:806:110::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Mon, 20 Sep
 2021 10:12:46 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.018; Mon, 20 Sep 2021
 10:12:46 +0000
References: <163192854958.416199.3396890438240296942.stgit@magnolia>
 <163192862659.416199.7915871246193862758.stgit@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandanrlinux@gmail.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/14] xfs: kill XFS_BTREE_MAXLEVELS
In-reply-to: <163192862659.416199.7915871246193862758.stgit@magnolia>
Message-ID: <87zgs7603s.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Mon, 20 Sep 2021 15:27:11 +0530
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0164.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::34) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (223.182.249.90) by MA1PR01CA0164.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Mon, 20 Sep 2021 10:12:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f82ab15-08bb-412d-8446-08d97c1f316e
X-MS-TrafficTypeDiagnostic: SA2PR10MB4540:
X-Microsoft-Antispam-PRVS: <SA2PR10MB45405044BB0262B5663184F0F6A09@SA2PR10MB4540.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:43;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N/LKNMNXqgqN5oZoXTvC5nohUlLGHF2DdaupXWMvQeIAiEaeHzUUOs+AERulenE+WpnFDNez8JReHWIQEQYON2tjq25Nrkmf1xXbku3TaMqAistn6SlfPbQumQQpRzcFcIJJrFeVDcLpzRq9WHsYPEn4NAh0kp5XTW5w5pxAQfpGRqrVwKpRhyqE+X3gtaSdubK+IhdqbVykxJvQbKHL3V/L14jOgoDR4SeX0Eo+RwUO10qqsSUDdv5cEv9jkSQ7m4v4TinOsnttGB5bFylHXeU4yzjy48vLlJb+odLlj7TJV6D8+tzogWCcUyZOF5cdjSso00ZWH7ngBVJGolnTQQIOnhFuB4JEbLsmZAd43Ghibih4uZCF0xCyOWYAhwKKUsfdRb6EOkcTg52L+QmYlmMZEXFoipE7g7da32Pp3kGCCFxpLFRsquOG9qx0dhtksGPYsDQ843PkEUKvnksEjD7KMvFQbW5ql8Jm+zasQwm2cS30UMUFjdJv5dkKo9p/mF5nCmf469EPNtyJX4jT+J0DQE25PLQ0ESFf9tLtHVIYKMUfqq0ny3b3lDhKD+Gp02JEo8IgPXzilKX0cCUAscjWC34lMDrtVX4c7toWJ8xgzmWYv3SAVJZn7H2RsdnORyzhpar+WNAQSibyD7qVPRpdqe8VqBJ6lL0BhKLy25Y0VMXJ4U6SQHcl7vZ5gz3Y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(316002)(4326008)(33716001)(26005)(52116002)(53546011)(6916009)(86362001)(6496006)(38100700002)(8676002)(6486002)(508600001)(5660300002)(38350700002)(66946007)(956004)(186003)(66476007)(83380400001)(9686003)(66556008)(2906002)(8936002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/p7OYmOEQLlJqhnrHQuL0He/UweAcb0uyVu+7dW0SoirV/8LI7G11rNyO4Xx?=
 =?us-ascii?Q?y1JDnv0PubE7pzfN8V0gjMkO8VV0PO38V2FDl1+rXdLC2Q09pEY/QwCbd/2n?=
 =?us-ascii?Q?1FHNJnZ+YV6p2h6ig0kgF1GtvBQeE4G9G/UX7eaFqjMYAhDPRjRp3j6qVFeK?=
 =?us-ascii?Q?cuCvgJLxnMlm4rauGKaDAtVk84Fz3cvm/oRfO0Y5wHNui92utMC1Xp0QpQDc?=
 =?us-ascii?Q?WI7rVcFljiQp6UCedpg3Nq52h0tTYZp7rUavpnvvmpv5LcymzlnHrILKlxEE?=
 =?us-ascii?Q?aC5DFkcU47EmG0WJEGyT8Isnhbv6HYaBCO/NBkcIfisBZHQBdJygcqO46hyo?=
 =?us-ascii?Q?wXzUPDJcE7lt0yzzqM0NZEB5ubLG7G6NuEPAwvv55JSvpEJ7GOuEHdkRWlSX?=
 =?us-ascii?Q?poScMLWIi5c0KLMKSrNNSfWtyMQgWWO0ZgKv4f3VjBm1DECckyFAfkq4tgCP?=
 =?us-ascii?Q?iJ4e6I9XGCm8f+PNBIcI5dpdzBlA5lD8f65Qbw7CixGJE6YHMUCEDdD3qCU2?=
 =?us-ascii?Q?o1MQqwHEqacfBgdl/4JcIOBH4+fvQbkVAc3XOPngck8fvDZYP0EU2tmsuVVh?=
 =?us-ascii?Q?0/dcJUP/rqHAqNn0zWa2h1kYMRs8jeuEX2LpO2RNrLpU4apAzvdPpCT5xh+y?=
 =?us-ascii?Q?TeCuEFiWwAl9bLkyXFIAkhBfNfjkZwgQFdj9znOQdXuH6dwTicNU9hKXRhgU?=
 =?us-ascii?Q?lRP/7ZQ0DGpI0/ux1z/D3RYLZz14pwDQECGm4ZM1oQ4d+bG/v0Fu5tHWDsfb?=
 =?us-ascii?Q?EZ8Iwc6lRJPNHexzPGD2CozpRfcBUu716ek9BpIgZhzAHm/mR2TonGvcHHZY?=
 =?us-ascii?Q?kl41yJfm6GNDpnUPMU9YPnMdgdkVNJ7IHHoFZqQehqJsZhYbg5TD2b//PnrM?=
 =?us-ascii?Q?ehAu6kMXTvrXWQ+bC7WhZ7Q/D9BC5S1G3kRu6WKIvdqfnHDIoDIDCzMVGwjK?=
 =?us-ascii?Q?L+reVPEcQlrRMUFC8iICnjDcWQkTFfsEnhANIJ+t3RITOQL2r2Ps7xkYvIQh?=
 =?us-ascii?Q?oTlMz0bzbPdOveKm0DaW0MdVOdlbKLJBgIT0LKLbe+PPswgbBVWgI32kXpjP?=
 =?us-ascii?Q?a+1NBcTqqlg1FbFU4uTwwsa/YjaI4egAOHQ3hLePeX3iX75M1T55H5FgKkHn?=
 =?us-ascii?Q?WYrJt792iD2XicyI3Z8SgIJXvb62V5eKPsVchXbQJNBRKtSHdvRccOXkyzy2?=
 =?us-ascii?Q?nDWWqNr8+mB87zKi+1vGAtxiOMhUn7KJMGCyb38lXoYVwkL8hUBL71BlAg4n?=
 =?us-ascii?Q?cUvfD6mjavkXKFyngA9pOXjTjgi70ckA2qJc3veRk4Cqpaq+dQrvj+Sni/fQ?=
 =?us-ascii?Q?jh4C2bdrZUcuEQSzpKeUY73L?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f82ab15-08bb-412d-8446-08d97c1f316e
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2021 10:12:46.7918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LM1/EyRor0zqNSf2MBFMX2Cj2mCW/N3i5qedQI1w94oB2DvH3iX3xTmnkVgB0Fh/ccYpIq49vDe1Q1JK3iKa2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4540
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10112 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109200063
X-Proofpoint-ORIG-GUID: EbAsr4nwDWL9kFPAaLgvInvMp9H1JkrW
X-Proofpoint-GUID: EbAsr4nwDWL9kFPAaLgvInvMp9H1JkrW
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 18 Sep 2021 at 07:00, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Nobody uses this symbol anymore, so kill it.
>

Looks good.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_btree.c |    2 --
>  fs/xfs/libxfs/xfs_btree.h |    2 --
>  2 files changed, 4 deletions(-)
>
>
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 005bc42cf0bd..a7c866332911 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -5003,8 +5003,6 @@ xfs_btree_alloc_cursor(
>  	struct xfs_btree_cur	*cur;
>  	unsigned int		maxlevels = xfs_btree_maxlevels(mp, btnum);
>  
> -	ASSERT(maxlevels <= XFS_BTREE_MAXLEVELS);
> -
>  	cur = kmem_zalloc(xfs_btree_cur_sizeof(maxlevels), KM_NOFS);
>  	cur->bc_tp = tp;
>  	cur->bc_mp = mp;
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index d256d869f0af..91154dd63472 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -90,8 +90,6 @@ uint32_t xfs_btree_magic(int crc, xfs_btnum_t btnum);
>  #define XFS_BTREE_STATS_ADD(cur, stat, val)	\
>  	XFS_STATS_ADD_OFF((cur)->bc_mp, (cur)->bc_statoff + __XBTS_ ## stat, val)
>  
> -#define	XFS_BTREE_MAXLEVELS	9	/* max of all btrees */
> -
>  struct xfs_btree_ops {
>  	/* size of the key and record structures */
>  	size_t	key_len;


-- 
chandan
