Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B399DC433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Nov 2021 17:00:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9880661220
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Nov 2021 17:00:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbhKDRCi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Nov 2021 13:02:38 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:58288 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231616AbhKDRCi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Nov 2021 13:02:38 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A4G4KZj026081;
        Thu, 4 Nov 2021 16:59:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=giQJPIowXiNhXk/XeJyUjot+oaaFAyzg9YmixbWx7WE=;
 b=CpP91tFbFaH1fZJIgQ6DQjqecZYyTBpdAjzE1Txk5ii6Y+yTvHzdz66SBId158fIzE3I
 melQnOtSQoQ0qCuD6BWoPoL34OjdY3tXEskpt0a+YYYdl+VqhPuH/bPm/uQBDIgB7pwd
 uFWnJ1L3QA1H2uENvzNqPvW/Fsuz5Il/DuYAfv1djdVEbOpBjkK7TccxOTsRB7Hweikg
 nvJJb5MAt2vahOzLVnTDalDjwJwRxM3kr81hMotchEeTMjP9090NpPQL00fVbhrKbisy
 t7BOrvKWZFCfJZJBhpE/4GBXyMEFcYX4GK75C3h5FnUcDfbqsyKyx68m4lfFthzd0qXn ig== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c3n9xsm4y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 16:59:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A4Gb7fU182425;
        Thu, 4 Nov 2021 16:59:53 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by userp3030.oracle.com with ESMTP id 3c27k8xu89-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 16:59:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aEUJ4GdttkowagwBfEP1a8rT+yGKTEaexKWSGb3rLtYkfZ5GklHKkRTv9t9xRvzdoOqU8Q/W4g1K8RRLFzMCbckT72BKM/EwtFllcgSEtbzZOOnmLSyXQzlrDZhqoJQmcYeEpOjqxknNZ6pnf5mnWzfJJi77K1bxaDNmf/QW0jyhRYWyHggFwj5FZtaUFk0439ZTPPEV9FkLbVBDiIkv5XnfxIK4kuOPEkAvMXn4V0FP3hg9updcxTNTN6AE7yLQpQJei81sDF51b/ESE12DZu4OIdTf+lRa5zbeMb4X0ijgESlKP7AnqH9CPqC6hSWjHF35Ac0uRqfcHavHhWR8wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=giQJPIowXiNhXk/XeJyUjot+oaaFAyzg9YmixbWx7WE=;
 b=GVA5siE2cYhmyeeaRE9QoQbtiVvEjCz5Hz7W2eV0l7Y4qDOMr+RQZSNSeYfFW7ueH95BOMpR4O86hr19PjrdttsRJq1F3o80KaB2yA0gPAkI6md9OkINT0DHHmDDu+RmrbzjExAkHvG6w635Qw485vC+Wh5zcWFJ87MLxWEzW5kEKIemD4jBFAWblrob8M3lL/y45+3IPeks95D5JYXti6lfF+1KCBp36Yn2UE/sbGtKbifeTtwnV6SCA8BH3DNeziH1d5geh0JLeZ+HZ5On7juNDGMQiKK9RDt4b6VvXXQ/K6iW/Vk8JoQd7DXsweHHPGx2TBr5e7XcR9DrvahoEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=giQJPIowXiNhXk/XeJyUjot+oaaFAyzg9YmixbWx7WE=;
 b=OFsXFnH00KTUhuR/6KnnD/JHCMXd/1qa0WsUeNLQnYNZUVVxaZB/u9p2uzwMpJWgJa7q3rciMN8og8MN96ozeqx4C4DKxTMGwJIrehLvM0wXBBQhHvS9CxR1OmK/hlvuXp/lX+hBGJy6ixDSs2wChbCWBFjB1/FA6ovohbSlNCE=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3921.namprd10.prod.outlook.com (2603:10b6:a03:1ff::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Thu, 4 Nov
 2021 16:59:51 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2%9]) with mapi id 15.20.4669.011; Thu, 4 Nov 2021
 16:59:51 +0000
Message-ID: <fc3c7b3d-42a2-1901-280e-2a99c3b49226@oracle.com>
Date:   Thu, 4 Nov 2021 09:59:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH] xfs: Fix double unlock in defer capture code
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
References: <20211103213309.824096-1-allison.henderson@oracle.com>
 <20211104001633.GD449541@dread.disaster.area>
 <20211104013007.GP24307@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
