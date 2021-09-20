Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC758C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Sep 2021 10:11:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF5FE60F9B
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Sep 2021 10:11:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235683AbhITKMr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Sep 2021 06:12:47 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:58828 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233557AbhITKMo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Sep 2021 06:12:44 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18K7u4VU017942;
        Mon, 20 Sep 2021 10:11:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=ibAZtRbKyHJtNSRjgGG+IZgvL4OyKYopUfeILoQGb90=;
 b=jXTarG8QLa3+pBV1h4HgtJ1k1dxH+xA85+MRatcS8w5lQZ9S2MvJTa/of8/XL2eVd7el
 qsO3VZVPwMxqBzhgzCEMrV57j1a396nxwlLwk85wAkNhimR988rhVCVs+7/b8MWHYkCd
 njMpETC06fui799CeqFXYPnVN8DIyPqGv1fXjLIhb6xdyNTUI6P5qbC2C5cdsVM1ul16
 sN2BhqO0gJpnRG/d6fXUBJlYIttbEDlYyACnYUjvxYub8+IJz6gTaTOEH8V+ZLzmXi0G
 fLPuTe44Tdf5vkIcr05jMPPRt7gKZ2f4QA3142lBoQnLtEeF1/eR8Zz2a4kKBGF+LS1X bA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2020-01-29;
 bh=ibAZtRbKyHJtNSRjgGG+IZgvL4OyKYopUfeILoQGb90=;
 b=qTINbW0Am1oiE8l0skkEMKqHmPlQ0Y3fOctBKXN5IgguwK/phzCs+Abqab7l8rUDewFt
 6KJlVJK/aSnCQbhue0iuV4tJCm9lHsugjwuGgZ5FNJeAgIy5XFr2bjz/RCiCO8xTxxq8
 /SA0byTGzyGFtepc44nd5BF4AWMGQquvrV+d8EOhZ56YwGGj3+KU1uc/N4O5YIjiHTBB
 3olpPACwAAvMz7uVgNybW/ZIeQWtnWcdqHj7vVLC58ZGCUyOiqtyBi9jzOTdBqSSjGlv
 KtUVr9tFQVwx22UiUt0uGp1P3Pe+S8zNu40vMC5YWtAHytgHi3XG1BtBDpHdOHaNk4pf CA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b66gn1r5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 10:11:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18KA9sNk085086;
        Mon, 20 Sep 2021 10:11:15 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by userp3020.oracle.com with ESMTP id 3b5svqfu8g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 10:11:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dR05lEl+DPhoB41EXNCVAf+G1SR9Bgh4wu/+Fz+yooZ1kd/U7kc5EmRGntmtTAKotEAdRchI9F20hYuDtfEnb7417jWUg7KEl+Npkz17m+KWl7NSMekRpwCN/e/qpuOu5J2xGz5aQFXH6IK2IAfGPHPfL4iW8B5fIigkID4Jj67reyPJ5ukPAM4H4ei9r5kSofoKS0+MWp8sNcckAPBdQFm1oLTakpcNAZ6NwROdgV2cpBXBE9LEPZgRD8x3/u57uJslX3H4zugWNWtdmIdXOUli2pQntmV40cvmLcrEkWMnGRbYyI0BoY596f5Ni/BQ4oJ4Z/OCK0itO9BwAJB/bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ibAZtRbKyHJtNSRjgGG+IZgvL4OyKYopUfeILoQGb90=;
 b=j0QKYVf1QCbXTk+6Qn02UMZ8V5d8LpTUysn65ttrDyHvdHcjdPk8IpJAH/WPusbvp7MS+KD2Uoz0ffXSDjzpniaXQxnpic7B5MrG5hfDJLf4gkp2vDp80/wTojwdAYJ0q7ggCbz37y3RZmJRKVhgNil9YjjX9iKtcgG8wdcqmTC+0twHUbXqfEVY5z41XMPODg2keLTYJz0yQedkzwqAyoyZCte4kM4cvZqD9aIGL382Lj6eouxRZFSRVb75/AHoG/MqaRSQihCkdhsMCNi8rj+WnoBJvfnrRw5FP6j+IVPVoYacSAJJRH/ZixmG+nqDQ5ak5Xp2gXUjVHT+BimamA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ibAZtRbKyHJtNSRjgGG+IZgvL4OyKYopUfeILoQGb90=;
 b=VEroSsFejhl5udhs6E4jM4+6gI7QL+abCkKKBY4rsAsL7NxqOw79XLMZQaVq1YzKXx67yFZN6ThPlTZe/QaCXvGZjxNSSAp3lYm0Oz/vGBNrU82F0a6DbcJr4svAbMr/ob68tpFPi7D8I/HUCBYJEQ+rQjTaSUNuBlZv96Yw4rU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4540.namprd10.prod.outlook.com (2603:10b6:806:110::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Mon, 20 Sep
 2021 10:11:13 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.018; Mon, 20 Sep 2021
 10:11:13 +0000
References: <163192854958.416199.3396890438240296942.stgit@magnolia>
 <163192859919.416199.9790046292707106095.stgit@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandanrlinux@gmail.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/14] xfs: fix maxlevels comparisons in the btree
 staging code
