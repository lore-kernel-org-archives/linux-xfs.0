Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7158DC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 10:05:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345032AbiDKKHo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Apr 2022 06:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345163AbiDKKHl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Apr 2022 06:07:41 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB3713F45
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 03:05:27 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23B9gTYx012645;
        Mon, 11 Apr 2022 10:05:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=hv3JXOcQv+cmUyUPIslTIA19LkRZtkEKgu9Cw9Rgqus=;
 b=ulULusRLjVrngYwH72ZIY1uXjMZJ/UOCznzZukUW9i787uJrxb/TOJ2cG1/l4OvRmsMA
 DQsgd0KwB3fZtmfv80C0vBsbezFcNhZVWs002F4yeW2Zblp8hqIkIFs/fxIFOWOUF97/
 SamJ/Mc20DjWHb3+Yk9FrA8Xh8OQD+VuNQ0lSEBYslQBVugzeW5siTjLJ8ba0zGoiOHD
 rwALMEfG1CWA6ZT/qHB+F3msoJoAQD+pB9VqkueM5LYfKF1ohsChnLAS5TTmhSO6jsj4
 QrsmxQEOvTWsoXvNylNdHeBi6lw6JRPrgZHOIGkIqwt6t1YiJbimcch9YCfqmEe1bsCw qg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb2ptu5q8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 10:05:26 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23BA2IGo013621;
        Mon, 11 Apr 2022 10:05:25 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fcg9g3d66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 10:05:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JFdHkyzwE4WUZcdxXjlAM5IUpzKM62xht/ys13d9G4GI/AZTG+sVQn2VTQK8LKv7ubwOybV+x3t13VSGvI/hHiwZ/xaMgHv3JM+sFvd0U2wvI921HdKHiG7uphVLQfKRGyf957yxjblN0vXn39vCFXADL32MCAoNj9bmXVlb8sHAdRDz8WSKjilIG+mlAawMx95Vz2r6sqorEgUmXICIj8m5QLShwqF6H/39cWTozVqEC6hQcw+g81OuuMyxwE+UC9//iaQ29EYwgdOvWDx4Ddi3+lI7feYnauYi8worKOOqqZ9DcZsF5cD5NaOCzxdTL7KIKclp/JhSGILYueJegQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hv3JXOcQv+cmUyUPIslTIA19LkRZtkEKgu9Cw9Rgqus=;
 b=jSL/r6u2WDaSAz75QzXZ5Z0sFFpR/ygCkQH/nIpTauyNsuaxStLd2h7rX9K/mcLs1Ru7xG6Z30GvcQUWK5u7pQcQ6bjUid/70h7OaPJj098MphWjIhSJXM7JRNSKCUAQKIVFg2D23jbYzhiSQBqx6FfWdVCRERySPw0EwzdNnT76vUB8xduSLc4aYFePDGzQak/QKwpFt+Kft3HsEL4HdSNsQW1ZEJlSeGd+ReS1yaYY4ekKY622uouy7/4fFIpCXl/QJ44AUAQcYgCByZLqHlVuQZfrnqqq/jZkMDDztgehYYrbaEC4NLprFc+4SprW29hK7QqD0Bows2vyozlfpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hv3JXOcQv+cmUyUPIslTIA19LkRZtkEKgu9Cw9Rgqus=;
 b=FT8N9J6I75+9B7oFca/jJEqXBIEZmCQ++t2VJfRQ6p2fLmnG1QXTaa0fY3FfEK0NYnm1GoToIBrC7TVUQA4d/ef9A92K2kQ9uSyzXT1GKYfvGtsYTOjTuoHv7fnmV748Pl6/ou1hkryQJpFOulYjHWOuq/rAFYDOiucZmngU7GM=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by DM5PR1001MB2075.namprd10.prod.outlook.com (2603:10b6:4:2b::37) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 10:05:22 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::c95c:3552:3b30:30ee]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::c95c:3552:3b30:30ee%6]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 10:05:22 +0000
References: <20220411003147.2104423-1-david@fromorbit.com>
 <20220411003147.2104423-2-david@fromorbit.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/17] xfs: convert buffer flags to unsigned.
