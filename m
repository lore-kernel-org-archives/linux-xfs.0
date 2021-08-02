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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4406DC4338F
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 08:18:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EA0861057
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 08:18:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232646AbhHBISZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Aug 2021 04:18:25 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:51696 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232632AbhHBISY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Aug 2021 04:18:24 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1728ApVO017161;
        Mon, 2 Aug 2021 08:18:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=/bKKFQvMCkRgHcvit6p2jWBmUa4lycFtcjE0CvpADoI=;
 b=gDm+e6qltX7I/3/JeKAnaSpIKs3olX08gM/a+muGbhc1i23cSW6rftszYQZ3Q+sHWl05
 THBbKV6ap4ChdxSSM7zGgxgvzUkDBhBPbyrGDVSg2x5BsqwZR5D4w1McA0m6B1+DYF8y
 7I12oxtPXkg4u5ytxiZTu6kAXvFEFW0LKFeZ3A/CjS1+a8w89jLRWHYW9cKbgWXJOGxQ
 9qzYm/1bRM8wEu+8rSEIylzrEqVsTqLoXH59y707R2bWjZoYdOfOMit6x8eBuPTdfSSz
 oGj/Ow/pdCZEnNpnVlxlptNqJombC+EaOkPlayLJVYYVa4umDjaXclXYICNcvPwrDfb+ oA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=/bKKFQvMCkRgHcvit6p2jWBmUa4lycFtcjE0CvpADoI=;
 b=f1Adcb1zl/l843Wu9pJR/GYQb5/sBhCDrq9DB7iAoAQF0BlWF0XnwugH5YeLNzcMA+g+
 fLALV8dRJGOIPiq4Tjc3jc6DB8LE2SnMJshQ0SARliltUf8mRahzE9JX7Jl4n13hW8IC
 Faexpdt6Jk0Jy6Xa3JsvdXbVY+wfqwAlX8ROVABuRKhBGoQQHSTQh/20seiMK/dF0Jhm
 Vkfs+k43zGkTUJ6ADnucWmZoUR096T0EO4cX7VQdoKvSBEl4HLlbh2xw7+98hezfDKC3
 V2YdixU2B5z5AvXxwki+cFMCOTI3UVNcSSO5wZlNJ+DIr9VakqRurPn8CCufLFMZiRYG Pg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a6cntg1xm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Aug 2021 08:18:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1728G2CJ005075;
        Mon, 2 Aug 2021 08:18:13 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by aserp3030.oracle.com with ESMTP id 3a4vjbm11y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Aug 2021 08:18:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R4J835D39fzEaxaMr7cMjYWYHo9MdKN6HosQodsMNV2FNVucu8NMw0AWmgqSSG6MqZMnHeEvlpQ/EjN8L6Git2dZmfQy4oDT57MxrJclaNHN2P42BGUkS1iXYecFwBRWHLAPG/2BpZISsg0PJGpL+chBcGSgzQDblgFpNnsVTwpCz9EFsg2wh4l2vgwL9vCIxDrclZ3holJJB90YLgya7OOZfT1QmLM0hZdlqeZi4dAbrixEMpzI7fYVxwFPvQCyvukHY4dTLnO0jo+3vYs8ZVwLvwIHDbSYCdEKkaWYYuysxdqjrY++/WFZ1Kd9DZo0uLZkmaUj8BAiKzN8OOvsSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/bKKFQvMCkRgHcvit6p2jWBmUa4lycFtcjE0CvpADoI=;
 b=MjmowbxxJi9LkNZ8KV8faqKt7oD1vBnr5niaKvF6C7It34a+ipWKP8UZPfbBGr1wnAuhS4DQO3CkzNTzc9SByHDzuHXMfUgNW0zM7jYCqenZ41UuHwQJRXlrQ2hRtpOxlED6XYmdwbx1d8k+J+BKtSwmvqvcTIo8cmbB7LXx1TSLJi4n9tezlIrDNLRrin2Z4N0JhUn48ip+d23PqWTbJ6Oh6MJNjGurBwkdcVBMTOhGCdkiE9hEgYD4kC/s2xO+wGxOURaKXU5xTBvTLZt1BWXyTV+lE9fxGXnvtTL8LOh/KeyABGZTR7XhTJPIdWQpo836qpLXpRVfToSeRayqkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/bKKFQvMCkRgHcvit6p2jWBmUa4lycFtcjE0CvpADoI=;
 b=eUxm6v0tGA+qdohORLMMvqOs4z4yEZoyBIS9CtkCLXZ+uQKC/JwaMUIoE3rXU4dqVgZRBD0JdvuCIDVOqGYyDA/paFn7/LbQ7sQ36P7QBRJQCQy63qWavjR6NwYP9+7/NuAkrLTEKrZhJVwf8rkVQ/K7t6qJ7ljjMjSNwAekDz8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4813.namprd10.prod.outlook.com (2603:10b6:a03:2d2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Mon, 2 Aug
 2021 08:18:11 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%9]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 08:18:11 +0000
