Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B3ECC433F5
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Apr 2022 01:07:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbiDWBKD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Apr 2022 21:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbiDWBKC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Apr 2022 21:10:02 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4DF81A1D91
        for <linux-xfs@vger.kernel.org>; Fri, 22 Apr 2022 18:07:06 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23MJcp9S019340;
        Sat, 23 Apr 2022 01:07:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=W1jgmZPexZ2gC56U2oODEtT4vCRTaQvDJ0vCG3teXcM=;
 b=F2HcSQ0Mm9noA4pf9aDTVLlLbBcKVbqI00MY5oSAPvKSLPAirlEpZyFypJMPLrvRFJtE
 hOF7wcPv5mSl11naBcW6Ncyt3LbfP+Vacbcz3/gR5ZplZYnq6svtLBRe2NhC6BnrGdFJ
 0ROkrCpBCmMMV0LB8IjkZIwBzvMAjvaEjTVlHVkgMF0LCsJcBIg2rnE7qc+BzqR3ZkdS
 uNJnT10Zk/EMBvRhKhPtz6mU79ebr2LZnuUy3ww0SmW/udsQp5WLVTh1y6a+iP+p4VdF
 oENonCYEyLH5Glu5C33wDQB2nYFHPEDL1v+UVacMhqycJPKg6CsGrJEyNifgytMIRs30 Ew== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffm7cyk5f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Apr 2022 01:07:05 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23N16vPV007748;
        Sat, 23 Apr 2022 01:07:04 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2040.outbound.protection.outlook.com [104.47.56.40])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3ffm8bttmr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Apr 2022 01:07:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SsSsQMOJBvKAbhM3dxtjAlbdZ5Ft3fKExGPnX/G3JLUesuQGDpVqRUPDq1rul9EaIUjIxrd6Ao3VeKrMuQcthow/IadoaEynfGiOc6YkfPuV85qUJUM3dpwiOlZ1JU3on5QEdJ5Rj3tNmoPNBTnkILQxgEARr6gFE+scL7Bqi2idXTK/M+up6jaFyyE8I9IcIvg5bpCKHD/v5aHeav+tgtGDWjSJYTY5wIRXQX7Z7fpgANiAbZ8njoEJ8IHv66BYeJ5eWkVnaB3WgJggzn1LEcxgJ3Cj24IM5/bV3CUmI2caf16LWaTF2KNaMcFh8V1fhsjHALA5JIpSQwCucufSXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W1jgmZPexZ2gC56U2oODEtT4vCRTaQvDJ0vCG3teXcM=;
 b=P+jwEedEDnZW4NUrgqxPaqJU6GMCGDeUryUszJQxJHdRBRkXxjOzayfXMOC5MD01lhRD05ZVgSvtOktisNXy29R8lhdimggNiTjuzk74TVU/xuEKQQPUxgYfuA4aAig/fHStXZW/G8EmGaBeI7LunjLcAvQzQevB9PRBKTYETe7VZvcQup3HR1KVGhzvdt6uKzXvzUnYRmmf5FYpGfaAuGiFjb64W3BYO4d9wTvV+TBEyBXJ8L8u+jSwuVCyuzUKQxC1gdGIYcSVYXQDPQ4ZKQDhnEFPS39ZT+IjvwjIJsmgAeWaITeGl+ungDWp2p+1DZeSOIkJhMWjmvgaVl+pqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W1jgmZPexZ2gC56U2oODEtT4vCRTaQvDJ0vCG3teXcM=;
 b=iF+uGTZrwJoDzwjND8eFhcKgZSa/UUZt3pvQGYK9I8okCIWEL5nwU56enApxABAOUxcOSfPDYIEUJY/bB/y/tEd16JV3IxZZdxvsLnT+WZEpIAU5paXzcGlU8JBoxU3supVp7y3aUyLy4VKB+AdOqBQmVEgBic/eAZWJnsuOPXI=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by MWHPR10MB1949.namprd10.prod.outlook.com (2603:10b6:300:10c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Sat, 23 Apr
 2022 01:07:02 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f%9]) with mapi id 15.20.5186.018; Sat, 23 Apr 2022
 01:07:02 +0000
