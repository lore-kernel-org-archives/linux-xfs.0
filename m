Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0E8FC432BE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 05:34:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3AEE61058
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 05:34:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241935AbhIAFfK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Sep 2021 01:35:10 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:12010 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232334AbhIAFfJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Sep 2021 01:35:09 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17VNaqcY019479;
        Wed, 1 Sep 2021 05:34:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=QvGYt8LOKe7qZDuETuBSAvqIHTyXMR6kJWEEBeCyPtM=;
 b=jF77nQqXNJSehDE0JozahXKvRX2Km+3MXvmQLW1il/YUxGuPKFfCzoQZzHr50GJqGody
 Sy0fplNoGYIUlecEG3zQ0HJKKeVWqs4O4tlIDl44qsyNVOfJGP8g+GJNs6QRvAprVT+o
 t+EWtIq7W9x2v/2+exk6nv5du+XwD0t5miIbqup6OkiOG8ftWvON+az/roMkYs+NxcEz
 iZs/6yYx0jdATHgBlnCRMgowNlsP6AZ2hPpPZr6sqjm42JW/KWgTgTpSgYvi51wTzB4w
 3z5UCJTX/DmG6Fz8CPPz0XV4OGtcPnUJzhsrbfiOVj5DK6PSbnPFS1hx9moWylPPkoTd UQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=QvGYt8LOKe7qZDuETuBSAvqIHTyXMR6kJWEEBeCyPtM=;
 b=Zww0lOppcTo2p5zci3tZJX+Rs5FT6PVJ5tk0af7IGFO26HBgFL5YS/sKrCEoc8+hRBj2
 LFgimJY3MsgKq99FjLwz/qT6de6j+22aq/gzk3JwhxCa4Mbz4rSONGiCDDHi1wA15E2H
 Anrz11ssmmWsHUqm5WHs6y3CC8ZlMXUp8wrAJYkw3wf7VZaXLcxb4cYNCWaMS5Ao7k4r
 rSW111wd4NPqm8n+oVVydp4sJz0tsRkxXVWba1+3LuZZpcfZ89ha2dExJjSqpRvRFcfz
 Ow8r6JCG6g+yCFH4Z596Ld7gi0Q5XJzy2bUJeBxyL5KxOoA0+3yfU4Dm5BBDwMNhkSdU RQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ase02bd9a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Sep 2021 05:34:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1815Pm0J157187;
        Wed, 1 Sep 2021 05:34:10 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by aserp3030.oracle.com with ESMTP id 3aqb6f674h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Sep 2021 05:34:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ALYQAjWroUEwAMeHlr0LV9r1ZoxwxjHvL+dTyUPtfAXRLoUZbp8cV2l1ija+lIFko3RG1zi3Q3o9tsIEuzLKj8MvtYz1qQZ0caJU7LG74ejeCC2/QUbtxye+0y0vK7Eu2ZUPPnVv0JxMBQVYcnmGFD9APNm+0Kg8PntGoexSDyMco1HGQyub1h662CNFYOg1aHgCEl7fBx+EgxuLdkJPyMmtC7DCWKa/t8VzuDxD9K/mTiwo+nJzjpRdAaESzW6aY/UxeH97dsG31vcNNIe1EUNF4Kv6zy6bB3EXj1i3cYcEBElVTUdrUmYJ5EhnJQpbcIYj2qvm9o1Qua+oA834zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QvGYt8LOKe7qZDuETuBSAvqIHTyXMR6kJWEEBeCyPtM=;
 b=OdbVnxPrJyV9Gxs62u5j6Pbs+oQjduCa/tktCfZdZTfFtBBHNnT7nryr5Un1VYR5oWlJnxDWICuTz3IcQPESv0acZDJ/aluDEbxKNOPrUaLHqGtITITS9e67h14N07KoAQyuK9L3sBZIj79KQHuNfiSt4TMadStZbqU011TtnW9BZNSrHT2Iif3JtochVuNl2XUK2IQdBKMbU3jPKsQb/UVpD3nJEKtdbwquOUtaAgg1MLPwO72hmDQbt+4uSdKoFOA0pzPxwBfPE0KtCwTKurZLy0UKrpCko2yS8TrwHYBcLlk7wT7xUo/2HKFYHCR8TXkrRY1njpKI9T9zYud5Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QvGYt8LOKe7qZDuETuBSAvqIHTyXMR6kJWEEBeCyPtM=;
 b=bryxBhxt0WOPrvIuQSgDuF0mLm2xi/P6m0v+X44E85kwwC/uEmZGbFBUC+jCVtanFWgk8v7T8vDs5F2siV3tXL67eBqCItqIGJs+p3ttSEw/lqtNcO4EPIclA07X8cch6fQ7LhEmUGxk9cQ1p0izMfHCZ651rnCoHIZ0DG/7UQk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3109.namprd10.prod.outlook.com (2603:10b6:a03:14d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Wed, 1 Sep
 2021 05:34:08 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f%9]) with mapi id 15.20.4478.019; Wed, 1 Sep 2021
 05:34:08 +0000
