Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFDA4C25B4E
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Jan 2023 05:30:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbjAXFa5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Jan 2023 00:30:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjAXFaz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Jan 2023 00:30:55 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 655E47D92
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jan 2023 21:30:54 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30O04gwW020106;
        Tue, 24 Jan 2023 05:30:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2022-7-12;
 bh=zA6mApsF7oSCwTqkFeDnktg9WcZpRcBDRZ2HVjv4JhQ=;
 b=qionYZ01EqUmXG1hnVRpTWMzHxFoxqNtm57PPx5aoMSfnmy5q/WizZvPPUv1Q+1CBivQ
 dRgNKZEIPoxXV5ICWCRsiIohh/10duBFLt9dFO1tiwa59tEV6whhTTdrZ9uUFcgz+B1k
 VkhleaPcw6vYAcB1pUVfwp/afUPT4JqwbHTLv+jRaVNBQ2KInu/mkZNADu66haRh93Jm
 r5fWZtz+ySIDE3uzvqveUvpq6zGzwDwhzihasmfaZ4EKFp9+OW/KxvArCuMlEFI84CKB
 RASWGmjZ2QWwPQGFMf69MLGwYxDNcwOFFEmyLGgztQ/dgNbrTj5VJb7kGj4Zd4J5kguC +A== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86ybchtn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Jan 2023 05:30:51 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30O3v0GI040110;
        Tue, 24 Jan 2023 05:30:50 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g4fk91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Jan 2023 05:30:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J7dNajITrTr89CGnVS82+kfvRK/KGtkPUHrR2CECQfz/8YutgYYoVDfzgOf0LyO4ONCg2E/mEUthJxzP0Uib1CYfnmjKgU+JrfXdSt05GLIjutnIS8/ofMb0p3Xl6+abHKoPi95ReUHL3tCo4CtPtf3ntl080MJ9YlSIfIpR93yepo5AcqanPE2xaKQ/jR+UseKtdqfZ/tpxr8pG3PDO2xVlvzm7By1k7Q6qjyFAD/QTOLloy3dFbhn2EpimZdlhx/2IqAVFIc7xQG6IGubmtG421n79zhS+BN0Hni89GE8ymfz4BZQ1m5sqfJr+q3G3WTUipPf59XlLK0bRERsxxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zA6mApsF7oSCwTqkFeDnktg9WcZpRcBDRZ2HVjv4JhQ=;
 b=E9zw6WXGeavxGOe+p7CYpCuwSUe/7/1tu4hReuU+GrXoxfzt46Ugg0DWLRtTlaMpeBtVgEm43IPslO5UTr/DZHGFnaZn7KXQc/d/2xyjmGmrKao0UH1gK8Q6iq1wwz5vp0ZD9Gh/CuzofUd8n5xpnpP8ZP3HDRgLk7PJpz4Xh0dnuOE5Xj+rJMhAY/4OuIlrM1TngFFMyXMjwJ44kZrNkG3Tlou6CQzyBACjhu8jBEZSGaBvKBY9PLVIwnhFGEoOsuGKQSGQSwVlpnU6/obly+0i1OjxaoUEC7otTwWkZf4aSzKFXkefZnAlQ/bpnk1W+fNRwOgANkEvEySycFtNsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zA6mApsF7oSCwTqkFeDnktg9WcZpRcBDRZ2HVjv4JhQ=;
 b=UW9TaArtzQ8dV1Lg3agj0nrucoOzqvyIZ36jHc2D//nSydpW+uOLMRnwPU93cVUb990ndwwsopt7UQJN99YIMpGfe3Y7S3+dDQ3SUuOg0d1hFSkKVR/p1MRiLD99aD5RdEGFXL+S5N+MY1CCK/tujxNJVBzZ6k/dxIfL7Rcnp84=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CY8PR10MB6660.namprd10.prod.outlook.com (2603:10b6:930:52::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.9; Tue, 24 Jan
 2023 05:30:48 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6043.016; Tue, 24 Jan 2023
 05:30:48 +0000
