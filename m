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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C066C432BE
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Aug 2021 18:12:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FD9660F12
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Aug 2021 18:12:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234077AbhHaSNt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Aug 2021 14:13:49 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:46858 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230200AbhHaSNs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Aug 2021 14:13:48 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17VFgUNI004082;
        Tue, 31 Aug 2021 18:12:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=WKtb0iuXfTQ3RzYg4zvkk3jqBAglbwH3wQ+4aIgBVWw=;
 b=GOTHM0MRKLoZ1kwdQG26E1H8M9uPB3Vy7LSaePyo9xBOsI+uwRzvfrh8WYGcdnvFka/L
 NidVHlToBqEto6NRDZp6pUv2YwemkFNt3FM3iH+CqwyXZgI7Sj7N4dymGmx1xOgqe2FN
 3+nKowaQwcVvgN3GAhwcPOCi6o+mWDYrSW7sLvrP2xwzWa2jPHbZ+bIheSUZ8j4WrQl4
 kR50QOsX+WxbQexlmA0pVKFI/XofmSlPeChLAR1uV9xUiO2X4paTFV4/AN9A9UhIuc1Y
 4kU4RvB7oo7iTs5lWRnqUvu/UEy2Qxtnfyltj0UcaLAaZUsNU82mIveARHO43C9bvuRQ bw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=WKtb0iuXfTQ3RzYg4zvkk3jqBAglbwH3wQ+4aIgBVWw=;
 b=s2Z4M6QYfQ3niRcfW75OU8P+0zqlEym4wOxpkn+aFjzJFBdTN+l6tKJy/HovKWNccNM8
 bb5mHczSd/CLNOtbtKb5B9crVKpNq6ul5fNVLR1sTND7F0yyWgJqggTIHhbdJ0qzzJLK
 Hj0hUh+Kp9YA3LDAUrVR1g+7a4xVXVLDXN4crGfW493jCKCDC9R2RtoP8VAEmzpHXEQd
 DkXNgehJV6pXPDcf2q4DqfCvndi2gwF6Gy0WRB0TW1OCV4aEGTeuHOb8XhkDMUfspq67
 dP61p+sCinLS8q1WRGXXbuTnS5KLhwWWWSnLCMkrNbp6w666m8dO6xA/CbxveSQNatNE 3g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3asf66hw45-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Aug 2021 18:12:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17VI9nuP146489;
        Tue, 31 Aug 2021 18:12:50 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by aserp3030.oracle.com with ESMTP id 3aqb6eax9f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Aug 2021 18:12:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AK6ALfBrWFnEjkBQswKARwZUXXoytIVJB/TAIqzKW5TOLff+KgFWoaQ5ZJ79MRJW9sXHpEeWuqgYR1J8zFIgMV+9eMovdEVbt7b4IBigq3ikCCMWnN1Q1YgsIwWuf6OPyILUr9GcgZ3+TR68joTQjRPt2eaOLFk5U833KmkVegJudRsD81K+1weQwwVSRrnp3km22Zz1dLne8h0c+WGcTqCYsClgdOk07WJL/SRX3ao3pXOuDjEUcYz55igHTwtNWo5l2RAaRbERUf8SmCZK8DYUM/5C1pNTuty/RDHfcHYBIn5iwTUyzMOfp+c/ZA1Iw/GZxu2jJIcVDngf7sfBbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WKtb0iuXfTQ3RzYg4zvkk3jqBAglbwH3wQ+4aIgBVWw=;
 b=eVpb/DxWwQmE4HEqidSIxpRblqrCqoge5q15dGCPhTJkGKId0gheyQ6HJMEL9azJAoZv1WrGU8yRIdYPss83xTbklXArMkZObUfkh3AEXMB4lQWvN7H8GuwidEP2qyirS0weI9zFXQC6JJTAV0JbfHQJjF1ajRzoYeFhQs3WZX7vzM9ZDHzQsKtip7h6gNa5aVYzf6ZLpIh4kZk79Bm2rGUyZ6JACQT6en+kVFyCBHFVuyEdW++C1Nopuf12Qibrydfho1D20amBlGfHe4MRqqm2RW+9s/nbUUv/uRjXjS5SiU1ANxP3r1ySsbuj7rU0jjQM3qJQuxLWfSkMPF2Ppw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WKtb0iuXfTQ3RzYg4zvkk3jqBAglbwH3wQ+4aIgBVWw=;
 b=xsMV7pV/cDSmwyeQdgrK91+Xo7vSTeLoy/Ky7ZxF/KhoTAMe/6Box0ARoJklz96zPqWWEfDcnRQS92MaTizzOCD4xD7fd8waTXKc/Qw750HVLvdpL9xbjRGvnjq9G0dkO8t9qkuK4Rmo0wwPHX5j8a5BlVWBRNDP9pHQnwzTf6w=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4386.namprd10.prod.outlook.com (2603:10b6:a03:20d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.24; Tue, 31 Aug
 2021 18:12:48 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f%9]) with mapi id 15.20.4478.019; Tue, 31 Aug 2021
 18:12:48 +0000
