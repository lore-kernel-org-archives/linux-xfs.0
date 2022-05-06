Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DD09C433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  6 May 2022 23:44:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359057AbiEFXsI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 May 2022 19:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445018AbiEFXsG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 May 2022 19:48:06 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D41E712D5
        for <linux-xfs@vger.kernel.org>; Fri,  6 May 2022 16:44:21 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 246KM4Eu013484;
        Fri, 6 May 2022 23:44:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=ZacNlrvEpiH7oCsKFXF92xKNHk9ox+d98fmXaWXGezw=;
 b=WeSl9Ec+qx7H3OpPIvZW6Ehy++qJq/PUTMftNANz8eR40+MAFMfdxlultxOPI1j+d2F7
 zukE+8NBy4WtLhQtjhtCitETr3HjsUiI5mOoU64PDluH0EmiLLemSOEHB3nnB1Xs3S+O
 8p7Q3Vd+gQ+WJWouQ1p2L6xYCigaOpcHdi8MXqZshUeT7v+5oOvnUB8JXzY1/wVXXaVV
 +EN491ia40sOkC83omEFbehdb+TbiZvczsNOyJzdSC9S8Ml9DXjNQpO7vsiydTJ5yZRv
 N8Fd4oo09EMEmOwlLD6r3SrWU9hjV3ipz5mI6Ef3e1i7v889eKDzLw+SQ9wUpLZ6PU45 Aw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3frvqsqbhy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 May 2022 23:44:20 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 246NZHeO033292;
        Fri, 6 May 2022 23:44:20 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3frujcg0ny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 May 2022 23:44:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gGT8kdMFtOjTOyw7xiZuUuASr5QnC8DtA9DG1E2HJ2UOvtWqCfXrK5hEiFG5C7+dXl4bUN6So2PzUudJ5ZybaB2V7ePQilS+1ImJmPeZVpX8EsPjWu+YjJMu9uj3ZMOfu2HpUJULdxOAoggLKvCzSmdNW0Cpb+H0tHO1Kl4Xy+p92M4lmUNxbRaCqZ9sBCVfexnqwGNrBZgkWPa1XmVah4X4KmsDEUrHBvC0rPXfl3iAJ6mQIy2M1+rt9PXfUr82GOme4PWhSxxLUkN8xE6iRAEriMcRBguNrxiRZ0fQPUJeV9W6/YG20OL8mKiS2ulxwwM3OJcXMkjQIbMGip0ILg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZacNlrvEpiH7oCsKFXF92xKNHk9ox+d98fmXaWXGezw=;
 b=oQzL29gatdCjMWA9kNC2oSjSJB8yushcDsYOMOGRM6zpoNCscD5/im60KJBTzDp1kTTAOyVr/Rkt3MCeiRShEsy+bW8Mx3OdnV6kZ1ijbxcdIZIjMYllOqxsNHYbBs2RrhRqN/7OjlanQpSOJVrFwngy5Kouv+6EoV50j/REoCYcCbkFlQXsE7CWWJ4nmVu/HsaCn/MiO/b7O8s6r6TgHPtxkREL/9iUkQ708AO9yWq/4fL8d342Jt0qR6CM8RhAkJYiMRAWr5hhrx+eeC3n2BFU4Rt3rxWmEhG4mDt+fTmvOGeOsPV6dsdtgwkiM2lJCPw5S6YnwYxvv7DTf46Ocg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZacNlrvEpiH7oCsKFXF92xKNHk9ox+d98fmXaWXGezw=;
 b=t/QeUBVHBl4DTr0/7HwSvWIHWm8Qdpx9t22I2BdDFiyymdIx+w8Q2/4pzUpzHdA80AcUJEQ26PBSCbgLBRKC8gqbyVODKjx7Xw0+BSQfgc8x8croNC0O7qXMSnGCsOmdphlmJF3mywgDXFwlUCLhEVVba/PzbfgahPE3Gtpt2u0=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3761.namprd10.prod.outlook.com (2603:10b6:a03:1ff::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Fri, 6 May
 2022 23:44:18 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f%8]) with mapi id 15.20.5227.020; Fri, 6 May 2022
 23:44:18 +0000
