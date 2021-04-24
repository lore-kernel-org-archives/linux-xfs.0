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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2B79C433B4
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Apr 2021 03:26:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F3346124B
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Apr 2021 03:26:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233027AbhDXD1X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Apr 2021 23:27:23 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35716 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232619AbhDXD1W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Apr 2021 23:27:22 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13O3QhPR021849;
        Sat, 24 Apr 2021 03:26:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=T8ydAdAiEveAngrdD2CXI1OOTC7VFZnQehwUF+ifDLs=;
 b=UTk+2hsokzy7VbG+SnfDQSpl5MoA1TM9+fGz87qYNMPdvvIzx5T3qEhGRybgcFRfITsr
 pdh1vNOsY/7OJjLx4tzzCCzmsFSLR1lpCes5NNeQXaM0UsGHkD2hZJ9FtA6KGYOeKWUx
 NmPGWC2xcerbW62YANUmhEvnoSEZnEbzs1DU0xI/LPxyzSQsWUOPXF2OvHZsodkXpMLA
 yD/1GHh4rhJWuB86TV1yXYeNvRJi6vBcMcSw6p5XpAdc4VdK1o254K7TcnZtb/xm8Cn5
 ObG+yZuplXGVOlTVYeLd+ALLjRZaK8P03Q8CGRsNnCos8xzmlyCA168Y9dURNBzneNFU WA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 384b9n005f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 03:26:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13O3QJcf082103;
        Sat, 24 Apr 2021 03:26:42 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by userp3030.oracle.com with ESMTP id 3848esc1kt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 03:26:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WaeL7RzPj3xp7FSv042+UNziqIE/91xAUNhoy2vB3A1Kxnx7PZdNvGrzIVVQggfLUHU0Sbb/HWCXQHmZB7JbzSMTB5WiEWSwACg0YWq11fZlwOjBmGJxBm8CtUkGJ5RfMYZjLI8krRPbC4D+5JIZMyz8dHZwo56aiTLbZN15ce3aAbmr63RYhwnaYGniTTwITwQNi2aVI1j9V5iy10Al4hqS4GZaV4X0j3vq2ugVTv52RPqkRJ+G4cXs0dizNVlddTSGPU1DBzPZ6xwOfWUi00dqE436IDFayRhw+63VCU0xE41GcVLQNk3Ff38i1zIlaeV1JaRkATzrB+fj+Jyg2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T8ydAdAiEveAngrdD2CXI1OOTC7VFZnQehwUF+ifDLs=;
 b=KXJXUkA2kFrpsBgFQSJBa2aTTRsvmuJJAQSKhE2eh748ODLOKJyiE67NVwzHxThR+40z3nl9/1ZfmB91g2RGzBmR8vY7/ne0GdqVST+fp5gVQDraIC0bNRYlyzNL+gaOuBe9a2DyjCMIKAR6idF1fKENmxqd2BelJdiGL0V5hOFH6fVOxZ5LiYT/DsHvthFOOJAhy0xyjwhTo/wv+JsUPkWYQqESOtFnaFwsA1yexPMMn0wr0ygiH2Gde25X1mZaPfoNM4GLv9wB3rrrCeggjEEco4qYs7pmH31W0JxrWuHWEq6gi1Ao/X3PrHZYaXybOU4gnTd5mY0X6d1v1gLSVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T8ydAdAiEveAngrdD2CXI1OOTC7VFZnQehwUF+ifDLs=;
 b=EjAFtjykpBjHGDMptcyS8STO3aiS43W31WM199MZedEmcCeNiDP2cOnaOaDnFa8xEbTpXWSXlLZ0mEzUuZrjkmKXafqz6wNAIF+hb0rnKwcjbu8ZewgNbrkKEYvLUgNAAiqC4c2XDRbivGQqiJfQFMKWFW2atBisaftgLHjZVso=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2966.namprd10.prod.outlook.com (2603:10b6:a03:8c::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20; Sat, 24 Apr
 2021 03:26:39 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.024; Sat, 24 Apr 2021
 03:26:39 +0000
Subject: Re: [PATCH v17 08/11] xfs: Hoist xfs_attr_leaf_addname
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210416092045.2215-1-allison.henderson@oracle.com>
 <20210416092045.2215-9-allison.henderson@oracle.com>
 <YIL+hEnaC7PG1tri@bfoster>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <5f31cc3b-cd3b-8b48-a784-ab47965ca522@oracle.com>
Date:   Fri, 23 Apr 2021 20:26:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
In-Reply-To: <YIL+hEnaC7PG1tri@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: SJ0PR13CA0128.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::13) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.222.141) by SJ0PR13CA0128.namprd13.prod.outlook.com (2603:10b6:a03:2c6::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.16 via Frontend Transport; Sat, 24 Apr 2021 03:26:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e8b9bdbb-8248-4553-7a23-08d906d0c5fd
X-MS-TrafficTypeDiagnostic: BYAPR10MB2966:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2966B04667C294BB02D98C0695449@BYAPR10MB2966.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VTQXAGasHYhgO9uxuf4aBTPmomV4MWBGBeyTC9RgrYC8oGZEP9ohZjfNJi+mrJAa3XpFisYuhbcemj0hTL05IvbYcekeR4E6ufNwuAfnC/S1WMtn1+GPaMXzJNUv3cc48dsKza0eMr1BZFQlmuO7eikhaOvv1yf2J4JNYa6XRDKrUPBbuIO2bMJT0Q//6iRMj0dIqkDlw5BOInBaVGs/cAXCfu2bdjFHknglePm7BPm9YyYkpVT7mUcKYmAdGoNdQE8hA9GccFk6zUEcZOpYK92KIpp90qbAmw+WVhvSQ7glmEFctApx9VU451TB7V2eG2kgF1O2Sj1WtCK+ip4gYTtWv00ud1FWT6eU8QrWZnZTEW7i+D5DpW/y+UjU4gWmmi97tef2AfLRJfB/NLlINaum0WQ0SyrRAVgJrrgGCEiu3s33NxqYYATTpgXYAxHiSo/IijPmIb4teWSuGjteGDOj7QI8wQDzzUTRjM8/l+gn5DhXNKhv6+Cyekkiis7VO2BUE6mE6oscFSUPosrY7DS5xpgNRzjOboFJnsjJOQZbdzAwIaE6/1RydpX6nOs7pkcDcv5y/pQSN0czBRVO2a+path/UELZ9lKo3hQ25Oh54z3ubfkBDlySqbQepPedfApgyAReFBG7JR4CrlibjihLB1Hkd40mNFSPtkrLbbXiP5FWQMYWRVGMT8G4dUrWcGbBtF9yJphUZULP3nwx3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(396003)(366004)(38350700002)(38100700002)(31686004)(4326008)(16576012)(316002)(83380400001)(8676002)(6916009)(86362001)(36756003)(478600001)(6486002)(31696002)(2906002)(8936002)(44832011)(52116002)(2616005)(5660300002)(956004)(16526019)(186003)(26005)(66476007)(66556008)(66946007)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WTRoT2V6eERpQ2x6R1dYeDdtTE1RU2JId0V3RWRESzFGcG5heThXZ1ZVKzJ1?=
 =?utf-8?B?M0YydVRSUzBHRXBLZnExYk5MWUp4TkRLWllmb0RtbzhBcHhTQ1Z3VWk2NGdE?=
 =?utf-8?B?MHBjaWVMc2p3TUpaWVFYNXFRVmRwSXJRdGV3NXN0cHZJd2trVktVR2J4VkdV?=
 =?utf-8?B?NFhQSzBibFZpTGlxZWRWcGlWTk44bGU1Yk8zU1l3Q3FsMkNJTWJCT2Jhb083?=
 =?utf-8?B?VG85RDEvR2ZUdVZkT0xVVWtRZElSLzU2cFVKTVJ1dDlEdCtKdkc2eXpPd3FL?=
 =?utf-8?B?aE8xcUFUN3RtaHlXR2k0L1czZzh6OXVVdXlaL0ZqRk5pblRqQUdCNERkcjdN?=
 =?utf-8?B?ZHZJS0VicjVLcXAxZmVmUWNXR29qaXAzSUxGNXIrMEh5eFA3NlVPaXRuZU8r?=
 =?utf-8?B?UzFKMk9NNVZvUFYvZ3diRGN5anRuTmpWVFRQZUUrNWgyakU4STNQOGFaaXp0?=
 =?utf-8?B?L3pTV3RSU2VJaGtMd0VINUlGVTB1aE1zVy9MRjBGZHZVelk4Z2IxemFtNEtY?=
 =?utf-8?B?aTRaQmthRWZIblRGVWhROGpQREVPMmFYMkRyM3hzSDdPTVlYMFV0UE8yaVFx?=
 =?utf-8?B?Z1RuMndIZnM4L2ZLbFU2b042dDNrblpzVFBQZEgyM0RseWtzRWJBTUJaeVVw?=
 =?utf-8?B?NUdyeVl6cnlpQmlOaTZ0eTM5bmo1WU9XWDIwQXZLbU9zVkM3aGUzdUUzSXFC?=
 =?utf-8?B?WnNyZXBEZm05cE9LVGVqWXYzUFh2Q3Q3ekFlV1oxSDZCZ3VPWXppS29QRElB?=
 =?utf-8?B?SGlHYTM0SDVaMHBhREkzVVRCc2FqOHN4SzhqY0NudGZMMGRsaFMyWUtud3I1?=
 =?utf-8?B?dEF2bXJFTE5ZdGxwTjN4Q1JldU1QSkI1d1h5SlBsL2xqTDlsTXRTVUJuNkFs?=
 =?utf-8?B?REFYVVBRQ05YVXpOQk1Vb1lnOWgzTUFYUkZmN1A4SnVPaXJiV2F2akpZanBk?=
 =?utf-8?B?dUxwSG5jNWVoY0EzS1I2UERMN1BkSm5vVHhDTDF3K0ZRYXRGSERjNzd3bTBv?=
 =?utf-8?B?bEkzZ3dVR2greDJHemVBRE1LS0R5aXVHbEI4enhwMXJpTHNIY0xCQlphdW0y?=
 =?utf-8?B?RWozb2JVMUt1R2RwQS9BSElCb1FOK1dUZnh1VFhxQnl6THlZblcxeXVvaWFC?=
 =?utf-8?B?UzVXS0lqOE9ERVh4dS9OeGV0RDYrQVQ2Yzk2Z0kyeDZzY3VJdlVEckFZdlRy?=
 =?utf-8?B?U1BOUHFNYVpuVExMajR4QUxtdXEvOU1KRTBuTkkwL01hN29qOGdOMy91NnBa?=
 =?utf-8?B?SE44ck5xS21tMTNLekgzWkRkbTRSZ1lIaUxKcnZxeFRLeGhFdnJ1ZGtoWDAw?=
 =?utf-8?B?RFZRanc0UTdIL3A0Y1dBUzdhQk56RFdFeGV4VlRCTnRvaFdYTGhzbWFYZkVl?=
 =?utf-8?B?SzAvenJ0TDlTR1NndXh3ZnhEQkQwa0VhVk84WkRqM3EwemZFbGJxNVlQSHhL?=
 =?utf-8?B?MTEzZmhYNEJvNFI5eWhHU0NhMXZiTkdPUFlORFkyaVlYQmh0YXBhNDlUb1V4?=
 =?utf-8?B?SVNvZkcvWTRuRHdYVmpYQ0tsV1RxNld5N2hycFBmOXVkVGlabTVrSjQxV2VD?=
 =?utf-8?B?NnB1amtoeUswZnpMSzI3STAxVGV6NUFXMnAwRDBIU3JrNDAxTWxNanBUUTBp?=
 =?utf-8?B?QTlhaEpWanB4eEVCaDA1d0ZsdG9ZYVVxbFdmZnhvMVZwVldGUFNVeEJZc00y?=
 =?utf-8?B?NzhnSzd4RStNN0t1VUU4SlZxN1N1S3NqVlUyRStnWFpCUXY2L20yN3lpeFc4?=
 =?utf-8?Q?wlc55xiaxoOwnSuko3H6U14sJZOGVlSZiiUR+kc?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8b9bdbb-8248-4553-7a23-08d906d0c5fd
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2021 03:26:39.6095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FDW+xBdiHAjcre/QLwFNc4T+LTWfExZQHrMM72XRAICPAqAu5p0jVCSfhWuVzgroZSWltcfK7XraQrwzFWV0Ei7AxGIXjjRZeqLnJHvNUuU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2966
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9963 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104240021
X-Proofpoint-ORIG-GUID: De_n-Zdlot4BaK9v29Z8-bjj3kjjhLKx
X-Proofpoint-GUID: De_n-Zdlot4BaK9v29Z8-bjj3kjjhLKx
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9963 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=0 spamscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104240021
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/23/21 10:06 AM, Brian Foster wrote:
> On Fri, Apr 16, 2021 at 02:20:42AM -0700, Allison Henderson wrote:
>> This patch hoists xfs_attr_leaf_addname into the calling function.  The
>> goal being to get all the code that will require state management into
>> the same scope. This isn't particularly aesthetic right away, but it is a
>> preliminary step to merging in the state machine code.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 209 ++++++++++++++++++++++-------------------------
>>   fs/xfs/xfs_trace.h       |   1 -
>>   2 files changed, 96 insertions(+), 114 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 80212d2..5740127 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
> ...
>> @@ -287,10 +288,101 @@ xfs_attr_set_args(
>>   	}
>>   
>>   	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> ...
>>   			return error;
>>   
>> +		xfs_attr3_leaf_remove(bp, args);
>> +
>> +		/*
>> +		 * If the result is small enough, shrink it all into the inode.
>> +		 */
>> +		forkoff = xfs_attr_shortform_allfit(bp, dp);
>> +		if (forkoff)
>> +			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>> +			/* bp is gone due to xfs_da_shrink_inode */
>> +
>> +		return error;
>> +node:
> 
> With the understanding that this mid function return thing goes away
> before the end of the series:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
Great, thank you!
Allison

> 
>>   		/*
>>   		 * Promote the attribute list to the Btree format.
>>   		 */
>> @@ -727,115 +819,6 @@ xfs_attr_leaf_try_add(
>>   	return retval;
>>   }
>>   
>> -
>> -/*
>> - * Add a name to the leaf attribute list structure
>> - *
>> - * This leaf block cannot have a "remote" value, we only call this routine
>> - * if bmap_one_block() says there is only one block (ie: no remote blks).
>> - */
>> -STATIC int
>> -xfs_attr_leaf_addname(
>> -	struct xfs_da_args	*args)
>> -{
>> -	int			error, forkoff;
>> -	struct xfs_buf		*bp = NULL;
>> -	struct xfs_inode	*dp = args->dp;
>> -
>> -	trace_xfs_attr_leaf_addname(args);
>> -
>> -	error = xfs_attr_leaf_try_add(args, bp);
>> -	if (error)
>> -		return error;
>> -
>> -	/*
>> -	 * Commit the transaction that added the attr name so that
>> -	 * later routines can manage their own transactions.
>> -	 */
>> -	error = xfs_trans_roll_inode(&args->trans, dp);
>> -	if (error)
>> -		return error;
>> -
>> -	/*
>> -	 * If there was an out-of-line value, allocate the blocks we
>> -	 * identified for its storage and copy the value.  This is done
>> -	 * after we create the attribute so that we don't overflow the
>> -	 * maximum size of a transaction and/or hit a deadlock.
>> -	 */
>> -	if (args->rmtblkno > 0) {
>> -		error = xfs_attr_rmtval_set(args);
>> -		if (error)
>> -			return error;
>> -	}
>> -
>> -	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
>> -		/*
>> -		 * Added a "remote" value, just clear the incomplete flag.
>> -		 */
>> -		if (args->rmtblkno > 0)
>> -			error = xfs_attr3_leaf_clearflag(args);
>> -
>> -		return error;
>> -	}
>> -
>> -	/*
>> -	 * If this is an atomic rename operation, we must "flip" the incomplete
>> -	 * flags on the "new" and "old" attribute/value pairs so that one
>> -	 * disappears and one appears atomically.  Then we must remove the "old"
>> -	 * attribute/value pair.
>> -	 *
>> -	 * In a separate transaction, set the incomplete flag on the "old" attr
>> -	 * and clear the incomplete flag on the "new" attr.
>> -	 */
>> -
>> -	error = xfs_attr3_leaf_flipflags(args);
>> -	if (error)
>> -		return error;
>> -	/*
>> -	 * Commit the flag value change and start the next trans in series.
>> -	 */
>> -	error = xfs_trans_roll_inode(&args->trans, args->dp);
>> -	if (error)
>> -		return error;
>> -
>> -	/*
>> -	 * Dismantle the "old" attribute/value pair by removing a "remote" value
>> -	 * (if it exists).
>> -	 */
>> -	xfs_attr_restore_rmt_blk(args);
>> -
>> -	if (args->rmtblkno) {
>> -		error = xfs_attr_rmtval_invalidate(args);
>> -		if (error)
>> -			return error;
>> -
>> -		error = xfs_attr_rmtval_remove(args);
>> -		if (error)
>> -			return error;
>> -	}
>> -
>> -	/*
>> -	 * Read in the block containing the "old" attr, then remove the "old"
>> -	 * attr from that block (neat, huh!)
>> -	 */
>> -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
>> -				   &bp);
>> -	if (error)
>> -		return error;
>> -
>> -	xfs_attr3_leaf_remove(bp, args);
>> -
>> -	/*
>> -	 * If the result is small enough, shrink it all into the inode.
>> -	 */
>> -	forkoff = xfs_attr_shortform_allfit(bp, dp);
>> -	if (forkoff)
>> -		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>> -		/* bp is gone due to xfs_da_shrink_inode */
>> -
>> -	return error;
>> -}
>> -
>>   /*
>>    * Return EEXIST if attr is found, or ENOATTR if not
>>    */
>> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
>> index 808ae33..3c1c830 100644
>> --- a/fs/xfs/xfs_trace.h
>> +++ b/fs/xfs/xfs_trace.h
>> @@ -1914,7 +1914,6 @@ DEFINE_ATTR_EVENT(xfs_attr_leaf_add);
>>   DEFINE_ATTR_EVENT(xfs_attr_leaf_add_old);
>>   DEFINE_ATTR_EVENT(xfs_attr_leaf_add_new);
>>   DEFINE_ATTR_EVENT(xfs_attr_leaf_add_work);
>> -DEFINE_ATTR_EVENT(xfs_attr_leaf_addname);
>>   DEFINE_ATTR_EVENT(xfs_attr_leaf_create);
>>   DEFINE_ATTR_EVENT(xfs_attr_leaf_compact);
>>   DEFINE_ATTR_EVENT(xfs_attr_leaf_get);
>> -- 
>> 2.7.4
>>
> 
