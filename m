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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A155AC4338F
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 08:33:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83FF161057
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 08:33:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232670AbhHBIdd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Aug 2021 04:33:33 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:45800 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229595AbhHBIdd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Aug 2021 04:33:33 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1728PhxP020648;
        Mon, 2 Aug 2021 08:33:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=e58RPBJVxs6thWCm1carcGu8sC9K2z3e6ezGCDQhdGo=;
 b=btmOUd+5YaT39pi5sBnsjtCJOtv9NEbAXAtuUzLSX1ZHfiHOv6yVPDEY35Mu2H2w4xwC
 N+A8jiXfin3gOZPDcPTLLmbor+O5XNEGbYxHkRN14wVW1LsFC5Db3CDH6JZo8a5xutod
 ueyc6KUuGSYXafVXk6O0iKrlFIZLYfjZGnsxWQPggv4t5BhSRmLLOCsgXJ3W6X1HLd6V
 xSKUaDPG/4xQ+anPTeFOxco3ig2js9/+KAQB7QEmWrqJfSpHBzHSGKpgl+RuFVuCdgpP
 d8y07Id6y5tmdL08jHzKvrcLAueJDR3UQfHx8RayA5suYBwqF1l/GHpUJLPFiRudr7kb zw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=e58RPBJVxs6thWCm1carcGu8sC9K2z3e6ezGCDQhdGo=;
 b=narwpg4CoANZP2fa5t6g1RWWXNCIVK3vLNl+UbhScOYSkDa15KFM7b+1iLNcY8IhHE6L
 VngK49co/dsE6LeCENbKhYVADa7XSba0vccLO9/UjVRJBgFuZ5auxt7UohGd8As+amUA
 DJiVUTQIKcU2WH2I+v33qOytGedONlgfuREsBWCKnQG2NBTBnVrJVH+eQPOJXaQE+bmB
 bTH8u2d6MCqInmYSxdezj2Q4ZgLt8Gh4vW3dONxoQPzPgim6tSWFB9aHoSoZ1YJmXAyR
 oKzgl+PlMSpA8fbfrI+HYWVpdidR6hDnAZthBYiIQqGO64ArC86hRxL9e/Ho3BY4QYQq rQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a5wy1gwuh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Aug 2021 08:33:22 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1728PDLi039234;
        Mon, 2 Aug 2021 08:33:22 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by userp3020.oracle.com with ESMTP id 3a5g9spc26-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Aug 2021 08:33:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WrQBT6ZuHAcHe6vUg/hD+RpRNEuJkBNClN50Eh03XByR9O46MeSnv7vkE0fxiB/gQoa43wC9wdPJXPvHE04vLpOF2sJs1U9TmHbNq6q/Y6GgOup2TNNvQ6dYUZ7oj31EL5BFrPyRg0/QzoIMIsMCIenJgyK8qEpTEvSNs43tBK90Jim7kLpMA3KxJJIOt+0bp4HDImOKS1LSZfPhcXbrgQ/aW/vCr5d0XIQRmZpaDSSSfDDSdnI4SaMASHJHQ0lgGgPca5AyL4B76QR0MJ4eYAsuKDluE/PuDIbAnIUm4WBhu8XztOqvNWOKYrGUcjYnHsVivsuCrURmBLIAY1i7oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e58RPBJVxs6thWCm1carcGu8sC9K2z3e6ezGCDQhdGo=;
 b=jExlIlrTHlvHM5Jtr6id60EdAcLd2hiqY0uAtEQ2GGSuvdC6cP3n6QyuazEaWXMr6pVEah9eGmOwZHEbRGtH71ViB8jFL7cGuqL6LjquBuw9vAjv0/EnAiN8999kKxw2bAj8T0PPzl4fEqTrxJ4S+OVTv4YzZv6KIfDYPlf9ZkSGp6mkVpj8HfEBQpjjMl/VN6ACfWszGISixCjvVJ81VUZQhSVAKgmF/RT0TFpiHOWWcJw6rDdMEKCAT3hRpAS5NsEr2At7k/6027Tbu4B/QdzbVFYBmr3YPiHXYyAgSkOUovWjKUx3Nqgl5OvpuRGyocUF1sPzFrrXHKMd1EShXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e58RPBJVxs6thWCm1carcGu8sC9K2z3e6ezGCDQhdGo=;
 b=UYzE0X0tjJMeIcidQkP8Siu1uH5nw3jO4uyFv7K3L+ueQClTuOV2HgYgu/2WV9s3ePY9qswV1YhDfoJInj4B8JnP1vWjTFkRhmiblesrHsIFAu8D5RRHkQhFt9vQdIfJ8mk3uqoAQkCAeK4YP4L9sucQueEYARb9x+fG5XCYCQQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB5485.namprd10.prod.outlook.com (2603:10b6:a03:3ab::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Mon, 2 Aug
 2021 08:33:19 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%9]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 08:33:19 +0000
Subject: Re: [PATCH v22 15/16] xfs: Merge xfs_delattr_context into
 xfs_attr_item
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210727062053.11129-1-allison.henderson@oracle.com>
 <20210727062053.11129-16-allison.henderson@oracle.com>
 <87zgu0msq0.fsf@garuda>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <d585b00b-296e-87d4-030c-c5f36cafd299@oracle.com>