References: <167400163279.1925795.1487663139527842585.stgit@magnolia>
 <167400163305.1925795.9512359158912946568.stgit@magnolia>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     darrick.wong@oracle.com, linux-xfs@vger.kernel.org,
        allison.henderson@oracle.com
Subject: Re: [PATCH 2/3] design: document the large extent count ondisk
 format changes
Date:   Tue, 24 Jan 2023 11:00:22 +0530
In-reply-to: <167400163305.1925795.9512359158912946568.stgit@magnolia>
Message-ID: <878rhslcse.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0035.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::13) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CY8PR10MB6660:EE_
X-MS-Office365-Filtering-Correlation-Id: 068332c5-38b7-4677-907c-08dafdcc2673
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JV19Is5Me20J8xti3TF4456jMElvaS/u/UqnlgXp6k+eHJp5K/03nA0EkCaeIrEzY+E4b64x3qmLdb+rDFtOeq+DpX9xw48Hx/O6QSZIoAHTnG88/0dltZOQMgey7KW37Itlg3fbrCwkT8tUzc2IKWLZND6DyGFNRBbRhj59zJ7LRDgV9aDeXDfuWtoNtaDBDdborxvX2exp2OH4rIiAMalN6qY6OuBn7kLl/U7eKTQBhcRdNpIA9e//yoj/+NbCeEsG7KmD/sQFCgsn1oQ0dhFAsP6WMnCawdPoURFJPTB9lX4iIv4bvYQMHLvzrTQBqN/fJOKyRKKqvRV1YcC9EUZmfNmylf2xOl/1A2l7l0K/ad9NXyWRS36rTzRMuFGOpLQKri4m00Nu+HI3T2EWd+Bo/TrnoA6WQ61LT9U4WosZWH2hmltM1QODmCnYxdYX1Y6V5suXPMggFgtpb7dX0uG0OMvES1Xhk7gjSj0GLTgM3up8+uG7ZRb9bj+2/jq7R/rS/1zIyD17uL/1xHGEdRiR5XV0isNZbMZCvURXS/a2ipueYYtIxZhyCk+Idogn5CYb85Sh51P5c1mLAjGbAjCKh6JcZCSwipoGx+uWQ9hBjETXzHnSa2Cd23DzJS82gzkiAAQvqILICRXecUwsCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(136003)(396003)(346002)(39860400002)(366004)(376002)(451199015)(2906002)(5660300002)(6506007)(6486002)(478600001)(53546011)(26005)(6666004)(107886003)(9686003)(6512007)(186003)(316002)(6916009)(4326008)(8676002)(66556008)(66476007)(66946007)(8936002)(83380400001)(41300700001)(86362001)(38100700002)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fQyKFiWN5jJlTFa1e8DjNRWc6B2QSE7ffKz30hZpj2Me3ygRUPOGAR7ex3GJ?=
 =?us-ascii?Q?g0YfloSw8RbOzIbgx5vivGDimhzInSGhFJYPRbSZaWa98K6FF+tlrmDhJU7u?=
 =?us-ascii?Q?hzYAvCN5ZgQ5tD/jFXuA3DdpX8WTHR7GF7R2Kzm7FVJrx3kmNZ2JS/Gaa96A?=
 =?us-ascii?Q?CyjxlW6muwREtJy5IiNrzMTrkwx1P0H9k+JqjmiJaUxXH8I/xS916tr9bL9o?=
 =?us-ascii?Q?QQIY4ZscrgWBDUYd0OkHSV2hR5NsX2LVoFhJWrBtpOYd+rT7jWw/vrTht9yY?=
 =?us-ascii?Q?RJ8d8dLM6oESqFB3Ak/GYYOEPEcpRV3pm4qjCjlzeDUj8A+ZHlGe+jjFrbPo?=
 =?us-ascii?Q?SEbmXBaCSaYNv8foSSPZuH/x0wfPX1+n1NygeqYCv/u4r/oj6+lqH7bgKoB3?=
 =?us-ascii?Q?eau2yI8ukMFZYDH2Kyg5YLBCtSg99IBW2BD6VfrRTdgutmIpR+dLNjAcgrPm?=
 =?us-ascii?Q?GQ1lIb7EZ8B6StbaM4xKUzT43XwuVvPVy34tsif7kSHvzD9C8I7qRJOB5Lxi?=
 =?us-ascii?Q?/vgyvM9iziFQgG+VlSSaVnOuwQ/KlJnRTNndNF5EV8T7X7Vb/SUTWvV8fvs2?=
 =?us-ascii?Q?fkSF26GlhEpjihGDAIzXQ0U/uK1QtbdPTuRSEfenaZAXKfIXPHwdjbTzGOo/?=
 =?us-ascii?Q?vmQCqNQGVL88XnSWyv8Mdo1vvKp7NYrC9jSrddzfLYPm+6fe0tiieujCFjYa?=
 =?us-ascii?Q?pRyadzKOeKvJ6+RNeSCPf9mAcMmTEoQkej95zgV31jxm4D+5QVhO6o2mnwhw?=
 =?us-ascii?Q?WqbBqpTIGiGOpDTMwZYqkOxC95gDsfauGulqSqTWMuVpeOW4fPqUvdbHzLnv?=
 =?us-ascii?Q?W3kv2AD0MKGnKGKNizNNV8ASfXFtYDxkK3Qfbw2H+GWuzb8i0Pd0L8guQV2e?=
 =?us-ascii?Q?08oMY8VTC0huLhCN1k5gPjh/iRAQbHFIIgxpp6kwoI9/ZmB95ETSlsrYypOW?=
 =?us-ascii?Q?KqBgDMQkAHUF1TD7HoT1qM3FGyG9qVeXpS1WSRhuXFk2mN4cAHydlS/OJM1Z?=
 =?us-ascii?Q?G+QikZjQ3Lc45EeQDRTzN4oCg/DHlTY6C2frdhs1Kgo/u2ox57dROdAR6Yr+?=
 =?us-ascii?Q?f4VyK/B5MBFKawX+AR0NQNI6xJKD0h7xKVasYPp+f9UZsfnS5rvXq8FYFwki?=
 =?us-ascii?Q?/B6GaJc92LSj99gZi5/NApAFf34gk34recLEvM4P6xePqQFOuQEUG2zLahrd?=
 =?us-ascii?Q?2iGv7ZqTd9BYDU+c1dzhmeCsataE+iHXImIxbid0Yex4OKrVcanbgzIjxQL5?=
 =?us-ascii?Q?gKfVLjLy4DB9GKJ0UEXg9/LVM7OkMEYj2z5VJAJh0OXApjQEUWm58CPLvmSe?=
 =?us-ascii?Q?aSheSy7NHhLgJDL8eHrv6mq7a62gOHKfN6Vb8+glMAcdplfSBfTqVBINHUD3?=
 =?us-ascii?Q?eIVO0ReqCwB2nslnQoaF8/2k/Y4AD/9xWLzau4AXdCFc8clp9cIADLiv0QtL?=
 =?us-ascii?Q?92DQ1NDJczr0ESCQB3JWSv6fqM8PVQQeNM4ci2buVtYsYMCIGsipSSZcTnSS?=
 =?us-ascii?Q?04BN3XWiPIfKmQ+4dY7T46l14+wTafr3OcF5qeJP39qKkgZ/i/p90DUP7NrI?=
 =?us-ascii?Q?Eq1fRBfraJo7B9bYrTBb9VK8vNSG7E5FzRoyjYTXeJRglPwDlnlMtftTynfl?=
 =?us-ascii?Q?mQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 1NgS8FJhlO2PwlAbV8buKHIPr+UAeLh8cYBvk/W7G3yjxdsSe6n1DPHi5jYuvJqnAMbsSnSRz8+WRaW9XfGfWFJTPvHDOnN+OfkUuKfoj04t37s2R5JtVJOcdS0+eVOLLgt0N7Yxg14lVVmtrj9kKKPcD/zmndofaWxsylCB0HWab2ILhwos0yw1PhwoswPt0Pgku1JBiePUE4F0sDgjtVTmNsP/m0WLFEpUcFbd502Por9Z7fHiQnfOKbUh3p37Sk0WdZpJyG1JNgXVjbnORQHgfrz7Fh4gqi1poUuWEQywZxBNMkt3na5yDlJCbVamrOnzfscp2nLYRnorMIPC+mlfqGITbUh844I2yiwfc0jcQtm8bl/g9i9MFoQJX9CHdoLojegMXqRGRUwrXi+Ot4c3x2zaERcJASqJDusqM+SKdheitjWgWZ2KJdRWZMKguFlnG04PnHEa3GnwK8kTcE7y2AcOiXoFJLHW4i1mqaWnrQHBecnPtB4U6CpeeNS5406gTlby4OB//NwJ3Ztr+PLvG2RdswR3Cef2y0ixhqOCUtywG8Vr6VmwNA9Hfx6bfR5Z4EXLFNE++aKcx84wpkIneP/XWzyc8e+H9iPJ4mf0fUz38h+oAU7WS4boGdtiEJlCvN6aOFDGPybrHhZhuDZrbC6XpbygOLufG93llRtEMMr57qlts+fyRGC1EDJtQyhSq+Cz9iWFGXr0C99Dh/B3PAexNn1Z4URmyid6Dz9pprR5Ax1lt+OSdSYFBp+12bR7RW/1TLT6VZ2pSSfPamoziicC8fq8JkAGxmkUnvY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 068332c5-38b7-4677-907c-08dafdcc2673
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 05:30:48.8028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yhnYUnTI+xhXdrUGwRtZWCO4pT5Lu0hxbH2L7z6gyAP6TYN9s3m3QcTzidjm9gYA3G9wirO5fPtnCKkq5o494g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6660
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301240049
X-Proofpoint-GUID: JoUNYpo_75sjLwmajtEGU34qiSVuvP4-
X-Proofpoint-ORIG-GUID: JoUNYpo_75sjLwmajtEGU34qiSVuvP4-
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 17, 2023 at 04:45:05 PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Update the ondisk format documentation to discuss the larger maximum
> extent counts that were added in 2022.
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

