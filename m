Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D3EBC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 05:23:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244716AbiDKFZb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Apr 2022 01:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbiDKFZa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Apr 2022 01:25:30 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604AB5F87
        for <linux-xfs@vger.kernel.org>; Sun, 10 Apr 2022 22:23:17 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23B2A3mW028178;
        Mon, 11 Apr 2022 05:23:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=faUZ8m4HHkBm+dshJXrnG9L/QulqFsvwj/o+Kbf8zcE=;
 b=ygwz6RraV6vwKZUHj17Gf44EiN+SRxjEhQ7BkZ6ZOslHp2x+TP+u07pm2zND05b8TCrp
 HtCr5oJPcbqaRKSvSCy95jHstpxv88ZWktL/yXNm573/dYey7scr1B/N73qOqOgRWzZg
 7TS3lG+fzaRbQ5oQsoP/VKY4q5XlJbHktS/u8IiA5GxeEOveyi+i6/ROgSJgm43ePCit
 4R653Tutm1EFqIjj/g+O54WLfw7noewIfMZZa1lTcURiykzrx+E6yyFe0LG4rg8fCDjf
 XMzOeA0jqYF5EyZuBfBGYBdBM0gkGsJBZ9zvfQDZyD6bIMY0r6kRufj1psR4jL55tXWQ mA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb219tb0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 05:23:15 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23B5HIPJ020303;
        Mon, 11 Apr 2022 05:23:14 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fb0k1bsss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 05:23:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JLBEjG9BnDeXPwmzltCCxRF3gTccGmCEff0gypNuDz5pyzfYuC97a8evkjKJhSBwFEhvryJkcbz8VcRAmg/q1iQ9z2xlLXOiXpMMv5fFHEWtWhPKwyPJmuMeb2tIKFUHUkjbDjAeQrY9hVOwJvHhV1USkzjNpIi2HiTnD1MDVlwDzj7nzM5Ne2HfrJ42uEhyYaI59ZgCUqIGxCv0W7HfPUYwm1lCGfauuMXNStoRo11Fk/duNBUol3VlPShFknvNWDjRPYG4E4AmG6JwOnuwC+ia2CR+66y/9gKkYrYsputhoQq0jzXTz8W6mg/9uTICjo36qcajEGD+0L0P6WBFGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=faUZ8m4HHkBm+dshJXrnG9L/QulqFsvwj/o+Kbf8zcE=;
 b=KIMzEhmQx11S0+ZpC+RIB36FirEHm4+iOI1gdsu4E9BETcZlOZh7anIqnYRKYU1PYqCKPnhGnNg5+cqg29cYB54dcZZOCeTrspCZbJlADVPt2LetQAaWwvIAUqTHrPNIcJ+Jj7+NibAxtDTkKBEDT4UgjCX/mdJG+H8qkhdPRjZ8VWC4tgqPiuSmhnfT0IVMy8RjI+VToPZ0CtcN6D93chozqjG2L2qca0JN1j1jG9hacviOauUx5hvGowk8rckWYv8RPxUnGibfbAIKVtq2vJYFPesRzyrFBRy0VBM+X8HYDZVUMm4ItrZqAQMdaqto7yWSbEt3M65oUys8pLbM2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=faUZ8m4HHkBm+dshJXrnG9L/QulqFsvwj/o+Kbf8zcE=;
 b=EYVbuFSGjiPjzvep6nvHrboVh+i+HL+1C3rQfe5U8Tt4DlFuFAvpYGdht7ZSi7barVvjJFsI7dC0SMJZhBsnoRu99EBhlSnmXcxjdo33+ZMuU3gpynEAUalFoVO+TaCGZOLeKHzKQJfivd0sU/Tq3nwDiPrLF6fdGJsP3TdI4Uo=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BLAPR10MB4948.namprd10.prod.outlook.com (2603:10b6:208:307::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 05:23:11 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::4cac:3ab1:a828:34ca]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::4cac:3ab1:a828:34ca%4]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 05:23:11 +0000
