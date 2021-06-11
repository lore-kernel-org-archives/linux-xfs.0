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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D93A1C48BE5
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Jun 2021 21:55:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B60D661364
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Jun 2021 21:55:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbhFKV5M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Jun 2021 17:57:12 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:64736 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229548AbhFKV5M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Jun 2021 17:57:12 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15BLobIc011223;
        Fri, 11 Jun 2021 21:55:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=9zMwKwuy6Uyj+xgGtP5yPnIElR7CVCEhInDhr8SPNKA=;
 b=WHcTkhKyiSDJjI9Sgprn3o/n/OyuamTWm/XJACmcdDbTvKzstaUWQVy7a60gneTe9Cnj
 n0quUf+MjOvg+BdvwGnYBW5ULDZRc+Ob87OMFtYWcGBWRwZ3Qhfgja+/ogHNiKr3aFE0
 f93NNUdrRRkwgN4wO/cSpOmrWMJIYXfrXYzVzLbrUvBJk3GdzEWceC7Uj6pQKvEFT7/Y
 fkWyyYqtbKGI23LomHFZcdj8qPi3ToFzZUcyFuQUzB1FkXgRfvk1aW8AHY0k1RS/RrBx
 8DJUhNRZjm8YYPo+Uqy02HIiLC5Pw08LXLnv04COElimnajx7a1jT+aINUDC9+1yI4v/ fA== 
Received: from oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 393y0x0acw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 21:55:07 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15BLt6d7003980;
        Fri, 11 Jun 2021 21:55:06 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by userp3030.oracle.com with ESMTP id 3949cwch18-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 21:55:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R0ob82wc4kcW1YhvaytS68xCTIncqWbaozzGbvdnG+jkYtkko2HnTIK9EgJ5t7tnpAiuQ7+R+75uBA8YNqK+LXhUeFgwxRmy4Oat6rdKbt20pf4bPKwYBAeNerWgFkhIDPLij3/WNxfESw+NTDZ/9OKRwhPWttHGXdTxt+j36FWvRmQJtOPRPy6x8a0I6/5itxeM3OwSLaaBIXTu21M+5yHyKM4XuhDyINguvftFL0e3RfNph1mR+VpGCaV4AXSCQ/RMzF0whoR5cn+gJnwZw4nlCfsj3ZUtt0hHDqa5IGpQgCYz4NQkwU74w7IZiSIX7YJdW/eQBNPNNgnsC5kcbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9zMwKwuy6Uyj+xgGtP5yPnIElR7CVCEhInDhr8SPNKA=;
 b=PK/OLFZa3O6Je7hQlHfWWp+bDQqo1G1VID/Rq6XOBB5m9606eRNjRlOD12RaveFx7eZZXRMzl0IZ7R4lWYMiy9ezaXSAeLWKqb99uDVyUFPit6SGiM0BnAGa+tkLceoRExKPNSUDRinmssBMFkwBnFNEqIipJI6QWoXnHYJwJ2yQvBftkn9kHC2Y6OUKfXObHvNDYckj1XBRo8eHBWDM1mLMUj+l61mtvmZWfRQRtsPnCV9+WJF0PzH5F7qr6Q6dyrnlqFHoM6nwpzCTOKWjpfo29oJ/b0VqROCT2WgDF82Xd9WKFgUfwrWrimCH2c7kzdhVfkAoTsXg+scIvdWoUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9zMwKwuy6Uyj+xgGtP5yPnIElR7CVCEhInDhr8SPNKA=;
 b=Hr7OKdV62YyzwIDgROXzio/isnp59MFDVp866umwKwDvxoLC+k9e+YW/3jf8zh9N5x9awkRlTdj+jMezsn3U595hR2+ev2/MnzMY4kqJHYd9Ztd9oxT6unxe2gIpZ6iZRrgEmgW//sImZTJW6httj2OBWrWb94d8TYQMKblI1Z4=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3955.namprd10.prod.outlook.com (2603:10b6:a03:1f7::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Fri, 11 Jun
 2021 21:55:04 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728%5]) with mapi id 15.20.4195.032; Fri, 11 Jun 2021
 21:55:03 +0000
Subject: Re: [PATCH 02/13] misc: move exit status into trap handler
To:     "Darrick J. Wong" <djwong@kernel.org>, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com, ebiggers@kernel.org
References: <162317276202.653489.13006238543620278716.stgit@locust>
 <162317277320.653489.6399691950820962617.stgit@locust>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <2fd3a9c2-edb4-5b4c-6741-1a2e10d1e99c@oracle.com>
