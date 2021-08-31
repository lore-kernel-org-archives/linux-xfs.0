Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2C16C432BE
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Aug 2021 18:11:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9D2460F6C
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Aug 2021 18:11:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbhHaSMa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Aug 2021 14:12:30 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:18460 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230200AbhHaSM3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Aug 2021 14:12:29 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17VFlnjf001701;
        Tue, 31 Aug 2021 18:11:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=WDDuDX8OLw33PThHE5gtfyLjB1d3pbpCPQ8Cr+HduaE=;
 b=zThDMi9sRv+MX04wU9sg2bSNxLR5Hp2LH1qze4LlSoVyrK3lYWBOUbDy423MUlLq0i0Q
 kqkENcUAUcjirx/hjmwc4nrJulTxg7XhfGAwkOvP351s5I1eLzxnTMe6z9f6DCPWYmqt
 hJKfmIUxD4oaTDQGKyEtXNH670inxcTebUiUxYvGejPEQTg4D0FKU0hrWIU57rBghd8H
 P81X7VQ8VU6hbRduD7MQnlrdlR3nfsxTV8/Y6wNYrWO8dBsn+AHO18Z2adFbfrLMmHPt
 tfcP0s9dNY2G5mw3GESvVu5Xf9VOtbdxqSMUy/JdZko01oHzKhZvkmvjgTliMFq8bxBW dA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=WDDuDX8OLw33PThHE5gtfyLjB1d3pbpCPQ8Cr+HduaE=;
 b=LD+IH7JlHjJau8I0yw3BzeiJRzYCYnWxwu4V6T4GBxoeNqlA45LDYywirLSnkEJw1A3P
 wF5cFQDblBoS2OoKsU3qTI1reNkj/OIRU3bZyDi5MQvvqinLOWdr/8jU15VOiBELAXDd
 imVvj/Vu557xCGLjee4VdOnMAZS3HLfIAD7Rga9XmYtvxFM2DCOt2xHNOIwQ7og2GXWb
 9i4MKkqDOoVew3HlszYndWg8ybhTelvcNcVkvz15QZ+eRws4KyLpTAVeA2/jqwadQdmD
 m6IhJxc0igw6h5/+f2eAf6wWtVmEJ345bpZSliXcygcNBP/diiN+m1jXonrdKz8WhF3n dQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aseedj0gt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Aug 2021 18:11:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17VI9rNL092532;
        Tue, 31 Aug 2021 18:11:32 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by userp3020.oracle.com with ESMTP id 3aqxwu0g5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Aug 2021 18:11:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I6sBh0tRby3XroGzgnVKCMcj9Tby1/Sv8U4wzNZociET5sDZhCJnsjziE058chC1j+DFQHC2J+4TXcVRgtr/S0IzHtODMKkT9a45iQ2X+Jq2ghsfy0pYayJgLHrhzFJWn35969YPFMuwwrdE0bZrJTUGIaHHULDkf8/M8P8+f76fh+L8y8ZLS5cUQuk2o1bvv4LQJJs5usnreIKE/B2pDgH8pIb2alGxcGXB4g2D9D3DHF3OpLeOo62x+B7QOMV7O9Rgeg1FxE772+BjQEw38trxUImWEIF2b43S/FmqKSQXgNINHQb1QptbriMliYt0pH3Uf4Gei+vIjfofLAlroQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WDDuDX8OLw33PThHE5gtfyLjB1d3pbpCPQ8Cr+HduaE=;
 b=EbfIKW8IMa2DQXekcfHzDiegPcsfIJi4g2W/tCWdXLyeX35LEerpZUZD4VbNKLzSBnv+YpHVPdZVmGOIayaBKyX0IbPV0eaglsZKLdbj+WaCvemhU0fZGgwK8kAvC1rohzOj6sZYTGTn9r6svNffuefrwZCz1TZZrYycJbSCIiTOrRPriwHsZK6UMwft82rbsLDG5kRJVEtshYz8GZogDR9Z9TIOJuf+Fgvc+ZejKH9VhCH5EwDV5N3x7R8GofXeESKkcOXtZkWvbkyGkKFFqbcshWdeP18XTe4z214Brh/oOo5CtM4IO74wxbOxndNGP86aQsHTTBOShImalNSqlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WDDuDX8OLw33PThHE5gtfyLjB1d3pbpCPQ8Cr+HduaE=;
 b=oX+shFUKeTMnoFzJp1RDWZ4YmE+Lig8Vf1jaJcFIzB9DDL4FVufBrPAcf+3D3N0JNb4kbESl9j2H8gNEY+U5GZy5ckuoWFOXT1zRqBzvr/1KN4WyYnxoQlNXtc2jeTqgcZVgjnbPDxUBHsyhJhJngGN7KmH5mPtfmO3dcrJd6Lw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3509.namprd10.prod.outlook.com (2603:10b6:a03:11f::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.24; Tue, 31 Aug
 2021 18:11:27 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f%9]) with mapi id 15.20.4478.019; Tue, 31 Aug 2021
 18:11:27 +0000
