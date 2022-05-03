Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CED4CC433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  3 May 2022 22:42:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbiECWqC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 May 2022 18:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243782AbiECWqB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 May 2022 18:46:01 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85CFF427FD
        for <linux-xfs@vger.kernel.org>; Tue,  3 May 2022 15:42:27 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 243J0fir004092;
        Tue, 3 May 2022 22:42:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=xeE7yXr4XHy+k1n7WR314H+Et7BHEy3eviYzlESaFiU=;
 b=hgWfdopcsVngArjSBjLygZsZ8iy95OqgmbUUMLyhKYaDopPaF6Onnxe4ZCqidwLZwRv1
 2sgoDPHID50A1U1g4fAhY7lruMYLuduzLNnn/jXP+KgCvm+vHwX35owVnCjSAxlGamVP
 jy8lwP/ueggXhwmIM21cP1V1LUkosQN4+AEink8vd4CcdPBk5Jyq37uuZi6Xz159bwif
 hQpbNtximpPsOQVTeS/axS21xa+t6CTiYJ7pcYzt3FYO1r1STomBfCNjQApJnmxrrIdq
 zoemIxqle6TGnwx9We7J3SWmF6nplPYdBRw8LvTJE4rKw1GSgwM7n94FK+NVP3LDKKbf fw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3frw0apt0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 22:42:26 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 243MZS80031696;
        Tue, 3 May 2022 22:42:24 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fsvbmsf2q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 22:42:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AO/jV9yQE9B11hOsVAmOY3MaB24Ga9cKJZpviuIhsMsJkwAnTmHY9T+3/6MSrJRcq9C5ISMreFt8NlPK1vqCpdzlBlRm7movrk2qxzUpBgnu+haKElkhmfbLLSYinU052DFJqiQje7TmABMYTHIWrf1IHbdA3LQtkEgwoFy3MAuGXMNC+D/IcD81Mx2Wwe6YChRJCTUga13wg2kCZhsb4RhFok2E0lfDtIVPU2nHbPw/ARw0kjI6brUd8FefB0wcIDD2UPH2i9tcm4d/MubAbF7QqeGRfEbAU4gkAR96VvL0kkp6ZvPTYrJJmFFugrkVCqSyE0VyWJtB+6CwRSxTUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xeE7yXr4XHy+k1n7WR314H+Et7BHEy3eviYzlESaFiU=;
 b=HRNUMACsR69KckEa1WvwzhjSuMcY/TYte5OZl1i8WgEZEpEoR6hoYn8AGBMQpg09KigUxwm1R3TUE5dFDUeDAi+PVNJ21CETF9xxgia+/psf6TVwNZukPXVplNUIcNSfglgvslGeYYhb6v6PG0MaVDG/VcRhyh9Dl8b86qF83kElBARgFw8hmHa76MfeXllYQg359k4U0OsZltdx5iXA4OWQ0T40o+45ldr3vjdcADqODwX+jTmxgji6ve5dFpSRrL2zbRoHBWaFqaIAG60lKdpALMku7FRcEy/ShoqHCQovBQP1VYmnHbDoHRco4t8+W16h7PDsF9a15xRpnyvQhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xeE7yXr4XHy+k1n7WR314H+Et7BHEy3eviYzlESaFiU=;
 b=ytMrqmMBN0CoFQp8O0UNKG1mMjaw3XJgx95ffSuL7zA4GRkWj2qrReYHRyLIgrzQVS8KfVxLSkyFUvcHxiezvbCfWFJvnRJTLRI2DGJc1cNO0E1hWiSnHyRs18n/Rscu2RV+KvPNVMPy2qmf3xN+ehV1cQ/maP5W6SMkHbCWGrA=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS0PR10MB6126.namprd10.prod.outlook.com (2603:10b6:8:c6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.28; Tue, 3 May
 2022 22:42:22 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f%8]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 22:42:22 +0000
Message-ID: <54404f50344613b773aa4d0613812fe8145001a7.camel@oracle.com>
Subject: Re: [PATCH 02/10] xfs: fix potential log item leak
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Tue, 03 May 2022 15:42:19 -0700
In-Reply-To: <20220503221728.185449-3-david@fromorbit.com>
References: <20220503221728.185449-1-david@fromorbit.com>
         <20220503221728.185449-3-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0061.namprd08.prod.outlook.com
 (2603:10b6:a03:117::38) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2223311a-a17f-4176-eeab-08da2d563016
