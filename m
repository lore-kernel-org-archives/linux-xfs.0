Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C037C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jan 2022 06:46:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236929AbiA0Gp7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jan 2022 01:45:59 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:16112 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236902AbiA0Gp4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jan 2022 01:45:56 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20R6VQDM005667;
        Thu, 27 Jan 2022 06:45:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=0P7kyUCaTzJrjpMXDgq3TbJbiCsdRYuuyTxdsdQ4v8I=;
 b=GArnrdfyFpnJbwUU2b1qqi5huiEN+GhVf2StL2sO/H60v+Wwsk93O0o5ULkcJ+FJGMhv
 DRFilMklhlsbewlXyCU8tRlSF57//y57e+FfGzplcAetgZXL5yLF85X+GcI+5mDKZQLK
 EfUXyjjjlQzDFgaMT0/GP9Oz5UC3y0KrmnWAXAEoVTjLg06BSXsZcY8+Dy0c/4NibG9O
 J5lJHuCNSXCk0O9hGwyzMikJ01Duz3iQ81TrTSeGExDdcvVPBmr6LfjNtoQgO13AfTEz
 R4L2z73+7dWXH93NS36zAhykY/HbSQBiJPP3whS6Al5RpDD4kiXn4nuJoo2WzLv3sgwB HA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dsy7b0hsg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jan 2022 06:45:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20R6epNU046402;
        Thu, 27 Jan 2022 06:45:52 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by aserp3020.oracle.com with ESMTP id 3dtax9t2gk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jan 2022 06:45:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HArrncSZJTD28KReVNIFMjjK6AFx76An+OVMheVj1vdLQyuraEgjIgipGocSzBlhjXx38VnkQ7+PRI4EEf4MShF5ZHv5k44rj+DsiCGgf5yfrKwGqrXcZ6ZG79Czv0EwHpmobV6DGcW5yVRLtQMaf7qbzN+ViowB3GQmpjY10puK1H4EB3xWHh/+OCYCm1ZSD5x0JPvFpBuQU6dMCiUeqHzBLmRkP2nPSF6JPMgS0bh6RtmdvAftj7EpXHnc/9c+CEAt9tAvZTfIYD/zs0uIkj3G6Hb3vfRzyREViVJORWtbg+HCPOExzbXQZCAsUTNTxYL9YgiggFdsF3Ra1fzeig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0P7kyUCaTzJrjpMXDgq3TbJbiCsdRYuuyTxdsdQ4v8I=;
 b=BLsWfZ2mQjH/a/s5hPE71leZPzLjaX9XUw0j1WCn89pfaMIGTozUPhVjU0Wt/94NCwcw2yabZ1V0uYiNFIKL5aWVkRigve7q98FUURAJ08ocZsxkfJoceQ4Op6TjxmI0/0gk/Rm9WlxR2WOHs3/sPYMfe17aFkkKLpOkNerAx69SeqDpZJpJoAuVTDJfNc3WHMtvsdIoMZ70M1r10N+vdp85rJeP2q00DnaGzQMcyrASH/t+YmgrHUoVraZHrrLQqCoxreLuGf/Gq71i2+ird0XkV/dSB05p6QeXmJdfLjmmAsCPhaO4+Ye21knYVp3G+a/0PaP24MpCXE0U0Cv2Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0P7kyUCaTzJrjpMXDgq3TbJbiCsdRYuuyTxdsdQ4v8I=;
 b=cDtIp6OP7IP+x3d8s1qslusj0YydgfUIQ3+X7mJL5qJN2qOnI35p32L/76hSqeFZc5dtum1/6zwoP/kC3RoWUprdsashEBrhmkR2AJvc0C2mIH74m4LKEcS5avizcCZ6oo8CWOtv16Z/kZEpuY5ATWr4YPkyxC/yDqQ7nGuDXp0=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM5PR10MB1771.namprd10.prod.outlook.com (2603:10b6:4:8::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4909.11; Thu, 27 Jan 2022 06:45:49 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3c8d:14a4:ffd3:4350]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3c8d:14a4:ffd3:4350%8]) with mapi id 15.20.4930.017; Thu, 27 Jan 2022
 06:45:49 +0000
Message-ID: <a8186309-fe17-50cf-66fa-a42f298fde17@oracle.com>
Date:   Wed, 26 Jan 2022 23:45:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v26 04/12] xfs: Set up infrastructure for log attribute
 replay
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20220124052708.580016-1-allison.henderson@oracle.com>
 <20220124052708.580016-5-allison.henderson@oracle.com>
 <20220125011023.GK13563@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
