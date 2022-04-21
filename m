Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B15FAC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Apr 2022 09:16:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387430AbiDUJT1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Apr 2022 05:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387473AbiDUJTI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Apr 2022 05:19:08 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F7427CEE
        for <linux-xfs@vger.kernel.org>; Thu, 21 Apr 2022 02:16:11 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23L96SIq019815;
        Thu, 21 Apr 2022 09:16:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Z06xeS3IKmDZrzPGvynHKqXYpOCds76+rr5+n/ddLP8=;
 b=Xegyo7QiWZP+PStnPnaTNGm//gqlC/sqHTjwX5OnCO3/kTiwCRQCdG6qMU3wj5Iu1H6q
 b2nyIkNXGvyEh85hT2OKD69d5k2UBHgA/IxA+TwsMsCpBZjSH0AE4QWCVbI7REn91ZEj
 HBEWKgFspRjnyTCB/h14v4OEpiGKbArCem4imP6jUctXlhDIn5+vH5VgN7QuK7lZX/BU
 vlpFANCpOKKYVl7FLNVhfjw2aXUBJw4n5saKxAut3JzZjhXbAJFjx9wcLsVTTDgsMZph
 13NRsDNcz5CcvXphms4u/wq8m0qHa1NcKtLwBC7SF+RwMveV252/lvxuKbHceTkapNIR Pw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffmd1bgyk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 09:16:03 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23L9Bo3J012885;
        Thu, 21 Apr 2022 09:16:03 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2174.outbound.protection.outlook.com [104.47.73.174])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ffm8a2ygd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 09:16:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GQgUmLT1gAubhaN+4h1/rfDtQnPa3XOIEpYUlN0yYvq6N1+hhRVZAikVHNV6kFFOYQVUEyFy8hiieQfpc13rRWvUtcp82B0L5ivq/c+Tlhz+/uob9jQQNe0Acou5A4sIs0OStjXG4T/g60xLdBJe8egw3nhxiZutjG0R03dn++1mNBFMbYjTV6DezXjoz3UDDrJ0AMOxh5uuPEiluAWWHNGShdTme690c8q7XivD1Y4xRaFRa1jJJEdFJqH1To2/Brbit5koO8PViU91eVoRbZ9583625H93ktGvhCaQQxpikq6q9ZxZ1t3oAfYWVtjH4uMHHNUyXtlN9F5FmYUpJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z06xeS3IKmDZrzPGvynHKqXYpOCds76+rr5+n/ddLP8=;
 b=KH6/45INCgW953FIaVGWAWujJgtxmyupIYmXX16JNlZIFcMI/ATpoxsTJKZZ84gSdCkINaXK5eE8Ab3yLzakVHz39LRP756cwLUu6e5ytmlhGV5wlZHLJwHIDHIc13Xy/ajSq8v1DfL4h3Mp1JOcVFXD4N/yOr/caEnfIQyLSOizAn/Phh3ElfTQq5qxNnH9ydkG3CJgULpA9QsGMsCS9x8T72sxdFfSTjVwoZSB7HIxlRzttyVT5hRMy/9KmfGEyvxq4HqrYapZ/T6Fu4y5U14kiuf/kX9e1p18QanbuRGkWRbnl/B3kyFkVHkLIYuwl7D+OYu0b22i38GomaUVtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z06xeS3IKmDZrzPGvynHKqXYpOCds76+rr5+n/ddLP8=;
 b=QsliAXwu+DY7oR3YBxwdSfdR+e+ijzoAdKdIIxq0QJsuaMWW2e54Zy2KIYQqDNqvc/U1NyK/YuDoVAw5dtbb62mfUOWKDZPoDzUHK40MYPSQnhe09eXmW27oHl+qS2sv9h2W/ZsACcxzx61g8zFpcLnwqdtv9LE6ento0iSs2/8=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by CY4PR10MB1815.namprd10.prod.outlook.com (2603:10b6:903:125::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 21 Apr
 2022 09:16:00 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::9874:fcc8:51fa:8fb5]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::9874:fcc8:51fa:8fb5%5]) with mapi id 15.20.5186.015; Thu, 21 Apr 2022
 09:16:00 +0000
