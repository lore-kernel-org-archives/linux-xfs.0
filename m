Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04735C433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Sep 2021 21:09:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA93061100
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Sep 2021 21:09:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232927AbhICVKL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:10:11 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:33744 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235936AbhICVKK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Sep 2021 17:10:10 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 183Ix8r0026099;
        Fri, 3 Sep 2021 21:09:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=MLL+6gSWRIem0jItoOMQgRfQReBbqZ29Lfd6VUOEnSQ=;
 b=ZItqgTEoIhe5Sq4adSfObnlT7Bfxd52jXy/RLeN9l6Kc7BsavSW36ogijAMYMBuOukg2
 uWqeHkJxD4pjGTmgOIjMZy66aa73Tlt7jPhHMWBhpbZ1BI3FDtnp3BDcYxYC3ziguivY
 snu0j0h9F69aCc47Vog0t4a6SDzKmkS+bSvB7rKDrc+KYPIpurpyR99p/yVFzIc638QQ
 9qEx3MS0xuUxKzIQiC53vqsJF40/c9rRZjQCA93WsMFo3gj/VNB5uBHihniLSPmMCCd9
 ZY8SnfZDmykCfJjWWDCoo6JBZt2g9C/2GChaTi2vS/wC2WVPdNLZ6B7BNrkZDUiY7xFE 5A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=MLL+6gSWRIem0jItoOMQgRfQReBbqZ29Lfd6VUOEnSQ=;
 b=hvPeyoYrxchWDLp174uWkoUZK77qzLNoKadDEmbxBdi30pUqpIW7s+cPPDqLtOjSXK2E
 Y7p1Bgnvis3H956nmIpXNXzntuIlkqra1F5rqb6KP5qepBCn0higGojTaAzOs+Obsj/o
 6BxQoKpV01z4ZmbGPXHXzzR0SG6x5IWRq93vT1L+rcVPsMoSYIRbPPhXYhQdWQNb+qxB
 8PoYui8OTCl7mw3AgQoXhfYowgp+VdiIwtrAXvFvqbxg/6oaQlIxXStgItT1iaAO5Mdf
 DSrZYionIx/zB14ZU8LVdf3uozQ1NOSWg9aIr49GwDv7qzkPMWcTBvkUxdDoOh/3XmbK qg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aug2pt1j1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Sep 2021 21:09:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 183L5mO8037803;
        Fri, 3 Sep 2021 21:09:05 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by aserp3020.oracle.com with ESMTP id 3aufp3te6w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Sep 2021 21:09:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R/XCtkOykNMCy1IhmuSQT06zSD9drz5wOwmMirtt4EvVnZ1/r2/BFlZidHevezWyg78EI7NZdo1sajucVDK85yAcZfRNydJXcTfPGCiZwTLA5R2yhLrbOI7V0LeHDr1dOukHFXb7KMDHHIZwmY9zKhJGkEFd6P8T2doiVV9WyHSkAqI9RpAuUwUKc9YhzJulULRPI4JH3/gItlWjK8q5fqnQPK1jH67D/ie/bFczijqvybriWJacZt6Y0ZzeoI/pAKt3RAG5BLIG/eLgpzdQQJkFi1ihxDI1dlhygWAov0ZeoBifhD9L8ELYhC84mUT+YxDwWQVWS/k/A08DNJRGuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=MLL+6gSWRIem0jItoOMQgRfQReBbqZ29Lfd6VUOEnSQ=;
 b=aGrIutJdTKwZvrKxQi+srqtFc+uDvE1JiZK07ZGx5g1CLhA26dHbEQXfSVNbg4YHbMhv5LlSK2ysNFpU4vYhOx7OOx2Zd+jFrxld+KrIMhw9VKnIY6oD5C5cnOB2oYAnVaETFvyesXn2Xvtuif8jzITAewGNGGk/n5VemP5QOCrlgqk5mwMVT2eINTNwgPnB3Bqetn4jbUFxob/7PTcMWe7O7zIM526zpUZHBrpg2P+gYr1w4GgT2M3jJI0SFKpDsbPt84wKfYDrMPIaN9uiaL1Gx+6e7fpJ5+GRpkg/Chm22jXnGCBrzHbV4w2M6rc4VeqCKDNviDjxLxRM6tizrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MLL+6gSWRIem0jItoOMQgRfQReBbqZ29Lfd6VUOEnSQ=;
 b=j9kdjnGfznDnWkBWofOYA3Hc46A9I32Pl74JFO2JAmhqoEsj+aXjhIKuwnqGm8XaotlIepqGWk52WQ/8kBiPViE5w1DkF6WCsK+qTAK1s0Ni0LAqSYYANKQFRk9waDH3UJ6D6nGaF9oh5P+WI/+S/5xmC1hodWQSpwYYreAGQwE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4765.namprd10.prod.outlook.com (2603:10b6:a03:2af::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Fri, 3 Sep
 2021 21:09:03 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f%8]) with mapi id 15.20.4478.023; Fri, 3 Sep 2021
 21:09:03 +0000
