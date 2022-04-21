Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D926CC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Apr 2022 03:08:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350159AbiDUDKx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Apr 2022 23:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243191AbiDUDKx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Apr 2022 23:10:53 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70C1C10F3
        for <linux-xfs@vger.kernel.org>; Wed, 20 Apr 2022 20:08:04 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23L36Gpi019412;
        Thu, 21 Apr 2022 03:08:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=dftBKabTWUKv9KROJpD+bEMlhq5+CntEZZl8KPnXnDY=;
 b=vQ1jIiO1x8yvUcShUw91RwLI6DmRRhu5+0ZIhaxdVDSienTiyrRTMWKw8c07xilCBR/Z
 SaJdwBV36TR7VxBMqN5g7fhe07zYrWJhEt6BccDf1Vnq2EzzCHko/a1dZpgIo4xeXpk3
 HnlbXeUP+wimiVbVAfs+/hGQh6Hm39KXW16TpRspG/tewgi9PdHgHXe1jKVHwYDuhgUa
 uiffsJ/T/FzJfm9xbEFw1lQt6ZEloBVpBrrkBv4q/1qtXuiTkfMkyxn6wSzqqMS9lj8L
 /Aq++44NECqVXpCr/DaheZq4Kc3Zq9j0vyZxMQgLmzjjbpFoMCMytTGeiaPCW+5qbfpe Vg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffm7ctj4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 03:08:02 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23L30hwq001933;
        Thu, 21 Apr 2022 03:08:01 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ffm89cpsn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 03:08:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CwoGpG7whAIf6VDbWNQ4M34DQnHuWu5k9T3yfHjYfihcOCRQfmSo9mN4PJ2fokJjgffbubpc4xefjoMd1PvTm4QEM50l2Pgplcqmz6wwo17QEtxVFmzI6uCNkkc86vxsBAWDc84fUNwGl7wUSYx2ILWca3oHMCvt6aykQYudoCJwwf0jwNExwm9vEJiczyFqEDlk1/Px6P5e5yLd0z3wiYJjRFzvGhDw+AdgJEyG5WJJtNM7L1yiIHwlOQX7QFR5dmWA78VfWmtrdCD1JppgU0Kfgd6RDy0MGZhq0jc7MBzkGSwRiXCVgBE0j8jbPpANrADuRzrtJIDq17nRDeVoUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dftBKabTWUKv9KROJpD+bEMlhq5+CntEZZl8KPnXnDY=;
 b=DSdRvUXo83E+TdkXrAOQjkWv7jl1GlT7T4ywKxM4F2PHs0M3A53vOpYsbuOpeHbJRzTmjChfPCpMc4tOGP0HIUt1xAbsDmt53APx83I1Otvm/fOthMOASSmbzZEcH2BRzIiooLtiw/85Ls8Csl5ZKvGTy30HcA1bNcNZmczWxiMguyEiClsa4lBYhVla0SLvAxBoapgG743SZ80PrvylUMVQ3OxKdxaMCB+VE2n2i7IHN5Z9LhqTFwxEqEdEMF2UY6oaA1o09uW+AaWF1rJ5jm0T9uYZynapZ1qXMYEnahYLfqQ3RmbgqCO7JVuRFrWlrUvG9cgNptQJz7vBty3blA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dftBKabTWUKv9KROJpD+bEMlhq5+CntEZZl8KPnXnDY=;
 b=O8ZRge0mswAazUDFGcpT1rDJ7fuwJ4T9rGfChZ8U1UNiGE0+/wwRCtQJmVGYcnPKQbthyIrEYqL2BIYaDq+olbXCFYVHcYxktJ7N9yjktUpUXsa3O/GGKOpuWhPB/hNYNURajpQHhN2pa0yZ/oSwLrsr6HTY9tl3znCYPLG6RxM=
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by SN6PR10MB2431.namprd10.prod.outlook.com (2603:10b6:805:49::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 21 Apr
 2022 03:07:59 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::b444:a720:24c7:76c8]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::b444:a720:24c7:76c8%5]) with mapi id 15.20.5186.014; Thu, 21 Apr 2022
 03:07:58 +0000
