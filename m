Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A82CC433F5
	for <linux-xfs@archiver.kernel.org>; Fri,  6 May 2022 09:59:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236473AbiEFKDW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 May 2022 06:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358846AbiEFKDO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 May 2022 06:03:14 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0FF94754F
        for <linux-xfs@vger.kernel.org>; Fri,  6 May 2022 02:59:31 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2469aI4b030616;
        Fri, 6 May 2022 09:59:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Qsq/q/HjQnLCz27SZPICvFt7u0uhnpTnhIocJaPYnuM=;
 b=TGckProx78Pp+3hRjmqbRftxodeIETdOA/tfryPjDhPwm5Dj1IN40qUu9nWRA5/3+Rx7
 NX4MGqAzTfEO+yxAMAL/bU0Izc9Oox8AMS3GM0ghL+CONgJryi7WsVLW5iR27KQcWh91
 cCVFCM57wJmdd5oQhD54z3kYENHGovbDcYrOakmNyb2PVJ7mMGS6piY7dDXrRmGScGG2
 4lWg+Nc0YinqPnN4HnC3BoHFXOJenW63h7AWaGQCUywuYRbTiT85pOWEYQKJeQIzyn6v
 JWILl9kxUzMPX2SRBY+j/LPnlYlNr6rYAxjkCFn2OU5glZKsblgWVpj68WTpQMllC+eD /g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fruq0nsb9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 May 2022 09:59:27 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2469tPmR006064;
        Fri, 6 May 2022 09:59:26 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fs1a85tq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 May 2022 09:59:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m2VlQXvrFmHrpECYoRT5Y3JojEg9kwDW3f48bsYtwxnlueNWkDLUJm/ZqVuOJgzDY1xnZsGUVaqGAe7nQGFds2UKeCjzE1a/TUQanUFIQnCz46W0uaZ4gWD4CGMQQ83DwLhIVi3Tmcg+d634+pKbGFzBxQc7yUJkzuCXOvjJcGlEsmbuRgamesIC/rUXHJGmAIy0SSbn8o0TnpGNJ8j7Fk+AjWsjLtY4FQ7IiDYnKuR6d++56fPsX8dPhI3gxW9Y38KGvTDVOuAZ5EeQHK1q47o2fx77iEuY6SK5bPxUspx1tFGBATCMEQL1+cIwAAEa2DKmt6YJP3+o13clcEIWDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qsq/q/HjQnLCz27SZPICvFt7u0uhnpTnhIocJaPYnuM=;
 b=bHGpV5FSVCDXQj4r2pgfZfYLVTRWz8pcd4us77EuPushNy4dILKhXD/jiDBg1eFbO3eURtUgWIaymj3hYspkFjnSwCQm5eKGzfneS2dy/I2Xr2gZtz/jqKVtpmV7Q7z3+B3j2TbfB5f+23XlvdbhKiEu3S1gzN6MBs2ae+2acULk4lkdhi9TLqcoiw1X56Rw9h7Da/mpZZR+9gX7LhiZdOtbMz0rQq+uZW1v3CoIPVee2RJ4KhEwIDOwqRPu5LWNGniUUCBbKrc7hEaZk42uGuCLnXnScRRToOcVnCc3Z/7RvBdJJjWETTLlf5A7uA77jiyfB70d5H4kxvZeOGMKoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qsq/q/HjQnLCz27SZPICvFt7u0uhnpTnhIocJaPYnuM=;
 b=xRAGXpgHnpi3vFKlnsrWpFSdPb39K2qkfL9ctTJPt62u+EaVrKBKquDLB4LA3LGwipWhNTx/XrnWZ43YakXqtSL1JrCkaU4r6L5kyrY2jACaHAmoIUCtzq+g1zQE9cfcFfJgLNb9Osn9+X6xMsr3RhKAHV4S+LKJ64VkKB4VCqY=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BLAPR10MB4995.namprd10.prod.outlook.com (2603:10b6:208:333::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20; Fri, 6 May
 2022 09:59:24 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::7d41:aa0f:80cf:ea15]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::7d41:aa0f:80cf:ea15%6]) with mapi id 15.20.5206.026; Fri, 6 May 2022
 09:59:24 +0000
