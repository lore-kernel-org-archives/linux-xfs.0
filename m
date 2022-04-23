Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFE01C433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Apr 2022 01:06:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbiDWBJx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Apr 2022 21:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbiDWBJw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Apr 2022 21:09:52 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD76B19C8DA
        for <linux-xfs@vger.kernel.org>; Fri, 22 Apr 2022 18:06:56 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23MK6Jcw025975;
        Sat, 23 Apr 2022 01:06:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=M4bVvHyLVuZi+ZjxpbEwwAmQxzq5lFPYNg1IS8nce/c=;
 b=lv5FvBMjdkZ+FPedxCtRMd8dS2XUUfhZ2dm46wLBZI6u6sMIIPBltn+f3Q3r0C9B7/+K
 8VbhysXz3bkrg+J3Ns/kfM+ZqE8+shzGrxn4BLRVZj1EYprMZi6BLoePK8inKD7V9Iro
 JMAZxOT2Jk2AG8DvB1IUQl4akEVwJk8Yinw8kuejgYS/o/aDIo7NxFwo7/JTtsL2nrub
 rLt8wgekrfMKKIGdnDay2dfQ3SwD5ltGhnZ1QTd53+pAOgI5veqV+n6aH7zdNJpyoqU5
 tEST+bIa1z3Pw1tXC2zfhSrZuNGDZcK50g8c7Wv5rS0/7wfdpbaI2bW/lzeob4ZddGSE 1A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffm7cyk5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Apr 2022 01:06:55 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23N16Jlk033473;
        Sat, 23 Apr 2022 01:06:54 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2042.outbound.protection.outlook.com [104.47.56.42])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ffm8eg7rs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Apr 2022 01:06:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dmUeUsTAdOOfeuUPs8IGJkSgFdQ/IgEcdkt1/HNze4gccQi47wveONXvjbPQLjNzHRrAW67xaaWHjMQklRigrIMJ6Vhp3pihixOfhsDh1b1jrHM+ym9OQVQAHGgu8C7Dxy/s3SKs66NU9Nnyq2ptxFlCHncdipnjAWY9FiB8qNEqAVZB+0O4rmNJEP5O4aNsKkruCISr9xev7e6so6xQ4zUalq3U57bjTcMtwpl+Npqv8xZX5WGQX5nSFQ7dPxhzMofAnD7dS80THZyLRTWg9V0Qbl1mcFgGXBWr9uEeeAloWMoG90LV7dVgaBLjUSqFZj8TSQNkYQgavNSVTXE1sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M4bVvHyLVuZi+ZjxpbEwwAmQxzq5lFPYNg1IS8nce/c=;
 b=FC3oB+4vVOsshAhW+FnK/2KvVawnx6o7aCpigSwq36ive2P4/vmRDZ1jawVzcF1mOdi9m8kaWgWV6JcMRunBZzPgugZkXHSea/kz5DRUR13YEeazyBnzSCqWiP4ONsFGK9pHvlefo1c6i0uqNfjkB78g682SejkfCZ7gym1KZgIaerXqVeq1QkQjlvrVlREBF4X17THz5zhuGcFJzErULe7wOf4SS5hUaA97R0WridDfVYSCOvpXlkz60Djtpjj/uFc+uyRLBSlFAb/k81OoesQj2vXzC5tA68yVPderDWTKtYIhDRDBf4fdoRPbj12F2soU8QllGO+pc2kbiVeQDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M4bVvHyLVuZi+ZjxpbEwwAmQxzq5lFPYNg1IS8nce/c=;
 b=JCIOLkOp5xrsHocOy9iCt9UqIR4v3L2CaV9lIQPR25J2YhLUS7R0TfZHt7RKYB2KiYiwUv6fiqaK0beUUfTkQf72CQPL6lE1pMednReo5PdjdcBRxqrt7NV7GtIwyLQXmB5xQRC9AOUCpViW/v93i+BfPoKvvhuK6FwIWqsaxoI=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by MWHPR10MB1949.namprd10.prod.outlook.com (2603:10b6:300:10c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Sat, 23 Apr
 2022 01:06:47 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f%9]) with mapi id 15.20.5186.018; Sat, 23 Apr 2022
 01:06:47 +0000