Date:   Mon, 2 Aug 2021 01:33:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <87zgu0msq0.fsf@garuda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH0PR07CA0048.namprd07.prod.outlook.com
 (2603:10b6:510:e::23) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.167] (67.1.112.125) by PH0PR07CA0048.namprd07.prod.outlook.com (2603:10b6:510:e::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.20 via Frontend Transport; Mon, 2 Aug 2021 08:33:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db6c24d0-cb62-4f81-3034-08d955902e70
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5485:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5485BE11D9A16AA5339CBC4995EF9@SJ0PR10MB5485.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:337;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 68ttD6x1pLJy/S+0U6e3MXnmjk9+061UVrAoM/kGT4Hd4pAbbxwm48Z0t9ae9XzBosj+x+/eN+8b3ByjXqAnwdO9t277SWA6itJSYD1ObODKdvXJucXe8/kgnOG4P8cVUf22MIhlkdhpz5xJkuT8tmjgECpAGA1A2alDtcRdO6fmfwbG0NFUQCKYQ2F0F9ZfkJzxbcpJF+QpRRnX5g9wEXSvoCC1UPqwqDd/sQDYZu9m4ayueUVfcJOW3/jCo3UFcWU13DlTpvhODTucx6uRQWTZ0IhbLZjhgPj/87gEWks/94Dsn0nBaAmzA5txWx6NezNEnp8soh+4aL50/r7Ux61XOx1pr8pNzHZuUam0x/6RQIwk5iEAXvlEqJC8IKoReTkQ1JkzzuTpS5G8YkQhYWY8il+GR/RowHx5D1ULfKS99h4FN9qEXGLtYl4TivWuqSvR/nmyGjQfYSK5Jw9zi6tLMm1/53E1B2gp8MGRTjhCojK1k4QT9VkaEoUiPSP4poZNBS0SJiNIu22HtzjDuSzYMPhw1pNIP7DFU5jS1dNY3UJavN16e82Dffxk2wcdi19p1LswgDGdntiYG7Yh2YgDqIrXwdaLMctS7R8nhp4I9TGsG0j2W0EO3QrVw/cgRhxgErBL+cGLNJjqPnZK8owJVcP5HA/Amwk0JPlCKEZ3HJhyoGZBgBizsjicavUryDXs3Ll+tfqsdxH22HWzsbUe8mKO/AyxWn9sOEyyKBQ5DiZ62MT10qQ3akG533EalA4kV7STtcVoNZruDsW/oQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(366004)(39860400002)(376002)(136003)(44832011)(4326008)(8936002)(36756003)(6486002)(86362001)(66556008)(38100700002)(38350700002)(66476007)(8676002)(316002)(2906002)(30864003)(16576012)(31696002)(66946007)(31686004)(53546011)(956004)(2616005)(26005)(5660300002)(186003)(52116002)(6916009)(478600001)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q3Jjb0ViRW00LytLTXBOTDQwczRza0RmS0xpZG92UGFEV05VNjF1QSs0QVBt?=
 =?utf-8?B?VmRWWFRNWEZhbzdrKzBJWGQrQU0weGtjWTROa2t1YVlEOTNYWHVkSThuYkIv?=
 =?utf-8?B?S0M2YlhCWFdQRTFPd0FTMk1uZExtbDJ0YTBuclFlTE03eXh1ekw1bmtKYU95?=
 =?utf-8?B?VmxoaXhEK282SjV5eHhFM05rdzN4UEpTWmJITlQyQ1NsckhqZmFVTlNVQ2c0?=
 =?utf-8?B?SSs2SGFocjN4UGQvZGVPakhXd0xWUVYzK1ArSVpmb1BUeGEzallTS2VVaVpL?=
 =?utf-8?B?ZjRVMXhSRHhORkxsSUxiYTkvVDNyU3dWZS9YKzYrZXJJcUNPdW1xRGV2MndR?=
 =?utf-8?B?VXVIN2h0Z254TVFGY05vcE1wWUl3ekp1NG1uOUhPV2pRQjl0SFRmelh0TWhW?=
 =?utf-8?B?TTNKVkVEQ01mUUJRNTJSU0poRHRZeGVwVVZzWkhYa2lXZ2lad3FYZ2VyZnZ6?=
 =?utf-8?B?U0ZleHJvYzd2NU5zN2dzOTAvVk1CTGFsSFJuUi9mYzJBN2ZYQVVOcnk5MTBy?=
 =?utf-8?B?dlNuOXZWenZyc0orNWc3WjhOajI5cDJISVZSbUJZL0RvYXJRYWFIdks2Z2VO?=
 =?utf-8?B?ZDlzNHZUTUtxRG5YZ1dUS0dZQTdBd0pMZmlBSWpPS1lJTjVqYW81OUZJOXMw?=
 =?utf-8?B?SUFUSXFTMkgvTW1WVjNmeXA5N2Zld2JLMnQzODUyWjF0NTYwbVdTWDFMTjRi?=
 =?utf-8?B?Lzg4MlQxMitSU1VVZVVHajNaUnI2V0JGbzZMTGRNNFFncGpXQSs3R2k4cUNQ?=
 =?utf-8?B?RExadGVXSDF5K0trMGwzVFJTeXU4SVNmOC8zTTV6M2hMdGVqWS8wNGhRWEI5?=
 =?utf-8?B?TC9GREFQSzlNSjFKZGNZaHo5VnR0d0ZvcDQrcWVxb0Q3d0pudTQveHk0RmNo?=
 =?utf-8?B?RkZEM1pYMnZxNE02MSs5em1aV3QxRjZxOG8wZzdkdHQrRmphRU1PeTBjL1Zp?=
 =?utf-8?B?dXRyaFI2VDRsUCswR2dWejVQRWw3SzBxSC9iWnptOEU1ejMrcWd0c0ZOL3lE?=
 =?utf-8?B?NmdhSlM5S0diMysvOWpUaXAxWWtyNUt2NWFOUExJUVQwOFY2R2lzK1ZXdEJl?=
 =?utf-8?B?dGZJUjFjLzlDaU9CalArMkhLQmt5bnhvL0Z4UVFWWkdQK2cwdTRXY1g2bm40?=
 =?utf-8?B?MjB2SnVwTlV0cDlLSGNrQWVDRmNZRXgxTHRrUTZ4Z3ZGZjV0RlFlOXJnaFJB?=
 =?utf-8?B?YWx5ZXdkaFE3VnZCbWlHdnV0d29iNmlpVmNtZk54cmlTa1NicVVrdjVpT0JD?=
 =?utf-8?B?LzQwelpLSDNMelpINWhIdlFMTkdDM0FpWnZJYjdyMGpqUitIckJoVkFqZ1Y2?=
 =?utf-8?B?RTNQYzF1Ynl5c1Uwa1BuMEwxdklZSjlycTlSU3RWZEVpNjJCR2xWbWF4bWo3?=
 =?utf-8?B?UFh2NkFSNEJqZVFoT0xMQUx5THN4U3ZDTUdOYWpGV1RkcDVRaGxmWS9QaWkz?=
 =?utf-8?B?Vmg3NndJbEFOTjVvUlR0YjBCY3lsWjIzclFvR1FyMDdLazQzSmpkU29IV1Nz?=
 =?utf-8?B?VHRhU04yUW1Pc3pVMFJubFhqV1hHQXRPRVNDbHR1OHVyUE1SdTdkazIvQS9l?=
 =?utf-8?B?Rm1CMWRYdmFtai9WYkIxMGVnWm1mRzQ3dVBDQXNmbFQvT0ZoZnNPZGk0RjlO?=
 =?utf-8?B?TndzamV0TEV3cTZMQlV5cjdyZEViL1U0TXZ1U1FGT3BsbklzcWF0ZHRwQWQy?=
 =?utf-8?B?TjZhSmtxNG1rQVpmb1hjbUJrbXJ2OXhkLzRDTGwzbGo3SXUyNVRNMEtIOU50?=
 =?utf-8?Q?SWzp8/PAgogJPEoqlY/0HVKFm0HdFlB737+q+z3?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db6c24d0-cb62-4f81-3034-08d955902e70
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2021 08:33:19.3795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tVszCAaPZJrmD56CkFVdjI3VARxBcKtgjuXBy+Tqr/GtW1D55XgyREzW8bGq4TvQwkuKV6zOyUoAiDTQDXJAAN1Il+pKJQzw9JYEksTtPrA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5485
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10063 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108020059
X-Proofpoint-GUID: LmsKS18oSSlvR1WtvzoJbl0teGkcfd5p
X-Proofpoint-ORIG-GUID: LmsKS18oSSlvR1WtvzoJbl0teGkcfd5p
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 8/1/21 8:27 PM, Chandan Babu R wrote:
> On 27 Jul 2021 at 11:50, Allison Henderson wrote:
>> This is a clean up patch that merges xfs_delattr_context into
>> xfs_attr_item.  Now that the refactoring is complete and the delayed
>> operation infrastructure is in place, we can combine these to eliminate
>> the extra struct
>>
> 
> Looks good to me.
> 
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Great, thanks!

Allison
> 
> 
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c        | 142 ++++++++++++++++++++--------------------
>>   fs/xfs/libxfs/xfs_attr.h        |  40 +++++------
>>   fs/xfs/libxfs/xfs_attr_remote.c |  36 +++++-----
>>   fs/xfs/libxfs/xfs_attr_remote.h |   6 +-
>>   fs/xfs/xfs_attr_item.c          |  43 ++++++------
>>   5 files changed, 130 insertions(+), 137 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index ec03a7b..811288d 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -56,10 +56,9 @@ STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_buf *bp);
>>    */
>>   STATIC int xfs_attr_node_get(xfs_da_args_t *args);
>>   STATIC void xfs_attr_restore_rmt_blk(struct xfs_da_args *args);
>> -STATIC int xfs_attr_node_addname(struct xfs_delattr_context *dac);
>> -STATIC int xfs_attr_node_addname_find_attr(struct xfs_delattr_context *dac);
>> -STATIC int xfs_attr_node_addname_clear_incomplete(
>> -				struct xfs_delattr_context *dac);
>> +STATIC int xfs_attr_node_addname(struct xfs_attr_item *attr);
>> +STATIC int xfs_attr_node_addname_find_attr(struct xfs_attr_item *attr);
>> +STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_attr_item *attr);
>>   STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>>   				 struct xfs_da_state **state);
>>   STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>> @@ -246,11 +245,11 @@ xfs_attr_is_shortform(
>>   
>>   STATIC int
>>   xfs_attr_sf_addname(
>> -	struct xfs_delattr_context	*dac)
>> +	struct xfs_attr_item		*attr)
>>   {
>> -	struct xfs_da_args		*args = dac->da_args;
>> +	struct xfs_da_args		*args = attr->xattri_da_args;
>>   	struct xfs_inode		*dp = args->dp;
>> -	struct xfs_buf			**leaf_bp = &dac->leaf_bp;
>> +	struct xfs_buf			**leaf_bp = &attr->xattri_leaf_bp;
>>   	int				error = 0;
>>   
>>   	/*
>> @@ -295,17 +294,17 @@ xfs_attr_sf_addname(
>>    */
>>   int
>>   xfs_attr_set_iter(
>> -	struct xfs_delattr_context	*dac)
>> +	struct xfs_attr_item		*attr)
>>   {
>> -	struct xfs_da_args              *args = dac->da_args;
>> -	struct xfs_buf			**leaf_bp = &dac->leaf_bp;
>> +	struct xfs_da_args              *args = attr->xattri_da_args;
>> +	struct xfs_buf			**leaf_bp = &attr->xattri_leaf_bp;
>>   	struct xfs_inode		*dp = args->dp;
>>   	struct xfs_buf			*bp = NULL;
>>   	int				forkoff, error = 0;
>>   	struct xfs_mount		*mp = args->dp->i_mount;
>>   
>>   	/* State machine switch */
>> -	switch (dac->dela_state) {
>> +	switch (attr->xattri_dela_state) {
>>   	case XFS_DAS_UNINIT:
>>   		/*
>>   		 * If the fork is shortform, attempt to add the attr. If there
>> @@ -315,7 +314,7 @@ xfs_attr_set_iter(
>>   		 * release the hold once we return with a clean transaction.
>>   		 */
>>   		if (xfs_attr_is_shortform(dp))
>> -			return xfs_attr_sf_addname(dac);
>> +			return xfs_attr_sf_addname(attr);
>>   		if (*leaf_bp != NULL) {
>>   			xfs_trans_bhold_release(args->trans, *leaf_bp);
>>   			*leaf_bp = NULL;
>> @@ -342,19 +341,19 @@ xfs_attr_set_iter(
>>   				 * handling code below
>>   				 */
>>   				trace_xfs_attr_set_iter_return(
>> -					dac->dela_state, args->dp);
>> +					attr->xattri_dela_state, args->dp);
>>   				return -EAGAIN;
>>   			} else if (error) {
>>   				return error;
>>   			}
>>   
>> -			dac->dela_state = XFS_DAS_FOUND_LBLK;
>> +			attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
>>   		} else {
>> -			error = xfs_attr_node_addname_find_attr(dac);
>> +			error = xfs_attr_node_addname_find_attr(attr);
>>   			if (error)
>>   				return error;
>>   
>> -			error = xfs_attr_node_addname(dac);
>> +			error = xfs_attr_node_addname(attr);
>>   			if (error)
>>   				return error;
>>   
>> @@ -365,9 +364,10 @@ xfs_attr_set_iter(
>>   			if (!args->rmtblkno && !args->rmtblkno2)
>>   				return 0;
>>   
>> -			dac->dela_state = XFS_DAS_FOUND_NBLK;
>> +			attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
>>   		}
>> -		trace_xfs_attr_set_iter_return(dac->dela_state,	args->dp);
>> +		trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
>> +					       args->dp);
>>   		return -EAGAIN;
>>   	case XFS_DAS_FOUND_LBLK:
>>   		/*
>> @@ -378,10 +378,10 @@ xfs_attr_set_iter(
>>   		 */
>>   
>>   		/* Open coded xfs_attr_rmtval_set without trans handling */
>> -		if ((dac->flags & XFS_DAC_LEAF_ADDNAME_INIT) == 0) {
>> -			dac->flags |= XFS_DAC_LEAF_ADDNAME_INIT;
>> +		if ((attr->xattri_flags & XFS_DAC_LEAF_ADDNAME_INIT) == 0) {
>> +			attr->xattri_flags |= XFS_DAC_LEAF_ADDNAME_INIT;
>>   			if (args->rmtblkno > 0) {
>> -				error = xfs_attr_rmtval_find_space(dac);
>> +				error = xfs_attr_rmtval_find_space(attr);
>>   				if (error)
>>   					return error;
>>   			}
>> @@ -391,11 +391,11 @@ xfs_attr_set_iter(
>>   		 * Repeat allocating remote blocks for the attr value until
>>   		 * blkcnt drops to zero.
>>   		 */
>> -		if (dac->blkcnt > 0) {
>> -			error = xfs_attr_rmtval_set_blk(dac);
>> +		if (attr->xattri_blkcnt > 0) {
>> +			error = xfs_attr_rmtval_set_blk(attr);
>>   			if (error)
>>   				return error;
>> -			trace_xfs_attr_set_iter_return(dac->dela_state,
>> +			trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
>>   						       args->dp);
>>   			return -EAGAIN;
>>   		}
>> @@ -431,8 +431,8 @@ xfs_attr_set_iter(
>>   			 * Commit the flag value change and start the next trans
>>   			 * in series.
>>   			 */
>> -			dac->dela_state = XFS_DAS_FLIP_LFLAG;
>> -			trace_xfs_attr_set_iter_return(dac->dela_state,
>> +			attr->xattri_dela_state = XFS_DAS_FLIP_LFLAG;
>> +			trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
>>   						       args->dp);
>>   			return -EAGAIN;
>>   		}
>> @@ -451,16 +451,16 @@ xfs_attr_set_iter(
>>   		/* fallthrough */
>>   	case XFS_DAS_RM_LBLK:
>>   		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
>> -		dac->dela_state = XFS_DAS_RM_LBLK;
>> +		attr->xattri_dela_state = XFS_DAS_RM_LBLK;
>>   		if (args->rmtblkno) {
>> -			error = xfs_attr_rmtval_remove(dac);
>> +			error = xfs_attr_rmtval_remove(attr);
>>   			if (error == -EAGAIN)
>>   				trace_xfs_attr_set_iter_return(
>> -					dac->dela_state, args->dp);
>> +					attr->xattri_dela_state, args->dp);
>>   			if (error)
>>   				return error;
>>   
>> -			dac->dela_state = XFS_DAS_RD_LEAF;
>> +			attr->xattri_dela_state = XFS_DAS_RD_LEAF;
>>   			return -EAGAIN;
>>   		}
>>   
>> @@ -491,7 +491,7 @@ xfs_attr_set_iter(
>>   		 * state.
>>   		 */
>>   		if (args->rmtblkno > 0) {
>> -			error = xfs_attr_rmtval_find_space(dac);
>> +			error = xfs_attr_rmtval_find_space(attr);
>>   			if (error)
>>   				return error;
>>   		}
>> @@ -504,14 +504,14 @@ xfs_attr_set_iter(
>>   		 * after we create the attribute so that we don't overflow the
>>   		 * maximum size of a transaction and/or hit a deadlock.
>>   		 */
>> -		dac->dela_state = XFS_DAS_ALLOC_NODE;
>> +		attr->xattri_dela_state = XFS_DAS_ALLOC_NODE;
>>   		if (args->rmtblkno > 0) {
>> -			if (dac->blkcnt > 0) {
>> -				error = xfs_attr_rmtval_set_blk(dac);
>> +			if (attr->xattri_blkcnt > 0) {
>> +				error = xfs_attr_rmtval_set_blk(attr);
>>   				if (error)
>>   					return error;
>>   				trace_xfs_attr_set_iter_return(
>> -					dac->dela_state, args->dp);
>> +					attr->xattri_dela_state, args->dp);
>>   				return -EAGAIN;
>>   			}
>>   
>> @@ -547,8 +547,8 @@ xfs_attr_set_iter(
>>   			 * Commit the flag value change and start the next trans
>>   			 * in series
>>   			 */
>> -			dac->dela_state = XFS_DAS_FLIP_NFLAG;
>> -			trace_xfs_attr_set_iter_return(dac->dela_state,
>> +			attr->xattri_dela_state = XFS_DAS_FLIP_NFLAG;
>> +			trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
>>   						       args->dp);
>>   			return -EAGAIN;
>>   		}
>> @@ -568,17 +568,17 @@ xfs_attr_set_iter(
>>   		/* fallthrough */
>>   	case XFS_DAS_RM_NBLK:
>>   		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
>> -		dac->dela_state = XFS_DAS_RM_NBLK;
>> +		attr->xattri_dela_state = XFS_DAS_RM_NBLK;
>>   		if (args->rmtblkno) {
>> -			error = xfs_attr_rmtval_remove(dac);
>> +			error = xfs_attr_rmtval_remove(attr);
>>   			if (error == -EAGAIN)
>>   				trace_xfs_attr_set_iter_return(
>> -					dac->dela_state, args->dp);
>> +					attr->xattri_dela_state, args->dp);
>>   
>>   			if (error)
>>   				return error;
>>   
>> -			dac->dela_state = XFS_DAS_CLR_FLAG;
>> +			attr->xattri_dela_state = XFS_DAS_CLR_FLAG;
>>   			return -EAGAIN;
>>   		}
>>   
>> @@ -588,7 +588,7 @@ xfs_attr_set_iter(
>>   		 * The last state for node format. Look up the old attr and
>>   		 * remove it.
>>   		 */
>> -		error = xfs_attr_node_addname_clear_incomplete(dac);
>> +		error = xfs_attr_node_addname_clear_incomplete(attr);
>>   		break;
>>   	default:
>>   		ASSERT(0);
>> @@ -785,7 +785,7 @@ xfs_attr_item_init(
>>   
>>   	new = kmem_zalloc(sizeof(struct xfs_attr_item), KM_NOFS);
>>   	new->xattri_op_flags = op_flags;
>> -	new->xattri_dac.da_args = args;
>> +	new->xattri_da_args = args;
>>   
>>   	*attr = new;
>>   	return 0;
>> @@ -1098,16 +1098,16 @@ xfs_attr_node_hasname(
>>   
>>   STATIC int
>>   xfs_attr_node_addname_find_attr(
>> -	struct xfs_delattr_context	*dac)
>> +	 struct xfs_attr_item		*attr)
>>   {
>> -	struct xfs_da_args		*args = dac->da_args;
>> +	struct xfs_da_args		*args = attr->xattri_da_args;
>>   	int				retval;
>>   
>>   	/*
>>   	 * Search to see if name already exists, and get back a pointer
>>   	 * to where it should go.
>>   	 */
>> -	retval = xfs_attr_node_hasname(args, &dac->da_state);
>> +	retval = xfs_attr_node_hasname(args, &attr->xattri_da_state);
>>   	if (retval != -ENOATTR && retval != -EEXIST)
>>   		return retval;
>>   
>> @@ -1135,8 +1135,8 @@ xfs_attr_node_addname_find_attr(
>>   
>>   	return 0;
>>   error:
>> -	if (dac->da_state)
>> -		xfs_da_state_free(dac->da_state);
>> +	if (attr->xattri_da_state)
>> +		xfs_da_state_free(attr->xattri_da_state);
>>   	return retval;
>>   }
>>   
>> @@ -1157,10 +1157,10 @@ xfs_attr_node_addname_find_attr(
>>    */
>>   STATIC int
>>   xfs_attr_node_addname(
>> -	struct xfs_delattr_context	*dac)
>> +	struct xfs_attr_item		*attr)
>>   {
>> -	struct xfs_da_args		*args = dac->da_args;
>> -	struct xfs_da_state		*state = dac->da_state;
>> +	struct xfs_da_args		*args = attr->xattri_da_args;
>> +	struct xfs_da_state		*state = attr->xattri_da_state;
>>   	struct xfs_da_state_blk		*blk;
>>   	int				error;
>>   
>> @@ -1191,7 +1191,7 @@ xfs_attr_node_addname(
>>   			 * this point.
>>   			 */
>>   			trace_xfs_attr_node_addname_return(
>> -					dac->dela_state, args->dp);
>> +					attr->xattri_dela_state, args->dp);
>>   			return -EAGAIN;
>>   		}
>>   
>> @@ -1220,9 +1220,9 @@ xfs_attr_node_addname(
>>   
>>   STATIC int
>>   xfs_attr_node_addname_clear_incomplete(
>> -	struct xfs_delattr_context	*dac)
>> +	struct xfs_attr_item		*attr)
>>   {
>> -	struct xfs_da_args		*args = dac->da_args;
>> +	struct xfs_da_args		*args = attr->xattri_da_args;
>>   	struct xfs_da_state		*state = NULL;
>>   	int				retval = 0;
>>   	int				error = 0;
>> @@ -1323,10 +1323,10 @@ xfs_attr_leaf_mark_incomplete(
>>    */
>>   STATIC
>>   int xfs_attr_node_removename_setup(
>> -	struct xfs_delattr_context	*dac)
>> +	struct xfs_attr_item		*attr)
>>   {
>> -	struct xfs_da_args		*args = dac->da_args;
>> -	struct xfs_da_state		**state = &dac->da_state;
>> +	struct xfs_da_args		*args = attr->xattri_da_args;
>> +	struct xfs_da_state		**state = &attr->xattri_da_state;
>>   	int				error;
>>   
>>   	error = xfs_attr_node_hasname(args, state);
>> @@ -1385,16 +1385,16 @@ xfs_attr_node_removename(
>>    */
>>   int
>>   xfs_attr_remove_iter(
>> -	struct xfs_delattr_context	*dac)
>> +	struct xfs_attr_item		*attr)
>>   {
>> -	struct xfs_da_args		*args = dac->da_args;
>> -	struct xfs_da_state		*state = dac->da_state;
>> +	struct xfs_da_args		*args = attr->xattri_da_args;
>> +	struct xfs_da_state		*state = attr->xattri_da_state;
>>   	int				retval, error = 0;
>>   	struct xfs_inode		*dp = args->dp;
>>   
>>   	trace_xfs_attr_node_removename(args);
>>   
>> -	switch (dac->dela_state) {
>> +	switch (attr->xattri_dela_state) {
>>   	case XFS_DAS_UNINIT:
>>   		if (!xfs_inode_hasattr(dp))
>>   			return -ENOATTR;
>> @@ -1413,16 +1413,16 @@ xfs_attr_remove_iter(
>>   		 * Node format may require transaction rolls. Set up the
>>   		 * state context and fall into the state machine.
>>   		 */
>> -		if (!dac->da_state) {
>> -			error = xfs_attr_node_removename_setup(dac);
>> +		if (!attr->xattri_da_state) {
>> +			error = xfs_attr_node_removename_setup(attr);
>>   			if (error)
>>   				return error;
>> -			state = dac->da_state;
>> +			state = attr->xattri_da_state;
>>   		}
>>   
>>   		/* fallthrough */
>>   	case XFS_DAS_RMTBLK:
>> -		dac->dela_state = XFS_DAS_RMTBLK;
>> +		attr->xattri_dela_state = XFS_DAS_RMTBLK;
>>   
>>   		/*
>>   		 * If there is an out-of-line value, de-allocate the blocks.
>> @@ -1435,10 +1435,10 @@ xfs_attr_remove_iter(
>>   			 * May return -EAGAIN. Roll and repeat until all remote
>>   			 * blocks are removed.
>>   			 */
>> -			error = xfs_attr_rmtval_remove(dac);
>> +			error = xfs_attr_rmtval_remove(attr);
>>   			if (error == -EAGAIN) {
>>   				trace_xfs_attr_remove_iter_return(
>> -						dac->dela_state, args->dp);
>> +					attr->xattri_dela_state, args->dp);
>>   				return error;
>>   			} else if (error) {
>>   				goto out;
>> @@ -1453,7 +1453,7 @@ xfs_attr_remove_iter(
>>   			error = xfs_attr_refillstate(state);
>>   			if (error)
>>   				goto out;
>> -			dac->dela_state = XFS_DAS_RM_NAME;
>> +			attr->xattri_dela_state = XFS_DAS_RM_NAME;
>>   			return -EAGAIN;
>>   		}
>>   
>> @@ -1463,7 +1463,7 @@ xfs_attr_remove_iter(
>>   		 * If we came here fresh from a transaction roll, reattach all
>>   		 * the buffers to the current transaction.
>>   		 */
>> -		if (dac->dela_state == XFS_DAS_RM_NAME) {
>> +		if (attr->xattri_dela_state == XFS_DAS_RM_NAME) {
>>   			error = xfs_attr_refillstate(state);
>>   			if (error)
>>   				goto out;
>> @@ -1480,9 +1480,9 @@ xfs_attr_remove_iter(
>>   			if (error)
>>   				goto out;
>>   
>> -			dac->dela_state = XFS_DAS_RM_SHRINK;
>> +			attr->xattri_dela_state = XFS_DAS_RM_SHRINK;
>>   			trace_xfs_attr_remove_iter_return(
>> -					dac->dela_state, args->dp);
>> +					attr->xattri_dela_state, args->dp);
>>   			return -EAGAIN;
>>   		}
>>   
>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>> index d4e7521..b5f8351 100644
>> --- a/fs/xfs/libxfs/xfs_attr.h
>> +++ b/fs/xfs/libxfs/xfs_attr.h
>> @@ -430,7 +430,7 @@ struct xfs_attr_list_context {
>>    */
>>   
>>   /*
>> - * Enum values for xfs_delattr_context.da_state
>> + * Enum values for xfs_attr_item.xattri_da_state
>>    *
>>    * These values are used by delayed attribute operations to keep track  of where
>>    * they were before they returned -EAGAIN.  A return code of -EAGAIN signals the
>> @@ -455,7 +455,7 @@ enum xfs_delattr_state {
>>   };
>>   
>>   /*
>> - * Defines for xfs_delattr_context.flags
>> + * Defines for xfs_attr_item.xattri_flags
>>    */
>>   #define XFS_DAC_LEAF_ADDNAME_INIT	0x01 /* xfs_attr_leaf_addname init*/
>>   #define XFS_DAC_DELAYED_OP_INIT		0x02 /* delayed operations init*/
>> @@ -463,32 +463,25 @@ enum xfs_delattr_state {
>>   /*
>>    * Context used for keeping track of delayed attribute operations
>>    */
>> -struct xfs_delattr_context {
>> -	struct xfs_da_args      *da_args;
>> +struct xfs_attr_item {
>> +	struct xfs_da_args		*xattri_da_args;
>>   
>>   	/*
>>   	 * Used by xfs_attr_set to hold a leaf buffer across a transaction roll
>>   	 */
>> -	struct xfs_buf		*leaf_bp;
>> +	struct xfs_buf			*xattri_leaf_bp;
>>   
>>   	/* Used in xfs_attr_rmtval_set_blk to roll through allocating blocks */
>> -	struct xfs_bmbt_irec	map;
>> -	xfs_dablk_t		lblkno;
>> -	int			blkcnt;
>> +	struct xfs_bmbt_irec		xattri_map;
>> +	xfs_dablk_t			xattri_lblkno;
>> +	int				xattri_blkcnt;
>>   
>>   	/* Used in xfs_attr_node_removename to roll through removing blocks */
>> -	struct xfs_da_state     *da_state;
>> +	struct xfs_da_state		*xattri_da_state;
>>   
>>   	/* Used to keep track of current state of delayed operation */
>> -	unsigned int            flags;
>> -	enum xfs_delattr_state  dela_state;
>> -};
>> -
>> -/*
>> - * List of attrs to commit later.
>> - */
>> -struct xfs_attr_item {
>> -	struct xfs_delattr_context	xattri_dac;
>> +	unsigned int			xattri_flags;
>> +	enum xfs_delattr_state		xattri_dela_state;
>>   
>>   	/*
>>   	 * Indicates if the attr operation is a set or a remove
>> @@ -496,7 +489,10 @@ struct xfs_attr_item {
>>   	 */
>>   	unsigned int			xattri_op_flags;
>>   
>> -	/* used to log this item to an intent */
>> +	/*
>> +	 * used to log this item to an intent containing a list of attrs to
>> +	 * commit later
>> +	 */
>>   	struct list_head		xattri_list;
>>   };
>>   
>> @@ -516,12 +512,10 @@ bool xfs_attr_is_leaf(struct xfs_inode *ip);
>>   int xfs_attr_get_ilocked(struct xfs_da_args *args);
>>   int xfs_attr_get(struct xfs_da_args *args);
>>   int xfs_attr_set(struct xfs_da_args *args);
>> -int xfs_attr_set_iter(struct xfs_delattr_context *dac);
>> +int xfs_attr_set_iter(struct xfs_attr_item *attr);
>>   int xfs_has_attr(struct xfs_da_args *args);
>> -int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
>> +int xfs_attr_remove_iter(struct xfs_attr_item *attr);
>>   bool xfs_attr_namecheck(const void *name, size_t length);
>> -void xfs_delattr_context_init(struct xfs_delattr_context *dac,
>> -			      struct xfs_da_args *args);
>>   int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
>>   int xfs_attr_set_deferred(struct xfs_da_args *args);
>>   int xfs_attr_remove_deferred(struct xfs_da_args *args);
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
>> index e29c2b9..db5f004 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.c
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
>> @@ -568,14 +568,14 @@ xfs_attr_rmtval_stale(
>>    */
>>   int
>>   xfs_attr_rmtval_find_space(
>> -	struct xfs_delattr_context	*dac)
>> +	struct xfs_attr_item		*attr)
>>   {
>> -	struct xfs_da_args		*args = dac->da_args;
>> -	struct xfs_bmbt_irec		*map = &dac->map;
>> +	struct xfs_da_args		*args = attr->xattri_da_args;
>> +	struct xfs_bmbt_irec		*map = &attr->xattri_map;
>>   	int				error;
>>   
>> -	dac->lblkno = 0;
>> -	dac->blkcnt = 0;
>> +	attr->xattri_lblkno = 0;
>> +	attr->xattri_blkcnt = 0;
>>   	args->rmtblkcnt = 0;
>>   	args->rmtblkno = 0;
>>   	memset(map, 0, sizeof(struct xfs_bmbt_irec));
>> @@ -584,8 +584,8 @@ xfs_attr_rmtval_find_space(
>>   	if (error)
>>   		return error;
>>   
>> -	dac->blkcnt = args->rmtblkcnt;
>> -	dac->lblkno = args->rmtblkno;
>> +	attr->xattri_blkcnt = args->rmtblkcnt;
>> +	attr->xattri_lblkno = args->rmtblkno;
>>   
>>   	return 0;
>>   }
>> @@ -598,17 +598,18 @@ xfs_attr_rmtval_find_space(
>>    */
>>   int
>>   xfs_attr_rmtval_set_blk(
>> -	struct xfs_delattr_context	*dac)
>> +	struct xfs_attr_item		*attr)
>>   {
>> -	struct xfs_da_args		*args = dac->da_args;
>> +	struct xfs_da_args		*args = attr->xattri_da_args;
>>   	struct xfs_inode		*dp = args->dp;
>> -	struct xfs_bmbt_irec		*map = &dac->map;
>> +	struct xfs_bmbt_irec		*map = &attr->xattri_map;
>>   	int nmap;
>>   	int error;
>>   
>>   	nmap = 1;
>> -	error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)dac->lblkno,
>> -			dac->blkcnt, XFS_BMAPI_ATTRFORK, args->total,
>> +	error = xfs_bmapi_write(args->trans, dp,
>> +			(xfs_fileoff_t)attr->xattri_lblkno,
>> +			attr->xattri_blkcnt, XFS_BMAPI_ATTRFORK, args->total,
>>   			map, &nmap);
>>   	if (error)
>>   		return error;
>> @@ -618,8 +619,8 @@ xfs_attr_rmtval_set_blk(
>>   	       (map->br_startblock != HOLESTARTBLOCK));
>>   
>>   	/* roll attribute extent map forwards */
>> -	dac->lblkno += map->br_blockcount;
>> -	dac->blkcnt -= map->br_blockcount;
>> +	attr->xattri_lblkno += map->br_blockcount;
>> +	attr->xattri_blkcnt -= map->br_blockcount;
>>   
>>   	return 0;
>>   }
>> @@ -673,9 +674,9 @@ xfs_attr_rmtval_invalidate(
>>    */
>>   int
>>   xfs_attr_rmtval_remove(
>> -	struct xfs_delattr_context	*dac)
>> +	struct xfs_attr_item		*attr)
>>   {
>> -	struct xfs_da_args		*args = dac->da_args;
>> +	struct xfs_da_args		*args = attr->xattri_da_args;
>>   	int				error, done;
>>   
>>   	/*
>> @@ -695,7 +696,8 @@ xfs_attr_rmtval_remove(
>>   	 * the parent
>>   	 */
>>   	if (!done) {
>> -		trace_xfs_attr_rmtval_remove_return(dac->dela_state, args->dp);
>> +		trace_xfs_attr_rmtval_remove_return(attr->xattri_dela_state,
>> +						    args->dp);
>>   		return -EAGAIN;
>>   	}
>>   
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
>> index d72eff3..62b398e 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.h
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
>> @@ -12,9 +12,9 @@ int xfs_attr_rmtval_get(struct xfs_da_args *args);
>>   int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
>>   		xfs_buf_flags_t incore_flags);
>>   int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
>> -int xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
>> +int xfs_attr_rmtval_remove(struct xfs_attr_item *attr);
>>   int xfs_attr_rmt_find_hole(struct xfs_da_args *args);
>>   int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
>> -int xfs_attr_rmtval_set_blk(struct xfs_delattr_context *dac);
>> -int xfs_attr_rmtval_find_space(struct xfs_delattr_context *dac);
>> +int xfs_attr_rmtval_set_blk(struct xfs_attr_item *attr);
>> +int xfs_attr_rmtval_find_space(struct xfs_attr_item *attr);
>>   #endif /* __XFS_ATTR_REMOTE_H__ */
>> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
>> index 2efd94f..18fc202 100644
>> --- a/fs/xfs/xfs_attr_item.c
>> +++ b/fs/xfs/xfs_attr_item.c
>> @@ -284,11 +284,11 @@ xfs_attrd_item_release(
>>    */
>>   STATIC int
>>   xfs_trans_attr_finish_update(
>> -	struct xfs_delattr_context	*dac,
>> +	struct xfs_attr_item		*attr,
>>   	struct xfs_attrd_log_item	*attrdp,
>>   	uint32_t			op_flags)
>>   {
>> -	struct xfs_da_args		*args = dac->da_args;
>> +	struct xfs_da_args		*args = attr->xattri_da_args;
>>   	unsigned int			op = op_flags &
>>   					     XFS_ATTR_OP_FLAGS_TYPE_MASK;
>>   	int				error;
>> @@ -305,11 +305,11 @@ xfs_trans_attr_finish_update(
>>   	switch (op) {
>>   	case XFS_ATTR_OP_FLAGS_SET:
>>   		args->op_flags |= XFS_DA_OP_ADDNAME;
>> -		error = xfs_attr_set_iter(dac);
>> +		error = xfs_attr_set_iter(attr);
>>   		break;
>>   	case XFS_ATTR_OP_FLAGS_REMOVE:
>>   		ASSERT(XFS_IFORK_Q(args->dp));
>> -		error = xfs_attr_remove_iter(dac);
>> +		error = xfs_attr_remove_iter(attr);
>>   		break;
>>   	default:
>>   		error = -EFSCORRUPTED;
>> @@ -353,16 +353,16 @@ xfs_attr_log_item(
>>   	 * structure with fields from this xfs_attr_item
>>   	 */
>>   	attrp = &attrip->attri_format;
>> -	attrp->alfi_ino = attr->xattri_dac.da_args->dp->i_ino;
>> +	attrp->alfi_ino = attr->xattri_da_args->dp->i_ino;
>>   	attrp->alfi_op_flags = attr->xattri_op_flags;
>> -	attrp->alfi_value_len = attr->xattri_dac.da_args->valuelen;
>> -	attrp->alfi_name_len = attr->xattri_dac.da_args->namelen;
>> -	attrp->alfi_attr_flags = attr->xattri_dac.da_args->attr_filter;
>> -
>> -	attrip->attri_name = (void *)attr->xattri_dac.da_args->name;
>> -	attrip->attri_value = attr->xattri_dac.da_args->value;
>> -	attrip->attri_name_len = attr->xattri_dac.da_args->namelen;
>> -	attrip->attri_value_len = attr->xattri_dac.da_args->valuelen;
>> +	attrp->alfi_value_len = attr->xattri_da_args->valuelen;
>> +	attrp->alfi_name_len = attr->xattri_da_args->namelen;
>> +	attrp->alfi_attr_flags = attr->xattri_da_args->attr_filter;
>> +
>> +	attrip->attri_name = (void *)attr->xattri_da_args->name;
>> +	attrip->attri_value = attr->xattri_da_args->value;
>> +	attrip->attri_name_len = attr->xattri_da_args->namelen;
>> +	attrip->attri_value_len = attr->xattri_da_args->valuelen;
>>   }
>>   
>>   /* Get an ATTRI. */
>> @@ -403,10 +403,8 @@ xfs_attr_finish_item(
>>   	struct xfs_attr_item		*attr;
>>   	struct xfs_attrd_log_item	*done_item = NULL;
>>   	int				error;
>> -	struct xfs_delattr_context	*dac;
>>   
>>   	attr = container_of(item, struct xfs_attr_item, xattri_list);
>> -	dac = &attr->xattri_dac;
>>   	if (done)
>>   		done_item = ATTRD_ITEM(done);
>>   
>> @@ -418,19 +416,18 @@ xfs_attr_finish_item(
>>   	 * in a standard delay op, so we need to catch this here and rejoin the
>>   	 * leaf to the new transaction
>>   	 */
>> -	if (attr->xattri_dac.leaf_bp &&
>> -	    attr->xattri_dac.leaf_bp->b_transp != tp) {
>> -		xfs_trans_bjoin(tp, attr->xattri_dac.leaf_bp);
>> -		xfs_trans_bhold(tp, attr->xattri_dac.leaf_bp);
>> +	if (attr->xattri_leaf_bp && attr->xattri_leaf_bp->b_transp != tp) {
>> +		xfs_trans_bjoin(tp, attr->xattri_leaf_bp);
>> +		xfs_trans_bhold(tp, attr->xattri_leaf_bp);
>>   	}
>>   
>>   	/*
>>   	 * Always reset trans after EAGAIN cycle
>>   	 * since the transaction is new
>>   	 */
>> -	dac->da_args->trans = tp;
>> +	attr->xattri_da_args->trans = tp;
>>   
>> -	error = xfs_trans_attr_finish_update(dac, done_item,
>> +	error = xfs_trans_attr_finish_update(attr, done_item,
>>   					     attr->xattri_op_flags);
>>   	if (error != -EAGAIN)
>>   		kmem_free(attr);
>> @@ -608,7 +605,7 @@ xfs_attri_item_recover(
>>   	args = (struct xfs_da_args *)((char *)attr +
>>   		   sizeof(struct xfs_attr_item));
>>   
>> -	attr->xattri_dac.da_args = args;
>> +	attr->xattri_da_args = args;
>>   	attr->xattri_op_flags = attrp->alfi_op_flags;
>>   
>>   	args->dp = ip;
>> @@ -645,7 +642,7 @@ xfs_attri_item_recover(
>>   	xfs_ilock(ip, XFS_ILOCK_EXCL);
>>   	xfs_trans_ijoin(tp, ip, 0);
>>   
>> -	ret = xfs_trans_attr_finish_update(&attr->xattri_dac, done_item,
>> +	ret = xfs_trans_attr_finish_update(attr, done_item,
>>   					   attrp->alfi_op_flags);
>>   	if (ret == -EAGAIN) {
>>   		/* There's more work to do, so add it to this transaction */
> 
> 
