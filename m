Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B35FDC4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 09:02:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 936C360FC0
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 09:02:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233919AbhG1JCU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 05:02:20 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:16654 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234963AbhG1JCU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Jul 2021 05:02:20 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16S8qdsE004091;
        Wed, 28 Jul 2021 09:02:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=D+4n0mphpBYmgKsIjg9p4DAFs0rI4/YUugtHCLMCpmg=;
 b=Fvn3+FHTa+hKD90CHma9VmoQzkCci0oj9yoE0NrdB4PZxPqpO2Do2kgwhzFjogwiNoJ0
 0tmSlU6zIUPkBiV/4E/53nmN+oQZnPWIRkTDY29SY9LfI9gYZcBbRdiBIGSPpn2npMmG
 8Nc5R6Pe/9IGUoyf3nR3Pia4kucXsQ3zxAxsX7qG19o5Bgo/rOjFoyx2icVDIpZlh9iK
 BlEs7N1xbYkBdEPpvwcOYPHgkcIHIhymNy3oVLnwrkZ3WM6NGvWr3jpHpi5AE6aHpgX7
 5joYgB0a9Syu9ct0kfeNHuxM7FbHdrt+dznWKfGH9RavBo6TBP9lSL7xB/Wozpbgz338 Tg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=D+4n0mphpBYmgKsIjg9p4DAFs0rI4/YUugtHCLMCpmg=;
 b=FagT7PB+v6n9BjyVTHoyRuFao+YxCZkkCHt5n0BvkCoZgGjkzfWSum8/lGxWBK0a7cCC
 1U4aQB/PL0mPDIgre2zo1S7CVTUgVw9C22ILg883bEW9WRdO3Chh4UyKcoG++Tva3ma4
 /XOyksvmLn9HkmwHozYaAkPuU1OGHg1LtTX7ljXR4wkV1E+l2Z9A2bmyZbLCoRcKM27W
 3Hf9iJNtRr9ZBdKbXGscF9QqTH9SMw1E9Y9nOQpzY8I8KEbtRYpDdQt4NUVwXnKVvLpO
 A55G1O4jEpoMWX2efPPOQALfIZ/qWunM9r39T4xpAUCPaaeAUsqAOceI8iYuaCxzSOkL 9w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a2jkfa70y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jul 2021 09:02:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16S8xWKc046402;
        Wed, 28 Jul 2021 09:02:17 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by aserp3020.oracle.com with ESMTP id 3a2349s9ka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jul 2021 09:02:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ROPPmjmbWvMlkC0yF+zf4RuVjeRB50JuYqZwL3/Hh9y5v06HhEUNwBFwWjRmR2txMf6EY54qSlFdDJPGHT2X6uCLYHe2ZsXqzAAyvNRVhX9m9ZpKKeQls9EEc3HGV9Jy2jmFWs53zsT+TUfe/u2ByB4ZLLRm2NHCf/AlP8TVd4RRkI0fvzb8DzFDEW2Pd2tGxsztqHVvEBHyXumZ1OKQQuShplDD+ZW5HwQ7du4ZN9GohoHjLzUjPby745YZI67g2EDSeSCv8cyMqgBPko4TyOXFhE8OcUIWvRjcqmzsdpyuHPduuWgwPmdxkeQyIbXA1x3ZonZFqAlI92vDbu+3LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D+4n0mphpBYmgKsIjg9p4DAFs0rI4/YUugtHCLMCpmg=;
 b=I5tW8OHB2l8TZeL5eGdvIq6ZpXjViGAMs5+DjElSXWa+gmfki3kzkcWczhd/8Ou6aPxBYlsGjCwtur3Sen6zojUrRr3htN6N/XXBfmnyi05vy7zgc0iRxUCsm+9oeHecLxt/lofEsj5YU4gNghl645lsD7WeDs4DK+W8Iu5f9DLg+pGWYD9KcqxXIa7miotBLFZZyfhZIIO5FzmMvHx6ZzHcwTj+t+5Au8MCIiKF1gMZhJpGeKbt9k5NKqOdMjw/15yqWkNQn/+myErRABV9E8gejvo1vYljSorBImwDw4R7h55kRhtRDbWp1ZrZGJpEmiu4Hx6PFjMCYO/AF72+VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D+4n0mphpBYmgKsIjg9p4DAFs0rI4/YUugtHCLMCpmg=;
 b=eTM2FzNz6XoTCIHYT9AXBsiAAP2748V1U/paiYI1lztJ3b6K8jWoEGcdMWjv+q67kDuhs/2H93E9S9lA9Tly/kv9mzhkkgX57GC1BrUyqv/cY+xE1VwPb+4U9ZRWil819esvNJkm3tWwUTRhfEXK9RCbzSvOg17AYyUF+uTtZO4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2966.namprd10.prod.outlook.com (2603:10b6:a03:8c::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Wed, 28 Jul
 2021 09:02:13 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%9]) with mapi id 15.20.4373.019; Wed, 28 Jul 2021
 09:02:13 +0000