Subject: Re: [PATCH v22 16/16] xfs: Add helper function xfs_attr_leaf_addname
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210727062053.11129-1-allison.henderson@oracle.com>
 <20210727062053.11129-17-allison.henderson@oracle.com>
 <20210728195226.GG3601443@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <254ccedc-377c-adf5-818e-856628236c8d@oracle.com>
Date:   Mon, 2 Aug 2021 01:18:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <20210728195226.GG3601443@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0030.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::35) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.167] (67.1.112.125) by SJ0PR13CA0030.namprd13.prod.outlook.com (2603:10b6:a03:2c0::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.6 via Frontend Transport; Mon, 2 Aug 2021 08:18:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e47cb52-ca69-4e85-89f9-08d9558e110f
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4813:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB48138D8B89B5CE7873FE5F9795EF9@SJ0PR10MB4813.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sarIORgGewMKxRzeXS5GQlsJMRk9qUJ5N+KvQtqP9x5EZsqVQcXvgLnrQBOarheZz+RBrQp1IqmpTcVZbeyd7/UKReWIqijWBzQkI9AjbKPHT2TUp7IPfSUidgUyickjpm5f9niaM4Wh5J3hZFDQMxfIxdtpSM+jwh4obLqAoSx2of3gVqlnFjCviE9/x1Y53D7QFy8NiIMDqKN/WisunAbjsBAF2N8QSW9OcHwzi0a5VLk45Dz33Q8Qx0I/ryPrxw7FykGFmW9KYEYQ1eR+lAepWlICXqrrrijEd6n9G+OIt6m2Gb/ETBvJb9okkZFRT37JxHDgdSlz41PxtHzH2nWK1gwc7NVMuqkrPIRKtHpEBOuxxv+CnYbWgUWqn+g+3t5TQsOiybYWFlUZJXJf73FTJI+vSn0DaWj+u50qSE1NAxT2tXoIBsBxJR/U/wrfn5eLZsEnbnrk4IU4EV6YdRCq7yclETQrmF3SKB+iZ+0sGHqrn6ZBbeZH5h3A8RTks3tXiDrPsrK2z83apuI/zkNp6hilnyBxnBO9DSG1OzcyT7Sl72XK44NR1sTRE6Jr5buI0cYn//OeVCZYYuoFj/Xnek0ci2K3FECL/9xtot5UXcMqQq3WhQ/urVb/jTeMn2WSWx+AnITZ4sy0JPpG/X7WyxCVMK5T7JmtucWY/waDM+TtnkEIAc16voURZINAsQvQoEgaRxkUBRibjKdZXZJnRl2jQYLwXgG8wih4iXRVBseQIdikQiobl9YcAz79VfumAqAjR76j1cq13uHuPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(396003)(136003)(366004)(376002)(31686004)(26005)(186003)(8936002)(2616005)(16576012)(66476007)(83380400001)(31696002)(6916009)(66556008)(956004)(4326008)(66946007)(38350700002)(6486002)(2906002)(36756003)(53546011)(52116002)(5660300002)(316002)(8676002)(38100700002)(478600001)(86362001)(44832011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eGhuZjJmQzkrWm1wQjRpYkFBakxScVRVM2gwblRBVHVCRE83QVFTSXNOU1g2?=
 =?utf-8?B?N1hsa2owaHRrSkdzR2NaVUhVdWNDYjBLNDU0VC82WHBvcVNVeVFjbm9YSzBI?=
 =?utf-8?B?QlcxdkhjTlJBYkEyMEZzWm9rYTZnMElJY0Q4UStoalZnRUZYNXpZUWFxUGZ2?=
 =?utf-8?B?V29tT09VZ3RTaUNVOVJBWHRBRml1RTBrS1crVjFYN1Y0a211K01nY1BhcWdX?=
 =?utf-8?B?U3V0TkMzMDJxUzNrajhwVnA5cmNwWGFzbGVkMzArNDJzUmxlUTV3UFIwTndI?=
 =?utf-8?B?L1VuR0NaTWd5ajBhckI3QVpTaUFBZnFESHdKQnlOaTRmMXFtSlFRQ1RmUXIz?=
 =?utf-8?B?eitPdnhhWUVPOHB0UjBRN1ZFWjJRZlFKVWw1YllEbXJ6UDJWWnFTWHh5SVVK?=
 =?utf-8?B?UzlPZFR0Y2VzaEVpcHhLbVArSkJoSEtiazN5Mm1oUmlYQnBIMkEzZ0ZoNENB?=
 =?utf-8?B?NnU3SS9XM0hWVmxIVkx6UXdldzZDMkViRWY2cUdCdkxOSUZuYVBJTGRkMFZq?=
 =?utf-8?B?R1VRMVprbWFSZmNTdE12OHZ2NzFqWnlFVFROZGNuNkFsSG9Wd1hIOW41NFdV?=
 =?utf-8?B?ZUwzZm5QWHFldXZsNUxUR0xPYVRwRFpPa25CS3p1OTZMWGVHSXpZa0psOXVL?=
 =?utf-8?B?NVA1bklKZDcwaSt5d3RDaXhzeUdLQnFDM0tCUFQ0RUpRNW5idktZaVNnUDJ6?=
 =?utf-8?B?MFZjblV2dzFPczJsRGNaRUV1SzdSanlINU5EV2FhYWFNTEdnSnVtZ2oweURY?=
 =?utf-8?B?eWJpQTg4eWVqbzRKdWswZGZYMXZ6eUowVjlySk4vZXhxczhBRG1EelpGeVJz?=
 =?utf-8?B?cUVzcGp3UDZLbDJCOU55Sy9jVTNidFo1WTVBRHNjZ1VtZE9RTDRjVkIwL01W?=
 =?utf-8?B?bHNobjlsUjZVOW5ZanM2dktndTFua2h1N3p3UzdwWlRtQ0FadWoxMGVES25R?=
 =?utf-8?B?OTVNUjhvaUlXazlkalpWVmxPS3JjaFpQTGw5R0c0TjlhbER4U0h0bGhheGRH?=
 =?utf-8?B?ZTJHWDV0S0lmSEJET3JKS1JpZFlmWlNaYTBHam1jZmJHUDJoWlc4Tm05eURY?=
 =?utf-8?B?b1Nyby9Za0NEbkpycWhlT1dybWorSHdoWWNXemJ5RjBmUGZFTFJEMnNxL0JO?=
 =?utf-8?B?RWthd2NCZDVPYVVMWlc4UFJFc1NzaGhhVlpxVmd3ZmM2eHM2bnZyRGp4ejBh?=
 =?utf-8?B?bUhSMTlydUZxaTFzMmJLaStDUnI0NERQL0pML01xcTFXZDd3M3lUVjVteExO?=
 =?utf-8?B?RXJMUjBXQWxvWCtjK01KNHh2dkYrbWtycmI1UmY0Zm5OeDB0WVhnYnpIVHBL?=
 =?utf-8?B?V1lrUEVlMVFucDRGRXZCZGVMSkpvcTNLRVNRSTMrMmNUbGs4bHFKN0cxTGhI?=
 =?utf-8?B?VjdYNmg3OTNLNzlRWlV3Z0thaERDVSs1YkI5d2FJTXJBazhWTzNaaCtmQ0Qv?=
 =?utf-8?B?aFdRY2xWMkhCQWRNYzhXRVdGcWFVbTQwSmhaeW5WYUlYaXlOUHZNbEhFZ2Rp?=
 =?utf-8?B?RFIzVnJSWndsOGprZytFRXpaV2gxMVhacEoxSll0S3c0NXdjY0xpcW9pWXdN?=
 =?utf-8?B?Rm9qRnJmaXhDY29McHZ5cDZhS3UwenJ3T0xpcGsxL0sxOWs4VWcwQkVOTkd4?=
 =?utf-8?B?QUZWa1o4U3pJQm9LYmp2OFhId1pnSDRtNkVPWThWTHFKYmNlUWhzcy9ySnVN?=
 =?utf-8?B?VzFXZzRLd1NMRTJnQmtaVmtVRWlFR3k2aXR2cm1mdE5kOGlIKzBkUFUrOFhO?=
 =?utf-8?Q?5EkIUvkSbDGZAPATtQwu288OiFEhgfw0UV3n3t7?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e47cb52-ca69-4e85-89f9-08d9558e110f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2021 08:18:11.1087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eytBAKy/MAzAeh0HKuc9VqyuJRMw3KUOQGHNADGTafH1AajLaN7PaAJIP5Y/cF22TLTzXRKaRjMUWUBQFUXBBKIKem16CSHdh3UdQA8V4Lg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4813
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10063 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108020058
X-Proofpoint-ORIG-GUID: Jb2aCsX_htkmRuo6E2nLgQSWQInU49kc
X-Proofpoint-GUID: Jb2aCsX_htkmRuo6E2nLgQSWQInU49kc
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/28/21 12:52 PM, Darrick J. Wong wrote:
> On Mon, Jul 26, 2021 at 11:20:53PM -0700, Allison Henderson wrote:
>> This patch adds a helper function xfs_attr_leaf_addname.  While this
>> does help to break down xfs_attr_set_iter, it does also hoist out some
>> of the state management.  This patch has been moved to the end of the
>> clean up series for further discussion.
>>
>> Suggested-by: Darrick J. Wong <djwong@kernel.org>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 108 ++++++++++++++++++++++++++---------------------
>>   fs/xfs/xfs_trace.h       |   1 +
>>   2 files changed, 61 insertions(+), 48 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 811288d..acb995b 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -285,6 +285,65 @@ xfs_attr_sf_addname(
>>   	return -EAGAIN;
>>   }
>>   
>> +STATIC int
>> +xfs_attr_leaf_addname(
>> +	struct xfs_attr_item	*attr)
>> +{
>> +	struct xfs_da_args	*args = attr->xattri_da_args;
>> +	struct xfs_buf		*leaf_bp = attr->xattri_leaf_bp;
>> +	struct xfs_inode	*dp = args->dp;
>> +	int			error;
>> +
>> +	if (xfs_attr_is_leaf(dp)) {
>> +		error = xfs_attr_leaf_try_add(args, leaf_bp);
>> +		if (error == -ENOSPC) {
>> +			error = xfs_attr3_leaf_to_node(args);
>> +			if (error)
>> +				return error;
>> +
>> +			/*
>> +			 * Finish any deferred work items and roll the
>> +			 * transaction once more.  The goal here is to call
>> +			 * node_addname with the inode and transaction in the
>> +			 * same state (inode locked and joined, transaction
>> +			 * clean) no matter how we got to this step.
>> +			 *
>> +			 * At this point, we are still in XFS_DAS_UNINIT, but
>> +			 * when we come back, we'll be a node, so we'll fall
>> +			 * down into the node handling code below
>> +			 */
>> +			trace_xfs_attr_set_iter_return(
>> +				attr->xattri_dela_state, args->dp);
>> +			return -EAGAIN;
>> +		}
>> +
>> +		if (error)
>> +			return error;
>> +
>> +		attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
> 
> Hmm.  I know I reviewed this once before, but on second thought it's a
> little strange to be calling the node addname function from the leaf
> addname function.  Can you reduce the leaf addname function's scope like
> this:
> 
> STATIC int
> xfs_attr_leaf_addname(
> 	struct xfs_attr_item	*attr)
> 
> 	struct xfs_da_args	*args = attr->xattri_da_args;
> 	struct xfs_buf		*leaf_bp = attr->xattri_leaf_bp;
> 	struct xfs_inode	*dp = args->dp;
> 	int			error;
> 
> 	error = xfs_attr_leaf_try_add(args, leaf_bp);
> 	if (error == 0) {
> 		attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
> 		trace_xfs_attr_leaf_addname_return(attr->xattri_dela_state,
> 				args->dp);
> 		return -EAGAIN;
> 	}
> 	if (error != -ENOSPC)
> 		return error;
> 
> 	/* No room in leaf; convert to node format and try again. */
> 	error = xfs_attr3_leaf_to_node(args);
> 	if (error)
> 		return error;
> 
> 	/*
> 	 * Finish any deferred work items and roll the transaction once
> 	 * more.  The goal here is to call node_addname with the inode
> 	 * and transaction in the same state (inode locked and joined,
> 	 * transaction clean) no matter how we got to this step.
> 	 *
> 	 * At this point, we are still in XFS_DAS_UNINIT, but when we
> 	 * come back, we'll be a node, so we'll fall down into the node
> 	 * handling code below
> 	 */
> 	trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
> 			args->dp);
> 	return -EAGAIN;
> }
> 
> Then the callsite up in xfs_attr_set_iter looks like:
> 
> 	case XFS_DAS_UNINIT:
> 		if (xfs_attr_is_shortform(dp))
> 			return xfs_attr_sf_addname(dac, leaf_bp);
> 		if (*leaf_bp != NULL) {
> 			xfs_trans_bhold_release(args->trans, *leaf_bp);
> 			*leaf_bp = NULL;
> 		}
> 
> 		if (xfs_attr_is_leaf(dp))
> 			return xfs_attr_leaf_addname(...);
> 
> 		/* node format */
> 		error = xfs_attr_node_addname_find_attr(attr);
> 		if (error)
> 			return error;
> 
> 		error = xfs_attr_node_addname(attr);
> 		if (error)
> 			return error;
> 
> 		dac->dela_state = XFS_DAS_FOUND_NBLK;
> 		return -EAGAIN;
> 
> 	case XFS_DAS_FOUND_LBLK:
> 
Sure, I can pull some of that back up, should be ok.

Allison

> --D
> 
>> +	} else {
>> +		error = xfs_attr_node_addname_find_attr(attr);
>> +		if (error)
>> +			return error;
>> +
>> +		error = xfs_attr_node_addname(attr);
>> +		if (error)
>> +			return error;
>> +
>> +		/*
>> +		 * If addname was successful, and we dont need to alloc or
>> +		 * remove anymore blks, we're done.
>> +		 */
>> +		if (!args->rmtblkno && !args->rmtblkno2)
>> +			return 0;
>> +
>> +		attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
>> +	}
>> +
>> +	trace_xfs_attr_leaf_addname_return(attr->xattri_dela_state, args->dp);
>> +	return -EAGAIN;
>> +}
>> +
>>   /*
>>    * Set the attribute specified in @args.
>>    * This routine is meant to function as a delayed operation, and may return
>> @@ -320,55 +379,8 @@ xfs_attr_set_iter(
>>   			*leaf_bp = NULL;
>>   		}
>>   
>> -		if (xfs_attr_is_leaf(dp)) {
>> -			error = xfs_attr_leaf_try_add(args, *leaf_bp);
>> -			if (error == -ENOSPC) {
>> -				error = xfs_attr3_leaf_to_node(args);
>> -				if (error)
>> -					return error;
>> -
>> -				/*
>> -				 * Finish any deferred work items and roll the
>> -				 * transaction once more.  The goal here is to
>> -				 * call node_addname with the inode and
>> -				 * transaction in the same state (inode locked
>> -				 * and joined, transaction clean) no matter how
>> -				 * we got to this step.
>> -				 *
>> -				 * At this point, we are still in
>> -				 * XFS_DAS_UNINIT, but when we come back, we'll
>> -				 * be a node, so we'll fall down into the node
>> -				 * handling code below
>> -				 */
>> -				trace_xfs_attr_set_iter_return(
>> -					attr->xattri_dela_state, args->dp);
>> -				return -EAGAIN;
>> -			} else if (error) {
>> -				return error;
>> -			}
>> -
>> -			attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
>> -		} else {
>> -			error = xfs_attr_node_addname_find_attr(attr);
>> -			if (error)
>> -				return error;
>> +		return xfs_attr_leaf_addname(attr);
>>   
>> -			error = xfs_attr_node_addname(attr);
>> -			if (error)
>> -				return error;
>> -
>> -			/*
>> -			 * If addname was successful, and we dont need to alloc
>> -			 * or remove anymore blks, we're done.
>> -			 */
>> -			if (!args->rmtblkno && !args->rmtblkno2)
>> -				return 0;
>> -
>> -			attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
>> -		}
>> -		trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
>> -					       args->dp);
>> -		return -EAGAIN;
>>   	case XFS_DAS_FOUND_LBLK:
>>   		/*
>>   		 * If there was an out-of-line value, allocate the blocks we
>> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
>> index f9840dd..cf8bd3a 100644
>> --- a/fs/xfs/xfs_trace.h
>> +++ b/fs/xfs/xfs_trace.h
>> @@ -4008,6 +4008,7 @@ DEFINE_EVENT(xfs_das_state_class, name, \
>>   	TP_ARGS(das, ip))
>>   DEFINE_DAS_STATE_EVENT(xfs_attr_sf_addname_return);
>>   DEFINE_DAS_STATE_EVENT(xfs_attr_set_iter_return);
>> +DEFINE_DAS_STATE_EVENT(xfs_attr_leaf_addname_return);
>>   DEFINE_DAS_STATE_EVENT(xfs_attr_node_addname_return);
>>   DEFINE_DAS_STATE_EVENT(xfs_attr_remove_iter_return);
>>   DEFINE_DAS_STATE_EVENT(xfs_attr_rmtval_remove_return);
>> -- 
>> 2.7.4
>>