Subject: Re: [PATCH v24 09/11] xfs: Add larp debug option
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210824224434.968720-1-allison.henderson@oracle.com>
 <20210824224434.968720-10-allison.henderson@oracle.com>
 <875yvn9m1g.fsf@debian-BULLSEYE-live-builder-AMD64>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <ed95e826-9367-c1e2-a6f9-190838c43e4a@oracle.com>
Date:   Tue, 31 Aug 2021 11:12:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <875yvn9m1g.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0131.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::16) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from [192.168.1.167] (67.1.112.125) by SJ0PR13CA0131.namprd13.prod.outlook.com (2603:10b6:a03:2c6::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.11 via Frontend Transport; Tue, 31 Aug 2021 18:12:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4fc586b2-2259-490f-4ff6-08d96caaf0a8
X-MS-TrafficTypeDiagnostic: BY5PR10MB4386:
X-Microsoft-Antispam-PRVS: <BY5PR10MB438697F7488DEE39C1AA9FD495CC9@BY5PR10MB4386.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:483;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: POhRS0b+BvXFcpOiXTL75pLDfyHreWs7BkjATgAd1FM39KZRrfCZL5pbdnsNRdA1mFvhgh9JlCE2kwAuNzzILZ0j3wWxIG/yLqBVk7gf6FptvBi17FcbFdehFc+wm1C4TzS2eVLRM1W5NwnmDtviJjG7g0gd2TwZQ1FqkZvaOcC9DsE/Eo+wYfD14jgJvEQK9C/NFcyouWLFo/NL3rf2jJ5UPAkIwGHvqSYHBbeBozBsXsjNhrICqKe4x8wMjNYAhCLDqFiiyPNibA6SWpny4gk7tyj4zw/R9ZWQ6Y9hEf/gNnlW9quePIdLwFT/ih8rzd9VWkOhs9M3FaxmEZLaN7IqEgU0Jl9Egmaq4nilUvA/YUtpnL3kv2E0oXlci/NUTFcKEJaQ6+67Kb949fHjeI7+kspzNSI9o8Ke+/ZxTUIUOndpszX6elTVCxUY9AsjdW9RX3qxmeSUsH3NDCtvSwQqPl2vtErsgyiB2ebSOvDPm+Tjzv6EUYz8BWaIx//MsvBXOIikiW7e8Xqs0Xz8aNw9rk4GNGLlF1y5Xyue11uPXzZBcToJEz3DcEZbakAfW1deu0FjQr7uDyoaUvBYJlAqYPPp15q7uZnsT1AlyiAzB1F4tvt+1YYNvHtWtP/NbpNy8l1atkZNCJMWniUyAEY3iXOoQvZ26UyFOo5Mm68TSp8RerCgTLlYimzsYgEp0aLipqe4HuTyuf+HuvIGrc+vnZM5uAIavJ+p/+WvI3KPLwCwyB2pbp0ZcKGjgRdljiA8ZyDqseHm5AFaxxYd3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(396003)(346002)(39860400002)(376002)(38350700002)(956004)(38100700002)(4326008)(2616005)(31686004)(478600001)(5660300002)(2906002)(53546011)(26005)(186003)(66946007)(8676002)(31696002)(52116002)(316002)(44832011)(6486002)(66556008)(83380400001)(66476007)(8936002)(86362001)(6916009)(16576012)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OE5tUU5RNXdhbThrVHA5WGJXV09meVN4L2dMMndIQ0tIemtQSzkzbTU3QzIx?=
 =?utf-8?B?alVJMTY4QmZIWmJFYVFPRWtnQklwaHRhUVRQV1FKc042NXlYT0ZXMzI4ZHo4?=
 =?utf-8?B?d1Bmd0ZYcUxTUUlzZmV2cFFRV25XRGVVS2FaaU9qbG9tK0lWei9kb3JqZTdO?=
 =?utf-8?B?aGkzSHJEbmFJM2FyODJUNUt2WUVqVG96MGtHME1nZ1N4cUlhaTIvNHhibFNt?=
 =?utf-8?B?L3g0dDF3cUJ5QjlLMGg2cFA5VjB6V2drUXNYckxndW9CZ2p3QklVd3FIaDZF?=
 =?utf-8?B?RUJRNHB3ckFsZnN6MkNxdksveEdxelNXN3R1dUtFNWtHazBDVHp3dFI5aGdi?=
 =?utf-8?B?cXVHeXB4MkE4aWk0ZEVNNkV1dEhUMXNCNkY3QzU3ajNKUTU3QkZSZFMvcjE4?=
 =?utf-8?B?UUhSZzc2SlFmRHVkb2IzMGFjVUdyZUY2VzdBREhoVFAwL1JqdHl4SmV3T2gv?=
 =?utf-8?B?S3hDRjBiZ0p6NUZqMmd6NEJzTFBQRXZpOE9IUkU0bndXQzc5dXJTemtVNURE?=
 =?utf-8?B?UWZqUnpuZlBONVRFdHhPaEFmNFZmQkp3Q0dKdFpZYSsxcTZxTmV6dEo2THFM?=
 =?utf-8?B?aGh4L0UzNTlpNFRBdjJXVm1hajNpZjBxVnRKd2xxRFV6bmhKOXkyYUJlcHNv?=
 =?utf-8?B?cVZ0MnJibWNYVU51eTFqRnM0WmE4NllxdisyNCtPOUJGOWpvdnF3MGN2MXFZ?=
 =?utf-8?B?dlFWci81R2dQYmorb2paYUxQVndSQ0gweVZyQUNqYkhLRmNtOGh6bFJvQThy?=
 =?utf-8?B?T0trV2hJczFMWXk3S215RUlTU0RKU2x6NERWRVc5dXVDZ2NYM2JVbjQ2RlM0?=
 =?utf-8?B?Ylh5K01pbVh3aW9SVXpnM0hMRjhKalJKZHkzRmsydDEyUlpRMldLc3pQbGZu?=
 =?utf-8?B?RWNSSktYMlgwWE9OUzhvbGY3OVkxQlFndFIzTFlIMCs0SmJMM3pRVGsrZGJR?=
 =?utf-8?B?dFdzZUZ5YWRBMFlkNUk2UDd5UnNLOEdEVlowbXl3Ui8vc1lHdER2Y2VXNnhC?=
 =?utf-8?B?eDAwMDd3WWdtaW8zMHdnbWxLc3Nib28zcDVUQlRyZytYMUEya1pHaUxyN25V?=
 =?utf-8?B?WWJLVmJUdVRzZDcyN1VNbHBGS0lPTGNPUzI4RUpHaE9DdWQ4N1N4U1lTZ2Ja?=
 =?utf-8?B?eFB4bUQyeVM3THpURTdHMFhqcmg2NGMyQnIzRzhHdGpkMXI4WEpWMDNWaVRB?=
 =?utf-8?B?Q3JqVm1FUEZkT2J3WGJMVjloYlN5VEt0OTVVY0o3SzB4VUhiMG9TWFE0MkFC?=
 =?utf-8?B?UHRjaVRyNjg2c2RJN29QVVFyWU85aTlaTFV0VnlrNHZuWC9qLzJEcU42Zkt1?=
 =?utf-8?B?U0p5MWdDdkVYZTZzbDhUWDY1M0k1Ym41bmY3STVnbWwvWU4rdGZibjZaM2Zy?=
 =?utf-8?B?N2JyQjRxSXdVWHMzdkpkMURqUTA1b0xaNS9SZE5KK09wcXp0a3pPVGVUcE42?=
 =?utf-8?B?YWtxUWFsY3IwMHJBbXRvVWlEcllFS1BZbDlPMk56MTlrNWk3Vmo1dzgzOXZ0?=
 =?utf-8?B?OC9MUm9iRkFpU2xlMkJMTE9MUG9uQmhIZktHSTJEektpVy9YanZNMTB0U2xM?=
 =?utf-8?B?d2xiODVKdzZmQUZQYkhDK1VwYklUMkRGNEtVaWJpa0s1RjBaYXZTUlBGUXhX?=
 =?utf-8?B?bXg0d1FCT29zNWRCcUdPV2VDSEdDaHE2V2lYdng0SGJNYnJ3ZTZZSVFaeVFi?=
 =?utf-8?B?Vm5mU0JncXhJMFIxUnlmTzR3RGVnWWFtcUVyQkMwdTFYMlJiSDF1QzVEQXhq?=
 =?utf-8?Q?AMSAcB36m3QApGTpV5pD8eUMzLKx+YVTlkMDiSN?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fc586b2-2259-490f-4ff6-08d96caaf0a8
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2021 18:12:48.8882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xzOc8swK6grJfu2TKHF1LsJce6qMQuOBIrOAjYRh+Eh2MLiYVx3G9MzPVQE1zuzalVB102IBfnVIibCia0QJagWHncITyUAPh7MOmpEHPRo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4386
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10093 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108310101
X-Proofpoint-GUID: -0JE7GRvbn1byh0H32LuOqv234qLvwsd
X-Proofpoint-ORIG-GUID: -0JE7GRvbn1byh0H32LuOqv234qLvwsd
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 8/30/21 5:03 AM, Chandan Babu R wrote:
> On 25 Aug 2021 at 04:14, Allison Henderson wrote:
>> This patch adds a mount option to enable log attribute replay. Eventually
> 
> s/mount option/debug option//
Ok, will fix.

> 
>> this can be removed when delayed attrs becomes permanent.
> 
> The rest looks good to me.
> 
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Thanks!
Allison

> 
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.h |  2 +-
>>   fs/xfs/xfs_globals.c     |  1 +
>>   fs/xfs/xfs_sysctl.h      |  1 +
>>   fs/xfs/xfs_sysfs.c       | 24 ++++++++++++++++++++++++
>>   4 files changed, 27 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>> index efb7ac4fc41c..492762541174 100644
>> --- a/fs/xfs/libxfs/xfs_attr.h
>> +++ b/fs/xfs/libxfs/xfs_attr.h
>> @@ -30,7 +30,7 @@ struct xfs_attr_list_context;
>>   
>>   static inline bool xfs_has_larp(struct xfs_mount *mp)
>>   {
>> -	return false;
>> +	return xfs_globals.larp;
>>   }
>>   
>>   /*
>> diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
>> index f62fa652c2fd..4d0a98f920ca 100644
>> --- a/fs/xfs/xfs_globals.c
>> +++ b/fs/xfs/xfs_globals.c
>> @@ -41,5 +41,6 @@ struct xfs_globals xfs_globals = {
>>   #endif
>>   #ifdef DEBUG
>>   	.pwork_threads		=	-1,	/* automatic thread detection */
>> +	.larp			=	false,	/* log attribute replay */
>>   #endif
>>   };
>> diff --git a/fs/xfs/xfs_sysctl.h b/fs/xfs/xfs_sysctl.h
>> index 7692e76ead33..f78ad6b10ea5 100644
>> --- a/fs/xfs/xfs_sysctl.h
>> +++ b/fs/xfs/xfs_sysctl.h
>> @@ -83,6 +83,7 @@ extern xfs_param_t	xfs_params;
>>   struct xfs_globals {
>>   #ifdef DEBUG
>>   	int	pwork_threads;		/* parallel workqueue threads */
>> +	bool	larp;			/* log attribute replay */
>>   #endif
>>   	int	log_recovery_delay;	/* log recovery delay (secs) */
>>   	int	mount_delay;		/* mount setup delay (secs) */
>> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
>> index 18dc5eca6c04..74180e05e8ed 100644
>> --- a/fs/xfs/xfs_sysfs.c
>> +++ b/fs/xfs/xfs_sysfs.c
>> @@ -227,6 +227,29 @@ pwork_threads_show(
>>   	return snprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.pwork_threads);
>>   }
>>   XFS_SYSFS_ATTR_RW(pwork_threads);
>> +
>> +static ssize_t
>> +larp_store(
>> +	struct kobject	*kobject,
>> +	const char	*buf,
>> +	size_t		count)
>> +{
>> +	ssize_t		ret;
>> +
>> +	ret = kstrtobool(buf, &xfs_globals.larp);
>> +	if (ret < 0)
>> +		return ret;
>> +	return count;
>> +}
>> +
>> +STATIC ssize_t
>> +larp_show(
>> +	struct kobject	*kobject,
>> +	char		*buf)
>> +{
>> +	return snprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.larp);
>> +}
>> +XFS_SYSFS_ATTR_RW(larp);
>>   #endif /* DEBUG */
>>   
>>   static struct attribute *xfs_dbg_attrs[] = {
>> @@ -236,6 +259,7 @@ static struct attribute *xfs_dbg_attrs[] = {
>>   	ATTR_LIST(always_cow),
>>   #ifdef DEBUG
>>   	ATTR_LIST(pwork_threads),
>> +	ATTR_LIST(larp),
>>   #endif
>>   	NULL,
>>   };
> 
> 