Message-ID: <5d4b79d43bee81b25df43eaec294ee9b8b58ec0d.camel@oracle.com>
Subject: Re: [PATCH 10/16] xfs: clean up final attr removal in
 xfs_attr_set_iter
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Fri, 22 Apr 2022 18:06:46 -0700
In-Reply-To: <20220414094434.2508781-11-david@fromorbit.com>
References: <20220414094434.2508781-1-david@fromorbit.com>
         <20220414094434.2508781-11-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0379.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::24) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 16fbb6d8-e2a8-4dcf-f324-08da24c58a1e
X-MS-TrafficTypeDiagnostic: MWHPR10MB1949:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB1949C5E2FC1ED103833859F295F69@MWHPR10MB1949.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: giP63HXvFd+odxOf5e2eh17OgVrji9mLcgMNetzkY0AtNTv4PzzMbpL0mxxhy0ytQywAQ4x1U3AdlPQHSuXFXZ1bzB2EFC9hpv7xdf1X7KamhFa5kBAnnLypQ3wG/lsABHMjymNvtOoXcciB6EARFBy2u5A0PGmWulg4EucAPWzOkLCAFKUxD0/CKJWekZxiVbgShxSP6mVCh8eojulSdPIYFlHqWEExeKrheoSFmr/QkDIv3xzbWhDd2qAKEDF6W6YDR16ZATytZ4LmFaa1t057uBJEldz7YYTAHz4727oxFOmGb+6WSgIlomisw4Behs0oFHKjjpBQTrvJKWWgGyabm8QwzoqktLZivdc2vcHtOi0JgnwkEtbYR60c4vmQ8jtoz0X5WPYT+1lvQnAHk9s8QG2xGghjzUfSgQJRDeZTkpJ6nx16lRmTWKIiq3hYRIojLsX4ql3kgyieYDrUMiHL5IpiioP115HCBnpqOm5XUEv8w268i9sjDxQe5/Kr70WoMVOVCNoRH4cPc0PqiwiQorcfxdDRqZ+CsHV5o1LuAGKBgS21JjhqDjAEjgWCW2mjhWhpHCP9miNErsDN19vbk5hM98DJg3UhzSHPlcK5zf3wrRVQQiITcLVIPEcvmNBqsQ7xqOUsFMafUL/wJ5AvlwRTl7KuH77Um70EFE1qO3pGXzMpdA6clhCLdK/h6JLtecOPaRtbLWEf7Yrafg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(52116002)(6512007)(2906002)(8936002)(26005)(316002)(8676002)(66476007)(66556008)(66946007)(38350700002)(86362001)(38100700002)(5660300002)(2616005)(6506007)(186003)(508600001)(6486002)(83380400001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Nk5xS29oM3ljWVdISVhMV3kzcnl4cmN6NGRLbUFBQTZFblF3bWVuT1RQTXFT?=
 =?utf-8?B?MXBDZWF0bldSY0piOVZrbzZKK3ZVOVN2b2w5bkhqVktqZGNqcnhTYWpFWnND?=
 =?utf-8?B?d0JiZUdvaWNmamUyb2Nud2dlZUNFdFZIVW1iS090ZVhUc25CeFNFWEFzNHdt?=
 =?utf-8?B?c0pPNW0wTTQwZzFrOGlaMmgrZitvMzhoaDBqUUQvcisyOTArQzZ5M3laUWVH?=
 =?utf-8?B?dzhXOUd3RlJIUG51TFBRZHJ5REZzMGVtSUZvU0pJNDlxWUNZNXF3M1V4S0E2?=
 =?utf-8?B?UHpVUEdxVFJwQW9vWGRpWGRIbkhRT3gwSlZ5dTRja09hd3hxSUNXMDdWYk1W?=
 =?utf-8?B?OTBGN3p2aVdNb2kwMm1sNU5YajV3K0UzZGI1Z1o0T2FPTlZuVEhrSmZMc05F?=
 =?utf-8?B?RVovcytoMTlwU0NFZDFQT0hnV1VObU5GNHdkSkg3ajlXdnljVVViZTRJRnF1?=
 =?utf-8?B?aDZYNUlOQUMvWm9UUEZic2RRdTY2K3BaMWpCYTF3bnBWNXlzYXVhRmRiWEd0?=
 =?utf-8?B?WGF1Y2VzMmFjSmFzTHdFYmZhalBKbU41R01Zc2VQUGRVTGxBMEUzaGVoRjM2?=
 =?utf-8?B?SCtKd0UzcGVaRUxiYkJYVDd4MXNHRUEvbkxKUDRFVG5nQ3lJakI2cHNnV1Fq?=
 =?utf-8?B?czFSUmh0MzY2NGloeUVibFhnamFsWUNXY3VKMnNmRy9jak04UHBkdXN5UnBQ?=
 =?utf-8?B?eXJwaWxZWkFKUFZiY21INjl4UzVTOHZBUkZCWGFEenBDSWdBNENVakJzdHBL?=
 =?utf-8?B?ekQrUUVrdEFrTVpQU1lqUGJjVVFQcXpGOStkZzluOWdhRDN3RzhaQXEzcERp?=
 =?utf-8?B?UFIweG5LTk5iUUt0UFFTS0JNb3NlLzlMUWFOVXFpVXlreGF1OWV6M1ZkMUJO?=
 =?utf-8?B?eXdOR3NuaFFXK3dTSDJySDRCandtcHJDL0xrU3ZPS3hoR0tybENhcjkxOFYz?=
 =?utf-8?B?OUVBQXVUUFdEeDlPMWlDSG1zRU50VXhCVHBja0NkNjBDOTk5ZjFMZ29NYzVT?=
 =?utf-8?B?citubDVjdVMvWUwyWC91N1dtdU00bnRoRjZneTdmZGlGWFl1Q1hxM3orakJP?=
 =?utf-8?B?RjhzT0xtNFg4VTBrNTFJbjJRSFR1TEFJZ3dqSXNRY1FVWXE3eUZaNEZ0WWZT?=
 =?utf-8?B?dDNKc0szUXBYNHFuYlZvZXJKR1RJdEkvOFRrdmtTNjNROHlPSDZrb2JuRHRV?=
 =?utf-8?B?TkZzSy9oL0FGQndwa0F3ajZyN1BhdUVPcUZoalpHVkdxelkzZGdLNzlpbHUz?=
 =?utf-8?B?RjlsZGJINnhvdGpuaXUrRGRETHhBU05WQktoVXM4NEQreDU0RHAraFUwNWJO?=
 =?utf-8?B?bmlKS09ZZFgvRTVHeXNlZURJb0ZpcXdLQVhLenptMFpFUW9NMlYvbEFZTnNx?=
 =?utf-8?B?VVBManRJVWVNTndacEdHYUtja0NUZ1ppRWI4ak1ZalJ1WGJuTDh1UFBGN1FS?=
 =?utf-8?B?cStPbngwN3FSdkRLbnZma1NMUko3cDFPQmEyRW12bkZSdjgxcDNhaXphRStX?=
 =?utf-8?B?WFF1RnJSRDZwSHVVa0RWcVV2UVFnazh6Znk5QURkR3BTUHJhYUMwOHFUVmt4?=
 =?utf-8?B?TkNZSHVFcml4QWdqVkJDeHo0WDRCTEtkRmhMSitxNmsrUmdDcVg5QjhCNFJr?=
 =?utf-8?B?TlhQNlkxRkduYVh0cXM0SjFyVDdZOHIxYkFpaFdrcThFTy9NYVlZL2ltRmUr?=
 =?utf-8?B?YW8rRHl6NmxnQ3BNbSttZ05jTEJWUVNaYU85eWpKOUozNW55cG4wcWVaWnV0?=
 =?utf-8?B?NzdBN3FaSzl3YnVCRHpzWC9SU2ZhUWZrTUo2RFdHcGRDM1QzSDNPcmNTUFY5?=
 =?utf-8?B?YmNEWkFxM0RTT0hPZ0g1cklDUTJtdlljcWtzTmVsMVJTb1hCWWVNUkJNYUky?=
 =?utf-8?B?Nm5sSlRpUUhDS1lxYjducjVjS1NEQUpJRUhmWVJrNmZsaW9xTTBmZG5nMXhl?=
 =?utf-8?B?REhtNFhCWW4yL25qMFJTc0RsT2lCbUozNXBIekNWWDZGZU5CbGxybkU4Rkda?=
 =?utf-8?B?TE1jeWJtT0tIUVpIanpkaEdEMVJPdW0rUXFTYk1BeElyTWw0MVVSZldlNUla?=
 =?utf-8?B?ZWlLUUhPRWhHSG1vbm03RFJXZG1COGJISU1jQnFYU3RwWjdHMHhWVlZGcm9i?=
 =?utf-8?B?ZHdnQmxXcVR2bDJoM2JzZ3UwSGFGVzVIZUpEVFFTaHF0aVRXK3RpbVd3anpk?=
 =?utf-8?B?SW5tTjkrbDBIdW9GdGVpcFVGeVdnbWxuQ3ZoVzVTd1JyQjZHckI5QmNOWS9I?=
 =?utf-8?B?UDZLT3NGUnpMeFI5UHYzUnFzaW9wUmZ4L2pQekNkWHRKMFFEYjkxUWhObFZW?=
 =?utf-8?B?ZGcvaEowZDh2VjJZNmtLOTc2T2dFV1lTZ21NTWMraHM3UVlka2c4czc3YXZJ?=
 =?utf-8?Q?IgTFVo152SQsDDQE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16fbb6d8-e2a8-4dcf-f324-08da24c58a1e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2022 01:06:47.2037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7Xc9ioB5WmPpBwqZIJ+yEo1P8Y8XDPRuxvTRGKPtQmQrzaLJf06cf2niDFBLEIGqUI7zae19+hvNMCuP2CRMIWPdT/nOjhcfiUDx7u2roGQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1949
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-22_07:2022-04-22,2022-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204230003
X-Proofpoint-GUID: 3Gn5MB28ZAop1smAjv8dBggHFSSCgCui
X-Proofpoint-ORIG-GUID: 3Gn5MB28ZAop1smAjv8dBggHFSSCgCui
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 2022-04-14 at 19:44 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Clean up the final leaf/node states in xfs_attr_set_iter() to
> further simplify the highe level state machine and to set the
> completion state correctly.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
Ok, I can follow it
Reviewed-by: Allison Henderson<allison.henderson@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_attr.c | 72 +++++++++++++++++++++++---------------
> --
>  fs/xfs/libxfs/xfs_attr.h | 12 +++----
>  fs/xfs/xfs_trace.h       |  5 +--
>  3 files changed, 50 insertions(+), 39 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 8762d3a0605a..9dc08d59e4a6 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -61,7 +61,7 @@ STATIC int xfs_attr_node_get(xfs_da_args_t *args);
>  STATIC void xfs_attr_restore_rmt_blk(struct xfs_da_args *args);
>  static int xfs_attr_node_try_addname(struct xfs_attr_item *attr);
>  STATIC int xfs_attr_node_addname_find_attr(struct xfs_attr_item
> *attr);
> -STATIC int xfs_attr_node_addname_clear_incomplete(struct
> xfs_attr_item *attr);
> +STATIC int xfs_attr_node_remove_attr(struct xfs_attr_item *attr);
>  STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>  				 struct xfs_da_state **state);
>  STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
> @@ -451,6 +451,36 @@ xfs_attr_rmtval_alloc(
>  	return error;
>  }
>  
> +/*
> + * Remove the original attr we have just replaced. This is dependent
> on the
> + * original lookup and insert placing the old attr in args-
> >blkno/args->index
> + * and the new attr in args->blkno2/args->index2.
> + */
> +static int
> +xfs_attr_leaf_remove_attr(
> +	struct xfs_attr_item		*attr)
> +{
> +	struct xfs_da_args              *args = attr->xattri_da_args;
> +	struct xfs_inode		*dp = args->dp;
> +	struct xfs_buf			*bp = NULL;
> +	int				forkoff;
> +	int				error;
> +
> +	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
> +				   &bp);
> +	if (error)
> +		return error;
> +
> +	xfs_attr3_leaf_remove(bp, args);
> +
> +	forkoff = xfs_attr_shortform_allfit(bp, dp);
> +	if (forkoff)
> +		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
> +		/* bp is gone due to xfs_da_shrink_inode */
> +
> +	return error;
> +}
> +
>  /*
>   * Set the attribute specified in @args.
>   * This routine is meant to function as a delayed operation, and may
> return
> @@ -463,9 +493,7 @@ xfs_attr_set_iter(
>  	struct xfs_attr_item		*attr)
>  {
>  	struct xfs_da_args              *args = attr->xattri_da_args;
> -	struct xfs_inode		*dp = args->dp;
> -	struct xfs_buf			*bp = NULL;
> -	int				forkoff, error = 0;
> +	int				error = 0;
>  
>  	/* State machine switch */
>  next_state:
> @@ -564,32 +592,14 @@ xfs_attr_set_iter(
>  		attr->xattri_dela_state++;
>  		break;
>  
> -	case XFS_DAS_RD_LEAF:
> -		/*
> -		 * This is the last step for leaf format. Read the
> block with
> -		 * the old attr, remove the old attr, check for
> shortform
> -		 * conversion and return.
> -		 */
> -		error = xfs_attr3_leaf_read(args->trans, args->dp,
> args->blkno,
> -					   &bp);
> -		if (error)
> -			return error;
> -
> -		xfs_attr3_leaf_remove(bp, args);
> -
> -		forkoff = xfs_attr_shortform_allfit(bp, dp);
> -		if (forkoff)
> -			error = xfs_attr3_leaf_to_shortform(bp, args,
> forkoff);
> -			/* bp is gone due to xfs_da_shrink_inode */
> -
> -		return error;
> +	case XFS_DAS_LEAF_REMOVE_ATTR:
> +		error = xfs_attr_leaf_remove_attr(attr);
> +		attr->xattri_dela_state = XFS_DAS_DONE;
> +		break;
>  
> -	case XFS_DAS_CLR_FLAG:
> -		/*
> -		 * The last state for node format. Look up the old attr
> and
> -		 * remove it.
> -		 */
> -		error = xfs_attr_node_addname_clear_incomplete(attr);
> +	case XFS_DAS_NODE_REMOVE_ATTR:
> +		error = xfs_attr_node_remove_attr(attr);
> +		attr->xattri_dela_state = XFS_DAS_DONE;
>  		break;
>  	default:
>  		ASSERT(0);
> @@ -1262,8 +1272,8 @@ xfs_attr_node_try_addname(
>  }
>  
>  
> -STATIC int
> -xfs_attr_node_addname_clear_incomplete(
> +static int
> +xfs_attr_node_remove_attr(
>  	struct xfs_attr_item		*attr)
>  {
>  	struct xfs_da_args		*args = attr->xattri_da_args;
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 18e157bf19cb..f4f78d841857 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -451,21 +451,21 @@ enum xfs_delattr_state {
>  	XFS_DAS_RM_NAME,		/* Remove attr name */
>  	XFS_DAS_RM_SHRINK,		/* We are shrinking the tree
> */
>  
> -	/* Leaf state set sequence */
> +	/* Leaf state set/replace sequence */
>  	XFS_DAS_LEAF_SET_RMT,		/* set a remote xattr from a
> leaf */
>  	XFS_DAS_LEAF_ALLOC_RMT,		/* We are allocating remote
> blocks */
>  	XFS_DAS_LEAF_REPLACE,		/* Perform replace ops on a
> leaf */
>  	XFS_DAS_LEAF_REMOVE_OLD,	/* Start removing old attr from leaf
> */
>  	XFS_DAS_LEAF_REMOVE_RMT,	/* A rename is removing remote blocks
> */
> -	XFS_DAS_RD_LEAF,		/* Read in the new leaf */
> +	XFS_DAS_LEAF_REMOVE_ATTR,	/* Remove the old attr from a leaf */
>  
> -	/* Node state set sequence, must match leaf state above */
> +	/* Node state set/replace sequence, must match leaf state above
> */
>  	XFS_DAS_NODE_SET_RMT,		/* set a remote xattr from a
> node */
>  	XFS_DAS_NODE_ALLOC_RMT,		/* We are allocating remote
> blocks */
>  	XFS_DAS_NODE_REPLACE,		/* Perform replace ops on a
> node */
>  	XFS_DAS_NODE_REMOVE_OLD,	/* Start removing old attr from node
> */
>  	XFS_DAS_NODE_REMOVE_RMT,	/* A rename is removing remote blocks
> */
> -	XFS_DAS_CLR_FLAG,		/* Clear incomplete flag */
> +	XFS_DAS_NODE_REMOVE_ATTR,	/* Remove the old attr from a node */
>  
>  	XFS_DAS_DONE,			/* finished operation */
>  };
> @@ -483,13 +483,13 @@ enum xfs_delattr_state {
>  	{ XFS_DAS_LEAF_REPLACE,		"XFS_DAS_LEAF_REPLACE" }, \
>  	{ XFS_DAS_LEAF_REMOVE_OLD,	"XFS_DAS_LEAF_REMOVE_OLD" },
> \
>  	{ XFS_DAS_LEAF_REMOVE_RMT,	"XFS_DAS_LEAF_REMOVE_RMT" },
> \
> -	{ XFS_DAS_RD_LEAF,		"XFS_DAS_RD_LEAF" }, \
> +	{ XFS_DAS_LEAF_REMOVE_ATTR,	"XFS_DAS_LEAF_REMOVE_ATTR" },
> \
>  	{ XFS_DAS_NODE_SET_RMT,		"XFS_DAS_NODE_SET_RMT" }, \
>  	{ XFS_DAS_NODE_ALLOC_RMT,	"XFS_DAS_NODE_ALLOC_RMT" },  \
>  	{ XFS_DAS_NODE_REPLACE,		"XFS_DAS_NODE_REPLACE" },  \
>  	{ XFS_DAS_NODE_REMOVE_OLD,	"XFS_DAS_NODE_REMOVE_OLD" },
> \
>  	{ XFS_DAS_NODE_REMOVE_RMT,	"XFS_DAS_NODE_REMOVE_RMT" },
> \
> -	{ XFS_DAS_CLR_FLAG,		"XFS_DAS_CLR_FLAG" }, \
> +	{ XFS_DAS_NODE_REMOVE_ATTR,	"XFS_DAS_NODE_REMOVE_ATTR" },
> \
>  	{ XFS_DAS_DONE,			"XFS_DAS_DONE" }
>  
>  /*
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 91852b9721e4..3a215d298e62 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -4110,13 +4110,14 @@ TRACE_DEFINE_ENUM(XFS_DAS_LEAF_ALLOC_RMT);
>  TRACE_DEFINE_ENUM(XFS_DAS_LEAF_REPLACE);
>  TRACE_DEFINE_ENUM(XFS_DAS_LEAF_REMOVE_OLD);
>  TRACE_DEFINE_ENUM(XFS_DAS_LEAF_REMOVE_RMT);
> -TRACE_DEFINE_ENUM(XFS_DAS_RD_LEAF);
> +TRACE_DEFINE_ENUM(XFS_DAS_LEAF_REMOVE_ATTR);
>  TRACE_DEFINE_ENUM(XFS_DAS_NODE_SET_RMT);
>  TRACE_DEFINE_ENUM(XFS_DAS_NODE_ALLOC_RMT);
>  TRACE_DEFINE_ENUM(XFS_DAS_NODE_REPLACE);
>  TRACE_DEFINE_ENUM(XFS_DAS_NODE_REMOVE_OLD);
>  TRACE_DEFINE_ENUM(XFS_DAS_NODE_REMOVE_RMT);
> -TRACE_DEFINE_ENUM(XFS_DAS_CLR_FLAG);
> +TRACE_DEFINE_ENUM(XFS_DAS_NODE_REMOVE_ATTR);
> +TRACE_DEFINE_ENUM(XFS_DAS_DONE);
>  
>  DECLARE_EVENT_CLASS(xfs_das_state_class,
>  	TP_PROTO(int das, struct xfs_inode *ip),