Subject: Re: [PATCH v24 06/11] xfs: Add xfs_attr_set_deferred and
 xfs_attr_remove_deferred
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210824224434.968720-1-allison.henderson@oracle.com>
 <20210824224434.968720-7-allison.henderson@oracle.com>
 <20210901034754.GW3657114@dread.disaster.area>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <67b6c67f-8036-9eec-d55d-a6c4c8d8b4a9@oracle.com>
Date:   Tue, 31 Aug 2021 22:34:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20210901034754.GW3657114@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0228.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::23) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from [192.168.1.167] (67.1.112.125) by SJ0PR03CA0228.namprd03.prod.outlook.com (2603:10b6:a03:39f::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend Transport; Wed, 1 Sep 2021 05:34:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7409a63-f307-45f5-b2dd-08d96d0a1ef6
X-MS-TrafficTypeDiagnostic: BYAPR10MB3109:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3109EC96EC6721DBF40C2DE895CD9@BYAPR10MB3109.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Os4i//GcW1yqJtw96O3mjg51qsdu1ya51jUfVOSUUuCpXRVaY5qLN645Loaytsbjd6V40gLWRwcmjQ19duO2MoJ9P5cK4QW7eEaP8s0Ehdt9tSa5YkCQBb+XYN9nkDYrDRLGAttZw3XqBwk46DTzMxij/D8oKlikEqWxEsosClbsBCcG38cd0A/O0vJfwwMgjSHtT4bu05RKQmwyRAUsjdTsoLxPEjci5hSlVEWLn4DEbATSQlyDoExF8NVzQSmND52XamEsCbRxdK8nG9UdahUmHYrFzBxOVFJZRTAI2dmCris0J21DXXFsnMBmyZbN5n/2WIGP/0YrzvqrKHfddEOgdPDl5pIO6Y0ntHYy29kNOrMzfkL6hSfv6USYHfPeA/alpp4FIFYdudt5zJRfANpDhLE2EcYcBkGx5NlaRgN+amoERjvBaoTAu3HFQyO08Hrok3BkPiLiVuv8NXcwpmEiRi8zuPUIcPajHo3aSnKxL3Xx4yjXdjT1WdMGSnJ1FCBcLyULvX3dWZMiBXn7CHsR0dbJ4SnLtsx4SJUec1cQ4nMkJKVOba5pshx/GGCaav6sfyAdsZmZk893yRHa8ZP37ghULWFGzlhzuQcBkxwJmdxiPwAZhJuexl8mtKrasV9UBMNBCez1FSK7EN394xJ9cvHL1my+baNukFlQzihJROEiUA2wAqs2okJmHhxTMW8yLhSrjl6cuHof3mnRgpYJvBjkESFXP+Ydkm1hr7TyDF2YTZsYRhJxatyWpTJiLUXPBCosJriDLujeER2wIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(346002)(39860400002)(136003)(86362001)(36756003)(31696002)(16576012)(316002)(186003)(31686004)(53546011)(6916009)(26005)(38350700002)(4326008)(44832011)(2616005)(2906002)(66476007)(956004)(5660300002)(8676002)(8936002)(38100700002)(66946007)(66556008)(52116002)(6486002)(478600001)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UGMxQy9zUk5ReGhySjlMbnBRb3prRlpaMkNYSjJmMzhsdndOY2E4QjhwT09M?=
 =?utf-8?B?YU9RY3NEL09Qb1hObGtSVDFWK1FwaGsweTR3MXpZREdOS3NDWjE1M1RQRE9P?=
 =?utf-8?B?SzlETzI1T1MxYVBRZkFDa1lmQWJtellUTU9HeU9pa0lOQkxLdnhSZFdIenhl?=
 =?utf-8?B?Qng3RGpPRjdXb05jODBhVFRjRDdhY3dOc1pOZmFPZ3dhZk1HMVRXd29kYjc3?=
 =?utf-8?B?QXpSSVdUSFY4dS9HSHlMS2hlTkJRVTlJWFlzU3Z6UUFhUDhxYWdWTWVFNjRZ?=
 =?utf-8?B?cGo0SjFURkk4WnJBcnh4UXhwMHlCQ05WSVdGL1Jadzd1cW5IQ1N2WlczdVBs?=
 =?utf-8?B?MU9xbklSVUdzMzRlVEtMby81eGJEdzhVVERHNVFYNDhabEwrUUxBcFlzOFRW?=
 =?utf-8?B?bDBwM0xHekI3dVozNG1yZXZCYXRBenQ0bWlBazh0QzBqODZwVHJLRGtlVnpD?=
 =?utf-8?B?bnY5VnN3TlNtN3JqTUg5Ti9ob01HOUZ0N015c0IreTJGZHlsckNGSFdXeCtU?=
 =?utf-8?B?aHNSaWxIWk9WY1h1SytJUG9ITXRJR3dvQk56YlFSQmNreU9GWUsvYlppbWJv?=
 =?utf-8?B?UHBzdUhWYWtrdzhFM3lGLyt0VHVPNHRHTDRiUjJRWFVZN0xCRFRFN0I4R1Iy?=
 =?utf-8?B?YjZYWGFMTmE2UlhaZG5ha0RFSkdqNDJvNVlMUm5UQnV1YTdVYkNqQ0pFbWxp?=
 =?utf-8?B?R2ZQeXNxRVdERVVmVWtOMUNkTlRSOUdsSWRJSnRiaTBFQU1qUG1pelR2RUlF?=
 =?utf-8?B?K1hYb1Q5cmFUaE5MTVE0VE1uMDg4MThNY25WYkN1K1pad1V5YnpwMEI5bjF1?=
 =?utf-8?B?QTYyL1I0VmQrTUdKbmJoZjlWcWdDUis3cjZUbFhJd2lMa1krOFZDQ09BK2FU?=
 =?utf-8?B?NE1JM01NbjRiT2o1SVRjMFRVRy8vSWNhZVl6V242RVd0UllkYmdnT1NLWWsw?=
 =?utf-8?B?MGlBNUJXTDc0Tk1HaUs0UW8xNzJUazFVQ2FkSytYb2p6cFNVN2NnbVdQNFZI?=
 =?utf-8?B?Tm9nU0dFQ0pKVmRoRitnSGpoNnAyMUVmQlVIQnFZNElvQy9WMTAwQjVNTUty?=
 =?utf-8?B?NllkL1RrZEJ5NXluMDYzNmtDT3lVb2RyaFJibEZrVERTT3NTbzAwWVFoRSt0?=
 =?utf-8?B?bHFXbHo0VXg3c3VhdzJsS0t3ZURUK01Uc01tbkw3MUJKTUtuZXNiK21Jc1p6?=
 =?utf-8?B?c2NlZG9UVEZQb0p4SGo4ajl1Rk94UFpkRzUzRGZyQ3ZpNXBxejQzUU9ZZ2dE?=
 =?utf-8?B?NDhIVC9RcE81aVBSR1FuWG1iTHVGS0hlTTVBdDBoYzkxT3ljcXdlcEhuM2xj?=
 =?utf-8?B?aDBZSTZyMFZYVlRGTnhvNWhEdkdYWTErREpSaVpSbGVoRXBJL0xjMFh3cUxj?=
 =?utf-8?B?SlBhdGtSWTNmSUMwL0dqdjlQWFBuRGRVT2FWU3RaWnpWVG5idWxOUWxjZHBC?=
 =?utf-8?B?Z3RtUnE5WmtSVlR2cFdsQUUrL0RVcmdhaFFpbXF6SWljbFdJTmc1enpoQmJs?=
 =?utf-8?B?UklsdVZQTzVhN3NGMFB0elNxMFVmekplT29LNHlLM0NhVHZXcXI3bE5rQU9X?=
 =?utf-8?B?Z2ZmS1BKUUlrbHk2V3h6c1l2ajVGd1JoNHllTEZ5NGVIWWlQWFozdkp2NE5F?=
 =?utf-8?B?eDZaRWU2NHJ3dGtyUVBpaGxuNlFuZVZUUkhsNzVDMC9sVkRFRzA0TGlFbkVZ?=
 =?utf-8?B?Y1pZenc0SzBmZ09rMDVGb0FpdjBTVG01eHBpZUhRSWdVUEpPWVZYUS9DREVF?=
 =?utf-8?Q?WjP8JUE/WLlc8pDr6LMEbJ6BT8KPRnSXnEcp80T?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7409a63-f307-45f5-b2dd-08d96d0a1ef6
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2021 05:34:08.7226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZasP43XxIN80v4YsKi5wIFK6cIl8ueNxDN8hjduJilCXHodIcnAVVVmlgik/QJojiH6WcIFaZw/ercRedq7yqda6jIWV7b8PX/zWdDpVH0Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3109
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10093 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2109010029
X-Proofpoint-GUID: ItAXgKFv9-wRTbzy1E5YEkiQwi7Vq1ku
X-Proofpoint-ORIG-GUID: ItAXgKFv9-wRTbzy1E5YEkiQwi7Vq1ku
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 8/31/21 8:47 PM, Dave Chinner wrote:
> On Tue, Aug 24, 2021 at 03:44:29PM -0700, Allison Henderson wrote:
>> From: Allison Collins <allison.henderson@oracle.com>
>>
>> These routines set up and queue a new deferred attribute operations.
>> These functions are meant to be called by any routine needing to
>> initiate a deferred attribute operation as opposed to the existing
>> inline operations. New helper function xfs_attr_item_init also added.
>>
>> Finally enable delayed attributes in xfs_attr_set and xfs_attr_remove.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> .....
>>   
>> +STATIC int
>> +xfs_attr_item_init(
>> +	struct xfs_da_args	*args,
>> +	unsigned int		op_flags,	/* op flag (set or remove) */
>> +	struct xfs_attr_item	**attr)		/* new xfs_attr_item */
>> +{
>> +
>> +	struct xfs_attr_item	*new;
>> +
>> +	new = kmem_zalloc(sizeof(struct xfs_attr_item), KM_NOFS);
> 
> In transaction context here so we don't need KM_NOFS.
ok, will remove

> 
>> +	new->xattri_op_flags = op_flags;
>> +	new->xattri_dac.da_args = args;
>> +
>> +	*attr = new;
>> +	return 0;
>> +}
> 
> Why doesn't this just return the object or NULL on allocation
> failure? What other error could it ever return?
I had adopted this function signature just to be consistent with other 
*_item_init routines at the time.  Mostly just trying to be uniform, 
though they may have changed since.  This patch spent some time on the 
back burner while we were more focused on the state machine refactoring.

> 
>> +
>> +/* Sets an attribute for an inode as a deferred operation */
>> +int
>> +xfs_attr_set_deferred(
>> +	struct xfs_da_args	*args)
>> +{
>> +	struct xfs_attr_item	*new;
>> +	int			error = 0;
>> +
>> +	error = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_SET, &new);
>> +	if (error)
>> +		return error;
> 
> i.e.
> 	attri = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_SET);
> 	if (!attri)
> 		return -ENOMEM;
> 
>> +
>> +	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
>> +
>> +	return 0;
>> +}
>> +
>> +/* Removes an attribute for an inode as a deferred operation */
>> +int
>> +xfs_attr_remove_deferred(
>> +	struct xfs_da_args	*args)
>> +{
>> +
>> +	struct xfs_attr_item	*new;
>> +	int			error;
>> +
>> +	error  = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_REMOVE, &new);
>> +	if (error)
>> +		return error;
>> +
>> +	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
>> +
>> +	return 0;
>> +}
> 
> We really should not use "new" as a variable name. As a general
> rule, the common pattern set by this file is that xfs_attri_item
> objects in a function are named "attri". Just because it's newly
> allocated doesn't mean we should use a different convention for
> naming xfs_attri_item objects...
> 
Ok, I had seen the pattern around and reused it.  Will change to attri

Allison

> Cheers,
> 
> Dave.
> 
