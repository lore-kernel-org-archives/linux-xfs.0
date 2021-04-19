Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00E86C433B4
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Apr 2021 18:33:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C059F61285
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Apr 2021 18:32:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240971AbhDSSd2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Apr 2021 14:33:28 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57484 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241009AbhDSSd2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Apr 2021 14:33:28 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13JIUKs1114326;
        Mon, 19 Apr 2021 18:32:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=6v/EdL+b/TuXC40wLYXUhyWH2KJlV2De156L9+lvj5s=;
 b=v6F4SnD0EEUxhVdGDYdU95lIXwBijzGGwTb2clbb3sQpJE8F8/UDXG3OFci/F0p4Ndu2
 dwtR3hF7KMZpl4wHxrDLHOokEUkSazflKNRG3d+JRvdyQ0Gs5kGBiaDZ/mwo9z9ctiQD
 2V89HcUWip8l+MIXRZsikIbufx9gYVVEOMS36rrLDmrMOMWd4X8Obw49PsTl6JERPhFJ
 bNG719dbVssMcFz8U8OWAd2M5zPkEwBvB1JsMaCiThLjt/GLxtQfXLM7AUFgSK2+OIxK
 O3srgm+q8gIwnr1N3sZOMkyxtSHxR9FKPArvEsEEB5e+2B3iaTYS8eWS3XnBDD3t5np6 Pg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37yveacc0k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Apr 2021 18:32:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13JIQJhQ040770;
        Mon, 19 Apr 2021 18:32:56 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by aserp3020.oracle.com with ESMTP id 3809jy765h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Apr 2021 18:32:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kfJqvy6EBXcSx88gO7f56EJTEnuZGjTHs03ADG7CaFmKUjcv+5/iSOTkyPS56+E7Xav+sR8g7nu4R5/Cfj8wp1+0EPFScAh3SfFSJZqtuWgvhXfyESJgBmA2Dph3ebHFIRNWjmCUDQRK6aNnXm7FOyVMPKQ6ak9H96d+4ZH6MtU2z0zL2t+sdOFsruuRAxTAb/qAbkCL+m9UkrDkrfLLgbrfBz7BdYIricwzG12iFZSofRtdVuS7nQkrpwI97OZy190d/9ypZjvlEbp34LSTsvojTWgd129zM0X+C8qclbwXsw4nXkJZ6jktTq9VuSxgBWWYXzi0EuLYcadt0LC5EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6v/EdL+b/TuXC40wLYXUhyWH2KJlV2De156L9+lvj5s=;
 b=Wk9s3H6mc/GYZ+efIgHWFEvNvVMFRNyXoGlo1iA75G/gLVG3K1qXGV/07Xk92zqx8Fn0LRBe3jtr8RmG3JZ5gOe1w7n1zmL66rFrX0e78+Gulfuo1pKlv18R+MOGbEF71SGZzPUZy9rhngTvePv2zmppyumi/f+rs6AVVCUUTmW41EtKLUp0gQlpvLfnl3zF1Uo5mx5AL4tJAzQZhsjGThICwCVbkMTQjEyEMW4Ok8vRk8Bdgu/5J4sXP/VVmvp800VCq/ylVXEzBW0e3bUzgaRMJsaiCt5hA5/7WB8L/AiWH+1o1O6nzmYxlLA1BH4bEO5WYAKCqubsuXelxlRfNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6v/EdL+b/TuXC40wLYXUhyWH2KJlV2De156L9+lvj5s=;
 b=cCjHITaKdv4/t5LyfIJt+iffdx2GJgfB9wzCNuzUFxj3xOkbO8fCq78EKhBqRjQE8KqwmVhC/qHEPUJlZyJ92i2pQpucsxuuTh4zv3pcKE2jHzi4CaphAi3W1GBIaNEqdolAeHvfZzltrWy6WgskGSwjKNcb7ozVUt9azyA5zxM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2565.namprd10.prod.outlook.com (2603:10b6:a02:b2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Mon, 19 Apr
 2021 18:32:54 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.024; Mon, 19 Apr 2021
 18:32:54 +0000
Subject: Re: [PATCH v17 07/11] xfs: Hoist xfs_attr_node_addname
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210416092045.2215-1-allison.henderson@oracle.com>
 <20210416092045.2215-8-allison.henderson@oracle.com> <87mttuj0vy.fsf@garuda>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <94af091d-8b8e-41c8-ea58-94e812f04ab5@oracle.com>
Date:   Mon, 19 Apr 2021 11:32:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
In-Reply-To: <87mttuj0vy.fsf@garuda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: SJ0PR03CA0203.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::28) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.222.141) by SJ0PR03CA0203.namprd03.prod.outlook.com (2603:10b6:a03:2ef::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19 via Frontend Transport; Mon, 19 Apr 2021 18:32:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 623d63c2-ac79-4f28-c779-08d903618bac
X-MS-TrafficTypeDiagnostic: BYAPR10MB2565:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2565FF7393498FC92869D17295499@BYAPR10MB2565.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NpfrdJIYL2IDyMAp8xu1Te8Aj3Kv3NLR9YPI1sjdG1PBhkFwStIo5U8J1GWAHFnScrYYJPgDXL3LdpX8pwydiWSnQ3XSKkfCkH83L6AhE2ruyow5h7L2KVqBoG7Euq7lqyaybLbiatiQB86XAfhMZblijaNNZ42cyp8pjCuTurmLU9HAng3EMdqAPoNildj+F0UUdCnp+e12ZBJT8KmIx42WopOPWk4m8Fy1jZ9IFfgRKwRKTIPZ69vICWXKKz/abJxuKWo4Og+x4kwStoYZbRt6P9IAcFO/FnE2oryOzCkeu81NM+yMjd77Bw+3cuqJFIEP9ddlPViade4ulJ3jO5nfPSdaNjKzKTW/1RAnmTo856ZbkX7pec82/nnLdt6sgh2dbV7P+0XvZa2RtIZu3jHv8IzKucjaeGQYQHSgpObOJ625FQzlyrxuxLXQvqzBP0qCJrbTYzRE38ZhCLUP5qWtpHjqBjuvnkjWx98MHdbnMFDEXh70qqLa4LS1i7y4StUhkPIT0JLmWPk4eIf6vv+pMnHaNemw8MWTRpf82Beko1+2TOB8Sonm7hE2sLwqfCBSQOjHQqbCIUAnhV8KsoEY8X6WFislGp1jdhBKYh84l4KQZqnLbST96MeqlBOspAUkC7stFJ/zSD/bzdVAP8OABm3FvtFJlu9EIKdyQEWJOmlOmc2YgbkzQiVU04lxwEQ7SiGNvzIamlJGB3cnkw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(366004)(376002)(346002)(136003)(478600001)(86362001)(52116002)(26005)(66476007)(6916009)(66946007)(83380400001)(16576012)(31696002)(2906002)(44832011)(956004)(316002)(5660300002)(16526019)(186003)(8936002)(53546011)(4326008)(8676002)(38350700002)(66556008)(36756003)(31686004)(38100700002)(6486002)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bkg2UmFkZ0NJNkFpM205dHdURGZKcWJXTHQvV3BlNFQwMWRXbTdFbGpzd0JL?=
 =?utf-8?B?TEl2bmhnaE1SUGhkYW1hbFdLU2ZvQ0tvaXZpOE40bVVBSXc1dVhDQUs3VHlX?=
 =?utf-8?B?UnZubFd4ejNqY2tvRGNTTEI0OEdKOEtNQVBrQ0dWV3RGTUlDckFWaDNjRzVG?=
 =?utf-8?B?bWgwQk9nTytCNXJ0Zjh0S0VpaXlZeEpvS1FFM2RUVkVqL2ZnKzdJUVRmOHQ5?=
 =?utf-8?B?bXBXQVpPc1Nqa1NNU0RjWEhEM3h6UWpady9hRWlDQUdGS1cxNTN5dXhEbzR1?=
 =?utf-8?B?dCs4c2lXb3BnQWxUUGx4SVoveVJ0L2hnbVlOVUVIbUJzeEtFYk0vM2NpRjJw?=
 =?utf-8?B?TlFDb0VaSGJGaDRzMWZMYUJqTVU4L0hJQytxUnpnOE1MQ1BNTTRuR2FDZWhi?=
 =?utf-8?B?SUdIZ1dETHcrK21BVDIxc3JDQ0IwQWlXdzlRbUc3NmphY0orb2JKOEZGLzVq?=
 =?utf-8?B?dzREdUFUeXZLdnlscEUwUXVGT0NsYW1NQUVDRmlYSnFTOVpzSWpDMHczTEdn?=
 =?utf-8?B?KzZkaWllT2czWVExQzJlSU9XR2p1RmFueGRUcWRvbXgvT0o5U3JUSlpTVmRE?=
 =?utf-8?B?NTZlUy9URkkzR1B6RWdVcjlEaGk5SG9jTml4ZzY0TGpmVWx1Wld3Z3k1OWNJ?=
 =?utf-8?B?QTIxMExJVmt6aWY5WlRCNHJBZGRUNlJiNEJpQko2eXlWaElTU0MrNlc5VkhX?=
 =?utf-8?B?eWlMWEd3bkFPTVc1bm96MDRVRGtaZ25BOFlCZ0JvYnEvZVVWSjRRWld0QmhX?=
 =?utf-8?B?UzBXS3gvUkFrSmxlWlJ2RHZpbUkyck5MQzZtWm1OK0k2dmZhN081S2x5d01I?=
 =?utf-8?B?bG13OGN6UkRoVm5ESTFmRG9Ubi9nOEloZHdHRnMzdy9rWDRKamVlK0VZSU0y?=
 =?utf-8?B?Sm5sNCsrZDR6a2dHeHdEUG16b1gxN3A0S3RMV205OEFXNTlhSEFLaWx6eitS?=
 =?utf-8?B?QXFoV2RoNjhVUThmUnh3SnlEazNHdU9wOXB2cHNMYXNkRmRNSVpsQTJYQ3Zk?=
 =?utf-8?B?YlFGWUk3TzRiZytHNFhGNWJwQWEvaGNXbEdRR2xESVZ1YW1Lck1kNkd5S0tk?=
 =?utf-8?B?ek5WMnlnM0k4aGJtdDdvSkFWNnd1UlVxeFROWWJlQStnbHh5QWw5QVdOT2Yw?=
 =?utf-8?B?cExxbEZmN1pFSUQyYVJ1MUNHcTY5NHRIUVE0S2YyaEcyQWsxYUVTSHdENkpj?=
 =?utf-8?B?TmpoMHJqOG4xd0ROYTRwVGRhZitFN29TUWpvWkxjcHUvVW1qbXZLbmN5QzJu?=
 =?utf-8?B?T2Z1aG9hYk9uNHhxRWkwOUo1VGJQeEhqWDlVYytJUXVJZk9odHliL0szQmtJ?=
 =?utf-8?B?NUh4Y2VEbWxNRzNWNUxtRzBzZHpub0xmcUZ5N3Z4VkZwU3cwV3lhbkxOZS9W?=
 =?utf-8?B?SmlzRk9HL3BSem8vd1plVkxZS3dzU1RwaFBpbFNpMWdRUTA1ZHFWVE1iYU9u?=
 =?utf-8?B?SUR4ekZGUTRSUTVFK290dGkxMzhicjNzbDdOOXlqWXFxUDV0eG0xUUc2NWhl?=
 =?utf-8?B?VjBKV3dMSGttd0pSWmZYQ1VQQjZQeHhzMDYyclRza3lBRDhlSWxqbTZnRXdO?=
 =?utf-8?B?YUlhb1FhZEZlMFNUbHhEclFRNUY1VGh2NTI4Mjk5VW5UMDh4SUhXQTBkaVFa?=
 =?utf-8?B?RnpyQ0tLS1ExcEhzQTcwRVRacnVNc1YrZ0tZVTFoWlFLSjhPODNrN000TnVB?=
 =?utf-8?B?SVExT0t0UWNxTVpBcm9Gb2ZJL2ZFdlV4bngvdE5xVUZGd2xSa3pmV1Z6em44?=
 =?utf-8?Q?rpug2SJSGrEDLEAnfgT43uhzCck7RFWu1G4qamr?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 623d63c2-ac79-4f28-c779-08d903618bac
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2021 18:32:54.1813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +uoQh8bvPSJnmMcw4s3EDXuVTYFmdI2VCwB/3whs52cKlAoGrTqBcGEkmitx7owR6fTmmfU6qUAzb9RNXns67MDJEL3i//EdH+Bn2ytVBDo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2565
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9959 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104190126
X-Proofpoint-GUID: 3VYB9N6SsJ9bC8lRxtggCFPgDFwZG4wq
X-Proofpoint-ORIG-GUID: 3VYB9N6SsJ9bC8lRxtggCFPgDFwZG4wq
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9959 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0 mlxscore=0
 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 adultscore=0 malwarescore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104190126
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/18/21 10:31 PM, Chandan Babu R wrote:
> On 16 Apr 2021 at 14:50, Allison Henderson wrote:
>> This patch hoists the later half of xfs_attr_node_addname into
>> the calling function.  We do this because it is this area that
>> will need the most state management, and we want to keep such
>> code in the same scope as much as possible
>>
> 
> The changes look good to me.
> 
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Thank you!!
Allison

> 
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> Reviewed-by: Brian Foster <bfoster@redhat.com>
>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 157 +++++++++++++++++++++++------------------------
>>   1 file changed, 76 insertions(+), 81 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 16159f6..80212d2 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -52,6 +52,7 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>>    * Internal routines when attribute list is more than one block.
>>    */
>>   STATIC int xfs_attr_node_get(xfs_da_args_t *args);
>> +STATIC void xfs_attr_restore_rmt_blk(struct xfs_da_args *args);
>>   STATIC int xfs_attr_node_addname(struct xfs_da_args *args,
>>   				 struct xfs_da_state *state);
>>   STATIC int xfs_attr_node_addname_find_attr(struct xfs_da_args *args,
>> @@ -270,8 +271,8 @@ xfs_attr_set_args(
>>   	struct xfs_da_args	*args)
>>   {
>>   	struct xfs_inode	*dp = args->dp;
>> -	struct xfs_da_state     *state;
>> -	int			error;
>> +	struct xfs_da_state     *state = NULL;
>> +	int			error = 0;
>>   
>>   	/*
>>   	 * If the attribute list is already in leaf format, jump straight to
>> @@ -322,8 +323,77 @@ xfs_attr_set_args(
>>   			return error;
>>   		error = xfs_attr_node_addname(args, state);
>>   	} while (error == -EAGAIN);
>> +	if (error)
>> +		return error;
>> +
>> +	/*
>> +	 * Commit the leaf addition or btree split and start the next
>> +	 * trans in the chain.
>> +	 */
>> +	error = xfs_trans_roll_inode(&args->trans, dp);
>> +	if (error)
>> +		goto out;
>> +
>> +	/*
>> +	 * If there was an out-of-line value, allocate the blocks we
>> +	 * identified for its storage and copy the value.  This is done
>> +	 * after we create the attribute so that we don't overflow the
>> +	 * maximum size of a transaction and/or hit a deadlock.
>> +	 */
>> +	if (args->rmtblkno > 0) {
>> +		error = xfs_attr_rmtval_set(args);
>> +		if (error)
>> +			return error;
>> +	}
>> +
>> +	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
>> +		/*
>> +		 * Added a "remote" value, just clear the incomplete flag.
>> +		 */
>> +		if (args->rmtblkno > 0)
>> +			error = xfs_attr3_leaf_clearflag(args);
>> +		goto out;
>> +	}
>> +
>> +	/*
>> +	 * If this is an atomic rename operation, we must "flip" the incomplete
>> +	 * flags on the "new" and "old" attribute/value pairs so that one
>> +	 * disappears and one appears atomically.  Then we must remove the "old"
>> +	 * attribute/value pair.
>> +	 *
>> +	 * In a separate transaction, set the incomplete flag on the "old" attr
>> +	 * and clear the incomplete flag on the "new" attr.
>> +	 */
>> +	error = xfs_attr3_leaf_flipflags(args);
>> +	if (error)
>> +		goto out;
>> +	/*
>> +	 * Commit the flag value change and start the next trans in series
>> +	 */
>> +	error = xfs_trans_roll_inode(&args->trans, args->dp);
>> +	if (error)
>> +		goto out;
>> +
>> +	/*
>> +	 * Dismantle the "old" attribute/value pair by removing a "remote" value
>> +	 * (if it exists).
>> +	 */
>> +	xfs_attr_restore_rmt_blk(args);
>> +
>> +	if (args->rmtblkno) {
>> +		error = xfs_attr_rmtval_invalidate(args);
>> +		if (error)
>> +			return error;
>> +
>> +		error = xfs_attr_rmtval_remove(args);
>> +		if (error)
>> +			return error;
>> +	}
>>   
>> +	error = xfs_attr_node_addname_clear_incomplete(args);
>> +out:
>>   	return error;
>> +
>>   }
>>   
>>   /*
>> @@ -957,7 +1027,7 @@ xfs_attr_node_addname(
>>   {
>>   	struct xfs_da_state_blk	*blk;
>>   	struct xfs_inode	*dp;
>> -	int			retval, error;
>> +	int			error;
>>   
>>   	trace_xfs_attr_node_addname(args);
>>   
>> @@ -965,8 +1035,8 @@ xfs_attr_node_addname(
>>   	blk = &state->path.blk[state->path.active-1];
>>   	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>>   
>> -	retval = xfs_attr3_leaf_add(blk->bp, state->args);
>> -	if (retval == -ENOSPC) {
>> +	error = xfs_attr3_leaf_add(blk->bp, state->args);
>> +	if (error == -ENOSPC) {
>>   		if (state->path.active == 1) {
>>   			/*
>>   			 * Its really a single leaf node, but it had
>> @@ -1012,85 +1082,10 @@ xfs_attr_node_addname(
>>   		xfs_da3_fixhashpath(state, &state->path);
>>   	}
>>   
>> -	/*
>> -	 * Kill the state structure, we're done with it and need to
>> -	 * allow the buffers to come back later.
>> -	 */
>> -	xfs_da_state_free(state);
>> -	state = NULL;
>> -
>> -	/*
>> -	 * Commit the leaf addition or btree split and start the next
>> -	 * trans in the chain.
>> -	 */
>> -	error = xfs_trans_roll_inode(&args->trans, dp);
>> -	if (error)
>> -		goto out;
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
>> -		retval = error;
>> -		goto out;
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
>> -	error = xfs_attr3_leaf_flipflags(args);
>> -	if (error)
>> -		goto out;
>> -	/*
>> -	 * Commit the flag value change and start the next trans in series
>> -	 */
>> -	error = xfs_trans_roll_inode(&args->trans, args->dp);
>> -	if (error)
>> -		goto out;
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
>> -	error = xfs_attr_node_addname_clear_incomplete(args);
>>   out:
>>   	if (state)
>>   		xfs_da_state_free(state);
>> -	if (error)
>> -		return error;
>> -	return retval;
>> +	return error;
>>   }
> 
> 
