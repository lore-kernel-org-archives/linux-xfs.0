Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8229C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Nov 2021 22:24:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 946EE60F45
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Nov 2021 22:24:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234266AbhKLW1T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 12 Nov 2021 17:27:19 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:40838 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229634AbhKLW1P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Nov 2021 17:27:15 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ACLnDTH004993;
        Fri, 12 Nov 2021 22:24:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=hOwulWaZZVjZtXfQbgZEiP/ukNOIqfG403XrGsdJvqI=;
 b=LmU/Xw/tTs506naCnOoWtLu+O51uBjCY7nUC+JuO/pGOJIKS35hrVcZQDs7xvOOWegCs
 S0DJyAQbTvqiKULwN66H/zkgopeM9SdlGql/p2LMaJwaYb4oBVHgzGzAz3OgfnESBmtd
 Lx6YCYVX6O+8S68LPbs+HDLfdfBl8IGAE1dV/Uew0qnBNMzReOWrKTJVOFyZX++0uXg9
 qFVvesFkxU7+3Z6vQVszTtoZnNlM2/ZLaFRSFLtGmOnl5W4og2Cn2fYAGIlyHHYkPuER
 maHvtS8xTwfxoBCyxqj+M/MUMUPxW7Whuma0eTDJ5d3Ia0OWIj0l4ae5F0a7QvIP/+Bs cw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c9rucb43t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Nov 2021 22:24:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1ACMMGjV051191;
        Fri, 12 Nov 2021 22:24:21 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2042.outbound.protection.outlook.com [104.47.51.42])
        by userp3030.oracle.com with ESMTP id 3c842fu7vv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Nov 2021 22:24:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EGBzQf+jalb8yCQYzeIxkO1ycWwpfYb1s2/FCH20gyeDYcC3bBnunp9ZqAg8w7b2wtVNMOKjWVKAmcLwgtSS1qJKYRSlntF8kWjyeCOmhzeeQjvu3ERJqevOuo/sem+go+/PX/Nwc4467XxDD7TXLT9oiJ9lgQwxOXpsDb0+wtxy7MCA+1X4Tbeh0dWi13MDJGeu8jc+2PxWpF0+zp9L3hyyud1cpy21MuR+F4fc1S4vOuaJjDLjNll6w9HV6ztnb/AxK/55W6AuYb7HKeDiOTZhF7lcAmvwld77UIncZHpbD42MlRQ6qmFlFZlbf/3kZTNQ/Ol4ryR0BGg+VG66Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hOwulWaZZVjZtXfQbgZEiP/ukNOIqfG403XrGsdJvqI=;
 b=MDVAcUfzH8PlCDZqhP1hlSEoNyeRrvs3M44yMRutxeNEskbbn9ZtTODpe/dotaCXpDUe+SqI8HF6T96w+aHSREKuMG/whoknoJljsHe7zJMYWswwG9ULrMJT3/seC1Ae1Poz7Z5kgWuZ5Se0uvjmpXuTbTwnV/6VjYeB3fuxjyLeEvV05KB/Zu+vBf38xzBX93ImXUQKbvSV8IF/JPZanjGYoqMLPL/qsuFOb7Wr7QVhAs1gF/1sEWCnhwDNXIM59dbeVHCLhpCjrAYqpfjAU1RWljoFdcG96k5z7lklg++CrZxE65Fx73ilj9H8T3KmgZ9tSKjltbY+nX/u+E3d7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hOwulWaZZVjZtXfQbgZEiP/ukNOIqfG403XrGsdJvqI=;
 b=MP2FwlXv0AMFLrDvJ7fHVCA25rsYtPSLayvRrAYMUIkZJqUSLvtDv7UUinEBMIZlof0sv5heMKO9+z3PC2dG5PzeEnXcSu8R8DUWHzM3MfHp+ktb1wCMQXRJHNCtoN/plWzINa64kbK/+vvGxCgIAmpAdaPxjcSaAY/kporyVFo=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3111.namprd10.prod.outlook.com (2603:10b6:a03:159::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16; Fri, 12 Nov
 2021 22:24:19 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2%9]) with mapi id 15.20.4690.026; Fri, 12 Nov 2021
 22:24:19 +0000
Message-ID: <9e6181f4-584f-1643-cd04-e46a5f1d8af1@oracle.com>
Date:   Fri, 12 Nov 2021 15:24:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [RFC PATCH 1/2] xfs: add leaf split error tag
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>,
        Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20211111001716.77336-1-catherine.hoang@oracle.com>
 <20211111001716.77336-2-catherine.hoang@oracle.com>
 <20211111231708.GJ449541@dread.disaster.area>
