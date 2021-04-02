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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40A27C433ED
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 09:50:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01F356112F
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 09:50:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234450AbhDBJu0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Apr 2021 05:50:26 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60946 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbhDBJuZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Apr 2021 05:50:25 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1329SqTv176777;
        Fri, 2 Apr 2021 09:50:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=oRLJiLU4tLoEnvjiVdeeOA1sqoSVVpSAuEv0pd/xcK8=;
 b=QrhA0cXuH/6aaqfQeZcnN0w7sNVqHms6+dS3Bp1ZTVWqDwEp+ns/bB/qZHWjpMFn5FAa
 hSJP7j/sTn0NeyaqZTqzwe55H87dwYyeFynrNTtmJVY/pNhBqcx+eTDdODE4LUL+umH9
 9okNh5frog+dACP+I9pnKdfalHeKxn8JosVuhd+QpKIPCMidZxnxZpbrji6bJy/WyzKS
 hDztgThV/6uz+jriazUrmk/VMRdZ/gH6Bl2MgjHNqZUR/TW0YaruERbnKu2IaYvv9kFy
 2BnoaPQDR3aDvLr8q0wLJgC2L0uEhD+Ou8ET0WJWaIlLOvYeMu4KyDRAA/f9eW/6gsIU mA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 37n2a04ac0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 09:50:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1329jdEk173610;
        Fri, 2 Apr 2021 09:50:22 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by userp3030.oracle.com with ESMTP id 37n2atw50c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 09:50:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WwAGE/dzRrccb/P/1rnblOMBU7a8n7zuFsMRFOj/Oj4boJbNrRiehvFgVujVLOdkB8AjRYzv+889kSWorGQn3aqZbBRPzO4lguti90854V/QcKPyHDM+NKXAYqgJHaPATMO8LAvqocGRT3fG6JjMPYQcyXAwt6P4lO7VaFL1Xfhd2Hvtwk6lsXo3kp8+tkBeCtDr6HcPy308Yxgtj/QLCAKqqi66v9KqbgNpeDWAsxFJVxfpoTWfd6VhldW4QjrYJ9+qmcyPWdWRADECLe6TrsyEfGWKMjeDtEBlGFBzdHe4mVcbLbpWYdPeeOVdmgteLc7iIGg1M2LJkD70V1vdjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oRLJiLU4tLoEnvjiVdeeOA1sqoSVVpSAuEv0pd/xcK8=;
 b=PxuYA8xz6PiK2tad8T6OTtPUZbM/yj1GUFZXKr/kTZLC17vN5QPbaIvBDpPaUk4bxwfl8Eb0LsECA6DSxdo71NWmyZeViuETerb4PHNFZ6EQlM0h1VnYn1jGyjH5zJLv9o5JrzHErCB6FO9nw/PR6+p5zwc7Z4ZCIC6BTPDUXX9pUuCDw/FhLkRUFsje+7lys1iNLsywAGwP1J5B/nriqAtxqWe+FCsisxDCVOb8mK2X/EgcjqfMYuYGhXffpbehwl1wbklp5DbZ5oV8LdvtIrAs8Om/ElzvmVQfrX3yDQO1lXx6btSbVvJP+gwbUrMCvRT8w8BP3OTLxrlziP5L9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oRLJiLU4tLoEnvjiVdeeOA1sqoSVVpSAuEv0pd/xcK8=;
 b=OcCcetaP6T2jI3UPrjGGJLZbORLF1CpFw8UCkSWnUrXphEPyou12qeuNf2bX6vKQQ7CFijdwW8zvH4u3LrpsnZT1zczbZhReDmItPvfvO2AWjKobc/5Nd46PVmgVSyQosgMg4yYEBFGuZ1ujjeTDCUZnj2e+E9BqE7fk2Pjo+A0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3046.namprd10.prod.outlook.com (2603:10b6:a03:8e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.33; Fri, 2 Apr
 2021 09:50:20 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.3999.032; Fri, 2 Apr 2021
 09:50:20 +0000
Subject: Re: [PATCH v16 06/11] xfs: Add helper xfs_attr_node_addname_find_attr
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210326003308.32753-1-allison.henderson@oracle.com>
 <20210326003308.32753-7-allison.henderson@oracle.com> <87tuop72lo.fsf@garuda>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <74e8b3f3-5312-7c36-367e-bc8d61a94ec2@oracle.com>
Date:   Fri, 2 Apr 2021 02:50:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <87tuop72lo.fsf@garuda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR05CA0037.namprd05.prod.outlook.com
 (2603:10b6:a03:74::14) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by BYAPR05CA0037.namprd05.prod.outlook.com (2603:10b6:a03:74::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.8 via Frontend Transport; Fri, 2 Apr 2021 09:50:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 569cb46a-ca55-46f8-59f9-08d8f5bcbaa0
X-MS-TrafficTypeDiagnostic: BYAPR10MB3046:
X-Microsoft-Antispam-PRVS: <BYAPR10MB304640A36A796CAF73D340B5957A9@BYAPR10MB3046.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kNmHdfRb9qHlj+lTGa+cbr6+6BnOrG83zLeJL+qMdU0AmBR3gZtvC3IAwrIjH9u9fAK4QvE9BTq1/e4bgx1gWAvE09IaYZH0VxpGv99ApszDqGT1Wbxd8mFVn+/WRf8/+6QW35f5Zitw76+TQ90AfTgh2x14P+/5pLJ1JACfJemm1Nwmx3iF0Bq8/isO1ySVnXiJUOPb6XBEemTNR1gVhdejeD8Oz5OgefEQBZzTdwgfvmaU2erG2l/jVbeKs9bOngstgAHw7cUN8lN32VGQYfKrfpEzkImuSZzuTDN+zA7CQng5xSSPDyocG6fR6JclXlzGbMv4bIxV1Ene/ph5WB5ICJhoMnMM94/t+IBhxVHDQKAqrlXOqnoakbGOwZup8FtEb6Z8JktAY5dTRDjSGb4n+9kq830UHGhu9AaswEziOTBn1zm8vHL7z9ikZPVQ2wmMRI62AUrKveMDXuuBeMSFLta9gFJvyI6PaU5WDwiPkfqxyWzg/SP7uDmwCqzFgNwhXV2bjBAFyzeYWWG5/F5pR2kYewIk1wX+tXMTjp7Zaj9RA7C8oabwNtUlyQsINaMVRg4RQjCiThpNNhgLrs8gnWWwB1xrQ2EPREXjwfPbjnMuJWtJjJU1DW/o3wCfLMY4oufptyByRhvNgnCRVyTEGMDXgJz5LzSm3NFZ1j9ydn9oXhc2nZo9lU/Uwk6ktyc/EpTgciVi117o883F2Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(136003)(396003)(376002)(39860400002)(956004)(36756003)(6916009)(2616005)(38100700001)(83380400001)(316002)(8936002)(4326008)(86362001)(186003)(66946007)(44832011)(66556008)(31696002)(5660300002)(53546011)(16576012)(31686004)(16526019)(6486002)(2906002)(52116002)(478600001)(66476007)(8676002)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dldZa1RWMGZ0eFMxTDBDL0NNZWxUMi9waUtJK3hUTnpCU2xQQXJod0dveGht?=
 =?utf-8?B?MDJPK1gwa3IvZUZHMFUvamV2NHdiaWlHVzN1UlRoeTA2TVYxandyZFlIeDQ2?=
 =?utf-8?B?dzl0cTA2a2k3Wjl2Tkp3cjN5b3FKUzZiZWM0RFZNd1dVZFFIaXZFTk56Zy9R?=
 =?utf-8?B?YzR4dHhuOE5IaVVuOWFiNVhLdTJTMFh3MUc4ZlQvVUJrMzBjSWM4a1VxZTRJ?=
 =?utf-8?B?UFBENnlBNUZtdU9OeEhyY0NpK1lVUFFqUEVWdGQyNjZJMUg5cTdCMVgyamtW?=
 =?utf-8?B?UWZMa3E1dms4WVpoeFB1TUdyYUpmSXJFb0huaDNhT3NuZVJuak4xQ2YrNHlT?=
 =?utf-8?B?eUZHSjlTdlgrK2k1T1ZqSEVYcUEveVBvN3NPbGxaQWh0c1FJNzR0Z1Z3TXpE?=
 =?utf-8?B?MkJMOFhWcHhwUjdUTkNQRE9nRmlWSVF2eThaYUpkemdCRGVPQWpvY0t2eEtF?=
 =?utf-8?B?ayt0b3UwOUIva2E3NkRvNFczTnVmMGdtLzJRZ05TUlppbG85Q0o5RlhkRFNR?=
 =?utf-8?B?QXozNzFLcUY1eWJ3Ny9KWmhNRjcwVmRkTDZwOGFYTTEyY2tWVmlDWG14VWtl?=
 =?utf-8?B?eVhRQituM1hoNjl0VEFnUklyOVc3Z2lEbFFwdGx2QXI0UTZ3RXBsL2tWcDJD?=
 =?utf-8?B?cW9mN1JUSjh5NHBDdXFpNnh4TXlvSHVpTnB2U3pVU2dES0RtcTVzMDRoS2xn?=
 =?utf-8?B?MU9xbytadFdaU3ZJS1ovalRkYlZLYWF5c1p4b0dHVXg1bW9DSEtuZW1RZ0hu?=
 =?utf-8?B?YTVxaEhrQ25tK094cmVjMGN1dzAzWnBQekJ1RVlFTm9HOGw0citvUks0SjNJ?=
 =?utf-8?B?RTZhRGYvb3lkd0FhUlpvcnR3VStwWmxGdGg1NDdHcmpjU0EweTBZQ0VRaklR?=
 =?utf-8?B?dHlrajFQN3ZGUEIxdXdnZ0U5cTdsTzlxS1hCMUhkS2pCczJSdXhydTNRV2xB?=
 =?utf-8?B?VThic0p6Tlh2SUE1TndiTzNqMlcrZCtURWxDMmRGdEJWZVRmQkh5Sk1iSWhC?=
 =?utf-8?B?MXdKYnJwSy9CR1NpOUFjSk5vdjJGOTA1d2tBYzJSOFRwUm80N3ZBQ3JXMFo1?=
 =?utf-8?B?cmJhcnkvd0NXZWRDRnFyYVJ0WCtpQzkvMkUrV2c0Z2hPb0ZVZnk1Z3JWUzhY?=
 =?utf-8?B?cDZaSUFMVkYyemg4WE1kS0pWMloxUkxsKytVV1lna3llVnJENHYyaUpvTTdQ?=
 =?utf-8?B?ZkNEbGNQcm9aNUdLUXZuUmphY2tnNEdoTGJhb0hLQzlJU0dweUdCNUxBc3lw?=
 =?utf-8?B?Nk9hL0xhbkRZQ04zdlNhVWVTbS80MktaWi9nZE4xZXZhZTNUR0JwL3l6ZFdH?=
 =?utf-8?B?eHVHVGw3eXdMTVJma2NXUE9hNm5wL25lZE4rMEtIRU9nQTZWd29oVkduMVFD?=
 =?utf-8?B?a2M3R0d0cm1Makx4TklzcHlSb3hMSUNDaStKanJqM3I5UzE4Mk5ETk5kSVF3?=
 =?utf-8?B?ckFTVUF1QTJqT3F5YVV6R3pGNDlCUExSV0VFdTBxaFpRRVp3cDFPSkpNTlFW?=
 =?utf-8?B?VHl5Qk5TT25wMCs4Zk5yN3BZQ2VXK3dQbVJQYW5sZUpJTUM2NjZ2T2k4N1hH?=
 =?utf-8?B?cElib0t6RlkwU0hRYUZPSFhDNGpOQ0ZKTnRTOHBncmcvY1k4azdhUU9ZNWMz?=
 =?utf-8?B?K0h4a2d4T0xMRmFlUlVxa2MvanJ6KzRQODhvb3BrVVJhSnFsQUJCQ1N2bTRz?=
 =?utf-8?B?cDZsb0M4clNGMklpZnZSYVRTYkpJNjZ0YXZJSlRRZEM5dnVRMk1vTnl3OGh6?=
 =?utf-8?Q?Qr3//4A367mei9M4zL4hNqv69T/zZKz6qZjQisf?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 569cb46a-ca55-46f8-59f9-08d8f5bcbaa0
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2021 09:50:20.8146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Iny64QbUXuJzQmkrA1388nFwIeRwHqESckx0fTxmxln3rob6ybH2zpmCR8yKipnZ5Ggedk0RFhlMMB/opK8dOIhvy/cBbBlziZm1PIumeAs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3046
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020068
X-Proofpoint-GUID: 6A38wBVULXYc279R7gnZ_8-ryOKOc174
X-Proofpoint-ORIG-GUID: 6A38wBVULXYc279R7gnZ_8-ryOKOc174
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 adultscore=0
 clxscore=1015 mlxlogscore=999 phishscore=0 bulkscore=0 priorityscore=1501
 spamscore=0 malwarescore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020067
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/1/21 9:05 PM, Chandan Babu R wrote:
> On 26 Mar 2021 at 06:03, Allison Henderson wrote:
>> This patch separates the first half of xfs_attr_node_addname into a
>> helper function xfs_attr_node_addname_find_attr.  It also replaces the
>> restart goto with with an EAGAIN return code driven by a loop in the
>> calling function.  This looks odd now, but will clean up nicly once we
>> introduce the state machine.  It will also enable hoisting the last
>> state out of xfs_attr_node_addname with out having to plumb in a "done"
>> parameter to know if we need to move to the next state or not.
>>
> 
> Looks good to me.
> 
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Thanks for the reviews!
Allison

> 
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> Reviewed-by: Brian Foster <bfoster@redhat.com>
>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 86 ++++++++++++++++++++++++++++++------------------
>>   1 file changed, 54 insertions(+), 32 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 531ff56..16159f6 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -52,7 +52,10 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>>    * Internal routines when attribute list is more than one block.
>>    */
>>   STATIC int xfs_attr_node_get(xfs_da_args_t *args);
>> -STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
>> +STATIC int xfs_attr_node_addname(struct xfs_da_args *args,
>> +				 struct xfs_da_state *state);
>> +STATIC int xfs_attr_node_addname_find_attr(struct xfs_da_args *args,
>> +				 struct xfs_da_state **state);
>>   STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
>>   STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_da_args *args);
>>   STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>> @@ -267,6 +270,7 @@ xfs_attr_set_args(
>>   	struct xfs_da_args	*args)
>>   {
>>   	struct xfs_inode	*dp = args->dp;
>> +	struct xfs_da_state     *state;
>>   	int			error;
>>   
>>   	/*
>> @@ -312,7 +316,14 @@ xfs_attr_set_args(
>>   			return error;
>>   	}
>>   
>> -	return xfs_attr_node_addname(args);
>> +	do {
>> +		error = xfs_attr_node_addname_find_attr(args, &state);
>> +		if (error)
>> +			return error;
>> +		error = xfs_attr_node_addname(args, state);
>> +	} while (error == -EAGAIN);
>> +
>> +	return error;
>>   }
>>   
>>   /*
>> @@ -885,47 +896,26 @@ xfs_attr_node_hasname(
>>    * External routines when attribute list size > geo->blksize
>>    *========================================================================*/
>>   
>> -/*
>> - * Add a name to a Btree-format attribute list.
>> - *
>> - * This will involve walking down the Btree, and may involve splitting
>> - * leaf nodes and even splitting intermediate nodes up to and including
>> - * the root node (a special case of an intermediate node).
>> - *
>> - * "Remote" attribute values confuse the issue and atomic rename operations
>> - * add a whole extra layer of confusion on top of that.
>> - */
>>   STATIC int
>> -xfs_attr_node_addname(
>> -	struct xfs_da_args	*args)
>> +xfs_attr_node_addname_find_attr(
>> +	struct xfs_da_args	*args,
>> +	struct xfs_da_state     **state)
>>   {
>> -	struct xfs_da_state	*state;
>> -	struct xfs_da_state_blk	*blk;
>> -	struct xfs_inode	*dp;
>> -	int			retval, error;
>> -
>> -	trace_xfs_attr_node_addname(args);
>> +	int			retval;
>>   
>>   	/*
>> -	 * Fill in bucket of arguments/results/context to carry around.
>> -	 */
>> -	dp = args->dp;
>> -restart:
>> -	/*
>>   	 * Search to see if name already exists, and get back a pointer
>>   	 * to where it should go.
>>   	 */
>> -	retval = xfs_attr_node_hasname(args, &state);
>> +	retval = xfs_attr_node_hasname(args, state);
>>   	if (retval != -ENOATTR && retval != -EEXIST)
>> -		goto out;
>> +		goto error;
>>   
>> -	blk = &state->path.blk[ state->path.active-1 ];
>> -	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>>   	if (retval == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
>> -		goto out;
>> +		goto error;
>>   	if (retval == -EEXIST) {
>>   		if (args->attr_flags & XATTR_CREATE)
>> -			goto out;
>> +			goto error;
>>   
>>   		trace_xfs_attr_node_replace(args);
>>   
>> @@ -943,6 +933,38 @@ xfs_attr_node_addname(
>>   		args->rmtvaluelen = 0;
>>   	}
>>   
>> +	return 0;
>> +error:
>> +	if (*state)
>> +		xfs_da_state_free(*state);
>> +	return retval;
>> +}
>> +
>> +/*
>> + * Add a name to a Btree-format attribute list.
>> + *
>> + * This will involve walking down the Btree, and may involve splitting
>> + * leaf nodes and even splitting intermediate nodes up to and including
>> + * the root node (a special case of an intermediate node).
>> + *
>> + * "Remote" attribute values confuse the issue and atomic rename operations
>> + * add a whole extra layer of confusion on top of that.
>> + */
>> +STATIC int
>> +xfs_attr_node_addname(
>> +	struct xfs_da_args	*args,
>> +	struct xfs_da_state	*state)
>> +{
>> +	struct xfs_da_state_blk	*blk;
>> +	struct xfs_inode	*dp;
>> +	int			retval, error;
>> +
>> +	trace_xfs_attr_node_addname(args);
>> +
>> +	dp = args->dp;
>> +	blk = &state->path.blk[state->path.active-1];
>> +	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>> +
>>   	retval = xfs_attr3_leaf_add(blk->bp, state->args);
>>   	if (retval == -ENOSPC) {
>>   		if (state->path.active == 1) {
>> @@ -968,7 +990,7 @@ xfs_attr_node_addname(
>>   			if (error)
>>   				goto out;
>>   
>> -			goto restart;
>> +			return -EAGAIN;
>>   		}
>>   
>>   		/*
> 
> 
