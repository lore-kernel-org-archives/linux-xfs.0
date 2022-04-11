Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83BD2C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 14:04:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346877AbiDKOGX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Apr 2022 10:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343489AbiDKOGV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Apr 2022 10:06:21 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B76AB5D
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 07:04:03 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23BD0u1A031505;
        Mon, 11 Apr 2022 14:04:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=txmMSyF0locJln6ex6Le3+MBA5se28/R6w82GJdY6Yc=;
 b=Gv6i0Sw3m2eIFWuLAlNzZ/3piZoDPF/BIFaZ7Jn/t0KEwA+aJCnVtjXfaKtfBVkivz73
 P4tqf3odMv19m+cKdetYF/vF997kcuHgQzgR7lwPWjX9gbnQ1MUnh1dnxeJBc8s2VIEz
 pleDf7rIyTEiw2q1tU6sjPGUmkUZ8tSnAWOwWYgTrYCO5wz7fxP+ywbYB8imur7BMy6n
 KenWsYhWTctywQPrrwT30mj4dgaA60shEWBHS7s3kxaJVOYrZuZ8tD1ElJe72uQMQncX
 ryDhoZ8Cbm73Im1jLDlfxzeIn6HU2BLwRbiIkeZI9GApa7aqx9VkgBW36k52taSdT9pl iw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb1rs3rt3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 14:04:00 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23BE291B011164;
        Mon, 11 Apr 2022 14:03:59 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fcg9g9xu5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 14:03:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ljpijiamVzGWVMcTFpkKk92lDmMbawyEAWewJ1rFHWbMtEFxdcPHA469VPF32QXDP+v0GiuaySWGMm8cMWHcr/VVlNYltdwTSdS8ju5kc6a5OAglW8wy4fFzavCFcLwe4wcLmmDWW0F06b0iCNkka8Wih7Q6dvQQfuXl+l6Y2h4R4rV1/bV9MLcPi0qrWHlg7krtuV7GmkRjIFiPsRz4vu8aUR90GInqSjWwg5brExKqMpjFd14Xk5ABZ8NhU+62OMB6csTC6QUBsdBAjdTTewnyn0TmL63N0ghsPyBjO8RHWhSHmKknQMHIXG6UdyLK1eKHdfojhFIwRTs7bKK/Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=txmMSyF0locJln6ex6Le3+MBA5se28/R6w82GJdY6Yc=;
 b=mlPqV3m158bzJI/5mmAC8nIOyottt6LY9VaWf9hCT/XqwNnqw2qsnS6l2Rs5cX9sjsk6DvaM3KeDKy35oyT20JXaoO1lwCqugPlVR2Sgxsc9UkldLtrh0gUB7llQ7nRnoYD18JEPXZQO7Dvim2kF2IvE6tovOdOYYSsSWxa1zYqEXRe/ZgWXNvvWbRuO3mBRO8W55Qrr44/K6t384sRLN9U7G5tUpSyzkqhE96Z1hMJe9ImoW04u1Y8JODFPX9R851O2ZR74wbuUh9aHXvL76qP8pWimeqTA9oJxzqI+ABiKhLFAUZjhs5ppWdo8RofaZcoyEp1J5QmEqebpcBItJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=txmMSyF0locJln6ex6Le3+MBA5se28/R6w82GJdY6Yc=;
 b=S0tCl7EgRPFUe0hwllkGVgOyj5Gv2c0FRgx6YuZDnJFwY1lnEs2ggF9frd4jxcth7vrVPhbmrOvjCYEEJIYFpM1q5BEAPL8s9KCuvFeod6+y0NRHGqa/dxOBWJMnYIUMatPIEbRPqArS1djNPgsVGUncjw0eMIkx/uatqDkQuEo=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BN7PR10MB2451.namprd10.prod.outlook.com (2603:10b6:406:c6::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 14:03:57 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::c95c:3552:3b30:30ee]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::c95c:3552:3b30:30ee%6]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 14:03:57 +0000
References: <20220411003147.2104423-1-david@fromorbit.com>
 <20220411003147.2104423-9-david@fromorbit.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/17] xfs: convert btree buffer log flags to unsigned.
In-reply-to: <20220411003147.2104423-9-david@fromorbit.com>
Message-ID: <875ynfvhrv.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Mon, 11 Apr 2022 19:33:48 +0530
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0156.jpnprd01.prod.outlook.com
 (2603:1096:404:7e::24) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ea06fee-ff18-437f-feca-08da1bc41ee5
