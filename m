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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AD79C43460
	for <linux-xfs@archiver.kernel.org>; Sat, 15 May 2021 05:41:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D375B613D4
	for <linux-xfs@archiver.kernel.org>; Sat, 15 May 2021 05:41:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234373AbhEOFnH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 15 May 2021 01:43:07 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48218 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232792AbhEOFnH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 15 May 2021 01:43:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14F5fqbY057772;
        Sat, 15 May 2021 05:41:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=OPZ+LaLlAN7TRZMI1r5joGa+c8QRF+ZtUuxwaFnESbU=;
 b=vmbjzLlqe9Ko+1a1DQRaFFD/9ETmnIaZPMSd8Uo5+AujLVrRwN4Wy42kuSw7ROmKrP0m
 VKAwXrScR3eUZ9C0d+ViNSm4a35H433mPKXT2QsiXOfqjY6xc39UjgEcfI6ub2bYNRxK
 DziXP27TwUhmxkO8TWaNDZLzt+DugE1X8oYR9R1SGY2RFQooXSzt+qL6RFNXcUGRIF4W
 5QGyQtSFrchaIVz+Gn3q7xmiRVKORuqDppo/0xfnyAX8lK7HqDWE50oPUnSpALR30yKo
 WlrJU/34sNPvzn7lqg89JzMwUGGqx+1afn4Ocz6t6lSLgtvxkNHwKEWC3MRhD7I+pTGb yA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 38j6xn81j9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 05:41:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14F5dvrx092779;
        Sat, 15 May 2021 05:41:51 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2049.outbound.protection.outlook.com [104.47.74.49])
        by userp3030.oracle.com with ESMTP id 38j3drd7tt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 05:41:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X+NaW8ZWKkNUZ1xttW4fmdRmNw7mCKGlwd8ALFtXceXeqPnfxaLMTYYyRd9vcFXeRTF+IVrNpWhboE7yQ47R//+d6FdJ4fVdj1YUeLe+Kfv20mwigH/0CEskoVeQYYOo/zQRB1fc1ZNNWmpkLrC7YwH/SXC1KbyvtMERI6lamJ23LmtgJMjk5q8Om7olLnz6ypoUwsHr0Er7rVP52J4xD0EQ7JMcCQNwK5/3sf14Dw4osfLZLH5Og67l6jwT4u0MPyGvQ/IxG1+pbeMlRPGiCy/PfT2fmY6eFxiI/U36Xbvw36GnKJ7a5jxECodYmyCvS04hUGFy23Nouv+4WjxPdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OPZ+LaLlAN7TRZMI1r5joGa+c8QRF+ZtUuxwaFnESbU=;
 b=D6bV3gyqsO5AUyk7Y98Tb57lSDDomRxr1nKK+CH6FEvkFQBlWdVwi22FKkMeNVBqNW8Iov4oCDoYMoqDEbEow6H1cr1dE0lxKLG6oYqQkVAgY+NSLi7dHUDNQ0nPu50REMnWZRuP9uhZfNTtvuvF459/BtLT5uCnNHlQm7BHGenPNOzxo3jDUeBgfdE/1Q4jjFVZ5s53Pn0c916bxJFi8ZQbganH78duDKWfFFsPogXkz7HO7GjwYpMjIfLpm6WZyKAqT7/jfZYXVOscgpWIRLHPFVkQ9vHpdMCdIq9MizV0nAuIRHKta5v1zudRTSJMRexW6AWP8lq0IqsUDzfxXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OPZ+LaLlAN7TRZMI1r5joGa+c8QRF+ZtUuxwaFnESbU=;
 b=HorLpoejJVXOCL1GMnTmioMi0YrKVNqtLG97pHRVhHVBEt3vpaj1z+syhtRrDRIA1Tu2XxrY/CKq4My6Zi9RKSsU3hmj0qyFo8vIvhJG84Mn6LYwXXTtHSKir84N2JY8IcPPvYs/PTQXZmwRyr6V+dqCDq1BpRk0eH9tSSyfREw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3272.namprd10.prod.outlook.com (2603:10b6:a03:157::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Sat, 15 May
 2021 05:41:49 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4129.029; Sat, 15 May 2021
 05:41:49 +0000
Subject: Re: [PATCH RESEND v18 05/11] xfs: Separate xfs_attr_node_addname and
 xfs_attr_node_addname_clear_incomplete
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210512161408.5516-1-allison.henderson@oracle.com>
 <20210512161408.5516-6-allison.henderson@oracle.com>
 <20210513234913.GE9675@magnolia> <20210514004137.GF9675@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <728c468b-a51f-cbb4-ca75-e4a73001bedc@oracle.com>
Date:   Fri, 14 May 2021 22:41:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210514004137.GF9675@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: SJ0PR03CA0204.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.210.54) by SJ0PR03CA0204.namprd03.prod.outlook.com (2603:10b6:a03:2ef::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Sat, 15 May 2021 05:41:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22db9fda-683f-419d-5667-08d9176422b7
X-MS-TrafficTypeDiagnostic: BYAPR10MB3272:
X-Microsoft-Antispam-PRVS: <BYAPR10MB32729C69CDBA3CC8DDED409E952F9@BYAPR10MB3272.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p9jIj1ooJ9RfVXQNsXZt3Ei8H4jHT7LTkC2vtkDf39CfhOIH0BMepcDmo7Evcr1YFPKO9OgOCO2pZqO2C2p5WB3+NYC41jJg+7DFzBzxI+s3KwwH8FZk7ybio0S7ypeC+sW8e1DG2kXqQcw0TLmnx5Dht5edQ87sgsMAgBnLW1eGqXyCxsucEDjMV2fyUG878doCeSYHMENNRGrysIYoZ2ycNx+EigZ6kDXx/N5k/X5Q8/uWOKTyIT/EclQXDdm/OB0btsYqQRKy6mCQ1eUEPiZ9D3m6sTZoHn5T95wX5ZadeETyIqBbOsYutoW2T+oXj1eD6CkPUurQnmaAkZ8W+uX9xbfyRvVE2iDI/T1v+ipxSXp+aamJxTZKTcXiJJ8OPEiMcsWf+6jYQ/2CpEU8za+BBBmjL5FRBdY3i77Iwi3mwEDVxLluPg9KfYUFZTwEtS/X6FhATaQu4Al2cUKeBwI2GXnW3ShBA/n7A5f35OAZsVjgt/5Gy+QM6bhBwi6gVCBn4t4awvCr5+ku4qz4grbBAuh3wZvsmpyFqI3HtN6GiNKIQ0gZmlohK5voOdkaTfXuKqffnoer4Da/ExzsM7lt1ARQlf+EhkVvmmFBwZr2KbX+QAYG0xEOCiMgBF65lVx/f00KwROvv96RJwfOFTeZg3wFlIWfyeGr40u1QsPFyG+ivz6IZtDAEfaajZeKYynu0oLm9ifUGRQlH3VVGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(396003)(376002)(136003)(346002)(8676002)(316002)(478600001)(31686004)(26005)(186003)(16576012)(53546011)(4326008)(2616005)(956004)(86362001)(6916009)(2906002)(66556008)(66946007)(66476007)(6486002)(16526019)(44832011)(5660300002)(31696002)(52116002)(36756003)(8936002)(38100700002)(38350700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?V08zOGRlRXFERXhwcVE2dE80TS9STHI5Rmg3eXdCQ3Y0OG1yV0RoMGw4ekgw?=
 =?utf-8?B?bzFJaWxwTWxNM0J0ck5aeXgwV2g2KzZ3dnBwNFNNU3RBRGlQQ0tJNy9KVWlJ?=
 =?utf-8?B?ZUtUcExMT1FML1FvUzZTdDM4Q2ZnWGR0Y05hOWJva0JESkx4Tnp4ZC9CVzZ0?=
 =?utf-8?B?OG5MVmx2QW8wT0ZiY1FyQ3RCWStQYitiY0d1RWc2cUlxeEVaamQxejJ2RndI?=
 =?utf-8?B?OFhDb2RQRURaelgyM0h3QVorcWUyS2dxVThpZFJwOWY3ZnhQbzJHRGpXOTZ0?=
 =?utf-8?B?eTQ4NkRtWG8zWUIySTdiNXhkdkw2WDYyVXBVbGYvM3EzS1crR3g4UnJXV0Fy?=
 =?utf-8?B?R0QxMW1pN2Q2TUlUSzloa3NaL2VQRURUdCt5ZGNKUlpYMThaWFFwdFp3TVla?=
 =?utf-8?B?Z2RlVzlnYTBYcG0zVWExUjJqZHlxZHBiZS81ZDRodVNGNXAwSnFjYlVIRStL?=
 =?utf-8?B?NGg1d1NmTGl5YnMxKzhJWFU0MVBld3V3a1hORzRucGZ1VEt1cFVTSmVNQnpw?=
 =?utf-8?B?U01QVVF1VGh1VGM3UU9FMGo2V2xZbjBhaXNhRGdObUpQZmg2ZE1LRW1nRitu?=
 =?utf-8?B?eXBTUFJtbk9ldWRaWDZ3NWR0ZWtjRmdEZzFVOXI2djAvcmQ2YzArVlRMRG94?=
 =?utf-8?B?dVc3Q0RaL0lGR21ueWxERlVjU0lsYWJIUEM5SUNYeGNNd3lpdnFFRHJXUXFS?=
 =?utf-8?B?enJQaGx3K1dSaEpnNDhJU3o0Nzl0QVVHbU5UQm1vdWlBRHIwYko5M2k1S29w?=
 =?utf-8?B?UzNNQ0xDZWc0aGROTS9rU2c1UmplMm83MXhSeEoxSThpYWowSTlLSVpZeEJL?=
 =?utf-8?B?eVhVdzllSXlxdjJNRnZBUXFqYnVNVmpvYlJXRUNkeHlkaWlvWHpSTHNXZXo1?=
 =?utf-8?B?NmFoOXpmWkNlRXpCbWdRbW4rbjNBaldoV25wQ3haYlNHYWl2VGVQWGF4UzdC?=
 =?utf-8?B?bGcrQVdDQjdOdWtVa0p5UU9iekt3dEZuWE42MUpoZFE3NDBBMXREQm5ocXBq?=
 =?utf-8?B?bUNWNEpvaURKQ3BPNmF6Vjhzdm1Xcmt2cElKMGZidHBsM3F5QVlsSEI4OHd5?=
 =?utf-8?B?MnNkMG90c1o3Z3IwTzM1d3l5eWRGM0QybmZiUFZqN0ZNZFVHV0VlV3BvdFRk?=
 =?utf-8?B?cVR6WURpTjFmQ2hRRzQ4M1BDRENxVFdpcXp6ZmpZUVNFcFFFMFBlUXI5UDF0?=
 =?utf-8?B?R3JUWE5VNFlHWnk4WGtaNzhUZjRIUktPZDN3eEdZS0s0dWlqQ1B3S3RqeURk?=
 =?utf-8?B?Tnh0MUlCVER1ZnorS3FlR3NrK0hSRnBIYjdMUEN6Q1lINFdhTFVpV0V6d2VT?=
 =?utf-8?B?Q1cvRTdXNXBOSkdFS1RXNExvN2wxY2lveHZwalliSWszOUNGWHRMQXVYU3Vq?=
 =?utf-8?B?TkxoRWhmOEh1K3d3dUF1Y0kyejg1MC8xTG93WlZQQmw5RFplSGNZU1MxeVdQ?=
 =?utf-8?B?MGlmaWttZndCWkp4STNIMGZNSVRyd3BlTWU4YUR1TWVVdVN5SFovQnVwMFpG?=
 =?utf-8?B?YzdTb2w4ZkNsQ281NXNJa3hRWmR5UE1PemgvUDJMVDlSV0g1OG9mSjUvcVJ5?=
 =?utf-8?B?ZjQ2M2diV3NFOHNycUU2RzRLRGI5SUljTEh5aUptd2NnMUhkZHltMHJSa2Ji?=
 =?utf-8?B?WVNacnlVdzl2YUtnUzd0UVpWVHM5UWtwbEJCQSt4bmVqUkw4VEIrZVNDUUxJ?=
 =?utf-8?B?R0lYQjJvTUg5eittay9qVTdxVkhoRGQzL3FLK2c1dlF4VXlMc003VGJUTlVR?=
 =?utf-8?Q?1QrAud1b5VVLYZ7ZNj3wxksWw0xT6dw58dQ2Xvd?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22db9fda-683f-419d-5667-08d9176422b7
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2021 05:41:49.8046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 77ZvUsaDfFGoXsh6gkH4qWUq6pqvTiKVmzbFgmVyY+Jll9B2W8iCES8FbJKnuDfY/M1QeQk60wCqZIlRoz8t15uavmAecc7qQUVrBr3zs5E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3272
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9984 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105150040
X-Proofpoint-GUID: zxvSLZSUaY4AJ1Sz8JzVirKvhPagEO5R
X-Proofpoint-ORIG-GUID: zxvSLZSUaY4AJ1Sz8JzVirKvhPagEO5R
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9984 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 priorityscore=1501
 phishscore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105150040
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 5/13/21 5:41 PM, Darrick J. Wong wrote:
> On Thu, May 13, 2021 at 04:49:13PM -0700, Darrick J. Wong wrote:
>> On Wed, May 12, 2021 at 09:14:02AM -0700, Allison Henderson wrote:
>>> This patch separate xfs_attr_node_addname into two functions.  This will
>>> help to make it easier to hoist parts of xfs_attr_node_addname that need
>>> state management
>>>
>>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>>> Reviewed-by: Brian Foster <bfoster@redhat.com>
>>> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
>>
>> Makes sense...
>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Great.  Thank you!

>>
>> --D
>>
>>> ---
>>>   fs/xfs/libxfs/xfs_attr.c | 23 +++++++++++++++++++++++
>>>   1 file changed, 23 insertions(+)
>>>
>>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>>> index 1a618a2..5cf2e71 100644
>>> --- a/fs/xfs/libxfs/xfs_attr.c
>>> +++ b/fs/xfs/libxfs/xfs_attr.c
>>> @@ -54,6 +54,7 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>>>   STATIC int xfs_attr_node_get(xfs_da_args_t *args);
>>>   STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
>>>   STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
>>> +STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_da_args *args);
>>>   STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>>>   				 struct xfs_da_state **state);
>>>   STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>>> @@ -1073,6 +1074,28 @@ xfs_attr_node_addname(
>>>   			return error;
>>>   	}
>>>   
>>> +	error = xfs_attr_node_addname_clear_incomplete(args);
>>> +	if (error)
>>> +		goto out;
>>> +	retval = 0;
>>> +out:
>>> +	if (state)
>>> +		xfs_da_state_free(state);
>>> +	if (error)
>>> +		return error;
>>> +	return retval;
>>> +}
>>> +
>>> +
>>> +STATIC
>>> +int xfs_attr_node_addname_clear_incomplete(
> 
> ...well, so long as this gets changed to:
> 
> STATIC int
> xfs_attr_node_addname_clear_incomplete
Sure, will fix.

> 
> --D
> 
>>> +	struct xfs_da_args		*args)
>>> +{
>>> +	struct xfs_da_state		*state = NULL;
>>> +	struct xfs_da_state_blk		*blk;
>>> +	int				retval = 0;
>>> +	int				error = 0;
>>> +
>>>   	/*
>>>   	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
>>>   	 * flag means that we will find the "old" attr, not the "new" one.
>>> -- 
>>> 2.7.4
>>>