Subject: Re: [PATCH v24 04/11] xfs: Implement attr logging and replay
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210824224434.968720-1-allison.henderson@oracle.com>
 <20210824224434.968720-5-allison.henderson@oracle.com>
 <87h7f79xxk.fsf@debian-BULLSEYE-live-builder-AMD64>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <9daacd6a-915b-2d73-3cef-d609fb9da093@oracle.com>
Date:   Tue, 31 Aug 2021 11:11:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <87h7f79xxk.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0148.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::33) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from [192.168.1.167] (67.1.112.125) by SJ0PR13CA0148.namprd13.prod.outlook.com (2603:10b6:a03:2c6::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.9 via Frontend Transport; Tue, 31 Aug 2021 18:11:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 956993e8-7dd2-47fd-7cb3-08d96caabfc7
X-MS-TrafficTypeDiagnostic: BYAPR10MB3509:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3509C06DADDD191F954ACFC895CC9@BYAPR10MB3509.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:151;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U7/r0okG18Froo4Qeleki46PZopvAMwcLrS6n5bsxRMsJwAhQVfVh/buvvTSviOhiJ95cJUCK59V+62OR8XssGvj2Z4vZs5EfFWGwpwX3liVeD2aBLbu028wiVqePu2tYxir3+cNOZVQUORNymkik99kyiS05M3LD36W7QylWQY/7G++kVp/cfBOAsgOEZyetdrJXowyJ6XXQaXn7/XjYZlokeysLXwgSostganKquw6U42lGsg8+AZrdsCPtYkaZdtqjjVnTSHW22atj3Qib5YBs7EHm3kS62f7GFftrrdSC35aStWe+uadVSTQ8H6PIuCyw8DjIWlHX9omtVe8iDoY0janxp33TJaerBP6jtPFZWBYlNVLUPewSOBbJRvbWv9lIb4Hto/T0vTtyfL36W+E0QojXrk4JXMVG5UdEKaOk604OJ4NQMQLarpx2zwsJKJ2Lfrr3XaMh9r1az5lObRIW9hb28Shlnlvcg3qyD+BmH13TgiQzXYFczLjwqriirEFLraoR43b2As+h4QPSp5W4DdoTE0Z0v2wL5HhgMdf+IS9vXkALwRGihAM4g89CTT2VYXV7gP5K7V+5w/NNql8SXaL8q2lPKbyPcYcAm4jHpQS0Bp6z1+/eZJbFjTuwOIDxrzWSqjgcWAIoNUGboRekQyMvY6PYOwsL2Bfw5XNuV/DTsjqo/x4551bmvXeYHAk1AEgM8cCLHG5ZQV4wlViu9wjl8mo/96Uyl/Zw0ZM3H3HyrxpNKpzX09sKLRzYkM5hUVwekVFcvttS1eecA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(136003)(346002)(366004)(376002)(53546011)(2616005)(44832011)(66556008)(956004)(38100700002)(83380400001)(6486002)(6916009)(38350700002)(4326008)(478600001)(30864003)(5660300002)(52116002)(66476007)(8676002)(2906002)(8936002)(86362001)(31686004)(316002)(26005)(16576012)(186003)(66946007)(36756003)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dkVYSjR3QU1CL1NKdTgxOW11bkJFaVNhM0R1RlRZNDFUOXNFQXBSSWttUDBi?=
 =?utf-8?B?ZUlaVjd6SFd4YzJqR2VKVWNZU1RvalFXbWdjWTd5Ymdzc0VRaFZTdFNiNnZ5?=
 =?utf-8?B?SGh4VksrNDNzM1VibHNUMHpxVmgrZzVZTnJ6ekVxQ2ZYMUtJNVVkUVdiSDU1?=
 =?utf-8?B?eHdIcnAxcFRIQXQ1Mk1XMXRLbk9hRVMwVnI1QnBJYjF6cnl5dWZWdUhHTXNB?=
 =?utf-8?B?dG13VEQ1K0I3VFJINTl2b2xoYkFSYmVwYVp3dVhPbUFmVWg5ZmxmUUhsQlNE?=
 =?utf-8?B?SkxrOG5VUHNVcmhtSEVuSG16ZFpXQ3FGWXZWN0tKdHJVZW9VVUVjUnJQZEFq?=
 =?utf-8?B?bk5FMjBzdUcrZ0M2VVBLbldZbnF0ZkZUT0cvbnliS09hdHJTdEQ1WEdvNUhN?=
 =?utf-8?B?QWtqd1VvbVk4Zng3RWgvVjlqQzZ5SUVOUHdMb2x4dXhMSzNHTExTVmRoc3Ru?=
 =?utf-8?B?Nm1Ya3gwS0RNenU5SEJraXlLc1VXTmVMS1Rya3F5WkJVVi9YaTNwaEtJMFRO?=
 =?utf-8?B?Z05FcThGaEMwSy9LNG54bFI4cjVVbG00djM2VUJaS2FSY3NOS1pJL05xMHhX?=
 =?utf-8?B?MTM5RmZLSWJqdXJIOXQwVlh0UVNTMVQzVVVDSmFMNXQxVGRpRUZFVUdxREto?=
 =?utf-8?B?U0lqUDc4a1U3eExwS3NTcjExYmdUa1pUNzhFS2VKaHNzamliVUJMbGRwSDFk?=
 =?utf-8?B?RjNCNmxrMWZwdzRpbElDVDZEUzZWRkRoT3A2ZDhCdmdrazJYUW5yVnE0bzRN?=
 =?utf-8?B?bURQcnZOc0w5K3NtejRqdHN0aHpmYnRrU0cwdExBejAwV2hVMjVrV21lZWlB?=
 =?utf-8?B?elQxV2V2TEtpS3VVZVFCUWtDVkFDNjYvamF4TU54RVlOSHJyZWc2WWh0VnJN?=
 =?utf-8?B?eHVxMmhLK05BQ3N4S29GMy9SakRtL0pKSEp2UzVhSmI4ZE5WQmE5UWc1RW9q?=
 =?utf-8?B?REVUTjJzWFppcjdqR1R4eVZXd0haMC91RGQwQmlzekhFdUN2NDlpcFNEWjEx?=
 =?utf-8?B?Yk1Fd3NCM3Q0dG8xTGJuaHRMUFFVSVpKc05mdXE4ZUJ1Y0pzaENhbUFMc1Mw?=
 =?utf-8?B?UE91VGw2VEhnVlVDUGl3ZEhWSnhhQ1FFVjA0Q1J1a1lDWmo4TkNDdmw3cWRU?=
 =?utf-8?B?dVN3ZEVVdVM4M0ZlcFNXT3RmUWUxSU1NeG9ianM3Y2x2UDJoUlhsbHFrTFZw?=
 =?utf-8?B?NDh5T2tkME4rK2RtWDJIa0dlUmdqc2FPeUFJeHZwOS94Qy9NcDFXaHNIdTY3?=
 =?utf-8?B?Zll4T2M4SXd0UXp3a3dBY2hJaHA0aW5vcmtCVWJwTU9yVnlBdGh1Y1E1azlt?=
 =?utf-8?B?U0JWanB6S0cwNVQ4ZHdoY0wvQmZITVBlTEZlcmJsQlJZRGVrT2hISTVvdFBO?=
 =?utf-8?B?YUlNVGtycjh1QW02a2J2WnBneHE1UDBjUmZuRURMOTJOTnBuZnJqSkQzRmRy?=
 =?utf-8?B?RHhpQ0tUamxaQVBwUmZ0dHhRUlltQTBTL3l0dXBaMy9OMWJyVllZQ1UwQUJG?=
 =?utf-8?B?YXRkWEsybXJpNkNlRi9DQ09iY0dsYmlGMGJZbjlXTzVSQi9KbTR3UThrQi9F?=
 =?utf-8?B?K1FJYkNrbm1tRU92Y3hNMGU3ZDZZcW11MS9vOGhQNXEzZ3d0NmFiRURpYklZ?=
 =?utf-8?B?MmwyQ0dHeDN1alUxUU85RmxFc3B0ZWJlQkQ0THZvVmZVWnk4OWcwL3k5QmZC?=
 =?utf-8?B?czM4dEpOc0JTa1BxbTQ3aUZuS0JDbEFEMVFzWnVpek9RYkRIWmxHS0tXcHhR?=
 =?utf-8?Q?GUKQTRd8TH1/ZCZN80yDttDuvyOAL6ieCThWTqK?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 956993e8-7dd2-47fd-7cb3-08d96caabfc7
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2021 18:11:26.9747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Rvqe0+7aRCxVZsW7hJ/V5U6T1G7O3sCt9Z8Ku5Aa297456QTwoXjgWMP74Ao4Ok/IsnePSbaUBeCoukbYWqSjvkc+cnUvAoxLwYU1DTysE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3509
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10093 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108310101
X-Proofpoint-ORIG-GUID: D0UVBYfeUW9YiWKu3YE7_t5tFoFpsFtp
X-Proofpoint-GUID: D0UVBYfeUW9YiWKu3YE7_t5tFoFpsFtp
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 8/30/21 12:47 AM, Chandan Babu R wrote:
> On 25 Aug 2021 at 04:14, Allison Henderson wrote:
>> This patch adds the needed routines to create, log and recover logged
>> extended attribute intents.
>>
> 
> Apart from the two nits mentioned below, the remaining changes seem to
> correctly handle attr set/remove operations regardless of whether delayed
> logging is enabled or not.
> 
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Ok, thank you!

> 
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_defer.c  |   1 +
>>   fs/xfs/libxfs/xfs_defer.h  |   1 +
>>   fs/xfs/libxfs/xfs_format.h |  10 +-
>>   fs/xfs/xfs_attr_item.c     | 358 +++++++++++++++++++++++++++++++++++++
>>   4 files changed, 369 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
>> index d1d09b6aca55..01fcf5e93be5 100644
>> --- a/fs/xfs/libxfs/xfs_defer.c
>> +++ b/fs/xfs/libxfs/xfs_defer.c
>> @@ -178,6 +178,7 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
>>   	[XFS_DEFER_OPS_TYPE_RMAP]	= &xfs_rmap_update_defer_type,
>>   	[XFS_DEFER_OPS_TYPE_FREE]	= &xfs_extent_free_defer_type,
>>   	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
>> +	[XFS_DEFER_OPS_TYPE_ATTR]	= &xfs_attr_defer_type,
>>   };
>>   
>>   static void
>> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
>> index 89719146c5eb..d70525c57b5c 100644
>> --- a/fs/xfs/libxfs/xfs_defer.h
>> +++ b/fs/xfs/libxfs/xfs_defer.h
>> @@ -19,6 +19,7 @@ enum xfs_defer_ops_type {
>>   	XFS_DEFER_OPS_TYPE_RMAP,
>>   	XFS_DEFER_OPS_TYPE_FREE,
>>   	XFS_DEFER_OPS_TYPE_AGFL_FREE,
>> +	XFS_DEFER_OPS_TYPE_ATTR,
>>   	XFS_DEFER_OPS_TYPE_MAX,
>>   };
>>   
>> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
>> index 2d7057b7984b..2e0937bbff6d 100644
>> --- a/fs/xfs/libxfs/xfs_format.h
>> +++ b/fs/xfs/libxfs/xfs_format.h
>> @@ -388,7 +388,9 @@ xfs_sb_has_incompat_feature(
>>   	return (sbp->sb_features_incompat & feature) != 0;
>>   }
>>   
>> -#define XFS_SB_FEAT_INCOMPAT_LOG_ALL 0
>> +#define XFS_SB_FEAT_INCOMPAT_LOG_XATTRS   (1 << 0)	/* Delayed Attributes */
>> +#define XFS_SB_FEAT_INCOMPAT_LOG_ALL \
>> +	(XFS_SB_FEAT_INCOMPAT_LOG_XATTRS)
>>   #define XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_LOG_ALL
>>   static inline bool
>>   xfs_sb_has_incompat_log_feature(
>> @@ -413,6 +415,12 @@ xfs_sb_add_incompat_log_features(
>>   	sbp->sb_features_log_incompat |= features;
>>   }
>>
> 
> To be consistent with the existing convention, may be the function below
> should be renamed as xfs_sb_version_haslogxattrs()?
Sure, will add xfs_ prefix

> 
>> +static inline bool sb_version_haslogxattrs(struct xfs_sb *sbp)
>> +{
>> +	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
> 
> The above comparison can be replaced with a call to xfs_sb_is_v5().
Ok, will update. Thanks!
Allison

> 
>> +		(sbp->sb_features_log_incompat &
>> +		 XFS_SB_FEAT_INCOMPAT_LOG_XATTRS);
>> +}
>>   
>>   static inline bool
>>   xfs_is_quota_inode(struct xfs_sb *sbp, xfs_ino_t ino)
>> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
>> index 879a39ec58a6..c6d5ed34b424 100644
>> --- a/fs/xfs/xfs_attr_item.c
>> +++ b/fs/xfs/xfs_attr_item.c
>> @@ -275,6 +275,163 @@ xfs_attrd_item_release(
>>   	xfs_attrd_item_free(attrdp);
>>   }
>>   
>> +/*
>> + * Performs one step of an attribute update intent and marks the attrd item
>> + * dirty..  An attr operation may be a set or a remove.  Note that the
>> + * transaction is marked dirty regardless of whether the operation succeeds or
>> + * fails to support the ATTRI/ATTRD lifecycle rules.
>> + */
>> +STATIC int
>> +xfs_trans_attr_finish_update(
>> +	struct xfs_delattr_context	*dac,
>> +	struct xfs_attrd_log_item	*attrdp,
>> +	struct xfs_buf			**leaf_bp,
>> +	uint32_t			op_flags)
>> +{
>> +	struct xfs_da_args		*args = dac->da_args;
>> +	unsigned int			op = op_flags &
>> +					     XFS_ATTR_OP_FLAGS_TYPE_MASK;
>> +	int				error;
>> +
>> +	switch (op) {
>> +	case XFS_ATTR_OP_FLAGS_SET:
>> +		error = xfs_attr_set_iter(dac, leaf_bp);
>> +		break;
>> +	case XFS_ATTR_OP_FLAGS_REMOVE:
>> +		ASSERT(XFS_IFORK_Q(args->dp));
>> +		error = xfs_attr_remove_iter(dac);
>> +		break;
>> +	default:
>> +		error = -EFSCORRUPTED;
>> +		break;
>> +	}
>> +
>> +	/*
>> +	 * Mark the transaction dirty, even on error. This ensures the
>> +	 * transaction is aborted, which:
>> +	 *
>> +	 * 1.) releases the ATTRI and frees the ATTRD
>> +	 * 2.) shuts down the filesystem
>> +	 */
>> +	args->trans->t_flags |= XFS_TRANS_DIRTY;
>> +
>> +	/*
>> +	 * attr intent/done items are null when delayed attributes are disabled
>> +	 */
>> +	if (attrdp)
>> +		set_bit(XFS_LI_DIRTY, &attrdp->attrd_item.li_flags);
>> +
>> +	return error;
>> +}
>> +
>> +/* Log an attr to the intent item. */
>> +STATIC void
>> +xfs_attr_log_item(
>> +	struct xfs_trans		*tp,
>> +	struct xfs_attri_log_item	*attrip,
>> +	struct xfs_attr_item		*attr)
>> +{
>> +	struct xfs_attri_log_format	*attrp;
>> +
>> +	tp->t_flags |= XFS_TRANS_DIRTY;
>> +	set_bit(XFS_LI_DIRTY, &attrip->attri_item.li_flags);
>> +
>> +	/*
>> +	 * At this point the xfs_attr_item has been constructed, and we've
>> +	 * created the log intent. Fill in the attri log item and log format
>> +	 * structure with fields from this xfs_attr_item
>> +	 */
>> +	attrp = &attrip->attri_format;
>> +	attrp->alfi_ino = attr->xattri_dac.da_args->dp->i_ino;
>> +	attrp->alfi_op_flags = attr->xattri_op_flags;
>> +	attrp->alfi_value_len = attr->xattri_dac.da_args->valuelen;
>> +	attrp->alfi_name_len = attr->xattri_dac.da_args->namelen;
>> +	attrp->alfi_attr_flags = attr->xattri_dac.da_args->attr_filter;
>> +
>> +	attrip->attri_name = (void *)attr->xattri_dac.da_args->name;
>> +	attrip->attri_value = attr->xattri_dac.da_args->value;
>> +	attrip->attri_name_len = attr->xattri_dac.da_args->namelen;
>> +	attrip->attri_value_len = attr->xattri_dac.da_args->valuelen;
>> +}
>> +
>> +/* Get an ATTRI. */
>> +static struct xfs_log_item *
>> +xfs_attr_create_intent(
>> +	struct xfs_trans		*tp,
>> +	struct list_head		*items,
>> +	unsigned int			count,
>> +	bool				sort)
>> +{
>> +	struct xfs_mount		*mp = tp->t_mountp;
>> +	struct xfs_attri_log_item	*attrip;
>> +	struct xfs_attr_item		*attr;
>> +
>> +	ASSERT(count == 1);
>> +
>> +	if (!sb_version_haslogxattrs(&mp->m_sb))
>> +		return NULL;
>> +
>> +	attrip = xfs_attri_init(mp, 0);
>> +	if (attrip == NULL)
>> +		return NULL;
>> +
>> +	xfs_trans_add_item(tp, &attrip->attri_item);
>> +	list_for_each_entry(attr, items, xattri_list)
>> +		xfs_attr_log_item(tp, attrip, attr);
>> +	return &attrip->attri_item;
>> +}
>> +
>> +/* Process an attr. */
>> +STATIC int
>> +xfs_attr_finish_item(
>> +	struct xfs_trans		*tp,
>> +	struct xfs_log_item		*done,
>> +	struct list_head		*item,
>> +	struct xfs_btree_cur		**state)
>> +{
>> +	struct xfs_attr_item		*attr;
>> +	struct xfs_attrd_log_item	*done_item = NULL;
>> +	int				error;
>> +	struct xfs_delattr_context	*dac;
>> +
>> +	attr = container_of(item, struct xfs_attr_item, xattri_list);
>> +	dac = &attr->xattri_dac;
>> +	if (done)
>> +		done_item = ATTRD_ITEM(done);
>> +
>> +	/*
>> +	 * Always reset trans after EAGAIN cycle
>> +	 * since the transaction is new
>> +	 */
>> +	dac->da_args->trans = tp;
>> +
>> +	error = xfs_trans_attr_finish_update(dac, done_item, &dac->leaf_bp,
>> +					     attr->xattri_op_flags);
>> +	if (error != -EAGAIN)
>> +		kmem_free(attr);
>> +
>> +	return error;
>> +}
>> +
>> +/* Abort all pending ATTRs. */
>> +STATIC void
>> +xfs_attr_abort_intent(
>> +	struct xfs_log_item		*intent)
>> +{
>> +	xfs_attri_release(ATTRI_ITEM(intent));
>> +}
>> +
>> +/* Cancel an attr */
>> +STATIC void
>> +xfs_attr_cancel_item(
>> +	struct list_head		*item)
>> +{
>> +	struct xfs_attr_item		*attr;
>> +
>> +	attr = container_of(item, struct xfs_attr_item, xattri_list);
>> +	kmem_free(attr);
>> +}
>> +
>>   STATIC xfs_lsn_t
>>   xfs_attri_item_committed(
>>   	struct xfs_log_item		*lip,
>> @@ -306,6 +463,30 @@ xfs_attri_item_match(
>>   	return ATTRI_ITEM(lip)->attri_format.alfi_id == intent_id;
>>   }
>>   
>> +/*
>> + * This routine is called to allocate an "attr free done" log item.
>> + */
>> +static struct xfs_attrd_log_item *
>> +xfs_trans_get_attrd(struct xfs_trans		*tp,
>> +		  struct xfs_attri_log_item	*attrip)
>> +{
>> +	struct xfs_attrd_log_item		*attrdp;
>> +	uint					size;
>> +
>> +	ASSERT(tp != NULL);
>> +
>> +	size = sizeof(struct xfs_attrd_log_item);
>> +	attrdp = kmem_zalloc(size, 0);
>> +
>> +	xfs_log_item_init(tp->t_mountp, &attrdp->attrd_item, XFS_LI_ATTRD,
>> +			  &xfs_attrd_item_ops);
>> +	attrdp->attrd_attrip = attrip;
>> +	attrdp->attrd_format.alfd_alf_id = attrip->attri_format.alfi_id;
>> +
>> +	xfs_trans_add_item(tp, &attrdp->attrd_item);
>> +	return attrdp;
>> +}
>> +
>>   static const struct xfs_item_ops xfs_attrd_item_ops = {
>>   	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
>>   	.iop_size	= xfs_attrd_item_size,
>> @@ -313,6 +494,29 @@ static const struct xfs_item_ops xfs_attrd_item_ops = {
>>   	.iop_release    = xfs_attrd_item_release,
>>   };
>>   
>> +
>> +/* Get an ATTRD so we can process all the attrs. */
>> +static struct xfs_log_item *
>> +xfs_attr_create_done(
>> +	struct xfs_trans		*tp,
>> +	struct xfs_log_item		*intent,
>> +	unsigned int			count)
>> +{
>> +	if (!intent)
>> +		return NULL;
>> +
>> +	return &xfs_trans_get_attrd(tp, ATTRI_ITEM(intent))->attrd_item;
>> +}
>> +
>> +const struct xfs_defer_op_type xfs_attr_defer_type = {
>> +	.max_items	= 1,
>> +	.create_intent	= xfs_attr_create_intent,
>> +	.abort_intent	= xfs_attr_abort_intent,
>> +	.create_done	= xfs_attr_create_done,
>> +	.finish_item	= xfs_attr_finish_item,
>> +	.cancel_item	= xfs_attr_cancel_item,
>> +};
>> +
>>   /* Is this recovered ATTRI ok? */
>>   static inline bool
>>   xfs_attri_validate(
>> @@ -337,13 +541,167 @@ xfs_attri_validate(
>>   	return xfs_verify_ino(mp, attrp->alfi_ino);
>>   }
>>   
>> +/*
>> + * Process an attr intent item that was recovered from the log.  We need to
>> + * delete the attr that it describes.
>> + */
>> +STATIC int
>> +xfs_attri_item_recover(
>> +	struct xfs_log_item		*lip,
>> +	struct list_head		*capture_list)
>> +{
>> +	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
>> +	struct xfs_attr_item		*attr;
>> +	struct xfs_mount		*mp = lip->li_mountp;
>> +	struct xfs_inode		*ip;
>> +	struct xfs_da_args		*args;
>> +	struct xfs_trans		*tp;
>> +	struct xfs_trans_res		tres;
>> +	struct xfs_attri_log_format	*attrp;
>> +	int				error, ret = 0;
>> +	int				total;
>> +	int				local;
>> +	struct xfs_attrd_log_item	*done_item = NULL;
>> +
>> +	/*
>> +	 * First check the validity of the attr described by the ATTRI.  If any
>> +	 * are bad, then assume that all are bad and just toss the ATTRI.
>> +	 */
>> +	attrp = &attrip->attri_format;
>> +	if (!xfs_attri_validate(mp, attrip))
>> +		return -EFSCORRUPTED;
>> +
>> +	error = xlog_recover_iget(mp,  attrp->alfi_ino, &ip);
>> +	if (error)
>> +		return error;
>> +
>> +	attr = kmem_zalloc(sizeof(struct xfs_attr_item) +
>> +			   sizeof(struct xfs_da_args), KM_NOFS);
>> +	args = (struct xfs_da_args *)(attr + 1);
>> +
>> +	attr->xattri_dac.da_args = args;
>> +	attr->xattri_op_flags = attrp->alfi_op_flags;
>> +
>> +	args->dp = ip;
>> +	args->geo = mp->m_attr_geo;
>> +	args->op_flags = attrp->alfi_op_flags;
>> +	args->whichfork = XFS_ATTR_FORK;
>> +	args->name = attrip->attri_name;
>> +	args->namelen = attrp->alfi_name_len;
>> +	args->hashval = xfs_da_hashname(args->name, args->namelen);
>> +	args->attr_filter = attrp->alfi_attr_flags;
>> +
>> +	if (attrp->alfi_op_flags == XFS_ATTR_OP_FLAGS_SET) {
>> +		args->value = attrip->attri_value;
>> +		args->valuelen = attrp->alfi_value_len;
>> +		args->total = xfs_attr_calc_size(args, &local);
>> +
>> +		tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
>> +				 M_RES(mp)->tr_attrsetrt.tr_logres *
>> +					args->total;
>> +		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
>> +		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
>> +		total = args->total;
>> +	} else {
>> +		tres = M_RES(mp)->tr_attrrm;
>> +		total = XFS_ATTRRM_SPACE_RES(mp);
>> +	}
>> +	error = xfs_trans_alloc(mp, &tres, total, 0, XFS_TRANS_RESERVE, &tp);
>> +	if (error)
>> +		goto out;
>> +
>> +	args->trans = tp;
>> +	done_item = xfs_trans_get_attrd(tp, attrip);
>> +
>> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
>> +	xfs_trans_ijoin(tp, ip, 0);
>> +
>> +	ret = xfs_trans_attr_finish_update(&attr->xattri_dac, done_item,
>> +					   &attr->xattri_dac.leaf_bp,
>> +					   attrp->alfi_op_flags);
>> +	if (ret == -EAGAIN) {
>> +		/* There's more work to do, so add it to this transaction */
>> +		xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &attr->xattri_list);
>> +	} else
>> +		error = ret;
>> +
>> +	if (error) {
>> +		xfs_trans_cancel(tp);
>> +		goto out_unlock;
>> +	}
>> +
>> +	error = xfs_defer_ops_capture_and_commit(tp, ip, capture_list,
>> +						 attr->xattri_dac.leaf_bp);
>> +
>> +out_unlock:
>> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>> +	xfs_irele(ip);
>> +out:
>> +	if (ret != -EAGAIN)
>> +		kmem_free(attr);
>> +	return error;
>> +}
>> +
>> +/* Re-log an intent item to push the log tail forward. */
>> +static struct xfs_log_item *
>> +xfs_attri_item_relog(
>> +	struct xfs_log_item		*intent,
>> +	struct xfs_trans		*tp)
>> +{
>> +	struct xfs_attrd_log_item	*attrdp;
>> +	struct xfs_attri_log_item	*old_attrip;
>> +	struct xfs_attri_log_item	*new_attrip;
>> +	struct xfs_attri_log_format	*new_attrp;
>> +	struct xfs_attri_log_format	*old_attrp;
>> +	int				buffer_size;
>> +
>> +	old_attrip = ATTRI_ITEM(intent);
>> +	old_attrp = &old_attrip->attri_format;
>> +	buffer_size = old_attrp->alfi_value_len + old_attrp->alfi_name_len;
>> +
>> +	tp->t_flags |= XFS_TRANS_DIRTY;
>> +	attrdp = xfs_trans_get_attrd(tp, old_attrip);
>> +	set_bit(XFS_LI_DIRTY, &attrdp->attrd_item.li_flags);
>> +
>> +	new_attrip = xfs_attri_init(tp->t_mountp, buffer_size);
>> +	new_attrp = &new_attrip->attri_format;
>> +
>> +	new_attrp->alfi_ino = old_attrp->alfi_ino;
>> +	new_attrp->alfi_op_flags = old_attrp->alfi_op_flags;
>> +	new_attrp->alfi_value_len = old_attrp->alfi_value_len;
>> +	new_attrp->alfi_name_len = old_attrp->alfi_name_len;
>> +	new_attrp->alfi_attr_flags = old_attrp->alfi_attr_flags;
>> +
>> +	new_attrip->attri_name_len = old_attrip->attri_name_len;
>> +	new_attrip->attri_name = ((char *)new_attrip) +
>> +				 sizeof(struct xfs_attri_log_item);
>> +	memcpy(new_attrip->attri_name, old_attrip->attri_name,
>> +		new_attrip->attri_name_len);
>> +
>> +	new_attrip->attri_value_len = old_attrip->attri_value_len;
>> +	if (new_attrip->attri_value_len > 0) {
>> +		new_attrip->attri_value = new_attrip->attri_name +
>> +					  new_attrip->attri_name_len;
>> +
>> +		memcpy(new_attrip->attri_value, old_attrip->attri_value,
>> +		       new_attrip->attri_value_len);
>> +	}
>> +
>> +	xfs_trans_add_item(tp, &new_attrip->attri_item);
>> +	set_bit(XFS_LI_DIRTY, &new_attrip->attri_item.li_flags);
>> +
>> +	return &new_attrip->attri_item;
>> +}
>> +
>>   static const struct xfs_item_ops xfs_attri_item_ops = {
>>   	.iop_size	= xfs_attri_item_size,
>>   	.iop_format	= xfs_attri_item_format,
>>   	.iop_unpin	= xfs_attri_item_unpin,
>>   	.iop_committed	= xfs_attri_item_committed,
>>   	.iop_release    = xfs_attri_item_release,
>> +	.iop_recover	= xfs_attri_item_recover,
>>   	.iop_match	= xfs_attri_item_match,
>> +	.iop_relog	= xfs_attri_item_relog,
>>   };
> 
> 
