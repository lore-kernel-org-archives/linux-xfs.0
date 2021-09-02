Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1C66C4320E
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Sep 2021 08:58:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F0D7610C8
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Sep 2021 08:58:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244772AbhIBI7K (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Sep 2021 04:59:10 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:50744 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244583AbhIBI7J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Sep 2021 04:59:09 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1827OA3Y002842;
        Thu, 2 Sep 2021 08:58:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Y0/sulacwN+OnHw4Uom+E6OEqb1haAyeyJ7wtZcVaT8=;
 b=pmF91ZDvT3eoyCPCtdhVTwL8Z2BXxbNtyj8hK3YOSJBi9pz7i+VnR6iomEaw6RPE789m
 NLlVAp7Ya4Up6t3JgeoKqouBbnLDzK4HReTZ0fWg1lpFONo0/Kc0atDK3F3KM1Mld16L
 BBMi2pfdq+KHh+OxM03yjUhVi/XizthmUpriPC8A3/s2pFFM8vaH6bD8bRh6tLGakhtT
 XBvaHGfI7VZvftbPfFqm6AyCdjCPbZZwexHfNlIulA2ylSlfjES2X/ANQ33k7pmUbwfn
 +3HXBdviUQ7DO058E0B7rsIeDux8k16cvlkiev2bbrzfZrUBBcWxsxzN8PlLT2MGjLoA jg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Y0/sulacwN+OnHw4Uom+E6OEqb1haAyeyJ7wtZcVaT8=;
 b=kxOSFztc1/7SDoGdmQYHv3aelqXDVqzYLo0h+8V9uA23vzeiX+itRyqO/qnyTj0Hdi5n
 4Po4nSf9j9ICAL3Iaf94QdW+XYqDl36pMbNK+qbCh2A4f/fapzSmaZSZ6+FRSAFNWO5R
 nivRrnYoxMuYpLS5v7d6ZgDpuxU/tA5R4CPgUF23fZZBJH6qLruJrrIxg1qcZUsllWMQ
 XTISIQITxRo0uNl0Ww7O+lNtB1hNKH01XAlcYYNEssXJ1sbNkRi6MNvFKLQ3iQYmhYyM
 AWtfAGdeW3yeuuIwccBCr8aK4YogvwJNWTh/1Y3WWSS/+BMqcFyZgTESMP4JkHor32/z xw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3atdw0hxau-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Sep 2021 08:58:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1828uU64124126;
        Thu, 2 Sep 2021 08:58:09 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by userp3030.oracle.com with ESMTP id 3ate05fsxd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Sep 2021 08:58:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FLRtGxa/itLla3AgebfReoPwKF0gDAgAhDnxPIa8ZwSinJLfwjoPhG5hCEwO4YLLS76l0YdBeBn05yil98mzUsFHo/Hgj2uw76hFMZ/2G6Q4RXRl+WAB6HXWLT3YlCWSrtG9KvktRFkFd6+BnnqfJae1ISpQ6dtJ+Ck40uTSnD7nkaCDysEIDOrKfM8W+znSCnVo4Rtlk/kZhd+6qd19QWw2+yii62uW+Zc54yjd8WVeGgEGuVq5nxuh52y6uyTZ6anhuqC2GWSL65mW5zTrM5Ur3/m0sjXl+TeWkH0leroKCXK5xTbG6/i1cBS39XRHuuN/wqaeNeTrO1cbxDaSBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y0/sulacwN+OnHw4Uom+E6OEqb1haAyeyJ7wtZcVaT8=;
 b=TqvrxHWyu15tO1HC9WGMHmhCLQ9w5C3r5YybYffabSnBfMSelaG7G4G4DKGazcMffYYeAeEcHad0Z3qAaMSBGQ7pmDx0ILXzwFkoXzI2PaH7zA+E3h5zr2EZ+NXWsOaYlTyMsF90ik1gxgNBH/a1vaibMtB8MB6fEp/MP47JoDEUkb9vX8WMLIKul82rHhilXJvPKCX3jiIAzxf4FzsR7XhKVe09uHsRmT1SyqkMwTpgcux/XLucSjZmYPK/aoXMm5IT9A3FQHdVf9uOiLH3MYlbSLVQds2YMTmMeoBKf8HV1JWaVnHdVdlizkxx5+EGGCyfG/SN3s65et+8gQG7MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y0/sulacwN+OnHw4Uom+E6OEqb1haAyeyJ7wtZcVaT8=;
 b=xDAllNhk/FFNKDCstdFKj9PAFZ4NuEoIkJ3o1y1HSrR8RpIwobG4mXW4qoPKBAATWVFsja2VbKrddHow+6b7UlxnGVLDcaDwyXG2fguQstXQb61sTLtShB2qpYfnbKFzXpsIDvjTxupNXlTUgSR7KCZqp2XlBxi7LZqJFxtqdMU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3029.namprd10.prod.outlook.com (2603:10b6:a03:8d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.24; Thu, 2 Sep
 2021 08:58:07 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f%9]) with mapi id 15.20.4478.021; Thu, 2 Sep 2021
 08:58:07 +0000
