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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D837C433ED
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 09:01:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B4C861105
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 09:01:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234207AbhDBJBP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Apr 2021 05:01:15 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59322 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbhDBJBP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Apr 2021 05:01:15 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1328xvct157267;
        Fri, 2 Apr 2021 09:01:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ZMbdt5rl4CkuHQ9xJOz4LS7U0zgKe8FH9FEQJp/5Tk8=;
 b=UNefJmuO2bpOdug9RyWXgq8JY47Xgi1mphzWQZEI2d3Psmxg/Bs7aDBkwEfdshviuwkR
 pdg7DABVixBXOBBUd2gVm5I4YLKh9qgI4XtkgNoNunuagY0MpBGkXpUK/qL2PGdKupyE
 QTw9hAIpQIioYccNtpAA3ATHI0Mxokux2V/Dwr0bDQhTtmUhVdmQnKCBS/3NxI8XXFm8
 Bsp6d/JlNeN2ax9xFTG3wzobqAnXkvxDjaxmtZTlt9HHw4FmlXUYafADJbKr0J3G12KN
 jCM5sJzQ3qCTLgwdcHNhTqPPlYGJrP+BjtnxkYOG/IKHT/dBsqZ6PfoeKdhaqOsJXcOZ 1A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 37n30sc5jg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 09:01:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1328xjhb105212;
        Fri, 2 Apr 2021 09:01:11 GMT
