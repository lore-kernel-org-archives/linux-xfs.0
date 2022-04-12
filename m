Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ABC8C43217
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Apr 2022 10:01:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351606AbiDLKBF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Apr 2022 06:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376298AbiDLHnz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Apr 2022 03:43:55 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E699945529
        for <linux-xfs@vger.kernel.org>; Tue, 12 Apr 2022 00:26:52 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23C5iwcT001710;
        Tue, 12 Apr 2022 07:26:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=OzmhOdNpd4g4+/QaoeL4ZIcQfPHC9U2gfjTnBA1ap7A=;
 b=BR/xW6L6nOAiJgsJH5GK+6LDBwg8TUw4dg063Be30wLo90BMmCvRkOuH+pEFggkKwiz0
 QfjbKkGVtv5xKp8tUn/E4Y/kMWTo1nasPYHco6pViPvG/8IzKL4AQb6L3jSEN4rz61wY
 yIIyGLv2rbO0K9D/EfPUGKUkrm66e2+k+6NDpbTOuEEQRak6hQskBpCfQtdSWVkJuMbb
 LsIwDnosiPMYsUwAChgctX7EGojm+kRrzaTS5/61InbWyvy7w4qF6xSgXnddBFJerH9D
 l7QpnnnE+3qNpppsps08gdrUVrLuLblZm2WjVHYc6otAIEeCU2FPfRhfISRuaedsdXLw Dw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0x2dvff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 07:26:51 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23C77HaF002971;
        Tue, 12 Apr 2022 07:26:51 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2045.outbound.protection.outlook.com [104.47.73.45])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fb0k26nad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 07:26:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bm4yv7keN4zQyVTHh38IVUwZUUlIDXnh/DUP3UfxalBn6mpk851sk8HJdnaEXCysCtKwtpKfr90KVHQ21GBSnVz9L4kwDGgOEzqUSlk0+GhBZqrpXqbPPwvxPIrVkTumilaClEFDPGrjJIbwPmsRLdEF1j9+PmW9yDfqCIFJy+ihNFLGn6KjB2SyppA+scwbl4zGf0FXCABig41VhGN6w49z2VpcKIwot30xG7cP5YmFfqF/LtEPP5Ss3u/+QMyMF4d7qrh+6vKHT9f/9oks3U56hJxGk/iKjc6WXphQhB+wj0Z7nrQTXrPvtwo7n8HBUTvTMocEFboAYgvxMoWlsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OzmhOdNpd4g4+/QaoeL4ZIcQfPHC9U2gfjTnBA1ap7A=;
 b=QJYm3IMxNwQKZ+/9VL3noUWZueMjsJV+/j/VrWCfRY+/Zl4zv4kHtAlE0RKE/15pGkrtdiKVdHpq88xHfkMbFSWmhlv/+cvPkxvNQoWMivYcUd7GsVT5a8ottQwh3H07Ym3VzWAMYxISvX4uzZCx06TkvIKauoVylOMff9DX8M3FCuQuT9M7www+Up6TkAkkqXGWV+RKrcp8qZex3biJ4BlP3YdFQ8TgxPo062//PQJzihk7spJ2CPFj8lNZKoY6ygBBh5m1GSkHn6ROeKownTx4wbMmzEThXigy8lR4iHhS1pI0yCYZ3jEqoZS8MwDrh5Eb35y4SoHIY1czfWQJdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OzmhOdNpd4g4+/QaoeL4ZIcQfPHC9U2gfjTnBA1ap7A=;
 b=YZjvTr3H3HaWw3/NNPpo0uTG0PYQ5Yck/my9Kj/iB0hYH/E+lRaAtcbqvEa0tS+AebRvRoLD5kFc2yO9RgftBvF8Pj6MyJYriGtMaBSlJyco+TcLKGIHWPzTtxnXGXtttgjWddrN6Ypxga7yvEDVPYsZMajcS7Uu5KsHvfxUbMU=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BYAPR10MB3464.namprd10.prod.outlook.com (2603:10b6:a03:126::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 07:26:49 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::c95c:3552:3b30:30ee]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::c95c:3552:3b30:30ee%6]) with mapi id 15.20.5144.030; Tue, 12 Apr 2022
 07:26:49 +0000