References: <20220411003147.2104423-1-david@fromorbit.com>
 <20220411003147.2104423-14-david@fromorbit.com>
 <87v8vezrrt.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20220412084305.GE1544202@dread.disaster.area>
 <20220421004437.GQ1544202@dread.disaster.area>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/17 v2] xfs: convert inode lock flags to unsigned.
In-reply-to: <20220421004437.GQ1544202@dread.disaster.area>
Message-ID: <87h76mer08.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Thu, 21 Apr 2022 14:45:51 +0530
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0020.apcprd02.prod.outlook.com
 (2603:1096:4:195::7) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1cb20331-2bc7-4d05-8b34-08da23778d36
X-MS-TrafficTypeDiagnostic: CY4PR10MB1815:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1815B54DE3BD0CD4F75DD2BBF6F49@CY4PR10MB1815.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S3xfqLIAmUyqXD05CSYYhedKjPIpecA3s3jwhkzpTI/qEN7UlCdqsTzGSJGBXGl+F5gqbP1zXwdYXsYhv2BkY4Q7TFw6eTtGPY8FKcAObzGSIIfezS1HQ9xXAFvkJAMIO6u3DgOI+0qxFYDANqYATtZ+K9gPi16YFMog8gD4Cl6oCsz7efTyesaG+vgiYDCP0KF8NsJh0SZZkzn2hzzp49jtbXEl2jF/62KZwqlEgDhHm60lOJqWlvOLFcBTbRE4MrnGYpgSq6DpDOg8Lj7EzQvcNo/qXCAAoSnQ4x0348LLJW8DL4euBFm5XBjDFLxYdk03tzU8dJckB51/SMcHGIWIXGwuVB4awA5at9zBA2MDbmIJbtAouY/XH9rHDETHesQ//RI8bOU729VU8t8yxKQEmIY8LYz3pdu571ND0HRv+P5M9onszwAO2gGxSmySr3pWQvCpaQiaq7DH0n1L/b9Bxei4Ond+2LfPDEpEbsztlFdX7/o7khCkcyCCayG6ZAIhb+w3YLm3Bd3RkliRLlAk4Lsiep3Jd3lT67bGtV2bOcf6IX5bOfSxTvCRuBebzbbP5PI1STgziRxBGQXsoRaJRSLG9X+Nk5sdZQ5ZDD8n39boICxvL5vfbvYu4y8dVAqSHJn/2ZQrxUib31VxTvyzAXKhYHJ5ORqvLu6NblM11Uq7CUV27gmUGgX6fpByaaDEgVAYvpDOU8fjmDk0iQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(8676002)(508600001)(6512007)(4326008)(66476007)(6916009)(2906002)(66556008)(26005)(83380400001)(316002)(38100700002)(38350700002)(53546011)(6506007)(8936002)(9686003)(33716001)(5660300002)(6486002)(186003)(66946007)(52116002)(6666004)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uNdcuvh6wKb7NqWdrZGZBVVQPzaNH2F641y1M9oFNx8j692+2M03/dCBT3C+?=
 =?us-ascii?Q?LdCLEj4tVfC2oJAhfz9ynQizq3I7Cib1+hR4aeVIXd4REA/7WHaVv+4e1+Go?=
 =?us-ascii?Q?8Jc5WBW8sPS3fwMcGQG/zLy/WZ1hcTmw5pKnVXcz10k91TckNM19PVD9jP5/?=
 =?us-ascii?Q?EZVwH5RivYiaQ2NqzQzvG9RJHiH9jPh4a0x5YMzZTWFC2h9A6YHZ9fBc6yz6?=
 =?us-ascii?Q?KCEKBk6HiY/ThHR+3KZL1Odj8xtNanOtlptmOe2gFagyhIucVheE1kyQ6HWC?=
 =?us-ascii?Q?DiMCwgUFoX827IOnd0I750xTd0RWxdvtJuZfKlwPcLGW3q3jF1N58sOlAS3p?=
 =?us-ascii?Q?BRQCn4VYMep/fYGa+3OXaTLn6pSOkWLjrH5uF+/5Sx4oVqIaSQChE3yxNpbx?=
 =?us-ascii?Q?kuKbMJ6BcxNNCsv/Lnzw6G7cNOE7OVZxoqUqEkWVUjE4NQmZ3bVLD/huOOZS?=
 =?us-ascii?Q?0QLWkdrYzs/hOeOaNgFek/B2tQv7uNmtTWPKqGxF3H2NkI1fXs+mj7EddEKe?=
 =?us-ascii?Q?O08xutCiZSMxZizgGEvF2K4wFFZIWW8CqdnF2glzRqnTV7MyCjHsIn7n9wrn?=
 =?us-ascii?Q?YTwfeI2kvtP5YATZ6DTTS89BXBVsVPNtWWArxXJCps14QzNiHpXqDKRtl892?=
 =?us-ascii?Q?KmABbQ+bGGW8uxgxVnItRAwWwcEhFrlSk35gNgYqhirXoCDScEIypHlR9CBD?=
 =?us-ascii?Q?kt3YMaYe9eWdCkFIxhEq/zBpSlZXc/OeOvbO7re+0+Z+5IeyMayIaq3gUNHS?=
 =?us-ascii?Q?T216QUh8GL5Urd29iERaQuPk1zBwNdkykF1az4F32XZGq9VKgwgA4h6JAAqs?=
 =?us-ascii?Q?xJ4JiO0KVPwqTV8jI+cNjvmtpltq1TMAfQd2IxnjtUtBWYrY8woCW6Y1z3Ez?=
 =?us-ascii?Q?eQ8kyRhtX/+8uUQMtdQK3OeOC3KksIvx7p1YSU1GTYO5SHwKDVtWoYSrlEQC?=
 =?us-ascii?Q?wqLjZT/8Exy/CXuX9Rt5S+VPlImNJsdLZN3WMcX+WvdB6A3rJrwgc59+QPmN?=
 =?us-ascii?Q?E0aLmbGpPESOhFmjGhqKtr+FrzhYw+0iFBsJTQmzE2OyISgK12vj7waf9EXp?=
 =?us-ascii?Q?rz2u/wGQ/VP5uLeU709pZZYPmCKWFPU7GljjClglPNSC5g8As4fZZY2jRgYU?=
 =?us-ascii?Q?FVXH4F3H4w5noNxt4VpF3crAi7il7e2ECWf/XU2UiCe6HaL0um0OjgsQSBdA?=
 =?us-ascii?Q?TCHH5K8MEm2I/oZN9VNhrOta77dhg5CYFAP1VFGm7A8nR996/+Q0s9nvV8JA?=
 =?us-ascii?Q?2OvgxGiBA6EADRB6tPbvLKW1eTUKwyo8LkQOEePXthaVfXngj8496akFaRDo?=
 =?us-ascii?Q?MqqAjaDKHRXH2d/1DbzhCm9K+5VX95jSRBRbBxAbq/nc8+3dEWZCel2D88Ss?=
 =?us-ascii?Q?J8ZLL15SU6evpTcVHFQVHwCrW7P+Cf4VF5OVMWIeOLzqtD+mW0e9ywV8ulLt?=
 =?us-ascii?Q?LVZ82Hnox1q0WwlLcUnzwx3SphV4wvgPzr2vQHOhakELK9w/pZaQZvhPWkWW?=
 =?us-ascii?Q?OBF/rN5OUMDUjYLu78OnoR+96x6VNdJS5m5UBLH4uwiqtnqs9sfcuC/SjguM?=
 =?us-ascii?Q?1g8DzjufZxyo47IOXsXnUi+VQKk6ykTesLbGLuvvtO32rnHHn1HoSCBIuayW?=
 =?us-ascii?Q?GBJ35Rev80JpLjM7jZQizy1iPd8YPZf+Y1nJ799EZVXOj2fkobAcil+SOdGx?=
 =?us-ascii?Q?YzlUx1SjgMq4lD4xwgce4qxdpWT+kCF3vFlNVaxfRqDPkzxrn+sIq3ktRTJl?=
 =?us-ascii?Q?VXKhs9GeMw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cb20331-2bc7-4d05-8b34-08da23778d36
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2022 09:16:00.5151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dP2pOGubRQjfXmjcX0e896beRp5p/hq2k+zBK2l67In5v805EDuNOLgdczi5I5hdMGiHXaAH3QA3BojARAHHtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1815
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-20_06:2022-04-20,2022-04-20 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204210051
X-Proofpoint-ORIG-GUID: JpcKawdl3BDWAzwAxOmx6LnV9hLeM1__
X-Proofpoint-GUID: JpcKawdl3BDWAzwAxOmx6LnV9hLeM1__
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 21 Apr 2022 at 06:14, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> 5.18 w/ std=gnu11 compiled with gcc-5 wants flags stored in unsigned
> fields to be unsigned.
>

