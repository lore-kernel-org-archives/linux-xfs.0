Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70E6AC4320A
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Jul 2021 09:17:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FB6761019
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Jul 2021 09:17:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237992AbhG3JSB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Jul 2021 05:18:01 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:23728 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237895AbhG3JSA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Jul 2021 05:18:00 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16U9CGmQ011956;
        Fri, 30 Jul 2021 09:17:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=J3+jmRL7xq6KUMTQhmWDNnRy1Hx8UoDJKJ7EhX+kJGg=;
 b=Bpzj86QwwKLFp25YloKzdUWidc/F4bx+TOxZuj5ww4opmMUn5VYJRXSwK5U9y2+bkM8d
 ThQuAydv9nS/Bs82f+ngyYs0OaCwkJ3cs9tN5YlbNjOxBFdYNyBOIQscOhOQ0fDNI08P
 vBtZy0wz8Xdzi1rhR5rq8Vceqps3MaFF3wvxmaqX0dWIgqqwSwJA9KIy7V90OvuhxA+o
 8eHypi7TxduCj4GJJAGCqepAXcMF7JVuW8TCzbP2kHn+vmq711sLH3rFs8TMM4NXsgKV
 KG+bkjOK2B/rgPeVV/TzhxlsRk1BXs4tmfpuTMggvQ57JXFoAxBejtyrk8haig1SswZU kQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=J3+jmRL7xq6KUMTQhmWDNnRy1Hx8UoDJKJ7EhX+kJGg=;
 b=wg8y1wp9nH6HzIem1qUWXD2L7k1LL/b1lwubv5ODeAAc+Q/lK+nYqbVbKk9lO1byExnI
 9LMRU/Knvb9jIVWxSIgam8vAj9DL1IAdI+lq11VNS8adrsP+6POEoFXlbPwN7VFQAKPi
 JYEk66vz1BYKNky1cMHu8zk5pk6bOcEnki6wD1DsRwGpOKDEP9OYKL08Bc1vxMUNZYFy
 NIYtG4BNNXp6pFyOjAZmYLUtXbqI0zcWe0l8W5TUejF3ePF9DmZ/KkuVIgeVJv72BzEN
 us8+7di2+NFT1Lp9w/13RXwISrELapg+tDoeVudUm9z7LCYWOkU5uYwWK+lwTArTIxWo Dw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a488d8nwm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Jul 2021 09:17:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16U9FYbe071221;
        Fri, 30 Jul 2021 09:17:54 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by userp3030.oracle.com with ESMTP id 3a23596up1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Jul 2021 09:17:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HMAxYS/6ldyGZu+EIECeOXSZBRlbO9VD3oARWrKxig13DRbwpKS4pjKAmpeFbK22Atb6RfgWW4NgOOf4CEEAT6g22g6uOQ+Sm3sPY3E8LfLWglKzgqJZvO/qlhZoIemIfw1Am717y+4wdP8AaZ2n5hpuQWXRuj8J4Q+vzg0VaG78HNM7DFovWpKuE4Mbya5GlEjMnAFzCvWePH3OgExwaBlapJJk1LICay1JvHB57Yh3Q/jezCT/al8r10KCIQey8kVdF2Fzg68w/7IRj7eOfcokY5gPDs/h9rOS6PRrgc1ZLL6FXTfnkY42gdc5kQ2ZVMJ5+Xsh0os2cxivACLkIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J3+jmRL7xq6KUMTQhmWDNnRy1Hx8UoDJKJ7EhX+kJGg=;
 b=Z2s3Rpae0SYcE12/kXh7Fgn/hD77hdn5pNwOJPcFmAGGN3xy8MhFz3+4o2+NrdEsBgJQkqWsxb4qwjKX4FMmu0+yqWhiVsI/Pan1INqUFCJufnWpUEHz+4PGARc+Eh8GQKKPOAa9a2HhyDUe4PL82mTp3QDf5nuyNI9CyCislhRHt0vXUub3eCUH3uZZaIvTuO6aXLfS/1QwkJzY2dDbxiRMNjAnaLc/Qz4PzrxBcpkY/MobqXaV2oeg8UKkgPeZ0LF6Y7hzZgf/d3aX1D/IMRe8lfnSWdxVHFyY35LBUqdL6t4r19u7o/oBA6kQ+DtGdzi4oK5ESm8BVjB2z/xetg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J3+jmRL7xq6KUMTQhmWDNnRy1Hx8UoDJKJ7EhX+kJGg=;
 b=z5S6Eznot+XIVy112JeF0eW0jBZiN5HsB9joslfGC7+Z5aP4ph1qAOrxYTtoZzXm9SmQFSESD2wRfRmBZbbP1Ebw2wagfZ2NNRXAWkADW+7o5zS6wuIjv6b3WU5usFO1Syo/5pAyXAl/39ajxuZwiA1oI5CV8I8rRlQwV1hVLsM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3384.namprd10.prod.outlook.com (2603:10b6:a03:14e::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17; Fri, 30 Jul
 2021 09:17:53 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%9]) with mapi id 15.20.4373.025; Fri, 30 Jul 2021
 09:17:53 +0000
