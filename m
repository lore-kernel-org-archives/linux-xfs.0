Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F318CC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 00:33:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354451AbiD0AgJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 20:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242692AbiD0AgI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 20:36:08 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F293464C
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 17:32:59 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23QMVPhA032176;
        Wed, 27 Apr 2022 00:32:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=RdYxCaqOmS8tCRUzQdl7X18BGabiCQuAXUyryMTyUQ8=;
 b=oPn3EaEHwW/DTth1qIIfFD4sL1AU/gK3qCnuAb47eGre5VcryiT7KhUjvJ/SqEB0MgmH
 gTddjF1Fz1dzoP05VE85WzHpm7Y+JUuvKqgdiODVn4Djf62stFgmo9lgxr3EDun0hwjB
 ctmDCPi6aB9Mn8ctZsex/v48o0IBD6FGkls6TLzlqp8L/PMmz8k/sSlP5QZgilOgkz+r
 yA7RzgI+8aUhFivlcIOQ4M+LKLnPLWP0cRb5d7DXTTSrsEjUACxp83eP0fjopApf4d8e
 juKl6BoAl8dNLF4gJcbU1qip215e/Y02c8RAWfEv60VSiJuj5EJ8zo2XeFJPIqTPkCm7 FA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb0yyb3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Apr 2022 00:32:57 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23R0V6fl003525;
        Wed, 27 Apr 2022 00:32:55 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w3wrgv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Apr 2022 00:32:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k3nDCea0P+BXhHzTwR6sR9EAlqsYC+GCPvjujzE2fwbcv/ZGiWBfaoeSy2pUTwMMzTnKP7b/3wihEvEOv5xW5JACtZmOf4ivQ+SkXvhFgycnqvuiomv9ZQRF9dzbU1UHsNoCKzcxSw+3BP2mGW1zcP6DKiufT4rYPCrKXhYBvQWGSPzFCA8sJY+25TjWv1nsaQgXpCEUDDMRYK5A7eFLX2Q3TD62JD1t/Qt4/iz6jmw/IqebZdLzoIvQxdO+X37O9VyltzM/TXksF1PyysA1w7JCqEZF7cBjewn8LdqHdXCYSpWMoRVdNcl57qdTWLtIvOKNsYTMmafbY6Tv/43/Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RdYxCaqOmS8tCRUzQdl7X18BGabiCQuAXUyryMTyUQ8=;
 b=fvmRLmYs4ZevN85fyayyph2V60GMlPgzi0YOke8pYH/tdgEGWMcMl1XjlgB9smTFLMRhjY2cNWync13ude1FW9rWQpZgNWXh2h6gFx8gvE1qKYSmJITvNIZd7elHwo9/kkfxmm2Sb0ZCf83utS/A4p0QutdJmRjiRLh6KRchcv2PqZGV4rGZRBclx6YIxmczbMH6U3sGwhY/dIpzK2IoCeSa34cIcmCNXxLdMMgD2acY78Y4Pi9YGcOnJ8XYU/fZzd/LV1TYmfSmRA9l8ksjZePFkcklPQW8O72ROiQvKV6b/W2AT4F/6qnpqDyXv3szHX/AZBQzJBQ291sKhTipPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RdYxCaqOmS8tCRUzQdl7X18BGabiCQuAXUyryMTyUQ8=;
 b=OYCADsVjfcD6lxMq1lPoIuyKoe40d2jbMmJIRxpQ3hBTOwA1CyfUVNCg0XnpNuoEeMl/X4dVWA0BZw+wysS52qTi7yntC+g0r8K6Gm6FRr4Zvj5EDDBmlQUxuxwlRzRKco2zVtHdoCdgufXtpQyyIPTvP+ZVdHU89AWrYQ0r9vk=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CY4PR10MB1767.namprd10.prod.outlook.com (2603:10b6:910:a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Wed, 27 Apr
 2022 00:32:53 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f%9]) with mapi id 15.20.5186.021; Wed, 27 Apr 2022
 00:32:53 +0000
Message-ID: <c470536bfb4f381ea5c0020fbedf758cbf7567f1.camel@oracle.com>
Subject: Re: [PATCH 10/16] xfs: clean up final attr removal in
 xfs_attr_set_iter
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Tue, 26 Apr 2022 17:32:51 -0700
In-Reply-To: <20220414094434.2508781-11-david@fromorbit.com>
References: <20220414094434.2508781-1-david@fromorbit.com>
         <20220414094434.2508781-11-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0059.namprd17.prod.outlook.com
 (2603:10b6:a03:167::36) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 63d625ec-64a8-4703-360f-08da27e5775d
