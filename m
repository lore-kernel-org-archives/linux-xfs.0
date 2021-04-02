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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28323C433B4
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 09:01:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E32CB61003
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 09:01:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234327AbhDBJBL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Apr 2021 05:01:11 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59244 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbhDBJBJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Apr 2021 05:01:09 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1328xdsu157182;
        Fri, 2 Apr 2021 09:01:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=UzcmmT+3gNnOe5I0wOu9ReYYqFfgF/cwTkuHCYzbYzE=;
 b=CI8hH/Synguo/pTS0xsh5YYCp4NKZInwV7KEr5N6jj7Fb8Hu4hq8gRl1KSZ3glsvjcTV
 xssimjPpIgZTbsuAwWYr/SuUDjNZnhh6T9QnOovbM+FjrJ90mZUL6QrhIjwh060bvjkw
 1VNGpPEdhHsnNFgTeOr4EXJcWjY/UtR/YcNOgvr49buybbzZEbQ8mNSHODmqrhVRvsEN
 cgZQP6TA5JWAtqgTxr9J+2nEIh/5x+5sI7K5SNGTwPVwMkO0NFom+xSCP9s0rPs+tdEP
 j8iEzlZtppnTbub9CDDQ9h25Ii0U/CLEMik0kj6iXto3AeWHx6XygEVH8VPrgAGCpx3J yQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37n30sc5ja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 09:01:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13290xP8157086;
        Fri, 2 Apr 2021 09:01:07 GMT
