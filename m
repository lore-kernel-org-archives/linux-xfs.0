Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B59FC433ED
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 09:47:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DC5B61105
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 09:47:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233718AbhDBJr0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Apr 2021 05:47:26 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59630 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbhDBJrZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Apr 2021 05:47:25 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1329Sq8B176781;
        Fri, 2 Apr 2021 09:47:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ly1sS9yafnTCrMpdDinikEsjG2M8iuwAmN690qnvbrM=;
 b=DlDsKzAzsYZW9rAIeVNScyflQgsQdZbZUOMaEmj6BaaQE5tvIWL9SluepgFohp4uhkFJ
 ZErioWWyZK/o0B4V52b/EObDDf9o+sTbWNNM8iQy/EUeSSFZedVbQpVzmkWb/tEwxSoU
 jbCwDPuhtGZtGeQZrIIN3YkrA2mN1wQEvMXUGW7GE2o3foRK89kebjmci+iybqiRajss
 SQrbh8VijQDd155UWoo2rQ23VwUsNv3hrSEMvx2M+PsFuDBRQrYlDfvbZ4YDBd0E6vqb
 xpqVdG2eVqh74LJjsZB5nkejGKuHECs5S8Sl7+Rj1RS81z2Kd83bA/afnay3Obi9ikhL 0A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 37n2a04a4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 09:47:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1329j2f9066611;
        Fri, 2 Apr 2021 09:47:22 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by aserp3020.oracle.com with ESMTP id 37n2acae34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 09:47:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f0ZBH0lba1bJl6Ksm753cx5CIrGGB7wdLRL3xDK4p1w3jrBKLlcdH3y95VIgIdgPDAwodFDPMoJjAGjwlreLOlpTV4mXoOwLC85fhlPDc9idHnWJqYIhN683XA+8unBQ+tmhbX7/pwJaU2umRGpcr38UsGTheaRs+ED7cG16XP8bTePVrz+pRajm1bHX/g8IGehcDXexbH7zUFtO9gFpOqAeoo6rZb5P2X7E6n62cN8y/tGMSjJk7RQK/tHh5cjanejOqafFIR7Yv5GTL34/w5dJfR98rI8wG3CXCHkVOOvSJdZ2Y+tJlMXCWRbHrK0kFLINYW1aNQ4ikAXA0Moaig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ly1sS9yafnTCrMpdDinikEsjG2M8iuwAmN690qnvbrM=;
 b=MUqogi4V18iQ55fhMtMsJX7jT9NJLiBRG7ijPqNPDfaCyZeN68TAIj/fkOxcj4JtC6+sfN+puvztI4mAaACz1BOUlIYoda2c6wlToEnYVwSNvSrcfpfkjJHf3uwX4k2cwOVRdoCuDgwpJDsUeC0bUMmhWVovX5RPjlJaeo2iK1dq5nykRWL2JN3wAK3ACeybZYNRFH+rLDNwz6RCSjvVfshMNtw3dKPQTDaDn/Kbhtg7lgwntwP1KxLiuK9w2BNoH6loj6jaf+lz/61XkK/csMMUhN9dHl88dKlKewr1+XLrK/xRFZleC0InndBfFxe4Q8XYsQFhYM8ru/vwy0sIjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ly1sS9yafnTCrMpdDinikEsjG2M8iuwAmN690qnvbrM=;
 b=oST/FIEjLQXSx76bkCRCXsqmbV2bDib8vWGN9fS7/qWCjgEHHs6OBfDtwjMrUOFLlHlg6tRgF7/aCPQoBXsV4W3B5DsRIFO9mZxAXhUf+NHDIMF+ZHNvKYWYNkd0g25Ctl/x1zHpei/NKBlJkvYSLweR5u6UNyypnDwTmtY9mh4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4813.namprd10.prod.outlook.com (2603:10b6:a03:2d2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Fri, 2 Apr
 2021 09:47:20 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.3999.032; Fri, 2 Apr 2021
 09:47:20 +0000
Subject: Re: [PATCH v16 04/11] xfs: Add helper xfs_attr_set_fmt
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210326003308.32753-1-allison.henderson@oracle.com>
 <20210326003308.32753-5-allison.henderson@oracle.com> <87h7kub8rv.fsf@garuda>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <f4877258-2320-02c5-b117-c65e764e0ee7@oracle.com>
Date:   Fri, 2 Apr 2021 02:47:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <87h7kub8rv.fsf@garuda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: PH0PR07CA0039.namprd07.prod.outlook.com
 (2603:10b6:510:e::14) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by PH0PR07CA0039.namprd07.prod.outlook.com (2603:10b6:510:e::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Fri, 2 Apr 2021 09:47:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e77cf59-ac86-4918-a223-08d8f5bc4f0e
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4813:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4813BB26C063475EBA94352E957A9@SJ0PR10MB4813.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:332;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9V6fiUDuNBGCQUS6YoX4ml2D5Q3zxxVO5otveJXiJmTWNegyjy41TLlRuu3qcRId4gJvWAiSA/e5/XtvT2neANk0kHLPMrKjX9wA7Nqix8/cIgMGyFbiUo0HZ3Pm/NC4rj7rSNFQOWmktmHfmqeAbagiiXzWGc4EoyIv8IYrwPhSVqH3zS8HnV+wBCoE5ZqVR4uXe1lLO7eNdC1A5ftGdwQRWziVARdjgCpat8/GVLLLKqlpFSIxNzOuTdF9as/EgGQ4KWdBn4aZDiQS94B5kxStpKqd3UvKd9vN9U83MXkgC4p+fiCQHtD3DZKd6oPoC2ntV2OZbH9DCmo4hPMZULfHCuLsdkybnsWMOlfuz1VX4nhc5eGXOGNTg3WruMegARWcvm5dtcFjxG+/FXLdAHgfY+8OWF+Y4cVkCZka+pi7NJk/K6b3iE/bTQs8oEKXMDdlXoY13K/Lf4SXgPlUHGHkCaSmAfQLuMHn72xouNdSG5qsZGJXKJvSlJ8fUmGzKMfQwAzWtqts/E1LA837OsC0TomDBL+Tv52GyEgVPGqns2Q66xUDGKFIGor5r13q6FPlM2LQnGmi4wPLIpBlbkrssHopByFKB7v8DLFYKezFEdRDOiFkh2floBdcRomgj7tNIabaADcKLsrfCn79CTPOSJWh9BlB+BldPvu5HK/KUA+pzsTlQgpSCsm0CYeMjrNvPCKXHY3xtg+3KR5Tzg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39860400002)(376002)(366004)(346002)(38100700001)(86362001)(956004)(2616005)(16526019)(8936002)(26005)(2906002)(31686004)(186003)(8676002)(31696002)(36756003)(83380400001)(44832011)(53546011)(316002)(6916009)(478600001)(16576012)(5660300002)(4326008)(66476007)(66556008)(66946007)(52116002)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?USt0MXRucERicEk2OTZ4WFVueGxjblRHdnRBVEpUejhDNVp4QytQYWpmMXJK?=
 =?utf-8?B?QUMwamxlTng0bjFaVkM2K1F4QU14WEsvdlBUU0lnRXgvUnNnNTBYbzV1dHJy?=
 =?utf-8?B?WlYwdXJjZlZXemF5S1c3aXhCdW5RbE5lV1B6dUcxOWpVRE5NNlNmZnlxdlVx?=
 =?utf-8?B?N1M2d09Xc3pIQnd4NmxRSmNQME91Q242VEEyUGFaTWJ1eU15bk9GSjMvdGVF?=
 =?utf-8?B?Y2JualJtZW1WVjRYajRpRDFmUmRTbGVzWGlyaVNRYmd2eitjSDFLRWYvMkRj?=
 =?utf-8?B?OFUzeEpBY0dsN2VFNE1Melp4cFpqaWhyOWs1Y3dKVHczdzdnSWsyb3N1UGVI?=
 =?utf-8?B?c1gzaG93MCs2VmREeS93MkxnSU1iL3djcGxUUkJUWm5GOTBab2FranpvRG9m?=
 =?utf-8?B?UjI0ZnhMVFRTYU52M1M5SXJlNi81NUdCMVgvVzY0bzdEQ2YxM1JRd0Q2aGty?=
 =?utf-8?B?MVBKM2hZWTlGeW9nRFZydlh6TVF3VkpYUEt2N1QyRWNiWDBUUUJvbVlMbXBV?=
 =?utf-8?B?WUQzMTRvVVRpYkIxZEt2VU1nNWNEUEZNMTZ1T2QzUFJ4Y1N5OXlXTDA4REJT?=
 =?utf-8?B?b1Y4SVNia25nbXpSajZrZkIrSkRHejA3NFhhbGtqajlUR0tpamUyTnZDNWF2?=
 =?utf-8?B?Y215ZWdtdk9tTEsyciszOVhNL3pqbmpsb3BCR1FMTDFXRklXb1Iya29QaTVi?=
 =?utf-8?B?eC9BTFZ4aURPWitYL2ZaWHpLSDV0MlY1MjlZYXRHbmp2bVBkZEtYNTNlb1JD?=
 =?utf-8?B?RFJKbXNBVDh6RTFXbnlRMENWMTg1SkFUZ0ZGRlJVQXYvMkNwVEE4ZnBmY1Rv?=
 =?utf-8?B?MDNaTWdIeEM0M09nOVF5SWRyVlBOWTJnU1E0Ykcxa3V3Qjd3MEd5d294Lys5?=
 =?utf-8?B?Y3QxRk1PUTk3QWtodUdMK3Y2MzdSSUZWV1VNYmdScjVkUlFnZTVQV0tzdkdI?=
 =?utf-8?B?MERFZFhpcFJUbmxuZmx2U2JhQ2hGSWw1bDlKamJieCtVQ3psSWVyWkRndVVt?=
 =?utf-8?B?YjY0TW8rVXlTSzhhck0wSFR1YlEvYmM4OEhra21wNjhLc0hmT0gyVGltaENQ?=
 =?utf-8?B?NHlDTXp5bWlBVnhHWEx2amdoNXNWeDEzNmplMjh3eUR6RWpVK3B1cjB4dzZ0?=
 =?utf-8?B?VHUwUDZUWk9HdGQ5SEZKZE9LUzNpVWJ2TXdFZ3V4cDNMRXp1V01xVEVJYzZo?=
 =?utf-8?B?c3AwVC9NWXBYWDV4VW1uQktPYjNHelc1TldXLzloTjU1UGFkVDNlcVJZOUQy?=
 =?utf-8?B?TDAybVZyRnRlZkpOUTZEdmNtTVo3RlFsdVRtb0Z3ZTIyb2tkWHNWY3UzWFB1?=
 =?utf-8?B?SjR2cHp4SVV5MTlVbzRvK0FMNnlIWXkxaHBER2hDQWQzT0s4WngwbnVBek5h?=
 =?utf-8?B?TDg3RnBmaEkwYTVCN3p2bTFObS9tTVNMMkhwTkNCZ3Bwc25jS2tQNGVmK1Yv?=
 =?utf-8?B?TmRVbWZyYkQ0SE9GYjJEUkdlT2xhb2hUbCtCWXQ1bjFxR2MrNVlpUHUydTNM?=
 =?utf-8?B?MTNJQisvUWRVcEpCamJEL3FzQzJ2cjZlQW5nSmY0eUdVL0tPVlV3L3VkRHlF?=
 =?utf-8?B?NTA1NC9hSjVrbmVZakd4dVM4OStOS01NTE5CeVB3ZG1rdUtFcXBUWW9YLzAz?=
 =?utf-8?B?ZWlOSVhjV084Qlg0cUNyREZ6UDNsbjFZRkNuUzlubHl2OUV3Qm5qaEg4Mnc0?=
 =?utf-8?B?WklaNzVic0gyN041aXQzaGZvZDZqajJzRG8ya3BMSU5IdDBwdzdEMzRYblhW?=
 =?utf-8?Q?rC4iloKWBDs0OwMIpvpoaUSYfYr3roc7+Ja0V9L?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e77cf59-ac86-4918-a223-08d8f5bc4f0e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2021 09:47:20.3573
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J9NaWGcs0cIGz36tO1IaYGCPNXjFLaTa1izP9mvZgl3FBem6dKZY2qIAjwDtxweldUlBlsIZJoeAFpxpdx6TsJMyyvWiUJ17WyCzx0SUMmw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4813
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020068
X-Proofpoint-GUID: 9mfR4b7uJy1ErNjqqPJWmwDRoPSuqUO3
X-Proofpoint-ORIG-GUID: 9mfR4b7uJy1ErNjqqPJWmwDRoPSuqUO3
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 adultscore=0
 clxscore=1015 mlxlogscore=999 phishscore=0 bulkscore=0 priorityscore=1501
 spamscore=0 malwarescore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020067
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 3/29/21 2:37 AM, Chandan Babu R wrote:
> On 26 Mar 2021 at 06:03, Allison Henderson wrote:
>> This patch adds a helper function xfs_attr_set_fmt.  This will help
>> isolate the code that will require state management from the portions
>> that do not.  xfs_attr_set_fmt returns 0 when the attr has been set and
>> no further action is needed.  It returns -EAGAIN when shortform has been
>> transformed to leaf, and the calling function should proceed the set the
>> attr in leaf form.
> 
> The previous behaviour is maintained across the changes made by this patch.
> 
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Great, thanks for the review!
Allison

> 
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> Reviewed-by: Brian Foster <bfoster@redhat.com>
>>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 79 ++++++++++++++++++++++++++++--------------------
>>   1 file changed, 46 insertions(+), 33 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 5216f67..d46324a 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -216,6 +216,48 @@ xfs_attr_is_shortform(
>>   		ip->i_afp->if_nextents == 0);
>>   }
>>   
>> +STATIC int
>> +xfs_attr_set_fmt(
>> +	struct xfs_da_args	*args)
>> +{
>> +	struct xfs_buf          *leaf_bp = NULL;
>> +	struct xfs_inode	*dp = args->dp;
>> +	int			error2, error = 0;
>> +
>> +	/*
>> +	 * Try to add the attr to the attribute list in the inode.
>> +	 */
>> +	error = xfs_attr_try_sf_addname(dp, args);
>> +	if (error != -ENOSPC) {
>> +		error2 = xfs_trans_commit(args->trans);
>> +		args->trans = NULL;
>> +		return error ? error : error2;
>> +	}
>> +
>> +	/*
>> +	 * It won't fit in the shortform, transform to a leaf block.
>> +	 * GROT: another possible req'mt for a double-split btree op.
>> +	 */
>> +	error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
>> +	if (error)
>> +		return error;
>> +
>> +	/*
>> +	 * Prevent the leaf buffer from being unlocked so that a
>> +	 * concurrent AIL push cannot grab the half-baked leaf buffer
>> +	 * and run into problems with the write verifier.
>> +	 */
>> +	xfs_trans_bhold(args->trans, leaf_bp);
>> +	error = xfs_defer_finish(&args->trans);
>> +	xfs_trans_bhold_release(args->trans, leaf_bp);
>> +	if (error) {
>> +		xfs_trans_brelse(args->trans, leaf_bp);
>> +		return error;
>> +	}
>> +
>> +	return -EAGAIN;
>> +}
>> +
>>   /*
>>    * Set the attribute specified in @args.
>>    */
>> @@ -224,8 +266,7 @@ xfs_attr_set_args(
>>   	struct xfs_da_args	*args)
>>   {
>>   	struct xfs_inode	*dp = args->dp;
>> -	struct xfs_buf          *leaf_bp = NULL;
>> -	int			error2, error = 0;
>> +	int			error;
>>   
>>   	/*
>>   	 * If the attribute list is already in leaf format, jump straight to
>> @@ -234,36 +275,9 @@ xfs_attr_set_args(
>>   	 * again.
>>   	 */
>>   	if (xfs_attr_is_shortform(dp)) {
>> -		/*
>> -		 * Try to add the attr to the attribute list in the inode.
>> -		 */
>> -		error = xfs_attr_try_sf_addname(dp, args);
>> -		if (error != -ENOSPC) {
>> -			error2 = xfs_trans_commit(args->trans);
>> -			args->trans = NULL;
>> -			return error ? error : error2;
>> -		}
>> -
>> -		/*
>> -		 * It won't fit in the shortform, transform to a leaf block.
>> -		 * GROT: another possible req'mt for a double-split btree op.
>> -		 */
>> -		error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
>> -		if (error)
>> -			return error;
>> -
>> -		/*
>> -		 * Prevent the leaf buffer from being unlocked so that a
>> -		 * concurrent AIL push cannot grab the half-baked leaf buffer
>> -		 * and run into problems with the write verifier.
>> -		 */
>> -		xfs_trans_bhold(args->trans, leaf_bp);
>> -		error = xfs_defer_finish(&args->trans);
>> -		xfs_trans_bhold_release(args->trans, leaf_bp);
>> -		if (error) {
>> -			xfs_trans_brelse(args->trans, leaf_bp);
>> +		error = xfs_attr_set_fmt(args);
>> +		if (error != -EAGAIN)
>>   			return error;
>> -		}
>>   	}
>>   
>>   	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>> @@ -297,8 +311,7 @@ xfs_attr_set_args(
>>   			return error;
>>   	}
>>   
>> -	error = xfs_attr_node_addname(args);
>> -	return error;
>> +	return xfs_attr_node_addname(args);
>>   }
>>   
>>   /*
> 
> 