In-reply-to: <163192859919.416199.9790046292707106095.stgit@magnolia>
Message-ID: <87ee9j7eqx.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Mon, 20 Sep 2021 15:25:35 +0530
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0054.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::16) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (223.182.249.90) by MAXPR0101CA0054.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:e::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Mon, 20 Sep 2021 10:11:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f1baa740-cb16-4bbf-ce64-08d97c1ef9b5
X-MS-TrafficTypeDiagnostic: SA2PR10MB4540:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4540665029870F04E6E41E5FF6A09@SA2PR10MB4540.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cILKEbghaQ/Wf/hxAVvgIuCKC88xtGzn1mBTKo5fnEVnFQG8gVU3BjI1XMmUPvX6MZcAfjb3F6D6kcfOg/LCGe12ryigM1i58Rb/8ZKLheYChB48IzYjIYK7gMw2TEED7JeWcl/4vZLlCgAReocBrzV16aP03wWuG6hH02LouhAEjuVheX0yfBNb/oe8hFzrFW5ZQA2Nm6mhkNJ7jI0NFHg1cdAuLbu39DTwstkqnu/tT1qnn5JPgCnBrTsmDwxjDfCNE+VZIumHGce4ukKIeHUYzXcauG+fMxV9KLYrLBtD20sfRbEpktq41PCGKuUqoSdHu6fFFqIde41toBff86VWhtBJONbYxUWUqc0NJZPJI5HD5W1G5OBZYsaYh7cA0GFaXUbpqnVQXfQC7sfnZwfosGHN0PjPRjQtOY70uDp6u4nm37dP5zx1sfu30K3kz7GsZZr+u32ZeV/r/ZohmFQ2W79oWEcKHfK7DO/u50AE3O1PByDKv/uVKycT8nH5vW3OMkbAYV3evE98Zt8xdH2MVXmeTwALak9YMvQL1tK78/YkJN2qbLWua+hMY8AkiwVR3Zi0pmywzEPaA1M9AkotsJqJxwnT72L2zrogexwdvuMcPKp+v8CLb3PkQIdVbpeOwefSgCsqNCfng4+mQcLV8SMR+8lDc8bgDXx3r3GvNUccb6ivUWTYhJN46RbOjRnxEcof3dupTAVf+XCEIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(316002)(4326008)(33716001)(26005)(52116002)(53546011)(6916009)(86362001)(6496006)(38100700002)(8676002)(6486002)(508600001)(5660300002)(38350700002)(66946007)(956004)(186003)(66476007)(83380400001)(9686003)(66556008)(2906002)(8936002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1PzwE4MidcpH6gArSret+KjZT+scZ7fuo01XRBOsMJahdcbfKxQXPxl9SOYv?=
 =?us-ascii?Q?fHRCaz/8sGQ+1zbUPOgkW1S/2NyO826n18l6TNCW43dBupUVF7IEzc4mxVg2?=
 =?us-ascii?Q?oUl4HiM+4qgBvsvMqG49fHaGmEUJzXK3oc+9BoZ4QVcDp3r1ioMmINRIBc6z?=
 =?us-ascii?Q?ekosc1/fw2Sh3cNC0oqq9RRPITwHO6rhWMzVY34sgL9PaFSxW1HTaEdGgTwB?=
 =?us-ascii?Q?g6v322sMvu56Ycp1fa5bjeYmmrHUp//5FFmv8ZoYwfU3zV2X/gdaCHM4ccfR?=
 =?us-ascii?Q?24QcPpsl0R4RRTdX8ehAdsyMnt7A6KmIZlX1wPnt794TmnQAdzvxolAu528B?=
 =?us-ascii?Q?mcfwoYIoCMkiPQyWCaWTC7qY0HJC01VUZldXGiS3JmPsJIZPHZKhQBia1jQQ?=
 =?us-ascii?Q?qUNNTahzDvQiMXjpjriROYoEhOQfsi/6ncw1p5MSFm4o9iRC06gcqUvSYDrT?=
 =?us-ascii?Q?n/vVXYiCz39brOg1via3sHULw00tDZfGcwUfECFVRSwWsnQiqaqW+5/iknJV?=
 =?us-ascii?Q?7L/8wTscKC2RqfgZcgA7wz1J7U0QEgsQUzF+FpnmGWLa7eJ6kK+GEktVgLCH?=
 =?us-ascii?Q?EXBgdkD8o1i60OmIHYEmLzKGqu3AfNQeu8p6/vwn1a6nOpEQWxAPhtJ2wvNS?=
 =?us-ascii?Q?+VBLG+4XZD/qTqX22AnmkmwPtaVhZrV9uMhxnw3sVGaQZD11KJeeysztFAgg?=
 =?us-ascii?Q?YxtNUAuwu1iwFTH8R8d20FwmttnYvj7jYUkc+CmD7CzEBDY/zYTSFGyBkGkL?=
 =?us-ascii?Q?2xqPhNOgcwcKh5Gxn11TBMAlnVi78NtWHOwjRKn6EJi19p3F5wXioZHlZ+n5?=
 =?us-ascii?Q?ftATEtrn6U7a3/AB2UrfuueQywRBWSKbEw0oyPQZEuq6Jxm0vxV9T7ZzHGWQ?=
 =?us-ascii?Q?ErxNzl5PUOe6BLJ16O8SPkSuDiCeiMYv0dvyt0Eli99th9CSq0H08vsQ8cg8?=
 =?us-ascii?Q?adk2x8TvCRDqSm0lQmREkfXtgBHIj9MPqMUBfLirZDgaQY6rzQ9I0bi36ZBQ?=
 =?us-ascii?Q?mx4oRzx+1V2Gl79cNufcEorQQ3J6J63BaJ1cDDAzm4J7S9XEVTsWTXg3ENPp?=
 =?us-ascii?Q?/Iam4O83vMFw04iMERoqAOnHgKIVEyYtllfzOjNaYw0Yk3PSO/1kL9xylNPp?=
 =?us-ascii?Q?UZxm3m4tWIRQAIJOctRbOKglRyOf/dlJ3WK5P/V9O7yW5mYxrAjPyslFkMbE?=
 =?us-ascii?Q?bDv8yZ+BK3SONKKOSYHXfPP+3vaFqiE1jiztfEJwZ/DJ+Ym8D6P0yyudnB8B?=
 =?us-ascii?Q?r8ntxFYNAHDX9sAja3OWoewtbjDW0atFs7HpvOLyJPb0QvBAfNeyCYOt7aph?=
 =?us-ascii?Q?vtjAeEiEElszE2c7B4SaoKUl?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1baa740-cb16-4bbf-ce64-08d97c1ef9b5
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2021 10:11:13.2957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cIBlf8OSLzvi/qiy4ec+7M3L+e8qyIchHuL6RXGkr+t9SbDeXaJHCm/6mIq+MVNtbrtIZ4YAAS27sxGWSdLSNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4540
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10112 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109200063
X-Proofpoint-GUID: bdW1Uj1NiE_TrywVDmA-w6dhWI5xqy1f
X-Proofpoint-ORIG-GUID: bdW1Uj1NiE_TrywVDmA-w6dhWI5xqy1f
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 18 Sep 2021 at 06:59, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> The btree geometry computation function has an off-by-one error in that
> it does not allow maximally tall btrees (nlevels == XFS_BTREE_MAXLEVELS).
> This can result in repairs failing unnecessarily on very fragmented
> filesystems.  Subsequent patches to remove MAXLEVELS usage in favor of
> the per-btree type computations will make this a much more likely
> occurrence.

Looks good.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_btree_staging.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
>
> diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
> index 26143297bb7b..cc56efc2b90a 100644
> --- a/fs/xfs/libxfs/xfs_btree_staging.c
> +++ b/fs/xfs/libxfs/xfs_btree_staging.c
> @@ -662,7 +662,7 @@ xfs_btree_bload_compute_geometry(
>  	xfs_btree_bload_ensure_slack(cur, &bbl->node_slack, 1);
>  
>  	bbl->nr_records = nr_this_level = nr_records;
> -	for (cur->bc_nlevels = 1; cur->bc_nlevels < XFS_BTREE_MAXLEVELS;) {
> +	for (cur->bc_nlevels = 1; cur->bc_nlevels <= XFS_BTREE_MAXLEVELS;) {
>  		uint64_t	level_blocks;
>  		uint64_t	dontcare64;
>  		unsigned int	level = cur->bc_nlevels - 1;
> @@ -726,7 +726,7 @@ xfs_btree_bload_compute_geometry(
>  		nr_this_level = level_blocks;
>  	}
>  
> -	if (cur->bc_nlevels == XFS_BTREE_MAXLEVELS)
> +	if (cur->bc_nlevels > XFS_BTREE_MAXLEVELS)
>  		return -EOVERFLOW;
>  
>  	bbl->btree_height = cur->bc_nlevels;


-- 
chandan