X-MS-TrafficTypeDiagnostic: BN7PR10MB2451:EE_
X-Microsoft-Antispam-PRVS: <BN7PR10MB24513E8F649F1AF63377252AF6EA9@BN7PR10MB2451.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +uFUxtU7Ze8fyaRikqBF5zkpQM894KZo+bt8ohpQx/fmsaLR4Ujbt0tfa0o+1+NTLvV4WBX7Jr8GonPsxALAt1SZtc+LxZq4n/IHNuUZWS1JtRe5ehYOQf+hdD+oYlijgDfobFr5lqeZovIAszVmves3EQLOyqChrews5C1HDWxAm0ghrYGlbQZZxgYmdUkwLdwLmjKU617fUK633DtJK9wwAMe9eJOxyUrBVdEBL0qY3IKmTJ/0HeZLos+kVQWZPBEwOsWVIIWfqdWIB4QLuGCzhYwzyT7ZFhC6rkj2vKIrAQB29xu98ITt65D4vKOsRjrWf7TJ0kuv7ttWxZYwEi1iGBrjelFbe21g8uxi46+q/T9FVsnwE+4XbWvkkWiCAy+DiNud5nNuxJS7MT14no1on0lGFWaBcDN1EWiKk/zLei0H9OT7aPm+10KuECe9jeEwWbC27uAwBFjqE0AHSTK11ihuDkiFgvcN2oIQ3G8nWW7oKdj1xX+7EcoeBLSKBmdaGAtkhJXqNVWK9+sE+u3750RrFcagPOksqvH/Tqv3hqkR2ONnXzQ19FrdeRdJ55mOB5wMaWgt0QP0OM+2iFZzHFDUhNYmtus9XtZA07VZlOxuiiAuvGIHaqTAIiH5Gy0UKj8zH6OwKQozbGv7BVtXC+wK/uejq9ZzaeSwowYA36CgvYSBItYfRUd/aOzzW8Wr+R4ZFyx7sTBUeqjKqg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(33716001)(6486002)(38100700002)(38350700002)(66476007)(6666004)(5660300002)(66556008)(6916009)(2906002)(83380400001)(86362001)(508600001)(8936002)(8676002)(316002)(9686003)(66946007)(6512007)(53546011)(186003)(26005)(52116002)(6506007)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FFI9RHIgiszmdIKNS+eDynFGNy1qlczwKn6KxOEziy03laKiiiMrtpKoyGK1?=
 =?us-ascii?Q?mVaUAD4vJJhugo8SULtC7GqUjYtymzLxAs8CBEH1oCd2SbUPHYS/GZZCBWc1?=
 =?us-ascii?Q?PGZFcXrLjBvwrPirLjkUfjL3V3IPzTLQ2teIN/MR2UVjEdm9DALpiCkrmyJw?=
 =?us-ascii?Q?mnzDZDyG1j75mPuWca0/PIue7tRwWm3iAYfEqVIQls4y8Hkej9sWzWwDme6C?=
 =?us-ascii?Q?/zblK6SF5yrh8jLMN4dzwW1OsGJGNUPHu1r1Rr+F8p0/oRfMu3GoBYn9mKf3?=
 =?us-ascii?Q?+UAT5oHTUEKiNRXEPAJM34+bEWawPCWz2rB++FkGwZI/6WELqk8Jekco6OXq?=
 =?us-ascii?Q?NYCaJtf2MDaa0JQTi/qZjOWlUio9TsaQZ2CFbYI1QUs2ulXaDPrcg+sYZitU?=
 =?us-ascii?Q?tzK4r4mB2v2l+BMG+Ndo3sErdzeK8aTTeP/1iNWlyk5wYclADIIbBoqO/Y7a?=
 =?us-ascii?Q?Pu+0HqdC9kmRGuOMtk+8V4eKG5m3Wp8HoYhG3Vj+sJ4ACOR/PDgDaIZhEQO5?=
 =?us-ascii?Q?U/4i5apZ0Wqvh+ci1z4AUfY0fMRUbYkZOWcZWT3z5VXvDamGh4qEK9xNJ7WA?=
 =?us-ascii?Q?5Btcng+KucR7yHoinMTWWBifM3qv9YKiFRcZEhl452w9crptKYFVSQHM463z?=
 =?us-ascii?Q?hdZbeax5K90oCY4tM5Jmtyg6mGukBMG6REkNZywbYDypTCWSMNJLGEc6BraL?=
 =?us-ascii?Q?Mdpk4wsJJ1mZzpPevOmBUBcB+fcLcQ3fBBfBTARo15JNxmA0SicUFfvVXIpT?=
 =?us-ascii?Q?heW6G3zwgijp+27nzi9wHI8DSTJtQB+Vm17Bb0F4O+v1FI5Rhfigq9hzur4Z?=
 =?us-ascii?Q?SpGuct120P7JHMUIIADD0QJYgCHsTi8RoxIm3Pz66HbXn+ancERDQ2G1cayj?=
 =?us-ascii?Q?GFDq8Y+q4a13F18VvLv+DXzVGe8IkD8DjOiMX/ay9mSPTRJKfKJT2t7zbek8?=
 =?us-ascii?Q?I9h/2yt4wJMeJgSOs0fZh4EDmxHA7zaQLv2yf0furchDwl4zkqUW2QSNEoIH?=
 =?us-ascii?Q?LQCWIb2D/fHDbdW2I7Vkmij2QupHK7jJA/uXN6LzsPHIFJtW8k1p9b6WVQPv?=
 =?us-ascii?Q?yQ3/WJLLzKh8znixHSFEHxIgev/He5xpEuNuAzGCLrvL62LFBUt+cOOq/kEc?=
 =?us-ascii?Q?aeI8FFkFOriK+k/1iQToiisWpeQiCFRuMts67U+kQEcLcMqsTbSso7a8Q/1j?=
 =?us-ascii?Q?7XKIOvFLXbBi62CsXeaJ4nw9ozvEPXMFsiT4hrXxa8jMBpUr2PykRoXVxp1Y?=
 =?us-ascii?Q?GuB3ImGBjBObX3kwdlv+jmu+p6Z/IEfODsAYhyZ3H2KvMkdFXf7SbxidoILM?=
 =?us-ascii?Q?IVv9YmMAwcbmmt9If+fxj0hjjO1Qeohs5mrv+AZjyQgZWSRhZA0n4Mi/0ZSJ?=
 =?us-ascii?Q?c5RAvBspKe2fXhCNOi0EkSpXe9YStipP+mt6j7rEHSOis3HL3qpIYglSvgEN?=
 =?us-ascii?Q?lxz7kygevka0oirCUwIP6VXSb2p54P41sCbhjAJ0qCp+UJN+GcBc1YYML+Uh?=
 =?us-ascii?Q?Peda7fCq8AGVBHabtK6vhNXXBhOTBB3kNHvnsYXPmSKPd55YwYHW69/ssddS?=
 =?us-ascii?Q?q0aTRkNryHSOXZmkxmIgGXs71kYE8DWcwhfGawXqIybFrXvrm1d9LCNmUWXZ?=
 =?us-ascii?Q?onhOFJG42MAQTBkyiHNglbm/VsaEmhLp6z57T+/U3TJwp7bNgCjNeN4DABkE?=
 =?us-ascii?Q?Zo34UmvZ5n9ORJL6Vq4a4DXIZ4PM2FaaNS74XYQlvUZYIGeUGV3iBpNvU+qi?=
 =?us-ascii?Q?vmQ+rkxuG3UxU9YUy4VD/rVy0CxMZLw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ea06fee-ff18-437f-feca-08da1bc41ee5
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 14:03:57.4463
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PheoEyzTwPH9bTlY7JBmWHpiv9+SBqkbebMXeagnBmy9j/UAn6z5ryTeBEjTYP1zRY1OnrnLcVpwRXy2UmDCTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR10MB2451
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-11_05:2022-04-11,2022-04-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204110078
X-Proofpoint-ORIG-GUID: 7cFexXTwCO8vx_DydADa-UOt1A2_M_gV
X-Proofpoint-GUID: 7cFexXTwCO8vx_DydADa-UOt1A2_M_gV
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 11 Apr 2022 at 06:01, Dave Chinner wrote:
> 5.18 w/ std=gnu11 compiled with gcc-5 wants flags stored in unsigned
> fields to be unsigned.
>
> We also pass the fields to log to xfs_btree_offsets() as a uint32_t
> all cases now. I have no idea why we made that parameter a int64_t
> in the first place, but while we are fixing this up change it to
> a uint32_t field, too.
>

