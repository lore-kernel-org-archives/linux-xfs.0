Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BDD6C433ED
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Apr 2021 21:37:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1D1161090
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Apr 2021 21:37:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236994AbhD0ViH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Apr 2021 17:38:07 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:48446 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235440AbhD0ViH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Apr 2021 17:38:07 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13RLYW1o008920;
        Tue, 27 Apr 2021 21:37:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=s4Yh/e1eI0F/Njyx7D+5ifY0olVFA8tYi4C5fZMu2RM=;
 b=MnBghkKqHVdMK2VHyow6WLC4YKx8fywfzlEiN3vNq4iaKRFMgrA01u072NLjcRkCfgeV
 rNWh0yEGPOnWuy7k8GrMClLz7uwQi/hmMOOz/geayfhNXCglVxNPLxHwWz9xWtD1w8nN
 1l0/Oj0Q6mcbM3tSnQZ36ykTpbqyY3TYp9pMvCmYNi/eenYmUogIJSdgJN6GfLzq47eh
 0KlAtolneT0xKVgvb+vnLkDOtb7543Ee9TGZ62pkd46tns0MSZZJBu+d1XzF+R61oDGO
 uR0EnSEiKWf8lBufQ8rsN71+kZiu6+Qbvr9WvASjjLp9Opi9xKjlOBKmx3px7Nwr33sd Rg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 385afpy0he-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Apr 2021 21:37:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13RLTm37041136;
        Tue, 27 Apr 2021 21:37:21 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2041.outbound.protection.outlook.com [104.47.56.41])
        by aserp3020.oracle.com with ESMTP id 384b57aqkj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Apr 2021 21:37:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PTQV4S02bWGax1Q4vgtkKKYDCJYydeKLpjeZNdVby8oQRfEyXjTJ6wi6nIT7X0QSPxGmJ52OcEwm+xbnHxJA4NAqCvKDdo1JsBnEayO7QhgtyjCDvuM9xQBFCUiDRyheQHJNsEEeZ6r5CVflwCBRnAnJu5shKrtj8WKTraugY+fHOLjkj//lkn4705y9Jh+21msmOWiFLYUjsxoz3u14hb/8buY527fxLcEaq2jMS2geps0f/+KnyzUCCs02AWySjWjIrY65OOcYCOzmN/h90StTLgBa5fP6xBi1AjcaSKVyqJmPGLR4lpZeqZCbp6JakJtOdsIfaATK19zW58QZBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s4Yh/e1eI0F/Njyx7D+5ifY0olVFA8tYi4C5fZMu2RM=;
 b=JZEtXXvtGXQ5FYLvGSHUWD3iSgE105MLYnSy874PPo76KY8farJCKv/ZAbnyY8tKbWyn48UdWCz1AaWV/smMjwDvJVhn/yErHVOdgndNMHcNF5SsMh+4/UhW3g8sbXBhe2YjvV7LpDGlQ8AJaOmltUe1Qc2L0vZFkktUnQ9j7HChm6FrN0HJlPkKrRTJw8sJ0T+EQLj1vYsG848VUz0hACzS9OD/V87rAda1nzEmfdZSWEjorpRq3qGVNZLBTenJntdwRaere9oP8jw8f3op1PMk2yY3mSX5xwf1u2olT6CYFK+Uec4UtH1Ncwjl/xeiwPMy05zffmlxCa3UVA36Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s4Yh/e1eI0F/Njyx7D+5ifY0olVFA8tYi4C5fZMu2RM=;
 b=gUTU1Bf5pnpzHLmWgRoakIxgQVxkrfwpDZqDNYkzxKjTg4jjx/TfAJ2muGidbyOv+kmk5udDK+nhb8LoVFgvqeQvWmvmaNkyRh2F4xvW0ogLRvsCQaPaQfII5M75fy3FNAGyDPhij41s5HwX1cOGGoCG0fOr4cmpafJ4iO4L1D0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4637.namprd10.prod.outlook.com (2603:10b6:a03:2d6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.26; Tue, 27 Apr
 2021 21:37:19 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.024; Tue, 27 Apr 2021
 21:37:19 +0000
Subject: Re: [PATCH v4 2/3] xfs: introduce in-core global counter of allocbt
 blocks
To:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20210423131050.141140-1-bfoster@redhat.com>
 <20210423131050.141140-3-bfoster@redhat.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <7086c26d-e886-a856-bf1d-b1333c974e68@oracle.com>
Date:   Tue, 27 Apr 2021 14:37:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
In-Reply-To: <20210423131050.141140-3-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: BYAPR02CA0017.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::30) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.222.141) by BYAPR02CA0017.namprd02.prod.outlook.com (2603:10b6:a02:ee::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Tue, 27 Apr 2021 21:37:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8a76cb5e-7301-4f63-f49f-08d909c4a25a
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4637:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB463790362D32BD2D0581A0A595419@SJ0PR10MB4637.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jTwCQ3TBNwQlfQs3EHu+F1HM65IlUOqubnP+oS3OQojQYUVsD+s1JHwCpImVKIyVhj8jB9o4VBD9WILcMGe5plUIpu+veii5wS3CEjEY0DDPxjzSTyMHyFoVZyMCUt/0/jHBsVPosOlDwIGtTUU/JGGchI2kLUsR5C9sjl6A8Z1OCwtoROB081cuoLbEFECxoeBEePnXI/+i0YRP1+g8FvNToNfGKgS8g3ycLE78KiC6VqNS/pmH+prcz3ZboKCNZ7GLcH7+BgDB0XaAfHlE/DiY4kZZrNAIGX9EdJpSMnqLmCZ99H3Nj3477q9mrqmaZ0z9hOT+2tl4xFA2C+3cAgGCwaGQwrEDe4yBlTjSwPPv6+AiI6aMDuxjRfLEy09iv/iqXJSl2f/WL1JuG05VUuKaOHmfj6Va+SJlVXNeqqH3BxjWqMjJTJBd0X7XKZJWqJlA58EC4kzkM214bXg9WdkQO4fEjH9dzqslkedClIYKQOktK9Lmb+69yzgb238A6srJiS2/tWMdnucgYxYLlke4lM1L13bLY+/DoPmf9p9CfvejFgHByM26J2dRudlO1XwoJUlObL+J6gzE4lReNT6afG6Wzp/avSP+RyxFUWjOwE/wnBcOxaY3ShwZVnmPMc3+lnf5w05jjQay4qqKlGxHTw77hZcIm6Q65MijmkTdxuvHPD3QgOs3tOjzvxDQltRin593Oj8cH9IojIm4HQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(136003)(366004)(396003)(346002)(36756003)(2906002)(52116002)(16576012)(53546011)(478600001)(316002)(31686004)(86362001)(16526019)(38100700002)(31696002)(38350700002)(44832011)(6486002)(186003)(83380400001)(26005)(8676002)(66946007)(5660300002)(956004)(2616005)(8936002)(66556008)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QVUvZExSSlo1dzFSRkV3N090OXdGTzRpK1Uyd2tReWI5Q3I1RlZuR2M1MGli?=
 =?utf-8?B?aTBtSWI1Y3gwY3pmTG5KWUpFTTRlTmpkRGNwb2tLdlpXL2ZSb0N6Z1laejZl?=
 =?utf-8?B?SVhUTlhiUm5uaXFjU1YySlRUYUlsa05OcXFpbHExa0RpcmMxdEtiTWR3Q0Zo?=
 =?utf-8?B?cUtaT0RZTVRiQlN1NXlvSjhPRDkzdnVFa0h4K0wvYXg2Q20xYkw2Z1BMd1Yr?=
 =?utf-8?B?TEhpaXZzMjlhbmJGblRZU25ZbTNJKzVRN3dsSUZVRi9QZi85NERrZHdldzBK?=
 =?utf-8?B?QlJySVdkWG5lbm53bFY1VXV3N1FueUY0SU13aU1KZ2xSNHNzaGJPS1l0cjds?=
 =?utf-8?B?a3JRVCs2VkczSFVyZWhiT0d6dkQ4NmQzOUJpSFNGVkRTNDlwcGVCZlV5MjJY?=
 =?utf-8?B?ZE9JVG1DVFFiOGEwVXVOL3lHZW5Sa042enVqWWRrS01wWVBCaTVnQkE3aHJI?=
 =?utf-8?B?RXVXOUg3ZW9ISTh6eXNVVThGVnNLT0Fad1Y2TkZmLzdjUTIwMFlqSFBSZDlK?=
 =?utf-8?B?dHpCbUVHMmdmM3NtOGpwT2x5d1BTNDlKOHZwcE1YK0FTRnh3QTNCeUtGb2FP?=
 =?utf-8?B?bXorTVl1MUNrSkdDdjhoeDFOQzE5eExDNnVucFlVUkh4bG80YUl1bnhzeVZy?=
 =?utf-8?B?NkhGOW5IMVZpSHVXRUFURUY1Ti9Pc0RRbWN1MkkwMHZ6cHdJRms2MjNyNHZm?=
 =?utf-8?B?T3I1Ly9lYk1YdkhyVFFYL29mblBsVEMwbXlLZXhZc1JpdjkweVVpK3BuOEpF?=
 =?utf-8?B?c1p0RTVhK2pHYkhmN2dUVktNR0lUWjI3K2kzM1RmRk1jRnZhWDFTN0lSS0s4?=
 =?utf-8?B?RG9yZjhFRUQ2aVBSR1hYSjBTUExrTElLSktjN2hYaVBWVE9HUVdsdzVac3Ru?=
 =?utf-8?B?UTlwZGNsWGovQTdIbVRxUHB0cE11bkdieEZzSnRpdzFRV1YvOTdxZStaQlNm?=
 =?utf-8?B?NmJWMVBsSWdnVnRIRUZuZ1ByblVFZStUMlJSOUhvTTYyUDVMbWpZdkhadm5o?=
 =?utf-8?B?QU01bnNLMVpZSWZ0WEp6Y2xvTVlUelBPNi9vOWtFZkExUTlnWW50UG8yMjVs?=
 =?utf-8?B?U2ZneVpFQVJiNmozUzg1OFdRZ1NHaHQ0ekRDTGZCazhCYzliSHdjTWVuTUd0?=
 =?utf-8?B?dWRRRW96RFlIdzRzcU4vUjZnR0xLaXJvNU5BbHJtbHMwS2NTY2VYYW1OZGpz?=
 =?utf-8?B?L2JyZ1BDZGwrRDkxWTRHQ3U0UjN0eng3WGFSOVJoYXVITnA5VVBLSmRDQm5F?=
 =?utf-8?B?VzM4TUc1YjJlQmkxM1pwOXJxUkd3Qkw5djlmWDQ0Y21paHZoeDBMcUZKM2Fo?=
 =?utf-8?B?WUorUC9aT3lMNHhJYVpsSm9tM05YU3AyMHhBaDJxV2JXWG4reUJGM0dBK0px?=
 =?utf-8?B?T1ZtcXZLbGNad2Jyell0MGt2Y3JBaEdFM2tzblF2YWpTT3AyZXIrVGZyb0di?=
 =?utf-8?B?YUY2bXRNMEtHY0FWSmlQcFducmJDbHZQeGl0K05ERndNNU0zSFlxZmdGbzUx?=
 =?utf-8?B?VjllSHBGejI1L2gxWC9Gc1poODA0bU9RbURNbTdsN1h3S0Eva1B0NTRLK2RI?=
 =?utf-8?B?UU9jZ1lCRWZOMkEyd1AzRlFXa2JTL1d4NlluWFRweHYyempLNUJ5MlBLNWg3?=
 =?utf-8?B?Q1J2MTRSaktTOGZZWkxlcy96MU9ZT0NMdUs5Wk9tRkRPMHJJOVpJS3BxZGZk?=
 =?utf-8?B?cTh4dHdQTm5UaWEzSmhGK2g0dDNoQk42SlMrYjd5SG5HWVc1a25UMTFVQTNL?=
 =?utf-8?Q?xi84JIAnyq8X0mBd/yCVirWqmfc9bogo+d59IDj?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a76cb5e-7301-4f63-f49f-08d909c4a25a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2021 21:37:19.2880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 89xcw6axVusiT0w4O5EK3stH3Z+OyQ2prz4gMityfSYTupVSNz6b0CtJRM3jZ+PB7IzzQ0Ptzig/vsLHLDc4Ym1NlMHjbGjAkhPK5ziYXlw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4637
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9967 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104270144
X-Proofpoint-ORIG-GUID: SFu7WH2RzmI_r8QK3Fwlg_U3p11OSf-i
X-Proofpoint-GUID: SFu7WH2RzmI_r8QK3Fwlg_U3p11OSf-i
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9967 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 clxscore=1015 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 malwarescore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104270144
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/23/21 6:10 AM, Brian Foster wrote:
> Introduce an in-core counter to track the sum of all allocbt blocks
> used by the filesystem. This value is currently tracked per-ag via
> the ->agf_btreeblks field in the AGF, which also happens to include
> rmapbt blocks. A global, in-core count of allocbt blocks is required
> to identify the subset of global ->m_fdblocks that consists of
> unavailable blocks currently used for allocation btrees. To support
> this calculation at block reservation time, construct a similar
> global counter for allocbt blocks, populate it on first read of each
> AGF and update it as allocbt blocks are used and released.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
OK, makes sense
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   fs/xfs/libxfs/xfs_alloc.c       | 12 ++++++++++++
>   fs/xfs/libxfs/xfs_alloc_btree.c |  2 ++
>   fs/xfs/xfs_mount.h              |  6 ++++++
>   3 files changed, 20 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index aaa19101bb2a..144e2d68245c 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -3036,6 +3036,7 @@ xfs_alloc_read_agf(
>   	struct xfs_agf		*agf;		/* ag freelist header */
>   	struct xfs_perag	*pag;		/* per allocation group data */
>   	int			error;
> +	uint32_t		allocbt_blks;
>   
>   	trace_xfs_alloc_read_agf(mp, agno);
>   
> @@ -3066,6 +3067,17 @@ xfs_alloc_read_agf(
>   		pag->pagf_refcount_level = be32_to_cpu(agf->agf_refcount_level);
>   		pag->pagf_init = 1;
>   		pag->pagf_agflreset = xfs_agfl_needs_reset(mp, agf);
> +
> +		/*
> +		 * Update the global in-core allocbt block counter. Filter
> +		 * rmapbt blocks from the on-disk counter because those are
> +		 * managed by perag reservation.
> +		 */
> +		if (pag->pagf_btreeblks > be32_to_cpu(agf->agf_rmap_blocks)) {
> +			allocbt_blks = pag->pagf_btreeblks -
> +					be32_to_cpu(agf->agf_rmap_blocks);
> +			atomic64_add(allocbt_blks, &mp->m_allocbt_blks);
> +		}
>   	}
>   #ifdef DEBUG
>   	else if (!XFS_FORCED_SHUTDOWN(mp)) {
> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> index 8e01231b308e..9f5a45f7baed 100644
> --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> @@ -71,6 +71,7 @@ xfs_allocbt_alloc_block(
>   		return 0;
>   	}
>   
> +	atomic64_inc(&cur->bc_mp->m_allocbt_blks);
>   	xfs_extent_busy_reuse(cur->bc_mp, cur->bc_ag.agno, bno, 1, false);
>   
>   	xfs_trans_agbtree_delta(cur->bc_tp, 1);
> @@ -95,6 +96,7 @@ xfs_allocbt_free_block(
>   	if (error)
>   		return error;
>   
> +	atomic64_dec(&cur->bc_mp->m_allocbt_blks);
>   	xfs_extent_busy_insert(cur->bc_tp, be32_to_cpu(agf->agf_seqno), bno, 1,
>   			      XFS_EXTENT_BUSY_SKIP_DISCARD);
>   	xfs_trans_agbtree_delta(cur->bc_tp, -1);
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 81829d19596e..bb67274ee23f 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -170,6 +170,12 @@ typedef struct xfs_mount {
>   	 * extents or anything related to the rt device.
>   	 */
>   	struct percpu_counter	m_delalloc_blks;
> +	/*
> +	 * Global count of allocation btree blocks in use across all AGs. Only
> +	 * used when perag reservation is enabled. Helps prevent block
> +	 * reservation from attempting to reserve allocation btree blocks.
> +	 */
> +	atomic64_t		m_allocbt_blks;
>   
>   	struct radix_tree_root	m_perag_tree;	/* per-ag accounting info */
>   	spinlock_t		m_perag_lock;	/* lock for m_perag_tree */
> 