Subject: Re: [PATCH v22 04/16] xfs: Return from xfs_attr_set_iter if there are
 no more rmtblks to process
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210727062053.11129-1-allison.henderson@oracle.com>
 <20210727062053.11129-5-allison.henderson@oracle.com> <87wnpavdh3.fsf@garuda>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <d2acb564-624b-e4f7-97fc-ea3f1c69052d@oracle.com>
Date:   Fri, 30 Jul 2021 02:17:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <87wnpavdh3.fsf@garuda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0039.namprd08.prod.outlook.com
 (2603:10b6:a03:117::16) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.166] (67.1.112.125) by BYAPR08CA0039.namprd08.prod.outlook.com (2603:10b6:a03:117::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Fri, 30 Jul 2021 09:17:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ace02fbe-7c6b-4a76-4b92-08d9533ae943
X-MS-TrafficTypeDiagnostic: BYAPR10MB3384:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3384C322A663BB618BA01C3995EC9@BYAPR10MB3384.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZtESCNv//MSNzLPKGP15K2/yRLYIi4wyLYlHqMBYQMGE4SkYy0vDwiq+h/cRddAwyP670LgA6ePRoAEINdN3qQSAf8MbXUUuIsEtr/AjNEp15ZaikQR4CMt9xF954qEZCPAwQYXNG5BQ2vS74gWpKVY8BQW/rwDxAfWBwDccZFihAe5nb7bgsJlEqsGrZtYQrK5WhV4LdDrWHmoW9KOVqYCPbXPgGCXZWD0flxjU8FM8mQPZQ+cTODBSCigIILxAkPo59NozMKzr+gcOW9+y560AM6jy0x9qER+eyRc7QQPSDfQZaVKaGsmxQWdkXjXed1W6nzlx0g/7XjcMDsSDEkI8MvhDwECe7GwI58P6YucG4vLLahEP7QEf3XEYsrPGtI4PEUhJw+8q1waH9z3fnYcqVQQY+4/T7MRFW49we1pg2TCeFF67HOzMvK44/1G0Gttj/8jqaLS33kUprwJcuEEci/DItpwFqE7Tezjib6oIGU0SexyJ/uf9i0qlvRUxe5YAlkeIJvGMBdwYEXGpiYTl+uj2k7ejuHyqGXmgpN5tY282epBMhKL+5izNAfAokFL8jAUtQUKS1K00a7pERXFQNOIT3gHIGE1K6sJ6sO5t7+Tk733jgpHQ2CPDVjHVFKM6QPcl/+Oxh2qL3wGkz0stKikLDFAe/AuBjNfyklZAlzasfRrcosNiarYvsmzewHl3GLf2Q0/yv9y1jdPlixbczaV+1DpNAU9tA88Oo1xpyKleOdsZKSKQU5bDNH7NptkqrhvYgUnXXJ1Hlf1oHwMxo3yPuf9ZBnXPbCZs4ap0QNr1esNA41PqEwWsRqO511PGQhaDlV7JH3kTAF+WSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(366004)(376002)(136003)(396003)(316002)(36756003)(4326008)(16576012)(8676002)(186003)(31696002)(66476007)(31686004)(478600001)(26005)(66556008)(8936002)(52116002)(66946007)(86362001)(44832011)(5660300002)(2906002)(6916009)(53546011)(38350700002)(38100700002)(2616005)(83380400001)(956004)(6486002)(29513003)(40753002)(133343001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VVFPUE94SnFOS2Y5WHY4aXdNN2FrTVVHZi9icHBaZUV5YjZCWmFEeDB0RU5I?=
 =?utf-8?B?NWp0UVlJWmJwZEsweHNMd2F2Skt1WkhNVVdOdi93UHNWQlB4SU5kKzVaWHhx?=
 =?utf-8?B?UmNobUszV01YaE9tb0RYNjYzWWtwU3ZjMy8wdFAwSExwVmtKTmRrcUNKcERK?=
 =?utf-8?B?cWE1bE90cG1hdGlaRWF5c3QvUUJmMDVYQURMd29vdVhqZnF1VC83aEI2ZVZk?=
 =?utf-8?B?TlF5Q28rcnhSWGF1MHRaOSs1UFg3NDFJUEo3TC81YjVCaXJjNENPSVJkTXFa?=
 =?utf-8?B?a0ZZVEJkamxBZ0dNTU9nSDlMT1VZZDE3MG9GZEtKdUhCb21GSlNyZkFkUEJU?=
 =?utf-8?B?VTlIREZ3aXRhQmVpQVZSd3I2WFFwalZHMmRuZFk1QkE2Ni82eWJoK1Q1Tk96?=
 =?utf-8?B?NDNKNlVBNFlWLzB1SlNoR1dUWkE0Nkprc2Q4QzZkUG9EMG9DaFdNcXdLeXRl?=
 =?utf-8?B?UEdobU1XeC83ejFKK3BlRDhocWxwM0ZodndmeXdycjlPNkhadE40TlRjSHZZ?=
 =?utf-8?B?OXFBNk9zMGpCN1Z0djZETlFRUVJYR2RUNm5vU3ZBalZZZXZyOWxpMjNxdS9F?=
 =?utf-8?B?QTJDWnBEVUhBQmpNRFdWbDFkL2pobUNVc2FHZmNiYkNGUDUyOUVIOXNkSENl?=
 =?utf-8?B?Z2VTMXRaV0pGMVUxc1gzMmNsQ1hZWHZDdlhiRThrZVNqMUZZSzdON01DbE1t?=
 =?utf-8?B?QXNaZlhTYnlsbEw5NzdnN2lhZGw1TmVWbzVjRFdQZzk0djZhNWFNNm5qOXBt?=
 =?utf-8?B?bVRGYXlsMU1BTllmOE5JdEdMMlFXeExDUzVuT08zc1lmK2thcXF6NXBMUUxL?=
 =?utf-8?B?QkNZclJrQVc3UHl2WWkxSWtoUHZoaEpRSmJqTTNsdmhxVkRBcVF0UmNQc0dP?=
 =?utf-8?B?dDB0Uk1FaTNVNXJKV1VDaWo2V2djbTBLYUJKZlFIeGRDS2JRQ2txbGpPSm9M?=
 =?utf-8?B?dzhNNkEwV2hxejJ2cXU3OHI3YlRnNFlWR1RMWm40ZVZSK1VBcG9wZUhyS00r?=
 =?utf-8?B?UHUzQnRFZk5ablNWVUFIZDROeXJTaGNncGN0akhqMXN5V0dWWEdCb0xFSXRD?=
 =?utf-8?B?NzVMYTF3dFhFTVV3N0txSGVENHdWOWR3RTVDUlUrUzhKTDF1cFNnYTdLUWxm?=
 =?utf-8?B?azk1ZGVtaExWc0FUT2tQMDFhWUFjOEZYSnhZTUg0YTBLTXYvWEp5RzFNQmZ0?=
 =?utf-8?B?dVBxNGppWm5rOXRrTnd1cVphTllFbXc0Mk5pMUErK1FqZ0I1a0duT1dxKzVQ?=
 =?utf-8?B?N09ZTWVmZjdKNm1PWGVFN2k4Z1kzcjVIcFlWVExPdXYwbmhsb3d0ZHplSkVY?=
 =?utf-8?B?QUR1V1ZwdllxTmhtN09ZZk5nMm1QVHlOWlZtNG5lOEZweWhydk8xWnB0S25X?=
 =?utf-8?B?TFphZ2FBV095RnVHNGs0TFBZSmU4TkNnWG8yU0xsbWRzU3pZRExpbmFHUlpH?=
 =?utf-8?B?RjhONWJOeVdrV0U5bnFmMFBuV2ZrS0pJbHExV0ZOaldGdzJwc0lHYlpXN1lT?=
 =?utf-8?B?VlpRbVBEdmJyWFVERjNobSsxZWZBZlpxMjM3c28zUlFWRlloWXdENVQ1aVRr?=
 =?utf-8?B?Y1FHY3VIbG9Fek5vTXQ1cVRjeUVUOWcwaWlwU0FQbGtycGtPQ0FxRWFXNEhw?=
 =?utf-8?B?K3pkQU4wOVU0THRzOTA1VnV1Q2NrQUprdzBUU0Q2OEFaZ0VGay90WkE1Q0VL?=
 =?utf-8?B?VjJFaEY1R1p5Z3hQWTFtMWZ0TmJQUWtyZGtaUy9OczBjYmxQZjNqN3UxMEM5?=
 =?utf-8?Q?doTQSH1Qpk2tLQqJDeNBmP9tsAWTC0Jb2rbYlrK?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ace02fbe-7c6b-4a76-4b92-08d9533ae943
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2021 09:17:53.7271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hsRwd5FD6zFl06Hbji4kQ3RxQJ0mOdl3Y9e2ut71iNbinW2bcXPOBRpbVHQIXib2N+HCo9IRdofL2ijOEvvZWrt4q6iipCK3HakZL+Ec/eM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3384
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10060 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 suspectscore=0 phishscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107300056
X-Proofpoint-GUID: SF7bfyEf_Z8vDE0jHrZsm5semAe_t_Pd
X-Proofpoint-ORIG-GUID: SF7bfyEf_Z8vDE0jHrZsm5semAe_t_Pd
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/28/21 5:18 AM, Chandan Babu R wrote:
> On 27 Jul 2021 at 11:50, Allison Henderson wrote:
>> During an attr rename operation, blocks are saved for later removal
>> as rmtblkno2. The rmtblkno is used in the case of needing to alloc
>> more blocks if not enough were available.  However, in the case
>> that neither rmtblkno or rmtblkno2 are set, we can return as soon
>> as xfs_attr_node_addname completes, rather than rolling the transaction
>> with an -EAGAIN return.  This extra loop does not hurt anything right
>> now, but it will be a problem later when we get into log items because
>> we end up with an empty log transaction.  So, add a simple check to
>> cut out the unneeded iteration.
>>
> 
> Looks good to me.
> 
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Thanks!
Allison

> 
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index d9d7d51..5040fc1 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -409,6 +409,13 @@ xfs_attr_set_iter(
>>   			if (error)
>>   				return error;
>>   
>> +			/*
>> +			 * If addname was successful, and we dont need to alloc
>> +			 * or remove anymore blks, we're done.
>> +			 */
>> +			if (!args->rmtblkno && !args->rmtblkno2)
>> +				return 0;
>> +
>>   			dac->dela_state = XFS_DAS_FOUND_NBLK;
>>   		}
>>   		return -EAGAIN;
> 
> 
