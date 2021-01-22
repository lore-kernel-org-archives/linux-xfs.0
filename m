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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4507DC433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Jan 2021 03:49:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05A8623899
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Jan 2021 03:49:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbhAVDt2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Jan 2021 22:49:28 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:41654 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbhAVDt0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Jan 2021 22:49:26 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10M3Uxxt123018;
        Fri, 22 Jan 2021 03:48:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=3b4+m+Jh64mzTaTdld7GqGWWtw2mW+uS2ztqHvBUtPY=;
 b=y30joQ9GR9v6bITVK0+gRpm/Qs+x8rd4PAOo489JMWXZTAi4KKPlhsHyNqxidF+Aixpf
 DNhOAS9FkZgAGDhIc22OpK84OdCPIW3/eRi159dC1+zoHywBj7wJlja0UTc3nOuoEtJ5
 sWnpTQP9UmmXIWoByrKFfqE+jPVM2k5hamFN/g3LdYSBhBQgtxnnGiGoAdBsvE2UgmjI
 oDZde67FiunVgtI8O8hrC0/6dQmM5HCwZP7qr1YF7l4GOyy9txymsnG7UAzyOAPyvIFu
 liNslB2yGgmartSXIDrjGVefHtPR0AlvPTJYaWSK6zy52ztghtmGM19v8oRSDOZ+Zfmr lg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 3668qn27vk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 03:48:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10M3OsNh150486;
        Fri, 22 Jan 2021 03:48:41 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by userp3020.oracle.com with ESMTP id 3668r08rtx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 03:48:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NUoyIb/uMZKC20wUOdsTVXzt5H3l2CMvQ0IlTdBwMqCdFqjcs9vUzF0jW0vO+zOsuHShvSQH4bwUE38afqCp1xP2sfq7rRU5CFkc6dsTPKC51bH7ujOWVkNMhTkGP6IgAM9H0fOgCZnzuLqps4t7eS4MQ8id+rr9NywgoXGDj4cNsAxUM8jhG9g1CjdNZ9q0qg9Ggg6YHFdfMrD34qJOluMwxfVqpylhxZlTz5s7MSkoaQzdkjiRIi0F+4vWO4UVXRlHW22/z/7I4BdkcCThVtB7Lqz5iQdnInhsDkO8hKcZMJPndwElS1Cg9VrSAXNwccQKZQ1RqtF1qbRp6wTgnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3b4+m+Jh64mzTaTdld7GqGWWtw2mW+uS2ztqHvBUtPY=;
 b=gdYX0Sq5TPFNGK3aR6h1Bq1dnnH+azGF+So3msSoSFVYZn1HOTLbPeFRTEifmLLAG7O9jbsMs8+527zN8vfHaxlXiCuwHukXp7einMtDxTX/+n+zIpS7MG4TloyeeGNXy5026JNdxhv+Bf8P1DVUzW/I3dXskDAzHAtlpxjsAluTFulrQCd8CXs9Ws/fnaq+k99Fw0SYPApbjHCgyJt/xGTX9bZf6HTNw8PbUoPS1ajpJ/wNIEdCcIWpntsjB1wdHw4utPAJeGevSKEbpJ7A0NsHU92VFjC/pGFlq0BxTI9+J7MI2ba4scsTWN5ESplrxZhkAyIIlHk3sE+s9pfePA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3b4+m+Jh64mzTaTdld7GqGWWtw2mW+uS2ztqHvBUtPY=;
 b=Mzgg39ND9epijnR2lfbL239oqOd1mkI+1dCdtTjd7MB03R4eIKfe2cy4Bzm7aF2tK/HN4W5jXre4Z0nsiNabMirFb3GALFKCbFboweIT0jy5q09L4qpUzTvBXAkw54JsR/UkwVw1wXpR9XPMduQ/3FUBi5/oPzjEqH0PynQVio8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4388.namprd10.prod.outlook.com (2603:10b6:a03:212::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Fri, 22 Jan
 2021 03:48:38 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::9105:a68f:48fc:5d09]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::9105:a68f:48fc:5d09%6]) with mapi id 15.20.3763.014; Fri, 22 Jan 2021
 03:48:38 +0000
Subject: Re: [PATCH v2 5/9] xfs: don't reset log idle state on covering
 checkpoints
To:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20210121154526.1852176-1-bfoster@redhat.com>
 <20210121154526.1852176-6-bfoster@redhat.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <daf97add-e7fc-c739-7999-5d98d6aaa736@oracle.com>