Looks good.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_btree.c | 10 +++++-----
>  fs/xfs/libxfs/xfs_btree.h | 26 +++++++++++++-------------
>  2 files changed, 18 insertions(+), 18 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index c1500b238520..a8c79e760d8a 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -751,20 +751,20 @@ xfs_btree_lastrec(
>   */
>  void
>  xfs_btree_offsets(
> -	int64_t		fields,		/* bitmask of fields */
> +	uint32_t	fields,		/* bitmask of fields */
>  	const short	*offsets,	/* table of field offsets */
>  	int		nbits,		/* number of bits to inspect */
>  	int		*first,		/* output: first byte offset */
>  	int		*last)		/* output: last byte offset */
>  {
>  	int		i;		/* current bit number */
> -	int64_t		imask;		/* mask for current bit number */
> +	uint32_t	imask;		/* mask for current bit number */
>  
>  	ASSERT(fields != 0);
>  	/*
>  	 * Find the lowest bit, so the first byte offset.
>  	 */
> -	for (i = 0, imask = 1LL; ; i++, imask <<= 1) {
> +	for (i = 0, imask = 1u; ; i++, imask <<= 1) {
>  		if (imask & fields) {
>  			*first = offsets[i];
>  			break;
> @@ -773,7 +773,7 @@ xfs_btree_offsets(
>  	/*
>  	 * Find the highest bit, so the last byte offset.
>  	 */
> -	for (i = nbits - 1, imask = 1LL << i; ; i--, imask >>= 1) {
> +	for (i = nbits - 1, imask = 1u << i; ; i--, imask >>= 1) {
>  		if (imask & fields) {
>  			*last = offsets[i + 1] - 1;
>  			break;
> @@ -1456,7 +1456,7 @@ void
>  xfs_btree_log_block(
>  	struct xfs_btree_cur	*cur,	/* btree cursor */
>  	struct xfs_buf		*bp,	/* buffer containing btree block */
> -	int			fields)	/* mask of fields: XFS_BB_... */
> +	uint32_t		fields)	/* mask of fields: XFS_BB_... */
>  {
>  	int			first;	/* first byte offset logged */
>  	int			last;	/* last byte offset logged */
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index 22d9f411fde6..eef27858a013 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -68,19 +68,19 @@ uint32_t xfs_btree_magic(int crc, xfs_btnum_t btnum);
>  /*
>   * For logging record fields.
>   */
> -#define	XFS_BB_MAGIC		(1 << 0)
> -#define	XFS_BB_LEVEL		(1 << 1)
> -#define	XFS_BB_NUMRECS		(1 << 2)
> -#define	XFS_BB_LEFTSIB		(1 << 3)
> -#define	XFS_BB_RIGHTSIB		(1 << 4)
> -#define	XFS_BB_BLKNO		(1 << 5)
> -#define	XFS_BB_LSN		(1 << 6)
> -#define	XFS_BB_UUID		(1 << 7)
> -#define	XFS_BB_OWNER		(1 << 8)
> +#define	XFS_BB_MAGIC		(1u << 0)
> +#define	XFS_BB_LEVEL		(1u << 1)
> +#define	XFS_BB_NUMRECS		(1u << 2)
> +#define	XFS_BB_LEFTSIB		(1u << 3)
> +#define	XFS_BB_RIGHTSIB		(1u << 4)
> +#define	XFS_BB_BLKNO		(1u << 5)
> +#define	XFS_BB_LSN		(1u << 6)
> +#define	XFS_BB_UUID		(1u << 7)
> +#define	XFS_BB_OWNER		(1u << 8)
>  #define	XFS_BB_NUM_BITS		5
> -#define	XFS_BB_ALL_BITS		((1 << XFS_BB_NUM_BITS) - 1)
> +#define	XFS_BB_ALL_BITS		((1u << XFS_BB_NUM_BITS) - 1)
>  #define	XFS_BB_NUM_BITS_CRC	9
> -#define	XFS_BB_ALL_BITS_CRC	((1 << XFS_BB_NUM_BITS_CRC) - 1)
> +#define	XFS_BB_ALL_BITS_CRC	((1u << XFS_BB_NUM_BITS_CRC) - 1)
>  
>  /*
>   * Generic stats interface
> @@ -345,7 +345,7 @@ xfs_btree_dup_cursor(
>   */
>  void
>  xfs_btree_offsets(
> -	int64_t			fields,	/* bitmask of fields */
> +	uint32_t		fields,	/* bitmask of fields */
>  	const short		*offsets,/* table of field offsets */
>  	int			nbits,	/* number of bits to inspect */
>  	int			*first,	/* output: first byte offset */
> @@ -435,7 +435,7 @@ bool xfs_btree_sblock_verify_crc(struct xfs_buf *);
>  /*
>   * Internal btree helpers also used by xfs_bmap.c.
>   */
> -void xfs_btree_log_block(struct xfs_btree_cur *, struct xfs_buf *, int);
> +void xfs_btree_log_block(struct xfs_btree_cur *, struct xfs_buf *, uint32_t);
>  void xfs_btree_log_recs(struct xfs_btree_cur *, struct xfs_buf *, int, int);
>  
>  /*


-- 
chandan
