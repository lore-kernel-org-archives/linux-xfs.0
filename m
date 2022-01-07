Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D47EFC433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  7 Jan 2022 16:11:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233092AbiAGQLI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 7 Jan 2022 11:11:08 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:65184 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231302AbiAGQLH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Jan 2022 11:11:07 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 207DvSjv014394;
        Fri, 7 Jan 2022 16:11:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : message-id : in-reply-to : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=JNGJgPluvZeJiaT+6KNDjajKsXK14jtt3PwJvWL9Zxk=;
 b=frFj3xigzjCLY3RUmOQfNpMN46iMXgNxOD5Dwh5QWC0cOj1IAz26FFa8Tgbcz0tbi16r
 V9rb72jJAz331ssSGzb9A6jtFvfTdifqwH4ltsI1Apz4uPKbghf73xappwLOQRyYVY9U
 cNpmQJma/TtCc9DniSjBYhz5d//xeJimGL9qrNdIY8xyZyBuCWOtJhb17hXyBweBDY5k
 VHzIf95GZyZHjr6rvc6uVyibRBHM29P6SvLgYWRB7WZQGLyqAkO4a+Cgicny1X0lDXYG
 pMjsN5PJ7DHsH7LzPuK74ZYwNqMJa9dNUPcOt+Txih2/r33Mn1FI0fQ4VT3+52ORiVoG EQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3de4v8jdxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jan 2022 16:11:02 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 207G6Fmv130412;
        Fri, 7 Jan 2022 16:11:01 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2042.outbound.protection.outlook.com [104.47.73.42])
        by aserp3030.oracle.com with ESMTP id 3de4w389f6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jan 2022 16:11:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CVDVV6E5eryIMc1xAQW3Ct21bneGGru4ravQ5urSdJI/ykBud/WdCUB22Ys+ruddrV2rfHqAlz57D2lU0oHRw/gCrYLcPO1pdVap6kn9wbTreDv9b+KjTR/LqPgjtEW6mEMH3ISiHkys1OewgwVCylHGoMUaZqeW6vFlvsh7IUZg79Aag6ZKbI2V8LhSNgXqLt9C/pw8/UaFg9voUpZqBDcCSpCesLveQedl4jJlsQvU0SWWL5PsqhbEAFNqR2O7DruX+kmTiyLJT/IqH7R5CjkaD29k4zmBleuLg0+T1tLVSwTvKRHpcyUOZtpU1V29lJBiABmaudrlounrc7N1Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JNGJgPluvZeJiaT+6KNDjajKsXK14jtt3PwJvWL9Zxk=;
 b=dDCsdkK5hKztJHGx3pvolQYYuD0f6JcLF2I3YR8MSrFm1sQWPLl6Q7a5xRyp/gwpFms62LO/YcYAM4E4wqkDfrJ6ty2FwDt+gFLubmWFbTFYmu84l/SOrI/Ax6rzx7JJ+1NxvYeUfNz5oQjuxY8SeUxcUrnCGyzN7lOkcuBpPG3JacKSMSP1TPn3oFjibyKUu2idocxBaAdz/5UR1wI03D8oEBSAQehAdexQfaGFLt06v6C0ZA8rWO2XASC2Q9yjmAvvB95UoUd43elxgrA2KKy4PDnhx7meTwS/HUHZ3iqPyGLRad4JtxIxo01cBAYYhKc1QzMCqCiqxeaWqQBcwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JNGJgPluvZeJiaT+6KNDjajKsXK14jtt3PwJvWL9Zxk=;
 b=HZkg4mZKUmGns88AiqVYpwPoCXYxq6gnj7jLwTaf6jrjKJvxp6NepHyJPZiAszHE8K9INwg5mFQ/QlueJ1+svBVPN23Fv/vR2JlyK8U2WYkF3J+WVfa5IWyTcNqENc9NSxqxDTF7aeBJ0yMBmvhJaJBMcdKz19uD7oDNcE80soo=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2928.namprd10.prod.outlook.com (2603:10b6:805:d2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Fri, 7 Jan
 2022 16:10:59 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%7]) with mapi id 15.20.4867.011; Fri, 7 Jan 2022
 16:10:59 +0000
References: <20211214084811.764481-1-chandan.babu@oracle.com>
 <20211214084811.764481-14-chandan.babu@oracle.com>
 <20220105011213.GB656707@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH V4 13/20] xfsprogs: Introduce per-inode 64-bit extent
 counters
Message-ID: <87a6ga8a8c.fsf@debian-BULLSEYE-live-builder-AMD64>
In-reply-to: <20220105011213.GB656707@magnolia>
Date:   Fri, 07 Jan 2022 21:40:45 +0530
Content-Type: text/plain
X-ClientProxiedBy: SGAP274CA0020.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::32)
 To SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd2850e7-52a5-45df-d0e5-08d9d1f84a6e