Subject: Re: [PATCH v2 1/1] xfstests: Add Log Attribute Replay test
To:     Dave Chinner <david@fromorbit.com>,
        Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <20210901221006.125888-1-catherine.hoang@oracle.com>
 <20210901221006.125888-2-catherine.hoang@oracle.com>
 <20210901233647.GC1756565@dread.disaster.area>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <e9d7d12d-6d76-51c1-0967-b8d39d03e5b5@oracle.com>
Date:   Thu, 2 Sep 2021 01:58:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20210901233647.GC1756565@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0074.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::15) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from [192.168.1.167] (67.1.112.125) by BYAPR07CA0074.namprd07.prod.outlook.com (2603:10b6:a03:12b::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.18 via Frontend Transport; Thu, 2 Sep 2021 08:58:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da6c19e0-7dc1-451e-dc91-08d96defc821
X-MS-TrafficTypeDiagnostic: BYAPR10MB3029:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB302964C613120EBE8282762395CE9@BYAPR10MB3029.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PsNGlgGPl5WylkYCIM8XBUYcmcCLsR+BubmGkmRQljBb/ZE+LSvCKfD008VPJnMI/MJ6zqP0BAD3pG5AFJNMtbTIp3kehOSKmgXPJozJvWJxNXmcGDg15eWZZmh4K8e8GG6qY8vpR6ptYU2qgE/yt4Ahk6KryfdSLbUzpuJWylcrffbVpit1VmNZ6HouPjh6YpIwN885A94C+cFnYZcaE6BCXDr/YffDkuxVpSSkmcXgg+AUksdO5Zz6dOq2hBUcxKw5wr5JXP8ME7VB6AMSgL6L+zAFRAyk3PQ1EwFUNEI+yPBiF+m9vBjLD8XGBNXuhJ5/F5NOZIE2WXZkUbErx8UJjgqQgbKuZ4f2F2kwnzRmUmlMtJGrK99bRP1YqBBGAbCKyoXoiGlo4NQQVbheKepoAG5ErEMq/vGw1Cm1jnNwdoVLUVpnJs9GAO11ea7JT9Pc8iDk5CSiehbJLUXQKr2kKKU5OmvBHb8FdINln1wzgIyXdEfnBVwWuSN4Ho5O2D9k/eD6UNaIguxuxb9LvzcAv+Q2FNt1ApnqIHBiiSCm0oHsZth+qq11WmyZGBoumk3JUaKNUH+IWBQNrdGuddPIB8lCYv4nZ/Y2BVvQjw5ep59HkrmQ/D//fjSlcTzUty9Bf9B9bZ2iDGFspT7Ltxkm8GoTC3e/PEXv7K/7wLNr173iSmnKrkJyG2sgRZgxv/TxCYWUB5FQeRx9NgD1WKrAWT5J4qFcYrTZS+9AgpXRVPd5B9xlz135FTU2AbvzlDt2PblJfIxj9N/bLgziSdey0PrCMMGRJR6mi0HyClo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(39860400002)(136003)(366004)(186003)(53546011)(16576012)(478600001)(8676002)(66556008)(44832011)(5660300002)(66476007)(66946007)(26005)(2616005)(316002)(83380400001)(956004)(2906002)(4326008)(31696002)(31686004)(6636002)(86362001)(52116002)(6486002)(38350700002)(110136005)(36756003)(38100700002)(8936002)(45980500001)(43740500002)(357404004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RHppUWQ0cis5T2RhT2IyR2dUY0NvdHZ6ZjdqV1VmdFlNMmIxdmllaHhueHA5?=
 =?utf-8?B?WDkwdU96TjFKR3R6a3VxM25JVEtGZ3JOTExIckFWejE0clpYSG5uQk1TekhF?=
 =?utf-8?B?bWJ5cFNQd0toZVo4UldZUEdmRiswdkUxWW83cmZqMWIzS0tJU0xoVTNZVHVa?=
 =?utf-8?B?K04wci9qQXZoQzJaUko3NWJKN1BkeFZsZ3hhMjc2V2loNXRMNmZWU1RlWXcy?=
 =?utf-8?B?YmRqcnBMekQ0dTBGUVh3c3hETmtUaDFsVFBiTlA2UmtrQS9kU25XbWM1Q1V6?=
 =?utf-8?B?UlZPYnhna2Ria3VEYVdiMlZuR3Zib243U0xaRTdVNmFGY1lMdkVKanhHVGlR?=
 =?utf-8?B?UlZKN2t5OVVUYUV1dGxxaDFTQVFzTTRSd0FHcXA5cG9ZbFlRSloweDU0VHBi?=
 =?utf-8?B?aVdHU3A2S2U2ZktxMXBzeFFnOXdwSG1xVVNiSjVRNUNwUVZHRVdvbWFYNHFt?=
 =?utf-8?B?ZVBzUHllT3l5TzZiaWhaQlBhcEo3cHFLY0wzZU1pNWljeWRURVA3L2FoTXA4?=
 =?utf-8?B?THRJUXJNbDNvaXNZanRhMTVVbHZlYXRoaFhVM2YwVTVKRGIrcDRCTFdLdEQ2?=
 =?utf-8?B?UzVYWFI1WFhjY3gxdmR5cEFuWDdENncvR29ybmZWWU9IOTJINmZKY2JEellk?=
 =?utf-8?B?V1hVZEwyOG5uNmF3bGV3Yy92bVl2cVdKWkU4NDBSSEx1a3BybGZYV3BmZTBU?=
 =?utf-8?B?azZZa24vV1c2R1NGSVJkMDVzUWFsUlZvQS9iWGpqSWpGN2llNWRlZHVyS0pY?=
 =?utf-8?B?d2Ntek9KbEdtc29YRlBsbStKTENaOE4xbUorYUtPWWJzbHY2TE5OeUxBSUhj?=
 =?utf-8?B?Q2t4elYyQmwzbnQxNDBxL3VpcHZ3RDEvVjBja0s1bTloTHo0NHZWRFlZNmdS?=
 =?utf-8?B?bDlBd2ZoUFVVUmd0S25BbnBQMmZpbm9Kc1gxRUdKY2w5NTV3RTAwOG51ZFZK?=
 =?utf-8?B?SGdPR1pPK2pvOVliRTlHM1lYbmdXdFBMZnc5NXBnMkRmUEVsT0VGczFiQUg2?=
 =?utf-8?B?b2tNeVhybG9FTkdUK09vTDNCVXdqYXpMRlFXdlA5dHZNMDZ4THJadVNEYlo2?=
 =?utf-8?B?bmY4OVlMVWpSdHB1ZGxMNkI5eHBwc3ZkMjlRTjBmeFRUMExOQTZUNE9tNE56?=
 =?utf-8?B?YXh1Q1B1czlHSldkSGVaQnVvc3RLalpIZk5GbnR2eWZtb0pPbmR5Y1crczZT?=
 =?utf-8?B?MGJCUzFrdU91RlM3enlSRTVZMFMyandscE1oT05LTE5CcXpGSS9GZWtqN2ww?=
 =?utf-8?B?azNvK1lmSW5CMktGQ2hQZ0ZnL2hLRkIrZXV1WHhaTVB5VFYzdHo1ZlBnUi9i?=
 =?utf-8?B?TllSMThiWXZoRjlmTWhrUnk4VGRxeXVqQVZ0TXZQSFAwUFVMNVVLOC9CdW52?=
 =?utf-8?B?S0ZZUnVXbnJjb3c1WXd2Z2RwZTBCeHR0VmY4NmZncXlmOEpqa0w5WkdGWHg5?=
 =?utf-8?B?Y2djTk0vQ1NDVWdqcFVMN0tJK0E2WlN6bExLekVWQWhlMHRFV3A5RHgvMkZF?=
 =?utf-8?B?QlpIYWE1V3NCRHFQVjNVYWg2T0svbWU2QlIxU3g3QmMvSUNOdjhuS0dlYkY2?=
 =?utf-8?B?Z2xtY1BnL1Q5ZnJlSmJlc1BHN0tjUFI3cFh6ckZoMExWTnlRUE9nSE0reEdZ?=
 =?utf-8?B?U0M0cVpGeTlLeUN2UDltaEQrQWxQYm9sYmw5WkI3UnV0b2Q1S2p3bWc4dFJC?=
 =?utf-8?B?LysxQ3ZiNEd1TWtOZTJpWll2UDFncGRnNmV4Vkxac0dRd1lBSTQvekJwSVdN?=
 =?utf-8?Q?3Y353qzNpfaRGHZ/bQ9RFybYx8LBX5B/+UJo03m?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da6c19e0-7dc1-451e-dc91-08d96defc821
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2021 08:58:07.3592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w3uAAZunBCYNceF/MHVu6diDaCu5FavN+Z73mJDA4/MDQTlriK3+fbXJGf0iOF3pY8N8Nhu90S1SgD5OWIk0l+11gJcFoeGz9fdQzdXqKqU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3029
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10094 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 mlxscore=0
 phishscore=0 malwarescore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2108310000
 definitions=main-2109020055
X-Proofpoint-GUID: _TgvnYb7QDRXTr7W8fkuA1N0vuDRZ37m
X-Proofpoint-ORIG-GUID: _TgvnYb7QDRXTr7W8fkuA1N0vuDRZ37m
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 9/1/21 4:36 PM, Dave Chinner wrote:
> On Wed, Sep 01, 2021 at 10:10:06PM +0000, Catherine Hoang wrote:
>> From: Allison Henderson <allison.henderson@oracle.com>
>>
>> This patch adds a test to exercise the log attribute error
>> inject and log replay.  Attributes are added in increaseing
>> sizes up to 64k, and the error inject is used to replay them
>> from the log
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
>> ---
>> V2: Updated attr sizes
>>     Added attr16k test
>>     Removed rm -f $seqres.full
>>     Added filtering for SCRATCH_MNT
> ....
>> +_test_attr_replay()
>> +{
>> +	attr_name=$1
>> +	attr_value=$2
>> +	touch $testfile.1
>> +
>> +	echo "Inject error"
>> +	_scratch_inject_error "larp"
>> +
>> +	echo "Set attribute"
>> +	echo "$attr_value" | ${ATTR_PROG} -s "$attr_name" $testfile.1 2>&1 | \
>> +			    _filter_scratch
>> +
>> +	echo "FS should be shut down, touch will fail"
>> +	touch $testfile.1 2>&1 | _filter_scratch
>> +
>> +	echo "Remount to replay log"
>> +	_scratch_inject_logprint >> $seqres.full
> 
> Huh. That function name has nothing to do with remount or dumping
> the log. _scratch_remount_dump_log() would at least describe what it
> does (indeed, it is just scratch_unmount; scratch_dump_log;
> scratch_mount). Can you follow this up with another patch to
> rename _scratch_inject_logprint() to _scratch_remount_dump_log()
> and also do the same for the equivalent _test_inject_logprint()
> function? They should probably move to common/xfs from
> common/inject, too...
Sure, we can do a separate clean up patch for that

> 
>> +
>> +	echo "FS should be online, touch should succeed"
>> +	touch $testfile.1
>> +
>> +	echo "Verify attr recovery"
>> +	_getfattr --absolute-names $testfile.1 | _filter_scratch
>> +	$ATTR_PROG -g $attr_name $testfile.1 | md5sum
>> +
>> +	echo ""
>> +}
> 
> Ok, so this tests just the "set" operation.
> 
> FWIW, there is no need to echo test beahviour descriptions to the
> output file. Each of the "echo" statements here should just be
> comments.
Ok, we can turn the echos into comments then

> 
>> +
>> +
>> +# real QA test starts here
>> +_supported_fs xfs
>> +
>> +_require_scratch
>> +_require_attrs
>> +_require_xfs_io_error_injection "larp"
>> +_require_xfs_sysfs debug/larp
>> +
>> +# turn on log attributes
>> +echo 1 > /sys/fs/xfs/debug/larp
>> +
>> +_scratch_unmount >/dev/null 2>&1
>> +
>> +#attributes of increaseing sizes
>> +attr16="0123456789ABCDEF"
>> +attr64="$attr16$attr16$attr16$attr16"
>> +attr256="$attr64$attr64$attr64$attr64"
>> +attr1k="$attr256$attr256$attr256$attr256"
>> +attr4k="$attr1k$attr1k$attr1k$attr1k"
>> +attr8k="$attr4k$attr4k"
>> +attr16k="$attr8k$attr8k"
>> +attr32k="$attr16k$attr16k"
>> +attr64k="$attr32k$attr32k"
>> +
>> +echo "*** mkfs"
>> +_scratch_mkfs_xfs >/dev/null
>> +
>> +echo "*** mount FS"
>> +_scratch_mount
>> +
>> +testfile=$SCRATCH_MNT/testfile
>> +echo "*** make test file 1"
>> +
>> +_test_attr_replay "attr_name1" $attr16
>> +_test_attr_replay "attr_name2" $attr64
>> +_test_attr_replay "attr_name3" $attr256
>> +_test_attr_replay "attr_name4" $attr1k
>> +_test_attr_replay "attr_name5" $attr4k
>> +_test_attr_replay "attr_name6" $attr8k
>> +_test_attr_replay "attr_name7" $attr16k
>> +_test_attr_replay "attr_name8" $attr32k
>> +_test_attr_replay "attr_name9" $attr64k
> 
> Hmmm - all attributes have different names, so this only tests
> the "create new attribute" operation, not the "replace attribute"
> or "remove attribute" operations.
> 
> Also, why were the given sizes chosen? It seems to me like we should
> be selecting the attribute sizes based on the different operations
> they trigger.
> 
> For an empty 512 byte inode on 4kB block size fs, we have ~300 bytes
> available for local attr storage. Hence both attr16 and attr64 will
> be stored inline.  attr256 will trigger sf-to-leaf transition with
> existing entries.  attr1k will do a leaf internal addition. attr4k
> will be stored externally as a remote attr, as will all the
> remaining larger attrs.
> 
> Hence this doesn't test the following cases:
> - empty to leaf transition on first attr insert
> - remote xattr insertion when empty
> - leaf split/addition due to filling a leaf block
> - extent format to btree format transistion (i.e. tree level
>    increase)
> 
> IOWs, for a 512 byte inode and 4kB block size fs, the tests really
> need to be:
> 
> - empty, add inline attr	(64 bytes)
> - empty, add internal attr	(1kB)
> - empty, add remote attr	(64kB)
> - inline, add inline attr	(64 bytes)
> - inline, add internal attr	(1kB)
> - inline, add remote attr	(64kB)
> - extent, add internal attr	(1kB)
> - extent, add multiple internal attr (inject error on split operation)
> - extent, add multiple internal attr (inject error on fork
> 				  transition to btree format operation)
> - extent, add remote attr	(64kB)
> - btree, add multiple internal	(1kB)
> - btree, add remote attr	(64kB)
> 
> This covers all the different attr fork storage forms and
> transitions between the different forms.

Ok, so if I'm understanding this description correctly, I think we can 
just add a file name parameter to the _test_attr_replay function, and 
then modify the test calls to look something like this:

# test empty attr add
touch empty_file1
touch empty_file2
touch empty_file3
_test_attr_replay empty_file1 "attr_name" $attr64
_test_attr_replay empty_file2 "attr_name" $attr1k
_test_attr_replay empty_file3 "attr_name" $attr64k

# test inline attr add
touch inline_file
_test_attr_replay inline_file "attr_name1" $attr64
_test_attr_replay inline_file "attr_name2" $attr1k
_test_attr_replay inline_file "attr_name3" $attr64k
_test_attr_replay inline_file "attr_name4" $attr1k


# test split on leaf
touch leaf_file
echo "$attr16$att64" | ${ATTR_PROG} -s "attr_name" leaf_file 2>&1 | \
			    _filter_scratch
_test_attr_replay inline_file "attr_name2" $attr256


# test fork transition
touch fork_file
echo "$attr1k" | ${ATTR_PROG} -s "attr_name" fork_file 2>&1 | \
			    _filter_scratch
_test_attr_replay fork_file "attr_name2" $4k


#test remote attr
touch remote_file
_test_attr_replay remote_file "attr_name1" $attr64k
_test_attr_replay remote_file "attr_name2" $attr1k
_test_attr_replay remote_file "attr_name3" $attr64k

Does that reflect what you are meaning to describe?

> 
> We then need to cover the same cases but in reverse for attr removal
> (e.g. recovery of leaf merge operations, btree to extent form
> conversion, etc).
Sure, we can add a _test_attr_rmv_replay.  Maybe _test_attr_replay 
should be renamed _test_attr_set_replay too.

> 
> We also need to have coverage of attr overwrite recovery of all the
> attr formats (shortform, leaf internal and remote) because these
> both add and remove attributes of the same name. We probably want
> different points of error injection for these so that we can force
> it to recover from different points in the replace operation...
So you want more error tags?  Maybe one for the shortform, leaf and node?

Thanks!
Allison

> 
> Cheers,
> 
> Dave.
> 
