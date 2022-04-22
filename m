Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B3CFC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Apr 2022 00:38:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442966AbiDVAlJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Apr 2022 20:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiDVAlI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Apr 2022 20:41:08 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 038FA443FA
        for <linux-xfs@vger.kernel.org>; Thu, 21 Apr 2022 17:38:17 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23LLYuVZ024754;
        Fri, 22 Apr 2022 00:38:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=wixQiqQIaPFVpiYOygm5IVjeVmV8eXUgk0jzLcYKLYY=;
 b=gJjn/ZxhybNwEuwJn8crbxfvfI6DM1zmPqPsou0dU+Mr9+WRAVno4CH6O3QFjVJ1GFBo
 7uZsVcS3Na/bHxxbqqEOYiYRzndsmrB8rauCkH1sbCFGvUEqw1Zkx0aZXXl0Vlm/8+Xh
 Bbut2gKBvk1muLnQqfQWmupX9RKcl7vZ2EPhRw5ThRxL6KprElCmVlYxMypfRQaFt5Yw
 KyqiqWYpXyl4Hitg4faj29gBaaSAHQNuRSUveGbRHuR6jOAmbF2ikJ7CSKDuyuLbMD9O
 BG35PUdyWGGA/SGPCOeGKSyeZCaYC+GSxu6SJyXrFkMVXLcJ93yCJ36XB0BJbDUzOLxL +Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffnp9n32s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Apr 2022 00:38:15 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23M0alKa029370;
        Fri, 22 Apr 2022 00:38:15 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2043.outbound.protection.outlook.com [104.47.56.43])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fk3av135h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Apr 2022 00:38:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j3t9KO4Z1ZwkrIZAf+IA/wYZhFPnafpPSj5O37QsOJdJDgT7tyTaB1zu05Gv+ZyXkA3TkVVeqNIXQAIm2rL3Ev8ykGvr4hmc8Y/K5TnXvZkU8urTdc+WpjYGTGntA//d7dY8o93rlfHlaH6/Ci0la+rWLXVWwKL7QSvSZjyEYN9hsQfTg33QzjFltKkiRTyM2hIjQxjWrtz7yPlYvvdCPn590/31QMZ3cZxBqmhBJAsv/22nvhi0yWhETOc8T15JZ/9guujsdrIjc2DvZTTB9DIIyUxF5gUiLXTcO3yBF1l4xtYL7ayTu9jrDwB+I6EATH4dcYcdo1KuGBkcf3LRlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wixQiqQIaPFVpiYOygm5IVjeVmV8eXUgk0jzLcYKLYY=;
 b=GHrUTa3szKLIZrnv57lcbT+A+X7yYRMalifIAfbIcJVzfdllcZRu00IotExL2CQzCQMoak7J8F5ACq7PWy0Thw07v9b7bpnaQuGAu21BWP/5mKaC8Le2y5KlAD6lQKZoykALw3u7AMP9Pv885gV4B0d6LcEFD35LRwXGb/MJdBga3mHTKG5jhfWibbRYti9/ODbjUyU6CwnP2PT/RdLyHvUmbuisW5UqeHwL+13+KDYyj2Zrh1eCaYMDA/2RN3e1cpmhELQJoUz7RMUCUeP4osYCdnbpsH09UKVfOCRImgpgttJDECruZ7x1ZQOrugyvcZYm6q1Km+td2+6ctBZ/6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wixQiqQIaPFVpiYOygm5IVjeVmV8eXUgk0jzLcYKLYY=;
 b=IW+n56MQ1GFMKHlUPkYhYLItN2A+uZdR625ln1qNcr2mzxnPIAyNIr4Gfwad/S/CxxHsTWjWTeZQNt2XQCK3NZKGYWSxuorwzBwPpy50Chj+4u/vLQXbL4uu268bag0BWogNZUww2iHRrwVgnEcidB9d795mLzSf2S6YNgtxzL0=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM5PR1001MB2251.namprd10.prod.outlook.com (2603:10b6:4:2e::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Fri, 22 Apr
 2022 00:38:12 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f%9]) with mapi id 15.20.5186.015; Fri, 22 Apr 2022
 00:38:12 +0000