References: <20220411003147.2104423-1-david@fromorbit.com>
 <20220411003147.2104423-15-david@fromorbit.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/17] xfs: convert ptag flags to unsigned.
In-reply-to: <20220411003147.2104423-15-david@fromorbit.com>
Message-ID: <87sfqizrrh.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Tue, 12 Apr 2022 12:56:42 +0530
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0005.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::23) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a331cd8d-8c01-41a7-6d9e-08da1c55ce82
X-MS-TrafficTypeDiagnostic: BYAPR10MB3464:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB3464685E1FE7D22003034054F6ED9@BYAPR10MB3464.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1g/Tq8t8K5WQlmjsl/vN7Uiv9uuOXf1xeZ5DvMSyn8VoL+Fq2c1h7AD3FKQWXdumzuLq00JCaAHAhH7zDNghsewJNZAbUs3Dk7AjxhyAJ+kreOS9D7gAtbPcSYHVnt8hK+gDmIaipmhX/F2X4HZRSsOUNudHTW78YmwQT71Offa1yZZUcw9voijqQX2bTnG6T7JpSKBDYWw+jGA+mIsB7eMdACfQFnw+ss1qXaJxnMgGiG0j0AcSttj7ZDO+W9Q5MIvvXyH1SrftaztHQwW1MSy3I+8Wi9iuxKL5lnpS/SUF4CAFnaffiFN4d857gB6ypc0PVeMBoaz79ltif0OzFBaIq4QzcvrI1ohB+O6eFx+2NeGZvgYCxMshcvduGW3qvOaBFinGiSVE7D5t4P1yZV2KBw6cYYgQPSml2JdGIzhwQFxx07czGQ+IWZhk3RP0+k7BbUouU7gxE9o5sAjo6hk5nj4RodcbVTVAMo8BgkHl+2TS2nx7k8CV5s66p7OwhcnW+eFEdYSImta5IGgUcIH5tOCBhPsGKgdEk4gMBoGnzdn9qMN7cKUSjXdy8ksE2rO4ZyI00cz+jc37PswC/Y8zU0TVkQPSzynKxZ+IjoVUddZKZi3l7D7r9Zl4U9WUEyg52qTDwKJzctLEK+GHVoho5MwXFjGu/2EoSA7UF3dWEkLyRDo9FSnkFOJRu3aWxcTdfmqVoJ/z218m0Cremw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(66946007)(53546011)(4326008)(5660300002)(2906002)(86362001)(33716001)(8936002)(38350700002)(38100700002)(6666004)(66556008)(6506007)(6512007)(26005)(186003)(83380400001)(8676002)(52116002)(9686003)(316002)(66476007)(6916009)(6486002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k/XGtjv9z9zQc5NMGfOg2mLxaZZzVJdCLJEg4GStnhH7dwSkSXO2/okgu2OR?=
 =?us-ascii?Q?wvYA3zJ/Si9KoiGOPQqFSAVfm27Z8uAzDRFscW+legkA1pD5XzSaZ6iCIG1s?=
 =?us-ascii?Q?uQpimWTRHFEt4lYQV8UAYv2Jw9lGPoT6kCwsfu/OY76fLBxMRCy75YXJqiyC?=
 =?us-ascii?Q?xkJxNKu2JURcXYNx9CvSkc1GP+uMPtRoCLYoxgzGuIyEtIWNdSUVJmDwrD7T?=
 =?us-ascii?Q?I7AZyNlV8QgTvXs4wBFm8AvFrMPH/QfnDyF7QNobtA9P2OsvTLb3xjRZJZgs?=
 =?us-ascii?Q?1BQzniOEXOUexsmUkhLdCIZjUp/appg1NnR49zoGwlVPAOErWfdYpJPeq0KS?=
 =?us-ascii?Q?TOiOjHsrpHNX39gdoWgsbIhaFX1oGXvhC1/i/kYElC5l0R0llJqHXzY0CcBx?=
 =?us-ascii?Q?IfEacIsGDSf073dpIBixd7h2nyNnJCZ2A/LgrbVj0bglTUAdOkjoqMcoTZf0?=
 =?us-ascii?Q?eAkFXOtnPA2Bj3nO531b3dNq1xLOrGtaQWrUsTAy9sSNOxPqIFjmhgcLmt0F?=
 =?us-ascii?Q?rB/3uV6JmdVJYivUn/XFn2hcBr1VKPJ5PAL8adBRLUcRvI7nRjUvjuiwrgdd?=
 =?us-ascii?Q?EjuwYBweCcSwd/XjwejsBSYOvUiGmkXCfDQlniDyQZsV/HMLZPwdyL444V7l?=
 =?us-ascii?Q?bRjAr8RcCP4twnv4RhJr2QVnVgnPpiQtccGukK6sKo3sLNFhK5KtDgIj4M6t?=
 =?us-ascii?Q?bOcgSrJhTdu7/Zj6lCo9lgXt9OgnhOPNd6/XIunPf5lWwTe5xxhVw2fHnr8h?=
 =?us-ascii?Q?61C9mkfDZdmBMCT88wpu7eI3sv3LyuMPtRRBpOkDzg/EO44Jj18sqijSjvaL?=
 =?us-ascii?Q?826MJWDjxHbM7zbfWmPi2mo+CNBd0g41QDooK+ZLglnWR5Id7w7zuIsgkLF8?=
 =?us-ascii?Q?p06dNaTPF1L0oOwWn40kaVvl4ET2t1yjFQyzux1XfLETUr+y95dIIWNsSnoz?=
 =?us-ascii?Q?K7suuWXdH3qZhcXUWZIRUaKgVhHa1D5kqND5rmEvt71+fFz9xVPUKlYlTtWP?=
 =?us-ascii?Q?ijrifYwaLYKsXhN8Gzsr4mPyuvQkJzVriDJibEv/1F6ymPXUtE95pBZQNcBj?=
 =?us-ascii?Q?MyvJa9vcLhw0R3FcGF2tN1K0F71yI6y1wjvjnnr+FS1iM8TMXJQiol0AVGKy?=
 =?us-ascii?Q?5+Yw2XCCOz1mMJmMfU+1zb03kAsZuR4aFrEnr7aFMWEZ5Tybuo8f3gIkpZkW?=
 =?us-ascii?Q?39+sx3owZPhJyt7nyGqz29KgZmWPoPOOBTTb8XI/MmIWmwZmW1TKb5eLamgc?=
 =?us-ascii?Q?gAIcxewwFxecmU4TEeRCckzhezXWfXzJruYGj/uq3CkOySmTE+fGJgOGllYD?=
 =?us-ascii?Q?JEB3GaSwSvQo69/bpl2fvjgxPCPpJF2qbYI6qEfrBlV791j8Ap/65AlXk145?=
 =?us-ascii?Q?9+ULvI9/e137Q3TXIWJPrhjI2Uvh0ghxEG/A2L9sq/mIFh9ugaRzS+Zw02kV?=
 =?us-ascii?Q?Is85lcpjX76lm4s8Rj0UVEB9d1OgFC+/2K2NCL58qCnN5ChJ3f1GMpxJHqpa?=
 =?us-ascii?Q?ALu+uJ0AW6vKiuk9z836BQiJL103qcW6PbPLihrxaqaMwmoNEGNGVpWmlmWq?=
 =?us-ascii?Q?Ze0F/9wwFS0SylyRayXO64kWPSICpqq7T9D+tVTnulHOuLCHE4rIYMpknQbW?=
 =?us-ascii?Q?NdKmSIzezw9wsBDd9hul7z/NeXLE+Ks4ORYVNMtZnOgSnj5CQI2b4FPhKVad?=
 =?us-ascii?Q?VxY8U3vb3hD3R48ag6IC68YSpLGOcXMcDMrQrVKQveHut5tN+78Z+G6wyTLL?=
 =?us-ascii?Q?QR3YKh4i+hC+GcGruZgseWzOyhcBgV4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a331cd8d-8c01-41a7-6d9e-08da1c55ce82
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 07:26:49.1609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D7zGbocSmp6ycQ0CUbwRi6XctOd1h+2gknuu45eR3T/UiI6/4/Na6avcEPs2NVvCDm3QcLqm0UO0f/GQNFwZbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3464
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-12_02:2022-04-11,2022-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 mlxscore=0
 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204120034
X-Proofpoint-ORIG-GUID: N8mvYTKA0OB0tc6TnJIui6bqwBa4hOpt
X-Proofpoint-GUID: N8mvYTKA0OB0tc6TnJIui6bqwBa4hOpt
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
>  fs/xfs/xfs_error.h   | 20 ++++++++++----------
>  fs/xfs/xfs_message.c |  2 +-
>  fs/xfs/xfs_message.h |  3 ++-
>  3 files changed, 13 insertions(+), 12 deletions(-)
>
> diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
> index 5735d5ea87ee..5191e9145e55 100644
> --- a/fs/xfs/xfs_error.h
> +++ b/fs/xfs/xfs_error.h
> @@ -64,16 +64,16 @@ extern int xfs_errortag_clearall(struct xfs_mount *mp);
>   * XFS panic tags -- allow a call to xfs_alert_tag() be turned into
>   *			a panic by setting xfs_panic_mask in a sysctl.
>   */
> -#define		XFS_NO_PTAG			0
> -#define		XFS_PTAG_IFLUSH			0x00000001
> -#define		XFS_PTAG_LOGRES			0x00000002
> -#define		XFS_PTAG_AILDELETE		0x00000004
> -#define		XFS_PTAG_ERROR_REPORT		0x00000008
> -#define		XFS_PTAG_SHUTDOWN_CORRUPT	0x00000010
> -#define		XFS_PTAG_SHUTDOWN_IOERROR	0x00000020
> -#define		XFS_PTAG_SHUTDOWN_LOGERROR	0x00000040
> -#define		XFS_PTAG_FSBLOCK_ZERO		0x00000080
> -#define		XFS_PTAG_VERIFIER_ERROR		0x00000100
> +#define		XFS_NO_PTAG			0u
> +#define		XFS_PTAG_IFLUSH			(1u << 0)
> +#define		XFS_PTAG_LOGRES			(1u << 1)
> +#define		XFS_PTAG_AILDELETE		(1u << 2)
> +#define		XFS_PTAG_ERROR_REPORT		(1u << 3)
> +#define		XFS_PTAG_SHUTDOWN_CORRUPT	(1u << 4)
> +#define		XFS_PTAG_SHUTDOWN_IOERROR	(1u << 5)
> +#define		XFS_PTAG_SHUTDOWN_LOGERROR	(1u << 6)
> +#define		XFS_PTAG_FSBLOCK_ZERO		(1u << 7)
> +#define		XFS_PTAG_VERIFIER_ERROR		(1u << 8)
>  
>  #define XFS_PTAG_STRINGS \
>  	{ XFS_NO_PTAG,			"none" }, \
> diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
> index bc66d95c8d4c..c5084dce75cd 100644
> --- a/fs/xfs/xfs_message.c
> +++ b/fs/xfs/xfs_message.c
> @@ -62,7 +62,7 @@ define_xfs_printk_level(xfs_debug, KERN_DEBUG);
>  void
>  xfs_alert_tag(
>  	const struct xfs_mount	*mp,
> -	int			panic_tag,
> +	uint32_t		panic_tag,
>  	const char		*fmt, ...)
>  {
>  	struct va_format	vaf;
> diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
> index bb9860ec9a93..dee98e9ccc3d 100644
> --- a/fs/xfs/xfs_message.h
> +++ b/fs/xfs/xfs_message.h
> @@ -11,7 +11,8 @@ void xfs_emerg(const struct xfs_mount *mp, const char *fmt, ...);
>  extern __printf(2, 3)
>  void xfs_alert(const struct xfs_mount *mp, const char *fmt, ...);
>  extern __printf(3, 4)
> -void xfs_alert_tag(const struct xfs_mount *mp, int tag, const char *fmt, ...);
> +void xfs_alert_tag(const struct xfs_mount *mp, uint32_t tag,
> +		const char *fmt, ...);
>  extern __printf(2, 3)
>  void xfs_crit(const struct xfs_mount *mp, const char *fmt, ...);
>  extern __printf(2, 3)


-- 
chandan
