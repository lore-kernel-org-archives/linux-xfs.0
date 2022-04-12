Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB962C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Apr 2022 09:59:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344683AbiDLKAs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Apr 2022 06:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359777AbiDLHnk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Apr 2022 03:43:40 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D4054338C
        for <linux-xfs@vger.kernel.org>; Tue, 12 Apr 2022 00:26:14 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23C6x25G014133;
        Tue, 12 Apr 2022 07:26:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=quhwUGhCtjRs56UNLC7DKX8kHdjpRsIker3RK36mXKc=;
 b=U8ZEcuzvcW7iwcVwOEy1abS6/wIbdMMltaOlUUr1BPKjDjxPSVD73d6wvR+nKZBnx1yl
 xcsUsTmHrHngFwUf39DMtYfdX9SjzVmC5zJbFW2bzqD2UaWBEpokMqb8u/TGZScC+FME
 uVY39cGgi5IVvpZvZKCP2tp1S89C2xpm970Zbh6WGIjzNvM7rai7LG8pD7OwFOgnkOUF
 UbKTz0XjRtROX2pVZS+N7dQUhfCUERKssAFuqlpjznn96egpXignCOQVZVOS3+iWU+3u
 x3QIT+yl+bZVBGohg7ceh5BcmJL2m1GYkayv1ZTKhILwc4Dd8hbTMiZ0Yfl7xNqgLnw6 jQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb2ptwwys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 07:26:13 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23C76NLB037534;
        Tue, 12 Apr 2022 07:26:11 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fck12cc1u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 07:26:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hKfqNBkJQI6Uv5HUQG4Un/o7TBggiB3uuzlL6nx8MLHTYry77epWFirRwh1HrvHpWt1jUPfLFbv7j3bZAybN4qT5ay2gdxup3TPa2ZM8toIR/ZTfxxXZBR5wXV22hQM/eWE28sz6MfSuD3jdLNbYVwd3CXsqhq67Z4FkwASwPc0iOSm/CmK9E3PzoowcX/nRTydauWBzv1j4llEdj5c+ubfW4dFRD52OZSlqtmULLvmtC35rFc9I50EuFkqhPEwwDOchwJ2r8JUEpltcd9VhnZC3T9BapM/WKuYikqqIDyd+czIVkP3p5wbpcIaMf7NrH2VOfTxOjO9abYJI2EfzsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=quhwUGhCtjRs56UNLC7DKX8kHdjpRsIker3RK36mXKc=;
 b=ed5V8S4cM/EQ/wr6G4XMwMBC8uWN8rkp+QjoGUa5QG61XUW022cFzi1UPsk69qQCPRm6ce5zE9/VmdccB5+Ev/fswXN0m/hoxwCc7Og8qy3wNwTVH3DuZC/+TxfpoU9gd4gZGmdbXpkT7o2q7bkMLNtj6hr/9b9JIuHl5wm8nUr45mOPKxxrs8gPdKuiZYEiqwgW3ycrq4Iab4Ye01GAZ11LFZgYP1+VjEyJ7UEavcf5JqZsmlCEud3y4bnYsOhYuU1yyr+3USCBkKJi1dn6ZmcbawZLhcOITYyozzc7gG4qCXukayTX0s9Cd2zgId0eyhdDNYxPBf668pntpbCacA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=quhwUGhCtjRs56UNLC7DKX8kHdjpRsIker3RK36mXKc=;
 b=l0T8Ei9mqlYwEapvQVGc5drbl80p3gs+XC6khwwd5JZzEyE8/Sw9EhHlzvB62SkWnwx6+I4A7mtmogFvKN7GjhXfm1mm3okiu4/zMumUhVzT8mUfWyf/hBr+4eFiVhWYDtnmPNumfoiFUWMf1uN8LMTtelpzZ6+SRpKCIVhnIJ0=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BN6PR10MB1761.namprd10.prod.outlook.com (2603:10b6:405:a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 07:26:10 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::c95c:3552:3b30:30ee]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::c95c:3552:3b30:30ee%6]) with mapi id 15.20.5144.030; Tue, 12 Apr 2022
 07:26:10 +0000
References: <20220411003147.2104423-1-david@fromorbit.com>
 <20220411003147.2104423-12-david@fromorbit.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/17] xfs: convert dquot flags to unsigned.
In-reply-to: <20220411003147.2104423-12-david@fromorbit.com>
Message-ID: <871qy2225y.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Tue, 12 Apr 2022 12:56:01 +0530
Content-Type: text/plain
X-ClientProxiedBy: SG3P274CA0018.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::30)
 To SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91a05cf7-fc63-4506-2037-08da1c55b726