X-MS-TrafficTypeDiagnostic: CY4PR10MB1767:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB17670358B7D02C45B174E47595FA9@CY4PR10MB1767.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7d5t1E6RUsGWWGqzB92Rj5Ilbc9CglWPwmEb/nN8SqWmPMuYIb/cNKEWO4rL9UqvVxUHB0Wb6OzeqlBqaFaJ+bX47hfFx0U+ZmnSVoM5JsOyrroyMiQAni3++BuVifQvzD/cigH4HwrWjbEme3ZtikXl6X7gXX8IrgbbNOXDh+DiTMqjgWdv5fAHMygClmDMifD1lDu4fKynHg4FTC2ezUSMbqHbcOszuSGnZxqpJ+qnn6srnIAUofKwn/pYDe83Ly/PRmPZJzrm1d0poAbeNGvbOPB3MO8iPAXKbO/rxaUUd392sCXiy3EnbUAGnG+skiMP6Eaj8Va5erYwURSvyr1pK0lEpFtta80vphPhCuujcMawm1D/Gb1+guPLLd+uMZquHSR0R3y1+q1vQCP3egNOe0nfcl6eJIeChMITnZOFpcArTXHPkILWaDo8UnmNfwoAuBISnOi2qGF9cKdNHd8dsGz94dQTJOpn5T8Bz2ERbI/57YSVRRqomUZ1oCDEfCptMYuzC5k/sT3MRWAACp6ffK3+rDxU3rtaj+t5emP5YKgREappVUd8/N2J1+IDFf1iczDb6k44xHq039iYNAfYz+GL3GNbz+C8Pl+usNcO0JeXE9rT6EKLnh0Y+R1k692MaY49XJ7QePaCxlopSZL5jhwHFL07gdZ/gfx+KV8+xheEmNOkpLc3Efq4ly/aaIS3C/xW/GdEFMf1gdB5RQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(186003)(66476007)(8676002)(36756003)(6506007)(66556008)(26005)(8936002)(316002)(66946007)(6512007)(2616005)(5660300002)(508600001)(6486002)(52116002)(2906002)(86362001)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TTIvTXcxSDM2cjJtOWVXNExpMVpKR3BKVjhhTG9xK2xMaVFvVlNBNFFqQnQr?=
 =?utf-8?B?T0J2dWNRN1VWSFc3MTRhcXVjbm5sOFBzWnF3T0NZOXJUbFB6am1lK05DSlhw?=
 =?utf-8?B?RExVa095TEpncnhNeURoKzYzcHBUOEtCM0ZUbDRVdTJnUUF6ZXpGbkwxNWR5?=
 =?utf-8?B?ay9hd2pBKzY3aHpXdEs4Wnp6ZmY4RmlLano2SXZYVUxJU1Z2bHlPdUdld1M3?=
 =?utf-8?B?dGFnSE1IOWY1a2pQaUZINWNRSTVoTThjVDJSRXNpWHJZWC9aMTVqc2oyUXU1?=
 =?utf-8?B?bXBTQlNlYjFPZXpxVmZabGNYRDlVZjBvU2JtM0hLWWozVnFNS2xaS05WTWJ3?=
 =?utf-8?B?cnRETXMvK1l3N2FDaCtTL2JyQjdGaFBEdjFIUW0wR0xGYVpoMjFPYWN5dEw2?=
 =?utf-8?B?QSsrWlNWMDM0WVZFeHNuNk5GMzlSREtxMGdjOXRBWGN4M1hJNE5IUnJScEdK?=
 =?utf-8?B?azJWVTN3QWZaOGtXY0VpNVdzQXViZ2dxMmxxdXRYeTM1SWVYdHBUVGpvd1Z4?=
 =?utf-8?B?RVpWcElFZlhGa2k1cithNDM5UWJmUHFoejJFWjBBd2JKT1BSaXlRbk1sNzU1?=
 =?utf-8?B?K0VEQWwrdHlDNGJ5RmI1NTkrTFVXdFJRaWFhckI0ZFVMdGV2OGU3TXJTRjEy?=
 =?utf-8?B?SHRaT2d6R2hETElhYXVBMndxclBSM0FyTE9RTTZSWEhJZ3dGYTFZTXlqQ01y?=
 =?utf-8?B?dGRkVTJkRlNqOWtpVkkzQW41SHdOWVN4aWdtNldvUVloc29tNit6aHAzNllL?=
 =?utf-8?B?VVgyRlBQYkkzVmYwWng2bmNRaVpEZnAwWVdXMTRWdThCQkgyNXhaU25jL0py?=
 =?utf-8?B?dkUzbzZud1lhRnlvUmp3enJ5YmtEYXc1L3FjbzlDbGtnbUhTb1BLWVNHQzN0?=
 =?utf-8?B?K09IdFZMbXRHT2E5enFQL1JpejgyRTJrQ2tBKzJXQThsY2tVMGxGS1d1R0Qv?=
 =?utf-8?B?d1VSZFdOd2J3UExEbmxRRDVpV0xvSk9naENITFN3aExmTmpsRDhBdkpTYllE?=
 =?utf-8?B?ek1MK3hibzZISkxTVGFYMTFkQktodGVmeVh0QzJHYXltRWwxNmFNNXg0SEtQ?=
 =?utf-8?B?SURxZVhkcjRkVC9rY2JuMGlmc01Lc21ZaXRRaUl0TG12T1Zza2pIOGdxSUtt?=
 =?utf-8?B?c3paMWtQbzlmZHVNWWhyVW9KN2hmeW5zWTF1N0FTcE5iVEZvZmtaQjdXZTVZ?=
 =?utf-8?B?alZpamwydmRDamkzV3pvVTJzQURXYUlGZmJCRGx0bys2b0NYREk1YUZpNllS?=
 =?utf-8?B?OEJHRGt4VzJmMFIyK2xMZFFjS0hCSzE3UzUvc3AvUlpTbXk0cjE2dHBiZU90?=
 =?utf-8?B?bUF1ZldHZHBqMENCd3VtM2ZsRE1JVVQvejZ5Y1JhUjIzbmoybHIwdzJGQjVR?=
 =?utf-8?B?d1RKVXNUc2ZUQ3oyWTFJUjRSalVrMDNOd3VqMld4K0JUV25xZkQ1Mm9tZERZ?=
 =?utf-8?B?MURzM3cvNVVOUFR6NEQ5SlJ1OUd4bGpTcERqMTBQeVJBbER6WWJ4enBJMkI0?=
 =?utf-8?B?bTlKTHowejBIeXEvSmxKeGkxekRKdi90ZVJQWHNxejUrejhCb2hFSnQyRGkz?=
 =?utf-8?B?Y1RjNWJ5RG1nQ290UzZyVDFEK0JQNkw5RklTSjFwWnNBdlg1RW5NTmlQS1N0?=
 =?utf-8?B?eGc3aXpwQ0NzK2JPbnMrMm9jaVI5UU1TQjRhbmJpeWVVS013V3JkSEk3dWdL?=
 =?utf-8?B?Vk8wS0RJcGZUcVJhVmJ2THNyZ053bFNjMkxMdy84SWlKTzdQL2Q2SWJiYndo?=
 =?utf-8?B?UGxicmlMZ29lRHBzVkFvODdPMU5WcjNZYytRSDBLOTllREpZdjNReFJaSlFm?=
 =?utf-8?B?V09jcXdxUGRVSEN5OXRFVlJaUWk3YVF6YzJUc0laT0czYkZJdmNlTis4WUdo?=
 =?utf-8?B?Rm91ZUJTZkMzb25RSVk3a21RdTZlRTd2MTBoKzlsdUNFNXNxQlRSVkZBN2xv?=
 =?utf-8?B?MlN3RHRwN2w3VXpmalRsaEt0dUhKYUVJMkRUaVMybjEzRWxkSklTZlRzWXVF?=
 =?utf-8?B?NUN1K0hINXQ3RjVDanpEcThUa0ZLTC9BMHV6cUM5eGd2d2xScHIzTXFRR1JI?=
 =?utf-8?B?aGkvcWViQXFqTGVCNHJ6SDJVMFYyQjR2cmRGYW1nVHM0QmQwT2FMSzVSOTky?=
 =?utf-8?B?K1hrNGNOdS9EdFh3TFpkWTRBQ012eGJiekhBSkVBZlQ1KzZSS2g4b1hjU3Zk?=
 =?utf-8?B?Z3VhaTRocjZoZGExazRWRytrc0JOQ0M4T05RZ3ZwbXpjOHpmeXVEQjVMYUhD?=
 =?utf-8?B?Z3Q0TFBqOHBSMlVqanhoOWc2cjZZWWRELzJjL2tncHExeis0T3dUd3UzaTlt?=
 =?utf-8?B?c3RaK2Z0eWtCbVZrVHFIZFI2dUgvOFp5dDZva2xmWXdNMUt3aUJKeXl4dmFS?=
 =?utf-8?Q?RnLo6iWEMcYOmM40=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63d625ec-64a8-4703-360f-08da27e5775d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2022 00:32:53.1812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2C6lj/ooo4WOoZNSLrT662p1bNnsKcBW4/FgdfKmUohpf3PWKbZ0UJKtQfFZ0zJAT205DGP0IiQYt/7eBA0tV1OISqIU1lnLn1dIFqja7+I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1767
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-26_06:2022-04-26,2022-04-26 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204270001
X-Proofpoint-ORIG-GUID: KzhmUsGUbuJN-SdHGuk0kcbkxy6E7bfp
X-Proofpoint-GUID: KzhmUsGUbuJN-SdHGuk0kcbkxy6E7bfp
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
Ok, looks ok to me
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

