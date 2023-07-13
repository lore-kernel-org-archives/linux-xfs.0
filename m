Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31FC5EB64DD
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Jul 2023 06:40:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233452AbjGMGkL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Jul 2023 02:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233303AbjGMGkJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jul 2023 02:40:09 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8415F1724
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 23:40:08 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36CLAKA6010415;
        Thu, 13 Jul 2023 06:40:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=WbbR7RvvTAMocopbje5sNqZ7lSTe/BBwpdxQDIraMkg=;
 b=4I8jDrp5Kmw6KbwsVSkGkKn1ncI1rPDewcI/tobHh22d9o820ZDxIHtsH62gS3g3UiC2
 eqoahRK1QzD7U16UPbzFHCOwg91SZdHK/AwRWcP3Xre1YK98170e76q7ZtYAmE9AAsgr
 zeO6ZHRlYQAyEY0Yl29zFfmz07ENKh28OVJdLuil8On2x2g6w6StEvN1KEgNi6AhIKYg
 vPo1nhGtZwqVbWwNzwnpQlcyCvNT6l80b0JQPvlFOqYXH6fnebW6vnQuoomgflKh5aY9
 FlvDJtC/auGdB2/TymJ4JopVm24mfd2DRHtv4ZnMAeN8JXpTk7hxUHtPK35znyVQejzu nA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rpydu0thf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 06:40:04 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36D4ceAm007221;
        Thu, 13 Jul 2023 06:40:03 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2047.outbound.protection.outlook.com [104.47.57.47])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx87tbhy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 06:40:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oGAGpp0+a8tGS54sfvBkRwY4UPFOcnFmrFAhKQOHeCeN+AwKY69ZFHRamp7U+bvWg5+M+0sEnK3IgGDBJ6Z88qXHfu20cGk6OXU+sdglg/vfLD2+YlPITeG6/xY/MDL8kF5mHG+GvN9NA3Z6MWH3vhKBy5QpZoLgr9WXAJQdIO/9ShO/VH86tM1W2RWcqhrvuEIMQCrEPXSOHlbZ0sD0gmvnzHm3C20g7hE46k3zEUfw6xPIj4yzhXJGooXKS+Er9lJQY+Pw5fWbe+fzp5GVGVb15SQEaz7PzzkyE4GG2HkhI+eZ/8TzaZWP5DvLZN6SYCB612QAXeTCf+kiZrKfZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WbbR7RvvTAMocopbje5sNqZ7lSTe/BBwpdxQDIraMkg=;
 b=kbclmObPKKFphafqYkQ5bz8imxYYJS+9NaOrLe6vhV1W8DYaTQq5nxw0N0Sow7RILgiABbKq9POluGGRYtwh2i2PuGIVha3TOpcgv1KB1hkY7A1YFMEqu4sX23cAzmeFZ/ikgXDax1bQTnBDq1/2Ouv4bu+hBC2q2wDowXM+y0ABx1fxFcdjJvmSuNqdx7zCAB/ZEKi1vs92gY6Pcu8/o7emEdANT4DzQfKgxo68CsqI4cVtTPOQzHDfp7xw+NyN4WMO9ZRppZgqjnjWk86QH71CmcApcLWNNRxVauU9J5+5fCHI1ei8Z/sCqDpZFQ8InekDq6djzIHzewJzZBcMAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WbbR7RvvTAMocopbje5sNqZ7lSTe/BBwpdxQDIraMkg=;
 b=w9XuCjXoHjV0KPTqoPucaj0tvbo6CjEBq4m3WJUNZ6SNCA1I/HijM3ea4fJJ425hnHmGuWceeqP9df79I7f1xamXo/Oaql6u5MUr0wDsUHsrVSGk0IdyXK4AFGE05aBt/rZ5AvxabbV7xLY1KwjojVXRSj/KOUMMqnnV6/fhnN0=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by SJ2PR10MB7759.namprd10.prod.outlook.com (2603:10b6:a03:578::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.31; Thu, 13 Jul
 2023 06:40:01 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::f1fb:7883:7c6d:4839]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::f1fb:7883:7c6d:4839%7]) with mapi id 15.20.6565.034; Thu, 13 Jul 2023
 06:40:01 +0000
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
 <20230606092806.1604491-11-chandan.babu@oracle.com>
 <20230712171842.GI108251@frogsfrogsfrogs>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH V2 10/23] metadump: Define metadump v2 ondisk format
 structures and macros