In-Reply-To: <20211104013007.GP24307@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR21CA0004.namprd21.prod.outlook.com
 (2603:10b6:a03:114::14) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from [192.168.1.167] (67.1.243.157) by BYAPR21CA0004.namprd21.prod.outlook.com (2603:10b6:a03:114::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.2 via Frontend Transport; Thu, 4 Nov 2021 16:59:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db8ca05d-9f6d-44e4-e04a-08d99fb48482
X-MS-TrafficTypeDiagnostic: BY5PR10MB3921:
X-Microsoft-Antispam-PRVS: <BY5PR10MB3921420B36BC29DD67373B3E958D9@BY5PR10MB3921.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iDX12Pycn9GAD1ReSiHzZHIxVWglkOh//K4FLpIfdHXfZ5yTllPf9NUkHPQM6xXaI7B/GMB+4xetYr3JNyxVq0UOfwhGIVQCQZAnVU0dYziXY3TAhV7S8wFzeenqSpxcpzwbClQOtmxAhbDG35zX48QwR3E/E/HgFbjNyEcdbsi6m3SHc5wOMSv03bgBFD8zP8OyuF0ohqgtv0fU3PefxovaF90ty0+ZE5s147t4HbIATHHgjP0zQ+1xdbRjH9zdLhHs6zWKDiNLj03bJBjRctctm7DDcPSgpkzyoo48hbVPFQGOce7Uom3i+AShmkSfZF9TxmIftnra4ip7LEUNoz7cfx1pU8C4K6URxMpvtZSOBARiVFpZVsacAEKH/d5XZcxwUc7ozBeEbKFtIe9IX+NCRd3KYBrjeOq2TzcbzD0KUsXqahapJulTSFEzxKKaX03z+OSsb7xhx3H44toxMLUeqdzFk6bb3KOieqL2RBnMMhux8m754b5/sDOZVf7tKuaQTOW/traBSEQQyKPKNS/bJRZQ0V01Ki5UDQcy05KiXs4+vsFp5za5CvKuoJ5pvWDETTgPVDDTtygS2R8UHLJeVGGM0dQECflhrM3BKj+frV8K5xahK1cSe6QHSLXp9xxitAmp15TSsXE2X3vlgBAZyGIjelPL0L3iCNOSFYr71Wglf7ddol/OU1lmJbJvI28fChjOTD5hAziv2tqUR3qHTm6I6PBQEWUThkh+LfhBxFuKE+iOSdHA7ovcN+638yttuKX9xuj3/QJNF3ZwzuJ8TJN1YCyPC+XYOZdelHs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(186003)(26005)(8936002)(36756003)(66476007)(956004)(2906002)(110136005)(44832011)(316002)(83380400001)(508600001)(66556008)(31696002)(86362001)(16576012)(5660300002)(31686004)(4326008)(53546011)(66946007)(8676002)(52116002)(38350700002)(38100700002)(6486002)(87944003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dnVFNXEwc3V4UVFVQ0ZLZkhYdG05Y1lmNHVxLzVZcEhHKzBCUTNxcEd0RERB?=
 =?utf-8?B?UmJ1SFpwWDdBS1luUkNTcFErLzRleGl6SjlsZW0rRllPNlB1ckFudTR1dmJU?=
 =?utf-8?B?QkxkNTZpM3J1OGNEQ0xyTmJydDBZUVh4QWpQc3lFSFBDdUZFM1hGaTM3WkZQ?=
 =?utf-8?B?dkQ5azJESUFXVitkQ0hsRkw0QmkyT3UwRlpKUXo1eWJmZjl0bjFtNGdqRUg4?=
 =?utf-8?B?UDVEcFp2QmY3TUkzNFByK09rMTJYTTJLNzJ0M3IxdkUrNUZ4T3ZIVllGWExU?=
 =?utf-8?B?QXNtYnFiZ1NOWG9OUzlLSUovM0ZTNFRzUHN2dmFsZ2RIaFJoTjYxTkJzcEkx?=
 =?utf-8?B?cVFTdHRJT0tvTzVoTXZGMGhoTTU2MzJJYjNpQkRCZ3BFR21Sa25lclp2TkE3?=
 =?utf-8?B?a3g5SVhEZDBtajZYNFZvc3pPa3JSNmFrc1R2ZGZwNHZLMncyQzNhd0k5TXNo?=
 =?utf-8?B?RjR5U1RQSlFKSS82OUpFQXFnQ3p5dllzNzZ1aFhJMURWZ1pTVnUwb29SSHFI?=
 =?utf-8?B?OTVHeENsUlBEeXNUN0tyMzd5eDJQU2Q2eldJc2ZZKzU0RUZJbWNZL1B6aTZo?=
 =?utf-8?B?cFkwUlE0R1VXRDVWL2tNeTFFZVZLdjIvQ0lZWGMyd3Iva2tiV0VadEo4WUVj?=
 =?utf-8?B?bDI1enBZMGptTmlPdnZoNmNFTS9QejdjemJFVkRzSXFiczR3aWlmOE9IZi80?=
 =?utf-8?B?S3F4Ukx6S0RSV1pTUW9WZDIwNHM1OXVRRWs4Mit3emxuOGlWN3B4d2p6TE95?=
 =?utf-8?B?QWUyK1BlTnpvUE9NbmJzNzhGYUYxdndsQS9LbGI0bEhyU2cvOGhsL3c4d1li?=
 =?utf-8?B?TXVWdjI3UmlBVmNZWEVScmZGd3JvcW03SmRkalAvTHJ4TTdNMDYwbHVacWVm?=
 =?utf-8?B?dGJZV1gxMTNUVUFFQjF4cVpSUVo5elk2QzVUekx4d09qV0pXTEV6V2d3dUdF?=
 =?utf-8?B?SDB1Yi9TSCs3NDlvQWZlbTNmUlp4azU0b2RRQ3BHZXUyTlk4SXRMQ2ZRWk12?=
 =?utf-8?B?dWQ2OC9abmRrdEZNL1BUN1k3VHFSMEtnYkVYTnZTRGNGbGd2NUJRUmdRbkJQ?=
 =?utf-8?B?TEkreG82YklxOXRNd2gydFoxL3ExOWZMNDZNUCs1QU5EMDAwRFV0emhHQWh2?=
 =?utf-8?B?NWloK2dqNVZtUXNGTXdzSEEzN2RkZEhiZnNpRG95NlJXcStDUEdFc3BKcUZv?=
 =?utf-8?B?cFdTSDNEUHRVeVVVT21oM3lrQ2xIMkI4UENaM3lZZGN3dUlZVDNoUEZycEpp?=
 =?utf-8?B?WVFmZFZ4cHZhQzJiR2FHRGx4Q1FhN0QvVDljbEplaXVyeENUMGdDY1ArRDU5?=
 =?utf-8?B?azB3cFZhNytUdFc4QnpERjdsZkJZNGFTVVJVcjVBNmt4YmViQml5eVVLNllK?=
 =?utf-8?B?TFFKbkVwUDh3MFgvdjlTcHNuL01SM1ZWUnZIM0Y4M21hK0pCejJsSnovNnVZ?=
 =?utf-8?B?RkdxQlcwOTdnTUV6Zk8rU3ZRTm50QkYzOTNyT1AreDZucmQydnBZVDJsb0sw?=
 =?utf-8?B?enloYU83ampiYWRTaHBiZFZHbm00dTRVTmlWTE04ZjZuN2QxTDVJNjlOR1B6?=
 =?utf-8?B?eCttMzdJZHIvNXE5dHVTOGhydkY0UHJIeHhkc2hvN3AvS3NzaWQrc3F3REg0?=
 =?utf-8?B?Tk5wSHZTYVFzN0Q5Tngwbk1RYUR3QXFKdUx2NHJHNWhXUTFWdzNIeWRLVWND?=
 =?utf-8?B?MHBRV2FWd3NrSlBMQnZhcWdZN1dISzl0eEM4QVFyM2NiTGttZFpHRG9LRXQ4?=
 =?utf-8?B?MGJKWVdTam5ZSmR2dUhVZ1Mva1hzbTA3dnY1VUFOeVIyN2FKRlBWRlVOYk55?=
 =?utf-8?B?MTIzRTRKR2szMFd2c0wvQWJOM09xdEpsbUltZWZLaytlRjBrQi9IMGorSzZl?=
 =?utf-8?B?SnpxU0o4dUg3UlgzbEYyRTV1d3BtWHBMenNJbjdyOC80dEZ6a0F5enBITnNt?=
 =?utf-8?B?M2pMSGZqYkFXMWFNQzloU2NuME1MV3Q5cWhmb2ljOUdZVFNlbzE0T3BrVXY3?=
 =?utf-8?B?U2l6anFYZFJNSDlzYnZiTGJWaEpFMm5nYzFhMXhVNVo0MVI5alQ3dXpyaXpR?=
 =?utf-8?B?Vmx1UDJxRGJUMG5xd3JoaUx6Nnp4WURPOExxOXpsa2VrTm51b2taaTlFM092?=
 =?utf-8?B?WFpwcWMyZThBVDR6a0RvaFFEbTNUcjhQMHhXVnJlVTUwaTVQeDRybjdkQnF1?=
 =?utf-8?B?V3ZvbFlyYTJHRW9ZTmVKek9jY0w4NDNQd1dQVDZ2NEFyZUhkZjVNMmJIMUxp?=
 =?utf-8?B?eGxOMDZERHNmOHZHcC9nMWVQV1NRPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db8ca05d-9f6d-44e4-e04a-08d99fb48482
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 16:59:51.6800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nkIKJVxuhlZR4ddn5O0Nh3vhAXfnmbcyggDqFS2BzjiwTg7UlSVy4RFD4RxtKUb2HRSndMG1l5FDMbrXBy16HL9B2Pk4Deoihz+luhxanow=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3921
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10158 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111040063
X-Proofpoint-ORIG-GUID: _J5aTQ0Z6PlBoASvRDmJE2pCQYKRkCFv
X-Proofpoint-GUID: _J5aTQ0Z6PlBoASvRDmJE2pCQYKRkCFv
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 11/3/21 6:30 PM, Darrick J. Wong wrote:
> On Thu, Nov 04, 2021 at 11:16:33AM +1100, Dave Chinner wrote:
>> On Wed, Nov 03, 2021 at 02:33:09PM -0700, Allison Henderson wrote:
>>> The new deferred attr patch set uncovered a double unlock in the
>>> recent port of the defer ops capture and continue code.  During log
>>> recovery, we're allowed to hold buffers to a transaction that's being
>>> used to replay an intent item.  When we capture the resources as part
>>> of scheduling a continuation of an intent chain, we call xfs_buf_hold
>>> to retain our reference to the buffer beyond the transaction commit,
>>> but we do /not/ call xfs_trans_bhold to maintain the buffer lock.
>>> This means that xfs_defer_ops_continue needs to relock the buffers
>>> before xfs_defer_restore_resources joins then tothe new transaction.
>>>
>>> Additionally, the buffers should not be passed back via the dres
>>> structure since they need to remain locked unlike the inodes.  So
>>> simply set dr_bufs to zero after populating the dres structure.
>>>
>>> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
>>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>>> ---
>>>   fs/xfs/libxfs/xfs_defer.c | 40 ++++++++++++++++++++++++++++++++++++++-
>>>   1 file changed, 39 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
>>> index 0805ade2d300..734ac9fd2628 100644
>>> --- a/fs/xfs/libxfs/xfs_defer.c
>>> +++ b/fs/xfs/libxfs/xfs_defer.c
>>> @@ -22,6 +22,7 @@
>>>   #include "xfs_refcount.h"
>>>   #include "xfs_bmap.h"
>>>   #include "xfs_alloc.h"
>>> +#include "xfs_buf.h"
>>>   
>>>   static struct kmem_cache	*xfs_defer_pending_cache;
>>>   
>>> @@ -762,6 +763,33 @@ xfs_defer_ops_capture_and_commit(
>>>   	return 0;
>>>   }
>>>   
>>> +static void
>>> +xfs_defer_relock_buffers(
>>> +	struct xfs_defer_capture	*dfc)
>>> +{
>>> +	struct xfs_defer_resources	*dres = &dfc->dfc_held;
>>> +	unsigned int			i, j;
>>> +
>>> +	/*
>>> +	 * Sort the elements via bubble sort.  (Remember, there are at most 2
>>> +	 * elements to sort, so this is adequate.)
>>> +	 */
>>
>> Seems like overkill if we only have two buffers that can be held.
>> All we need if there are only two buffers is a swap() call.
>>
>> However, locking arbitrary buffers based on disk address order is
>> also theoretically incorrect.
>>
>> For example, if the two buffers we have held the AGF and AGI buffers
>> for a given AG, then this will lock the AGF before the AGI. However,
>> the lock order for AGI vs AGF is AGI first, hence we'd be locking
>> these buffers in the wrong order here. Another example is that btree
>> buffers are generally locked in parent->child order or
>> sibling->sibling order, not disk offset order.
>>
>> Hence I'm wondering is this generalisation is a safe method of
>> locking buffers.
>>
>> In general, the first locked and joined buffer in a transaction is
>> always the first that should be locked. Hence I suspect we need to
>> ensure that the dres->dr_bp array always reflects the order in which
>> buffers were joined to a transaction so that we can simply lock them
>> in ascending array index order and not need to care what the
>> relationship between the buffers are...
> 
> /me agrees with that; I think you ought to be able to skip the sort
> entirely because the dr_bp array is loaded in order of the transaction
> items, which means that we'd be locking them in the same order as the
> transaction.
Ok, we don't have anything that uses two buffers ATM, so there really 
isn't a need for it.  Will remove.

> 
>>> +	for (i = 0; i < dres->dr_bufs; i++) {
>>> +		for (j = 1; j < dres->dr_bufs; j++) {
>>> +			if (xfs_buf_daddr(dres->dr_bp[j]) <
>>> +				xfs_buf_daddr(dres->dr_bp[j - 1])) {
>>> +				struct xfs_buf  *temp = dres->dr_bp[j];
>>> +
>>> +				dres->dr_bp[j] = dres->dr_bp[j - 1];
>>> +				dres->dr_bp[j - 1] = temp;
>>> +			}
>>> +		}
>>> +	}
>>> +
>>> +	for (i = 0; i < dres->dr_bufs; i++)
>>> +		xfs_buf_lock(dres->dr_bp[i]);
>>> +}
>>> +
>>>   /*
>>>    * Attach a chain of captured deferred ops to a new transaction and free the
>>>    * capture structure.  If an inode was captured, it will be passed back to the
>>> @@ -777,15 +805,25 @@ xfs_defer_ops_continue(
>>>   	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
>>>   	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
>>>   
>>> -	/* Lock and join the captured inode to the new transaction. */
>>> +	/* Lock the captured resources to the new transaction. */
>>>   	if (dfc->dfc_held.dr_inos == 2)
>>>   		xfs_lock_two_inodes(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL,
>>>   				    dfc->dfc_held.dr_ip[1], XFS_ILOCK_EXCL);
>>>   	else if (dfc->dfc_held.dr_inos == 1)
>>>   		xfs_ilock(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL);
>>> +
>>> +	xfs_defer_relock_buffers(dfc);
>>> +
>>> +	/* Join the captured resources to the new transaction. */
>>>   	xfs_defer_restore_resources(tp, &dfc->dfc_held);
>>>   	memcpy(dres, &dfc->dfc_held, sizeof(struct xfs_defer_resources));
>>>   
>>> +	/*
>>> +	 * Inodes must be passed back to the log recovery code to be unlocked,
>>> +	 * but buffers do not.  Ignore the captured buffers
>>> +	 */
>>> +	dres->dr_bufs = 0;
>>
>> I'm not sure what this comment is supposed to indicate. This seems
>> to be infrastructure specific to log recovery, not general runtime
>> functionality, but even in that context I don't really understand
>> what it means or why it is done...
> 
> The defer_capture machinery picks up inodes that were ijoined with
> lock_flags==0 (i.e. caller will unlock explicitly), which is why they
> have to be passed back out after the entire transaction sequence
> completes.
> 
> By contrast, the defer capture machinery picks up buffers with BLI_HOLD
> set on the log item.  These are only meant to maintain the hold across
> the next transaction roll (or the next defer_finish invocation), which
> means that the caller is responsible for unlocking and releasing the
> buffer (or I guess re-holding it) during that next transaction.
> 
Ok, so should we remove or expand the comment?  I thought it made sense 
with the commentary at the top of the function that talks about why 
inodes are passed back, but I am not picky.  How about:

/*
  * Inodes must be passed back to the log recovery code to be unlocked,
  * but buffers do not.  Buffers are released by the calling code, and
  * only need to be transferred to the next transaction.  Ignore
  * captured buffers here
  */

?

Thanks!
Allison


> --D
> 
>> Cheers,
>>
>> Dave.
>> -- 
>> Dave Chinner
>> david@fromorbit.com