Message-ID: <aa95f0d19f78a94e8bcdbcf76979253bf97f8bcb.camel@oracle.com>
Subject: Re: [PATCH 1/8] xfs: hide log iovec alignment constraints
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Sun, 10 Apr 2022 22:23:09 -0700
In-Reply-To: <20220314220631.3093283-2-david@fromorbit.com>
References: <20220314220631.3093283-1-david@fromorbit.com>
         <20220314220631.3093283-2-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH0PR07CA0033.namprd07.prod.outlook.com
 (2603:10b6:510:e::8) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0c1471c6-39d6-458c-9cad-08da1b7b5e93
X-MS-TrafficTypeDiagnostic: BLAPR10MB4948:EE_
X-Microsoft-Antispam-PRVS: <BLAPR10MB4948137D31406D1A8467C1F595EA9@BLAPR10MB4948.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9LMzL0D24QKvxsQYljayHzQI2NQuXgUk62NhTeYnIQnWho3iXKkvbur06Qseg7bXkNn1dGUnqhSpJ3LmiFRvLg5ITEexyfmaxHCkA0UB78g/xhlE9aHcBJUcdL+1KOJ2nATiOh1MNfYEdXdjGXpTV4N1ML/6VekRbgKODLl3CxBkaYvWK+0G1ImbBggthQpXoCOGCcLvbq0qhI1fshKLVSQB5nE+yMapBJV/qBPezvQ7F/3KZkLtXH75MBX94NHWgs/FBGW1IE4Jydocgce+kyKUHuFUhAEQuOYiC/O4ijcSLf+Ro2l6Pif/Nti9jG3gF1otMSgl+VPPRbIt9UlfrZd17sSMGmJa8mRKblUhzE9tElbEolNzfnrT6Ncil7ZFMCYRI6XYM0IVB/d26ZiAkGYBjJ3ulP47I4mr0h2OPGgwksiHKYddyMx5A54Pabh6i6y0eU7SBipYn7BfZK86aid8riSc6WPSefvDewIsqlKwoubWBrDt2VFlmbDWuZA0UKQGUtRiir5Ix2/LbVH5rcJxl0Hu6HUk8/YYJ/1GWwGUOS/QOABWKJdqdcLmfT8wXOXQZamF6dnYXrp6mknNkvvQ+H5PcNXH/xwEuyAiYMjz2Z7KrCKmzwm2FngS9psb543WcbBQ+Upzp36fK9SdrpBsPoXyuWyz1BbTbtFMmZG5hYcxHPuTP5yXiLUsGwzk9YXZyeQUtrfPxTw1JzuJww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(86362001)(38350700002)(38100700002)(2906002)(316002)(5660300002)(6512007)(66476007)(26005)(52116002)(6506007)(2616005)(186003)(36756003)(508600001)(6486002)(66556008)(66946007)(8676002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dXVrOW5iMmNRSWdTR0MvOEZIcmZFSnZBakFINGtNVW5iWDY2SkZucWlLS2FN?=
 =?utf-8?B?ckZsTWpVLzJIK3NxZDdrMnJNZ1ViR0k1VVVvRHp0ZjgzL0V3cGN6ZFYvdHZL?=
 =?utf-8?B?eWltUGZSak5xZ1hJVHQxRXJxSXFKTGMvd0RqMnNsakRZT2QzK2FUT0N4Mlkx?=
 =?utf-8?B?ZS9aeUt6Mm5PcjBBN0VvcmxNTlZWNXlsV1VpOVJrQ2NLYUVGL0hCNnZnNEpj?=
 =?utf-8?B?clkvR1pWQmlqc1lVWmRLNkNsdlBmWWV4Sk5YMnNYcVNsS0pyeURjK0Frbnht?=
 =?utf-8?B?ZXVvVXJRN1RhOFlZM2l0NytPMkRPbTExZzl5bmZiUkJ4RXNoU2kyUXl0aE40?=
 =?utf-8?B?aGdpdm1Mb2J6ZEtIVVpzbGY0ZjQ3bW8xTDM5RmthTkVRVkZFT2ozK25mcXVQ?=
 =?utf-8?B?UEowU3ZxZnM2UGVLYTExL0pLb2dEditYdXE2Ui9nRkR1d1NQaWJkbnFhUlpF?=
 =?utf-8?B?WVVob2lPZVF4WE4vRXN2VXYzRnF3ZkhNVTJPY3lkZ0FXNlZjL0IxbTJnSzA3?=
 =?utf-8?B?bWdXWU00MGJkakZJVUxIYU5mM3pSb1JQZUZpa3JuUnpYa25hbWNVMGdzM0d6?=
 =?utf-8?B?SHZqNGtTc2tHTTdYQXJqdk5KUnhibzhyOC9IYzZRZmUwclZDVG0xemZBWXJK?=
 =?utf-8?B?akJralRjR0lJZVE4SmZTd2VKMW1DblhpOFc5dHhwTlZXWmJTSUJ2d21vS3Ev?=
 =?utf-8?B?SWtMN2J3TkNjTTRNWjR1dmJzb0NNbG5ZSThWWFJuVUtUZkpHU080cHRPZjho?=
 =?utf-8?B?eDIzK0ZpRHA3MG8rd1BFZGRPYm9Cb1hCNHhQUzNjRWxIeElWZ1Q2QnpRbjZT?=
 =?utf-8?B?VG91OGNlc2U1SERnQ3lUVzNIQU42UkNEakdWSWJjeDBrYVc0UzVEOE0vYmZD?=
 =?utf-8?B?ZUROUm1DZUVYZ1VWNms0R1V4T3hhbUtYazhGQmY2YU5OeDRMbUlSY3dGd1NK?=
 =?utf-8?B?cjY2NG5acGZqc1dwZTg1Q0E5SU5SOVdmeVo2NHVxQWxDa3BaTTFGRGhQVU5x?=
 =?utf-8?B?UGFmUjEzUW1ndGJDeU50YzZockNPMloxV2xLWlZIb21kOFJNMWhLWXBFUnU4?=
 =?utf-8?B?bFVnYWpYRHpodW52RllqckdvdkszTUtFMnBNYTYvVHUrL204QmgvMlVOVnJ1?=
 =?utf-8?B?RjZGeGRDMFVoaThsM1FKZG96Z09QWUtDd0Y3TjNUMi9ZenF0K1JDTm1selFj?=
 =?utf-8?B?V0V1aFMvVXd3eDBXUkZlVHJ1dGhaeDhoTFJ4S0hPZXlYZUVtdzFXT3FIQ1M1?=
 =?utf-8?B?NlVLUis5WDVMdXNMR3NuVzAzRGNxSjhpTFluL3U1THo5Z1FQaWpXTm81Rm14?=
 =?utf-8?B?OE5ibUlaeGlsaExaQ2xtV1lLaGNHUzRBUm5aZzhDOC9od1lDNzd3TngxbkN3?=
 =?utf-8?B?UmlQdTRnMFBCS0NHZmFhWU9pYU5FQVl6NTRCZ3hma0p5RmxaTmEybjluUm1h?=
 =?utf-8?B?K0Vsc2VPV3g0MDFKeno2VFpiVzFoblVidnpuSkxrNEx1VXlDbUlzWXJaQ2FK?=
 =?utf-8?B?dmkrTlpXQ2lmQ3lnSkJEOGI1N0ZIWDZLcmFXVVQrSCtmMlgyWjRJK0M4L1JD?=
 =?utf-8?B?QzBkUmlCam4rb1BwUnRhT3B2eTdDOG9TYzNlNExsd2xvL2UvRnNPdkZ0Yisw?=
 =?utf-8?B?dWlqMm5yTCtzekZHMjJlVFNkdGYxQWQraWs1V1cxWlREZEZ4ZlJPWnpISXhC?=
 =?utf-8?B?cEtsVURZdEtDbXliM2g3dUdhMG5xckRqelArdy9HY2pKVS8yWi8rRmY0OFpt?=
 =?utf-8?B?cXhoZWtxaFdLN0QxSGVEaDVac3J2aGZoMVJKOEZKNnFFblAzeEU3ZERzU2Zl?=
 =?utf-8?B?aTZmMTFnV0daYnZ4enphNERuM0ZjTjdjbmNSSFFnMHU4SDhnVFJpNEN2bi9L?=
 =?utf-8?B?RDFycUpJVDFBOTFHWnRQd3B3SWI3U2xROG9uTGxrZC9ZSVRSc01sSGpMUVIv?=
 =?utf-8?B?MjNTNGdIdnZsMTkxdVRvVC9nVTc5VDlzSGFYL293Uk42UDNua3k5NFdwNXpj?=
 =?utf-8?B?bnpkdEQzTFFqTVE5bUFmZlV6NCtIL2FlL0pvVTJvV2tMUkxJMUpPdGNHVFZn?=
 =?utf-8?B?V3JETEhDdC8zenpZNXdNWDNJdUZ6bGpCdGtHK0VHTFJSQms1eHMwcktuSlVH?=
 =?utf-8?B?alhxNURCcHJtWEtBSVVmdE9zM3lBSkwzOGNMRnJHSnIyVEVIUzBra1c1MWg4?=
 =?utf-8?B?cEhzVDM2Q2xWNHU3TkhOVGtBOVp4UTNOY1Iycm1BTk1vaUhKOW9VaWNBdG0x?=
 =?utf-8?B?MnNXT0NyWUJac3BFMVhScGs1cklEZWQvYnZORGpmbmxPeTlUUkNKeTFDVG5j?=
 =?utf-8?B?Z0NUcTJoRTVKcU9rZWRqb0JVTDRDUEQranpVSjd3NkxKTis5SUM0M05EMWxF?=
 =?utf-8?Q?egvcJDSidrNjDaJQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c1471c6-39d6-458c-9cad-08da1b7b5e93
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 05:23:10.9412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LB/Na1qo3HXlND/IQKoe/4CGs5HI9QIPXBW32Me0pGKQb5Ts3oBuaMnAxe/5zUia5NPmf3Nws6EIEeePLrmt9oCj/SY7JedRHYBW65c3KIA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4948
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-11_01:2022-04-08,2022-04-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204110030
X-Proofpoint-GUID: dFHddObAGHOcTdM8_aoSw3NmnnIj-A2Z
X-Proofpoint-ORIG-GUID: dFHddObAGHOcTdM8_aoSw3NmnnIj-A2Z
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2022-03-15 at 09:06 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Callers currently have to round out the size of buffers to match the
> aligment constraints of log iovecs and xlog_write(). They should not
> need to know this detail, so introduce a new function to calculate
> the iovec length (for use in ->iop_size implementations). Also
> modify xlog_finish_iovec() to round up the length to the correct
> alignment so the callers don't need to do this, either.
> 
> Convert the only user - inode forks - of this alignment rounding to
> use the new interface.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_inode_fork.c  | 12 +++---------
>  fs/xfs/xfs_inode_item.c         | 25 +++++++------------------
>  fs/xfs/xfs_inode_item_recover.c |  4 ++--
>  fs/xfs/xfs_log.h                | 23 +++++++++++++++++++++++
>  4 files changed, 35 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c
> b/fs/xfs/libxfs/xfs_inode_fork.c
> index 9149f4f796fc..a46379f6c812 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -36,7 +36,7 @@ xfs_init_local_fork(
>  	int64_t			size)
>  {
>  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
> -	int			mem_size = size, real_size = 0;
> +	int			mem_size = size;
>  	bool			zero_terminate;
>  
>  	/*
> @@ -50,8 +50,7 @@ xfs_init_local_fork(
>  		mem_size++;
>  
>  	if (size) {
> -		real_size = roundup(mem_size, 4);
> -		ifp->if_u1.if_data = kmem_alloc(real_size, KM_NOFS);
> +		ifp->if_u1.if_data = kmem_alloc(mem_size, KM_NOFS);
>  		memcpy(ifp->if_u1.if_data, data, size);
>  		if (zero_terminate)
>  			ifp->if_u1.if_data[size] = '\0';
> @@ -497,12 +496,7 @@ xfs_idata_realloc(
>  		return;
>  	}
>  
> -	/*
> -	 * For inline data, the underlying buffer must be a multiple of
> 4 bytes
> -	 * in size so that it can be logged and stay on word
> boundaries.
> -	 * We enforce that here.
> -	 */
> -	ifp->if_u1.if_data = krealloc(ifp->if_u1.if_data,
> roundup(new_size, 4),
> +	ifp->if_u1.if_data = krealloc(ifp->if_u1.if_data, new_size,
>  				      GFP_NOFS | __GFP_NOFAIL);
>  	ifp->if_bytes = new_size;
>  }
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 90d8e591baf8..19dc3e37bb4d 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -70,7 +70,7 @@ xfs_inode_item_data_fork_size(
>  	case XFS_DINODE_FMT_LOCAL:
>  		if ((iip->ili_fields & XFS_ILOG_DDATA) &&
>  		    ip->i_df.if_bytes > 0) {
> -			*nbytes += roundup(ip->i_df.if_bytes, 4);
> +			*nbytes += xlog_calc_iovec_len(ip-
> >i_df.if_bytes);
>  			*nvecs += 1;
>  		}
>  		break;
> @@ -111,7 +111,7 @@ xfs_inode_item_attr_fork_size(
>  	case XFS_DINODE_FMT_LOCAL:
>  		if ((iip->ili_fields & XFS_ILOG_ADATA) &&
>  		    ip->i_afp->if_bytes > 0) {
> -			*nbytes += roundup(ip->i_afp->if_bytes, 4);
> +			*nbytes += xlog_calc_iovec_len(ip->i_afp-
> >if_bytes);
>  			*nvecs += 1;
>  		}
>  		break;
> @@ -203,17 +203,12 @@ xfs_inode_item_format_data_fork(
>  			~(XFS_ILOG_DEXT | XFS_ILOG_DBROOT |
> XFS_ILOG_DEV);
>  		if ((iip->ili_fields & XFS_ILOG_DDATA) &&
>  		    ip->i_df.if_bytes > 0) {
> -			/*
> -			 * Round i_bytes up to a word boundary.
> -			 * The underlying memory is guaranteed
> -			 * to be there by xfs_idata_realloc().
> -			 */
> -			data_bytes = roundup(ip->i_df.if_bytes, 4);
>  			ASSERT(ip->i_df.if_u1.if_data != NULL);
>  			ASSERT(ip->i_disk_size > 0);
>  			xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_ILOCAL,
> -					ip->i_df.if_u1.if_data,
> data_bytes);
> -			ilf->ilf_dsize = (unsigned)data_bytes;
> +					ip->i_df.if_u1.if_data,
> +					ip->i_df.if_bytes);
> +			ilf->ilf_dsize = (unsigned)ip->i_df.if_bytes;
>  			ilf->ilf_size++;
>  		} else {
>  			iip->ili_fields &= ~XFS_ILOG_DDATA;
> @@ -287,17 +282,11 @@ xfs_inode_item_format_attr_fork(
>  
>  		if ((iip->ili_fields & XFS_ILOG_ADATA) &&
>  		    ip->i_afp->if_bytes > 0) {
> -			/*
> -			 * Round i_bytes up to a word boundary.
> -			 * The underlying memory is guaranteed
> -			 * to be there by xfs_idata_realloc().
> -			 */
> -			data_bytes = roundup(ip->i_afp->if_bytes, 4);
>  			ASSERT(ip->i_afp->if_u1.if_data != NULL);
>  			xlog_copy_iovec(lv, vecp,
> XLOG_REG_TYPE_IATTR_LOCAL,
>  					ip->i_afp->if_u1.if_data,
> -					data_bytes);
> -			ilf->ilf_asize = (unsigned)data_bytes;
> +					ip->i_afp->if_bytes);
> +			ilf->ilf_asize = (unsigned)ip->i_afp->if_bytes;
>  			ilf->ilf_size++;
>  		} else {
>  			iip->ili_fields &= ~XFS_ILOG_ADATA;
> diff --git a/fs/xfs/xfs_inode_item_recover.c
> b/fs/xfs/xfs_inode_item_recover.c
> index 239dd2e3384e..044504a4b399 100644
> --- a/fs/xfs/xfs_inode_item_recover.c
> +++ b/fs/xfs/xfs_inode_item_recover.c
> @@ -401,7 +401,7 @@ xlog_recover_inode_commit_pass2(
>  	ASSERT(in_f->ilf_size <= 4);
>  	ASSERT((in_f->ilf_size == 3) || (fields & XFS_ILOG_AFORK));
>  	ASSERT(!(fields & XFS_ILOG_DFORK) ||
> -	       (len == in_f->ilf_dsize));
> +	       (len == xlog_calc_iovec_len(in_f->ilf_dsize)));
>  
>  	switch (fields & XFS_ILOG_DFORK) {
>  	case XFS_ILOG_DDATA:
> @@ -436,7 +436,7 @@ xlog_recover_inode_commit_pass2(
>  		}
>  		len = item->ri_buf[attr_index].i_len;
>  		src = item->ri_buf[attr_index].i_addr;
> -		ASSERT(len == in_f->ilf_asize);
> +		ASSERT(len == xlog_calc_iovec_len(in_f->ilf_asize));
>  
>  		switch (in_f->ilf_fields & XFS_ILOG_AFORK) {
>  		case XFS_ILOG_ADATA:
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index 816f44d7dc81..fbe3e764cee3 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -21,6 +21,17 @@ struct xfs_log_vec {
>  
>  #define XFS_LOG_VEC_ORDERED	(-1)
>  
> +/*
> + * Calculate the log iovec length for a given user buffer length.
> Intended to be
> + * used by ->iop_size implementations when sizing buffers of
> arbitrary
> + * alignments.
> + */
> +static inline int
> +xlog_calc_iovec_len(int len)
> +{
> +	return roundup(len, 4);
> +}
> +
>  void *xlog_prepare_iovec(struct xfs_log_vec *lv, struct
> xfs_log_iovec **vecp,
>  		uint type);
>  
> @@ -29,6 +40,12 @@ xlog_finish_iovec(struct xfs_log_vec *lv, struct
> xfs_log_iovec *vec, int len)
>  {
>  	struct xlog_op_header	*oph = vec->i_addr;
>  
> +	/*
> +	 * Always round up the length to the correct alignment so
> callers don't
> +	 * need to know anything about this log vec layout requirement.
> +	 */
> +	len = xlog_calc_iovec_len(len);Hmm, what code base was this on?
> > 
Hmm, I'm getting some merge conflicts in this area.  It looks like the
round_up logic was already added in:

bde7cff67c39227c6ad503394e19e58debdbc5e3
"xfs: format log items write directly into the linear CIL buffer"

So I think it's ok to drop this bit about rounding length.

Other than that I think the patch looks ok.
Allison

> +
>  	/* opheader tracks payload length, logvec tracks region length
> */
>  	oph->oh_len = cpu_to_be32(len);
>  
> @@ -36,8 +53,14 @@ xlog_finish_iovec(struct xfs_log_vec *lv, struct
> xfs_log_iovec *vec, int len)
>  	lv->lv_buf_len += len;
>  	lv->lv_bytes += len;
>  	vec->i_len = len;
> +
> +	/* Catch buffer overruns */
> +	ASSERT((void *)lv->lv_buf + lv->lv_bytes <= (void *)lv + lv-
> >lv_size);
>  }
>  
> +/*
> + * Copy the amount of data requested by the caller into a new log
> iovec.
> + */
>  static inline void *
>  xlog_copy_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec **vecp,
>  		uint type, void *data, int len)