Message-ID: <1507f37636aa2ea5ef4abc938b29d82ca3c60b6d.camel@oracle.com>
Subject: Re: [PATCH 13/17 v2] xfs: convert inode lock flags to unsigned.
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>,
        Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 20 Apr 2022 20:07:55 -0700
In-Reply-To: <20220421004437.GQ1544202@dread.disaster.area>
References: <20220411003147.2104423-1-david@fromorbit.com>
         <20220411003147.2104423-14-david@fromorbit.com>
         <87v8vezrrt.fsf@debian-BULLSEYE-live-builder-AMD64>
         <20220412084305.GE1544202@dread.disaster.area>
         <20220421004437.GQ1544202@dread.disaster.area>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH0PR07CA0075.namprd07.prod.outlook.com
 (2603:10b6:510:f::20) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f1f3ba6b-6a19-4df4-cc2d-08da2344233a
X-MS-TrafficTypeDiagnostic: SN6PR10MB2431:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB2431BF444A4BD5BD5FF7977195F49@SN6PR10MB2431.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1NXoGHKWRSAfoc9ZcrIEjjNy4i8dDqEDGKOyeQO0K9aEiKXM2nrMC17LLvfaZj9i24UHV7Xd3IHI5nSyTWqOZe41JhRjoHuci3oIC+vNhMjUh6Lvd3ZQqwqwYlYgKGbtD0TeTvSvPkJ+pIIDooch80diF/9bmlKDmOuqdAvH6uebllQO5T0BTtPGiUwJexpFk+rBiIpKnEgIK4MbaoHSScfUmxO1wHE8B8uzLAIL4sDRsFKC5XqhHZkI1hMUZ17Jz3496kOAqhdAh70DJqOq3CKb7SEWqiDajuLr1e21w3cWzBHCqrC0XZqAMFg1WtvPebajVy6ELGG2tcHLQY6FB6KTooFSZ9PAe8gJoUtGVf1kwn+xiNRiiaXS3ti+8gIlobfcc828NA9DP7Uyu6YjCVIvPP3CXd7NVyrEyNn6lPxgRkvZyWM0E1YZaqLZUonv7xvKdudVjzy92LKKnUrqyDHlF6c5IxakzBALdNdKf3s2wLj6pIEYZOVlMRoAXIPyucOlNq1J2xcm5HjggLE9SnuC+a89EWKiXJ6YIcvziL2GCC2eAl3IeXjo1YM1Jy6/48gR6YEus4Gj9g1W2mLr+rcCu3SLGICKPWFH/0nSHGC/zxvRpt1ab6VjTQIKApVRgsacUsngu+oI9NAcYuL8qcnn1wzcysxx8KXXp/oc3UyvEloqYKsrXfgxD2wpxIJU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(26005)(38100700002)(38350700002)(6636002)(83380400001)(86362001)(316002)(5660300002)(110136005)(6486002)(36756003)(8936002)(66946007)(66556008)(66476007)(8676002)(4326008)(2906002)(6666004)(6512007)(52116002)(6506007)(2616005)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aEx5S1V1UGxERk1rRkJ3bVoxUWxwVlNMWXdTM1BpVEh6eTBjanJLS2c2QlJu?=
 =?utf-8?B?aEJzSWRmL20xOWxSV0tqT1JienFsS3hBZ1dESWdNdFRVWUtyZ1ViWXZUM1JZ?=
 =?utf-8?B?cTFHY25jZnkvb05BbENEYkdiUXIrWUlZRjFjVzBnTGdDd0lEMDh2NXpxbmg5?=
 =?utf-8?B?VjRoUzF3NitYN0ZKd2xQOHRQcURoNmxVd1VKSFQ0K201V0UrekFSSEpySmFT?=
 =?utf-8?B?RTdDcVBkMHpjYXNVT0FJVldadXdXL29xWEpuOFE2N0JYWWFZTm5iWnpIVXVQ?=
 =?utf-8?B?dEV4ZkRuamRqV1pOazdEdDNmdVRCd2xMT29aT0ZkNHdTOUpWdUxFUlFKNE10?=
 =?utf-8?B?aEZlLzJlb3NnN3RremlSUkFlYjJPTXBiZW1QdzdOWDdyUC9YVktoVmVsRnV1?=
 =?utf-8?B?VEtrclptY0pQeEZqeGw1M1g0VGFZeEVpOUVKSm5QUjZwaW9rWExtL0lCeEJI?=
 =?utf-8?B?QVhjMTN1akJZWi9hbDBhQ1ByOWVzdzNQcjZvV2VtZHBRSUtSWWd3T3JFUDhS?=
 =?utf-8?B?K1RkaTEydUZHUVVTa2FaU3U1cmJPNkdRbURla21oZHg4VnU3RnlZWmVWdTVj?=
 =?utf-8?B?WDhwSVhDWU5OL2FoWFc0U0laUGJ5MFpCQmoyOTBkQkJ2N2RWSXkvSlI2RE0z?=
 =?utf-8?B?N0YvZVlPUGhPQWdEdWhLcWFlYUxtNmI4V1FOQ1ZQVS9Vb2hobnpwMFdTZzhZ?=
 =?utf-8?B?UGJISk1DQXVjd2ZaZGhLb1h0TDk2UFdNempKUzhrUnFQMWhwRVYzMGxtbmR4?=
 =?utf-8?B?akZlWjR3cElDemYvNTFJWkRZUlFndVRBZ0w5dU9qaklKRytOMHdKdkRUSGtL?=
 =?utf-8?B?UklaUmJDblpBdTV6ZklDaXV6R1ljN3B3YWw2L1BDeVdEL0syajI3Y3ZLU3Rw?=
 =?utf-8?B?SmlXUElsZTVuRFBHNy9XSDQvV21kZzNkOUR5a0s3SzVhc0VGdWt2eEp3TTZB?=
 =?utf-8?B?VTJRWS80bHVSUGdBYlhJaGNDYm5PZE91OG9xU1Z5M2tMTHdXSzNNVDdVdE1F?=
 =?utf-8?B?TDdjNi9HNWZvMEM0WTZ3VWwydkRGaEdkM1JsY0g2SHNuamtVd1l4eXRjU1p0?=
 =?utf-8?B?aittSVFENnlKQ2VLTWNISVF2eTRqUDYrSW9YdnRqUEhxc2xQanh3WGhySlFk?=
 =?utf-8?B?VmhhaGQ0Z0Nja0FvK0JBWlByYkxYRXgzK2x5U2NlbGt1SU1SNjZCbGlOcGxD?=
 =?utf-8?B?NnlhZDdYM0VqMnE5YmZhV2xuVW1uZUk4YS9jam5KdzlkRHJxall5UDd3Sy9R?=
 =?utf-8?B?N1NKUlFmaEpsQ1htNlRiQnRlemszdkdDSUVtaWYzS2ZFUDhCVmdVVEEwVTRt?=
 =?utf-8?B?NVlHUHkxVzJWNFZuZjJMTmtubGh1elc2Nk5yRFU0ZVBwZ3RGaHZCZitvcTBX?=
 =?utf-8?B?Qmw3clExTWNUbndPK0VoNUo1NUlBYmp5dEp4eVcvRjBOWWthKzBmdldxTkt6?=
 =?utf-8?B?eWp3ZU43YnZPMFFSRWkzQXNZZDBIdGtQOWN1c0VZaTc3WTEycGlWdGNpMGVG?=
 =?utf-8?B?enpkMEVENkdwZXdPbytVS0F3d2o3QXJPR1NFK1pNT2RWYjJJZWNDZWw1aEhU?=
 =?utf-8?B?SWlueUJBK1dOMFYxa0kvNDRKTEp6V1h5NU1Pd2NpRlp4ZzBacGVuZFZTdG5E?=
 =?utf-8?B?T1RMYXI4c1kxTnBlYjBBYmZPSG82MVhPYUxldFBqak5zNy8wbmJWLzZnbGJ6?=
 =?utf-8?B?UGhrZUlOTGhHV0x3YWc0dUQ1UzhuN0dybzJJYzhGUzhUNy9ybnVwL3QxUzYv?=
 =?utf-8?B?b3hjdFBkNmZ4aVp5Wjlackd4RmRIaWxnYmpzUll3ZVVyS1ZieWJHMXVlV29t?=
 =?utf-8?B?NE1HQmZReVR0ODhncU1ZWlJMM3BvbG5WdzhIYlBCU0hRZUt2V2RzUFRWR2ph?=
 =?utf-8?B?OFhkM1BvOFVNc01EbWJDUU1oS0QrWXQwWWN6eWdjQmljbHpyR1Vxc3dXd0ZY?=
 =?utf-8?B?UDdqWXlTRU13ODl3NzBWb3l4RmF2ZGF4bFpyaENyOE90cVJOb3BEcGVkOFla?=
 =?utf-8?B?bXZGbVlieWJFZTg1TzNHOGo5RnZlNjBvNWlUbXNiUWNCL0t3WlBIZ05jSnlX?=
 =?utf-8?B?RWVmQkdCN1I0Zkl1amhtL2IxUXU4TTFQYzRHZFFUaEVhWUVVVWkyc25xMWhB?=
 =?utf-8?B?amdQMXJIdTlGSnZZdWNpcktZYzJTZStTcEhXUllSOTBZZEE1aEErNFowQVFy?=
 =?utf-8?B?VGhkV3dIaHdDUERKS0NYWVluVWlPZXlWUXFDQTd3U3hiOEFDOTIwMjZROC9v?=
 =?utf-8?B?REFKN09tdWplMHNHMHYveVQ4c0Flb3RVdUlCbGVTMURCMEVZMExFUzBHK3VD?=
 =?utf-8?B?cFViY05zVHZmL0M5SnY1THprdXl6NnhhbGgxNGJxWHBOMDdoVldQbXN4TUg3?=
 =?utf-8?Q?4C+tYJ4xbLoUNpWo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1f3ba6b-6a19-4df4-cc2d-08da2344233a
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2022 03:07:58.4349
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gv0S6h3UtqoRfknV5RXp4x+x0LMxJyhkZNQCGXXVOg0/hW1lTbWIVNbTMG8Ejcqg18+7tSB3v+cVT/SlgSfpqpxMvSZrbkRpMN8zoDvGK6U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2431
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-20_06:2022-04-20,2022-04-20 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204210013
X-Proofpoint-GUID: zBxweY-dpX-Sx6ChzwlEWfzBhF-noSqD
X-Proofpoint-ORIG-GUID: zBxweY-dpX-Sx6ChzwlEWfzBhF-noSqD
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 2022-04-21 at 10:44 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> 5.18 w/ std=gnu11 compiled with gcc-5 wants flags stored in unsigned
> fields to be unsigned.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
> V2:
> - convert the missed ILOCK bit values and masks to unsigned.
> 
Looks ok now
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

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
>  	struct inode		*inode = iocb->ki_filp->f_mapping-
> >host;
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
>   * parent locking. Care must be taken to ensure we don't overrun the
> subclass
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
>  				if (lp && test_bit(XFS_LI_IN_AIL, &lp-
> >li_flags))
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
> @@ -278,12 +278,12 @@ static inline bool xfs_inode_has_bigtime(struct
> xfs_inode *ip)
>   * Bit ranges:	1<<1  - 1<<16-1 -- iolock/ilock modes
> (bitfield)
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
>  #define XFS_LOCK_MASK		(XFS_IOLOCK_EXCL |
> XFS_IOLOCK_SHARED \
>  				| XFS_ILOCK_EXCL | XFS_ILOCK_SHARED \
> @@ -350,19 +350,19 @@ static inline bool xfs_inode_has_bigtime(struct
> xfs_inode *ip)
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
>  #define XFS_ILOCK_MAX_SUBCLASS		(XFS_ILOCK_PARENT_VAL -
> 1)
> -#define XFS_ILOCK_RTBITMAP_VAL		6
> -#define XFS_ILOCK_RTSUM_VAL		7
> -#define XFS_ILOCK_DEP_MASK		0xff000000
> +#define XFS_ILOCK_RTBITMAP_VAL		6u
> +#define XFS_ILOCK_RTSUM_VAL		7u
> +#define XFS_ILOCK_DEP_MASK		0xff000000u
>  #define	XFS_ILOCK_PARENT		(XFS_ILOCK_PARENT_VAL <<
> XFS_ILOCK_SHIFT)
>  #define	XFS_ILOCK_RTBITMAP		(XFS_ILOCK_RTBITMAP_V
> AL << XFS_ILOCK_SHIFT)
>  #define	XFS_ILOCK_RTSUM			(XFS_ILOCK_RTSUM_VAL
> << XFS_ILOCK_SHIFT)