Subject: Re: [PATCH 2/7] xfs: tag transactions that contain intent done items
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20210902095927.911100-1-david@fromorbit.com>
 <20210902095927.911100-3-david@fromorbit.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <4b6e9edb-6fbc-2e20-d0ef-4fd5b9e329b3@oracle.com>
Date:   Fri, 3 Sep 2021 14:09:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20210902095927.911100-3-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR03CA0019.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::32) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from [192.168.1.167] (67.1.112.125) by BYAPR03CA0019.namprd03.prod.outlook.com (2603:10b6:a02:a8::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17 via Frontend Transport; Fri, 3 Sep 2021 21:09:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5149f855-215d-4e1a-0a27-08d96f1f0edb
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4765:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4765F821172527963CE8C2D795CF9@SJ0PR10MB4765.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:205;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4LAasjX5m+6d6x9YDufsnpqhHRtI3gIFN0O6T2qtZvlOlRQJJCsTbFqx2OXM2IiUzXLqltCBAzuvty4Asm/E6jM72AQYmUshv21ym6zQ+k++6mfRoHy1ElCHtKrJHpjK1C7C2Z/6TiNf69iIZ5VQOhGY/dTgbpywTLt3Xw8EBGVesq+uyE+CjzpC73rV7FrsTMADcgkwzk9cuy13kpUuu3I+IXJNaFBFnqawmFao/ep/IA+ZFqsKLhl+n5sn6AcC58cMFXNqR4zA6mDZNyV8ajtpDaU3R8JrfSWT/BNwZU5lj/l6voKRiXw2NjBrlfDCQEUjRNI0kvkTX7orCPh3nOWWWys4u9AkHNMCAX0Rl3UkqXSb9C9d/gfWNI5PcgSzRaPXXOrNbbjpLpPdevX9g0vX8lxURdaresTm8YnzAYBc/SBWY1q0TDOyXhLVGVunaEUGwU5KbyJT4DIOLl4zlVKitDyEqH9RxDhwQQ6g06zdmzTDBYr1ZdXkW35GOkBQFhrIazFyRJrI98qri0wzUSiI/gI4jGqU5OK4cAXMzfhOcZeGnQKEvH5B/naKrUfGqYwfEeJJDnUpE1wik3J602fKcQKIgj+DhAXWZZeoPU8kqVMeq0OEZzy2rOT2tIAlwRTElMp0mybYF9MXT44fgfR6gGlm/nT2rfAve4V+txmSE5eDdHhh+Vb5kK5jV15PmKt6Xb2bmWW8i5HTncOOsLQN7dcNG855Ggr1H187lDBDPi48KTPCu6V5LHiKXvXc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(2616005)(5660300002)(66946007)(66476007)(86362001)(6486002)(44832011)(52116002)(36756003)(38350700002)(38100700002)(316002)(16576012)(53546011)(956004)(26005)(83380400001)(8676002)(31696002)(2906002)(31686004)(8936002)(66556008)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bXowdjZvQlNzSXJTeXBZdC8xVTVIMHdRN1k0T0tBWTg3eDNzN3UzYU8rRmlK?=
 =?utf-8?B?YjdZa095MGt2SVhnS3V0eFBpeGJSRkUxZjE2OTlzQS9GSlZZN1IvTjcyK29K?=
 =?utf-8?B?T2FHOHNzRUY1N3RsSUtnQlZlZFZ0dzV6TERiV2FMNG5IZXYxL2xsMVhocVcv?=
 =?utf-8?B?b3dXU3ZuUHpZbWpzeTZZdHo1QlQ5N1JtaG9qNmpadkxySkE0YTdiY1lXcGJk?=
 =?utf-8?B?Y1UzWWx0bmk5YkdScU16YmhlZ3JwVlhIbWZrSHFZcEV0ZmloYUpzb3dmRldu?=
 =?utf-8?B?MXUzcXJGL0p3dWwwSFJFeGMxeTFSVTlHTS84cVBLTU1RVWhtdUhVTVFreUJv?=
 =?utf-8?B?YnV6Nng2bWVqay80R0N6WGdyc3JVaURKRnoxbFpYQkRya1E2YWpEMzZrOHVM?=
 =?utf-8?B?VzNzdEUxNTFiN0Z5eW9QMkV3VTQveFBYZGpodXh0MTNodTJweU5jVkd6cU5l?=
 =?utf-8?B?TUhsTzl3OWplbHg1QTdCMzNWMzN2eGNmVDhNNFBFV2crcUwraFZSWTBzL2RD?=
 =?utf-8?B?NHFneXlBZFUzQmExSHBpVCt6Vlg1UjJNcTZLbEtZSlVUNXVtVEVQK1A2Wk9m?=
 =?utf-8?B?a080Sm1NVXMvYnhjZWhGby9NUWxsRWhoVEp2c3FES2xpRC9aWnpJd2huaTdE?=
 =?utf-8?B?Z3Z6UE5rOWhGajYxeWgrT3VyRGZOVE5kOXJYaENQSnQzd1UydUk5N0hCaXk2?=
 =?utf-8?B?L0ZNbUREelgzTFp3cUJ3dlpSRlg1UDByc0ptN0dxVDE0VWRDTTRubUExM0M1?=
 =?utf-8?B?eDhPbktLVXN6UWNHVHFrWTZYUEFnc3pRRU1WWmtjTDNEa3V2SG5WSjlBb0VV?=
 =?utf-8?B?UTVNLyt1UlFvcjJWZVB1YStMUGVXbE9ZWW9aQ0FvT2N5UXR0UGU2eXdJMkpH?=
 =?utf-8?B?bUR6eFkySWxOUTB3eDlMN3JnTHE3allYbkxSY0JVUGFhcFk5eFFKU2xodkU3?=
 =?utf-8?B?MVhFbmRHNWliVGVXOTZ5K2YzSXRhOURmUmJiZ2laUksvQW1TM3R2UjVIbm1P?=
 =?utf-8?B?TjBlVnVFY3NBUjYzMStDK1NhbkRFQVBDSkxuMGIycmFxL0kzSTV1Q0ZxR2ZG?=
 =?utf-8?B?ZURVODgzOW5FTktrSlZNeDdhcEtPTTl4YlpyTlJPd2szY1IyMXlkbVo4QXUr?=
 =?utf-8?B?c2tRSGtya3VzdWlLQnlKTnlVcmR5cHU2QVlES0h4UWRXbHpHVkxlV2I3YmND?=
 =?utf-8?B?MVhrMFdqamFlY21UWGZzc1VPS0pLdTdmZXgwWXhwa2dnMHFGS1E2NHRWV1ls?=
 =?utf-8?B?ZCtJUEViRjdPeVJqYkZ6NG5hQ285NjlpUkRXYmJldGFBRHBZWnR6K3dyOWtS?=
 =?utf-8?B?Z1U3RzNDN3R0OFltYkEyRURJdklHZW8zRGY1anpFbHdoTW5STkdZRWF1MVFy?=
 =?utf-8?B?ZVR0Z09EMzFVZlkxclExQms2VWdKNWtuc0JzN0N6VG80MkhZcS8rUHJIRDlI?=
 =?utf-8?B?K3ovb2U5Q0sxcy84WjZnb1dPVjBBa2RISEdoU2gyTnBmVnJnSkFDZ1JYUkEz?=
 =?utf-8?B?UGlDUjRSMUloNzhBTERCQmQ1RE5QaHZyUUM1MXk2S0M5SUEra0FNOG5Ea28r?=
 =?utf-8?B?SUZNRXpaMHp1VmpRSE44QUM0SmFrS1YxR2N3YWo4RGJOaVBFY3luRDkvekdj?=
 =?utf-8?B?a2Z1Rm8rZnVnYUN2U25SUjI1QkQyRHFrZUMvZHNnVWZMS1k2a0xNYk13aHFF?=
 =?utf-8?B?dUFrNmRwMEgrbTlKaFpPNGZJWVN0VFk4dHYxYXl0anhRekREY1hBdEFHWHU4?=
 =?utf-8?Q?CK7lm3TPK2Kmx9nP57zArMOjUbmFTtRp+x09UZC?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5149f855-215d-4e1a-0a27-08d96f1f0edb
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2021 21:09:03.4526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iaWDnwwePDjx16dCYpf7X+vwZ1eStwNHbL2zHMeKdZcgDemmWz3NCSoWpRnn1+8kAuB8DtMHBSE7QSYIb4Xrb6ygXuRiFPjqmURgs/7Dp0k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4765
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10096 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2108310000
 definitions=main-2109030123
X-Proofpoint-ORIG-GUID: ZTldss3KIO_Bl5_ZAeQ6JbfnhixAV01b
X-Proofpoint-GUID: ZTldss3KIO_Bl5_ZAeQ6JbfnhixAV01b
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 9/2/21 2:59 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Intent whiteouts will require extra work to be done during
> transaction commit if the transaction contains an intent done item.
> 
> To determine if a transaction contains an intent done item, we want
> to avoid having to walk all the items in the transaction to check if
> they are intent done items. Hence when we add an intent done item to
> a transaction, tag the transaction to indicate that it contains such
> an item.
> 
> We don't tag the transaction when the defer ops is relogging an
> intent to move it forward in the log. Whiteouts will never apply to
> these cases, so we don't need to bother looking for them.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
Ok, makes sense
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   fs/xfs/libxfs/xfs_shared.h | 24 +++++++++++++++++-------
>   fs/xfs/xfs_attr_item.c     |  4 +++-
>   fs/xfs/xfs_bmap_item.c     |  2 +-
>   fs/xfs/xfs_extfree_item.c  |  2 +-
>   fs/xfs/xfs_refcount_item.c |  2 +-
>   fs/xfs/xfs_rmap_item.c     |  2 +-
>   6 files changed, 24 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
> index 25c4cab58851..e96618dbde29 100644
> --- a/fs/xfs/libxfs/xfs_shared.h
> +++ b/fs/xfs/libxfs/xfs_shared.h
> @@ -54,13 +54,23 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
>   /*
>    * Values for t_flags.
>    */
> -#define	XFS_TRANS_DIRTY		0x01	/* something needs to be logged */
> -#define	XFS_TRANS_SB_DIRTY	0x02	/* superblock is modified */
> -#define	XFS_TRANS_PERM_LOG_RES	0x04	/* xact took a permanent log res */
> -#define	XFS_TRANS_SYNC		0x08	/* make commit synchronous */
> -#define XFS_TRANS_RESERVE	0x20    /* OK to use reserved data blocks */
> -#define XFS_TRANS_NO_WRITECOUNT 0x40	/* do not elevate SB writecount */
> -#define XFS_TRANS_RES_FDBLKS	0x80	/* reserve newly freed blocks */
> +/* Transaction needs to be logged */
> +#define XFS_TRANS_DIRTY			(1 << 0)
> +/* Superblock is dirty and needs to be logged */
> +#define XFS_TRANS_SB_DIRTY		(1 << 1)
> +/* Transaction took a permanent log reservation */
> +#define XFS_TRANS_PERM_LOG_RES		(1 << 2)
> +/* Synchronous transaction commit needed */
> +#define XFS_TRANS_SYNC			(1 << 3)
> +/* Transaction can use reserve block pool */
> +#define XFS_TRANS_RESERVE		(1 << 4)
> +/* Transaction should avoid VFS level superblock write accounting */
> +#define XFS_TRANS_NO_WRITECOUNT		(1 << 5)
> +/* Transaction has freed blocks returned to it's reservation */
> +#define XFS_TRANS_RES_FDBLKS		(1 << 6)
> +/* Transaction contains an intent done log item */
> +#define XFS_TRANS_HAS_INTENT_DONE	(1 << 7)
> +
>   /*
>    * LOWMODE is used by the allocator to activate the lowspace algorithm - when
>    * free space is running low the extent allocator may choose to allocate an
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index f900001e8f3a..572edb7fb2cd 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -311,8 +311,10 @@ xfs_trans_attr_finish_update(
>   	/*
>   	 * attr intent/done items are null when delayed attributes are disabled
>   	 */
> -	if (attrdp)
> +	if (attrdp) {
>   		set_bit(XFS_LI_DIRTY, &attrdp->attrd_item.li_flags);
> +		args->trans->t_flags |= XFS_TRANS_HAS_INTENT_DONE;
> +	}
>   
>   	return error;
>   }
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 8de644a343b5..5244d85b1ba4 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -255,7 +255,7 @@ xfs_trans_log_finish_bmap_update(
>   	 * 1.) releases the BUI and frees the BUD
>   	 * 2.) shuts down the filesystem
>   	 */
> -	tp->t_flags |= XFS_TRANS_DIRTY;
> +	tp->t_flags |= XFS_TRANS_DIRTY | XFS_TRANS_HAS_INTENT_DONE;
>   	set_bit(XFS_LI_DIRTY, &budp->bud_item.li_flags);
>   
>   	return error;
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 952a46477907..f689530aaa75 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -381,7 +381,7 @@ xfs_trans_free_extent(
>   	 * 1.) releases the EFI and frees the EFD
>   	 * 2.) shuts down the filesystem
>   	 */
> -	tp->t_flags |= XFS_TRANS_DIRTY;
> +	tp->t_flags |= XFS_TRANS_DIRTY | XFS_TRANS_HAS_INTENT_DONE;
>   	set_bit(XFS_LI_DIRTY, &efdp->efd_item.li_flags);
>   
>   	next_extent = efdp->efd_next_extent;
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index 38b38a734fd6..b426e98d7f4f 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -260,7 +260,7 @@ xfs_trans_log_finish_refcount_update(
>   	 * 1.) releases the CUI and frees the CUD
>   	 * 2.) shuts down the filesystem
>   	 */
> -	tp->t_flags |= XFS_TRANS_DIRTY;
> +	tp->t_flags |= XFS_TRANS_DIRTY | XFS_TRANS_HAS_INTENT_DONE;
>   	set_bit(XFS_LI_DIRTY, &cudp->cud_item.li_flags);
>   
>   	return error;
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index 1b3655090113..df3e61c1bf69 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -328,7 +328,7 @@ xfs_trans_log_finish_rmap_update(
>   	 * 1.) releases the RUI and frees the RUD
>   	 * 2.) shuts down the filesystem
>   	 */
> -	tp->t_flags |= XFS_TRANS_DIRTY;
> +	tp->t_flags |= XFS_TRANS_DIRTY | XFS_TRANS_HAS_INTENT_DONE;
>   	set_bit(XFS_LI_DIRTY, &rudp->rud_item.li_flags);
>   
>   	return error;
> 