-- 
chandan

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  .../allocation_groups.asciidoc                     |    4 +
>  .../XFS_Filesystem_Structure/ondisk_inode.asciidoc |   61 ++++++++++++++++++--
>  2 files changed, 58 insertions(+), 7 deletions(-)
>
>
> diff --git a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
> index 7ee5d561..c64b4fad 100644
> --- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
> +++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
> @@ -454,6 +454,10 @@ xref:Timestamps[timestamps] for more information.
>  The filesystem is not in operable condition, and must be run through
>  xfs_repair before it can be mounted.
>  
> +| +XFS_SB_FEAT_INCOMPAT_NREXT64+ |
> +Large file fork extent counts.  This greatly expands the maximum number of
> +space mappings allowed in data and extended attribute file forks.
> +
>  |=====
>  
>  *sb_features_log_incompat*::
> diff --git a/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc b/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
> index 1922954e..34c06487 100644
> --- a/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
> +++ b/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
> @@ -84,14 +84,41 @@ struct xfs_dinode_core {
>       __uint32_t                di_nlink;
>       __uint16_t                di_projid;
>       __uint16_t                di_projid_hi;
> -     __uint8_t                 di_pad[6];
> -     __uint16_t                di_flushiter;
> +     union {
> +          /* Number of data fork extents if NREXT64 is set */
> +          __be64               di_big_nextents;
> +
> +          /* Padding for V3 inodes without NREXT64 set. */
> +          __be64               di_v3_pad;
> +
> +          /* Padding and inode flush counter for V2 inodes. */
> +          struct {
> +               __u8            di_v2_pad[6];
> +               __be16          di_flushiter;
> +          };
> +     };
>       xfs_timestamp_t           di_atime;
>       xfs_timestamp_t           di_mtime;
>       xfs_timestamp_t           di_ctime;
>       xfs_fsize_t               di_size;
>       xfs_rfsblock_t            di_nblocks;
>       xfs_extlen_t              di_extsize;
> +     union {
> +          /*
> +           * For V2 inodes and V3 inodes without NREXT64 set, this
> +           * is the number of data and attr fork extents.
> +           */
> +          struct {
> +               __be32          di_nextents;
> +               __be16          di_anextents;
> +          } __packed;
> +
> +          /* Number of attr fork extents if NREXT64 is set. */
> +          struct {
> +               __be32          di_big_anextents;
> +               __be16          di_nrext64_pad;
> +          } __packed;
> +     } __packed;
>       xfs_extnum_t              di_nextents;
>       xfs_aextnum_t             di_anextents;
>       __uint8_t                 di_forkoff;
> @@ -162,7 +189,7 @@ When the number exceeds 65535, the inode is converted to v2 and the link count
>  is stored in +di_nlink+.
>  
>  *di_uid*::
> -Specifies the owner's UID of the inode. 
> +Specifies the owner's UID of the inode.
>  
>  *di_gid*::
>  Specifies the owner's GID of the inode.
> @@ -181,10 +208,17 @@ Specifies the high 16 bits of the owner's project ID in v2 inodes, if the
>  +XFS_SB_VERSION2_PROJID32BIT+ feature is set; and zero otherwise.
>  
>  *di_pad[6]*::
> -Reserved, must be zero.
> +Reserved, must be zero.  Only exists for v2 inodes.
>  
>  *di_flushiter*::
> -Incremented on flush.
> +Incremented on flush.  Only exists for v2 inodes.
> +
> +*di_v3_pad*::
> +Must be zero for v3 inodes without the NREXT64 flag set.
> +
> +*di_big_nextents*::
> +Specifies the number of data extents associated with this inode if the NREXT64
> +flag is set.  This allows for up to 2^48^ - 1 extent mappings.
>  
>  *di_atime*::
>  
> @@ -231,10 +265,19 @@ file is written to beyond allocated space, XFS will attempt to allocate
>  additional disk space based on this value.
>  
>  *di_nextents*::
> -Specifies the number of data extents associated with this inode.
> +Specifies the number of data extents associated with this inode if the NREXT64
> +flag is not set.  Supports up to 2^31^ - 1 extents.
>  
>  *di_anextents*::
> -Specifies the number of extended attribute extents associated with this inode.
> +Specifies the number of extended attribute extents associated with this inode
> +if the NREXT64 flag is not set.  Supports up to 2^15^ - 1 extents.
> +
> +*di_big_anextents*::
> +Specifies the number of extended attribute extents associated with this inode
> +if the NREXT64 flag is set.  Supports up to 2^32^ - 1 extents.
> +
> +*di_nrext64_pad*::
> +Must be zero if the NREXT64 flag is set.
>  
>  *di_forkoff*::
>  Specifies the offset into the inode's literal area where the extended attribute
> @@ -336,6 +379,10 @@ This inode shares (or has shared) data blocks with another inode.
>  For files, this is the extent size hint for copy on write operations; see
>  +di_cowextsize+ for details.  For directories, the value in +di_cowextsize+
>  will be copied to all newly created files and directories.
> +| +XFS_DIFLAG2_NREXT64+		|
> +Files with this flag set may have up to (2^48^ - 1) extents mapped to the data
> +fork and up to (2^32^ - 1) extents mapped to the attribute fork.  This flag
> +requires the +XFS_SB_FEAT_INCOMPAT_NREXT64+ feature to be enabled.
>  |=====
>  
>  *di_cowextsize*::
