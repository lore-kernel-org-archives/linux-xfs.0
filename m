Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF3DEC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 19 May 2022 20:34:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244761AbiESUe3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 May 2022 16:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244766AbiESUe2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 May 2022 16:34:28 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF167A83F
        for <linux-xfs@vger.kernel.org>; Thu, 19 May 2022 13:34:27 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24JJwwuU030095;
        Thu, 19 May 2022 20:34:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=P0SVADXZ6UoztjxYr8q92eyXbAH4t1MoXXDJMzuvN+k=;
 b=o2NjfHjaeGrC/DBNhCk6s83qBKIOJ0ix+xlVd/3zsM8EPSa6kSd54oQR1hzQwFIrm6Pk
 2493OrTSQc5kpfJoCwhVZRq4OX3lVxiptVewVMoZVB+86++3YH2yMxKOGMENX++ljgeA
 hQ6K4nK/zSiiDu4xrvfTBfg08NpCY4PMibmXxQwlmzH5TvEZcbr5+QJNeCSsGQyw5rYS
 cu4KISKI68ZPgufJtVtdmKee8QP2OvME3AxmxOvP/EWTgJ1kqIqQlW7eyl2B+l/Iy/48
 1d1HjKLiaLKDWkkzuuf59X5uTs2GYLhQY4PweDYSk9JB+w6X6pIHhHSLv5quUj6eflJq cw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g23725mcq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 20:34:23 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24JKG6Pn017005;
        Thu, 19 May 2022 20:34:22 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g22v5pc25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 20:34:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QGJYH/rhXBplb5Bl747oEkqmkoQgGHNLcE2v6HaV4boncnXv5E11iTPNRJDoVKrkQ04rgV36YgcdLKdIVq9Kn3/sWR2rsLqpYKaKh8oy6H+6GrsORSQ8FoAoIMoK7Wc4BB60OgFpURP4thS5l+DKerQUHK0Nt8dSkt4TzZlzGpvlWFJxvSXaPGFRX2IPE9h9q/J94X8zg7M+1ddjnjYqwllESodspOZdaiCbeALC7RwXjDYrna4hUZenP+Z5/joWbdWPqUUsczfvvZdio2HyZcvJENKXvQ2Z8h/p3cEk9IJs7weXsr81+DZRQY8qnNn65uV/hlal4IBY8xYI3qaX2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P0SVADXZ6UoztjxYr8q92eyXbAH4t1MoXXDJMzuvN+k=;
 b=nPj0y3TiSaiBP6CZ3+Q7lOpeh3WAY3zk0ylglDy1tMZMrlx9BYP3AShTyspISKDs7MHbLcT5ZGtUwkT0KUeToskaAd3d0PPL4H+JcIYCrPfyEhfhDpFiZemsBdFOPaagYVmiAAFmNiUBKq0o9UFRv0b+ocYOMkEHqcExY0wg/TCj6Sx9Fxl4+8v73zx346lIIF6GpRyuye4nX9CZJAZpAPqM8UeSS7Aa7/Q4uVHhUx6UwUWjkz1EedNSFwFCzRmm7W5LoC16NauORWRDshQezGMuXqDGNNSCm3CX4+5qJzFU834jakOz+xc30iCELHOU94IdAdYRwPAvfhhS2TzI2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P0SVADXZ6UoztjxYr8q92eyXbAH4t1MoXXDJMzuvN+k=;
 b=q48W++BNZja+FAVjcaGGXZeSyfAUtliLcS2pRFhjSEpYgQO5DEFY+/AeCheWRUUwcpzN7bkBVTb+mlQIGHxUsnMO/ggJKRf0RVO57rnWZAwGXUS5Fn3vwZXMfWWKQZ4ASmSoLEvSTDXlZV2s0or9p4fkl5SLqir3CIZUXHgSmnw=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM5PR1001MB2186.namprd10.prod.outlook.com (2603:10b6:4:35::35) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Thu, 19 May
 2022 20:34:21 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311%4]) with mapi id 15.20.5273.014; Thu, 19 May 2022
 20:34:20 +0000