Date:   Thu, 13 Jul 2023 10:07:30 +0530
In-reply-to: <20230712171842.GI108251@frogsfrogsfrogs>
Message-ID: <87ilaojow8.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0121.apcprd02.prod.outlook.com
 (2603:1096:4:188::21) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SJ2PR10MB7759:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fd23298-715f-4059-fc7d-08db836bfbcd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u9t/xb7zaOTx0SgeXDwzcJrK8qsndicHu2b4sIyCZwpxahDR7tY7p2Ky3AMfOBc3i7eEhudGgy494j5eWQsQ/vOuCedcHQ+o44ODksV2Fc692SdFsuzPN3qAB593KuQkzJjlt95erg/+UqLxvKHNn809Wvw/8VtGpZhz/A4cR3P8rk4QqnN4feiwym8HoiKDd1UK7NfgvFmqOAt0ExwM4Y01RRl+gyvVjxv4BH9FK3+V2B5lesJ9Y/m14akOKd3Vy207ns7vQ/115KvEI2s72CoNqBd5oJONxGGDsitEHaEgqaowx9YQWnPU9p52JtT0FGgslLCmvkNPtzA0yc1Ge6+CEgdTBwSU36o4nsd69GGAI1cmGUh2BHp32sQkL4CrPaLEg56W2j2KF2A1Jyv8mAJPly5qb1sk9siXuZi8wysf0b2CX2cUV1jNnAokvOSTW25tSYeFpRQ9NWGv3od+PSnqEDek4IeILHhDftQSjnkph5/g9ZGPJfMFOnbD+PkC6YpsiXxrSTUdAlSepdmqc5VHdgxYitxzAOUXVbmHnZoEtSP89yS9GhQ8LuHcb3Yp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(376002)(366004)(346002)(39860400002)(136003)(396003)(451199021)(86362001)(5660300002)(8936002)(8676002)(41300700001)(316002)(2906002)(66946007)(66476007)(6916009)(4326008)(66556008)(38100700002)(66899021)(33716001)(83380400001)(6666004)(478600001)(6486002)(186003)(26005)(6506007)(53546011)(6512007)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ewWOdsNzYiXNRammAkr2wolFaiyA+UDOXTUoYleGepydThqy8HISxPQF/ODK?=
 =?us-ascii?Q?QHbd7QGCkIum9Fa5NGzSLrkNOtEEExr2KzINqgMvJ9xItccoVUVGmoKQryBe?=
 =?us-ascii?Q?vI5+o32+21b/Nn31odhh/6Dz997fxBXstTZU1HWZjckipAcFj/UCwZXl600H?=
 =?us-ascii?Q?wO4mwaiXvriwObNv3ff+rIgR2axvtsyxfDQ7ndzQleIq1TiZG8M/rI8OdUqm?=
 =?us-ascii?Q?JADtjWwfaHmbXOTWBcbr0JT9H7dv9iKy5xEsvCvJ7ffkAultmyUuiz/kz+gj?=
 =?us-ascii?Q?FVbnqu8wjadvVe0vU327IskP95oj9K/ezUXHXmpfZTe9By1E70y/jJV6mZbN?=
 =?us-ascii?Q?zCmFAcewpBszCv0BgvQJfyBHqekYFoge6z3bkK+aBnPK2wBmvTQRVeD54umW?=
 =?us-ascii?Q?C7WGKjkuspVezI75FeqpBLKLYyWMZ31nemmuPQgVmHMG4YbiFM3fCwvFKPU0?=
 =?us-ascii?Q?9bbCegN7Bfl9ej34uEu1X+IAd1DMbpnJwq97khTrjrZvxbvOpCApj2DCIeoC?=
 =?us-ascii?Q?E3HY6WJu3o6S9MP9k3+FDF/fs9iemShQrEHqj+Whw6yjlO0Qe9WHDzJCML3v?=
 =?us-ascii?Q?lHltZUCemmY0BA/rDVAuXjim6e6C85Wuw1P8PHWw/FyIalHruoowVF7COXla?=
 =?us-ascii?Q?uaAIkiro1GSCucluFTGIswfAs5RcH4HbYA7nLdaCIYxvpvOv3h4/4XxRr8GU?=
 =?us-ascii?Q?AvNP0UzrKhr0mWcr6+4zeKz6/yW5KZXXirgZYQsKcUTOcJHV5yIPn32r0RjV?=
 =?us-ascii?Q?QqdsO4TTjR+4ukZw16bVOW856X9ZmKM4tBlFdEUJzzWFomfjddd0IDkJti0/?=
 =?us-ascii?Q?JbvPhEBOKw4LBFXtFFCCV87pOCM/FS+KXk/9TGepuILEHjCcb84bumX5Yh/A?=
 =?us-ascii?Q?lgHloItdhBaZ7dAOaJBSenTlAi+kX1hHq+0To5dLFVHZiObxYXqD7WrECeai?=
 =?us-ascii?Q?TIqk6CZp4WqHV/UOrFaDOsorFO/sSTe68dQsIwTf4S2l1ffOQ9yh29z0se7p?=
 =?us-ascii?Q?TQb+7XfGta+RB8O8sDQPkH86VsA+tNhXJ57lUFbM3MyxVUJXVsNIEZvtuGIa?=
 =?us-ascii?Q?NI4VsiJ2q2Wa9avDjiFG2CI184rG2fiLbSS2EN6nGfta5ojOowQffIDJuf/p?=
 =?us-ascii?Q?BRVwscaNVw9S6KRzjoqs8zILLhllSOdj5R/97d3YhpGoylFnb5RHBrloYwaY?=
 =?us-ascii?Q?VJSrpZj1dNrFHs5xv2IuxM45whSAjyBE/AXqE1wRRt9o04oSX2igyMke5px3?=
 =?us-ascii?Q?NFrmYLAi8s5eLU7tG5gRguCHcODT6Sd6udRxQnC6VwpcC/BAqWzrXdpY/qM9?=
 =?us-ascii?Q?8tv0Y/cA8qE39vxLbT7cqxLotC10Gm94APrzF7btPnhB2+WOpjkMFYb0/Lvn?=
 =?us-ascii?Q?NSbCBTC50T7Ih0NkEr5dZpcgBLdURkSpSCBFjeQQiJMJUUyC7NJcvOgbunCq?=
 =?us-ascii?Q?yQIH4t4xV2SgD9Uw21M63R7YCME5gxv8rosidY6O1KqEbqeZQCv9s+mLwvGD?=
 =?us-ascii?Q?vLIWs+nZyc6fJcPEAHMtyqnXV1SlKaoUKBm0XhTkqpSrE+CFTyBsTvVPRZAv?=
 =?us-ascii?Q?Q1xUOu9lPD7VrI7XYS2AUH1C8+CeIxCDCwihOQrbvzFwQc5td9zKrQfLQPXq?=
 =?us-ascii?Q?fw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: jkH7dUjr8Li63iY7YDNGz8vf/d1xIYCZM7OKRDEJBeu8NBEU1PNjrgM+9eege2X705Svi7leD2vjtL5Y8vqxg03Wabv6ZC7WdQsTxjyC/ZRkEvPmbwd/yYLEYGjIv16xfLrEY0RWZu5IA9TqF7Ukzg6Lb+gEWIxNgwJ+nfeype/P7m1LDbI0Equ9U9WfPNLEqHe8UrbBh7b76UVB0ivmVETvOLYWJsnktd3OrZ51ryY89gryiJm/jQNwelW5AqJlwyGenSq48cKxpZpCFLbxOOGyBlLGyc0iNXjoU4TuWtvDSw58WAwkTO7QXhVjU3iUR2JSKFefu24lkI8PYy+w208y2NMBfX6GVyH2HQmLvpU5yw7Bg0M8QzyP+InSvORNy7MrAEAkF3Wq1mzcbE9t0ojl4AlXp15SPwWB0ko0bIWnaYDcH1mdNkuNh/IVCcjsPmka/ro6ic+wsrN4LHtR7N9sWYAItX9x4zsjzuRSI7cQRTk0/aQepgWvcVMhJLLt9JKT9jedL4dS0dLNkrOBiHQaF5pb7XYRdKCdEjbMCIlQvtbYvVNpKjDHf8inR9/44O2DpezDYQeoi/gNKjGXNplILndGrdpyMXZvfjxMELzeKy+Fn+4Q8vUGNKT+Ew9aktuFEyPxRk/UWJ5JKSb+zKmOOFvgjSnUOhq1xed4He2ZCcSyLY7eyMOxUXNLL36/Dar7PLm08WsN/CpigCjNjlAJNBN5DRW6tCW1MAyjBiMFDTV5FHWhzvbCPdqfUOEvVPa1pe1ckFal2Q/2+ElYe5o8IeYoTUSjsuhJIlWIpQU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fd23298-715f-4059-fc7d-08db836bfbcd
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2023 06:40:01.5485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8fB6BW40EW9kSKNd+YtuZBmxhfyvppWoQ6s6TXub9phBT35RxfNuJgevyQmnONtPxpABwmjBVdpXhpMtHffwTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7759
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-13_03,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 spamscore=0 phishscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307130058
X-Proofpoint-GUID: qpTNSPT9lIiuCjlwpBFBHWzWRVbydbOm
X-Proofpoint-ORIG-GUID: qpTNSPT9lIiuCjlwpBFBHWzWRVbydbOm
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 12, 2023 at 10:18:42 AM -0700, Darrick J. Wong wrote:
> On Tue, Jun 06, 2023 at 02:57:53PM +0530, Chandan Babu R wrote:
>> The corresponding metadump file's disk layout is as shown below,
>> 
>>      |------------------------------|
>>      | struct xfs_metadump_header   |
>>      |------------------------------|
>>      | struct xfs_meta_extent 0     |
>>      | Extent 0's data              |
>>      | struct xfs_meta_extent 1     |
>>      | Extent 1's data              |
>>      | ...                          |
>>      | struct xfs_meta_extent (n-1) |
>>      | Extent (n-1)'s data          |
>>      |------------------------------|
>> 
>> The "struct xfs_metadump_header" is followed by alternating series of "struct
>> xfs_meta_extent" and the extent itself.
>> 
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  include/xfs_metadump.h | 58 ++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 58 insertions(+)
>> 
>> diff --git a/include/xfs_metadump.h b/include/xfs_metadump.h
>> index a4dca25c..518cb302 100644
>> --- a/include/xfs_metadump.h
>> +++ b/include/xfs_metadump.h
>> @@ -8,7 +8,9 @@
>>  #define _XFS_METADUMP_H_
>>  
>>  #define	XFS_MD_MAGIC_V1		0x5846534d	/* 'XFSM' */
>> +#define	XFS_MD_MAGIC_V2		0x584D4432	/* 'XMD2' */
>>  
>> +/* Metadump v1 */
>>  typedef struct xfs_metablock {
>>  	__be32		mb_magic;
>>  	__be16		mb_count;
>> @@ -23,4 +25,60 @@ typedef struct xfs_metablock {
>>  #define XFS_METADUMP_FULLBLOCKS	(1 << 2)
>>  #define XFS_METADUMP_DIRTYLOG	(1 << 3)
>>  
>> +/*
>> + * Metadump v2
>> + *
>> + * The following diagram depicts the ondisk layout of the metadump v2 format.
>> + *
>> + * |------------------------------|
>> + * | struct xfs_metadump_header   |
>> + * |------------------------------|
>> + * | struct xfs_meta_extent 0     |
>> + * | Extent 0's data              |
>> + * | struct xfs_meta_extent 1     |
>> + * | Extent 1's data              |
>> + * | ...                          |
>> + * | struct xfs_meta_extent (n-1) |
>> + * | Extent (n-1)'s data          |
>> + * |------------------------------|
>> + *
>> + * The "struct xfs_metadump_header" is followed by alternating series of "struct
>> + * xfs_meta_extent" and the extent itself.
>> + */
>> +struct xfs_metadump_header {
>> +	__be32		xmh_magic;
>> +	__be32		xmh_version;
>> +	__be32		xmh_compat_flags;
>> +	__be32		xmh_incompat_flags;
>> +	__be64		xmh_reserved;
>> +} __packed;
>> +
>> +#define XFS_MD2_INCOMPAT_OBFUSCATED	(1 << 0)
>> +#define XFS_MD2_INCOMPAT_FULLBLOCKS	(1 << 1)
>> +#define XFS_MD2_INCOMPAT_DIRTYLOG	(1 << 2)
>> +#define XFS_MD2_INCOMPAT_EXTERNALLOG	(1 << 3)
>
> Please document the meaning of these four flags.
>
> /*
>  * User-supplied directory entry and extended attribute names have been
>  * obscured, and extended attribute values are zeroed to protect privacy.
>  */
> #define XFS_MD2_INCOMPAT_OBFUSCATED	(1 << 0)
>
> /* Full blocks have been dumped. */
> #define XFS_MD2_INCOMPAT_FULLBLOCKS	(1 << 1)
>
> /* Log was dirty. */
> #define XFS_MD2_INCOMPAT_DIRTYLOG	(1 << 2)
>
> /* Dump contains external log contents. */
> #define XFS_MD2_INCOMPAT_EXTERNALLOG	(1 << 3)
>
> Otherwise looks fine to me.
>

Sure. I will add the required comments.

-- 
chandan
