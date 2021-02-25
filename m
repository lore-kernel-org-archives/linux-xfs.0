Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CBCEC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 06:19:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1599464EC4
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 06:19:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhBYGS5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 01:18:57 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41392 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232181AbhBYGSz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 01:18:55 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11P6FKlv119747;
        Thu, 25 Feb 2021 06:18:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=RTB9slqaTlTTShT6Nmwo+BNW2HdvZsgncpkSCLRDnpc=;
 b=IGbMuZ67EARwN+J6kPeaxLFRguJIVYc0mAuIZKtiPx+OlHvxLci79Ak9r/lYMozsRMF1
 AGGsmDJuO38PE/se0K0szsj6O0Mg/D9xX5Gw3NpEPm5Ww7Pd6hbpqHnYNsF3BnU1I8OP
 1XDo6jr3IFPYce6N29bCuA2aUTWu+bLYK/tiAfdR5kzO1RJPCJv51WSHeICCJ1apaQxB
 +W6LzioqPo8SnqtMfRhmBmTlgLM3k+zMZVpqNEZsyEU7bwc5ymdFxpe4PJux6RKOBMO0
 CfiwHmPx+B720zXIlIMgmgUOaYmtSV18KBjivP+zqIWcN7A1USEKwZG74Psgl5farIPH vA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 36tsur5bua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Feb 2021 06:18:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11P6AEJO173507;
        Thu, 25 Feb 2021 06:18:10 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by userp3020.oracle.com with ESMTP id 36uc6u2egg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Feb 2021 06:18:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=id+2Xua5CadOGLypyQBrsUfgS6TU45T16XWAGhk+GVscXWN8HQ8aC1riZY1YcO2LrArf45NzBL+2uOgGIx5G+Y5zWL8nGAsWKqNgYYBg2P0uIe5lL+Ja2/X1XtXQUl8ke1b6/G2s7qbq2TXeurKyqQkMh14h2tEWIw/DnRkCLOTwCOyVLTbvhT3uq8am7LqPRKpsB6qj4fvvdED60i8yAoTDFdfalOEBI8U0SPTyyTIPRLSn/mFAdmB8LspmDCie6q5WCUhhzYyomXcD69qgYv1W+SL5jxHCRrei8YtinXGIkkd0eukm4DIWH2hJXNy9NuHD6d1h7nA1MSJbFJAt1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RTB9slqaTlTTShT6Nmwo+BNW2HdvZsgncpkSCLRDnpc=;
 b=jkzGaWsJ3ZATXgZ7dGcwAyVi3a4dK31O/nDwlsLYuC+2SUoI77gjR7aIFT6y3jSSYPtt8yRHw4BPSJ4bmTZScbJiUAOKzy49LlbucWRiuj69Ts1/dQvrflnm5IKnDDURaeKZLSPw4q+gYrEGqoBVQWepaGSfnLZCZ0zL5MIcKKd0NgvMDb0rfYe/FPA3p7k23w7aGn2YrZUL511sZ9U3Ry+h3S5rwXW+bzeafY0w4cHfHR9wV/kCf5pCQuQiZYg2C19wDcckgc3SJV1BzYGMi7j2+lEgwEHI4ZA9ojcMQ870wcLmuIHwskRJ8u/1GtShfWpik6bV/7vzoHEN+mad/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RTB9slqaTlTTShT6Nmwo+BNW2HdvZsgncpkSCLRDnpc=;
 b=lAxR1UFyFUEUmNe6/OBS8zzDCVh5Kuy/rPhLwlTBT9FsmTgcgJzFp148h3ZILzHQJ1ZJfD0KKXhwr1MH8rCow0d0qGKAjHmozq/NUTXjJP6m4Hcjd4+8EOaseZWnHxmCwJiNZn7f+K4/8rqRiWbmw1hvpjWKv4QQMj/c521kygQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3780.namprd10.prod.outlook.com (2603:10b6:a03:1ff::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.33; Thu, 25 Feb
 2021 06:18:08 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3890.019; Thu, 25 Feb 2021
 06:18:08 +0000
Subject: Re: [PATCH v15 04/22] xfs: Hoist xfs_attr_set_shortform
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-5-allison.henderson@oracle.com>
 <20210224150411.GE981777@bfoster>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <28d7be6b-ed17-f229-b160-b1650c071dd1@oracle.com>
Date:   Wed, 24 Feb 2021 23:18:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <20210224150411.GE981777@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BY5PR16CA0015.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::28) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by BY5PR16CA0015.namprd16.prod.outlook.com (2603:10b6:a03:1a0::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Thu, 25 Feb 2021 06:18:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f8d2558-ff01-4ed0-fe6e-08d8d9551eb0
X-MS-TrafficTypeDiagnostic: BY5PR10MB3780:
X-Microsoft-Antispam-PRVS: <BY5PR10MB37801D82D5F656B7C70C00AD959E9@BY5PR10MB3780.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1247;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SyevdNDHSvzb+0mYsJywMTGSac9ahZKoGeQMsLHl5YmeoIL9ZuIbkHIZMMCoJW44OijsaRcD5RyHaaKnvI7QCf+qFjbtH4vKPHHtO8GsRk9a1JKeAPHTSxPO5QxrUK4T5U/Hgot6wdowCOQdn3KY14RFwVAjaL7DFzFMk4sXikYGZJVTUL8B72ged2qzUlmxqkFyXKktE3Esw5gHfdEaJn+9aAC9z0tORG7jsGnQyfEh0zLGk1u17xYVC2GVmpkAihfSbGbznnKqr3N7Qq4mSu45ODk6VZRNI81hEBB9ldes1LMzcgA7fDXqKN9j9TTHX59MgxzyM4Pce50s4NEz5sc3DDMq70tMJvkOV4uQA3w1U8DnZSZ013dJd12foJxOqTLk4tZHzAyYtIDT0DRU6NiRYzVeUdepS9vK1xS/6t9MZYLf9t3WxSoIBIOiEctFgwXe0H2VwgJrfScSHpbiJd96YvZOyI3noqeU+rWx/yvZ6w6856NGWv5GiCVyNYnVvqHS1tv/9dDTRRez7H6l+g1cK5hqZHxEg3hWNL2cDVFVcHYb4+8UvfZ+wLJjTpIehymUb3Xr46uIOLK6jdL9nqPcm1UAA8GYft3Vie6FY5w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(346002)(396003)(39860400002)(136003)(6916009)(66476007)(8936002)(4326008)(478600001)(316002)(956004)(83380400001)(31686004)(16576012)(36756003)(8676002)(86362001)(26005)(2906002)(2616005)(31696002)(66556008)(186003)(52116002)(6486002)(5660300002)(53546011)(44832011)(66946007)(16526019)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OFM5N0pMMy8rOVAwZGRLQmlIWjNGUmVxSTBtRG1ZR29TMTBNRW9YZ0ZFbjZu?=
 =?utf-8?B?WmJyOXlZVitkREN5cCthTmpEK1Fub3UyaE9sQWZ4OGF5OVhLVnlDSGlzNE1L?=
 =?utf-8?B?Rm16ZjJOMzJzMjhKUzZNZFMxcC90QzBmVHcrNGN1SEhoUzNWdzBVdDVFRStP?=
 =?utf-8?B?TUhOQm92a21YOER0YUhJMWliWWhtdGN5MFYxbG0xN1pxS0NPMUM0RWwrRTVn?=
 =?utf-8?B?U0R0YjJkTmNrNVJlQUx6cm1yRUd0Wnc1eUJvbjU4a0x0NFlQL3pTaUVVVTlX?=
 =?utf-8?B?TUZPaFk5TnNwWnd0am9WVThKVFVIL1hOVzkwTE85bHBCN2ZuMzlFZFV3NTVH?=
 =?utf-8?B?bVQ1cU91cTd0NlhuSFFGOGYvN2JzaENKb2FaL24yVUh5ZEIzOFNrVEZLT09J?=
 =?utf-8?B?Qm9TMlNRYnpyVE9aWldiM2laUXdIMW5sSmxzYVpkeWdSUXI3MlFOMWVsVkZx?=
 =?utf-8?B?eHpjelBJZGh0dXorL0FzN1AvMEZJM2U3U1JDQnhrb2hQRXNZbFZmaDZJc2kx?=
 =?utf-8?B?OTlJMTZucXVDcnNaRzh4RktNbU1jdldseVA1OHhJMVNSa3ord1d1V1lTZE0w?=
 =?utf-8?B?ZWhXOVIxNWlDUXpUelhBeHYwWVBxMHlocU02aVJJdFZGME9WaVMvZVdBTVlI?=
 =?utf-8?B?bDZJSW9mMGZ6Z1dCSzl5UUNzcWRVVmIyUHhyQWx5NmNuOWtEQnk4OHpoSkN6?=
 =?utf-8?B?aFE1QVhMZ0ZWUWxNTldONlVjdHhGOHdEYnRUN3VWYXQ1K0xOdnllVmpMZzIx?=
 =?utf-8?B?Wk9TWVRjMjBxT2RyY1JsK0VXQWQrMS9HVDZDWjhZZHlQbTlUSGk1ai9paEhw?=
 =?utf-8?B?QXhUd0Y1bEcvcVVkU0M1SmJDQkJiSSt3K29YVlJLcUxCYnE3MVk5NWJCcGRq?=
 =?utf-8?B?ZVJHQmZiRS8wR0pGLzhMQnllUmFuUWs0WUhQaWxGdHIzTy9wODVhQm04TVFj?=
 =?utf-8?B?bFBLOHFDaUZoZW9OMHZsUlJwWnhsa0I5ZUgwQUtMeFZ0anF6YlAydTVSUmI5?=
 =?utf-8?B?b1RudzdOSTU3elJTdkRMUXROcHdyQzB3QWdJd042RmVDTUlkYTRKWUhFTzNH?=
 =?utf-8?B?dTdRZEZVQnZwR0x3RFc5TmtBQ3VDdWhxOVgrMEwxSDBFT3dZYUNJNnRmakpn?=
 =?utf-8?B?eWcvSTdTNUY3MnJhb0ZBamF5RlRsN01lTUFHVGVzeFRrTnZKTkNiMzc3ZHJw?=
 =?utf-8?B?N2kzRW51bzBFZG4wVThMa0xjTDhtMmFnZ3JvajJ1N04rdWpqSjJUZGh3bkZO?=
 =?utf-8?B?UTRGNUkvMmJKRDdnR1VZS0xxaGltSGtxVVcwOVRjbXY1cGdoSzYvV1VxU3dU?=
 =?utf-8?B?SGw0UWNCaEtrTkxHcHZVK0VFUmZoRjBiZlczc1drM2lNT3VReDBrNFBIaXBF?=
 =?utf-8?B?b3M3M3E4UmpJVlduT1I5am5YbmhuODR4d3JxeEZoc1IvSGVpQWlCaXNWQk9l?=
 =?utf-8?B?ano4ZHdOZW5pRm1GaGo3Mkl6Q0VKNHZ1K0N1SE5oZkk1RXU5WUlIekJJZkhs?=
 =?utf-8?B?Q2RUTEtwWlpjTXlNTlp2VGlMZ0ovOG9saExjRXc0T3pTYzB6TVV6THgydlBT?=
 =?utf-8?B?ZTd3VnlEQnN0eWZsRG1ac0FtUTNTbnlBeGJqbTB0QUFrdGU2SFRHOXdTT0tU?=
 =?utf-8?B?YW9KR1JJR05xU3VpZGN3VEJ5VzF0QjBDU3ZNUkdkUW1RL3VNTkRTcnFyV25B?=
 =?utf-8?B?R21OWmFhYXBpNHZXN3A3TWJubmlSSEFMNDBtSENnb2ZzZ1BaTTRPd21JWk0z?=
 =?utf-8?Q?PcK78vlTeZdCrHaP4NYvSO0tBpE/5Mzl0CtxK5H?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f8d2558-ff01-4ed0-fe6e-08d8d9551eb0
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2021 06:18:08.4592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RXNdShr8RrKukioQmCARsJp3+jdbU0KbGw4Tjxc6zOFfVxW24RekPUFVwtExkoyED/ZWlsrI/LZI4phXcwUqx58jPTGqDMKNWZZiiVYWv04=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3780
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9905 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102250054
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9905 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102250054
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/24/21 8:04 AM, Brian Foster wrote:
> On Thu, Feb 18, 2021 at 09:53:30AM -0700, Allison Henderson wrote:
>> This patch hoists xfs_attr_set_shortform into the calling function. This
>> will help keep all state management code in the same scope.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
> 
> LGTM:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
Thanks!
Allison
> 
>>   fs/xfs/libxfs/xfs_attr.c | 81 ++++++++++++++++--------------------------------
>>   1 file changed, 27 insertions(+), 54 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 3cf76e2..a064c5b 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -217,53 +217,6 @@ xfs_attr_is_shortform(
>>   }
>>   
>>   /*
>> - * Attempts to set an attr in shortform, or converts short form to leaf form if
>> - * there is not enough room.  If the attr is set, the transaction is committed
>> - * and set to NULL.
>> - */
>> -STATIC int
>> -xfs_attr_set_shortform(
>> -	struct xfs_da_args	*args,
>> -	struct xfs_buf		**leaf_bp)
>> -{
>> -	struct xfs_inode	*dp = args->dp;
>> -	int			error, error2 = 0;
>> -
>> -	/*
>> -	 * Try to add the attr to the attribute list in the inode.
>> -	 */
>> -	error = xfs_attr_try_sf_addname(dp, args);
>> -	if (error != -ENOSPC) {
>> -		error2 = xfs_trans_commit(args->trans);
>> -		args->trans = NULL;
>> -		return error ? error : error2;
>> -	}
>> -	/*
>> -	 * It won't fit in the shortform, transform to a leaf block.  GROT:
>> -	 * another possible req'mt for a double-split btree op.
>> -	 */
>> -	error = xfs_attr_shortform_to_leaf(args, leaf_bp);
>> -	if (error)
>> -		return error;
>> -
>> -	/*
>> -	 * Prevent the leaf buffer from being unlocked so that a concurrent AIL
>> -	 * push cannot grab the half-baked leaf buffer and run into problems
>> -	 * with the write verifier. Once we're done rolling the transaction we
>> -	 * can release the hold and add the attr to the leaf.
>> -	 */
>> -	xfs_trans_bhold(args->trans, *leaf_bp);
>> -	error = xfs_defer_finish(&args->trans);
>> -	xfs_trans_bhold_release(args->trans, *leaf_bp);
>> -	if (error) {
>> -		xfs_trans_brelse(args->trans, *leaf_bp);
>> -		return error;
>> -	}
>> -
>> -	return 0;
>> -}
>> -
>> -/*
>>    * Set the attribute specified in @args.
>>    */
>>   int
>> @@ -272,7 +225,7 @@ xfs_attr_set_args(
>>   {
>>   	struct xfs_inode	*dp = args->dp;
>>   	struct xfs_buf          *leaf_bp = NULL;
>> -	int			error = 0;
>> +	int			error2, error = 0;
>>   
>>   	/*
>>   	 * If the attribute list is already in leaf format, jump straight to
>> @@ -281,16 +234,36 @@ xfs_attr_set_args(
>>   	 * again.
>>   	 */
>>   	if (xfs_attr_is_shortform(dp)) {
>> +		/*
>> +		 * Try to add the attr to the attribute list in the inode.
>> +		 */
>> +		error = xfs_attr_try_sf_addname(dp, args);
>> +		if (error != -ENOSPC) {
>> +			error2 = xfs_trans_commit(args->trans);
>> +			args->trans = NULL;
>> +			return error ? error : error2;
>> +		}
>> +
>> +		/*
>> +		 * It won't fit in the shortform, transform to a leaf block.
>> +		 * GROT: another possible req'mt for a double-split btree op.
>> +		 */
>> +		error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
>> +		if (error)
>> +			return error;
>>   
>>   		/*
>> -		 * If the attr was successfully set in shortform, the
>> -		 * transaction is committed and set to NULL.  Otherwise, is it
>> -		 * converted from shortform to leaf, and the transaction is
>> -		 * retained.
>> +		 * Prevent the leaf buffer from being unlocked so that a
>> +		 * concurrent AIL push cannot grab the half-baked leaf buffer
>> +		 * and run into problems with the write verifier.
>>   		 */
>> -		error = xfs_attr_set_shortform(args, &leaf_bp);
>> -		if (error || !args->trans)
>> +		xfs_trans_bhold(args->trans, leaf_bp);
>> +		error = xfs_defer_finish(&args->trans);
>> +		xfs_trans_bhold_release(args->trans, leaf_bp);
>> +		if (error) {
>> +			xfs_trans_brelse(args->trans, leaf_bp);
>>   			return error;
>> +		}
>>   	}
>>   
>>   	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>> -- 
>> 2.7.4
>>
> 