Looks good.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
> V2:
> - convert the missed ILOCK bit values and masks to unsigned.
>
>  fs/xfs/xfs_file.c  | 12 ++++++------
>  fs/xfs/xfs_inode.c | 21 ++++++++++++---------
>  fs/xfs/xfs_inode.h | 24 ++++++++++++------------
>  3 files changed, 30 insertions(+), 27 deletions(-)
>
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 5bddb1e9e0b3..f3e878408747 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -310,7 +310,7 @@ STATIC ssize_t
>  xfs_file_write_checks(
>  	struct kiocb		*iocb,
>  	struct iov_iter		*from,
> -	int			*iolock)
> +	unsigned int		*iolock)
>  {
>  	struct file		*file = iocb->ki_filp;
>  	struct inode		*inode = file->f_mapping->host;
> @@ -513,7 +513,7 @@ xfs_file_dio_write_aligned(
>  	struct kiocb		*iocb,
>  	struct iov_iter		*from)
>  {
> -	int			iolock = XFS_IOLOCK_SHARED;
> +	unsigned int		iolock = XFS_IOLOCK_SHARED;
>  	ssize_t			ret;
>  
>  	ret = xfs_ilock_iocb(iocb, iolock);
> @@ -566,7 +566,7 @@ xfs_file_dio_write_unaligned(
>  {
>  	size_t			isize = i_size_read(VFS_I(ip));
>  	size_t			count = iov_iter_count(from);
> -	int			iolock = XFS_IOLOCK_SHARED;
> +	unsigned int		iolock = XFS_IOLOCK_SHARED;
>  	unsigned int		flags = IOMAP_DIO_OVERWRITE_ONLY;
>  	ssize_t			ret;
>  
> @@ -655,7 +655,7 @@ xfs_file_dax_write(
>  {
>  	struct inode		*inode = iocb->ki_filp->f_mapping->host;
>  	struct xfs_inode	*ip = XFS_I(inode);
> -	int			iolock = XFS_IOLOCK_EXCL;
> +	unsigned int		iolock = XFS_IOLOCK_EXCL;
>  	ssize_t			ret, error = 0;
>  	loff_t			pos;
>  
> @@ -700,7 +700,7 @@ xfs_file_buffered_write(
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	ssize_t			ret;
>  	bool			cleared_space = false;
> -	int			iolock;
> +	unsigned int		iolock;
>  
>  	if (iocb->ki_flags & IOCB_NOWAIT)
>  		return -EOPNOTSUPP;
> @@ -1181,7 +1181,7 @@ xfs_dir_open(
>  	struct file	*file)
>  {
>  	struct xfs_inode *ip = XFS_I(inode);
> -	int		mode;
> +	unsigned int	mode;
>  	int		error;
>  
>  	error = xfs_file_open(inode, file);
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 9de6205fe134..5ea460f62201 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -416,10 +416,12 @@ xfs_lockdep_subclass_ok(
>   * parent locking. Care must be taken to ensure we don't overrun the subclass
>   * storage fields in the class mask we build.
>   */
> -static inline int
> -xfs_lock_inumorder(int lock_mode, int subclass)
> +static inline uint
> +xfs_lock_inumorder(
> +	uint	lock_mode,
> +	uint	subclass)
>  {
> -	int	class = 0;
> +	uint	class = 0;
>  
>  	ASSERT(!(lock_mode & (XFS_ILOCK_PARENT | XFS_ILOCK_RTBITMAP |
>  			      XFS_ILOCK_RTSUM)));
> @@ -464,7 +466,10 @@ xfs_lock_inodes(
>  	int			inodes,
>  	uint			lock_mode)
>  {
> -	int			attempts = 0, i, j, try_lock;
> +	int			attempts = 0;
> +	uint			i;
> +	int			j;
> +	bool			try_lock;
>  	struct xfs_log_item	*lp;
>  
>  	/*
> @@ -489,9 +494,9 @@ xfs_lock_inodes(
>  	} else if (lock_mode & XFS_MMAPLOCK_EXCL)
>  		ASSERT(!(lock_mode & XFS_ILOCK_EXCL));
>  
> -	try_lock = 0;
> -	i = 0;
>  again:
> +	try_lock = false;
> +	i = 0;
>  	for (; i < inodes; i++) {
>  		ASSERT(ips[i]);
>  
> @@ -506,7 +511,7 @@ xfs_lock_inodes(
>  			for (j = (i - 1); j >= 0 && !try_lock; j--) {
>  				lp = &ips[j]->i_itemp->ili_item;
>  				if (lp && test_bit(XFS_LI_IN_AIL, &lp->li_flags))
> -					try_lock++;
> +					try_lock = true;
>  			}
>  		}
>  
> @@ -546,8 +551,6 @@ xfs_lock_inodes(
>  		if ((attempts % 5) == 0) {
>  			delay(1); /* Don't just spin the CPU */
>  		}
> -		i = 0;
> -		try_lock = 0;
>  		goto again;
>  	}
>  }
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 740ab13d1aa2..b67ab9f10cf9 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -278,12 +278,12 @@ static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
>   * Bit ranges:	1<<1  - 1<<16-1 -- iolock/ilock modes (bitfield)
>   *		1<<16 - 1<<32-1 -- lockdep annotation (integers)
>   */
> -#define	XFS_IOLOCK_EXCL		(1<<0)
> -#define	XFS_IOLOCK_SHARED	(1<<1)
> -#define	XFS_ILOCK_EXCL		(1<<2)
> -#define	XFS_ILOCK_SHARED	(1<<3)
> -#define	XFS_MMAPLOCK_EXCL	(1<<4)
> -#define	XFS_MMAPLOCK_SHARED	(1<<5)
> +#define	XFS_IOLOCK_EXCL		(1u << 0)
> +#define	XFS_IOLOCK_SHARED	(1u << 1)
> +#define	XFS_ILOCK_EXCL		(1u << 2)
> +#define	XFS_ILOCK_SHARED	(1u << 3)
> +#define	XFS_MMAPLOCK_EXCL	(1u << 4)
> +#define	XFS_MMAPLOCK_SHARED	(1u << 5)
>  
>  #define XFS_LOCK_MASK		(XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED \
>  				| XFS_ILOCK_EXCL | XFS_ILOCK_SHARED \
> @@ -350,19 +350,19 @@ static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
>   */
>  #define XFS_IOLOCK_SHIFT		16
>  #define XFS_IOLOCK_MAX_SUBCLASS		3
> -#define XFS_IOLOCK_DEP_MASK		0x000f0000
> +#define XFS_IOLOCK_DEP_MASK		0x000f0000u
>  
>  #define XFS_MMAPLOCK_SHIFT		20
>  #define XFS_MMAPLOCK_NUMORDER		0
>  #define XFS_MMAPLOCK_MAX_SUBCLASS	3
> -#define XFS_MMAPLOCK_DEP_MASK		0x00f00000
> +#define XFS_MMAPLOCK_DEP_MASK		0x00f00000u
>  
>  #define XFS_ILOCK_SHIFT			24
> -#define XFS_ILOCK_PARENT_VAL		5
> +#define XFS_ILOCK_PARENT_VAL		5u
>  #define XFS_ILOCK_MAX_SUBCLASS		(XFS_ILOCK_PARENT_VAL - 1)
> -#define XFS_ILOCK_RTBITMAP_VAL		6
> -#define XFS_ILOCK_RTSUM_VAL		7
> -#define XFS_ILOCK_DEP_MASK		0xff000000
> +#define XFS_ILOCK_RTBITMAP_VAL		6u
> +#define XFS_ILOCK_RTSUM_VAL		7u
> +#define XFS_ILOCK_DEP_MASK		0xff000000u
>  #define	XFS_ILOCK_PARENT		(XFS_ILOCK_PARENT_VAL << XFS_ILOCK_SHIFT)
>  #define	XFS_ILOCK_RTBITMAP		(XFS_ILOCK_RTBITMAP_VAL << XFS_ILOCK_SHIFT)
>  #define	XFS_ILOCK_RTSUM			(XFS_ILOCK_RTSUM_VAL << XFS_ILOCK_SHIFT)


-- 
chandan