Message-ID: <10fb9319f267fb51ea6f527d4cb5a69324a8024b.camel@oracle.com>
Subject: Re: [PATCH 6/7] xfs: clean up state variable usage in
 xfs_attr_node_remove_attr
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Thu, 19 May 2022 13:34:19 -0700
In-Reply-To: <165290017800.1647637.17976841524804650684.stgit@magnolia>
References: <165290014409.1647637.4876706578208264219.stgit@magnolia>
         <165290017800.1647637.17976841524804650684.stgit@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0033.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::8) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87f50b33-d54b-4ed9-7fc0-08da39d6f419
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2186:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2186A3C50A1157BD7DA9BB4195D09@DM5PR1001MB2186.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H5FPueGVGj6Et9Y4Rvpev3Nq/uxPcaX0wQmmFgRpYa9EGGv+o4Tg22s17xnRAGjpI+YcTR6aiue52oTx8WDw/g59Akugo6vCMNLfK4voygW2zk8mO37l8+cjanUjO+Bf+IUlkBNS+fjYpxLk+OKQA35VL7dj7PRdXJZitr61HmHiL47L+jZ9t15w9Qe7wxGq8zDBVE1yj47DcsqZQga2y4FmX+S/mPRF9Mj8dr5wo5q735lEi25pH6zwgua2dGncIcDbHDKbYTugIH0UDTXtB3s3JR0T77HOh3psz8c04DZO1nluMQ1IGi9mbGhSAZWoYBbAIVIs1V/mpG4je9f6jjujbjtiOPOit3njJGMgBvqhxH5zWcvdfaxNFh3UQYTXHsVLGnitqvuzvhoILlu7adDVdyQhFvnuIpmV5Anp29EIP1I8esr5+2yPLqKk0i03Yll9oMOFnsKuYM0kBFXbsDscGVZGDE9iG/GqCJlWpdpZY+chWzry7HjWIKaZebf1lcsCCVotTv4LgiUBYt+oeA6BSGhYI69vSX/EELdYA58xKsMm62plpQgl0MBCIxv0qAY2OYbb1yPdefBiofORN8Bx1BVJhzVBWM0AUWpv5QILKT00Y1vjuKTfASJR35MKpLGCu3XHmMuvAFo/AC+DwBbj2aMyZTKwnvXM1mQsYCAHtOIPl/jJU7ZvqV+OvDfEHxPuDjIJH5NjrhS4tgbf7g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(52116002)(66556008)(6486002)(86362001)(6506007)(6512007)(186003)(26005)(4326008)(83380400001)(316002)(8936002)(5660300002)(38350700002)(38100700002)(36756003)(6916009)(8676002)(2906002)(66946007)(2616005)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZE5nUjVzb3JjZWN2S1JoWVBvQzVYZDNiaE5NRDBqb0hTS2Evd05tVmJMOXh0?=
 =?utf-8?B?UUxOOWNpQlF0SXFLNFNyOGV1WDg2aUlYV2RKMVl6NTEwVHFSUUhIUWtmbXJv?=
 =?utf-8?B?N0lwMFVGeXY1OU8xNFlSYk9ydlJGREFWN0FsTjMwaVVtRlFWQm12R0EzcldV?=
 =?utf-8?B?S0F6ZU9acGwyOVFlaDVmQSswaEtTdFYwQ09PSEtSMmtVbjM3U2swRGl5bHFP?=
 =?utf-8?B?S1NYdHVNdUozNVNhdW9tT0YzQTFHMWltMkxScjZGNkdWNWc1RVFZMWkvc2N2?=
 =?utf-8?B?WjFZTXZmZ0IrUGliREZsd3hobFdIQ2I5YjA1Ly9IN2NnUHUxbVVWdmZVMkVC?=
 =?utf-8?B?UEErR0FYYXg5THNLZ2RrYXNTVzdiY2tDaVJvRlVZbUpIWFZaNnZodXZNWGU5?=
 =?utf-8?B?bTRlV09BbUNmWG5UV0NEcWozMmxwTm9PRDNLTWNldUpnNnVIU1ZJQkZkN1hm?=
 =?utf-8?B?d3F5aUNna3pJWXQ0T0pyb0Q0d3Z6dGs5Y3FvbkZ4SGs1cWV3aXprQ1l2bUhW?=
 =?utf-8?B?am1kdUJTSkQxSWd4RGwvMndwZ3NjbmV4eFJWK1BHbWt6YWFpRnJ0S2xuNC9Y?=
 =?utf-8?B?S1lTbzdZTHVVNEJFL2Ryb2ptU0prVTdLd0JSOFZWdlY3S1UyeEdOMjBLWmF5?=
 =?utf-8?B?ekR0L2dnUkpTTW96b2dxWDFHSlZvY3lGRjZJRTNYWmxNNGZwbFBzOWd1Kytm?=
 =?utf-8?B?bEEvU1laWTArQmFad0txWHRnMFFtUlFnTzhFbW5XN1lMZUYxTk5QZnhHK0lQ?=
 =?utf-8?B?TjhjQUxWOVl3Tmowdldpc0tHVStEaWY5Z01XTDM4K3U2cEcyOW5WQzVmM2Uz?=
 =?utf-8?B?Qi8wVHBNSkp2c1FERG5WYVB6Q1Y1S1A5Mm5nZ1JxL0xObklpdk5hdnJxb2E3?=
 =?utf-8?B?R2hLZHhpSURMRUdubVhaeVdIZ0ozZUJILzhYMVg1OVV5UGdEUlV6enZLcW1X?=
 =?utf-8?B?NGJIY3NhVUlnTWxkT2NTTGRVL3FqYlBiZ1pVUEJCck5BUXdGZE81dWlIdnhC?=
 =?utf-8?B?VDkxMytGT2E0RE1qYmlGWjJFZDRKeXZTbTBZeHpycEZjYWE1TTRBUWlqMWd4?=
 =?utf-8?B?dnQwRjJJVGpSR1pRdWk3WjVJZjlCV2RpbjVyRE5kRWgvZDc5dHdUaFE3KzV1?=
 =?utf-8?B?Qmc2KzVDQ2Y5VHNMQ2xNdUYwN2J3aExiMGtoRHdsZGFoQWRuVm1rZXhjV0h4?=
 =?utf-8?B?eUhVOWJjcm9Ddi91WlhuSWxobkR5VlArMG10aUF5d1N1MGRVVWNIRThTTUsy?=
 =?utf-8?B?bjN4azhQV2tXQzJrRmo3aUtWT05nUW1KOVluVi9LTXZxQ3kxaHAyN1NIRE5y?=
 =?utf-8?B?Z3J2YlNuU3dGdlBpTUFMb0NSRzl0NVlOSWRVY0dPdmhQSDBpNnBEQ2hReWVt?=
 =?utf-8?B?SGZkL2JoNGg3Rm0rSDNtTEU4Njd6SnEvTTZ1cmZLbFN4a1BVdUZ6M3VjaEsy?=
 =?utf-8?B?L0svVnllOCsvd3E5cUlmSVh1RStVekJiTHNjTTFwd096OU16Ry9mVUVoWEFZ?=
 =?utf-8?B?ZlROZlBxQnIvektVUHQ0VWkvd3VvQlFkMnExZjVQbVJqL1NDQXdxS0g0azFy?=
 =?utf-8?B?MzRhQlM2OTg4QlQ5NFVCdGtqc0U2QlNFYzUzdVdqS0dxcU0wMzlsMTArM0ph?=
 =?utf-8?B?WkJDVzk3VzNESGgyY1VJV2JHY05rTDY4RnlWZTQ2eTRGa0prM01MWTYzZnhR?=
 =?utf-8?B?d3BTMU85T2JXR05qZGxiMXUrS013YXlJYXZZdmljQ1JiR2pSallIOGxMeU01?=
 =?utf-8?B?aFdmUU5xdzZmdTZxakhCWFhRb0FER3JpQTVIYmp3dUZ6UFV2a2s4WnZRTnpF?=
 =?utf-8?B?RTBhazVHSHJJMmdmeXFEeklBaEVqZE5NcG4ybEdLclZkb1ZSeFl2ejdjV01D?=
 =?utf-8?B?dHBudDNCMGhBd0dvdk0xQlVDaTU5VmJmK0c2L0RvVXY2VTI1MDlSU0dHOHlV?=
 =?utf-8?B?NzAxZDlrbEdIbkZyYXMvSWMxTUZ1dmZFZWsxdEtycGV2eHdJOWhBdEdQL01J?=
 =?utf-8?B?NkNTWmhKdXl0dDNCRFd3TVZ2L2VnQVZRVXhlKzN4ckI0ckZUVUJ1NkF0dkM5?=
 =?utf-8?B?enFSZDhadStJRUlQZWZzelNoM0dzc2Z4TDhJTXZDcnloN3JsOW1MZHlUME9Q?=
 =?utf-8?B?RWp4K2dycnY1L0FKdTMxcXFGZkZRYjVHMERhZXY1QXFIREdJSmQ2eWhOWWtw?=
 =?utf-8?B?dDA3UUpLb2RUUTh3VythbmhpN1hMaUx6cGx6SUlkTU4wY1diQ3hnTEV4VlEw?=
 =?utf-8?B?UkNYc3hLTW9yZTBoajRCUy9zSHhoc0FDdzVZTUUxbFJwRGpLZHJoNTdJRUJU?=
 =?utf-8?B?UTVDdEJnMmZ4dkRFdUc2UFZON3k3Z1lkczlVeTlyTGF1L2hnSmkvWDVTUWRR?=
 =?utf-8?Q?WA0nzYJOsS+PH++w=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87f50b33-d54b-4ed9-7fc0-08da39d6f419
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 20:34:20.9161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xZZX0HbGWaGkXDpOAcL6F4Ejb/eSZOZJq2AfXYZMCnwLi8Lm2f+hL527L0gNUc2o2vd+65jQEZXmQ+TF0nB22YUkg6NdkkAS35q5lh6HkaE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2186
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-19_06:2022-05-19,2022-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 malwarescore=0 adultscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205190112
X-Proofpoint-GUID: 9P0KTbBGtah2sPhe6XiZw7fEWeNADnl8
X-Proofpoint-ORIG-GUID: 9P0KTbBGtah2sPhe6XiZw7fEWeNADnl8
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2022-05-18 at 11:56 -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The state variable is now a local variable pointing to a heap
> allocation, so we don't need to zero-initialize it, nor do we need
> the
> conditional to decide if we should free it.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Looks ok
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c |    7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 162fbac78524..b1300bd10318 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1516,7 +1516,7 @@ xfs_attr_node_remove_attr(
>  	struct xfs_attr_item		*attr)
>  {
>  	struct xfs_da_args		*args = attr->xattri_da_args;
> -	struct xfs_da_state		*state = NULL;
> +	struct xfs_da_state		*state =
> xfs_da_state_alloc(args);
>  	int				retval = 0;
>  	int				error = 0;
>  
> @@ -1526,8 +1526,6 @@ xfs_attr_node_remove_attr(
>  	 * attribute entry after any split ops.
>  	 */
>  	args->attr_filter |= XFS_ATTR_INCOMPLETE;
> -	state = xfs_da_state_alloc(args);
> -	state->inleaf = 0;
>  	error = xfs_da3_node_lookup_int(state, &retval);
>  	if (error)
>  		goto out;
> @@ -1545,8 +1543,7 @@ xfs_attr_node_remove_attr(
>  	retval = error = 0;
>  
>  out:
> -	if (state)
> -		xfs_da_state_free(state);
> +	xfs_da_state_free(state);
>  	if (error)
>  		return error;
>  	return retval;
> 