Subject: Re: [PATCH v22 02/16] xfs: clear log incompat feature bits when the
 log is idle
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210727062053.11129-1-allison.henderson@oracle.com>
 <20210727062053.11129-3-allison.henderson@oracle.com> <87a6m7gc02.fsf@garuda>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <ad2ce7f3-f5dc-016e-64d8-65b5513da767@oracle.com>
Date:   Wed, 28 Jul 2021 02:02:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <87a6m7gc02.fsf@garuda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0002.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::15) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.166] (67.1.112.125) by BY5PR17CA0002.namprd17.prod.outlook.com (2603:10b6:a03:1b8::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Wed, 28 Jul 2021 09:02:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b827cc10-4c99-40ab-75ea-08d951a66404
X-MS-TrafficTypeDiagnostic: BYAPR10MB2966:
X-Microsoft-Antispam-PRVS: <BYAPR10MB296642577B82A6605964732C95EA9@BYAPR10MB2966.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oy8W5dTkL9loxmsgUlriGmdNems5tAXwf8RegzT+2uVxWd+V40LPdVnU2PfP7o8leGIavkU2pCfmS3pFELUcaBRWE9mARMkzR9/2p6BYmlUpCploHhbFcvMUMupok+eCBCM0Am0DwVIeArA9hkv3zM1o4LK9XQEC8SITraa2A1R5B25gY2I9HfYZvcnlouEaUsALIFkPKuHD4LAOsCojYb/rjPLYn9Dvk1bkdhsLiu+qRqmNK1SOayq5V5FTrv4DAQzmvLbtr5yfwle4X+UQRIn+ZUxE9ocIOMH02AreZGsMKZlb/E/Ko56Gt7fL797kAGQYmGT1oOPdPGczUf+cOcKbJYsgjgHzoov8Zx4xE09cjflSrQAgNKNr4UQZVOcLr5h5OwBNKoUbrx7mXlafdtDgpFrfcPHw6qfw1RJpcbq7/yBkpi9QOiqDpSzg+ibA0ZwxnFNZavsosHUuS/I5I9vlc5Kz4TbUjGTX/BfYEAyPgNamA0+dBa7ooP5eRljgoZgZqq3TwCwPf+wa+vwB39+SuGp8FI5Y8B72gb7wkT4LGYWWi8fzYmuKva4qC9h9WnIFKpnJE6L37St2GC4ko8i3Ps95GXwC+o1gtpECJvi3LXFKlTKgfXGhMmq8RiTbIiOhzSEvsywc0jOPMVDxLXbc1+3b+vTLuNhYOoEf3gOTxkOlT3TyUIyxOV9uHZY/dsAgyPOSo6NPctCOdhNoMMCLSp7/Foz9f+zqTkU9PpXK7crw5zQga7Nz8IeJgOWxpOIjU7HZagVKSYA0MbObbg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(6916009)(38100700002)(26005)(6486002)(52116002)(2616005)(38350700002)(316002)(66946007)(66476007)(66556008)(83380400001)(5660300002)(2906002)(508600001)(956004)(36756003)(186003)(16576012)(44832011)(4326008)(8676002)(8936002)(53546011)(31696002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WnlyMEdxSDRYRXM0bVhqVmVMMzFVemEvcHRncW93ZFBNU3B4Mk1NZzlRVzls?=
 =?utf-8?B?YlNWd3FvdWFDK3RuVm43R0ZtTm40TTVEajBPNUZYNjRiMjJReDc5Y3hoYnJ5?=
 =?utf-8?B?RVRpamxjbU1MVGZscmNFUEZmSVhHWGNIbVM5ZFVtVXNkR3IwTFlHMEdDSWQv?=
 =?utf-8?B?akprL0p3M1JiZmdNV3JQWUtPWWoydndRM0l3UC9LNWJ2TWI0VkQ1dUZjN1E0?=
 =?utf-8?B?aEo2U2RQRWVsc3R3SzZXSXQ4RktIdXQyWkFqWDFWcEY5YnJQQXpMY0xjV0l4?=
 =?utf-8?B?emRLTkpiU21tL3prT0Nvc1FvZkNYSDNVUTVGRGRkeVROcTYvU1lUdHVsUExF?=
 =?utf-8?B?U0l4RHdSUDkveEM0STdEb1dtZnhpbDZmczU5UWY0NnVnR1Z5TFhOS3NNM0ps?=
 =?utf-8?B?UmdJUWpUUXowZSt5Qm1XWXk4OU93Tnp3dy9HT29rVmY2Z0hDa25xWjEwN09m?=
 =?utf-8?B?NG9qYnMwZGhCeWlvQk93VWJyTzMzcUFLY3FlN01GUnNieUZtS2luU2hrY3Zi?=
 =?utf-8?B?SGxldXg4cUtPZkJYQXRPMFFlSDV3WVZNNmo1dGNzaGU5azZLV2lQS2FENi9C?=
 =?utf-8?B?MForbjNFZW1HY1o4cmVFaVNub2lPYmVtellmcFpxMkhodXYvVGI3ZW1kb3pq?=
 =?utf-8?B?cXY3UGR1b256MXlKa0NDUHN1V1hOKytUUTlBTXBRLzJEQ0czc2RGbDZnSkVP?=
 =?utf-8?B?VVc0OTZ4ejBMTlM1NDZLaWdGajJ3VXA1NU8zQW5lYWQ0OGRaMVhXZmpHeGx5?=
 =?utf-8?B?VWdhSVV6alFDVkNIQkZJSkxTTkZ2clcvWGdPQXVyTGwvSkFCcjBJQ3NvVS9C?=
 =?utf-8?B?Qm1wWEJ2K2NIZVluRlZDdEJlbjhoZ2Y1TExFdmZIS2RUdVg1S2FBb1ZMMVpF?=
 =?utf-8?B?ZmtLSngzNmNyditPbjFINXRTTEtHNlduVmFYdjRmKytrTy91WDBDM3RTN24y?=
 =?utf-8?B?YlgxNDFPbWJFVjlyMkNCZmY1RFB2ZS9UVFFNb0E3SHFUMmVJTzg3bTBObGQz?=
 =?utf-8?B?NC95eGNNQXhYK2dzOGRYQVQ3TS9Qc1BxaCtRbFRIMkp3VThSbEwveEtmWVVp?=
 =?utf-8?B?R2ZqanhGenNwN1duUWVSUXB2U3lRMXBwN0hxOFZXUnZqMXNHbHlJL0dMQWFX?=
 =?utf-8?B?T1NnV0ZNSThoOXNoMkhiYmp5Vk1NTlVKdFNnNHkzV2pNVWpsSno5eXN0cHpp?=
 =?utf-8?B?NlVERkVNRHExRTNHckJKMU9VNjJDOG42NTduMG16Tnl5RW5ydFZyNWo5azFz?=
 =?utf-8?B?bmh4K3A5d1pvaGY3QnBIbVlsTkpJbnVOL25QSXhPUWtXOGE0MkpBMFVmczQv?=
 =?utf-8?B?eVk4bzNUN0pwT1cwRDgxUFV1T1BUR2pmVVRiT0d2bThrY0VMS1VybmF1akt2?=
 =?utf-8?B?ZzQvUHZxYy9tNGx2N0FxbXljT0ZEcmNxRDQ4ZDZKMWVtdXh3MmZ0cU1keVpi?=
 =?utf-8?B?YmF0eDA2Mk00SDBYK2Vsb0RKNVBYRmN0RzhPelpmOXNvRStNT3BUWUNRVDhF?=
 =?utf-8?B?TWtVcGdpeHhpS1FzZW1UU1BKQk02ZjQ1bTE4bHI1blJiYUhTaE1lcVF4dmI0?=
 =?utf-8?B?L3pGL0tNRnhZaWNTbHFHeW0xL1MvMmZTazVVMGZ0eWIrWFU4RlQvVDFmckRW?=
 =?utf-8?B?S1Q1QWMwRTVnYWFPT3JzWUg3U2RvVlQwNE9FR00xbUpUa0oxMERiMC9GU0E3?=
 =?utf-8?B?YllZKzVjNU9aVHpEaVJHeXBKMGw5ditFa3JteXBuUERCNkprVVlYcEh1ZVJw?=
 =?utf-8?Q?oOT8qCItCI9ACtHfh6NN2kXSp8JwT9ku01v9sTj?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b827cc10-4c99-40ab-75ea-08d951a66404
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 09:02:13.4877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1DYt2wM9WqYnNv2i/W5Sh7a4qz89wvp0KulM9nhxz2qakfj+uMzY6avCpubm9lBZQJOVImn825BuzmLibzeVg8WRKSuu22VV+LkHbCntZfQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2966
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10058 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2107280051
X-Proofpoint-GUID: p3o3lu-o_d1jZsSf97Zf9lbEamcVM1rn
X-Proofpoint-ORIG-GUID: p3o3lu-o_d1jZsSf97Zf9lbEamcVM1rn
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/27/21 5:46 AM, Chandan Babu R wrote:
> On 27 Jul 2021 at 11:50, Allison Henderson wrote:
>> From: "Darrick J. Wong" <djwong@kernel.org>
>>
>> When there are no ongoing transactions and the log contents have been
>> checkpointed back into the filesystem, the log performs 'covering',
>> which is to say that it log a dummy transaction to record the fact that
>> the tail has caught up with the head.  This is a good time to clear log
>> incompat feature flags, because they are flags that are temporarily set
>> to limit the range of kernels that can replay a dirty log.
>>
>> Since it's possible that some other higher level thread is about to
>> start logging items protected by a log incompat flag, we create a rwsem
>> so that upper level threads can coordinate this with the log.  It would
>> probably be more performant to use a percpu rwsem, but the ability to
>> /try/ taking the write lock during covering is critical, and percpu
>> rwsems do not provide that.
>>
> 
> Looks good to me.
> 
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Thank you!

Allison

> 
>> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
>> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/xfs_log.c      | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
>>   fs/xfs/xfs_log.h      |  3 +++
>>   fs/xfs/xfs_log_priv.h |  3 +++
>>   3 files changed, 55 insertions(+)
>>
>> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
>> index 9254405..c58a0d7 100644
>> --- a/fs/xfs/xfs_log.c
>> +++ b/fs/xfs/xfs_log.c
>> @@ -1338,6 +1338,32 @@ xfs_log_work_queue(
>>   }
>>   
>>   /*
>> + * Clear the log incompat flags if we have the opportunity.
>> + *
>> + * This only happens if we're about to log the second dummy transaction as part
>> + * of covering the log and we can get the log incompat feature usage lock.
>> + */
>> +static inline void
>> +xlog_clear_incompat(
>> +	struct xlog		*log)
>> +{
>> +	struct xfs_mount	*mp = log->l_mp;
>> +
>> +	if (!xfs_sb_has_incompat_log_feature(&mp->m_sb,
>> +				XFS_SB_FEAT_INCOMPAT_LOG_ALL))
>> +		return;
>> +
>> +	if (log->l_covered_state != XLOG_STATE_COVER_DONE2)
>> +		return;
>> +
>> +	if (!down_write_trylock(&log->l_incompat_users))
>> +		return;
>> +
>> +	xfs_clear_incompat_log_features(mp);
>> +	up_write(&log->l_incompat_users);
>> +}
>> +
>> +/*
>>    * Every sync period we need to unpin all items in the AIL and push them to
>>    * disk. If there is nothing dirty, then we might need to cover the log to
>>    * indicate that the filesystem is idle.
>> @@ -1363,6 +1389,7 @@ xfs_log_worker(
>>   		 * synchronously log the superblock instead to ensure the
>>   		 * superblock is immediately unpinned and can be written back.
>>   		 */
>> +		xlog_clear_incompat(log);
>>   		xfs_sync_sb(mp, true);
>>   	} else
>>   		xfs_log_force(mp, 0);
>> @@ -1450,6 +1477,8 @@ xlog_alloc_log(
>>   	}
>>   	log->l_sectBBsize = 1 << log2_size;
>>   
>> +	init_rwsem(&log->l_incompat_users);
>> +
>>   	xlog_get_iclog_buffer_size(mp, log);
>>   
>>   	spin_lock_init(&log->l_icloglock);
>> @@ -3895,3 +3924,23 @@ xfs_log_in_recovery(
>>   
>>   	return log->l_flags & XLOG_ACTIVE_RECOVERY;
>>   }
>> +
>> +/*
>> + * Notify the log that we're about to start using a feature that is protected
>> + * by a log incompat feature flag.  This will prevent log covering from
>> + * clearing those flags.
>> + */
>> +void
>> +xlog_use_incompat_feat(
>> +	struct xlog		*log)
>> +{
>> +	down_read(&log->l_incompat_users);
>> +}
>> +
>> +/* Notify the log that we've finished using log incompat features. */
>> +void
>> +xlog_drop_incompat_feat(
>> +	struct xlog		*log)
>> +{
>> +	up_read(&log->l_incompat_users);
>> +}
>> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
>> index 813b972..b274fb9 100644
>> --- a/fs/xfs/xfs_log.h
>> +++ b/fs/xfs/xfs_log.h
>> @@ -142,4 +142,7 @@ bool	xfs_log_in_recovery(struct xfs_mount *);
>>   
>>   xfs_lsn_t xlog_grant_push_threshold(struct xlog *log, int need_bytes);
>>   
>> +void xlog_use_incompat_feat(struct xlog *log);
>> +void xlog_drop_incompat_feat(struct xlog *log);
>> +
>>   #endif	/* __XFS_LOG_H__ */
>> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
>> index 4c41bbfa..c507041 100644
>> --- a/fs/xfs/xfs_log_priv.h
>> +++ b/fs/xfs/xfs_log_priv.h
>> @@ -449,6 +449,9 @@ struct xlog {
>>   	xfs_lsn_t		l_recovery_lsn;
>>   
>>   	uint32_t		l_iclog_roundoff;/* padding roundoff */
>> +
>> +	/* Users of log incompat features should take a read lock. */
>> +	struct rw_semaphore	l_incompat_users;
>>   };
>>   
>>   #define XLOG_BUF_CANCEL_BUCKET(log, blkno) \
> 
> 