X-MS-TrafficTypeDiagnostic: DS0PR10MB6126:EE_
X-Microsoft-Antispam-PRVS: <DS0PR10MB61264BE189E7D80ADAF4427395C09@DS0PR10MB6126.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oL4EDmCTUlqGC2nD6aextPCJGP2mSIkHsgHGFjGcrVdUyJN+buz5lAT1zL2vw1HS/29ZNeavdsquO0bUG87sPjUtYMpLp0AHVReyE2cjB9tn6WhudkF7Muohc6f3viLEf53n97HZjT3CjB5B82e7qziaLqzCeMm/aoyZRawZnxxkKd5rowHz66DeZNnVJ16i1V9PFMgMuuNIK8Ylr+0AtmaviHW6abKA4p/DsUf3xC4oftbJmK/GuVdZzgQCtzh8lK0VYlDn0j+rjwGag/8qHhx3xjyO20+RCaYklvm9tsqe3oLZONbWhqEhA7kvXm2IJd7w4pKMlPGzfiUEWRWb60EeWWs9Hb7uXO1eIJz+juWnxulojFbzftR0zsa6fk39HY/s1kHdNKTrH1Ur73q+45Lue5haDtTqnKKuIV7r0YdqDHP8dkBXtV0PQCaj2sDyTvq3pMmkWvG51w3g4jPUAFCE1u2OLM//Qg09fYDhjYhrEFFl2g+E+1PGUqpZZrYrYgLHow0X5u0/BGNkO/BO5bV8VM8sCQuyi03nLXeR/IJer+gDj2kTF5Ctw/pmvrUvv7YLK+mD13cS/91yW56DNkynY1ZtoMiVYuo4ohYfiSv5LT0cJ16aAcf4tzXAUx4dEIV8sFXaR9Ev4qAx9Cw4Z5jZ3VF8UL77f2emBeXdaGkOsjLh2ipSb//Smy+cgqzrpXP88ZU1yd35tBvHpNBnbQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(316002)(36756003)(2906002)(52116002)(6506007)(83380400001)(8676002)(66946007)(66556008)(66476007)(86362001)(6486002)(38100700002)(26005)(5660300002)(508600001)(2616005)(186003)(8936002)(38350700002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?amtGZG43bGNEMWowNGw3UzlCWUh2eWhFOGhDTXZNMURPc2JYNzJ5TjB5UGpi?=
 =?utf-8?B?MDNBSXVLTTNHSGtwVm1lcUFCbVRwTGRaN1B6T0lneE1IaTFYTTdaRzNyMFZG?=
 =?utf-8?B?WVc3azNaQWRjaiszeFJ3WUxjWWkvQU5PRWIwTDBWT2tNUE4wL2k1ZUF5QUNN?=
 =?utf-8?B?QWhoNTFtSmJjUGtxcXlubjF5ZU1PRHp5K0t1d0l1OGJhc2FzY21JZFlXNU5I?=
 =?utf-8?B?VFd1R0NBWnpkUU9mbnBIWHQ5RFpaREw4bjZiOFNkYXN5SDFzbk4rTU84UUpX?=
 =?utf-8?B?VVRHcVdodXBmS1J4QVlvb3M4NGxPNGZDdTZKdTZMWTFRNDZDNk9TVHlYQWps?=
 =?utf-8?B?cVlxZXlCQXV6RzZSQmlvM0pRajlHQU5RRjRrVkhzejRWb1JiWWdKalhaNnNN?=
 =?utf-8?B?bzBJd2ZtcC90RlNrbms4VzBqVVc1SFNJUTVVWFpKZUJ3b0dPdDFITms3cUVZ?=
 =?utf-8?B?bHc2b2Vyd3lrY1BnN2ZYMS9SMmVIWVg2dXRHRUhnMXV6ekdMcGFrV2tlejZE?=
 =?utf-8?B?LzhoZDFyY2ZNZmtHYWZZaFRrM3Rrd3Nnd2orUkprdkgyaURnWWhlMGFnWWRV?=
 =?utf-8?B?U215dlhNK2FLMHFnc3h0bkRyTTE5WUMxSDJpbFJOUXgvdDdvRC9nOWp6ZCt4?=
 =?utf-8?B?OTVvY09wejAxa0lCbXh4a0ppNEZqNHJrWmsrc1BneFVHY1FHc2JIbExoMkcy?=
 =?utf-8?B?SlNZTWtqMm05MEUrNWp3U3d0SXYxOWQ4WkJ0Y25wa1kwS1VLK0J4Uzdod2Zq?=
 =?utf-8?B?S3V1V3RrNHBHdHpFNW41M2VxaHJWcXV0QkZoZzJBazN4UVlvUlpQR1RTVEY3?=
 =?utf-8?B?bTd5TzNadG1UcGhCK0JmaHRQMU9ZMFdaR3lLSWpueTVjVlhiL1JuNHlxYmxs?=
 =?utf-8?B?YVRFSm9DMFFvWFRZUjRGVVZIY2JFbUJrdUVncVlJdWtiNnN5bTZjVVhNbHNj?=
 =?utf-8?B?VEtyNmtTaGtaeFJVSHZ5ZHFmSW9qUVp0UU9ra25BQ3psZlNjZ2RmRUtyZk5I?=
 =?utf-8?B?NmFob2hDV2hxdEc5OEhMT2NsdE1OczIxMVdZQzJPczhRY3laNzZMVEdZVVY5?=
 =?utf-8?B?NUUybHlqb0pwTi9HeDI0WEd5MDBzVCtmYWZqeDM1a0FVK04rM2RzRWRsUWpG?=
 =?utf-8?B?azRxYkpGeXh1SGI3NE9VUnBSelpsMjFiMDZZUlZ6bzdnWWp5YzhQdGZjYVJm?=
 =?utf-8?B?M2hlMzJhY2ViOC8vQ0tIMm94dDdmWk4xWE8rK2k1RWFNS1dVVmk4ZlpXdUtq?=
 =?utf-8?B?dVRzbmltWTM5RXFiU1RGZDlycGZxTUV4SjVhT1pHSG0zU2t6T3RETERVTlQz?=
 =?utf-8?B?R01YSmVPQlJDeVNEems3RVJycFZpT3lUNnZKMi9PWDV0dHdMdENwR2JFTy9H?=
 =?utf-8?B?Q0laUWx3U2F1M0U1dHk5Z2F6T0QxODFxa0ZlMFlUVkRySE4xS0lmdG9oRUd3?=
 =?utf-8?B?a0NySDY3cFJYN0ZDSUw0R3VwWm1BeFYyQ09HeE5JaHI0alhNQmR3a2tYaFJR?=
 =?utf-8?B?NjI3RlhUSzNKcngvb0xtUGJlYlFYbE9nU1drbGlrWENwc2dteVRKRFcxdG5a?=
 =?utf-8?B?cldhZzUzYXdLaCs4WU9Ub2FibncvSmxiYlZtZDF0YTlpaUpxSVV3MEhIdkc2?=
 =?utf-8?B?TklUTjY0R2dLT3FZY3U2MENyTjRJRmpsQk51T1F3RWsrMVYweC8xVElNVDdE?=
 =?utf-8?B?akNtdTlLUHBvRDRYN0c5NlgwZkQ5b0QxcGlCeER3T0pyeGt5VVFQaXpmZmZy?=
 =?utf-8?B?OWhjTW40VnlhQUNyRm9QeU56N0Yya0RPYUhFV2NVREZQa200MGNRc29zcEo2?=
 =?utf-8?B?ZmZtWExOMzlhdk5TemNCd3UrbWhtSUozUitiQUtQN2lwVlVZK1lXWWRBRENG?=
 =?utf-8?B?anF1OXBYelRkS0tFOG8yYXYwNUVrZjFCdDJiUFlWNnZkTHQwcHhIalB5NHJy?=
 =?utf-8?B?WlhPLzhOQktFNy9WTWw1N1FUakNIeFJxWFM3S3g4SWRwQUxwd1FUaWN4SDdL?=
 =?utf-8?B?UktMbVordWs4cjdkNWhWQXRjVE1NSytMQVRSbnVMLyt5WUcwTW4rTDJOTjJI?=
 =?utf-8?B?TXpVNWxvTnJhVjVuL3IzYlBzUVlrTmdmR0dZZVhSSlBOdHV4emhVWWVzRGE5?=
 =?utf-8?B?bXJlRUV2N1M3aVNudkJGNkF3a2J4ZFZjNCtYK2gvMGdib0R2NjRTeE9RQ0tT?=
 =?utf-8?B?TXhHbE5VZVVkeWppOVV6WDVQNEllZHFjR2k4ZGkwQnBsem5NLy94UktVYWF4?=
 =?utf-8?B?czFySzM5a0ZwMWUwQkQ1QVlwSnBRcGo1cFN0akczNXJTWVFzeEpLYW9IcU8x?=
 =?utf-8?B?QWo3RU80QVVaRVFHck1yd3U5d2xoM3UzYmpFRXNrYndlVjFrZWdLUEhpdGVq?=
 =?utf-8?Q?I0THL3cPXLi3jU5o=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2223311a-a17f-4176-eeab-08da2d563016
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 22:42:22.5155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6/vB9qnEAE/k9/3xnBTpU2YU8eC5jIeuGSdogIGCYnCbT76VfRjiqrVquh/4CKd6qamPpVM0TNAqVsaTZwfR4yCWn7iZMI6L4o17ERKTonI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6126
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-03_09:2022-05-02,2022-05-03 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205030137
X-Proofpoint-GUID: xVs-abcoWtkvPQvg4lzv3ZilnsQs4sEt
X-Proofpoint-ORIG-GUID: xVs-abcoWtkvPQvg4lzv3ZilnsQs4sEt
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2022-05-04 at 08:17 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Ever since we added shadown format buffers to the log items, log
> items need to handle the item being released with shadow buffers
> attached. Due to the fact this requirement was added at the same
> time we added new rmap/reflink intents, we missed the cleanup of
> those items.
> 
> In theory, this means shadow buffers can be leaked in a very small
> window when a shutdown is initiated. Testing with KASAN shows this
> leak does not happen in practice - we haven't identified a single
> leak in several years of shutdown testing since ~v4.8 kernels.
> 
> However, the intent whiteout cleanup mechanism results in every
> cancelled intent in exactly the same state as this tiny race window
> creates and so if intents down clean up shadow buffers on final
> release we will leak the shadow buffer for just about every intent
> we create.
> 
> Hence we start with this patch to close this condition off and
> ensure that when whiteouts start to be used we don't leak lots of
> memory.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
Ok, looks good to me
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>  fs/xfs/xfs_bmap_item.c     | 2 ++
>  fs/xfs/xfs_icreate_item.c  | 1 +
>  fs/xfs/xfs_refcount_item.c | 2 ++
>  fs/xfs/xfs_rmap_item.c     | 2 ++
>  4 files changed, 7 insertions(+)
> 
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 593ac29cffc7..2c8b686e2a11 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -39,6 +39,7 @@ STATIC void
>  xfs_bui_item_free(
>  	struct xfs_bui_log_item	*buip)
>  {
> +	kmem_free(buip->bui_item.li_lv_shadow);
>  	kmem_cache_free(xfs_bui_cache, buip);
>  }
>  
> @@ -198,6 +199,7 @@ xfs_bud_item_release(
>  	struct xfs_bud_log_item	*budp = BUD_ITEM(lip);
>  
>  	xfs_bui_release(budp->bud_buip);
> +	kmem_free(budp->bud_item.li_lv_shadow);
>  	kmem_cache_free(xfs_bud_cache, budp);
>  }
>  
> diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
> index 508e184e3b8f..b05314d48176 100644
> --- a/fs/xfs/xfs_icreate_item.c
> +++ b/fs/xfs/xfs_icreate_item.c
> @@ -63,6 +63,7 @@ STATIC void
>  xfs_icreate_item_release(
>  	struct xfs_log_item	*lip)
>  {
> +	kmem_free(ICR_ITEM(lip)->ic_item.li_lv_shadow);
>  	kmem_cache_free(xfs_icreate_cache, ICR_ITEM(lip));
>  }
>  
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index 0d868c93144d..10474fe389e1 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -35,6 +35,7 @@ STATIC void
>  xfs_cui_item_free(
>  	struct xfs_cui_log_item	*cuip)
>  {
> +	kmem_free(cuip->cui_item.li_lv_shadow);
>  	if (cuip->cui_format.cui_nextents > XFS_CUI_MAX_FAST_EXTENTS)
>  		kmem_free(cuip);
>  	else
> @@ -204,6 +205,7 @@ xfs_cud_item_release(
>  	struct xfs_cud_log_item	*cudp = CUD_ITEM(lip);
>  
>  	xfs_cui_release(cudp->cud_cuip);
> +	kmem_free(cudp->cud_item.li_lv_shadow);
>  	kmem_cache_free(xfs_cud_cache, cudp);
>  }
>  
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index a22b2d19ef91..6c0b56ebdbe1 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -35,6 +35,7 @@ STATIC void
>  xfs_rui_item_free(
>  	struct xfs_rui_log_item	*ruip)
>  {
> +	kmem_free(ruip->rui_item.li_lv_shadow);
>  	if (ruip->rui_format.rui_nextents > XFS_RUI_MAX_FAST_EXTENTS)
>  		kmem_free(ruip);
>  	else
> @@ -227,6 +228,7 @@ xfs_rud_item_release(
>  	struct xfs_rud_log_item	*rudp = RUD_ITEM(lip);
>  
>  	xfs_rui_release(rudp->rud_ruip);
> +	kmem_free(rudp->rud_item.li_lv_shadow);
>  	kmem_cache_free(xfs_rud_cache, rudp);
>  }
>  