Date:   Thu, 21 Jan 2021 20:48:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210121154526.1852176-6-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.214.41]
X-ClientProxiedBy: SJ0PR03CA0038.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::13) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.214.41) by SJ0PR03CA0038.namprd03.prod.outlook.com (2603:10b6:a03:33e::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Fri, 22 Jan 2021 03:48:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91cbe276-168c-4ad8-d7a9-08d8be889a0c
X-MS-TrafficTypeDiagnostic: BY5PR10MB4388:
X-Microsoft-Antispam-PRVS: <BY5PR10MB438863B1C538A9544CAFBC7795A09@BY5PR10MB4388.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l6obbj1sY8ywREYdKarhasfN0aS7IziZU87gptUr1MInntCRPeQ6DeaPE0Zp6aahglNhc+qKcBJZ+GpQQ3wQK3XUkr1wgQB0ag2rLg2xYWPAs6FtVqn4MYi0kp4175dKL8Bt77EGT31rZ50fl++8mV8QokU/kfpQ0B5+FTZEZy4vziicv14bIGH8YI+FFrN+ijDT3c7pj2aQQh/S0wY7HTcymnOAmKw/0Rnxjz9QkVmr8h/UT53Nhii1nEFwifqeuMW20GyQq9Z9HOksVnMAfXcl4JTeS7beVb+GIiykpszEJKAgyzHXbL14kGMRCo+hmeDAQ7Oswd7aWaUCMcwI3DnYgwuvv5EXf8QzfBNOVpYwzimLWouabVmloHZpoysU1WOAlAc/iM1ssYrAbcVaYLgPS3gCpgA+zGKiYLuGs5re3kF2sx2vIH4FAFonfY6UKaerSHXGswon7TgzZJnePEOLIZnrWJopb8u2viVvfRSjjDHL0zUe1YHqrNFtlPHnWHlSGFIQzvum+PaOgkYqKGdm+fjutbLlqHZ4d/yk2QYqTwWZ+/UySF7hz3F5a+KoYLSLMj3tqu6FlSIW6JHanamb8OA//ODgq45k1W+nclI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(39860400002)(396003)(136003)(376002)(956004)(36756003)(2616005)(66476007)(186003)(52116002)(66946007)(26005)(66556008)(44832011)(16526019)(83380400001)(2906002)(16576012)(31696002)(86362001)(53546011)(316002)(31686004)(6486002)(5660300002)(8936002)(508600001)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bDRqbGNSNWVkYTdhUllXM0JCR1JPRjVIZ3JBSnNia0VwVE03anhBY3R3SU9E?=
 =?utf-8?B?VU9URWFIQXo4Z0VrY1IrWGJUazQvQ09LblJTM0g3ZWd0UDlNOCtPN1NoamI1?=
 =?utf-8?B?d1ZuRVU3VWEzUUpqQWQySE1ZT0FWQTIvV2lZOVFKOVJGdmc0OVc1VVQxTjRO?=
 =?utf-8?B?alplenRqaE1DU1lZMmI3bFVMY25uV3F1SkJtK2ZUV2lzL2plaEQ4dmcvNHdU?=
 =?utf-8?B?Rlc3RVhvZE55RzR4RE5UaFB4eEF3ZXA4c2JiZEtrOHlNanZRN0x5MUZxOFd1?=
 =?utf-8?B?Qzg4SWpMd0tzT0lBV0Z0LzhvRVdDcmxGZ0NSREkzcWgwaVpCbm9PQ0ZFaytr?=
 =?utf-8?B?YkZMNUI4WUNnVUZOSUZyUk5keDlGb3A3Y3lrT05JMEUvODVkdGtJVWt1cHRv?=
 =?utf-8?B?MWlabGIxaXRvQkhIQjFTZmZpYWtrQ1ErUTN4eWZpdTBpdGFXeFRyVy96Q0tW?=
 =?utf-8?B?cmZPK2FDVmhwbXpxQTdHblIzVUwvcXE0ZWlnbHExU01iMzcrd2d4UGU1MUdi?=
 =?utf-8?B?L1dIcy8yVmJXUkxqcU55ZGwraUV1aUdTQzhWMTRBc3RlcTFkeUZaalJDa0hG?=
 =?utf-8?B?WjY5N1NTQ2hGYytPNGpJc0pnNWJsU1dPeU02SE5VUU1Ed05aN1JHbGJqUk5i?=
 =?utf-8?B?bHl6Z3hyUDMrcW1YMTVtSGhXUlpBOU5FL0tqaFpwT2hQakpRV21raFh5WG5B?=
 =?utf-8?B?UTAvaHZMbmRCdG5vK1VuUTB6RFNxTm00YStXU2VySlVFY1ptQ1I5RUtHQkhS?=
 =?utf-8?B?SWY2Rnh4am1MV3BZRGxDNFMxWFppOXh6aXlickJaZitFeFF4bjBDbTRIR2lD?=
 =?utf-8?B?RVI3S2wwUU90R0p4NENQbnJkLzNMMDZNUWpwM2N6U1ZVUXF2MHgxcmZjd2FR?=
 =?utf-8?B?MDVRMXlJcWFPenBoQ0lmdm1xRFVSeEdUYngvRHhWU3RQa1EzMzdWdlBZQXJD?=
 =?utf-8?B?Zm5ickwyMnF1WmlyT2NnYXNjZk5rcUxrNXhCaTVEdjRaYlJmNmpUanRVTzN4?=
 =?utf-8?B?QnNrU0ZMb09wc25QblBpVFYzbUVwM1pYd21UTm84MUt3MWJkQnRYS2ZreEpO?=
 =?utf-8?B?M0gxbStTRE8ySFM0TlVtYXFhSVJsRjZ1STI4Z3BXRFFVQ3RqZ0NaVEVmYXdn?=
 =?utf-8?B?MFRaT09GeWFiL3hvTjdGUjVRR3NHdlV2bEx6ellVK1dzODFZcEx6bHhNWWgy?=
 =?utf-8?B?YXdqcnllMEFETEI0aGVUTzZ2b1U1YmVSZzg3NnNTOWFpc2lQQlRNWXVhNjVP?=
 =?utf-8?B?bmpjM1BoS2JEYlBuUDk4bGV0ZmF4U2c4N25IOU91NERoTHBYRkhZK3hWaUlo?=
 =?utf-8?Q?9cOhJC3XdSMoM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91cbe276-168c-4ad8-d7a9-08d8be889a0c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 03:48:38.4219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CXzayPl7kCpNJ0rn3tslzxfmg+c2ZCKGkFEVHC6qPvzrRDm2dG4BY+rAbk6zCfulRO03AE1ppkMxhNxYXhoJIEzIeQM7Q9IUDrxlGSi2IVI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4388
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9871 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101220016
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9871 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 adultscore=0 impostorscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101220016
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 1/21/21 8:45 AM, Brian Foster wrote:
> Now that log covering occurs on quiesce, we'd like to reuse the
> underlying superblock sync for final superblock updates. This
> includes things like lazy superblock counter updates, log feature
> incompat bits in the future, etc. One quirk to this approach is that
> once the log is in the IDLE (i.e. already covered) state, any
> subsequent log write resets the state back to NEED. This means that
> a final superblock sync to an already covered log requires two more
> sb syncs to return the log back to IDLE again.
> 
> For example, if a lazy superblock enabled filesystem is mount cycled
> without any modifications, the unmount path syncs the superblock
> once and writes an unmount record. With the desired log quiesce
> covering behavior, we sync the superblock three times at unmount
> time: once for the lazy superblock counter update and twice more to
> cover the log. By contrast, if the log is active or only partially
> covered at unmount time, a final superblock sync would doubly serve
> as the one or two remaining syncs required to cover the log.
> 
> This duplicate covering sequence is unnecessary because the
> filesystem remains consistent if a crash occurs at any point. The
> superblock will either be recovered in the event of a crash or
> written back before the log is quiesced and potentially cleaned with
> an unmount record.
> 
> Update the log covering state machine to remain in the IDLE state if
> additional covering checkpoints pass through the log. This
> facilitates final superblock updates (such as lazy superblock
> counters) via a single sb sync without losing covered status. This
> provides some consistency with the active and partially covered
> cases and also avoids harmless, but spurious checkpoints when
> quiescing the log.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Ok, makes sense
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_log.c | 9 ++++++---
>   1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 7c31b046e790..6db65a4513a6 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2597,12 +2597,15 @@ xlog_covered_state(
>   	int			iclogs_changed)
>   {
>   	/*
> -	 * We usually go to NEED. But we go to NEED2 if the changed indicates we
> -	 * are done writing the dummy record.  If we are done with the second
> -	 * dummy recored (DONE2), then we go to IDLE.
> +	 * We go to NEED for any non-covering writes. We go to NEED2 if we just
> +	 * wrote the first covering record (DONE). We go to IDLE if we just
> +	 * wrote the second covering record (DONE2) and remain in IDLE until a
> +	 * non-covering write occurs.
>   	 */
>   	switch (prev_state) {
>   	case XLOG_STATE_COVER_IDLE:
> +		if (iclogs_changed == 1)
> +			return XLOG_STATE_COVER_IDLE;
>   	case XLOG_STATE_COVER_NEED:
>   	case XLOG_STATE_COVER_NEED2:
>   		break;
> 