In-reply-to: <20220411003147.2104423-2-david@fromorbit.com>
Message-ID: <87tub0ue92.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Mon, 11 Apr 2022 15:35:13 +0530
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0071.jpnprd01.prod.outlook.com
 (2603:1096:404:2b::35) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f989d19e-656b-4701-090c-08da1ba2ca34
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2075:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2075EE63458E10B8260FBA86F6EA9@DM5PR1001MB2075.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x3sjMMzq+zYQndFmSxd5y9T/i1F2jc9FMcD6Sd3LJ47pkRdD8cdMo5HxdaHhmJT9vMRVA2TT3TS4kiIUcgrmFQUnyWUrdwyd3ZM74kL4v8Gvkq74TW7pfnp9AWyR97QvsopmTEaOtE7fIps8i9hERHp6rIEvWz2NYSFa0CR8rUXS0BT/JOwhg3n0ae1qV8FCQPEw9D8gi8xmQuW2K/OhYYrOt7BIIOww6Z6pjJy4tpoR7+UEHFEZhxm72GvBLeEEb7CPTy1jQYWngCoEEn+Qmqs/pRSuln5WMVQ9tFi2czRQwHbic5OEpgJS3ncLpCL5uer9Wcp8egc4ssfaYmTjwY+bZ8otOVaWjSpBb78fQNl+fO5vkrzq/1DZwBnsAPMxxaTzSWq12kgxs+1QvEjsnWn2zxp/0P8yAIndh2C4d34mgE4IxEyyQvg/nZqJQ8PPvnPPXGxQHV5FXy7N/YL+jziA4ZiRCOQm+AfHiulXTwI1j7CVi5OW94mgM5gMZvr3kQDcpswfRQX6lOqcZJwF/k3qmdAI1iq9n5Lm2U9GKhEc105qG7SzHF6k9pGP/dsMctTwQEzY2N5iQP2STh8xyvYr/cdOO/HwhqUZTiOQbsKWdg+74JsKzdygEX65mOP49n6dE2857JXFE66IQg1boniBvQJPxsxlz0ybmsKWR6z2drSkztvo9Ba+N1un4LriJ4bJIYwlx03NsywBN6c0og==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(6506007)(53546011)(52116002)(6666004)(508600001)(316002)(2906002)(5660300002)(9686003)(6512007)(26005)(83380400001)(186003)(8676002)(38100700002)(86362001)(38350700002)(66946007)(4326008)(6486002)(66476007)(33716001)(6916009)(66556008)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?46dec/YzRu0HDKkyymU59n66clw1CBdSFDm1WdjIm/1Ltb+mctn6vMOhBJtO?=
 =?us-ascii?Q?rb59u1TMOna9fvDlsPukUfMRB6C7qpp/ydSyqO8+nyX3U9S1UqO8QJZHMdB0?=
 =?us-ascii?Q?foW1K7qikk1GnWDOAFY1zoSBaGi/zMMUhuzRxzF7tQF6PbAZtN/mgHYY9WSK?=
 =?us-ascii?Q?uHRNdTg+y1nlpmDVFVsHMGLhzLEf9cVPWNBkMXmAAO/R754QV3ZS5byz9OMJ?=
 =?us-ascii?Q?VAj7NfzTO7POosL/GNs/28Cbgv/r+N2GY4EVPrBg7NUR7qj7NOhs6Cohi16r?=
 =?us-ascii?Q?7TpRI/KK0PQd46/TTVKcQHGy4u9TbpMU/NxjiFLbbLb3hOMK2YOB2cjkjUvH?=
 =?us-ascii?Q?b/w4ujOSKhckka7Nr0mfUL4fCJnY1aZKG4HqOG7rCKWIpvj4LmDEmRxuqFm1?=
 =?us-ascii?Q?ocjrG4sL3zTA1NwnC1D5FhqT9YjSirSchhpmguzvNgthOaZRYVHQwsty6WZq?=
 =?us-ascii?Q?NYtOTqRek4jobCPiJ+Z7SrimroZ9HpHvlOP44socTeOk6tfw4SWc++u51nJz?=
 =?us-ascii?Q?LB12s1Fom1P0rw8p2/6rAPtzBambnplr2+Dtm1qhRjK0vwvNBEAw36VNVoFu?=
 =?us-ascii?Q?oPk6UfPGZ3BKqqB879m2i3rYeyvsJVYPvQptH/Q/mGCPv81QgGRmU4PfoVYk?=
 =?us-ascii?Q?o+gAExsoXqS/WM8rmBKjYWMAT5Zn3Ft8y/Zm1/tep02vj0ceKP55anX9ONp9?=
 =?us-ascii?Q?Q+3EzfkHmHfP0GbXbnlXZo5SseX8IB6EyG/OJEdQSaKssLFmTVod4ct2JL8N?=
 =?us-ascii?Q?RkcLWpkYmIkidYAjhaZAq5yw9ZFEHffFR9mPKMXfDy9AblFlN2PM9IIssKXg?=
 =?us-ascii?Q?5l2c/+dNPRY9FziQCPle4oFJT7i3vI2DH080EH2Kdi13WEneH3Ab4v4yae+x?=
 =?us-ascii?Q?QH2GtAqjTbcoxFGRFGUUtqlpNzgcOW1ZX1jeaODqoG4XJMv4jTvoBAncCM7i?=
 =?us-ascii?Q?JCqVNVaG4I8lQ2W2NDqaxwiRLAOMpTWeXqC6kDDdWIV21PWgEm6XolRoY6Vj?=
 =?us-ascii?Q?P7fb9yJA0ioLBNrsnAU1guCdq2WW8DOqoAEGZHHGYtWwFcEOMfsMPa1aS7k6?=
 =?us-ascii?Q?vHhebUF4l7CYnqxfQPiWWcVT8nu6AcbZ/yxJ6ygTUFrdJRhx/6CLqOtAAWcr?=
 =?us-ascii?Q?kcLm6QnVlMBEEDFlVJUtmY2yLNujTHVsa9VhZhXvLoIASVFfNkhNGbzLxw0n?=
 =?us-ascii?Q?W9IG3vtlh7sNfp+4lXe4MAOQe4vXnOZWdJV6Gb0YMsoAonumCDTCotEvXFcz?=
 =?us-ascii?Q?FJ6icnOotI7h/TMwchPqE99Xm8GonGlemuML51BG/HBoQOT9KnrrnTRTRY/I?=
 =?us-ascii?Q?RxImpQ7VcBmE7oOy+03m7tYyofDjDtOvf3j6KbgNwTrUmVEYeg4Ky//3/MRT?=
 =?us-ascii?Q?kzESUP28uLiDl2rfwv8yU5S09FsZncfLQplRnTOT90P4VoT7IoX7RQ+w/wj9?=
 =?us-ascii?Q?L1T00J0ncpkqVvJ6A1EP+sbEQtUairTZ1dMlRYObcbt60qxR3AiELxKvnYhL?=
 =?us-ascii?Q?/cSsrIIqqGxDjwEU/+rAr1wuG33Bej0h+CnoVMBFlQ6vcrlXGuti+Md471rW?=
 =?us-ascii?Q?e4odsbrSHnDei61hgZW9vE8nWfLOhf/tuMWQYGReo9A9i7mZZ9hM0oYSkN9A?=
 =?us-ascii?Q?7feSR32tVAC4ec9mWd/Vl8WHe/aNX8VT4BEdh7Kw5rcRWbeoGfjisZNeYbFz?=
 =?us-ascii?Q?G1KEgp9B0R+XGLIiA0kK4M2spPbLgGwiLYsHVg9bBCtopA47ip7/ZK290ydI?=
 =?us-ascii?Q?uRmbfbiiJjY1McrIXhVXV3c8n6a/T/o=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f989d19e-656b-4701-090c-08da1ba2ca34
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 10:05:22.0062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eOB10tPVY8L92xYLlJuQRSoBrai9LL8b+0xNMex+uaklHd3meVa/TqJ2oMJjBfIqrfcdJ6uxP/Jy3uzjlV8rIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2075
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-11_03:2022-04-11,2022-04-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204110057
X-Proofpoint-ORIG-GUID: jCPQ3kk-l5M4dHqVyG7SBBuxq_Mvmh8x
X-Proofpoint-GUID: jCPQ3kk-l5M4dHqVyG7SBBuxq_Mvmh8x
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11 Apr 2022 at 06:01, Dave Chinner wrote:
> 5.18 w/ std=gnu11 compiled with gcc-5 wants flags stored in unsigned
> fields to be unsigned. This manifests as a compiler error such as:
>
> /kisskb/src/fs/xfs/./xfs_trace.h:432:2: note: in expansion of macro 'TP_printk'
>   TP_printk("dev %d:%d daddr 0x%llx bbcount 0x%x hold %d pincount %d "
>   ^
> /kisskb/src/fs/xfs/./xfs_trace.h:440:5: note: in expansion of macro '__print_flags'
>      __print_flags(__entry->flags, "|", XFS_BUF_FLAGS),
>      ^
> /kisskb/src/fs/xfs/xfs_buf.h:67:4: note: in expansion of macro 'XBF_UNMAPPED'
>   { XBF_UNMAPPED,  "UNMAPPED" }
>     ^
> /kisskb/src/fs/xfs/./xfs_trace.h:440:40: note: in expansion of macro 'XFS_BUF_FLAGS'
>      __print_flags(__entry->flags, "|", XFS_BUF_FLAGS),
>                                         ^
> /kisskb/src/fs/xfs/./xfs_trace.h: In function 'trace_raw_output_xfs_buf_flags_class':
> /kisskb/src/fs/xfs/xfs_buf.h:46:23: error: initializer element is not constant
>  #define XBF_UNMAPPED  (1 << 31)/* do not map the buffer */
>
> as __print_flags assigns XFS_BUF_FLAGS to a structure that uses an
> unsigned long for the flag. Since this results in the value of
> XBF_UNMAPPED causing a signed integer overflow, the result is
> technically undefined behavior, which gcc-5 does not accept as an
> integer constant.
>
> This is based on a patch from Arnd Bergman <arnd@arndb.de>.
>

Although the underlying data type is the same, may be the type of the fifth
argument to xfs_trans_get_buf() should be changed to xfs_buf_flags_t as well.

With that fixed,

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf.c |  6 +++---
>  fs/xfs/xfs_buf.h | 42 +++++++++++++++++++++---------------------
>  2 files changed, 24 insertions(+), 24 deletions(-)
>
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index e1afb9e503e1..bf4e60871068 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -406,7 +406,7 @@ xfs_buf_alloc_pages(
>  STATIC int
>  _xfs_buf_map_pages(
>  	struct xfs_buf		*bp,
> -	uint			flags)
> +	xfs_buf_flags_t		flags)
>  {
>  	ASSERT(bp->b_flags & _XBF_PAGES);
>  	if (bp->b_page_count == 1) {
> @@ -868,7 +868,7 @@ xfs_buf_read_uncached(
>  	struct xfs_buftarg	*target,
>  	xfs_daddr_t		daddr,
>  	size_t			numblks,
> -	int			flags,
> +	xfs_buf_flags_t		flags,
>  	struct xfs_buf		**bpp,
>  	const struct xfs_buf_ops *ops)
>  {
> @@ -903,7 +903,7 @@ int
>  xfs_buf_get_uncached(
>  	struct xfs_buftarg	*target,
>  	size_t			numblks,
> -	int			flags,
> +	xfs_buf_flags_t		flags,
>  	struct xfs_buf		**bpp)
>  {
>  	int			error;
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index edcb6254fa6a..1ee3056ff9cf 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -22,28 +22,28 @@ struct xfs_buf;
>  
>  #define XFS_BUF_DADDR_NULL	((xfs_daddr_t) (-1LL))
>  
> -#define XBF_READ	 (1 << 0) /* buffer intended for reading from device */
> -#define XBF_WRITE	 (1 << 1) /* buffer intended for writing to device */
> -#define XBF_READ_AHEAD	 (1 << 2) /* asynchronous read-ahead */
> -#define XBF_NO_IOACCT	 (1 << 3) /* bypass I/O accounting (non-LRU bufs) */
> -#define XBF_ASYNC	 (1 << 4) /* initiator will not wait for completion */
> -#define XBF_DONE	 (1 << 5) /* all pages in the buffer uptodate */
> -#define XBF_STALE	 (1 << 6) /* buffer has been staled, do not find it */
> -#define XBF_WRITE_FAIL	 (1 << 7) /* async writes have failed on this buffer */
> +#define XBF_READ	 (1u << 0) /* buffer intended for reading from device */
> +#define XBF_WRITE	 (1u << 1) /* buffer intended for writing to device */
> +#define XBF_READ_AHEAD	 (1u << 2) /* asynchronous read-ahead */
> +#define XBF_NO_IOACCT	 (1u << 3) /* bypass I/O accounting (non-LRU bufs) */
> +#define XBF_ASYNC	 (1u << 4) /* initiator will not wait for completion */
> +#define XBF_DONE	 (1u << 5) /* all pages in the buffer uptodate */
> +#define XBF_STALE	 (1u << 6) /* buffer has been staled, do not find it */
> +#define XBF_WRITE_FAIL	 (1u << 7) /* async writes have failed on this buffer */
>  
>  /* buffer type flags for write callbacks */
> -#define _XBF_INODES	 (1 << 16)/* inode buffer */
> -#define _XBF_DQUOTS	 (1 << 17)/* dquot buffer */
> -#define _XBF_LOGRECOVERY	 (1 << 18)/* log recovery buffer */
> +#define _XBF_INODES	 (1u << 16)/* inode buffer */
> +#define _XBF_DQUOTS	 (1u << 17)/* dquot buffer */
> +#define _XBF_LOGRECOVERY (1u << 18)/* log recovery buffer */
>  
>  /* flags used only internally */
> -#define _XBF_PAGES	 (1 << 20)/* backed by refcounted pages */
> -#define _XBF_KMEM	 (1 << 21)/* backed by heap memory */
> -#define _XBF_DELWRI_Q	 (1 << 22)/* buffer on a delwri queue */
> +#define _XBF_PAGES	 (1u << 20)/* backed by refcounted pages */
> +#define _XBF_KMEM	 (1u << 21)/* backed by heap memory */
> +#define _XBF_DELWRI_Q	 (1u << 22)/* buffer on a delwri queue */
>  
>  /* flags used only as arguments to access routines */
> -#define XBF_TRYLOCK	 (1 << 30)/* lock requested, but do not wait */
> -#define XBF_UNMAPPED	 (1 << 31)/* do not map the buffer */
> +#define XBF_TRYLOCK	 (1u << 30)/* lock requested, but do not wait */
> +#define XBF_UNMAPPED	 (1u << 31)/* do not map the buffer */
>  
>  typedef unsigned int xfs_buf_flags_t;
>  
> @@ -58,7 +58,7 @@ typedef unsigned int xfs_buf_flags_t;
>  	{ XBF_WRITE_FAIL,	"WRITE_FAIL" }, \
>  	{ _XBF_INODES,		"INODES" }, \
>  	{ _XBF_DQUOTS,		"DQUOTS" }, \
> -	{ _XBF_LOGRECOVERY,		"LOG_RECOVERY" }, \
> +	{ _XBF_LOGRECOVERY,	"LOG_RECOVERY" }, \
>  	{ _XBF_PAGES,		"PAGES" }, \
>  	{ _XBF_KMEM,		"KMEM" }, \
>  	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
> @@ -247,11 +247,11 @@ xfs_buf_readahead(
>  	return xfs_buf_readahead_map(target, &map, 1, ops);
>  }
>  
> -int xfs_buf_get_uncached(struct xfs_buftarg *target, size_t numblks, int flags,
> -		struct xfs_buf **bpp);
> +int xfs_buf_get_uncached(struct xfs_buftarg *target, size_t numblks,
> +		xfs_buf_flags_t flags, struct xfs_buf **bpp);
>  int xfs_buf_read_uncached(struct xfs_buftarg *target, xfs_daddr_t daddr,
> -			  size_t numblks, int flags, struct xfs_buf **bpp,
> -			  const struct xfs_buf_ops *ops);
> +		size_t numblks, xfs_buf_flags_t flags, struct xfs_buf **bpp,
> +		const struct xfs_buf_ops *ops);
>  int _xfs_buf_read(struct xfs_buf *bp, xfs_buf_flags_t flags);
>  void xfs_buf_hold(struct xfs_buf *bp);


-- 
chandan