Message-ID: <26523e695e8feab57166545121e4b481cb5e2cbf.camel@oracle.com>
Subject: Re: [PATCH 09/16] xfs: remote xattr removal in xfs_attr_set_iter()
 is conditional
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Fri, 22 Apr 2022 18:07:01 -0700
In-Reply-To: <20220414094434.2508781-10-david@fromorbit.com>
References: <20220414094434.2508781-1-david@fromorbit.com>
         <20220414094434.2508781-10-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0001.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::14) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d8f9400-a50d-4a16-5503-08da24c5933d
X-MS-TrafficTypeDiagnostic: MWHPR10MB1949:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB19499DA76C84EE1D1D5B9D1695F69@MWHPR10MB1949.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dOD8NFMbs68DJZeX7FlhdzIR/Hhozkg70mDfqYIdLLYFyrKRaQuNbvxUNGkQ3gkh5mAmEcYJ9hfZJOKa//USK47RUDv2TnmHJcuMh7y4xMCI+C7+BGhtaOuuHrsC3DnQkivjSdYgNtJ31iVzKZXe1u+YaFodUiHZhVy+s//+jVgGLEOHpnB9CUc0DxS5xSDuF9Y6FtKaxfzBVX38b7M7A9zsxvv41GWm1q816+ioBjwI+JiGis96ZVT4k6CqOpY6fjSodjjeOEdeQjXboF0tH3GrDog76lxyfox4LZpD0HdjotnSIQlMzA3xPMB5M4d+gl2PeJGnA7H1bTcFOBLmxK8jaDvIhwUyKlYZCrMFpDrCyak8/84NNPmgTzKn0+q8u440xfu9SrFqBLWhHkxbFDcDz5ZPi7KUZgnMMLGQ2YqiOlT2cgzWsdst3Om2W2eRFOjxOiqnxDw0rXsZ2YBIf2Wg83pywce3ffPri4DJgHjKbBVQsb2s0v2peKeag0IPyBABT3MkIfHXvhuaorW16OOlxfaF5DkRRt/geas/p4mUV3xc8iM74gtjZz98vFRpHq8/OOCpV6lvyVslKSfdPchsecU9rHHmofueU2uvgnPLk2lYj7+Bm/5ILCB3zFiC5xKaO0uX1mLwPvdIPpcHCUtLSGSH9N1DO0RjT4FZDdCT5oR61n4x+Vr3yZra393MBBwx8NOqyrpmm+zq2a7YNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(52116002)(6512007)(2906002)(8936002)(26005)(316002)(8676002)(66476007)(66556008)(66946007)(38350700002)(86362001)(38100700002)(5660300002)(2616005)(6506007)(186003)(508600001)(6486002)(83380400001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VU9tRCt0YUhscDhCTUxHVFBSQ3kzZ1FsWS9qQ1FBTnNwRGR6RWxUL2VnVHNk?=
 =?utf-8?B?T3N4RkVKTUdlUElUYWtWQ3lnSmZYL01nc1BBL3o1M3BHZUxNVXEwYnhPd1ln?=
 =?utf-8?B?NGpTTnRWbVh1SXJzNCsxZ005ZkhmaXNqZWI3NmRQOTdMMk9QNDlXZ2VUNFVo?=
 =?utf-8?B?dG5tNjZTR0VQYjNwbDZzRWZlSk9hb3dCMm03ZlVUOFV2eTc3RTVOOXNhVkxK?=
 =?utf-8?B?UjRoa1JWczVMQ29rS2svK3JxRWtJM0xLSndGVlpPaVNiNU92WTlOQm1KSzBI?=
 =?utf-8?B?NGI1ZXNZaCtxRERPSVZaTDc1L1Yrc1FydGFCQmJ1NkxURU5tNjdYS1d2UVNj?=
 =?utf-8?B?eFlFUEZnZGx2MVpqUWRweUFkZytBd1gxbUdVYjdlWDJ3em9Nb3I1bU5iNEZn?=
 =?utf-8?B?NjhFc2FPWDJBVFZQQU9Bd0pYc0VYMi9rb2VlZXlVaFFKMlNnUlBWWUNKbkRV?=
 =?utf-8?B?eDhSVDNwdzlXVVdHRENZZVVqSUk5akgycmNUTUtienF5SFlzZU1JUDh6ZXFi?=
 =?utf-8?B?UmJnSmZDTDFRUkFLVHN6QjNuSURwamMwTlpSWjlLc3IxQ0syaWc4NnZSbDl1?=
 =?utf-8?B?a3dxNzdiT3lNRkVweWt2eVhhUk1IdXNBSC9ZT2xoOTJFY044akJPMExxMnZ0?=
 =?utf-8?B?c1QxNHgrL3hGbm9rb0lBc21wTStCWkZuYkN5QkNZR2ErYm9vL3pnV2FJSUhC?=
 =?utf-8?B?NnVneCtnd2p5dVM5UFdlZUR4WThZM3pRQ0duc3BJRitSeEFpa2RrdTNycTh6?=
 =?utf-8?B?UVZSZUFDWGNITXY2U21hWG1XRUc0SjJSMXZwRzV5RXBlVkhmTmNjMWZNTG9u?=
 =?utf-8?B?OWsvOTZWNTBSVzRBVTIyb1lIQi9YTk5HWE02Vld6VlpvMjg3Mnp4NGNvRkxq?=
 =?utf-8?B?R3NieVI4N2RERXEyWnJmSlc3Rlp3QXNOTXdpMnU2K3pBWDNmcGl2ME84V2ZR?=
 =?utf-8?B?aVZlY3dpZDVzemhVWXJBQ2JucUlVN080TXlUdy94eWp6YjlLNjVnWXRvOXpQ?=
 =?utf-8?B?V21vMHI4VkdYZ0hwRFZNUXdRWmVnYnEvbW1MeTFiNUxsWVJQak45U1lhVXJO?=
 =?utf-8?B?YmcyZWRYK2o5ZmJFVCtYTllSL0xyQ2hnOWIyc3NKazBzRVJsZTU3ZzNzSDll?=
 =?utf-8?B?RUdlTnVIYUNPTTRoNmQ3UmNwNktjTWVaL2hxeTBGakpOcXVjdzJjV0R6V1Ft?=
 =?utf-8?B?MUVXb1BBV256elRsdzZJQWRaQW9zcFBYaHBmV2taWk5DQkx2K0cySEdZM1Ri?=
 =?utf-8?B?TEV4dmNNVzZmMFQzaCtnTGpaa3l2eTV5NHJ6VkF4cTRoRnAySDFOKzlCcnJm?=
 =?utf-8?B?WFpOTE83anhsRldybElBWjhiQ0txSEs0UjlSRUVtN1ZVTllBNzhmUDRvb1Br?=
 =?utf-8?B?aWRmNTJOMU9MaXNzVStkaG1SOHUwaTBUUFR5QjlQbnp4OEZST3VlRU9iWmFP?=
 =?utf-8?B?SVEzeXV2S3RsUTY0NW95YmtHTi9sZjl6alVTbmFVTlZpSUgyS3BVZ0hUb1pR?=
 =?utf-8?B?b1d6dHZkeGg0MHBPN3lSbGJrWGZBWC9hTHdMK3Z2T2ZJNCt1cnN5TDBpZWhT?=
 =?utf-8?B?MUxvRmlrNXhqT3hUcWYwY0JnYW9HWm9OYVVrREZSNUg5RGkrTjY5Q2FDcmIx?=
 =?utf-8?B?Y3dCWURYMU5lUWg2aTM3WGY2MW41dUdoc1JpM1VYMVc3QVdBTEJvSHNWOEQ1?=
 =?utf-8?B?UW1KaU4yOTNralRLNzNXRWlWM3ZHNCtJOGVZMU1wVjlrN0kyTTZHbzJrN2pm?=
 =?utf-8?B?TUE4SWRjajB1RklQZUZURVVDOVdmUnA5NWNwWjRSbU5CSURoVXljT09PUkhY?=
 =?utf-8?B?QmZGRmp5NVduSGhOMVhqTXNuVHRtek1ISzlCd2ZEK3ZrQjFzVGRTQSt0MXJl?=
 =?utf-8?B?MVBBMnpWcjVMTHJsODhybGE2UjBISWpGMmZwWjBEMjk2eTh1ZC9tOVhRSTZS?=
 =?utf-8?B?TmlxcVlldW9USE1nSnhlSk1SeGgydHl4RmFNd2thZUFiQTRrZExkVk1EZUVU?=
 =?utf-8?B?aERvZ09EdU1WajNCeWpVdEFhMzg3ekZrVzZFYTlDUTZzMko1eGUxcjd6MjBh?=
 =?utf-8?B?ckFyRGhaNXB3d3NLZU1xYmJ4TW4rSCt4b2U5cU51TG5adTNwNklKV3ptQjhl?=
 =?utf-8?B?cjBYLy9tY21wb0ZLb0ZqcDE0eHQvMWI4N1ZwNm5hb1NNcUQ0UUMvYXg1SFdn?=
 =?utf-8?B?eElXREdwaEFkMGJ1dG1BZGFTc0s5UCttbXc3ckRnTjBSckF6d0pmWE5IL2R2?=
 =?utf-8?B?aVBPSVBqT3J4bnArL3E2WkJUNi9rWkhOcXNjeTVoQlVwZVFOUVovQVYxYVMw?=
 =?utf-8?B?UjZrTDdDYmp3RHFSZUxVSXJ5T1ZvdjhaZjhRS2FqbXZ5bU5SOElES1Z3RXA5?=
 =?utf-8?Q?1+yjb9WQP+64kCLo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d8f9400-a50d-4a16-5503-08da24c5933d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2022 01:07:02.5179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: POqnItWeTBB2qUc5HfGdLK7iMy7/3EGGTsGD/2IB1Pm03/fDXex2Pz/OrMEaY9MD/Luer95nzLbZmQOoMH+pXCEdBIbTQsyLfpbcV1zsCZM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1949
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-22_07:2022-04-22,2022-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=999 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204230003
X-Proofpoint-GUID: f5Gg1X0EjzlUl5KNt-Sz35AyBeNLtNLX
X-Proofpoint-ORIG-GUID: f5Gg1X0EjzlUl5KNt-Sz35AyBeNLtNLX
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 2022-04-14 at 19:44 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We may not have a remote value for the old xattr we have to remove,
> so skip over the remote value removal states and go straight to
> the xattr name removal in the leaf/node block.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
Ok, I can follow it.  I may try and think of a new way to try and
illustrate it though as it is not nearly as linear as it used to be,
but I don't think that's a bad thing.  