Message-ID: <db4b1e9fd5633c68fa8f513ef676317d2896c97b.camel@oracle.com>
Subject: Re: [PATCH 05/16] xfs: kill XFS_DAC_LEAF_ADDNAME_INIT
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Thu, 21 Apr 2022 17:38:10 -0700
In-Reply-To: <20220414094434.2508781-6-david@fromorbit.com>
References: <20220414094434.2508781-1-david@fromorbit.com>
         <20220414094434.2508781-6-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR21CA0028.namprd21.prod.outlook.com
 (2603:10b6:a03:114::38) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ccfecf5d-e207-486e-5e36-08da23f8618d
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2251:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2251433659D4D326D84AFA5995F79@DM5PR1001MB2251.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EctS4FSSKYyZOS7lcfN0dUxw8sBM4SI/c3TojUFivmIDDTsEXbpPCj0quXyviG18PRwziITGYLHDXTjTv+oXykSfnm7yo9IUb4JKB8k+q8OswseylCwjnvneG7SEcfGThplTVRlJcpuuysQtYYsTG0ScsFrkG8XMSyQXptsTbWjU0L4LDogcf0PnInO/BVvMcbCiEnn2zGCcRYhJg3vT6GhHidHZpLaBSNIhO0LnB8vHiQGLfyzTdD3hyd3hczNowkpwD7ZZhsZrTpSs6vO0UYSsWPqaRE6v95AgLnPYHT2/LuyzcPoqQYibHOI4dgIfn2AzynF/6wv/Ax7haoPHYjEgrMVYCsIcFUukeO9FVTlc1uvPR0hFkJ6Oi/Iac1CiFDDUuICOERqDh2lvq3bBZ1TyEcX3/j37189ZV0fr5MGBJi3WKdj0dtyRoNN1MgKZkJLSOezNofjNUN73t/TA+sSmH9qlSGU+Wvtl2YSkaUm6z6RCdJ+lOYiyaOH9JotKd6OjUpug5tBEg6jzziZ2R8fSzXwvT5juVWoQ6rn1zrIgfvu6uCF2JUIGU5RVSdU8c4ur1HfBp+iPkYGb1w0DRmLse9g602IEdo8In/8OsZRYT1DClyusxpVmPevt4elq8KhLR8XGo/cnZwA4Ek+Lu21Ue4oHLfYU/Mkk4FgqZg3Z+cVUyIa21O2pI18YDY7h0na0SqfJMzvlUJXQUWSMmA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(38350700002)(5660300002)(36756003)(8676002)(8936002)(66476007)(66556008)(66946007)(316002)(86362001)(2616005)(508600001)(6486002)(2906002)(186003)(52116002)(6512007)(6506007)(26005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?akxRRWJPeVBrU29jemZhTzMzT09ONW44NXIrQ1ZsdVViMkNiVnU2MXpaYlBm?=
 =?utf-8?B?QzBRMW90ZVRrYm1Qcm1NY3hXdTRIaGw3d0FhZXZJZzJDeVJlZENoZWdMOHVm?=
 =?utf-8?B?cU1NTW4xT3JPeFduRmhRSG9KS3lPZlR6K0tWZkcrZnlFNWxWbTZSc0U1ZnJ5?=
 =?utf-8?B?Y0dpTDlIL0FOWWxSM2JvN3lNd0V1bUJuWGRQQVl5bDM0N3dBbW13ZFJ2NXZa?=
 =?utf-8?B?eHdlMGxIYjg4bHZCMnlhc0phaWk1TXBoWkxZcnFCbm41QVkyZ1NiN2twcWxK?=
 =?utf-8?B?N29FaE01MFp1WDlEUHEwa0puazU1NHBLNWZFM0huTG5lUWdVZVFjQ1VxYlBo?=
 =?utf-8?B?QVB6WkZxYThRODBQQnFIZ2ppZ2labFZQbUhmK2VBa3pYL3JWcXNkSU5kdWFp?=
 =?utf-8?B?cVlxQmNINzRsSm1xZHplem5XdUFsMFVJNktIcFpCUm5CK3JpajQ5L0ptTDVK?=
 =?utf-8?B?R3h6YmVoeUFNM1FlQWRxaStmdXpaenc5b3dickF2MXhhTkRmWldVeDFiS3lP?=
 =?utf-8?B?UXBMeFcvcDMzVnYxVUV2MkNJSUZvN00xa29kTVFSNTE3aFJIUGhIYlZZR2Jy?=
 =?utf-8?B?b09Da0phcVZmeHcrejh0TVpWUGJjdVJOcDgwc0c0UFYvcWFkZ1NEbVFnTmVj?=
 =?utf-8?B?N1BpYzJ1Z0ZudWxTd2R4MnNtSDBjRlJQWWlDcFQzSmc2LzcwWmFLK0pQRFVl?=
 =?utf-8?B?bDRpZTIvT3RqTjJiSHdiSUJtWXBPTWt3Zk1iSVRFMFFMVllBK05nOG5rV2lH?=
 =?utf-8?B?aUhpbWdkbUxoQklkR0Z0c1JiTGdOV1NrV2JtbGMyaHdYdnNOYnZOYWRvaGZL?=
 =?utf-8?B?dWg5ZjZjQnBnd2tqK3JyU2VrSVN6M3ROSVFHWGdPZmxySENvRnhORVZ1U0ZD?=
 =?utf-8?B?OEQwaDQrYXk2Q2RSYmdYNVVVempyRnAxcHkwaHJEWFhNVFBIZjNCSVFuNktk?=
 =?utf-8?B?eFUyU3hYOS8zTHlrMzFDSWdDRC9DeklrRnYyTGpDcUhNaGNHNDlvTWRRcG80?=
 =?utf-8?B?YVJLM1kwZk8wODRpU0w3UGdNNXkyaTJ5d2hnWkNrbUZ5NzQ4aFBieGFIRE5p?=
 =?utf-8?B?NGdlTnJpNllYazJsUlJDeFFoYXFjWXBKTGIrNFBLWUNGZWowS25sUUE1T3Az?=
 =?utf-8?B?bGIwUzNISDdWUE1sRjA4SlBNQUpTOHpNVS9JK1Nndi9scTFrSmlweUpRL0Jh?=
 =?utf-8?B?RmwyN2krcUxoVVhhQ2sxVHhwaHhtdThYSThycTZTOFJrOHJsYURSSU9vV0k2?=
 =?utf-8?B?Qk5FR3BVS29VTkp5S2VvWWZYaEZUTVAvYTBKS2xZdGdmOWRDamF4WGVsbzdu?=
 =?utf-8?B?R1RuTTRpaElDc3BMNXRHaG9BSVVyZkNIV2d2TVErcVF5dmFqallvejVEU2lQ?=
 =?utf-8?B?WlRWY213akVOM3lFZVlhS0RaQ0M5aDFHQmNKVWFPcEhUYlV1dFUxcSsveVNK?=
 =?utf-8?B?a29TeEZjbmxMTkQ3akZHanpDV3JnVVNmUlFXUWV0d0NWMEhBZzIyMW1YNFZu?=
 =?utf-8?B?K2V4VXB4VURocFhOVDRKcitWZ1JLVWt1RlVCK3RERTNCdEdZbnZTYk5SbTds?=
 =?utf-8?B?YndWUGFDZW5IeCtDaFNEK3NVKzA3eFU3TFc1NTV6MlMvb1F1cTJGN2xrOTAz?=
 =?utf-8?B?SG5QWHR1cFV0Wmo1ZkhvTnR2N2tUMEtYb2NFMUFjYlF3Tk1XN2xxWW0vWU5G?=
 =?utf-8?B?SVZZZmpkTlJIQXdYcWd3Q1lVUmJycm5PcnpmaEVkcklXbkE2Y3NyTjdETlh5?=
 =?utf-8?B?d2NtLzZkeXdLQmIreFpaMnp5aFdGMjhCSllLSFFjbGtWelBXVVhyQ0N0MHNl?=
 =?utf-8?B?b0hWRlNlQnN2SExUc2pCTEtUZkppMkVBN0RvRjVWdlpCNzlicTA5RVIvS2sz?=
 =?utf-8?B?OVc4cllLc1o0KzlwSnB2Yy9yTStuTHV6TUU5TzN0ZHdRbU1MWE94RDNFODhJ?=
 =?utf-8?B?eDVDVUpnc2NmcFFqU0JYUkN5d0x1TmxxemppdUJPaUFUQjY5VkYyL2lqdFA0?=
 =?utf-8?B?UVlmNUx6d29mY0h4ckxaanNmK09ZeXd3cWw3R0ZmY2IzSm9xNlBlaUJNUnkx?=
 =?utf-8?B?cEFNMCtTOXVpS250c01VamZsbzc1Vi82TUV0Zk40dDBUZkFlOHpFZWJUd0Jl?=
 =?utf-8?B?a2xmSlBqZUNzYjR1ZkcwZWM2eE1rNlpPRnRkTUJlei9lOE05TGNJK0k1MzZK?=
 =?utf-8?B?eFMzSnhIOERiMUFodXIycnJ6Z1FqNHBEUU1qOEpLbTEzek0vZmh0dzhtL3N6?=
 =?utf-8?B?NUZyOFRzdXhySFA5elpkNzRhdTA4T3lXZFpvZ2d1aUJieTBuT1paVGY4SmtY?=
 =?utf-8?B?NmZURnVBdVBsZW4vTHBqbk1YaGR0VEp3ckh2NnpEN05WenZjYmdBd1p0NmJ6?=
 =?utf-8?Q?McRM6+CjVyrHcWLs=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccfecf5d-e207-486e-5e36-08da23f8618d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 00:38:12.3112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /BY0eK5qvmRXtFW4Xdf6468hZfYYbqE223zlfCAQhTN2tYyG9+umLSBAiJyWycdWtNQXG5SuNSRhwJH5yGiOjPCPkDMj7rTbgDIosBYSFHw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2251
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-21_06:2022-04-21,2022-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204220000
X-Proofpoint-ORIG-GUID: mjjIgawF7bvWzwP6SG_gamFnlIJ7F_tx
X-Proofpoint-GUID: mjjIgawF7bvWzwP6SG_gamFnlIJ7F_tx
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 2022-04-14 at 19:44 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We re-enter the XFS_DAS_FOUND_LBLK state when we have to allocate
> multiple extents for a remote xattr. We currently have a flag
> called XFS_DAC_LEAF_ADDNAME_INIT to avoid running the remote attr
> hole finding code more than once.
> 
> However, for the node format tree, we have a separate state for this
> so we never reenter the state machine at XFS_DAS_FOUND_NBLK and so
> it does not need a special flag to skip over the remote attr hold
> finding code.
> 
> Convert the leaf block code to use the same state machine as the
> node blocks and kill the  XFS_DAC_LEAF_ADDNAME_INIT flag.
> 
> This further points out that this "ALLOC" state is only traversed
> if we have remote xattrs or we are doing a rename operation. Rename
> both the leaf and node alloc states to _ALLOC_RMT to indicate they
> are iterating to do allocation of remote xattr blocks.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
Looks ok to me
Reviewed-by: Allison Henderson<allison.henderson@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_attr.c | 45 ++++++++++++++++++++----------------
> ----
>  fs/xfs/libxfs/xfs_attr.h |  6 ++++--
>  fs/xfs/xfs_trace.h       |  3 ++-
>  3 files changed, 29 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index b0bbf827fbca..fed476bd048e 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -419,40 +419,41 @@ xfs_attr_set_iter(
>  		return xfs_attr_node_addname(attr);
>  
>  	case XFS_DAS_FOUND_LBLK:
> +		/*
> +		 * Find space for remote blocks and fall into the
> allocation
> +		 * state.
> +		 */
> +		if (args->rmtblkno > 0) {
> +			error = xfs_attr_rmtval_find_space(attr);
> +			if (error)
> +				return error;
> +		}
> +		attr->xattri_dela_state = XFS_DAS_LEAF_ALLOC_RMT;
> +		fallthrough;
> +	case XFS_DAS_LEAF_ALLOC_RMT:
> +
>  		/*
>  		 * If there was an out-of-line value, allocate the
> blocks we
>  		 * identified for its storage and copy the value.  This
> is done
>  		 * after we create the attribute so that we don't
> overflow the
>  		 * maximum size of a transaction and/or hit a deadlock.
>  		 */
> -
> -		/* Open coded xfs_attr_rmtval_set without trans
> handling */
> -		if ((attr->xattri_flags & XFS_DAC_LEAF_ADDNAME_INIT) ==
> 0) {
> -			attr->xattri_flags |=
> XFS_DAC_LEAF_ADDNAME_INIT;
> -			if (args->rmtblkno > 0) {
> -				error =
> xfs_attr_rmtval_find_space(attr);
> +		if (args->rmtblkno > 0) {
> +			if (attr->xattri_blkcnt > 0) {
> +				error = xfs_attr_rmtval_set_blk(attr);
>  				if (error)
>  					return error;
> +				trace_xfs_attr_set_iter_return(
> +						attr-
> >xattri_dela_state,
> +						args->dp);
> +				return -EAGAIN;
>  			}
> -		}
>  
> -		/*
> -		 * Repeat allocating remote blocks for the attr value
> until
> -		 * blkcnt drops to zero.
> -		 */
> -		if (attr->xattri_blkcnt > 0) {
> -			error = xfs_attr_rmtval_set_blk(attr);
> +			error = xfs_attr_rmtval_set_value(args);
>  			if (error)
>  				return error;
> -			trace_xfs_attr_set_iter_return(attr-
> >xattri_dela_state,
> -						       args->dp);
> -			return -EAGAIN;
>  		}
>  
> -		error = xfs_attr_rmtval_set_value(args);
> -		if (error)
> -			return error;
> -
>  		/*
>  		 * If this is not a rename, clear the incomplete flag
> and we're
>  		 * done.
> @@ -547,15 +548,15 @@ xfs_attr_set_iter(
>  				return error;
>  		}
>  
> +		attr->xattri_dela_state = XFS_DAS_NODE_ALLOC_RMT;
>  		fallthrough;
> -	case XFS_DAS_ALLOC_NODE:
> +	case XFS_DAS_NODE_ALLOC_RMT:
>  		/*
>  		 * If there was an out-of-line value, allocate the
> blocks we
>  		 * identified for its storage and copy the value.  This
> is done
>  		 * after we create the attribute so that we don't
> overflow the
>  		 * maximum size of a transaction and/or hit a deadlock.
>  		 */
> -		attr->xattri_dela_state = XFS_DAS_ALLOC_NODE;
>  		if (args->rmtblkno > 0) {
>  			if (attr->xattri_blkcnt > 0) {
>  				error = xfs_attr_rmtval_set_blk(attr);
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index fc2a177f6994..184dca735cf3 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -451,11 +451,12 @@ enum xfs_delattr_state {
>  	XFS_DAS_RM_NAME,		/* Remove attr name */
>  	XFS_DAS_RM_SHRINK,		/* We are shrinking the tree
> */
>  	XFS_DAS_FOUND_LBLK,		/* We found leaf blk for attr
> */
> +	XFS_DAS_LEAF_ALLOC_RMT,		/* We are allocating remote
> blocks */
>  	XFS_DAS_FOUND_NBLK,		/* We found node blk for attr
> */
> +	XFS_DAS_NODE_ALLOC_RMT,		/* We are allocating remote
> blocks */
>  	XFS_DAS_FLIP_LFLAG,		/* Flipped leaf INCOMPLETE
> attr flag */
>  	XFS_DAS_RM_LBLK,		/* A rename is removing leaf blocks
> */
>  	XFS_DAS_RD_LEAF,		/* Read in the new leaf */
> -	XFS_DAS_ALLOC_NODE,		/* We are allocating node
> blocks */
>  	XFS_DAS_FLIP_NFLAG,		/* Flipped node INCOMPLETE
> attr flag */
>  	XFS_DAS_RM_NBLK,		/* A rename is removing node blocks
> */
>  	XFS_DAS_CLR_FLAG,		/* Clear incomplete flag */
> @@ -471,11 +472,12 @@ enum xfs_delattr_state {
>  	{ XFS_DAS_RM_NAME,	"XFS_DAS_RM_NAME" }, \
>  	{ XFS_DAS_RM_SHRINK,	"XFS_DAS_RM_SHRINK" }, \
>  	{ XFS_DAS_FOUND_LBLK,	"XFS_DAS_FOUND_LBLK" }, \
> +	{ XFS_DAS_LEAF_ALLOC_RMT, "XFS_DAS_LEAF_ALLOC_RMT" }, \
>  	{ XFS_DAS_FOUND_NBLK,	"XFS_DAS_FOUND_NBLK" }, \
> +	{ XFS_DAS_NODE_ALLOC_RMT, "XFS_DAS_NODE_ALLOC_RMT" },  \
>  	{ XFS_DAS_FLIP_LFLAG,	"XFS_DAS_FLIP_LFLAG" }, \
>  	{ XFS_DAS_RM_LBLK,	"XFS_DAS_RM_LBLK" }, \
>  	{ XFS_DAS_RD_LEAF,	"XFS_DAS_RD_LEAF" }, \
> -	{ XFS_DAS_ALLOC_NODE,	"XFS_DAS_ALLOC_NODE" }, \
>  	{ XFS_DAS_FLIP_NFLAG,	"XFS_DAS_FLIP_NFLAG" }, \
>  	{ XFS_DAS_RM_NBLK,	"XFS_DAS_RM_NBLK" }, \
>  	{ XFS_DAS_CLR_FLAG,	"XFS_DAS_CLR_FLAG" }, \
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 9fc3fe334b5f..8739cc1e0561 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -4106,11 +4106,12 @@ TRACE_DEFINE_ENUM(XFS_DAS_RMTBLK);
>  TRACE_DEFINE_ENUM(XFS_DAS_RM_NAME);
>  TRACE_DEFINE_ENUM(XFS_DAS_RM_SHRINK);
>  TRACE_DEFINE_ENUM(XFS_DAS_FOUND_LBLK);
> +TRACE_DEFINE_ENUM(XFS_DAS_LEAF_ALLOC_RMT);
>  TRACE_DEFINE_ENUM(XFS_DAS_FOUND_NBLK);
> +TRACE_DEFINE_ENUM(XFS_DAS_NODE_ALLOC_RMT);
>  TRACE_DEFINE_ENUM(XFS_DAS_FLIP_LFLAG);
>  TRACE_DEFINE_ENUM(XFS_DAS_RM_LBLK);
>  TRACE_DEFINE_ENUM(XFS_DAS_RD_LEAF);
> -TRACE_DEFINE_ENUM(XFS_DAS_ALLOC_NODE);
>  TRACE_DEFINE_ENUM(XFS_DAS_FLIP_NFLAG);
>  TRACE_DEFINE_ENUM(XFS_DAS_RM_NBLK);
>  TRACE_DEFINE_ENUM(XFS_DAS_CLR_FLAG);