X-MS-TrafficTypeDiagnostic: SN6PR10MB2928:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB292858F361A381A26A2473A5F64D9@SN6PR10MB2928.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ANKHscghlYb+4ZJcyRlBdmwMMxHeYfRtDrgZ3/WNB4Iyv3MmiYmurmw0/fQl3tTzrgBkAxjHeGJ6qLcTc0ddKscbCowkzA7x/JhwXoZ4wMxzd6Sc0v7Je/sLIswacLsMyU3ty06K+xC+pR70+AjRh3y+Xjee5+Kj2K3IzXi85uRH38wX4Pu8E9UJL6yB5RGxhOFbAranb/YrWEO81FgYZGWuBpQE/uKywYxFlyDEMe3fq0S8pRorTmuZuNMvuGLNIlv5PO5udpa5XmBJxIpVMghPBUKq5liDdSbxvWfLDc7RxBVjH7pvXDJb3kA7pBsweaWMQKvIVY0ixdwQR9ZumpFFQMyzRPPEeJ4fqPo9D+hGkMDSMplacRR3yhaCCN2Ca0yV6QhJpGQz0eRKQ2+vzvOndmiSwslzvZoAkAprhauKVc/e8ZCL+akiOYVXw38Xh1F2jvKi8NyAQ/9I6pTn3JDDCwh6cYcjFfiJPY9vGBqHjESPTUN7l7O6QOGeSqAuqKzVhLlE6+wq66YFNvtikRGhvbc74EKVU+ESwIe0WG8nczP1ouYlIZk7mksG/Vv0A0h3ldX+l37jwwonDrKQYsuiDoXmP0XLnGBT2EjfQ0eo9yK+bXcQHcwjZ5WbLCijefHGD+y7QrPnz0ZHazm2XzgHDmRPlaEt0WMYOBJG7eRCikevLMb4kjoGQ8zf46dZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(33716001)(5660300002)(4326008)(83380400001)(66946007)(6916009)(186003)(86362001)(2906002)(508600001)(6486002)(66556008)(6506007)(6512007)(8676002)(9686003)(38350700002)(6666004)(30864003)(8936002)(66476007)(53546011)(26005)(38100700002)(316002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NeFPH42sPmqzJURkB0DT+n5tt+6SMMnrzG1tzJZr2ADIIcABNmI2ZL35eLMO?=
 =?us-ascii?Q?FprLdR1aTWWV+FydW6VIRSrqE0DSxbhpsI9BECsR48onBbm4J0DpL/f9G7kM?=
 =?us-ascii?Q?VoIOZNX+wUA2qycOKFyZ1Ii/qqnLDaD6bY4wxKkK7SA/wJpJ+ahb4hgzbiCH?=
 =?us-ascii?Q?4liVaOyfkkiXRYfnmeH+t1zupfoob8khO3WXq6z3Lbp4cxB3rhVbJVugHgpq?=
 =?us-ascii?Q?ujTHJSESDLYj210/ZhaN/QDltbt/0AgGgfB4/S5qdMN+YVKJPVn3p7jWeDf7?=
 =?us-ascii?Q?Ok+x8o/Ar9O4PwisJIovqSy0gt5QPN5WsvqWIcSQOz6PEIJJoC3Ds0WGdGRg?=
 =?us-ascii?Q?XtuouLdpU1NLzib7W17w0rhKLdWzzYVISSx6+/HPDiMZ9IYadOSFQZfWMQnG?=
 =?us-ascii?Q?Kkf6jrdUXe5dbhzYLWo88/J8OOvdPe4Ywctn9Mm3lU6t5+R7mNL4+GQTd42N?=
 =?us-ascii?Q?YqXViFyuAQA9YpPcboSSKh5c8taAhpu9WCaKEKHc9O6970pBLGciI2loq1o3?=
 =?us-ascii?Q?EwK5wAdl2kL6OFoxeBercc5s8XwL6r9xtu4S401Y24yVfkJ6A4N4XYJrKRG6?=
 =?us-ascii?Q?5Y6x7bSnMYcDegjfUVYeWwBNLpevUkLct1hzGiuDPksAZvIqg3yGeTNZg4YA?=
 =?us-ascii?Q?ZHOyCQs2yqVdJ2E5YgfqPQgVUsUD2RleL9BOLgx/kFXPj4qX+Ea17dbmuIod?=
 =?us-ascii?Q?rwcdEkAP4jKEUsL7wkvV3K9FluTSixRHHaamSt9ulwbiNDjxwJEGWbrYtjCg?=
 =?us-ascii?Q?H6Ciys4rH4+IAH0/yksQSOFk/ulr3HfzLcP27MO7NYZxqo2pw/FwLCskhqKb?=
 =?us-ascii?Q?kjNnRNLxPKcgdN4Pc/KQaZ8ffDZUyDKwPBH7cJEjcbU6j2bpRdGg/45r1mIV?=
 =?us-ascii?Q?nAjWj+atDpNiKw4n7RuE8HCWNVT78Gq4SglBKXwzKIikUcZ2g1HmyF+QHIZ2?=
 =?us-ascii?Q?1xgpgGgRmX0M3ecTNBKMm0fazMuVrmUeqHat8pjm2c2wc8oWS4xmCu7jmjqL?=
 =?us-ascii?Q?xviEdmFlVgs9xuaHyU8ASv2J8s7bUQ6yln73dcOEJq/HnZCW93xUy0+/ov//?=
 =?us-ascii?Q?0HMwY+X/EXKUoQ5+2MvZJTsFJU8ZeV/0I/wWGGMo04iaf+MKf6e1WKC7sZRQ?=
 =?us-ascii?Q?bFEGWoDmGZXcnPXR7RolY7co1ldV2O4odS+0VFDg0P02rtVWYgbZfo9rKkqV?=
 =?us-ascii?Q?dbvh7wO28aoHQ8QenJPJ4TwFaudYBjd2jMBLVYlm1mALUN87yYvRhcn3SxjS?=
 =?us-ascii?Q?hQtl0eZ8/sJatbqvTTaAPNy1XikW9Hm4jRh0YNHpG0Fmj9HXLMqO0bReuyew?=
 =?us-ascii?Q?m9xEjVpT9LgfTjPbnGUk+llJ5e47+tzgMj44uQ2JTYrCYXxs3yKo6+qh+/NN?=
 =?us-ascii?Q?5MueL9AevOVOC25p1ljFMSPkcR7y2B0WJaR8UHM/chAZdecLrqG1FwB68xuF?=
 =?us-ascii?Q?Vhiymqvh4AoAOwkUhFVf4JuxlKF9E3UB0BD1EqYTk2zicBevgGCeQRBHYrck?=
 =?us-ascii?Q?1cdvgBAlxBl/jNcH5lc2396JO+59ohN1VkWRJnZBo0hhn1ki68fK29u06GAl?=
 =?us-ascii?Q?z343Dtq1zNK5BIe7LeXnFW08veYgaiJKesjx2QGrk6yd2kbSGgoZ56xzrr+e?=
 =?us-ascii?Q?Ff7RtelVDHMZvGIsJxdhe2s=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd2850e7-52a5-45df-d0e5-08d9d1f84a6e
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 16:10:58.9567
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gJeGDBvhgl4Tx28ks+OAQUJkGqpFvYprlRBZGWRjN9op14zS3elYoypuYtxoKy9JQURJiLYBWldl9jDfbMunNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2928
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10219 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201070110
X-Proofpoint-ORIG-GUID: UUWTSHAh-EZqnqnftAgHfcd6fKNIdh-I
X-Proofpoint-GUID: UUWTSHAh-EZqnqnftAgHfcd6fKNIdh-I
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 05 Jan 2022 at 06:42, Darrick J. Wong wrote:
> On Tue, Dec 14, 2021 at 02:18:04PM +0530, Chandan Babu R wrote:
>> This commit introduces new fields in the on-disk inode format to support
>> 64-bit data fork extent counters and 32-bit attribute fork extent
>> counters. The new fields will be used only when an inode has
>> XFS_DIFLAG2_NREXT64 flag set. Otherwise we continue to use the regular 32-bit
>> data fork extent counters and 16-bit attribute fork extent counters.
>> 
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> Suggested-by: Dave Chinner <dchinner@redhat.com>
>> ---
>>  db/field.c               |   4 -
>>  db/field.h               |   2 -
>>  db/inode.c               | 170 ++++++++++++++++++++++++++++++++++++++-
>>  libxfs/xfs_format.h      |  22 ++++-
>>  libxfs/xfs_inode_buf.c   |  27 ++++++-
>>  libxfs/xfs_inode_fork.h  |  10 ++-
>>  libxfs/xfs_log_format.h  |  22 ++++-
>>  logprint/log_misc.c      |  20 ++++-
>>  logprint/log_print_all.c |  18 ++++-
>>  repair/dinode.c          |  18 ++++-
>>  10 files changed, 279 insertions(+), 34 deletions(-)
>> 
>> diff --git a/db/field.c b/db/field.c
>> index 51268938..1e274ffc 100644
>> --- a/db/field.c
>> +++ b/db/field.c
>> @@ -25,8 +25,6 @@
>>  #include "symlink.h"
>>  
>>  const ftattr_t	ftattrtab[] = {
>> -	{ FLDT_AEXTNUM, "aextnum", fp_num, "%d", SI(bitsz(xfs_aextnum_t)),
>> -	  FTARG_SIGNED, NULL, NULL },
>>  	{ FLDT_AGBLOCK, "agblock", fp_num, "%u", SI(bitsz(xfs_agblock_t)),
>>  	  FTARG_DONULL, fa_agblock, NULL },
>>  	{ FLDT_AGBLOCKNZ, "agblocknz", fp_num, "%u", SI(bitsz(xfs_agblock_t)),
>> @@ -300,8 +298,6 @@ const ftattr_t	ftattrtab[] = {
>>  	  FTARG_DONULL, fa_drtbno, NULL },
>>  	{ FLDT_EXTLEN, "extlen", fp_num, "%u", SI(bitsz(xfs_extlen_t)), 0, NULL,
>>  	  NULL },
>> -	{ FLDT_EXTNUM, "extnum", fp_num, "%d", SI(bitsz(xfs_extnum_t)),
>> -	  FTARG_SIGNED, NULL, NULL },
>>  	{ FLDT_FSIZE, "fsize", fp_num, "%lld", SI(bitsz(xfs_fsize_t)),
>>  	  FTARG_SIGNED, NULL, NULL },
>>  	{ FLDT_INO, "ino", fp_num, "%llu", SI(bitsz(xfs_ino_t)), FTARG_DONULL,
>> diff --git a/db/field.h b/db/field.h
>> index 387c189e..614fd0ab 100644
>> --- a/db/field.h
>> +++ b/db/field.h
>> @@ -5,7 +5,6 @@
>>   */
>>  
>>  typedef enum fldt	{
>> -	FLDT_AEXTNUM,
>>  	FLDT_AGBLOCK,
>>  	FLDT_AGBLOCKNZ,
>>  	FLDT_AGF,
>> @@ -143,7 +142,6 @@ typedef enum fldt	{
>>  	FLDT_DRFSBNO,
>>  	FLDT_DRTBNO,
>>  	FLDT_EXTLEN,
>> -	FLDT_EXTNUM,
>>  	FLDT_FSIZE,
>>  	FLDT_INO,
>>  	FLDT_INOBT,
>> diff --git a/db/inode.c b/db/inode.c
>> index b1f92d36..226797be 100644
>> --- a/db/inode.c
>> +++ b/db/inode.c
>> @@ -27,6 +27,14 @@ static int	inode_core_nlinkv2_count(void *obj, int startoff);
>>  static int	inode_core_onlink_count(void *obj, int startoff);
>>  static int	inode_core_projid_count(void *obj, int startoff);
>>  static int	inode_core_nlinkv1_count(void *obj, int startoff);
>> +static int	inode_core_big_dextcnt_count(void *obj, int startoff);
>> +static int	inode_core_v3_pad_count(void *obj, int startoff);
>> +static int	inode_core_v2_pad_count(void *obj, int startoff);
>> +static int	inode_core_flushiter_count(void *obj, int startoff);
>> +static int	inode_core_big_aextcnt_count(void *obj, int startoff);
>> +static int	inode_core_nrext64_pad_count(void *obj, int startoff);
>> +static int	inode_core_nextents_count(void *obj, int startoff);
>> +static int	inode_core_anextents_count(void *obj, int startoff);
>>  static int	inode_f(int argc, char **argv);
>>  static int	inode_u_offset(void *obj, int startoff, int idx);
>>  static int	inode_u_bmbt_count(void *obj, int startoff);
>> @@ -90,18 +98,30 @@ const field_t	inode_core_flds[] = {
>>  	  inode_core_projid_count, FLD_COUNT, TYP_NONE },
>>  	{ "projid_hi", FLDT_UINT16D, OI(COFF(projid_hi)),
>>  	  inode_core_projid_count, FLD_COUNT, TYP_NONE },
>> -	{ "pad", FLDT_UINT8X, OI(OFF(pad)), CI(6), FLD_ARRAY|FLD_SKIPALL, TYP_NONE },
>> +	{ "big_dextcnt", FLDT_UINT64D, OI(COFF(big_dextcnt)),
>
> Any reason we don't leave the display names as nextents and naextents?

Using existing names to display extent counts would require an xfs_db user to
additionally check the status of XFS_DIFLAG2_NREXT64 flag in order to
determine the exact source of the extent count (large extent counter vs small
extent counter).

This was the reason to print the large extent counters with different field
names.

Come to think of it, Most of the times an xfs_db user would generally be
interested in the extent counter value rather than the exact field from which
the count has been obtained from. Hence in the interest of optimizing for the
general case, I will change the code to continue to use nextents/naextents
names.

> I think fstests has a fair amount of hardcoded xfs_db output, right?
>

Actually xfs/298 is the only test which refers to nextents field directly,

	_scratch_xfs_db  -c "inode $inode" -c "p core.nextents"

Other tests use the helper function _scratch_get_iext_count() to obtain the
value of extent counters.

I had extended _scratch_get_iext_count() to obtain the correct data/attr fork
extent counters based on whether the per-inode flag XFS_DIFLAG2_NREXT64 is set
or not. This won't be required when xfs_db uses the same names to print the
extent counters.

>> +	  inode_core_big_dextcnt_count, FLD_COUNT, TYP_NONE },
>> +	{ "v3_pad", FLDT_UINT8X, OI(OFF(v3_pad)),
>> +	  inode_core_v3_pad_count, FLD_ARRAY|FLD_COUNT|FLD_SKIPALL, TYP_NONE },
>> +	{ "v2_pad", FLDT_UINT8X, OI(OFF(v2_pad)),
>> +	  inode_core_v2_pad_count, FLD_ARRAY|FLD_COUNT|FLD_SKIPALL, TYP_NONE },
>>  	{ "uid", FLDT_UINT32D, OI(COFF(uid)), C1, 0, TYP_NONE },
>>  	{ "gid", FLDT_UINT32D, OI(COFF(gid)), C1, 0, TYP_NONE },
>> -	{ "flushiter", FLDT_UINT16D, OI(COFF(flushiter)), C1, 0, TYP_NONE },
>> +	{ "flushiter", FLDT_UINT16D, OI(COFF(flushiter)),
>> +	  inode_core_flushiter_count, FLD_COUNT, TYP_NONE },
>>  	{ "atime", FLDT_TIMESTAMP, OI(COFF(atime)), C1, 0, TYP_NONE },
>>  	{ "mtime", FLDT_TIMESTAMP, OI(COFF(mtime)), C1, 0, TYP_NONE },
>>  	{ "ctime", FLDT_TIMESTAMP, OI(COFF(ctime)), C1, 0, TYP_NONE },
>>  	{ "size", FLDT_FSIZE, OI(COFF(size)), C1, 0, TYP_NONE },
>>  	{ "nblocks", FLDT_DRFSBNO, OI(COFF(nblocks)), C1, 0, TYP_NONE },
>>  	{ "extsize", FLDT_EXTLEN, OI(COFF(extsize)), C1, 0, TYP_NONE },
>> -	{ "nextents", FLDT_EXTNUM, OI(COFF(nextents)), C1, 0, TYP_NONE },
>> -	{ "naextents", FLDT_AEXTNUM, OI(COFF(anextents)), C1, 0, TYP_NONE },
>> +	{ "big_aextcnt", FLDT_UINT32D, OI(COFF(big_aextcnt)),
>> +	  inode_core_big_aextcnt_count, FLD_COUNT, TYP_NONE },
>> +	{ "nrext64_pad", FLDT_UINT16D, OI(COFF(nrext64_pad)),
>> +	  inode_core_nrext64_pad_count, FLD_COUNT, TYP_NONE },
>> +	{ "nextents", FLDT_UINT32D, OI(COFF(nextents)),
>> +	  inode_core_nextents_count, FLD_COUNT, TYP_NONE },
>> +	{ "naextents", FLDT_UINT16D, OI(COFF(anextents)),
>> +	  inode_core_anextents_count, FLD_COUNT, TYP_NONE },
>>  	{ "forkoff", FLDT_UINT8D, OI(COFF(forkoff)), C1, 0, TYP_NONE },
>>  	{ "aformat", FLDT_DINODE_FMT, OI(COFF(aformat)), C1, 0, TYP_NONE },
>>  	{ "dmevmask", FLDT_UINT32X, OI(COFF(dmevmask)), C1, 0, TYP_NONE },
>> @@ -403,6 +423,148 @@ inode_core_projid_count(
>>  	return dic->di_version >= 2;
>>  }
>>  
>> +static int
>> +inode_core_big_dextcnt_count(
>> +	void			*obj,
>> +	int			startoff)
>> +{
>> +	struct xfs_dinode	*dic;
>> +
>> +	ASSERT(startoff == 0);
>> +	ASSERT(obj == iocur_top->data);
>> +	dic = obj;
>> +
>> +	if (dic->di_version == 3 &&
>> +		(be64_to_cpu(dic->di_flags2) & XFS_DIFLAG2_NREXT64))
>
> (dic->di_flags2 & cpu_to_be64(XFS_DIFLAG2_NREXT64)) ?
>
> (I forget, does userspace's version of those macros elide constants?)
>
> --D
>


>> +		return 1;
>> +	else
>> +		return 0;
>> +}
>> +
>> +static int
>> +inode_core_v3_pad_count(
>> +	void			*obj,
>> +	int			startoff)
>> +{
>> +	struct xfs_dinode	*dic;
>> +
>> +	ASSERT(startoff == 0);
>> +	ASSERT(obj == iocur_top->data);
>> +	dic = obj;
>> +
>> +	if ((dic->di_version == 3)
>> +		&& !(be64_to_cpu(dic->di_flags2) & XFS_DIFLAG2_NREXT64))
>> +		return 8;
>> +	else
>> +		return 0;
>> +}
>> +
>> +static int
>> +inode_core_v2_pad_count(
>> +	void			*obj,
>> +	int			startoff)
>> +{
>> +	struct xfs_dinode	*dic;
>> +
>> +	ASSERT(startoff == 0);
>> +	ASSERT(obj == iocur_top->data);
>> +	dic = obj;
>> +
>> +	if (dic->di_version == 3)
>> +		return 0;
>> +	else
>> +		return 6;
>> +}
>> +
>> +static int
>> +inode_core_flushiter_count(
>> +	void			*obj,
>> +	int			startoff)
>> +{
>> +	struct xfs_dinode	*dic;
>> +
>> +	ASSERT(startoff == 0);
>> +	ASSERT(obj == iocur_top->data);
>> +	dic = obj;
>> +
>> +	if (dic->di_version == 3)
>> +		return 0;
>> +	else
>> +		return 1;
>> +}
>> +
>> +static int
>> +inode_core_big_aextcnt_count(
>> +	void			*obj,
>> +	int			startoff)
>> +{
>> +	struct xfs_dinode	*dic;
>> +
>> +	ASSERT(startoff == 0);
>> +	ASSERT(obj == iocur_top->data);
>> +	dic = obj;
>> +
>> +	if (dic->di_version == 3 &&
>> +		(be64_to_cpu(dic->di_flags2) & XFS_DIFLAG2_NREXT64))
>> +		return 1;
>> +	else
>> +		return 0;
>> +}
>> +
>> +static int
>> +inode_core_nrext64_pad_count(
>> +	void			*obj,
>> +	int			startoff)
>> +{
>> +	struct xfs_dinode	*dic;
>> +
>> +	ASSERT(startoff == 0);
>> +	ASSERT(obj == iocur_top->data);
>> +	dic = obj;
>> +
>> +	if (dic->di_version == 3 &&
>> +		(be64_to_cpu(dic->di_flags2) & XFS_DIFLAG2_NREXT64))
>> +		return 1;
>> +	else
>> +		return 0;
>> +}
>> +
>> +static int
>> +inode_core_nextents_count(
>> +	void			*obj,
>> +	int			startoff)
>> +{
>> +	struct xfs_dinode	*dic;
>> +
>> +	ASSERT(startoff == 0);
>> +	ASSERT(obj == iocur_top->data);
>> +	dic = obj;
>> +
>> +	if ((dic->di_version == 3)
>> +		&& (be64_to_cpu(dic->di_flags2) & XFS_DIFLAG2_NREXT64))
>> +		return 0;
>> +	else
>> +		return 1;
>> +}
>> +
>> +static int
>> +inode_core_anextents_count(
>> +	void			*obj,
>> +	int			startoff)
>> +{
>> +	struct xfs_dinode	*dic;
>> +
>> +	ASSERT(startoff == 0);
>> +	ASSERT(obj == iocur_top->data);
>> +	dic = obj;
>> +
>> +	if ((dic->di_version == 3)
>> +		&& (be64_to_cpu(dic->di_flags2) & XFS_DIFLAG2_NREXT64))
>> +		return 0;
>> +	else
>> +		return 1;
>> +}
>> +
>>  static int
>>  inode_f(
>>  	int		argc,
>> diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
>> index bdd13ec9..d4c962fc 100644
>> --- a/libxfs/xfs_format.h
>> +++ b/libxfs/xfs_format.h
>> @@ -980,16 +980,30 @@ typedef struct xfs_dinode {
>>  	__be32		di_nlink;	/* number of links to file */
>>  	__be16		di_projid_lo;	/* lower part of owner's project id */
>>  	__be16		di_projid_hi;	/* higher part owner's project id */
>> -	__u8		di_pad[6];	/* unused, zeroed space */
>> -	__be16		di_flushiter;	/* incremented on flush */
>> +	union {
>> +		__be64	di_big_dextcnt;	/* NREXT64 data extents */
>> +		__u8	di_v3_pad[8];	/* !NREXT64 V3 inode zeroed space */
>> +		struct {
>> +			__u8	di_v2_pad[6];	/* V2 inode zeroed space */
>> +			__be16	di_flushiter;	/* V2 inode incremented on flush */
>> +		};
>> +	};
>>  	xfs_timestamp_t	di_atime;	/* time last accessed */
>>  	xfs_timestamp_t	di_mtime;	/* time last modified */
>>  	xfs_timestamp_t	di_ctime;	/* time created/inode modified */
>>  	__be64		di_size;	/* number of bytes in file */
>>  	__be64		di_nblocks;	/* # of direct & btree blocks used */
>>  	__be32		di_extsize;	/* basic/minimum extent size for file */
>> -	__be32		di_nextents;	/* number of extents in data fork */
>> -	__be16		di_anextents;	/* number of extents in attribute fork*/
>> +	union {
>> +		struct {
>> +			__be32	di_big_aextcnt; /* NREXT64 attr extents */
>> +			__be16	di_nrext64_pad; /* NREXT64 unused, zero */
>> +		} __packed;
>> +		struct {
>> +			__be32	di_nextents;	/* !NREXT64 data extents */
>> +			__be16	di_anextents;	/* !NREXT64 attr extents */
>> +		} __packed;
>> +	};
>>  	__u8		di_forkoff;	/* attr fork offs, <<3 for 64b align */
>>  	__s8		di_aformat;	/* format of attr fork's data */
>>  	__be32		di_dmevmask;	/* DMIG event mask */
>> diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
>> index 9bddf790..5c6de73b 100644
>> --- a/libxfs/xfs_inode_buf.c
>> +++ b/libxfs/xfs_inode_buf.c
>> @@ -276,6 +276,25 @@ xfs_inode_to_disk_ts(
>>  	return ts;
>>  }
>>  
>> +static inline void
>> +xfs_inode_to_disk_iext_counters(
>> +	struct xfs_inode	*ip,
>> +	struct xfs_dinode	*to)
>> +{
>> +	if (xfs_inode_has_nrext64(ip)) {
>> +		to->di_big_dextcnt = cpu_to_be64(xfs_ifork_nextents(&ip->i_df));
>> +		to->di_big_aextcnt = cpu_to_be32(xfs_ifork_nextents(ip->i_afp));
>> +		/*
>> +		 * We might be upgrading the inode to use larger extent counters
>> +		 * than was previously used. Hence zero the unused field.
>> +		 */
>> +		to->di_nrext64_pad = cpu_to_be16(0);
>> +	} else {
>> +		to->di_nextents = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
>> +		to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
>> +	}
>> +}
>> +
>>  void
>>  xfs_inode_to_disk(
>>  	struct xfs_inode	*ip,
>> @@ -293,7 +312,6 @@ xfs_inode_to_disk(
>>  	to->di_projid_lo = cpu_to_be16(ip->i_projid & 0xffff);
>>  	to->di_projid_hi = cpu_to_be16(ip->i_projid >> 16);
>>  
>> -	memset(to->di_pad, 0, sizeof(to->di_pad));
>>  	to->di_atime = xfs_inode_to_disk_ts(ip, inode->i_atime);
>>  	to->di_mtime = xfs_inode_to_disk_ts(ip, inode->i_mtime);
>>  	to->di_ctime = xfs_inode_to_disk_ts(ip, inode->i_ctime);
>> @@ -304,8 +322,6 @@ xfs_inode_to_disk(
>>  	to->di_size = cpu_to_be64(ip->i_disk_size);
>>  	to->di_nblocks = cpu_to_be64(ip->i_nblocks);
>>  	to->di_extsize = cpu_to_be32(ip->i_extsize);
>> -	to->di_nextents = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
>> -	to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
>>  	to->di_forkoff = ip->i_forkoff;
>>  	to->di_aformat = xfs_ifork_format(ip->i_afp);
>>  	to->di_flags = cpu_to_be16(ip->i_diflags);
>> @@ -320,11 +336,14 @@ xfs_inode_to_disk(
>>  		to->di_lsn = cpu_to_be64(lsn);
>>  		memset(to->di_pad2, 0, sizeof(to->di_pad2));
>>  		uuid_copy(&to->di_uuid, &ip->i_mount->m_sb.sb_meta_uuid);
>> -		to->di_flushiter = 0;
>> +		memset(to->di_v3_pad, 0, sizeof(to->di_v3_pad));
>>  	} else {
>>  		to->di_version = 2;
>>  		to->di_flushiter = cpu_to_be16(ip->i_flushiter);
>> +		memset(to->di_v2_pad, 0, sizeof(to->di_v2_pad));
>>  	}
>> +
>> +	xfs_inode_to_disk_iext_counters(ip, to);
>>  }
>>  
>>  static xfs_failaddr_t
>> diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
>> index 7d5f0015..03036a2c 100644
>> --- a/libxfs/xfs_inode_fork.h
>> +++ b/libxfs/xfs_inode_fork.h
>> @@ -156,14 +156,20 @@ static inline xfs_extnum_t
>>  xfs_dfork_data_extents(
>>  	struct xfs_dinode	*dip)
>>  {
>> -	return be32_to_cpu(dip->di_nextents);
>> +	if (xfs_dinode_has_nrext64(dip))
>> +		return be64_to_cpu(dip->di_big_dextcnt);
>> +	else
>> +		return be32_to_cpu(dip->di_nextents);
>>  }
>>  
>>  static inline xfs_extnum_t
>>  xfs_dfork_attr_extents(
>>  	struct xfs_dinode	*dip)
>>  {
>> -	return be16_to_cpu(dip->di_anextents);
>> +	if (xfs_dinode_has_nrext64(dip))
>> +		return be32_to_cpu(dip->di_big_aextcnt);
>> +	else
>> +		return be16_to_cpu(dip->di_anextents);
>>  }
>>  
>>  static inline xfs_extnum_t
>> diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
>> index c13608aa..8f8c9869 100644
>> --- a/libxfs/xfs_log_format.h
>> +++ b/libxfs/xfs_log_format.h
>> @@ -388,16 +388,30 @@ struct xfs_log_dinode {
>>  	uint32_t	di_nlink;	/* number of links to file */
>>  	uint16_t	di_projid_lo;	/* lower part of owner's project id */
>>  	uint16_t	di_projid_hi;	/* higher part of owner's project id */
>> -	uint8_t		di_pad[6];	/* unused, zeroed space */
>> -	uint16_t	di_flushiter;	/* incremented on flush */
>> +	union {
>> +		uint64_t	di_big_dextcnt;	/* NREXT64 data extents */
>> +		uint8_t		di_v3_pad[8];	/* !NREXT64 V3 inode zeroed space */
>> +		struct {
>> +			uint8_t	di_v2_pad[6];	/* V2 inode zeroed space */
>> +			uint16_t di_flushiter;	/* V2 inode incremented on flush */
>> +		};
>> +	};
>>  	xfs_log_timestamp_t di_atime;	/* time last accessed */
>>  	xfs_log_timestamp_t di_mtime;	/* time last modified */
>>  	xfs_log_timestamp_t di_ctime;	/* time created/inode modified */
>>  	xfs_fsize_t	di_size;	/* number of bytes in file */
>>  	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
>>  	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
>> -	uint32_t	di_nextents;	/* number of extents in data fork */
>> -	uint16_t	di_anextents;	/* number of extents in attribute fork*/
>> +	union {
>> +		struct {
>> +			uint32_t  di_big_aextcnt; /* NREXT64 attr extents */
>> +			uint16_t  di_nrext64_pad; /* NREXT64 unused, zero */
>> +		} __packed;
>> +		struct {
>> +			uint32_t  di_nextents;    /* !NREXT64 data extents */
>> +			uint16_t  di_anextents;   /* !NREXT64 attr extents */
>> +		} __packed;
>> +	};
>>  	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
>>  	int8_t		di_aformat;	/* format of attr fork's data */
>>  	uint32_t	di_dmevmask;	/* DMIG event mask */
>> diff --git a/logprint/log_misc.c b/logprint/log_misc.c
>> index 35e926a3..721c2eb5 100644
>> --- a/logprint/log_misc.c
>> +++ b/logprint/log_misc.c
>> @@ -440,6 +440,8 @@ static void
>>  xlog_print_trans_inode_core(
>>  	struct xfs_log_dinode	*ip)
>>  {
>> +    xfs_extnum_t		nextents;
>> +
>>      printf(_("INODE CORE\n"));
>>      printf(_("magic 0x%hx mode 0%ho version %d format %d\n"),
>>  	   ip->di_magic, ip->di_mode, (int)ip->di_version,
>> @@ -450,11 +452,21 @@ xlog_print_trans_inode_core(
>>  		xlog_extract_dinode_ts(ip->di_atime),
>>  		xlog_extract_dinode_ts(ip->di_mtime),
>>  		xlog_extract_dinode_ts(ip->di_ctime));
>> -    printf(_("size 0x%llx nblocks 0x%llx extsize 0x%x nextents 0x%x\n"),
>> +
>> +    if (ip->di_flags2 & XFS_DIFLAG2_NREXT64)
>> +	    nextents = ip->di_big_dextcnt;
>> +    else
>> +	    nextents = ip->di_nextents;
>> +    printf(_("size 0x%llx nblocks 0x%llx extsize 0x%x nextents 0x%lx\n"),
>>  	   (unsigned long long)ip->di_size, (unsigned long long)ip->di_nblocks,
>> -	   ip->di_extsize, ip->di_nextents);
>> -    printf(_("naextents 0x%x forkoff %d dmevmask 0x%x dmstate 0x%hx\n"),
>> -	   ip->di_anextents, (int)ip->di_forkoff, ip->di_dmevmask,
>> +	   ip->di_extsize, nextents);
>> +
>> +    if (ip->di_flags2 & XFS_DIFLAG2_NREXT64)
>> +	    nextents = ip->di_big_aextcnt;
>> +    else
>> +	    nextents = ip->di_anextents;
>> +    printf(_("naextents 0x%lx forkoff %d dmevmask 0x%x dmstate 0x%hx\n"),
>> +	   nextents, (int)ip->di_forkoff, ip->di_dmevmask,
>>  	   ip->di_dmstate);
>>      printf(_("flags 0x%x gen 0x%x\n"),
>>  	   ip->di_flags, ip->di_gen);
>> diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
>> index c9c453f6..5e387f38 100644
>> --- a/logprint/log_print_all.c
>> +++ b/logprint/log_print_all.c
>> @@ -240,7 +240,10 @@ STATIC void
>>  xlog_recover_print_inode_core(
>>  	struct xfs_log_dinode	*di)
>>  {
>> -	printf(_("	CORE inode:\n"));
>> +	xfs_extnum_t		nextents;
>> +	xfs_aextnum_t		anextents;
>> +
>> +        printf(_("	CORE inode:\n"));
>>  	if (!print_inode)
>>  		return;
>>  	printf(_("		magic:%c%c  mode:0x%x  ver:%d  format:%d\n"),
>> @@ -254,10 +257,19 @@ xlog_recover_print_inode_core(
>>  			xlog_extract_dinode_ts(di->di_mtime),
>>  			xlog_extract_dinode_ts(di->di_ctime));
>>  	printf(_("		flushiter:%d\n"), di->di_flushiter);
>> +
>> +	if (di->di_flags2 & XFS_DIFLAG2_NREXT64) {
>> +		nextents = di->di_big_dextcnt;
>> +		anextents = di->di_big_aextcnt;
>> +	} else {
>> +		nextents = di->di_nextents;
>> +		anextents = di->di_anextents;
>> +	}
>> +
>>  	printf(_("		size:0x%llx  nblks:0x%llx  exsize:%d  "
>> -	     "nextents:%d  anextents:%d\n"), (unsigned long long)
>> +	     "nextents:%lu  anextents:%u\n"), (unsigned long long)
>>  	       di->di_size, (unsigned long long)di->di_nblocks,
>> -	       di->di_extsize, di->di_nextents, (int)di->di_anextents);
>> +	       di->di_extsize, nextents, anextents);
>>  	printf(_("		forkoff:%d  dmevmask:0x%x  dmstate:%d  flags:0x%x  "
>>  	     "gen:%u\n"),
>>  	       (int)di->di_forkoff, di->di_dmevmask, (int)di->di_dmstate,
>> diff --git a/repair/dinode.c b/repair/dinode.c
>> index 0df84e48..3be2e1d5 100644
>> --- a/repair/dinode.c
>> +++ b/repair/dinode.c
>> @@ -71,7 +71,12 @@ _("would have cleared inode %" PRIu64 " attributes\n"), ino_num);
>>  	if (xfs_dfork_attr_extents(dino) != 0) {
>>  		if (no_modify)
>>  			return(1);
>> -		dino->di_anextents = cpu_to_be16(0);
>> +
>> +		if (xfs_dinode_has_nrext64(dino))
>> +			dino->di_big_aextcnt = 0;
>> +		else
>> +			dino->di_anextents = 0;
>> +
>>  	}
>>  
>>  	if (dino->di_aformat != XFS_DINODE_FMT_EXTENTS)  {
>> @@ -1818,7 +1823,10 @@ _("too many data fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
>>  			do_warn(
>>  _("correcting nextents for inode %" PRIu64 ", was %lu - counted %" PRIu64 "\n"),
>>  				lino, dnextents, nextents);
>> -			dino->di_nextents = cpu_to_be32(nextents);
>> +			if (xfs_dinode_has_nrext64(dino))
>> +				dino->di_big_dextcnt = cpu_to_be64(nextents);
>> +			else
>> +				dino->di_nextents = cpu_to_be32(nextents);
>>  			*dirty = 1;
>>  		} else  {
>>  			do_warn(
>> @@ -1841,7 +1849,11 @@ _("too many attr fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
>>  			do_warn(
>>  _("correcting anextents for inode %" PRIu64 ", was %lu - counted %" PRIu64 "\n"),
>>  				lino, dnextents, anextents);
>> -			dino->di_anextents = cpu_to_be16(anextents);
>> +			if (xfs_dinode_has_nrext64(dino))
>> +				dino->di_big_aextcnt = cpu_to_be32(anextents);
>> +			else
>> +				dino->di_anextents = cpu_to_be16(anextents);
>> +
>>  			*dirty = 1;
>>  		} else  {
>>  			do_warn(
>> -- 
>> 2.30.2
>> 


-- 
chandan