Received: from nam04-sn1-obe.outbound.protection.outlook.com (mail-sn1nam04lp2057.outbound.protection.outlook.com [104.47.44.57])
        by aserp3030.oracle.com with ESMTP id 37n2at8xks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 09:01:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n2wBh5xZxaANXhBj2z8ZCvh6qLPIYpHSxy6ESV3gIuMmY4GTWgwOU6UBiDRy1yZSCY1k/+ya0bEubudiDFS38K+lAPlhHk61t/oxk9T23n6qOSXpnsFLv7XFhl8hWJhWrFLihCx/CFC1DP9FzHrIRxBbKnVRb8k4pwet5dwbnSZ7DYdukxfIXqJ5ElBwwBRuuBUf+OtGSexaJ6gyQr5cF/3+yhCDtuQOt/aOr+UIGB2hbYyzMqHyZprTg16rDfoaiajy3wqgjGhsFKxp1jkcvVEAe7JlR/S7moyhKaNPDNLX3a9vgY7PcxGITj4qcucPTBVWbU9mxl2VvYwTw1c+uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZMbdt5rl4CkuHQ9xJOz4LS7U0zgKe8FH9FEQJp/5Tk8=;
 b=aDpwdMV6jh9UnDaWE8J4/FwuW3lkOTcVJ6D7/GNB4Pv6iaODxQU6O3mY3wzROzLP0jQSsNlq3y41Nb74Du23WL0A+6lnR6xyxYLKtn7nLKYbDVRG5ZulELgX5uk2nx16HREBaTs6wtXKyi243jagkk7Ovkp0Ai7+8JnQ5A5KELO5FP9bye65cAAXDRwQbrRHPwNcWgSO1e8Y2Gtn86OxHUbtAKSAO8o/oUYgYMP18f5M+745LiRgjs/vOb6zzOR64vlSOjg82fHsTMMBh5clap3QFH3ggMUWsxc7K9kG4xOAIvW0vXoybz8vm6X208U9laWFz/JZdCpL2aH3cxJ2fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZMbdt5rl4CkuHQ9xJOz4LS7U0zgKe8FH9FEQJp/5Tk8=;
 b=FUnpOBvYNCI5pSLZg/feDUUbcvBJduHhPe2mKptBL7awR4cbYRiSn1Le5BerUu3qmPKXtXx9Od35Zx0POx3bmSFxTpxqKQ1f2mFzEzRydBNWz9n+9HXT5391ZWsHiZFDlNkdXFA8Ao7hCoTSgoavBBzFd0pBJ/TaGblpjTpwb6I=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4591.namprd10.prod.outlook.com (2603:10b6:a03:2af::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Fri, 2 Apr
 2021 09:01:10 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.3999.032; Fri, 2 Apr 2021
 09:01:10 +0000
Subject: Re: [PATCH v16 08/11] xfs: Hoist xfs_attr_leaf_addname
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210326003308.32753-1-allison.henderson@oracle.com>
 <20210326003308.32753-9-allison.henderson@oracle.com>
 <YGXqLqrf2p++5k5p@bfoster>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <f227aed8-1ef5-61fe-64c1-0173936dc1c8@oracle.com>
Date:   Fri, 2 Apr 2021 02:01:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <YGXqLqrf2p++5k5p@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR01CA0034.prod.exchangelabs.com (2603:10b6:a02:80::47)
 To BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by BYAPR01CA0034.prod.exchangelabs.com (2603:10b6:a02:80::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Fri, 2 Apr 2021 09:01:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 428542ab-b7bf-4497-7986-08d8f5b5dbe7
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4591:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4591AE78049C62B2B7E54039957A9@SJ0PR10MB4591.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5Q4nJkMt2Kcme7ekIck462sKjvzD4Pl8O31De1QAohz55eZhPGyYK0Ck8d80SfqMOiFovd1IPAsp0PldDwsj1X22Lexx1oM/bZ716n9aZRQgZSh4FUhVXIRj4r4Obm0zHUQwCmMiWg1gn0iGo5/PiwqGyHV8yPhJrJIbe2bVBb61IeSFRHY3PGKRUvl0w392awMnB9yaTgjwRIY39Al+3UimYkOtVI40dYgA4Rd+RSmc3iWn7k/eN0YKCK03KICvySunDgwEFFp2nWwrojDIFGuLALIp9QDKvLhZirvyao49bhmLrML7mPBk5DsDialCLG90PCxo07rEQMwsrJBMUZt63POvZsKjKIbBflr0SLFzEseuZYNnrFvZXPWEMbibHiW08QUHzmEstRQC/UzZ3bzDZPC16xWlsKEFVZ4sy6S1LXBmOfxZ/zJ24McAb8OFdwFwUmlvt2zZXRyWcgjnS3ekVLd+QdmpwrmKv6966rwbrMsNxE+d0kFPuc5sykxlrJBSHqMJwPP6q05m9mDBJ9jQAjplOMzjuM3FFaUZMZbO6zOZzFYXQHj5rdn1KbkhTy7/VRomBJh+XijFN8nXk9OujF7cJn9ydFVIJqCksRxEff95mG0zn1DAdJ0+1YxXcUcTk6jcFOc+xxb0ze0c8itt0Ss+p4u+pgVnDWmSnnO98JTLzGQRVIJN9xgkyX7I
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(346002)(39860400002)(136003)(366004)(8676002)(8936002)(31686004)(31696002)(66946007)(186003)(2906002)(83380400001)(956004)(52116002)(26005)(16526019)(6916009)(2616005)(6486002)(36756003)(316002)(478600001)(4326008)(38100700001)(16576012)(86362001)(66556008)(44832011)(53546011)(66476007)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dndodU1CbldMTkMrSUI0QVNWQ09BOEkzT2dISUlINzRjOUFPSG9vaEVIdER0?=
 =?utf-8?B?SURjYjZBQXlvOW05T21Ydk5rY3d0RGsvQjBuMXc1blFLZS9xMmZlcDBsOC91?=
 =?utf-8?B?ZmsyakZJa0k4dWIwaDBOVERNNXlWR2FJZGZWODhFbzBTNWdMR1dRVDVWbC9j?=
 =?utf-8?B?MHlKbUFrYjVwVzdzS3FBNEEvNThRajhzVnZqU1lPWVJnSWJqcXN4NmppVjlJ?=
 =?utf-8?B?RjBhR1dFbWhiWVMrZnpIL1RnSDFxQnJxb0dJdFRzQXNrODdqQ09pS1FwQTVx?=
 =?utf-8?B?RE9KTzhiWCtWbDFUa0dSMnd5V3hibDhBRkRNRys1aFFGY1RIbmtUY0c0NEFi?=
 =?utf-8?B?ZGk2cFEwNm9wbEttajJKVU5tYnFwMzdSeTY1OG5PZVlYYzBvKzlXRm56TTFz?=
 =?utf-8?B?SzNhbGJ2ek1KUkhLeHhUT3JuUm9yVjJXbnJNaWVGcFBueS9tUXFqUHJnbE1L?=
 =?utf-8?B?ZnNMdk5vSm5nR2h6SHVBZWtIaHFuYlhoUlFyQkkxbHZuOEJJdnlqZ2Z2QXNQ?=
 =?utf-8?B?QnV2cExhRUIzbUZyZHQyZVAyQXdLZDIrSTkyTGhGR0FJTEYvcHREc2d5NHNV?=
 =?utf-8?B?R0wzRWpJdU5HRVNpVWR4MnBmUmNXNm5HQ1BWVTJQNzA5MUZPdVBVOFFvWFdO?=
 =?utf-8?B?bllZMWplZ0R5N3BFQXhLbytsTHQ0b0pvQzJxRkFEUldCNW5HK1pRdmp0OXps?=
 =?utf-8?B?V0V4aDhYU2RpV0JHWHZJQUx6OTJlWnQvV1ZGWWxqSW1Qb0d6bW9sU3BEODUv?=
 =?utf-8?B?cW1KWlJKbzdiNXVRTXZGUzhHVlQ1dW9LUExYenJlM2pMTDNicFkvUXltckQw?=
 =?utf-8?B?QXBjSWlqQnpUV2ZkYUl6RVZDRmdZRWFMNkNZdzJzR2d5d3hZR3NiKys3cGho?=
 =?utf-8?B?cWRRWjRRUktNZVV6bWF6U1l4ejRXY29rbFZTWHpHblZqNkhXU2pXU3J2VlBM?=
 =?utf-8?B?TmRFZHZLaW1SWUY4MlZXOWxkQ2Q1aU8yNUxTaklXWmdsbHIyR0haRktQOWtD?=
 =?utf-8?B?MlowbXE4dUlva2JkWnpNZWFic1dZbkxCaHY2S05Ba3VXb1FYcWV6QjA5OUth?=
 =?utf-8?B?UDFtUE9GMmRmNGlhYndYNWp0dkg3bjVmM2NvYXdRVUluTEN6dFc5YXJZS1ZP?=
 =?utf-8?B?S0daaldZd1g1Vk1nN0F6elZtWEtNdnQzdFp6WlRmWGZEZE51aTlRWVZJS2hZ?=
 =?utf-8?B?TmN3dWNvNU9zdlA1N1FWTkpSN3ZqNzl6a090U2gxNkh2VE11cnZoQjNjUkta?=
 =?utf-8?B?dDh6dWhqeXlBbDNOdzhLaEUxOC9YbVo3S0k5RGJxaEdDUExnNmowaXZlOE1z?=
 =?utf-8?B?UHhBaWpQMzJrZWdDbGxaN1hMbzZHd1BabVk5VkFRUDd3dzlJRVpkbUlzT0FM?=
 =?utf-8?B?eGhyRDZqUVkvbjd1OExUS0phTU16cDlHRVRpcUNXN1N4YitYbFA5eGIzckpj?=
 =?utf-8?B?WjFmVERIaUY5VTlSeHFKMzdHRXpiakJuZWI4NUkvSGh1dFFYTTZUV2twZGFo?=
 =?utf-8?B?U1EyUWZDWmt1cVl2elROVWpyMGtScjhsbXNENkQyZUNnUWwvendxK2FEYWFB?=
 =?utf-8?B?YzFoNENTazlCT1ZJd1FVTWdidHpBbmdBMytiQVRyQm1jTW1wTUM2N2VMd0w5?=
 =?utf-8?B?Mk03aXl6cGJMQlhmL2h6ZUcvQ2tMRFhLb0hlMnZSTzBNTFBuT0ZMMjJDc2di?=
 =?utf-8?B?MEhjcXJvSmFjNmhMcndtY3lUTVUwVU5IU0JScStUbDZvMTFlcmNWa1pTT2k4?=
 =?utf-8?Q?AVTUFaZj8qrLQu/+4jTpD0l39FqFSuAWzec3gOK?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 428542ab-b7bf-4497-7986-08d8f5b5dbe7
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2021 09:01:10.1435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5akUA1NLJxtMwB845F8YvmlcU6nRx9amA+o1bsGNTM1vpa1POBwxwCv7DvbSZusLN298WdGnoQblrhX1k/bXiAI1v6bBNnlJHtiSLqS/pT0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4591
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104020064
X-Proofpoint-GUID: -He-SawxQ9v4E0-iCCKMyZ-33RrfgOXK
X-Proofpoint-ORIG-GUID: -He-SawxQ9v4E0-iCCKMyZ-33RrfgOXK
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 bulkscore=0 priorityscore=1501 suspectscore=0 mlxscore=0 spamscore=0
 clxscore=1015 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020064
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/1/21 8:43 AM, Brian Foster wrote:
> On Thu, Mar 25, 2021 at 05:33:05PM -0700, Allison Henderson wrote:
>> This patch hoists xfs_attr_leaf_addname into the calling function.  The
>> goal being to get all the code that will require state management into
>> the same scope. This isn't particuarly aesthetic right away, but it is a
>> preliminary step to merging in the state machine code.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 209 ++++++++++++++++++++++-------------------------
>>   1 file changed, 96 insertions(+), 113 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 5b5410f..16f10ac 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
> ...
>> @@ -729,115 +821,6 @@ xfs_attr_leaf_try_add(
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
> 
> Did this tracepoint disappear for a reason?
I thought the trace made sense to mark the entry of this function, but 
then when hoisted, looked sort of out of place.  It certainly wouldn't 
hurt it to put it back if people prefer.  I don't see it used anywhere 
else, and I don't think the calling function has it's own trace scheme 
either?  Should I translate trace_xfs_attr_leaf_addname to
trace_xfs_attr_set_args and hoist it up?

Allison

> 
> Brian
> 
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
>> -- 
>> 2.7.4
>>
> 