Received: from nam04-sn1-obe.outbound.protection.outlook.com (mail-sn1nam04lp2058.outbound.protection.outlook.com [104.47.44.58])
        by aserp3020.oracle.com with ESMTP id 37n2ac9hat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 09:01:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e04rEjMrn9ofDR8DRK6ezD8pMiQMRrR2lFf7U2lyC+pFAm/7qNEAvE3bm3eld4XDmOV7BDhksghuhi+sP5s8YpzbbSaZ+Y4FtCNxwboRyUKMZBvRkRx0nWM4XsO+mpBqwtLA2Lg/1ZwTOzuXKpKRvzWtbm80OJ4LknXSEhzJ60rtFfZfbAu/HhoIC5K4YvKdKLiJgi75fu0HoyBN/U1eP3QnxP5gXxh2exMfI/6Bp+QaOFycjHhlnGIjrObKy1SCpKWhQ0u2Qs9Eq5bmkx+pXm17hR5hgZN3aR325jfDAJ5iISPKL3btXDetoGtIFYHz7uDfh9oy+2aOBrHVvHVMYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UzcmmT+3gNnOe5I0wOu9ReYYqFfgF/cwTkuHCYzbYzE=;
 b=MUu4yvR/LJiLOjdliisSMenZDx5Km9iGeaIs3QmqvBMqY41lfvLokcrvge1l1R9Zn8MBVBjGODKHieLuRgk1G31A4fdow1c5xwVY2f6wSLKjh+rguH+9QcFMZxFfvPn0sfugarWUA2FnxNYU0RsXN1Sx0UqO54D6029aHiZ8K3IT8iwShewuvX3qga8MQH3hLibH8xlo6J3iQtIGeXhbbkhz6EWnvmzarh7ERc9XUQoyfuPFg3K+G9pX2uszEsiLdm0dBZGn6S8rKnP1Kc07I6KScsw5kikX+IaYhyrJeyBKrh+KOS3MSHjicgrmRpDcoLQPYzJrHpR73bO5Du5ITw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UzcmmT+3gNnOe5I0wOu9ReYYqFfgF/cwTkuHCYzbYzE=;
 b=OL+S2HzmhhFRqGc4gkMB4txZfC9W/bYwmANVoFyqKvd4OTwsAwffIMh+uHhXAQILmFE5ZBVn1bFlNeut/9eF/NHaJI6Z8E06oFMgBy3T9iUI+XQvxyE6eFFlmpqF+iALQKDre78yksn8CJ5QR2nHZuYuKXVh6ZuTy6WX/8RbDHk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4591.namprd10.prod.outlook.com (2603:10b6:a03:2af::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Fri, 2 Apr
 2021 09:01:00 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.3999.032; Fri, 2 Apr 2021
 09:01:00 +0000
Subject: Re: [PATCH v16 05/11] xfs: Separate xfs_attr_node_addname and
 xfs_attr_node_addname_clear_incomplete
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210326003308.32753-1-allison.henderson@oracle.com>
 <20210326003308.32753-6-allison.henderson@oracle.com> <87ft0eauo5.fsf@garuda>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <ddd333e7-5469-0fa0-9c35-951740ddd71a@oracle.com>
Date:   Fri, 2 Apr 2021 02:00:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <87ft0eauo5.fsf@garuda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR01CA0014.prod.exchangelabs.com (2603:10b6:a02:80::27)
 To BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by BYAPR01CA0014.prod.exchangelabs.com (2603:10b6:a02:80::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27 via Frontend Transport; Fri, 2 Apr 2021 09:01:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d10486e5-0520-4f8e-729b-08d8f5b5d632
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4591:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB45918323402C1E3647F64323957A9@SJ0PR10MB4591.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 84iulufv+sJkWxv+X3tyggcGhHfdWOJdyLUF8CxRDj5xcb7VHSbmyB5149uDXS+WzvWTF4FCPffjuoNzrtgjBd6sKt8WF2eGReTTncvSfu66gPhizcX59pJqEV8ZWSeruQyUoAcbsMknjDk9CIcx1csNAxmFXGPbmbEnEbqVOfa0/hyVrAhTRE35IAM6e9hADQ77+m/CAu26UYmshZOCtJ+ihoQXk9Nd7sFgWefpLybHOl0w7v0FHqiPj1aHNH/f6BBrK8VxTCrTIID9W6UArVWC41KXcs7WqjW4GMcctbDK3eyzp4vFfISoZ/Z1cO5hPO5hJ7hIlp5KqlzbHJd8GqQ2GNzZwlvSnqcfC3SBF5Ms01BvocHXYwWKat5jtYvsfy7hARwSMnHBa4f9kcwCpxb9YFf92PuEo+anFmGnS7SAGu2JI0kVkSKS1Qfyh8yJE1NqWLB7XcCXSb1ig03MxdEAZ9e/medjii2hsQI/RgCg+6Y3yvWmzZ73A8MrRkksl6cQkBd9E7/WZiUWsZ76Q24OGfCmH3o+5cr8jKnC/QdEsH8Ra8nBpsbJXu3NDnrsbfNU0OjH+kOR7uG1OUFUlV/0ZBG3cQvXsh0lqrWZZ+E/f8G2OStTOYAtUCaqoP7pQxWQHt1pzLEp4R7barnraZkGYGaTXsraUNQYpzJgGDNsoFjoJ2lUIQORXZqxnt7t
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(346002)(39860400002)(136003)(366004)(8676002)(8936002)(31686004)(31696002)(66946007)(186003)(2906002)(956004)(52116002)(26005)(16526019)(6916009)(2616005)(6486002)(36756003)(316002)(478600001)(4326008)(38100700001)(16576012)(86362001)(66556008)(44832011)(53546011)(66476007)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MkRuZzRvMFpnK2NNTkpacWtSWTdVWCtIeXduNlh0dlNzY2N5ZkNheWhnZ2lE?=
 =?utf-8?B?OW9Oc013TUh4UUlvNTcwQmZaZE1MWmRja0Y3WjN2VVN4ajQ2b2VhZXo1TDgv?=
 =?utf-8?B?dm8rSzFueDNzY20wb1V6eVlNT2FVTTdxck4zRXBLNTFBZGJYMkZSQS9BeU1F?=
 =?utf-8?B?YVAwNS9UZWpZY2x5ZEFNTXJkK1pPeFJOcm0rSVNSUmZKUEtzc1JuenhiUmdh?=
 =?utf-8?B?ak04VUdBQ1BjQ2tNcEM2OHc4cGUreWpPdFp4d1JRWUdMY1BIUm40d1BwZFhG?=
 =?utf-8?B?Q25CUThzemZoZkNtWnhoVk1FNEJ6ZFF5anRyUUtUWEFLMFBlQk5SQmw2QjRM?=
 =?utf-8?B?dWpUY2lXcEJUUm05Nm5GcXZpVnI5MXNTOHpQZmdaN1JGOUtmM1RMSEdWbWlV?=
 =?utf-8?B?WmJtbG5uUTVRbGpZMk9mdTVTNEZJYlBPdkpDeStHMUxUU0xWdXVvNy8xNkcr?=
 =?utf-8?B?ZnJiaWhsMzU3aTFwK1Z3S3Z1K3p5eDAvYTdCc0s0dDI1a0R4TTdoV1dEK1B6?=
 =?utf-8?B?OVZnaUt3bUJHVVlwbUxFS3E3ZHpreTBhbmRnUXJ5dUltUTdpTW9TaUwxRU5V?=
 =?utf-8?B?SjRBbWtsWTZGc0ozVkdhT2ltMnJWMW9QaWNob3RZRzFDUEcrQVpCZG4zdUQ3?=
 =?utf-8?B?L1FheTZNaUlyMlE4T0s0TE01WWdickVtdnRTNmZ6bGZKSElyOXhMK1RnS1NV?=
 =?utf-8?B?UkJQNEgrU01kQ0Q5cm1VZStpU3Vra0wrUTloc3FubzJHdFZoK3gzTmI5WERo?=
 =?utf-8?B?YmRJMlpIMXVPa2EwbDBPYW9pd3JiZDFlZW5UeXhaVUhCeTM5MGpvc3VzNWtQ?=
 =?utf-8?B?aE5MRUFjNkNtVkM2QVV4eGI0MlcvZEdpYnQrY3JQa29aQnhveFMvQmVwWVVx?=
 =?utf-8?B?bHVYQ3hEQnRFdEcrRzBXWXpVNG1aR3MzVEpzUUdlNEMzM3ZpWlpraDVoQWpS?=
 =?utf-8?B?bTlYSytPR25sVEppTkppQ3BGcGswNkREVUl1RDJ6dEhrd09kYVhTQnJRZGYy?=
 =?utf-8?B?SzRpZ1Y0ZXNVY2dzLzI1SUkzK1pDVitxMkdHamY3eXZ1R3RRdGt0Zk0yYmhO?=
 =?utf-8?B?WVJKS3h5UEVRNk8wSjQ0ejY0YWZnVlZ2Y1VDVDFyc045VjJ1bkhUVi9iYXdV?=
 =?utf-8?B?OU5WM1E0TlFZWWd5OG1mVm5BS3RpUjBjZUlmdUJxTHg0ZzB6NVp0RlRZUG16?=
 =?utf-8?B?cTdLUGcxNGNTb29YVXhZK3dhRS9YdTk4ejhMSTlXZDM0MEZ3QzhLcTF3VDlk?=
 =?utf-8?B?RmVtenEzQVdvclhSb1lOSkdGekVVUTYxb2ZkU1JyU2YwOXA5OTlwT1VTbmFi?=
 =?utf-8?B?Yk5sR1JWQk5YTTdWeE5iK2krZFBaQ2xlWE96U2dBcnYycnVuWFY1UHJkbzA2?=
 =?utf-8?B?T0lvSzY0RzhvWjBTaWVKeEFKREk1VWE1QXREYjd4MUMwNU9hanFiTXE3SS91?=
 =?utf-8?B?aTN5Q3BQdmFYcjl6WVp2blhmMXJnZEk4WTRWa1pQUEVvN2pzWE5xSHBEcXRX?=
 =?utf-8?B?VjlSeDc1MHZYaTExWGcxdkxBVVp0c3NjdTdWcHVzcG9TK1VTbHJVcXVWb3pC?=
 =?utf-8?B?d3E4SUdzSGJPakFhOG43eXkyUkxBdDc2U3JVTWJEbDFHTUdYWGVPZVIyRndy?=
 =?utf-8?B?OW4yN2JJZ0ZtVGQ2UGVGMElQWlo3cWF5Yy9rSnBFeVlod2gwYk92VXkwRFFa?=
 =?utf-8?B?ODFnNHFTcUNJNjdZNW05WURlWGpMNTJBQWd0YVAxSXkwelRmRnd3aXo2U2VY?=
 =?utf-8?Q?utA0c91kBjgaSdbkU7tAGntOnc+VY2OOSsVhlZa?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d10486e5-0520-4f8e-729b-08d8f5b5d632
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2021 09:01:00.6233
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TJ3AexwFrmn4VFZPy26PcI2gMhetOh/PjMWT9TQtR99lim/rLpwxJ45wKP4qBudgOiGgBDFNqQVLdOSi+AdeEKFhbwUzH/5isyLfkNm9BIw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4591
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020064
X-Proofpoint-GUID: wwnHHwZApH8zemoqzzkJbJbraw3iaNKU
X-Proofpoint-ORIG-GUID: wwnHHwZApH8zemoqzzkJbJbraw3iaNKU
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 bulkscore=0 priorityscore=1501 suspectscore=0 mlxscore=0 spamscore=0
 clxscore=1015 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020064
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 3/29/21 7:42 AM, Chandan Babu R wrote:
> On 26 Mar 2021 at 06:03, Allison Henderson wrote:
>> This patch separate xfs_attr_node_addname into two functions.  This will
>> help to make it easier to hoist parts of xfs_attr_node_addname that need
>> state management
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> Reviewed-by: Brian Foster <bfoster@redhat.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 20 ++++++++++++++++++++
>>   1 file changed, 20 insertions(+)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index d46324a..531ff56 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -54,6 +54,7 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>>   STATIC int xfs_attr_node_get(xfs_da_args_t *args);
>>   STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
>>   STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
>> +STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_da_args *args);
>>   STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>>   				 struct xfs_da_state **state);
>>   STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>> @@ -1061,6 +1062,25 @@ xfs_attr_node_addname(
>>   			return error;
>>   	}
>>
>> +	error = xfs_attr_node_addname_clear_incomplete(args);
>> +out:
>> +	if (state)
>> +		xfs_da_state_free(state);
>> +	if (error)
>> +		return error;
>> +	return retval;
> 
> Lets say the user is performing a xattr rename operation and the call to
> xfs_attr3_leaf_add() resulted in returning -ENOSPC. xfs_attr_node_addname()
> would later allocate a new leaf and insert the new instance of xattr
> name/value into this leaf. However, 'retval' will continue to have -ENOSPC as
> its value which is incorrectly returned by the above return statement.

ok, I think we pull out reval in patch 7, but probably a quick retval = 
error; assignment at the end of the -ENOSPC scope would be right for 
this patch.

Allison
> 
> --
> chandan
> 