References: <165176666861.247073.17043246723787772129.stgit@magnolia>
 <165176667978.247073.1336353301538627043.stgit@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_db: report absolute maxlevels for each btree type
In-reply-to: <165176667978.247073.1336353301538627043.stgit@magnolia>
Message-ID: <87wnezoubt.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Fri, 06 May 2022 15:29:18 +0530
Content-Type: text/plain
X-ClientProxiedBy: TYWPR01CA0003.jpnprd01.prod.outlook.com
 (2603:1096:400:a9::8) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8cb4bf2a-1685-4e96-19e9-08da2f47198f
X-MS-TrafficTypeDiagnostic: BLAPR10MB4995:EE_
X-Microsoft-Antispam-PRVS: <BLAPR10MB49957A88C4111699CF5F8AB9F6C59@BLAPR10MB4995.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dTNRy9D7pBulxWlg+AQecLgcUeCkr81p9lPnIKL/w0qzG3txhf2d0KXP5o2/NHqzWggu4F4VnPj0spmDq6GAGg3UcPgY5I0SHUu2Lu6B+5H1n+7IRI1WK4zVC0ZpQdKL0bRivAX7aDL3TphCnqSJcadvGtfpzZumERDHDWRoliwnQtpVKfqrqFHyYjkBrMwksfj3FT/rAJTE/d4syL5eGfxPPBWY48F61JHchcc64PZWsS5qorobj56ty8G9MQSiZO3Jga8yW/MfUavZRzEkedpY854iQowRlbMOPO+veY1S5bqJE3O9L2nhIDpvLppT8JzCcEv8wteu7iQhSTCFcnHrWPeLh4d2ZYKoTfG82/3snWyo5wBdSoEPLlG3B8Owi1+x3yssqv/ihDJyKFWv6ylG5tB8CS9s3Hmo+/juVQ7Z3p1UeYyo77GmVtQHS6naJOi0PaYN5RoQFnUJ3OgQ9iDUBHkUPpHyA4IsTcUcEamorIOJQ3fqJ2HMwFnhrPvGuQNmCD7DPMTeNiEXEu0Dm1N6kpi5OCbv5KbE/Z8JG8MpucngadiHU7X4thP49fI4cLERbe+PIhhgIJFbeo6yEoLE8ygjGRsBq4Y/MNcdmL/4fyoej8AK8VMpwf/iJSsK0m6gBdn3ja5PKuVdeXotQajqNlKfdaTZ8nAq38HP1LVY36psOD4b32lgwJPeehfQMWsWUpQYwbjHD/PO5ElipA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(6506007)(83380400001)(66946007)(66556008)(66476007)(8936002)(86362001)(53546011)(8676002)(4326008)(6486002)(5660300002)(508600001)(38100700002)(38350700002)(6666004)(2906002)(52116002)(33716001)(316002)(6916009)(186003)(9686003)(26005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OwZM5jnytWijG3vQSCQd229boQC/DHS/nWMOe99iSIJuQlWcBSptjT9j9p9Q?=
 =?us-ascii?Q?k+0KeTrsm3I58ZbCAC1q01yh6pjCyu5SGJsgB8QGli7iHiPUgx46gIKhs076?=
 =?us-ascii?Q?q8aqnUSRssdLTzRAmUm/rGwhJ/kfr3iRRCifPaFMxlqx3v+kgR3ARgorUEdB?=
 =?us-ascii?Q?nmrnk+qwCZWlgCyTHE1NwdoyTuJfpnB5E1ay0BGJvecpqOOvF92XV08MCqCD?=
 =?us-ascii?Q?3jtmCk1xuaY/kP0ZHz+Tmesks7nNS7bEE2QxIJ3bdPASTNzwYpNbvpVp4G3P?=
 =?us-ascii?Q?iLKbyl7AyGWlruDj6GKTV+pzkM4U0TYHdcdYzycJL0bPjJ/x4jHpHpEGIKzl?=
 =?us-ascii?Q?IuouIxFXs0c3yZcDIQ+R5w9iD9by5nEuDv7f8esxB771Y60nRNDK/Ni8AC7+?=
 =?us-ascii?Q?R41rPmkb01rk0t0BFzEZKPRZs4dceyR0Jb//TXLphktFjWfdcmssv0QXNEVg?=
 =?us-ascii?Q?FCELqpvWdII/e+dv+3+azpX4k/zW2TcgsK2mpuCgtdb9sXQANUeL2gipXOQ0?=
 =?us-ascii?Q?xGxZlG8c1LNZk4DfF8CRIHRHBMElcdwrtkrgNaEKvKG08u0jH1SiGoVi9x2d?=
 =?us-ascii?Q?xH+O1Y2tIB5ToOf33GD1xmfFQgwpmwzdDrt/G0wIRKvaaEEc+ys613EKcXgR?=
 =?us-ascii?Q?XOocoegiazHpL1eavkDavzQeIq/b+bvI+PiKRZRY8hK/VyKk9y4mgaB4iJUv?=
 =?us-ascii?Q?YulkjvIlpkTkbvxwn+CGi1gs2tbxwutVGLcm28Z9yC4PLi6aGREazHyLdDNv?=
 =?us-ascii?Q?UJsIfndy63sGWSehpdyWOTZLyZfms/Cy42pcp9LUzgae57nV9tvCVCAnQYsm?=
 =?us-ascii?Q?ihwZDu1sDDOQkfW06uh+OzZkMmboDK/skE4nI9Iq5bMGHNDJQyoalN5OkHsy?=
 =?us-ascii?Q?2wP1KItjWr6kOTaGOdgQpjlY8nxk39jk7vIjAG0T9eaETWHcPHYusG30wle5?=
 =?us-ascii?Q?1V2kuGtkMKawriF8Wpb/3Sz9BtEzS8d7tHWhANfjKlVItdQ0XLA9TYX8jl8B?=
 =?us-ascii?Q?s9maxdACy9OPec+5MkTrp/aCT/mNnkq74BDi1nMbr76q6AXeTbnQIcz7Zdgu?=
 =?us-ascii?Q?UqVUqoZCB2tVq2HOSkMt1kPVxkABwJ10vZ/bbuGA79rPpHxoDZHfSawBYqDm?=
 =?us-ascii?Q?NueWFlUliglzayPaB/b4eTiaUgDgWBMwtiXRaHPyYF+aP5bwBlYm+V4JdeNR?=
 =?us-ascii?Q?STPUI6enXc2+jM7Ld3ph75HeY48/7i7kEaJegpPPPi3oaOnU0f/KPr4wOWci?=
 =?us-ascii?Q?g8/UnuReXjkCAY7QpctpXUfR6MK90O+UY1/FAu4bALn5zZryuGUfbfl6yNpH?=
 =?us-ascii?Q?wWaams5pLiYDufGLG0zjfhpu0Gv8GSagRxmtmGphKor3L3nYYWEJIDyB1JnM?=
 =?us-ascii?Q?yKl27HcYqVkSbp+Tkh1oFhLCNh9Q7A+6zg0B1Q6owOnDPunoyheUkqZiQZJZ?=
 =?us-ascii?Q?SqiNHprAawdibGkern0+Vpa58RtFmvxGCHzPDd8gViyYqziDzzQVwOIHtLWu?=
 =?us-ascii?Q?I5evXYBRmeldE3hGH9GouA3ztNzqSpYAgDFq/fwgw486kfYoPu448PZN+RCy?=
 =?us-ascii?Q?NsdQ06zAMZhETYDBlrs9x+wVJiMmweN5HBjG6EwQy7KGQD5oQ5h+2Q33LlVh?=
 =?us-ascii?Q?HZsSFsAl+MzykMRU5kdWwQNjjvy/sHCR7yCUCQ8hYNulsqN9/cS7TDF6zD13?=
 =?us-ascii?Q?lwHag0G36Wg7waj8qrSYSNkcXbAHoq+GVU6NhEd2OP3QITJnrf60eN0Xh934?=
 =?us-ascii?Q?V9udpJFdwpd5mlE5U2su8KUjZMUNS0U=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cb4bf2a-1685-4e96-19e9-08da2f47198f
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2022 09:59:24.6213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H+6TIPjZHdSfAvSj112W9uBu8M3yhx/K86IDQSar71rCf/oyYe1/qvcGYBjE+YtodvX1ffl2UfrwIo5AOO57Cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4995
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-06_03:2022-05-05,2022-05-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205060055
X-Proofpoint-ORIG-GUID: ioJPK7WA0t7hc3ZULf_E59qyDKXQz1ox
X-Proofpoint-GUID: ioJPK7WA0t7hc3ZULf_E59qyDKXQz1ox
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 05 May 2022 at 21:34, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Augment the xfs_db btheight command so that the debugger can display the
> absolute maximum btree height for each btree type.
>

Looks good.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  db/btheight.c            |   73 ++++++++++++++++++++++++++++++++++++++++------
>  libxfs/libxfs_api_defs.h |    5 +++
>  man/man8/xfs_db.8        |    5 +++
>  3 files changed, 72 insertions(+), 11 deletions(-)
>
>
> diff --git a/db/btheight.c b/db/btheight.c
> index e4cd4eda..0b421ab5 100644
> --- a/db/btheight.c
> +++ b/db/btheight.c
> @@ -24,16 +24,45 @@ static int rmap_maxrecs(struct xfs_mount *mp, int blocklen, int leaf)
>  
>  struct btmap {
>  	const char	*tag;
> +	unsigned int	(*maxlevels)(void);
>  	int		(*maxrecs)(struct xfs_mount *mp, int blocklen,
>  				   int leaf);
>  } maps[] = {
> -	{"bnobt", libxfs_allocbt_maxrecs},
> -	{"cntbt", libxfs_allocbt_maxrecs},
> -	{"inobt", libxfs_inobt_maxrecs},
> -	{"finobt", libxfs_inobt_maxrecs},
> -	{"bmapbt", libxfs_bmbt_maxrecs},
> -	{"refcountbt", refc_maxrecs},
> -	{"rmapbt", rmap_maxrecs},
> +	{
> +		.tag		= "bnobt",
> +		.maxlevels	= libxfs_allocbt_maxlevels_ondisk,
> +		.maxrecs	= libxfs_allocbt_maxrecs,
> +	},
> +	{
> +		.tag		= "cntbt",
> +		.maxlevels	= libxfs_allocbt_maxlevels_ondisk,
> +		.maxrecs	= libxfs_allocbt_maxrecs,
> +	},
> +	{
> +		.tag		= "inobt",
> +		.maxlevels	= libxfs_iallocbt_maxlevels_ondisk,
> +		.maxrecs	= libxfs_inobt_maxrecs,
> +	},
> +	{
> +		.tag		= "finobt",
> +		.maxlevels	= libxfs_iallocbt_maxlevels_ondisk,
> +		.maxrecs	= libxfs_inobt_maxrecs,
> +	},
> +	{
> +		.tag		= "bmapbt",
> +		.maxlevels	= libxfs_bmbt_maxlevels_ondisk,
> +		.maxrecs	= libxfs_bmbt_maxrecs,
> +	},
> +	{
> +		.tag		= "refcountbt",
> +		.maxlevels	= libxfs_refcountbt_maxlevels_ondisk,
> +		.maxrecs	= refc_maxrecs,
> +	},
> +	{
> +		.tag		= "rmapbt",
> +		.maxlevels	= libxfs_rmapbt_maxlevels_ondisk,
> +		.maxrecs	= rmap_maxrecs,
> +	},
>  };
>  
>  static void
> @@ -55,6 +84,7 @@ btheight_help(void)
>  "   -n -- Number of records we want to store.\n"
>  "   -w max -- Show only the best case scenario.\n"
>  "   -w min -- Show only the worst case scenario.\n"
> +"   -w absmax -- Print the maximum possible btree height for all filesystems.\n"
>  "\n"
>  " Supported btree types:\n"
>  "   all "
> @@ -232,6 +262,22 @@ _("%s: pointer size must be less than selected block size (%u bytes).\n"),
>  #define REPORT_DEFAULT	(-1U)
>  #define REPORT_MAX	(1 << 0)
>  #define REPORT_MIN	(1 << 1)
> +#define REPORT_ABSMAX	(1 << 2)
> +
> +static void
> +report_absmax(const char *tag)
> +{
> +	struct btmap	*m;
> +	int		i;
> +
> +	for (i = 0, m = maps; i < ARRAY_SIZE(maps); i++, m++) {
> +		if (!strcmp(m->tag, tag)) {
> +			printf("%s: %u\n", tag, m->maxlevels());
> +			return;
> +		}
> +	}
> +	printf(_("%s: Don't know how to report max height.\n"), tag);
> +}
>  
>  static void
>  report(
> @@ -243,6 +289,11 @@ report(
>  	unsigned int		records_per_block[2];
>  	int			ret;
>  
> +	if (report_what == REPORT_ABSMAX) {
> +		report_absmax(tag);
> +		return;
> +	}
> +
>  	ret = construct_records_per_block(tag, blocksize, records_per_block);
>  	if (ret)
>  		return;
> @@ -344,6 +395,8 @@ btheight_f(
>  				report_what = REPORT_MIN;
>  			else if (!strcmp(optarg, "max"))
>  				report_what = REPORT_MAX;
> +			else if (!strcmp(optarg, "absmax"))
> +				report_what = REPORT_ABSMAX;
>  			else {
>  				btheight_help();
>  				return 0;
> @@ -355,20 +408,20 @@ btheight_f(
>  		}
>  	}
>  
> -	if (nr_records == 0) {
> +	if (report_what != REPORT_ABSMAX && nr_records == 0) {
>  		fprintf(stderr,
>  _("Number of records must be greater than zero.\n"));
>  		return 0;
>  	}
>  
> -	if (blocksize > INT_MAX) {
> +	if (report_what != REPORT_ABSMAX && blocksize > INT_MAX) {
>  		fprintf(stderr,
>  _("The largest block size this command will consider is %u bytes.\n"),
>  			INT_MAX);
>  		return 0;
>  	}
>  
> -	if (blocksize < 128) {
> +	if (report_what != REPORT_ABSMAX && blocksize < 128) {
>  		fprintf(stderr,
>  _("The smallest block size this command will consider is 128 bytes.\n"));
>  		return 0;
> diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
> index 0862d4b0..8abbd231 100644
> --- a/libxfs/libxfs_api_defs.h
> +++ b/libxfs/libxfs_api_defs.h
> @@ -23,6 +23,7 @@
>  #define xfs_ag_block_count		libxfs_ag_block_count
>  
>  #define xfs_alloc_ag_max_usable		libxfs_alloc_ag_max_usable
> +#define xfs_allocbt_maxlevels_ondisk	libxfs_allocbt_maxlevels_ondisk
>  #define xfs_allocbt_maxrecs		libxfs_allocbt_maxrecs
>  #define xfs_allocbt_stage_cursor	libxfs_allocbt_stage_cursor
>  #define xfs_alloc_fix_freelist		libxfs_alloc_fix_freelist
> @@ -39,6 +40,7 @@
>  #define xfs_bmapi_read			libxfs_bmapi_read
>  #define xfs_bmapi_write			libxfs_bmapi_write
>  #define xfs_bmap_last_offset		libxfs_bmap_last_offset
> +#define xfs_bmbt_maxlevels_ondisk	libxfs_bmbt_maxlevels_ondisk
>  #define xfs_bmbt_maxrecs		libxfs_bmbt_maxrecs
>  #define xfs_bmdr_maxrecs		libxfs_bmdr_maxrecs
>  
> @@ -109,6 +111,7 @@
>  #define xfs_highbit32			libxfs_highbit32
>  #define xfs_highbit64			libxfs_highbit64
>  #define xfs_ialloc_calc_rootino		libxfs_ialloc_calc_rootino
> +#define xfs_iallocbt_maxlevels_ondisk	libxfs_iallocbt_maxlevels_ondisk
>  #define xfs_idata_realloc		libxfs_idata_realloc
>  #define xfs_idestroy_fork		libxfs_idestroy_fork
>  #define xfs_iext_lookup_extent		libxfs_iext_lookup_extent
> @@ -138,6 +141,7 @@
>  #define xfs_refc_block			libxfs_refc_block
>  #define xfs_refcountbt_calc_reserves	libxfs_refcountbt_calc_reserves
>  #define xfs_refcountbt_init_cursor	libxfs_refcountbt_init_cursor
> +#define xfs_refcountbt_maxlevels_ondisk	libxfs_refcountbt_maxlevels_ondisk
>  #define xfs_refcountbt_maxrecs		libxfs_refcountbt_maxrecs
>  #define xfs_refcountbt_stage_cursor	libxfs_refcountbt_stage_cursor
>  #define xfs_refcount_get_rec		libxfs_refcount_get_rec
> @@ -146,6 +150,7 @@
>  #define xfs_rmap_alloc			libxfs_rmap_alloc
>  #define xfs_rmapbt_calc_reserves	libxfs_rmapbt_calc_reserves
>  #define xfs_rmapbt_init_cursor		libxfs_rmapbt_init_cursor
> +#define xfs_rmapbt_maxlevels_ondisk	libxfs_rmapbt_maxlevels_ondisk
>  #define xfs_rmapbt_maxrecs		libxfs_rmapbt_maxrecs
>  #define xfs_rmapbt_stage_cursor		libxfs_rmapbt_stage_cursor
>  #define xfs_rmap_compare		libxfs_rmap_compare
> diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
> index 55ac3487..1a2bb7e9 100644
> --- a/man/man8/xfs_db.8
> +++ b/man/man8/xfs_db.8
> @@ -402,7 +402,7 @@ If the cursor points at an inode, dump the extended attribute block mapping btre
>  Dump all keys and pointers in intermediate btree nodes, and all records in leaf btree nodes.
>  .RE
>  .TP
> -.BI "btheight [\-b " blksz "] [\-n " recs "] [\-w " max "|\-w " min "] btree types..."
> +.BI "btheight [\-b " blksz "] [\-n " recs "] [\-w " max "|" min "|" absmax "] btree types..."
>  For a given number of btree records and a btree type, report the number of
>  records and blocks for each level of the btree, and the total number of blocks.
>  The btree type must be given after the options.
> @@ -435,6 +435,9 @@ The default is the filesystem block size.
>  is used to specify the number of records to store.
>  This argument is required.
>  .TP
> +.B \-w absmax
> +shows the maximum possible height for the given btree types.
> +.TP
>  .B \-w max
>  shows only the best case scenario, which is when the btree blocks are
>  maximally loaded.


-- 
chandan