X-MS-TrafficTypeDiagnostic: BN6PR10MB1761:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB17613DB0216BAEF4A72D0F2AF6ED9@BN6PR10MB1761.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kB0TTrehfiflFGAJ840alAt/mHycfEo1hX6reu/vBaL/gmRZhfWIa7ytafY2+fIfzVzvwbV1x+SxizjUvquvwvw3PPvn6EdVjO9iXWKCvm9SL7AmglTcu3zlyz4RyQEi2H6rMHPNCZb5Rfb6qq9ev3xKY2D6OoHHQiQgW9CVor19cSXTlydDo0GN6jwNp3J0rdInHEdsrzz524FoApoKNm/FCQXkPe7Gy4O9DSZvpEib4/GnApouGLpeWHxRN6Akfr+N8aWVr4WTykGyrqXfYpGhNlyqgZLGQdSkJ1AcPEj1MmWPuH11Om3LiLJXYrMyA1yHs2XbQLpsJ2R5rb0VqRvVXQZWdbPEf1Zd+C79bJOBdpr7aroWqmjnI/qh+DWNkxVE6AU0QPlCDqIk1v2tLRwiBDWwHGwZ+kyc/nWuU3dOYQzt0B/8I4pPJfvotu73WhMUvImwONLw6Z4pl3r6XdtAVqZXg7dzEz5sdYRRg9bSQLz8xyekmqkDQjhcLVxILStEZxoCGfJInnvyKbTdMqSZw8qD9aj/XlShzr6wl3MLDeZLaQoFNv8bJHexq0n3Z8huTvysMjsLjrZLBP7iiZOi6ch9ImeZDPffc6csNR0XJ7CTCollgl5qvkURcTRqLEVpEosBd3lk4C+DU8gKJSCE/d5JQyXPqRT92kIS5uoXwlyk6dCQF8/OiIn6ZBjqQoqTdm0C3sA+oMKx2M2x9w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(6916009)(6512007)(316002)(2906002)(9686003)(83380400001)(508600001)(26005)(38100700002)(38350700002)(186003)(6506007)(8936002)(53546011)(52116002)(66476007)(33716001)(8676002)(4326008)(66556008)(5660300002)(66946007)(86362001)(6666004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BFTFPbbB5gM7OI487O3RP/rbZ1N4HZ0hEss4w5InxtTyuFoUnkrwcI88tRBV?=
 =?us-ascii?Q?jB/gQcwDpip9iMt7iDcnLmcZC1YAFckejtmoPi1anCjs2B7IlBsyKE6h3dhV?=
 =?us-ascii?Q?YY4qQGurmFAQGNTs/vq/eDFXuIzRDLPJSWvMBOo12p/3NvuLNS9ejdl6pR3y?=
 =?us-ascii?Q?MZLnjas+oTzh9eODVF5KpOei6nF+qLzMssxDNS/rELNB4tTYk/7jr+lwRTNg?=
 =?us-ascii?Q?N8wcY3Z7jA6xP4vPk9w5ztIoXBwgBvjKbiYQlvIVodxk3pIuLj+A1M2UC6g9?=
 =?us-ascii?Q?14wx0JfsYcOdqnNkE2gIINcnIBBbkyooUnh9QlfJJQuEYlgYk4UltO79IFpz?=
 =?us-ascii?Q?Tf8BVkAeunve/33KnwnKjLfRCPkeGjdqt5sWmcr+ZGlKURPu4EbYBdp5o1uN?=
 =?us-ascii?Q?S5KYuqINpcheublLexx+ntEn1mFpjm6Pi/b3FFH//sywzK1EJqKrOLOL3vO4?=
 =?us-ascii?Q?u7qbFVrG/owveiRSybhZkJ3slqS140sWeC9a2DNxoA+SxTQPyN2kxn4mzVyO?=
 =?us-ascii?Q?z9CpNkjMWosphcil7FYxxBo8vLW44rse13VWlllhOjbd34iavdfzQ/lTHJe4?=
 =?us-ascii?Q?5VnFN/W0b7bqDJFUzZaKx0jERzGCg1L8OuuU3aoCQLPo+o7UYKqac5MMsHN6?=
 =?us-ascii?Q?jVtbU+9ZbhO+s9I0TtfnzxhK8rvDUllhCYh2Z/x78HOoJiJKvd1NdcNuVvVf?=
 =?us-ascii?Q?e4rnzegwswF1sMnXPlAmH7HApBCF+cCzE5yOYSAzIe5DBV/4vLzUbbxSR3Vb?=
 =?us-ascii?Q?BI8ut7RdmAoyPhltV+8ej9tnBXsyAmusqWIWX2uDHY7SdVJ7MskVEJ5mR+8Z?=
 =?us-ascii?Q?2EG1x7YMfRQncA8BV1SMUwYYvE2/7rRlONyIUiFnGqOszl3TdF7590S03ilr?=
 =?us-ascii?Q?LI5mYznGun+7bAglxd2iSHc6jjePbm4ymFlqTWe4kkIFt9CJKL+QzXB3Y21h?=
 =?us-ascii?Q?DvVSMLM/FxwXsKhhLOZfFLjM6whazJHSGukVI6+YpUXmisAid5RPmtxkR6I4?=
 =?us-ascii?Q?PSrw7izTq8swWIFP7NokYYlkrUApCZ7a3lf3DDlH3dO2j5PxjAac6v3b7xSn?=
 =?us-ascii?Q?vIRPAo38jL7X58FG1NkxiAzWtQXJDtj/HCVWr+IjqbHeWQcnLJMHYBHAFGEa?=
 =?us-ascii?Q?DG7OyGtREpTwmZh1UTjN+i+S6uqvj4Q0QaMbZ6EbYkfUMPsp66+LTs6ix5ID?=
 =?us-ascii?Q?7OVXgBs6mgJMQrnyo1GYnEFQ44cSx+h0bwvh5669p4f4wvIXD1wal4TBoyeE?=
 =?us-ascii?Q?RVfQLfHGYm+2uO0im5WYxlvvjoTZ/5/ZMSV2HqUNe99eZ0uN0Ytm5CiIqt6q?=
 =?us-ascii?Q?Sr+dRPVNItgYFipHP+ENrnS1Pz5W/CYCmRM5/K1PHm7whB2O2ivJfEsYKRgD?=
 =?us-ascii?Q?oRDCBAK5WJsW0MSS0UVNExfNNMwHgBZv1+Z3cj6atEYTIMtFT6xOP5E2kxon?=
 =?us-ascii?Q?KouQxj0gYC4Xtb4hiEti7FOqJ7PIcfQtR6JKUOEDAK04wQwbe9dtBj0+zi6X?=
 =?us-ascii?Q?knXQlX9N2Wvf7n45qcLgaSojHDlNJG7YnTSQQYBt9rxwxkM1saWKdIukRdNK?=
 =?us-ascii?Q?1LkI9m91CaZAYmHKCoSab+29GgzeBt6b9u+Hn6sO3CNzlqFOEWdiwVXD2o5N?=
 =?us-ascii?Q?/Ww+8twMyYd3P+IH7451vCpkXYAWFuQzHGyoC03hj7SsYBVFBzK8LdUYU4KE?=
 =?us-ascii?Q?45R0qzf/ZXgdPzvIF5g7QB24g2t02huRrSk/bh6pWrrRjqQIYcLBnc8qe6M+?=
 =?us-ascii?Q?lrLVFdsYcEBlPu2qOml75WPQYTSeeUk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91a05cf7-fc63-4506-2037-08da1c55b726
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 07:26:09.9853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4/z/h8lwfYPWKo18G7FUXZEhPVr7SqzjT1cgIg0/TL+f4ge5DppNZTvOHhlJ8pGaUrF0zbAoFNqCpjv5c+rnAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1761
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-12_02:2022-04-11,2022-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 phishscore=0 mlxscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204120034
X-Proofpoint-ORIG-GUID: mr6KNO-GDa3Z42ugWR6axav1On8W4gC5
X-Proofpoint-GUID: mr6KNO-GDa3Z42ugWR6axav1On8W4gC5
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11 Apr 2022 at 06:01, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> 5.18 w/ std=gnu11 compiled with gcc-5 wants flags stored in unsigned
> fields to be unsigned.
>

Looks good.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_format.h     | 8 ++++----
>  fs/xfs/libxfs/xfs_quota_defs.h | 4 ++--
>  2 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 0d6fa199a896..f524736d811e 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -1085,10 +1085,10 @@ static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
>  #define XFS_DQUOT_MAGIC		0x4451		/* 'DQ' */
>  #define XFS_DQUOT_VERSION	(uint8_t)0x01	/* latest version number */
>  
> -#define XFS_DQTYPE_USER		0x01		/* user dquot record */
> -#define XFS_DQTYPE_PROJ		0x02		/* project dquot record */
> -#define XFS_DQTYPE_GROUP	0x04		/* group dquot record */
> -#define XFS_DQTYPE_BIGTIME	0x80		/* large expiry timestamps */
> +#define XFS_DQTYPE_USER		(1u << 0)	/* user dquot record */
> +#define XFS_DQTYPE_PROJ		(1u << 1)	/* project dquot record */
> +#define XFS_DQTYPE_GROUP	(1u << 2)	/* group dquot record */
> +#define XFS_DQTYPE_BIGTIME	(1u << 7)	/* large expiry timestamps */
>  
>  /* bitmask to determine if this is a user/group/project dquot */
>  #define XFS_DQTYPE_REC_MASK	(XFS_DQTYPE_USER | \
> diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
> index a02c5062f9b2..fdfe3cc6f15c 100644
> --- a/fs/xfs/libxfs/xfs_quota_defs.h
> +++ b/fs/xfs/libxfs/xfs_quota_defs.h
> @@ -29,8 +29,8 @@ typedef uint8_t		xfs_dqtype_t;
>  /*
>   * flags for q_flags field in the dquot.
>   */
> -#define XFS_DQFLAG_DIRTY	(1 << 0)	/* dquot is dirty */
> -#define XFS_DQFLAG_FREEING	(1 << 1)	/* dquot is being torn down */
> +#define XFS_DQFLAG_DIRTY	(1u << 0)	/* dquot is dirty */
> +#define XFS_DQFLAG_FREEING	(1u << 1)	/* dquot is being torn down */
>  
>  #define XFS_DQFLAG_STRINGS \
>  	{ XFS_DQFLAG_DIRTY,	"DIRTY" }, \


-- 
chandan