Reviewed-by: Allison Henderson<allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 59 ++++++++++++++++++++----------------
> ----
>  fs/xfs/libxfs/xfs_attr.h |  8 +++---
>  fs/xfs/xfs_trace.h       |  4 +--
>  3 files changed, 36 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index c72f98794bb3..8762d3a0605a 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -510,15 +510,14 @@ xfs_attr_set_iter(
>  		/*
>  		 * We must "flip" the incomplete flags on the "new" and
> "old"
>  		 * attribute/value pairs so that one disappears and one
> appears
> -		 * atomically.  Then we must remove the "old"
> attribute/value
> -		 * pair.
> +		 * atomically.
>  		 */
>  		error = xfs_attr3_leaf_flipflags(args);
>  		if (error)
>  			return error;
>  		/*
> -		 * Commit the flag value change and start the next
> trans
> -		 * in series at REMOVE_OLD.
> +		 * We must commit the flag value change now to make it
> atomic
> +		 * and then we can start the next trans in series at
> REMOVE_OLD.
>  		 */
>  		error = -EAGAIN;
>  		attr->xattri_dela_state++;
> @@ -527,41 +526,43 @@ xfs_attr_set_iter(
>  	case XFS_DAS_LEAF_REMOVE_OLD:
>  	case XFS_DAS_NODE_REMOVE_OLD:
>  		/*
> -		 * Dismantle the "old" attribute/value pair by removing
> a
> -		 * "remote" value (if it exists).
> +		 * If we have a remote attr, start the process of
> removing it
> +		 * by invalidating any cached buffers.
> +		 *
> +		 * If we don't have a remote attr, we skip the remote
> block
> +		 * removal state altogether with a second state
> increment.
>  		 */
>  		xfs_attr_restore_rmt_blk(args);
> -		error = xfs_attr_rmtval_invalidate(args);
> -		if (error)
> -			return error;
> -
> -		attr->xattri_dela_state++;
> -		fallthrough;
> -	case XFS_DAS_RM_LBLK:
> -	case XFS_DAS_RM_NBLK:
>  		if (args->rmtblkno) {
> -			error = xfs_attr_rmtval_remove(attr);
> -			if (error == -EAGAIN)
> -				trace_xfs_attr_set_iter_return(
> -					attr->xattri_dela_state, args-
> >dp);
> +			error = xfs_attr_rmtval_invalidate(args);
>  			if (error)
>  				return error;
> -
> -			attr->xattri_dela_state = XFS_DAS_RD_LEAF;
> -			trace_xfs_attr_set_iter_return(attr-
> >xattri_dela_state,
> -						       args->dp);
> -			return -EAGAIN;
> +		} else {
> +			attr->xattri_dela_state++;
>  		}
>  
> +		attr->xattri_dela_state++;
> +		goto next_state;
> +
> +	case XFS_DAS_LEAF_REMOVE_RMT:
> +	case XFS_DAS_NODE_REMOVE_RMT:
> +		error = xfs_attr_rmtval_remove(attr);
> +		if (error == -EAGAIN)
> +			break;
> +		if (error)
> +			return error;
> +
>  		/*
> -		 * This is the end of the shared leaf/node sequence. We
> need
> -		 * to continue at the next state in the sequence, but
> we can't
> -		 * easily just fall through. So we increment to the
> next state
> -		 * and then jump back to switch statement to evaluate
> the next
> -		 * state correctly.
> +		 * We've finished removing the remote attr blocks, so
> commit the
> +		 * transaction and move on to removing the attr name
> from the
> +		 * leaf/node block. Removing the attr might require a
> full
> +		 * transaction reservation for btree block freeing, so
> we
> +		 * can't do that in the same transaction where we
> removed the
> +		 * remote attr blocks.
>  		 */
> +		error = -EAGAIN;
>  		attr->xattri_dela_state++;
> -		goto next_state;
> +		break;
>  
>  	case XFS_DAS_RD_LEAF:
>  		/*
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index a4ff0a2305d6..18e157bf19cb 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -456,7 +456,7 @@ enum xfs_delattr_state {
>  	XFS_DAS_LEAF_ALLOC_RMT,		/* We are allocating remote
> blocks */
>  	XFS_DAS_LEAF_REPLACE,		/* Perform replace ops on a
> leaf */
>  	XFS_DAS_LEAF_REMOVE_OLD,	/* Start removing old attr from leaf
> */
> -	XFS_DAS_RM_LBLK,		/* A rename is removing leaf blocks
> */
> +	XFS_DAS_LEAF_REMOVE_RMT,	/* A rename is removing remote blocks
> */
>  	XFS_DAS_RD_LEAF,		/* Read in the new leaf */
>  
>  	/* Node state set sequence, must match leaf state above */
> @@ -464,7 +464,7 @@ enum xfs_delattr_state {
>  	XFS_DAS_NODE_ALLOC_RMT,		/* We are allocating remote
> blocks */
>  	XFS_DAS_NODE_REPLACE,		/* Perform replace ops on a
> node */
>  	XFS_DAS_NODE_REMOVE_OLD,	/* Start removing old attr from node
> */
> -	XFS_DAS_RM_NBLK,		/* A rename is removing node blocks
> */
> +	XFS_DAS_NODE_REMOVE_RMT,	/* A rename is removing remote blocks
> */
>  	XFS_DAS_CLR_FLAG,		/* Clear incomplete flag */
>  
>  	XFS_DAS_DONE,			/* finished operation */
> @@ -482,13 +482,13 @@ enum xfs_delattr_state {
>  	{ XFS_DAS_LEAF_ALLOC_RMT,	"XFS_DAS_LEAF_ALLOC_RMT" }, \
>  	{ XFS_DAS_LEAF_REPLACE,		"XFS_DAS_LEAF_REPLACE" }, \
>  	{ XFS_DAS_LEAF_REMOVE_OLD,	"XFS_DAS_LEAF_REMOVE_OLD" },
> \
> -	{ XFS_DAS_RM_LBLK,		"XFS_DAS_RM_LBLK" }, \
> +	{ XFS_DAS_LEAF_REMOVE_RMT,	"XFS_DAS_LEAF_REMOVE_RMT" },
> \
>  	{ XFS_DAS_RD_LEAF,		"XFS_DAS_RD_LEAF" }, \
>  	{ XFS_DAS_NODE_SET_RMT,		"XFS_DAS_NODE_SET_RMT" }, \
>  	{ XFS_DAS_NODE_ALLOC_RMT,	"XFS_DAS_NODE_ALLOC_RMT" },  \
>  	{ XFS_DAS_NODE_REPLACE,		"XFS_DAS_NODE_REPLACE" },  \
>  	{ XFS_DAS_NODE_REMOVE_OLD,	"XFS_DAS_NODE_REMOVE_OLD" },
> \
> -	{ XFS_DAS_RM_NBLK,		"XFS_DAS_RM_NBLK" }, \
> +	{ XFS_DAS_NODE_REMOVE_RMT,	"XFS_DAS_NODE_REMOVE_RMT" },
> \
>  	{ XFS_DAS_CLR_FLAG,		"XFS_DAS_CLR_FLAG" }, \
>  	{ XFS_DAS_DONE,			"XFS_DAS_DONE" }
>  
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index a4b99c7f8ef0..91852b9721e4 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -4109,13 +4109,13 @@ TRACE_DEFINE_ENUM(XFS_DAS_LEAF_SET_RMT);
>  TRACE_DEFINE_ENUM(XFS_DAS_LEAF_ALLOC_RMT);
>  TRACE_DEFINE_ENUM(XFS_DAS_LEAF_REPLACE);
>  TRACE_DEFINE_ENUM(XFS_DAS_LEAF_REMOVE_OLD);
> -TRACE_DEFINE_ENUM(XFS_DAS_RM_LBLK);
> +TRACE_DEFINE_ENUM(XFS_DAS_LEAF_REMOVE_RMT);
>  TRACE_DEFINE_ENUM(XFS_DAS_RD_LEAF);
>  TRACE_DEFINE_ENUM(XFS_DAS_NODE_SET_RMT);
>  TRACE_DEFINE_ENUM(XFS_DAS_NODE_ALLOC_RMT);
>  TRACE_DEFINE_ENUM(XFS_DAS_NODE_REPLACE);
>  TRACE_DEFINE_ENUM(XFS_DAS_NODE_REMOVE_OLD);
> -TRACE_DEFINE_ENUM(XFS_DAS_RM_NBLK);
> +TRACE_DEFINE_ENUM(XFS_DAS_NODE_REMOVE_RMT);
>  TRACE_DEFINE_ENUM(XFS_DAS_CLR_FLAG);
>  
>  DECLARE_EVENT_CLASS(xfs_das_state_class,