In-Reply-To: <20220125011023.GK13563@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH0PR07CA0014.namprd07.prod.outlook.com
 (2603:10b6:510:5::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6360cc32-8d5b-4ba4-07a7-08d9e160a7c7
X-MS-TrafficTypeDiagnostic: DM5PR10MB1771:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB1771B53A1CC155F8F426818395219@DM5PR10MB1771.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jz3BxEPd/NksxmN8KRzwOCxDY1dac7hiqyt0z/Cr1IpJP7bLQx0q5/zeIL4SzLQg15g1JK8fZbRv2DBQxQSp/By/t3LyLBxlxpehCIm3+aB1VSwPBGUf9wmIAKEML8hfqLRRF4TbrVPUvt43/fb6RL4GwFc9leZ5x5P06r7QR9JTZkvKx2jPmccJF1+d6PzJmSG4UHit1Ga0CtnX/5dXE6m11YRJhcSTtef4HrqR58WM2CRnHXwjL146EqmkMmywuClMmjcmFzDhebMxgLeuu+2KOSb21kKp69qsoaT+hgr9hrqL8/1ZijiQS/3gDV7h/vOp/He7trS9GvGJ7m40bywG0jDrcNhc+BEYPKJM3qSW6ACCaUv0vRSZUF3RcN8S4c02ClPF3WQGIdaS3HYxGDkfoCj1SkHHStACw65tL6Hcb0+p7hH5nO7WyUM/Q2cfdxA4Imw/w2+pUTNT4/NwZO+WSEwRAyo/6PTRUzOjQfofPNGRuO2fzUG4fXsUZ7yPABaVFbsc9T/bdmBFMEjBAhVc+58h/g+DqJ39U8m6RDXd1xpg4Ed7NQV2mhO4qa3B9V0cgfabVPwNzjxcOeg5BHYjMyPC7DA3/F/pnL3WNpDRjii/qxRbWpowzLlcQDM+FPlLQbQ9osHzwWRQYq14SmnvzC+e+1ORqSNQZWFgcPCdcMKiVxKPCrX3ZoDKDtr76KvWOFzKEI2YqytCH1rMEnNVRgw7JHIVTG56VpxQ4zeRGOG29I1K0TjCrsRlK2AeGwscO3L8NwrQ5JzUlPSjng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6486002)(31686004)(36756003)(26005)(316002)(508600001)(186003)(5660300002)(38350700002)(6512007)(44832011)(66946007)(2906002)(6506007)(2616005)(83380400001)(8936002)(52116002)(66556008)(4326008)(6916009)(66476007)(53546011)(30864003)(38100700002)(8676002)(31696002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eUc4NWQrcjNLalVXbGhEdk9ySVI4aFp2WVQ3d25HQ010d05kRVZEQXFDQTk2?=
 =?utf-8?B?TEtYTlZCVm5CeXVwamZIQkZITG1qalB6WHNBVytkbWpjVlhabHBHWEhlR2tn?=
 =?utf-8?B?a2lyNFArMnk5anorNW16enNaaXRXWk02OUNQdzRqSGZyNlNjb0hDS3lWQmxk?=
 =?utf-8?B?cHhDS3o1dTUxdFFDU1Z3bmhTYXBJSlorb2FRYkVzTFE4K29xTVlITHNZZFRv?=
 =?utf-8?B?bE5YbVNRcHR5VVFYai9Nbm1rSmpPNHV6RFJOckN2Y20zekhhV2VHRTE1VjVy?=
 =?utf-8?B?L1JvRVRmUHZQRDVWQitHaTBOSG50WURPWGVEY3VmYVdRMXZjMDR4OTVVR0Vk?=
 =?utf-8?B?VWtDeE1Qb1hTZURQelNwL2xFS2xwQXduandCZXJEZ2JzTERCR3l5NlJqM1VC?=
 =?utf-8?B?cktXT0NxUFZyRU5JdDBjUDZQS2JoZmVybEErS3pWMDE0dmpqbkovNUIxdDJB?=
 =?utf-8?B?eVlmZzdWbS9ETlkxemR1amZWd3RobWcwQ0Y1Wmp5clYzZ1NsTXBYNWFORzJS?=
 =?utf-8?B?NTI2M1RoK2gxQW9jT2NjWVpzZGlEeXRvOVRQb0d3ajdyNzltR2ZDaElETWVW?=
 =?utf-8?B?dWdOS3Jrbkg5cm9Lc2lLUlZBdmxscXd3OGp5OVpNTjA5bmxSWmFsUHY4b0lw?=
 =?utf-8?B?U09DMVNXTDkzVHpzMlhEQ3pTTDg3RlQ0QmRkYWN3TWJqaVVSL1N4dHhWSkRm?=
 =?utf-8?B?RnZJM3B4SGptUTJrQm55OGJnOFBSTkQ5R3BST0tQMmNDeWI3cnV3SFZlOVdV?=
 =?utf-8?B?YytMeStKUzNRbnl5bVp2bkhsR0w1RE1iUUd6NTFsQlhleEV3R1luRWttMU9R?=
 =?utf-8?B?Ymdlc3ViZVN4VDZpMmw4UGdoUmFTdklzTHkydlFBUi9oellaWEVXRWN0OTAy?=
 =?utf-8?B?MnhKWUZ5bWhsdXFJR0N1RkxwOHU1MWR0MDgrejR4YzF1QkpRbEE4OWxFWU94?=
 =?utf-8?B?LzdUQnA3ZVhxRElaMnFyZDBIMGlUYjlLZE9oMVBzOUNTeU5Cd3NDdE9tRjZn?=
 =?utf-8?B?dXVYOUxoUWdrZzFyNzlBUGxVOXNaTWg1ZlZKcStHYnRsUDJiSVVRVkdzNTFw?=
 =?utf-8?B?eDJLQzhWMnluUXdIZVg0OEVqNk5GMnFkREcyZCswWFN4ZDdvSEFUNFNub2Vt?=
 =?utf-8?B?dVFUQzMxcndZeHh2Ym5EWmtDbjFLUlhzTnAzU3JvRHcrMi91SjhDWjFUbDNX?=
 =?utf-8?B?NXZwVUo0UHBTdEt6TTEzOEdhbEwwMHM3SVlWUk53WmN5c0c3YXltMS8vY25j?=
 =?utf-8?B?T3UxemJDNjBqRnFrdVNtcFQ1R1BRRG0zVncxd252MGo3RzBDRHNybjRaMW5U?=
 =?utf-8?B?UG1OYUNxUVZxbHB2Y0FheU9Kem5PL0hmY0s2T1ZDYVRpTmlMbmhhbU5sQnFm?=
 =?utf-8?B?WThzR2tSN0Y3YVZKTUt0c05ZMjJQNXhqVVhCaCtUWnRLclA4NCs1R1R1Vlcw?=
 =?utf-8?B?SVNCc2tlYW9kcVk1VlBRMTE1VFBjNmRlSWhOT1g3b1FuTHNneEU3bXYzZWVa?=
 =?utf-8?B?RGJKWU5iQ3BYMWVSMWc3cXQ0bW8rcnBWVnJidCtwbVN6R2cvWS93TWZ6VlBh?=
 =?utf-8?B?aXNNRjJNdGdvQk0wVGwyYkRuTGhvODdwcDVrK3kwd0VJdTNNRTRPUWhOZXpY?=
 =?utf-8?B?dUVEKzJsNGp5R01qQmVxdU13SkpWQVlpZ2txbkxDcmVVejdUZDE0OXY0TlNP?=
 =?utf-8?B?aVNERjBwL09KY1NLUDVnY3V6OHdjSWkvOXB2c1Y5VXBORTJoM0FPSktqRU5a?=
 =?utf-8?B?a05udk5rcDBObVRkbmRrQWtnbzl2b0cxTE1Wd2tyejF0c1N2bFVsQU5pZXRC?=
 =?utf-8?B?a01HN3EwSlFpam9kZE1BeHhVcVliWGxvSDZ3T1J6dXhqcERkR01HTkRmWmlF?=
 =?utf-8?B?eCtDc00rYmI1L2MwejlwOE9GUjgzNVhuRUlQQTdDd0gwcnhVT0FERHl4L3lI?=
 =?utf-8?B?UTVIZ2EvbkdlN1BlQ2N2V3hDTWVjYlhDRlozZW8xQ2poRUFUWkh0cXV0WndY?=
 =?utf-8?B?Wk1pNHVBNk10N3BOazhaajRtMGdFODdqQXZGTSt0dEhDK2VuZVlLMHZDL2E4?=
 =?utf-8?B?a1hVcGpzNDFsVlRLOEkyRkhNV1BMalovTlJNZFYyTGpDWlZvcnpOTE1Ea0dn?=
 =?utf-8?B?N1NhcGJPVmxZblI1bThFN3I0dlZqclpURXQrellZQXVuck1vajJyUUdiWGNj?=
 =?utf-8?B?UWNlYW5KeEZ0SFdyejdJbEg2Y3NXeWthUGJBdEQrend6OFBIeHorMitUYmMr?=
 =?utf-8?B?OVN5djlFTGk0SFBnSjBWTFErVHh3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6360cc32-8d5b-4ba4-07a7-08d9e160a7c7
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 06:45:49.9146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C2JTCKhJgoYpReHWMtGEKKdQ/JKOn1iUouoeE57NCgswWJqEqMYOcWk9prd9MlO7SXxHTmeGMsoE+uhnEqI1R6vKv1zUmt0n/IzOoVW3tOE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1771
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10239 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 mlxscore=0
 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201270037
X-Proofpoint-GUID: zhjPbEaWN_OjBn8b41Z_wEdhkOtkf9Oc
X-Proofpoint-ORIG-GUID: zhjPbEaWN_OjBn8b41Z_wEdhkOtkf9Oc
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 1/24/22 6:10 PM, Darrick J. Wong wrote:
> On Sun, Jan 23, 2022 at 10:27:00PM -0700, Allison Henderson wrote:
>> Currently attributes are modified directly across one or more
>> transactions. But they are not logged or replayed in the event of an
>> error. The goal of log attr replay is to enable logging and replaying
>> of attribute operations using the existing delayed operations
>> infrastructure.  This will later enable the attributes to become part of
>> larger multi part operations that also must first be recorded to the
>> log.  This is mostly of interest in the scheme of parent pointers which
>> would need to maintain an attribute containing parent inode information
>> any time an inode is moved, created, or removed.  Parent pointers would
>> then be of interest to any feature that would need to quickly derive an
>> inode path from the mount point. Online scrub, nfs lookups and fs grow
>> or shrink operations are all features that could take advantage of this.
>>
>> This patch adds two new log item types for setting or removing
>> attributes as deferred operations.  The xfs_attri_log_item will log an
>> intent to set or remove an attribute.  The corresponding
>> xfs_attrd_log_item holds a reference to the xfs_attri_log_item and is
>> freed once the transaction is done.  Both log items use a generic
>> xfs_attr_log_format structure that contains the attribute name, value,
>> flags, inode, and an op_flag that indicates if the operations is a set
>> or remove.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
>> ---
>>   fs/xfs/Makefile                 |   1 +
>>   fs/xfs/libxfs/xfs_attr.c        |  42 ++-
>>   fs/xfs/libxfs/xfs_attr.h        |  38 +++
>>   fs/xfs/libxfs/xfs_defer.c       |  10 +-
>>   fs/xfs/libxfs/xfs_defer.h       |   2 +
>>   fs/xfs/libxfs/xfs_log_format.h  |  44 +++-
>>   fs/xfs/libxfs/xfs_log_recover.h |   2 +
>>   fs/xfs/scrub/common.c           |   2 +
>>   fs/xfs/xfs_attr_item.c          | 440 ++++++++++++++++++++++++++++++++
>>   fs/xfs/xfs_attr_item.h          |  46 ++++
>>   fs/xfs/xfs_attr_list.c          |   1 +
>>   fs/xfs/xfs_ioctl32.c            |   2 +
>>   fs/xfs/xfs_iops.c               |   2 +
>>   fs/xfs/xfs_log.c                |   4 +
>>   fs/xfs/xfs_log.h                |  11 +
>>   fs/xfs/xfs_log_recover.c        |   2 +
>>   fs/xfs/xfs_ondisk.h             |   2 +
>>   17 files changed, 645 insertions(+), 6 deletions(-)
>>
> 
> <snip past the boilerplate that looks ok>
> 
>> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
>> new file mode 100644
>> index 000000000000..bc22bfdd8a67
>> --- /dev/null
>> +++ b/fs/xfs/xfs_attr_item.c
>> @@ -0,0 +1,440 @@
>> +// SPDX-License-Identifier: GPL-2.0-or-later
>> +/*
>> + * Copyright (C) 2021 Oracle.  All Rights Reserved.
>> + * Author: Allison Collins <allison.henderson@oracle.com>
> 
> Please update the copyright year to 2022.  Even though I feel like
> it's 2062. ;)
Sure, will do

> 
>> + */
>> +
>> +#include "xfs.h"
>> +#include "xfs_fs.h"
>> +#include "xfs_format.h"
>> +#include "xfs_trans_resv.h"
>> +#include "xfs_shared.h"
>> +#include "xfs_mount.h"
>> +#include "xfs_defer.h"
>> +#include "xfs_log_format.h"
>> +#include "xfs_trans.h"
>> +#include "xfs_trans_priv.h"
>> +#include "xfs_log.h"
>> +#include "xfs_inode.h"
>> +#include "xfs_da_format.h"
>> +#include "xfs_da_btree.h"
>> +#include "xfs_attr.h"
>> +#include "xfs_attr_item.h"
>> +#include "xfs_trace.h"
>> +#include "xfs_inode.h"
>> +#include "xfs_trans_space.h"
>> +#include "xfs_error.h"
>> +#include "xfs_log_priv.h"
>> +#include "xfs_log_recover.h"
>> +
>> +static const struct xfs_item_ops xfs_attri_item_ops;
>> +static const struct xfs_item_ops xfs_attrd_item_ops;
>> +
>> +static inline struct xfs_attri_log_item *ATTRI_ITEM(struct xfs_log_item *lip)
>> +{
>> +	return container_of(lip, struct xfs_attri_log_item, attri_item);
>> +}
>> +
>> +STATIC void
>> +xfs_attri_item_free(
>> +	struct xfs_attri_log_item	*attrip)
>> +{
>> +	kmem_free(attrip->attri_item.li_lv_shadow);
>> +	kmem_free(attrip);
>> +}
>> +
>> +/*
>> + * Freeing the attrip requires that we remove it from the AIL if it has already
>> + * been placed there. However, the ATTRI may not yet have been placed in the
>> + * AIL when called by xfs_attri_release() from ATTRD processing due to the
>> + * ordering of committed vs unpin operations in bulk insert operations. Hence
>> + * the reference count to ensure only the last caller frees the ATTRI.
>> + */
>> +STATIC void
>> +xfs_attri_release(
>> +	struct xfs_attri_log_item	*attrip)
>> +{
>> +	ASSERT(atomic_read(&attrip->attri_refcount) > 0);
>> +	if (atomic_dec_and_test(&attrip->attri_refcount)) {
>> +		xfs_trans_ail_delete(&attrip->attri_item,
>> +				     SHUTDOWN_LOG_IO_ERROR);
>> +		xfs_attri_item_free(attrip);
>> +	}
>> +}
>> +
>> +STATIC void
>> +xfs_attri_item_size(
>> +	struct xfs_log_item		*lip,
>> +	int				*nvecs,
>> +	int				*nbytes)
>> +{
>> +	struct xfs_attri_log_item       *attrip = ATTRI_ITEM(lip);
>> +
>> +	*nvecs += 2;
>> +	*nbytes += sizeof(struct xfs_attri_log_format) +
>> +			xlog_calc_iovec_len(attrip->attri_name_len);
>> +
>> +	if (!attrip->attri_value_len)
>> +		return;
>> +
>> +	*nvecs += 1;
>> +	*nbytes += xlog_calc_iovec_len(attrip->attri_value_len);
>> +}
>> +
>> +/*
>> + * This is called to fill in the log iovecs for the given attri log
>> + * item. We use  1 iovec for the attri_format_item, 1 for the name, and
>> + * another for the value if it is present
>> + */
>> +STATIC void
>> +xfs_attri_item_format(
>> +	struct xfs_log_item	*lip,
>> +	struct xfs_log_vec	*lv)
>> +{
>> +	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
>> +	struct xfs_log_iovec		*vecp = NULL;
> 
> Nit: Lining up the name indentation here.
> 
Sure, will fix

>> +
>> +	attrip->attri_format.alfi_type = XFS_LI_ATTRI;
>> +	attrip->attri_format.alfi_size = 1;
>> +
>> +	/*
>> +	 * This size accounting must be done before copying the attrip into the
>> +	 * iovec.  If we do it after, the wrong size will be recorded to the log
>> +	 * and we trip across assertion checks for bad region sizes later during
>> +	 * the log recovery.
>> +	 */
>> +
>> +	ASSERT(attrip->attri_name_len > 0);
>> +	attrip->attri_format.alfi_size++;
>> +
>> +	if (attrip->attri_value_len > 0)
>> +		attrip->attri_format.alfi_size++;
>> +
>> +	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTRI_FORMAT,
>> +			&attrip->attri_format,
>> +			sizeof(struct xfs_attri_log_format));
>> +	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_NAME,
>> +			attrip->attri_name,
>> +			xlog_calc_iovec_len(attrip->attri_name_len));
>> +	if (attrip->attri_value_len > 0)
>> +		xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_VALUE,
>> +				attrip->attri_value,
>> +				xlog_calc_iovec_len(attrip->attri_value_len));
>> +}
> 
> <snip since the omitted code hasn't changed in ages>
> 
>> +STATIC int
>> +xlog_recover_attri_commit_pass2(
>> +	struct xlog                     *log,
>> +	struct list_head		*buffer_list,
>> +	struct xlog_recover_item        *item,
>> +	xfs_lsn_t                       lsn)
>> +{
>> +	int                             error;
>> +	struct xfs_mount                *mp = log->l_mp;
>> +	struct xfs_attri_log_item       *attrip;
>> +	struct xfs_attri_log_format     *attri_formatp;
>> +	char				*name = NULL;
>> +	char				*value = NULL;
>> +	int				region = 0;
>> +	int				buffer_size;
>> +
>> +	attri_formatp = item->ri_buf[region].i_addr;
>> +
>> +	/* Validate xfs_attri_log_format */
>> +	if (!xfs_attri_validate(mp, attri_formatp)) {
>> +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
>> +		return -EFSCORRUPTED;
>> +	}
>> +
>> +	buffer_size = attri_formatp->alfi_name_len +
>> +		      attri_formatp->alfi_value_len;
>> +
>> +	/* memory alloc failure will cause replay to abort */
>> +	attrip = xfs_attri_init(mp, buffer_size);
>> +	if (attrip == NULL)
>> +		return -ENOMEM;
>> +
>> +	error = xfs_attri_copy_format(&item->ri_buf[region],
>> +				      &attrip->attri_format);
>> +	if (error)
>> +		goto out;
>> +
>> +	attrip->attri_name_len = attri_formatp->alfi_name_len;
>> +	attrip->attri_value_len = attri_formatp->alfi_value_len;
>> +	region++;
>> +	name = ((char *)attrip) + sizeof(struct xfs_attri_log_item);
>> +	memcpy(name, item->ri_buf[region].i_addr, attrip->attri_name_len);
>> +	attrip->attri_name = name;
>> +
>> +	if (!xfs_attr_namecheck(name, attrip->attri_name_len)) {
>> +		error = -EFSCORRUPTED;
> 
> This should XFS_ERROR_REPORT so the sysadmin knows why the mount failed.
> 
Ok, makes sense.

>> +		goto out;
>> +	}
>> +
>> +	if (attrip->attri_value_len > 0) {
>> +		region++;
>> +		value = ((char *)attrip) + sizeof(struct xfs_attri_log_item) +
>> +				attrip->attri_name_len;
>> +		memcpy(value, item->ri_buf[region].i_addr,
>> +				attrip->attri_value_len);
>> +		attrip->attri_value = value;
>> +	}
>> +
>> +	/*
>> +	 * The ATTRI has two references. One for the ATTRD and one for ATTRI to
>> +	 * ensure it makes it into the AIL. Insert the ATTRI into the AIL
>> +	 * directly and drop the ATTRI reference. Note that
>> +	 * xfs_trans_ail_update() drops the AIL lock.
>> +	 */
>> +	xfs_trans_ail_insert(log->l_ailp, &attrip->attri_item, lsn);
>> +	xfs_attri_release(attrip);
>> +	return 0;
>> +out:
>> +	xfs_attri_item_free(attrip);
>> +	return error;
>> +}
>> +
>> +/*
>> + * This routine is called when an ATTRD format structure is found in a committed
>> + * transaction in the log. Its purpose is to cancel the corresponding ATTRI if
>> + * it was still in the log. To do this it searches the AIL for the ATTRI with
>> + * an id equal to that in the ATTRD format structure. If we find it we drop
>> + * the ATTRD reference, which removes the ATTRI from the AIL and frees it.
>> + */
>> +STATIC int
>> +xlog_recover_attrd_commit_pass2(
>> +	struct xlog			*log,
>> +	struct list_head		*buffer_list,
>> +	struct xlog_recover_item	*item,
>> +	xfs_lsn_t			lsn)
>> +{
>> +	struct xfs_attrd_log_format	*attrd_formatp;
>> +
>> +	attrd_formatp = item->ri_buf[0].i_addr;
>> +	if (item->ri_buf[0].i_len != sizeof(struct xfs_attrd_log_format)) {
>> +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
>> +		return -EFSCORRUPTED;
>> +	}
>> +
>> +	xlog_recover_release_intent(log, XFS_LI_ATTRI,
>> +				    attrd_formatp->alfd_alf_id);
>> +	return 0;
>> +}
>> +
>> +static const struct xfs_item_ops xfs_attri_item_ops = {
>> +	.iop_size	= xfs_attri_item_size,
>> +	.iop_format	= xfs_attri_item_format,
>> +	.iop_unpin	= xfs_attri_item_unpin,
>> +	.iop_committed	= xfs_attri_item_committed,
>> +	.iop_release    = xfs_attri_item_release,
>> +	.iop_match	= xfs_attri_item_match,
>> +};
>> +
>> +const struct xlog_recover_item_ops xlog_attri_item_ops = {
>> +	.item_type	= XFS_LI_ATTRI,
>> +	.commit_pass2	= xlog_recover_attri_commit_pass2,
>> +};
>> +
>> +static const struct xfs_item_ops xfs_attrd_item_ops = {
>> +	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
>> +	.iop_size	= xfs_attrd_item_size,
>> +	.iop_format	= xfs_attrd_item_format,
>> +	.iop_release    = xfs_attrd_item_release,
>> +};
>> +
>> +const struct xlog_recover_item_ops xlog_attrd_item_ops = {
>> +	.item_type	= XFS_LI_ATTRD,
>> +	.commit_pass2	= xlog_recover_attrd_commit_pass2,
>> +};
>> diff --git a/fs/xfs/xfs_attr_item.h b/fs/xfs/xfs_attr_item.h
>> new file mode 100644
>> index 000000000000..34b04377a891
>> --- /dev/null
>> +++ b/fs/xfs/xfs_attr_item.h
>> @@ -0,0 +1,46 @@
>> +/* SPDX-License-Identifier: GPL-2.0-or-later
>> + *
>> + * Copyright (C) 2021 Oracle.  All Rights Reserved.
>> + * Author: Allison Collins <allison.henderson@oracle.com>
> 
> Year update here too.
Will update

> 
>> + */
>> +#ifndef	__XFS_ATTR_ITEM_H__
>> +#define	__XFS_ATTR_ITEM_H__
>> +
>> +/* kernel only ATTRI/ATTRD definitions */
>> +
>> +struct xfs_mount;
>> +struct kmem_zone;
>> +
>> +/*
>> + * This is the "attr intention" log item.  It is used to log the fact that some
>> + * extended attribute operations need to be processed.  An operation is
>> + * currently either a set or remove.  Set or remove operations are described by
>> + * the xfs_attr_item which may be logged to this intent.
>> + *
>> + * During a normal attr operation, name and value point to the name and value
>> + * fields of the calling functions xfs_da_args.  During a recovery, the name
> 
> I initially thought 'calling' and 'functions' were a verb and object,
> then realized that 'functions' is a possessive.  How about rewording
> that slightly:
> 
> "...of the caller's xfs_da_args structure."
> 
ok, that sounds fine to me

> So that with all those nits cleaned up,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Great!  Thanks for the reviews!
Allison

> 
> --D
> 
>> + * and value buffers are copied from the log, and stored in a trailing buffer
>> + * attached to the xfs_attr_item until they are committed.  They are freed when
>> + * the xfs_attr_item itself is freed when the work is done.
>> + */
>> +struct xfs_attri_log_item {
>> +	struct xfs_log_item		attri_item;
>> +	atomic_t			attri_refcount;
>> +	int				attri_name_len;
>> +	int				attri_value_len;
>> +	void				*attri_name;
>> +	void				*attri_value;
>> +	struct xfs_attri_log_format	attri_format;
>> +};
>> +
>> +/*
>> + * This is the "attr done" log item.  It is used to log the fact that some attrs
>> + * earlier mentioned in an attri item have been freed.
>> + */
>> +struct xfs_attrd_log_item {
>> +	struct xfs_log_item		attrd_item;
>> +	struct xfs_attri_log_item	*attrd_attrip;
>> +	struct xfs_attrd_log_format	attrd_format;
>> +};
>> +
>> +#endif	/* __XFS_ATTR_ITEM_H__ */
>> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
>> index 2d1e5134cebe..90a14e85e76d 100644
>> --- a/fs/xfs/xfs_attr_list.c
>> +++ b/fs/xfs/xfs_attr_list.c
>> @@ -15,6 +15,7 @@
>>   #include "xfs_inode.h"
>>   #include "xfs_trans.h"
>>   #include "xfs_bmap.h"
>> +#include "xfs_da_btree.h"
>>   #include "xfs_attr.h"
>>   #include "xfs_attr_sf.h"
>>   #include "xfs_attr_leaf.h"
>> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
>> index 004ed2a251e8..618a46a1d5fb 100644
>> --- a/fs/xfs/xfs_ioctl32.c
>> +++ b/fs/xfs/xfs_ioctl32.c
>> @@ -17,6 +17,8 @@
>>   #include "xfs_itable.h"
>>   #include "xfs_fsops.h"
>>   #include "xfs_rtalloc.h"
>> +#include "xfs_da_format.h"
>> +#include "xfs_da_btree.h"
>>   #include "xfs_attr.h"
>>   #include "xfs_ioctl.h"
>>   #include "xfs_ioctl32.h"
>> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
>> index 3447c19e99da..7cf7b4fce4b9 100644
>> --- a/fs/xfs/xfs_iops.c
>> +++ b/fs/xfs/xfs_iops.c
>> @@ -13,6 +13,8 @@
>>   #include "xfs_inode.h"
>>   #include "xfs_acl.h"
>>   #include "xfs_quota.h"
>> +#include "xfs_da_format.h"
>> +#include "xfs_da_btree.h"
>>   #include "xfs_attr.h"
>>   #include "xfs_trans.h"
>>   #include "xfs_trace.h"
>> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
>> index 89fec9a18c34..8ba8563114b9 100644
>> --- a/fs/xfs/xfs_log.c
>> +++ b/fs/xfs/xfs_log.c
>> @@ -2157,6 +2157,10 @@ xlog_print_tic_res(
>>   	    REG_TYPE_STR(CUD_FORMAT, "cud_format"),
>>   	    REG_TYPE_STR(BUI_FORMAT, "bui_format"),
>>   	    REG_TYPE_STR(BUD_FORMAT, "bud_format"),
>> +	    REG_TYPE_STR(ATTRI_FORMAT, "attri_format"),
>> +	    REG_TYPE_STR(ATTRD_FORMAT, "attrd_format"),
>> +	    REG_TYPE_STR(ATTR_NAME, "attr name"),
>> +	    REG_TYPE_STR(ATTR_VALUE, "attr value"),
>>   	};
>>   	BUILD_BUG_ON(ARRAY_SIZE(res_type_str) != XLOG_REG_TYPE_MAX + 1);
>>   #undef REG_TYPE_STR
>> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
>> index dc1b77b92fc1..fd945eb66c32 100644
>> --- a/fs/xfs/xfs_log.h
>> +++ b/fs/xfs/xfs_log.h
>> @@ -21,6 +21,17 @@ struct xfs_log_vec {
>>   
>>   #define XFS_LOG_VEC_ORDERED	(-1)
>>   
>> +/*
>> + * Calculate the log iovec length for a given user buffer length. Intended to be
>> + * used by ->iop_size implementations when sizing buffers of arbitrary
>> + * alignments.
>> + */
>> +static inline int
>> +xlog_calc_iovec_len(int len)
>> +{
>> +	return roundup(len, sizeof(int32_t));
>> +}
>> +
>>   static inline void *
>>   xlog_prepare_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec **vecp,
>>   		uint type)
>> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
>> index 96c997ed2ec8..f1edb315e341 100644
>> --- a/fs/xfs/xfs_log_recover.c
>> +++ b/fs/xfs/xfs_log_recover.c
>> @@ -1800,6 +1800,8 @@ static const struct xlog_recover_item_ops *xlog_recover_item_ops[] = {
>>   	&xlog_cud_item_ops,
>>   	&xlog_bui_item_ops,
>>   	&xlog_bud_item_ops,
>> +	&xlog_attri_item_ops,
>> +	&xlog_attrd_item_ops,
>>   };
>>   
>>   static const struct xlog_recover_item_ops *
>> diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
>> index 25991923c1a8..758702b9495f 100644
>> --- a/fs/xfs/xfs_ondisk.h
>> +++ b/fs/xfs/xfs_ondisk.h
>> @@ -132,6 +132,8 @@ xfs_check_ondisk_structs(void)
>>   	XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format,	56);
>>   	XFS_CHECK_STRUCT_SIZE(struct xfs_qoff_logformat,	20);
>>   	XFS_CHECK_STRUCT_SIZE(struct xfs_trans_header,		16);
>> +	XFS_CHECK_STRUCT_SIZE(struct xfs_attri_log_format,	40);
>> +	XFS_CHECK_STRUCT_SIZE(struct xfs_attrd_log_format,	16);
>>   
>>   	/*
>>   	 * The v5 superblock format extended several v4 header structures with
>> -- 
>> 2.25.1
>>