Message-ID: <f1bbd319456656f1bfa61ad71ffb87cbd12a7edd.camel@oracle.com>
Subject: Re: [PATCH 09/17] xfs: XFS_DAS_LEAF_REPLACE state only needed if
 !LARP
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Fri, 06 May 2022 16:44:16 -0700
In-Reply-To: <20220506094553.512973-10-david@fromorbit.com>
References: <20220506094553.512973-1-david@fromorbit.com>
         <20220506094553.512973-10-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0336.namprd03.prod.outlook.com
 (2603:10b6:8:55::20) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 59093389-62c4-4a28-b149-08da2fba564d
X-MS-TrafficTypeDiagnostic: BY5PR10MB3761:EE_
X-Microsoft-Antispam-PRVS: <BY5PR10MB3761EA64AEC3464104B8714B95C59@BY5PR10MB3761.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5Wg+RZ3lHc2eLoKwP8Rx+z86bC9iWIlp09TsRJX5kX2IXcT+Kl2JAtgvoEzMuAQiO1ZOoLJkROq3Vywl/xEyHCK+7ZsDHTfHTojyaXo+NkKaawibvp4kO/npH4Y/uiWr/DCEpoldcRhWqybIdUmK/5cea1Y73ohHIBLpQXkuuIjsWfdJRcbl0vL9Sr9IUkgfwcxSY8dgJsWvYjNIWGSLeq8Drf1FvZnDapywNqnyJ1Lw9huqLwe2k9W/Qhlenyv1RAERYfdQYTnCrIFHL++Y6hdXi5+fB+1ucj12B9Db3YrRyAPU0NA41ybJ7UH/TCV4Jij5sz1gZHeeqBHAbh3GSfkeAtAmy37iPuEu3GXPsBNvRsfTUQ9/Opuieogi0Z9B90vsHSz5DXRrNU5nIB3P8TQY+8QJS0YXT5RBBRMtT1BxBtSMbIuZcPfjmppiVVTjbYsZhf16vRLMzJUj2qIJEyqVL2zML7Usjb41MR25SBFfibmmxmuraYD4L0ka2WXKebiaR+kdo/2t9O0xP/MUJ1E8aqRgyF+QfA3pt0e2E+lNNlbhwfhtHzzwweJtpJvyQJOeA+LqCWRvbV6qhBdOWn7mwKZnSstLGKm9Dd7nX1UmZRB4402LZVk9SRmyeOB8IOJ/p/uwCHjTIHvjy2KC7n8hIIoe8iRfnHTjGr5/Y+9BvN8rOIjd609ZVACOwpHlBIdlk631LSxECo21lchDkQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(38350700002)(5660300002)(186003)(6486002)(38100700002)(8676002)(66556008)(66946007)(66476007)(2616005)(508600001)(2906002)(6512007)(6506007)(26005)(316002)(36756003)(86362001)(52116002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NmtJWG1VRW9VekZIQnNyRlVnd3RoaWY5aEUzMFNiY21XdVZKdDRTTXB0RjIr?=
 =?utf-8?B?OXJaMy9pQjVyTm5JOHpna0VJSlR0OWdTVWFZcGlOVS92OWxNWGF5c1M3WEZE?=
 =?utf-8?B?RXBxNmt1MlpwcEpUQjBrNDhRRlI4WFZub0xwWFhzd29zcC9sWUdaRWhKaEZw?=
 =?utf-8?B?eVZpUU9LVlVmcEZ3eVlIOU9zYU9NY2pwVXlGd05MdEFNN2gwQjlLQlJGTk5J?=
 =?utf-8?B?SG16dkx2VU9heXFEQnU2NmJRRTZPWDdJQTVyd2xPNHVVNmhTRnloV1pHZzR6?=
 =?utf-8?B?bjgxRkhzU1o2MG4wUHoxa0VoUllLZ2J2NmcyUk94UTVQRTFlMVZ0Z1FrMnUy?=
 =?utf-8?B?SHp3a2xncEV2d2pHQ3dTdTJCQmtyckNES3lBNTlMQmVtN3R6WVNtQzMvdldU?=
 =?utf-8?B?RTFqVUpvRTBYa2NjN2RBOVVyRkJ5MWhseTlTanlsTUh2dFlLbTE1NGU0Vkpi?=
 =?utf-8?B?YTNJNU93VE1qRTNrYXlhMnZoeUk2Tk5DZmFQTGhJd09qeHNSSjVPeHFvWnpa?=
 =?utf-8?B?NzZORGR4cHBraHJrbzlBYmFnbkVya0k0MEpYNExUZExXYnNOTms0VzhFdHd0?=
 =?utf-8?B?dkVuT1YyekNkWGV3SVVRUHRMTVNiK2ErUFhNYldTRnllbkVPSmJZeWhmSi9i?=
 =?utf-8?B?R0t0bnZkWlEwQW1JZ0JlRmlnbVhsZ3BDc1F4a0taNW5RdEVVWVV6VzlyWnl5?=
 =?utf-8?B?NnBqNUpsN1B4MzlZZUl2N1VQbkVnRDNvOFpuQXg3T1ZoOVlWaXJ3MytVYk5O?=
 =?utf-8?B?ZG5jNUc1SmQ1ek5Da1V4SmFjcXo2Zlp1WDZJNGlvc1hjeVc3VEhYNmVBN0hZ?=
 =?utf-8?B?NERpTngrNXFNdEk3Z2NqSHZjWi8yMkdZNU5Cbkg2WlZqNWtuMmpJdWdkN2lY?=
 =?utf-8?B?bHFGZGYybklqSWQ3WHNUcUVUZ2M4MVdsVEpCbzZIaFBXOUg4d2kwVHlHN2xr?=
 =?utf-8?B?c0UvMnZML3RCS2pYN2g2SVlCUXJZR0xhYWhlamR3ZW5jcUJySmZDQ0JNRmJv?=
 =?utf-8?B?eml4allvWjJseHpPUk1jR0FIOFlBbGdJWGt1SkVvZDJuSHdKWm0yZytPa05H?=
 =?utf-8?B?bGlLVFJnZk9yNEZhTVVlQXFMNVppN2VQRHlwaTU1ZXhhNXR3N0lIbnBBNTNu?=
 =?utf-8?B?RWEvV2pSOWlEYjZiTEhiS2lSbWt4MUFFd09IT3pVRUFaaGpMQVJUK3hxQmdn?=
 =?utf-8?B?VDhpaEtMU1h0SG5Ta0JEaDdmRi82cW5jaUV1T1JGU2w5Y1NLOVVhdG1xNVBS?=
 =?utf-8?B?NzBNR3kvbzROZ2oyS3c2SFhndUlaU0p5WVg1QzBIbzJmYWJ1VDREZjlaTFlx?=
 =?utf-8?B?SGZpd2lWTE53VG4yeW9MRVc1YSt5bUZrMnl5clc2N24zTDJzb0o1KzZEUnh0?=
 =?utf-8?B?VjR4ajFDa2ZsckI1a1pFckZJdG5VS015b2I1Z3ZlWU1ZdDlmcFpkYmZTVDZr?=
 =?utf-8?B?cHkrWHQrODZqWGxaSXh4dGEwYVJyRXdRWmlvSGFyQlFxb0t3L1ZlV2k0ZXV6?=
 =?utf-8?B?TXNuemRZVGFGdEU0eFVTc0FrOTlOZ21EUjJnQ0tFSklKVFhIdmdCSUZOdlNw?=
 =?utf-8?B?c3ZYelRLRWU5NzU5bmF5RmE2QjBmc3ZEbHJYeUxXcDFoWW9oUnlSVkU4cDNx?=
 =?utf-8?B?Nmx3c2t4WWRxcnFZZ3NrRDV1S3QrWWhydlpTOW1rcm92RElMSUIveFRaalZE?=
 =?utf-8?B?SWlKMmxJYWhDUU50TFE4Q0t1WmxtQ2ZyUm1pbGU5TkxYSm9aSW4xai9zRDFH?=
 =?utf-8?B?bWoybFU4aElyZEREZmZKbFE2SWFYVFE0U3NWVmNzZ3VMOVdXbk0zcjNEelBh?=
 =?utf-8?B?SFdkNXNXMXZJS2RLMGtEZFUzcWNXL2Y1Ti9hT0xVSkpvdWlxeUovRUJyY0p3?=
 =?utf-8?B?WXduR1hxQ01LalRETmpYVUhNK3R0WWJ4VHZoMmZGK3ptdnQvTEVFNU43alFy?=
 =?utf-8?B?L29kclhSUDR1OS84clJvVkNCdVBpa0hpYndCTVdyZHpxUnJyMTczVVYzWGh2?=
 =?utf-8?B?WUhGSlhWbnlGSGgvdUJYbzhQK29ZOEtTTU4za0Z0YURuTllnbG4wazNPbU5X?=
 =?utf-8?B?UVNxRTZjbHk0Q3ZnenB4SXdBMEpqdWxXdWEram4vRkpWWFAvZU1Oc0Z4L2tm?=
 =?utf-8?B?a1dENDhHZ0hHRDc1eklnK3lGREF1NXJMcmdSYzN2T252ZVdPekt5NExHUDJj?=
 =?utf-8?B?em5GUVVUd09aNVZwMW5RUGtyMm85dk5uUk5PaTNLVkJuemg0K3JqYWpSM1M5?=
 =?utf-8?B?cE1SODFPSEs5WEM3eUhTTHdRV1AwNlVPSVFjaU1wSEpLUktDc216ejZYZTlG?=
 =?utf-8?B?d3UyK2RvS3FhODhoYWVOa3ZzRWhKS1krMWY1cWF4ci93NzViUmZhUytJaUhC?=
 =?utf-8?Q?bmTJ2Qo9+ffzJiFU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59093389-62c4-4a28-b149-08da2fba564d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2022 23:44:18.5808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qvb6Fk2ArqjOzBHu2Im37GOJWGyXesIR+n4d9N3dfmXcvGFzazj4e3u9aq7KvQ0vRdgtXgk7CtzcmHZcdn3dNGg+/8QAxIMakn+znJww38k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3761
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-06_07:2022-05-05,2022-05-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205060118
X-Proofpoint-GUID: w3J6hz6yYKohJ7avfLBBaEbNNY-FPexM
X-Proofpoint-ORIG-GUID: w3J6hz6yYKohJ7avfLBBaEbNNY-FPexM
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, 2022-05-06 at 19:45 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We can skip the REPLACE state when LARP is enabled, but that means
> the XFS_DAS_FLIP_LFLAG state is now poorly named - it indicates
> something that has been done rather than what the state is going to
> do. Rename it to "REMOVE_OLD" to indicate that we are now going to
> perform removal of the old attr.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
Ok, looks good now
Reviewed-by: Allison Henderson<allison.henderson@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_attr.c | 81 +++++++++++++++++++++++++-------------
> --
>  fs/xfs/libxfs/xfs_attr.h | 44 +++++++++++-----------
>  fs/xfs/xfs_trace.h       |  4 +-
>  3 files changed, 75 insertions(+), 54 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index d2b29f7e103a..0f4636e2e246 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -296,6 +296,26 @@ xfs_attr_sf_addname(
>  	return error;
>  }
>  
> +/*
> + * When we bump the state to REPLACE, we may actually need to skip
> over the
> + * state. When LARP mode is enabled, we don't need to run the atomic
> flags flip,
> + * so we skip straight over the REPLACE state and go on to
> REMOVE_OLD.
> + */
> +static void
> +xfs_attr_dela_state_set_replace(
> +	struct xfs_attr_item	*attr,
> +	enum xfs_delattr_state	replace)
> +{
> +	struct xfs_da_args	*args = attr->xattri_da_args;
> +
> +	ASSERT(replace == XFS_DAS_LEAF_REPLACE ||
> +			replace == XFS_DAS_NODE_REPLACE);
> +
> +	attr->xattri_dela_state = replace;
> +	if (xfs_has_larp(args->dp->i_mount))
> +		attr->xattri_dela_state++;
> +}
> +
>  static int
>  xfs_attr_leaf_addname(
>  	struct xfs_attr_item	*attr)
> @@ -338,7 +358,7 @@ xfs_attr_leaf_addname(
>  		attr->xattri_dela_state = XFS_DAS_LEAF_SET_RMT;
>  		error = -EAGAIN;
>  	} else if (args->op_flags & XFS_DA_OP_RENAME) {
> -		attr->xattri_dela_state = XFS_DAS_LEAF_REPLACE;
> +		xfs_attr_dela_state_set_replace(attr,
> XFS_DAS_LEAF_REPLACE);
>  		error = -EAGAIN;
>  	} else {
>  		attr->xattri_dela_state = XFS_DAS_DONE;
> @@ -369,7 +389,7 @@ xfs_attr_node_addname(
>  		attr->xattri_dela_state = XFS_DAS_NODE_SET_RMT;
>  		error = -EAGAIN;
>  	} else if (args->op_flags & XFS_DA_OP_RENAME) {
> -		attr->xattri_dela_state = XFS_DAS_NODE_REPLACE;
> +		xfs_attr_dela_state_set_replace(attr,
> XFS_DAS_NODE_REPLACE);
>  		error = -EAGAIN;
>  	} else {
>  		attr->xattri_dela_state = XFS_DAS_DONE;
> @@ -396,8 +416,11 @@ xfs_attr_rmtval_alloc(
>  		error = xfs_attr_rmtval_set_blk(attr);
>  		if (error)
>  			return error;
> -		error = -EAGAIN;
> -		goto out;
> +		/* Roll the transaction only if there is more to
> allocate. */
> +		if (attr->xattri_blkcnt > 0) {
> +			error = -EAGAIN;
> +			goto out;
> +		}
>  	}
>  
>  	error = xfs_attr_rmtval_set_value(args);
> @@ -408,6 +431,13 @@ xfs_attr_rmtval_alloc(
>  	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
>  		error = xfs_attr3_leaf_clearflag(args);
>  		attr->xattri_dela_state = XFS_DAS_DONE;
> +	} else {
> +		/*
> +		 * We are running a REPLACE operation, so we need to
> bump the
> +		 * state to the step in that operation.
> +		 */
> +		attr->xattri_dela_state++;
> +		xfs_attr_dela_state_set_replace(attr, attr-
> >xattri_dela_state);
>  	}
>  out:
>  	trace_xfs_attr_rmtval_alloc(attr->xattri_dela_state, args->dp);
> @@ -429,7 +459,6 @@ xfs_attr_set_iter(
>  	struct xfs_inode		*dp = args->dp;
>  	struct xfs_buf			*bp = NULL;
>  	int				forkoff, error = 0;
> -	struct xfs_mount		*mp = args->dp->i_mount;
>  
>  	/* State machine switch */
>  next_state:
> @@ -459,37 +488,29 @@ xfs_attr_set_iter(
>  			return error;
>  		if (attr->xattri_dela_state == XFS_DAS_DONE)
>  			break;
> -		attr->xattri_dela_state++;
> -		fallthrough;
> +		goto next_state;
>  
>  	case XFS_DAS_LEAF_REPLACE:
>  	case XFS_DAS_NODE_REPLACE:
>  		/*
> -		 * If this is an atomic rename operation, we must
> "flip" the
> -		 * incomplete flags on the "new" and "old"
> attribute/value pairs
> -		 * so that one disappears and one appears
> atomically.  Then we
> -		 * must remove the "old" attribute/value pair.
> -		 *
> -		 * In a separate transaction, set the incomplete flag
> on the
> -		 * "old" attr and clear the incomplete flag on the
> "new" attr.
> +		 * We must "flip" the incomplete flags on the "new" and
> "old"
> +		 * attribute/value pairs so that one disappears and one
> appears
> +		 * atomically.  Then we must remove the "old"
> attribute/value
> +		 * pair.
>  		 */
> -		if (!xfs_has_larp(mp)) {
> -			error = xfs_attr3_leaf_flipflags(args);
> -			if (error)
> -				return error;
> -			/*
> -			 * Commit the flag value change and start the
> next trans
> -			 * in series at FLIP_FLAG.
> -			 */
> -			error = -EAGAIN;
> -			attr->xattri_dela_state++;
> -			break;
> -		}
> -
> +		error = xfs_attr3_leaf_flipflags(args);
> +		if (error)
> +			return error;
> +		/*
> +		 * Commit the flag value change and start the next
> trans
> +		 * in series at REMOVE_OLD.
> +		 */
> +		error = -EAGAIN;
>  		attr->xattri_dela_state++;
> -		fallthrough;
> -	case XFS_DAS_FLIP_LFLAG:
> -	case XFS_DAS_FLIP_NFLAG:
> +		break;
> +
> +	case XFS_DAS_LEAF_REMOVE_OLD:
> +	case XFS_DAS_NODE_REMOVE_OLD:
>  		/*
>  		 * Dismantle the "old" attribute/value pair by removing
> a
>  		 * "remote" value (if it exists).
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 1749fd8f7ddd..3f1234272f3a 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -455,7 +455,7 @@ enum xfs_delattr_state {
>  	XFS_DAS_LEAF_SET_RMT,		/* set a remote xattr from a
> leaf */
>  	XFS_DAS_LEAF_ALLOC_RMT,		/* We are allocating remote
> blocks */
>  	XFS_DAS_LEAF_REPLACE,		/* Perform replace ops on a
> leaf */
> -	XFS_DAS_FLIP_LFLAG,		/* Flipped leaf INCOMPLETE
> attr flag */
> +	XFS_DAS_LEAF_REMOVE_OLD,	/* Start removing old attr from leaf
> */
>  	XFS_DAS_RM_LBLK,		/* A rename is removing leaf blocks
> */
>  	XFS_DAS_RD_LEAF,		/* Read in the new leaf */
>  
> @@ -463,7 +463,7 @@ enum xfs_delattr_state {
>  	XFS_DAS_NODE_SET_RMT,		/* set a remote xattr from a
> node */
>  	XFS_DAS_NODE_ALLOC_RMT,		/* We are allocating remote
> blocks */
>  	XFS_DAS_NODE_REPLACE,		/* Perform replace ops on a
> node */
> -	XFS_DAS_FLIP_NFLAG,		/* Flipped node INCOMPLETE
> attr flag */
> +	XFS_DAS_NODE_REMOVE_OLD,	/* Start removing old attr from node
> */
>  	XFS_DAS_RM_NBLK,		/* A rename is removing node blocks
> */
>  	XFS_DAS_CLR_FLAG,		/* Clear incomplete flag */
>  
> @@ -471,26 +471,26 @@ enum xfs_delattr_state {
>  };
>  
>  #define XFS_DAS_STRINGS	\
> -	{ XFS_DAS_UNINIT,	"XFS_DAS_UNINIT" }, \
> -	{ XFS_DAS_SF_ADD,	"XFS_DAS_SF_ADD" }, \
> -	{ XFS_DAS_LEAF_ADD,	"XFS_DAS_LEAF_ADD" }, \
> -	{ XFS_DAS_NODE_ADD,	"XFS_DAS_NODE_ADD" }, \
> -	{ XFS_DAS_RMTBLK,	"XFS_DAS_RMTBLK" }, \
> -	{ XFS_DAS_RM_NAME,	"XFS_DAS_RM_NAME" }, \
> -	{ XFS_DAS_RM_SHRINK,	"XFS_DAS_RM_SHRINK" }, \
> -	{ XFS_DAS_LEAF_SET_RMT,	"XFS_DAS_LEAF_SET_RMT" }, \
> -	{ XFS_DAS_LEAF_ALLOC_RMT, "XFS_DAS_LEAF_ALLOC_RMT" }, \
> -	{ XFS_DAS_LEAF_REPLACE,	"XFS_DAS_LEAF_REPLACE" }, \
> -	{ XFS_DAS_FLIP_LFLAG,	"XFS_DAS_FLIP_LFLAG" }, \
> -	{ XFS_DAS_RM_LBLK,	"XFS_DAS_RM_LBLK" }, \
> -	{ XFS_DAS_RD_LEAF,	"XFS_DAS_RD_LEAF" }, \
> -	{ XFS_DAS_NODE_SET_RMT,	"XFS_DAS_NODE_SET_RMT" }, \
> -	{ XFS_DAS_NODE_ALLOC_RMT, "XFS_DAS_NODE_ALLOC_RMT" },  \
> -	{ XFS_DAS_NODE_REPLACE,	"XFS_DAS_NODE_REPLACE" },  \
> -	{ XFS_DAS_FLIP_NFLAG,	"XFS_DAS_FLIP_NFLAG" }, \
> -	{ XFS_DAS_RM_NBLK,	"XFS_DAS_RM_NBLK" }, \
> -	{ XFS_DAS_CLR_FLAG,	"XFS_DAS_CLR_FLAG" }, \
> -	{ XFS_DAS_DONE,		"XFS_DAS_DONE" }
> +	{ XFS_DAS_UNINIT,		"XFS_DAS_UNINIT" }, \
> +	{ XFS_DAS_SF_ADD,		"XFS_DAS_SF_ADD" }, \
> +	{ XFS_DAS_LEAF_ADD,		"XFS_DAS_LEAF_ADD" }, \
> +	{ XFS_DAS_NODE_ADD,		"XFS_DAS_NODE_ADD" }, \
> +	{ XFS_DAS_RMTBLK,		"XFS_DAS_RMTBLK" }, \
> +	{ XFS_DAS_RM_NAME,		"XFS_DAS_RM_NAME" }, \
> +	{ XFS_DAS_RM_SHRINK,		"XFS_DAS_RM_SHRINK" }, \
> +	{ XFS_DAS_LEAF_SET_RMT,		"XFS_DAS_LEAF_SET_RMT" }, \
> +	{ XFS_DAS_LEAF_ALLOC_RMT,	"XFS_DAS_LEAF_ALLOC_RMT" }, \
> +	{ XFS_DAS_LEAF_REPLACE,		"XFS_DAS_LEAF_REPLACE" }, \
> +	{ XFS_DAS_LEAF_REMOVE_OLD,	"XFS_DAS_LEAF_REMOVE_OLD" },
> \
> +	{ XFS_DAS_RM_LBLK,		"XFS_DAS_RM_LBLK" }, \
> +	{ XFS_DAS_RD_LEAF,		"XFS_DAS_RD_LEAF" }, \
> +	{ XFS_DAS_NODE_SET_RMT,		"XFS_DAS_NODE_SET_RMT" }, \
> +	{ XFS_DAS_NODE_ALLOC_RMT,	"XFS_DAS_NODE_ALLOC_RMT" },  \
> +	{ XFS_DAS_NODE_REPLACE,		"XFS_DAS_NODE_REPLACE" },  \
> +	{ XFS_DAS_NODE_REMOVE_OLD,	"XFS_DAS_NODE_REMOVE_OLD" },
> \
> +	{ XFS_DAS_RM_NBLK,		"XFS_DAS_RM_NBLK" }, \
> +	{ XFS_DAS_CLR_FLAG,		"XFS_DAS_CLR_FLAG" }, \
> +	{ XFS_DAS_DONE,			"XFS_DAS_DONE" }
>  
>  /*
>   * Defines for xfs_attr_item.xattri_flags
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index cb9122327114..b528c0f375c2 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -4139,13 +4139,13 @@ TRACE_DEFINE_ENUM(XFS_DAS_RM_SHRINK);
>  TRACE_DEFINE_ENUM(XFS_DAS_LEAF_SET_RMT);
>  TRACE_DEFINE_ENUM(XFS_DAS_LEAF_ALLOC_RMT);
>  TRACE_DEFINE_ENUM(XFS_DAS_LEAF_REPLACE);
> -TRACE_DEFINE_ENUM(XFS_DAS_FLIP_LFLAG);
> +TRACE_DEFINE_ENUM(XFS_DAS_LEAF_REMOVE_OLD);
>  TRACE_DEFINE_ENUM(XFS_DAS_RM_LBLK);
>  TRACE_DEFINE_ENUM(XFS_DAS_RD_LEAF);
>  TRACE_DEFINE_ENUM(XFS_DAS_NODE_SET_RMT);
>  TRACE_DEFINE_ENUM(XFS_DAS_NODE_ALLOC_RMT);
>  TRACE_DEFINE_ENUM(XFS_DAS_NODE_REPLACE);
> -TRACE_DEFINE_ENUM(XFS_DAS_FLIP_NFLAG);
> +TRACE_DEFINE_ENUM(XFS_DAS_NODE_REMOVE_OLD);
>  TRACE_DEFINE_ENUM(XFS_DAS_RM_NBLK);
>  TRACE_DEFINE_ENUM(XFS_DAS_CLR_FLAG);
>  