From:   Allison Henderson <allison.henderson@oracle.com>
In-Reply-To: <20211111231708.GJ449541@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0111.namprd05.prod.outlook.com
 (2603:10b6:a03:334::26) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from [192.168.1.167] (67.1.243.157) by SJ0PR05CA0111.namprd05.prod.outlook.com (2603:10b6:a03:334::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.15 via Frontend Transport; Fri, 12 Nov 2021 22:24:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e554558-833b-4759-1f62-08d9a62b2b7b
X-MS-TrafficTypeDiagnostic: BYAPR10MB3111:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3111359C1ECA48B9767449CE95959@BYAPR10MB3111.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yjrSpMsDkii5AEGElzDmqlehTGaOIjHWBlzPF33ZmMPn8fZW7eYNhWGBKHJYjLOTOIOtWZh8FkgPo81Sf6PT1Z+/fD3IwU/24pJHyLzxAoChOOi4FCuLJz8ZCWWW+EWjoAggbCuZDmux8i9Oox3VUVusxeCVFeFH31Z2twr6RG5X4Y/jrM3HYFxDNLbU3lOXomcynIRTZ0woAAmf5huVwcAw0Uj7fRJYCcWdt35qUrmn4RZu1/Fn2eBb+UGnOtiBoodQoO6qG/K1szWcKPrwHUS4PJclVmKXmz4tJsdOrT1/BD+8AY3kbRI208z18PIHHXYUsYurjnxgu4ZE7prR5Kexa3pMHKjE/sdVSgxiP4xZ44JmiPrKPdxcqSwGez0qsaaFwpXKUBx8jD7hUY+j/iyqIWxvIkeLxJ8Rr5C2LcH4vuhO6SWCi+Rpj0JeESDFgxuECMPFVmWw0SqoOx1PdKntjT0qtWhXgm7HRmUqtrtOKpALm7w8jOwgwkvw678wFX4H2uVZRfY6vctTBkfAvtvFggscaauuUy0gjOVH9FeOTIB1FLb9yUNxfmLuc2avMJDlnuWob+YaKZix31Ux2NtnhRYe+0xXd0En7iHIqKZBAgb2tT/neJj+dF6KCwwBqtdBUfRkEErXG3qramRGX/Kd3b/gkrXOru2IhT9s9cTsXHpWLfw40KwEwWzKISGvga8jFm77YjNY8V8PS+TXahiUGiZwEu93ibfy1pTroH9P9KbsD7K66Xl4YpRQIdLt94zPZd0VuufA5FmDDIZLHg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(52116002)(66946007)(110136005)(8676002)(44832011)(53546011)(316002)(508600001)(38350700002)(16576012)(38100700002)(31696002)(186003)(6636002)(5660300002)(6486002)(66476007)(31686004)(26005)(66556008)(36756003)(86362001)(956004)(2906002)(8936002)(6666004)(2616005)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UXNHZTRLQ05FUGJCZWJCS1pzQi9USGdGRUF3blk0S0ZuMGIvaU9jTWpCb3hi?=
 =?utf-8?B?WVV2QUJwaGlOUnpJaWZKNzNzbWM2R0sveEhMWHFGcGtlY0Y3OVgxdmlqZUFx?=
 =?utf-8?B?Si9ZY0xnYVZIRG55ampvVUIvdVMyRHhRY2c1b1Bnc2FkMEgrdHRCMzEvbVZS?=
 =?utf-8?B?Z2ViOXRtc3ROSTYwVkhycVFqNFM5VDBDb0ljZnNpbGZuTzhCUXhwUit5WDdW?=
 =?utf-8?B?ck9IRmVqRm5Sb0hlUGtSTVhGTFlSV3NiVkZURm9CekVMT09RRU1nanAzdzNu?=
 =?utf-8?B?cW5aM2xBaUdwdzRWWmNMc3NtTDlGV21NblpRSFJPa3lnc2dlTTNGaUdWRlFp?=
 =?utf-8?B?SVZwWXJMR2hhMWVVVk1OOTFCUjhkWGJxVmJNQ1VrODlaS3dSQ0N3RzVXVmdJ?=
 =?utf-8?B?RWNlMlRxR0JHcHoybXA4VE9yQy9MRU0yN0dGYWptaU4ybXJ1c3dCWWlLNWxM?=
 =?utf-8?B?Y01peVFRbDluQXB5WFI1Vmx6eVAwVXc5SVNrMmxlRDBzaHAydExrU0N1enpa?=
 =?utf-8?B?OUNFMUlZS0FEWFg0QnJNYyttd25FQ0NOYmsza1NFOVRNSUowNENYbmViQ0Z4?=
 =?utf-8?B?bUpTMFdZNTRIc2wwV0dteHBMeURIcTVvM3BqZk1pVm9aK0pIc3dLWTkraFA2?=
 =?utf-8?B?L2RmZVZ2QVM3NitVUDhlY2wyMG5CTG4vcWl1QnhYLzJGVHJxbGp5Y2dDV0Ro?=
 =?utf-8?B?d2NUdFFYd2JGM2lmTFhKeU9mZ3Qyd0lIZDBiZitVTUJkYWhCZVFuTGY3b0Js?=
 =?utf-8?B?cGRlMkZQTFdkbjAxSTljbi9HZEc2M2Y5ZzBMeERMbFNOK2E5T1dheDhneVAw?=
 =?utf-8?B?cXBMbnQxVUNIZnZ5OUxJbkgrNUxRckNjdUZ5UmtpcXFteVM2YjAyL2dmdExh?=
 =?utf-8?B?VnpQdW9mRHVPZ3doOVlselVvYVpEWHJ4bXRPVDkyWXVDWWs3a3BOUFFadWx5?=
 =?utf-8?B?TXlZSHc2WjU2bmczZGhYVXdteTBYaWpkTTNNY0JJdmZIV0dMcFBIcGhDWHFX?=
 =?utf-8?B?MXd4MUUxd0hmbzVyUnpnVlYxdDRXRmtXbTRyVmhMMW9WeStvTjdZYjBEaHlJ?=
 =?utf-8?B?blgyRGtyb1VnTW9YYWQ4Q2R6VXZwbEU5bHhlc250U1dUdmlpZDVUN2RlamV2?=
 =?utf-8?B?L05IOEk5THh2QzZxU1lUdjkvbFNTbmRqVk0yN1ZoVHFLM1dyM0hXNTVxT3JM?=
 =?utf-8?B?eWtxOW95QzRhdkpjY1A1a3cyUmtHTm9SMDZQUy9NeWtRcWE2enYwOUU5MGND?=
 =?utf-8?B?VGttRm9ZMHhKaXBZVUlESjhncmdIcXFxWDBwUnJRYVVpVGRrVm41aXdSVTBG?=
 =?utf-8?B?NHE5alBZdDVyREN0NUl6SlUveHcrb2VDa08vYUN0eUlNQnNVUzVQaGRwY3VQ?=
 =?utf-8?B?WEVNc2FMeWxURGlZeU9iSDRnSHJWcHRMZlJ0K2dlQXhENXl1UzVoSUl0a3lE?=
 =?utf-8?B?NzN4Yko5NjlqRHNBaExUQ0dtWUZkM3YwUFJxTHNjWGRUb2N4TzBMQWhVVmFq?=
 =?utf-8?B?aHZ4d2hRNWphNVJiMEJyYjFsdTBqYlhETzFnRkNrSlhyWG1hb2xtTDJZSXJB?=
 =?utf-8?B?NDFzSUFLZmF4RGI2VDR3RWdvUXh6cVhacENXVDdYTExBUDFiSzRRU0hJRyti?=
 =?utf-8?B?ODB1N3g2WlFmZEF2NVMzMWZEVXVJTmpwS2JWOEp5eVF2QmdRbGNlRUhFRkQw?=
 =?utf-8?B?MlQ2VE0vYndpN1Q4bFVsKzUyVFdTdVo1eVI4SFJESlUzWERhMFlMdUVEVEJv?=
 =?utf-8?B?ZFFqN3JZNzk4M0p0aXkvbHVwcnNNaCthVndhbzN0N0EvQ1hxd0NXSmJoaUJs?=
 =?utf-8?B?S1BOSkRHWVdHam84bW1EeHVqMTc1OXdxTkQxcVdiNWFvTGk4bTVPNVllVHdo?=
 =?utf-8?B?bURKRzMvVGFZcWFmaGovR1QzSkRPdE1uSjVGby9HKzRKUXVidXVDNjVtdnlU?=
 =?utf-8?B?QjJXSVppcmduSXZQR1NzUnMwWVVGVWhVcGtDY2hFWU9zeEZTWERCbjZtSmhq?=
 =?utf-8?B?Q21ENzMxK0MxMXphNGtMVWNrUzNLK0Z0Ymo0b3NCaVZRUFNTcS85RTNwU3RP?=
 =?utf-8?B?YmR5eWtQK084c1p1TW1pVm5nQzVKOTQ1YWdLemRDaUpreHBqaVhxT3B5bGVq?=
 =?utf-8?B?S0sza3VoaU5JaXZKWWNpSkxnSW5DUWg5RVFQeWpJMDRham9kY3gxSGpFdVk2?=
 =?utf-8?B?K2RYemtQOUwvc0xMZGs3QTFuSnBieVlNUHVZSlpEMnpEeUJnWXhUcFJFWlNt?=
 =?utf-8?B?UCtRSEovamR1YzNNdUV0Q3pmOXhRPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e554558-833b-4759-1f62-08d9a62b2b7b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2021 22:24:19.4502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +2moSKgCMh+6vd4TWhVdkDhHz1+aCmUzQGFD3b/gAhBX9FZKZGVyF1WBP2SrHAbvZVls/TM4nZud0eX2RoiBdyEUV9sWnojgtre6/P51fps=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3111
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10166 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111120113
X-Proofpoint-ORIG-GUID: 0WOCyxJ350Jrv7BPMj4aUiOuiZU6TmkH
X-Proofpoint-GUID: 0WOCyxJ350Jrv7BPMj4aUiOuiZU6TmkH
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 11/11/21 4:17 PM, Dave Chinner wrote:
> On Thu, Nov 11, 2021 at 12:17:15AM +0000, Catherine Hoang wrote:
>> Add an error tag on xfs_da3_split to test log attribute recovery
>> and replay.
>>
>> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_da_btree.c | 6 ++++++
>>   fs/xfs/libxfs/xfs_errortag.h | 4 +++-
>>   fs/xfs/xfs_error.c           | 3 +++
>>   3 files changed, 12 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
>> index dd7a2dbce1d1..000101783648 100644
>> --- a/fs/xfs/libxfs/xfs_da_btree.c
>> +++ b/fs/xfs/libxfs/xfs_da_btree.c
>> @@ -22,6 +22,7 @@
>>   #include "xfs_trace.h"
>>   #include "xfs_buf_item.h"
>>   #include "xfs_log.h"
>> +#include "xfs_errortag.h"
>>   
>>   /*
>>    * xfs_da_btree.c
>> @@ -482,6 +483,11 @@ xfs_da3_split(
>>   
>>   	trace_xfs_da_split(state->args);
>>   
>> +	if (XFS_TEST_ERROR(false, state->mp, XFS_ERRTAG_LEAF_SPLIT)) {
>> +		error = -EIO;
>> +		return error;
>> +	}
>> +
>>   	/*
>>   	 * Walk back up the tree splitting/inserting/adjusting as necessary.
>>   	 * If we need to insert and there isn't room, split the node, then
>> diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
>> index c15d2340220c..31aeeb94dd5b 100644
>> --- a/fs/xfs/libxfs/xfs_errortag.h
>> +++ b/fs/xfs/libxfs/xfs_errortag.h
>> @@ -60,7 +60,8 @@
>>   #define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
>>   #define XFS_ERRTAG_AG_RESV_FAIL				38
>>   #define XFS_ERRTAG_LARP					39
>> -#define XFS_ERRTAG_MAX					40
>> +#define XFS_ERRTAG_LEAF_SPLIT				40
> 
> What leaf is being split?
> 
> This looks to be a DA btree split that it the error injection is
> being applied to, not a allocbt, rmapbt, etc split. And it's not
> really a "leaf split" because xfs_da3_split() walks the entire path
> back up the tree splitting nodes as well.
> 
> So, really, it's a da tree split, not a generic "leaf split" error
> injection point.
> 
> And, I suspect this won't always work as intended, because it can
> trigger on directory operations as well as attribute ops. Hence it
> could be difficult to direct this for testing attr fork operations
> during stress at the attr fork....

Well, the intent isnt to use these during a stress test.  The idea it to 
set the tag right before an attribute operation, and then see if the 
attribute is played back as it should.  Having the different points of 
failure demonstrates that the replay is successful even when the failure 
occurs during the different attribute forms.

That context of being in an attr operation is set up by the testcase. 
We create the dirs, and files first and then set the error tag before 
the attr operation.  So these error tags wouldn't otherwise trigger on a 
dir operation unless for some reason we wrote another test case that did 
that.  But that doesn't seem like it would be a very meaningful 
testcase?  Or it would have a different objective that it was trying to 
accomplish say the least.

Perhaps all we need here is a name scheme to make the intention clear?
How do people feel about this naming scheme?

XFS_ERRTAG_LARP			# Test log attr replay
XFS_ERRTAG_LARP_LEAF_SPLIT	# Test log attr replay on leaf split
XFS_ERRTAG_LARP_LEAF_TO_NODE	# Test log attr replay on leaf to node

That would also help to make clear that these are meant to trigger on 
the attribute code path for a replay. Let me know what people think. 
Thanks!


Allison

> 
> Cheers,
> 
> Dave.
> 