Date:   Fri, 11 Jun 2021 14:55:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <162317277320.653489.6399691950820962617.stgit@locust>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: BYAPR03CA0024.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::37) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.210.54) by BYAPR03CA0024.namprd03.prod.outlook.com (2603:10b6:a02:a8::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Fri, 11 Jun 2021 21:55:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd63441e-e122-4404-5648-08d92d23916f
X-MS-TrafficTypeDiagnostic: BY5PR10MB3955:
X-Microsoft-Antispam-PRVS: <BY5PR10MB395527B620C8592ABACDEF7D95349@BY5PR10MB3955.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: utNiS/OsnywCj6Ki+wgH3G7TS55Fc5iIG943vtOKvIt8WYwdm0gPXJm8iNfIxbErMHmSCnzd/Cr7m2z82AABbXBHGAT8nqhXByhFXd2t0ZbpgBDBgv4zgWQtrp06ZhOii3Nf/EsnfUkw30RVGkE7gGCrWW7EbMzZAmI+NA1u6VVeiEEl6qt77zvsfvZZCQf4PUm/NwYWSbM+GqgtkbFMrrHv2JBjEQKc/rxzOfDY1D54GxUBg4GJOYRWaV3flwRIzseyV3TLw5WGiuE92IgOgFlTtJ+aFeyrX9Bx6G7PmAOf8axMekcSRbUjvew8x3SpgNoKyaUgRbp0R1yMjlfVDB25Dq/30PpL0txMaJzsvSwjCk05I7IhtsxKBj14+M4Zu8Aw61RfDVSmwBpSZqm4Lyi2xaAWkcgDKmQtUGWaBMalnzsZVIfUr21vVBrwq7ayCSqIlJ1qwKcQsqzOr7f+O/lj4y4vo5+qO71s0ov6S4m+je6Ln38YIhVTWnXmIOUjEv3I8/xtgOlN98H715SI6q1wxADZHqjHZwKb9gaQwB10mTrfCvktlEDaiygo5+IA8/BWZr9aCfzLH3ZqwkWOZQRMBFHBg8HxWprf/wO1Erd8ov+hXL38vvZS8OabdOtENQXSlCR05sdyx6yiH7LtZ2nbiM0bKYnFtnuJCn4el8nD+aeRUUpMwmeWKfOnr/1xJS8N0scNp3WYqKlq5FLwmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(39860400002)(366004)(396003)(44832011)(31686004)(478600001)(8936002)(4326008)(6486002)(66556008)(66476007)(5660300002)(86362001)(38100700002)(38350700002)(2616005)(956004)(16526019)(8676002)(53546011)(316002)(52116002)(31696002)(83380400001)(186003)(36756003)(16576012)(26005)(66946007)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a3d6ZUg4cHpvcjJwQWY1WDJuQkJIZnJidmlVRDhDME9EZUZWa004SlJIZk0z?=
 =?utf-8?B?QVVpRFp4bGdTdTRJd3FLRS9EY1MzMktVcFprT3pjbmNqMEJwQS9NdjREWEFR?=
 =?utf-8?B?NjdXMXp6d0J4OVNkb3dybXJIQU96aWtDaFZzZXAyUVo1ODl6MWFRZUFwS1l1?=
 =?utf-8?B?dE5INXBUaUpxNld6UHRnMkRPUnhJTi9QS1hybUNXOEFhNkZIeWU5WGFmbUlh?=
 =?utf-8?B?VVpFUlZ5WnNvOFI2Z2ttdytmLzRGWVgxeS9JWXpSRnY3Y3R6bXJRZTc4WjUx?=
 =?utf-8?B?NEg3RXhvVnJXNFBwa2lPLzlVYkdhdXoxMWovYXBvYXNDeTd1R2o1L0ZLL00x?=
 =?utf-8?B?cTJMd3FCUCt5TTZQRk1QVXhoNE4xdGtXS0VKNDg2ajRzUkpablRDdGxnbkJU?=
 =?utf-8?B?VTBJUHJBYnVKemQ3WWxBVnJmenNtL0xabEJnNjdoQ1Ntc2VDWnBPbU4yYWpH?=
 =?utf-8?B?V25EbmpoQ0hBWFlhSTJBUmZ3T1BYNnQyVHdRaFh5aEJIendpUk9rRVlGT08r?=
 =?utf-8?B?S25jL1RkKzY0bDVCYzZ1VTNEdWlza1VQN2lVZkIzWFk5TjRObThPNHgydVYr?=
 =?utf-8?B?cXA0emc4YTJtay9laHo3SnAzNnh4RlpjZzFtYzRuNUp6eFN4RW1RT1JJd2VZ?=
 =?utf-8?B?cW03YXYvUE5rSjZBOTFrVkxUVHNSWDdyN3Byc2ZmY0c1MWVmMjYwWjliUnA4?=
 =?utf-8?B?RjM5ejFhSFJ2N29GZk1KL0FDT0g5V2UzMXpaVHI4eFhrRVNtNmhDcm0zQlRk?=
 =?utf-8?B?aFNmaVExanBFMTRyUDB6V1VIcHdHNjBHZ2VaUXJHeUZYOVZsbTBudGxmanpq?=
 =?utf-8?B?SlpZSGlDQTVKN2JhMUx2ZW9pY2JIclN5a1E0TVY1SDc5TnVpUVhtVjh5aGlh?=
 =?utf-8?B?Y2hjeVdTUlp6cVpxRXB2RFhSNzJTa3NTWHJ1Y2kyL3FQMmpqRzdXbkh3bWRu?=
 =?utf-8?B?anNRcGpTZS80KzBCNC9vRWtmeC9uZVhMWmRkWC84WEhGMmN2ckJYRVpKQTYv?=
 =?utf-8?B?cEhnWkhrQjlEeE55c1VlY0JuQ3VZZUV4WC9hKzBhZERPYUhnWlVhQlcrSVFM?=
 =?utf-8?B?eWJTUE5OOC9mbHZCOTJSUDNneVN0OXk4cWtEVElyeHBDQkJkQUhKWjNubWI1?=
 =?utf-8?B?U2hoYmpIcFlHajIvckNIQ0hCc1ZZS1pZRHdjRmV1WTA5bUg4Q3FONExQRTdm?=
 =?utf-8?B?ckxEZlFwZHVOeUo4ME1ldDh2a1dlci9iUitvTk5YTmlhMmNuRkVtZG02dytH?=
 =?utf-8?B?UEQxdjd4Wng4RmcvSHJUdUkzNFpCc0RLN0tuRnhyVzJVUlFWNE1IcnBBWUJT?=
 =?utf-8?B?MGplcTAvQ1RHcVBnM2Zuc0pmcnkyNW9EeFp6VTV6NGY0anYvaUxhcnJqbmN5?=
 =?utf-8?B?ejJLV1BKVDE5K3JPVDV3OHVtaHlZUk9uSFVuWExlMTk0WjZ5RW1zSUl1Q29P?=
 =?utf-8?B?by84czg5SUc5SDJpSW5JbEc5MXJpVm5FTlFGOTFTOWplRVVEaFpabHZQeStK?=
 =?utf-8?B?VHpZT20vQmR3TnNiZVJVMVQ1cjJ2UEJVOHB4d0xUN3RTR1NKMmVySHVkYTVH?=
 =?utf-8?B?VENZK2dLcmE1RFFoY0N2RmRORkZsTFRoV1F0UWcxMUpJVitDSC9zendxMitC?=
 =?utf-8?B?b3VKeEZHRkpCcTV4aDhxTkdjcVQ2WDVqamN6YkVIVDdpRE1rUmRrVEtFdVkr?=
 =?utf-8?B?dW9yQ0IzQWl5ZjhOaEJsM1B3dlYraHpYQ2lHRXcrR1lrQ1pLS2sxWU15a0c1?=
 =?utf-8?Q?f5jgLxUxWTT/cLEdREp9BJL3Ef13W0kWoYUfbc3?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd63441e-e122-4404-5648-08d92d23916f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2021 21:55:03.8426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lLteE3HGr4lwIXIddfbFIY5lji9lkXOowI6H1LmOyqul/piMua2z3CQIqUrkgPS8nAOZye+h5UcsQFW5Fvvok3byupNArDjuR+On/AbKE/s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3955
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10012 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 adultscore=0 malwarescore=0 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106110136
X-Proofpoint-GUID: RQdd4DI68sTzKz1Sa9BXerVdTVLb-DPO
X-Proofpoint-ORIG-GUID: RQdd4DI68sTzKz1Sa9BXerVdTVLb-DPO
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 6/8/21 10:19 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Move the "exit $status" clause of the _cleanup function into the
> argument to the "trap" command so that we can standardize the
> registration of the atexit cleanup code in the next few patches.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Ok, looks ok
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>   tests/generic/068 |    3 +--
>   tests/xfs/004     |    3 +--
>   2 files changed, 2 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/tests/generic/068 b/tests/generic/068
> index 932a8560..573fbd45 100755
> --- a/tests/generic/068
> +++ b/tests/generic/068
> @@ -22,10 +22,9 @@ _cleanup()
>       cd /
>   
>       trap 0 1 2 3 15
> -    exit $status
>   }
>   
> -trap "_cleanup" 0 1 2 3 15
> +trap "_cleanup; exit \$status" 0 1 2 3 15
>   
>   # get standard environment, filters and checks
>   . ./common/rc
> diff --git a/tests/xfs/004 b/tests/xfs/004
> index d3fb9c95..4d92a08e 100755
> --- a/tests/xfs/004
> +++ b/tests/xfs/004
> @@ -18,9 +18,8 @@ _cleanup()
>   {
>   	_scratch_unmount
>   	rm -f $tmp.*
> -	exit $status
>   }
> -trap "_cleanup" 0 1 2 3 15
> +trap "_cleanup; exit \$status" 0 1 2 3 15
>   
>   _populate_scratch()
>   {
> 
