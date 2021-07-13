Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E792C07E95
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Jul 2021 18:52:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAAA860FF4
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Jul 2021 18:52:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbhGMSzN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Jul 2021 14:55:13 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:15612 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229478AbhGMSzN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Jul 2021 14:55:13 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16DIfTR9000776;
        Tue, 13 Jul 2021 18:52:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=QuBtZTknjJiMT6vg2eoMQwU1EgnrgS8M2Lj/JgLiKPE=;
 b=u+a+qhTM3RqXYWYdGwqa9bSN6DZHLw0HQXUjhnNQGASAOaXCGBhE0GRWVHOBOv6xT+uc
 I3gzxGTYjhLsH7R4g+u4aDq3uM6WyQVU2pglLY5pmwEMI1g7/6RWic5siltThFsItZIk
 63diQHK6jta3jAnA4rHdFVuVWyQd9SaKcFB3xZUiIIrJ7tPW4y8IoqiKKEO0NSeU5MH9
 big0e9mtIewQwMX1drT8X/VGiHiL6IB+QrCiZLuiEzBEqu0GT+pJ0Q3hFyFJqXvQMyo/
 zXlT1vl954U9h6H7yl23InhTzuE43kPAF13sULpBfWA7TGaVR+NMHjbwekioK3yAwM/3 eA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39sbtugrf4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Jul 2021 18:52:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16DIoV2o012335;
        Tue, 13 Jul 2021 18:52:20 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by userp3030.oracle.com with ESMTP id 39q0p5d6es-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Jul 2021 18:52:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xck0UmLmldN9veZAtfRGA9EVU3haJ5UYXQMnabDHLrSCr4mu7EaPlCyQuBqB0TtMhMEmwKOBUPcJcoEBJZkkmzY/e8ohfTPtMZnQUdizgO5g27jhBrptLiNFbkJqqfRTHBVNsi5uUey0j5Fvc191lEktl7zO0AfyEufmqnKSo8pn3S1ctnFAJqBzcbkGG+d2L3broSWXlFNf2TcRNhALNFb8/3pbuKGhVyXFt+XjrYQhIaAdtMITYlvR13/rTZJTDHWRxrQsZTpGWTxWWLusrdx0EiVXa/tAzaIihanPxIxJUuZsI5VOFxDvPtdqPNFyvdKpXuzncQKjyVtjsdmCQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QuBtZTknjJiMT6vg2eoMQwU1EgnrgS8M2Lj/JgLiKPE=;
 b=KAWUnXZjFyg5BanONlSRFRTu9xQijSQhIugP6ihq72R3GJedBEQTZDf2ZoJiwXd5xgunBcIlSiGNacPDFP4UvQ0yWHQz35BxUlXiRdhhbcz/gwot8gxviWZVEg3JfY1tlmPVfMhTEr7QfbiUUyOG4A9BqK7BlLTmHiir+UiSaZScKIYBVmvedIXSNL4P3Hj3QglBBze2QoivVVUhhNXl9i15ccOAx+e7zp6rbUpGB6JlL9+gGa25kuo5zEbGvfJjVUDeyiZoIU7sORJwPWSs4PBnp1V6Mo81TmqXR4RhrwuIV3hNXSP23BZSgihZMeckCWcxBU5A3+5QRbWX+AcScQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QuBtZTknjJiMT6vg2eoMQwU1EgnrgS8M2Lj/JgLiKPE=;
 b=fCYv5OPImIRJajxPYKJUYYjNDjRurtYUVfi9gaLZNUOXzPZewiN8LtCQjqW19YS6yfFmGfngYzhOH49zzncAdt/yYGQknn6EoasdLHxAb5B2uOftYPGEHdu65Wj2RZE9S5jpFqqiAgzQBMy4Hw4orrC4nhgHEljzlk8NcfT41AQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4388.namprd10.prod.outlook.com (2603:10b6:a03:212::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Tue, 13 Jul
 2021 18:52:18 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%9]) with mapi id 15.20.4308.027; Tue, 13 Jul 2021
 18:52:17 +0000
Subject: Re: [PATCH v21 05/13] xfs: Set up infrastructure for deferred
 attribute operations
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210707222111.16339-1-allison.henderson@oracle.com>
 <20210707222111.16339-6-allison.henderson@oracle.com>
 <20210710003912.GZ11588@locust>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <55b2ed03-d7f0-1f4b-49aa-4fce3ae72c11@oracle.com>
Date:   Tue, 13 Jul 2021 11:52:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210710003912.GZ11588@locust>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR20CA0021.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::34) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.167] (67.1.112.125) by BY5PR20CA0021.namprd20.prod.outlook.com (2603:10b6:a03:1f4::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Tue, 13 Jul 2021 18:52:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: daf9e5bb-2f9e-4ec5-c138-08d9462f5674
X-MS-TrafficTypeDiagnostic: BY5PR10MB4388:
X-Microsoft-Antispam-PRVS: <BY5PR10MB4388402A4DCC63F72DBF779295149@BY5PR10MB4388.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C+e/M2pxmBpxb9qlQtS3EsJAhtq4uSh/dsvjRLEPHwtZ4ONhDsJft1Eg+Y1ySMQKYX/AdKDgNTnETGEZs/b7A/J5/w/8alur5DuZ351jAxX0Uev31wWr/jmVx8YkJxJgSsdLVtN841HFc/QHf4OU+uQl3ugnDIKsCzzo5pdGq7VgtRWPhveb2fGGwvqlaRr16xKniUixeNNBZWF4afiUpliAcx3LOvA06SypXYA5ZGtTf0d4OIoCgi4uIJ32MyR+2dIIrfzoCXIG8m5qol0lkXjQBDdhJ0iNQwesEB6/Z4XaieFieC5Q4yYITlWy8bXNFyAIaXJGFevY3NCUOF2z7SHvTj/5HlKmSJZ817Nz0+WgURI6C8UDCAjhSifaBNvLaOalcCxZTMWSKoQnmdw0zPwvWuWLeu4X1YGP7+cnZsCTtbtKcqhXzIN4NEsN3k/Soox9YzfsSjg3UwNtmuVUO5w/xEVN0UAhgk2wuRU757oGrg/pDbmycueY2i+U0NVJLrJ9GYQeQs2T8Gy/Ny4kIeZRzJujpKCxirxWlabIbU3osB+1XZrewpzigVijtfn3xyEiQuGtPraR3StfKSzFSbhnWwMeHRdQY3XARs/yA2Ef/m/G/RXX3uxhsa7cU4yc0ON9c9crUf0hFg/fyepfMoX76aRLrz23me4Jle7+nbN9GwqDe8o3nL+frWxwh9kurpbiFuPvIDJNpMxJN8uqedL7Sqtx5wEL1RFCym+3tWc/jLcj6+efJZWdbZD9QHY8OV2V7CLmKg18kqTKH5dzaQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(396003)(39860400002)(136003)(38350700002)(38100700002)(66946007)(26005)(6486002)(2616005)(66476007)(83380400001)(31686004)(66556008)(36756003)(2906002)(956004)(16576012)(52116002)(53546011)(66574015)(8676002)(31696002)(316002)(8936002)(186003)(6916009)(478600001)(5660300002)(4326008)(30864003)(44832011)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eDBiMTBEWEl4SzdJczFHL0V2b1FidUhyWWRpemhQb0doTkNQWmR5c0RuK0lI?=
 =?utf-8?B?UWtwSE5hVkNRQ0daOXdzbC9HWmNNUE9KRyt4bytQc0YwWTVZUmZDRzA0QmZR?=
 =?utf-8?B?Nm1yUGhFaUVyODN1Z0NMSDUzeEk2dkFlWUJndW5EUms3MWNFd0xCTGtTdUpV?=
 =?utf-8?B?RG9lb1dSRzIxUEQrSUxUTVZPa2NmT3gxVGVxZHI4Yyt1bUNGS3N6T1Z5ajJM?=
 =?utf-8?B?T3V1cnZBU3hheEc4MGVENEs5eFFjanF5bTQzak9HMmFVeXFGaGxDbk0rSjN1?=
 =?utf-8?B?N1ZUWWVoQllwUG5yVWR0b05iNGhxREJsRGZ0elFyVnVPeWE3MFNOUEVIeUth?=
 =?utf-8?B?QXdod2tpVnpoQisvZDhuQnUxYWVnKy9VTzByd3RqdmF5YWljWlRPZHVmRU9U?=
 =?utf-8?B?b2xLM3NWajR5Q3BWMjNVdEtnMHB5K21XNUdmYUJwOTNBTHFoSGQ3eDc2Njda?=
 =?utf-8?B?NHhRcE9xZTNrY1ZqR0ZLNEdzcEJramx1OGhoVHg2eDBuL2QzUlUyZ1p3ZjBM?=
 =?utf-8?B?bURPL1ZJd1QxaGRqM1J0RXNSa201a1ZMbVZUcnRYK3RlYVgzZVNpUnltQVo0?=
 =?utf-8?B?NFdKK1dlcnlJK08vbXZCdHd0SFgwQk11SDgzcFlnK2p4R3VjWGUwaFl3aG4y?=
 =?utf-8?B?MEdFSHAxZStWc2ZOWkRsQWRKcVZQQlJEMHFMbjU1WHpIbW05Vm42dE5Xa2FN?=
 =?utf-8?B?cDVlZk5CLzRyY1Z3SnlQamVMWjZIZmJLR0ZCK0NVWThQRUZNVS8vMFNscFVW?=
 =?utf-8?B?bGk2ZXVuVnByOEVNMit4ZS8vSWREbXZNVGZ0NjdxZHFMNzhzK0NFT2JtQVYx?=
 =?utf-8?B?MFBYYXRuSURxM2tSMTQxVktvbjZzRXR2NFF1UTBxV3BraTZZTnVEMkRhRzBs?=
 =?utf-8?B?QzN4QTVPNU9sY1ZIc08vQTVsZzE2L3Y1RmdmVmdzRHNoR08xOVFESmtINHQ2?=
 =?utf-8?B?clpPTTZ1QUhGazJ6Q3ZqMnBsS1J5YjFRQlpYUWxMZGhLOS9mSTNaeFZwQnFI?=
 =?utf-8?B?SjhhczdISXlkVUp5NDFiOVdsMW4reERPLzNyUjdIT2FqT2RmcjhwT21uSHYr?=
 =?utf-8?B?TXJ4VDVWMFI0bFdNaUFNZ1FMTG04Skx1cDQ2VVZLWjEvelB0S2p3bWFhUHpn?=
 =?utf-8?B?bzArdCtLVGxISDNxVyszb045ZmZhdUNCWW9hZ3F3SkNQRHpKWS9hS1lhZ3N3?=
 =?utf-8?B?MUFoTHg3TUl3Z2prR3RMOTNKMXVGMUpTcXdUYlBEQVZiVytxbmVyWGRjeWpt?=
 =?utf-8?B?QWpPQkxUMVRqSisyTWNXdDFONUNKUFRad0dET1BTdG5NSUZaMXcyY2hMeVRJ?=
 =?utf-8?B?YkxqWjFJZDQ5eUkvQU5pdGcvdjRWSEhZcVFxZzZTOW11bUlPNHN0aGJYbWYx?=
 =?utf-8?B?NUFoVVBNYndSRk5Wa2tETFh0Y1NxQ1NLeFkvSTY1dGNSd2ovTUFWdUhaWWxG?=
 =?utf-8?B?WVI3K29sbC9BWUp2NmxvQ3JYUDV3dXJ2Rjl2TmZCbTMzSGwwUSs3SnRFaDdj?=
 =?utf-8?B?QWRyeHlwN29KY3VhMUZYUVBRU0RrNlAvVHlJT3BJS01YMSttcXBzcUxtMmds?=
 =?utf-8?B?Yk9QQzF1VUFta3ZnMG1XZDNPZGNVcE54TW5XNTFycDhyN2tGYzBRaHcxV2wz?=
 =?utf-8?B?MVBuY3hhc2J4RnJXcWt0alhNa1dNTzBvcXZrT1cvb1lheit6VFhWMHBnM0Nw?=
 =?utf-8?B?WnRmQ1o4VFpsZ25hNXd6MFQzL29INndOVGczZ1JCblFxOWRaT3V0QjVpakhi?=
 =?utf-8?Q?BrVhDHRO8Qx/Tw9Qa43Nhhe3G9rZXIML2gYGJUp?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: daf9e5bb-2f9e-4ec5-c138-08d9462f5674
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2021 18:52:17.9586
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XvcdGN4j1NZQVibCjGJvARljpXvuE7lw6yyVpKC3SHY6TWme7945E08sjMrhUzl/KCYLXl8MR2Mm6zEFpjgCagULd+cyLffmEbLFE8zotas=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4388
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10044 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107130119
X-Proofpoint-GUID: mnMMQVX2LisAbskEClUROsqXxLO1fvVc
X-Proofpoint-ORIG-GUID: mnMMQVX2LisAbskEClUROsqXxLO1fvVc
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/9/21 5:39 PM, Darrick J. Wong wrote:
> On Wed, Jul 07, 2021 at 03:21:03PM -0700, Allison Henderson wrote:
>> Currently attributes are modified directly across one or more
>> transactions. But they are not logged or replayed in the event of an
>> error. The goal of delayed attributes is to enable logging and replaying
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
>> ---
>>   fs/xfs/Makefile                 |   1 +
>>   fs/xfs/libxfs/xfs_attr.c        |   5 +-
>>   fs/xfs/libxfs/xfs_attr.h        |  31 +++
>>   fs/xfs/libxfs/xfs_defer.h       |   2 +
>>   fs/xfs/libxfs/xfs_log_format.h  |  44 +++-
>>   fs/xfs/libxfs/xfs_log_recover.h |   2 +
>>   fs/xfs/scrub/common.c           |   2 +
>>   fs/xfs/xfs_acl.c                |   2 +
>>   fs/xfs/xfs_attr_item.c          | 460 ++++++++++++++++++++++++++++++++++++++++
>>   fs/xfs/xfs_attr_item.h          |  52 +++++
>>   fs/xfs/xfs_attr_list.c          |   1 +
>>   fs/xfs/xfs_ioctl.c              |   2 +
>>   fs/xfs/xfs_ioctl32.c            |   2 +
>>   fs/xfs/xfs_iops.c               |   2 +
>>   fs/xfs/xfs_log_recover.c        |   2 +
>>   fs/xfs/xfs_ondisk.h             |   2 +
>>   fs/xfs/xfs_xattr.c              |   1 +
>>   17 files changed, 608 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
>> index 04611a1..b056cfc 100644
>> --- a/fs/xfs/Makefile
>> +++ b/fs/xfs/Makefile
>> @@ -102,6 +102,7 @@ xfs-y				+= xfs_log.o \
>>   				   xfs_buf_item_recover.o \
>>   				   xfs_dquot_item_recover.o \
>>   				   xfs_extfree_item.o \
>> +				   xfs_attr_item.o \
>>   				   xfs_icreate_item.o \
>>   				   xfs_inode_item.o \
>>   				   xfs_inode_item_recover.o \
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 8d51607..bdcdadc 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -24,6 +24,7 @@
>>   #include "xfs_quota.h"
>>   #include "xfs_trans_space.h"
>>   #include "xfs_trace.h"
>> +#include "xfs_attr_item.h"
>>   
>>   /*
>>    * xfs_attr.c
>> @@ -61,8 +62,6 @@ STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>>   				 struct xfs_da_state **state);
>>   STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>>   STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
>> -STATIC int xfs_attr_set_iter(struct xfs_delattr_context *dac,
>> -			     struct xfs_buf **leaf_bp);
>>   STATIC int xfs_attr_node_removename(struct xfs_da_args *args,
>>   				    struct xfs_da_state *state);
>>   
>> @@ -166,7 +165,7 @@ xfs_attr_get(
>>   /*
>>    * Calculate how many blocks we need for the new attribute,
>>    */
>> -STATIC int
>> +int
>>   xfs_attr_calc_size(
>>   	struct xfs_da_args	*args,
>>   	int			*local)
>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>> index 8de5d1d..4ee5165 100644
>> --- a/fs/xfs/libxfs/xfs_attr.h
>> +++ b/fs/xfs/libxfs/xfs_attr.h
>> @@ -28,6 +28,11 @@ struct xfs_attr_list_context;
>>    */
>>   #define	ATTR_MAX_VALUELEN	(64*1024)	/* max length of a value */
>>   
>> +static inline bool xfs_hasdelattr(struct xfs_mount *mp)
>> +{
>> +	return false;
>> +}
>> +
>>   /*
>>    * Kernel-internal version of the attrlist cursor.
>>    */
>> @@ -454,6 +459,7 @@ enum xfs_delattr_state {
>>    */
>>   #define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
>>   #define XFS_DAC_LEAF_ADDNAME_INIT	0x02 /* xfs_attr_leaf_addname init*/
>> +#define XFS_DAC_DELAYED_OP_INIT		0x04 /* delayed operations init*/
>>   
>>   /*
>>    * Context used for keeping track of delayed attribute operations
>> @@ -461,6 +467,11 @@ enum xfs_delattr_state {
>>   struct xfs_delattr_context {
>>   	struct xfs_da_args      *da_args;
>>   
>> +	/*
>> +	 * Used by xfs_attr_set to hold a leaf buffer across a transaction roll
>> +	 */
>> +	struct xfs_buf		*leaf_bp;
>> +
>>   	/* Used in xfs_attr_rmtval_set_blk to roll through allocating blocks */
>>   	struct xfs_bmbt_irec	map;
>>   	xfs_dablk_t		lblkno;
>> @@ -474,6 +485,23 @@ struct xfs_delattr_context {
>>   	enum xfs_delattr_state  dela_state;
>>   };
>>   
>> +/*
>> + * List of attrs to commit later.
>> + */
>> +struct xfs_attr_item {
>> +	struct xfs_delattr_context	xattri_dac;
>> +
>> +	/*
>> +	 * Indicates if the attr operation is a set or a remove
>> +	 * XFS_ATTR_OP_FLAGS_{SET,REMOVE}
>> +	 */
>> +	uint32_t			xattri_op_flags;
> 
> This could be a regular unsigned int.
Sure, will fix
> 
>> +
>> +	/* used to log this item to an intent */
>> +	struct list_head		xattri_list;
>> +};
>> +
>> +
>>   /*========================================================================
>>    * Function prototypes for the kernel.
>>    *========================================================================*/
>> @@ -490,11 +518,14 @@ int xfs_attr_get_ilocked(struct xfs_da_args *args);
>>   int xfs_attr_get(struct xfs_da_args *args);
>>   int xfs_attr_set(struct xfs_da_args *args);
>>   int xfs_attr_set_args(struct xfs_da_args *args);
>> +int xfs_attr_set_iter(struct xfs_delattr_context *dac,
>> +		      struct xfs_buf **leaf_bp);
>>   int xfs_has_attr(struct xfs_da_args *args);
>>   int xfs_attr_remove_args(struct xfs_da_args *args);
>>   int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
>>   bool xfs_attr_namecheck(const void *name, size_t length);
>>   void xfs_delattr_context_init(struct xfs_delattr_context *dac,
>>   			      struct xfs_da_args *args);
>> +int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
>>   
>>   #endif	/* __XFS_ATTR_H__ */
>> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
>> index 05472f7..0ed9dfa 100644
>> --- a/fs/xfs/libxfs/xfs_defer.h
>> +++ b/fs/xfs/libxfs/xfs_defer.h
>> @@ -63,6 +63,8 @@ extern const struct xfs_defer_op_type xfs_refcount_update_defer_type;
>>   extern const struct xfs_defer_op_type xfs_rmap_update_defer_type;
>>   extern const struct xfs_defer_op_type xfs_extent_free_defer_type;
>>   extern const struct xfs_defer_op_type xfs_agfl_free_defer_type;
>> +extern const struct xfs_defer_op_type xfs_attr_defer_type;
>> +
>>   
>>   /*
>>    * This structure enables a dfops user to detach the chain of deferred
>> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
>> index 78d5368..34011c8 100644
>> --- a/fs/xfs/libxfs/xfs_log_format.h
>> +++ b/fs/xfs/libxfs/xfs_log_format.h
>> @@ -113,7 +113,12 @@ struct xfs_unmount_log_format {
>>   #define XLOG_REG_TYPE_CUD_FORMAT	24
>>   #define XLOG_REG_TYPE_BUI_FORMAT	25
>>   #define XLOG_REG_TYPE_BUD_FORMAT	26
>> -#define XLOG_REG_TYPE_MAX		26
>> +#define XLOG_REG_TYPE_ATTRI_FORMAT	27
>> +#define XLOG_REG_TYPE_ATTRD_FORMAT	28
>> +#define XLOG_REG_TYPE_ATTR_NAME	29
>> +#define XLOG_REG_TYPE_ATTR_VALUE	30
>> +#define XLOG_REG_TYPE_MAX		30
>> +
>>   
>>   /*
>>    * Flags to log operation header
>> @@ -236,6 +241,8 @@ typedef struct xfs_trans_header {
>>   #define	XFS_LI_CUD		0x1243
>>   #define	XFS_LI_BUI		0x1244	/* bmbt update intent */
>>   #define	XFS_LI_BUD		0x1245
>> +#define	XFS_LI_ATTRI		0x1246  /* attr set/remove intent*/
>> +#define	XFS_LI_ATTRD		0x1247  /* attr set/remove done */
>>   
>>   #define XFS_LI_TYPE_DESC \
>>   	{ XFS_LI_EFI,		"XFS_LI_EFI" }, \
>> @@ -251,7 +258,9 @@ typedef struct xfs_trans_header {
>>   	{ XFS_LI_CUI,		"XFS_LI_CUI" }, \
>>   	{ XFS_LI_CUD,		"XFS_LI_CUD" }, \
>>   	{ XFS_LI_BUI,		"XFS_LI_BUI" }, \
>> -	{ XFS_LI_BUD,		"XFS_LI_BUD" }
>> +	{ XFS_LI_BUD,		"XFS_LI_BUD" }, \
>> +	{ XFS_LI_ATTRI,		"XFS_LI_ATTRI" }, \
>> +	{ XFS_LI_ATTRD,		"XFS_LI_ATTRD" }
>>   
>>   /*
>>    * Inode Log Item Format definitions.
>> @@ -859,4 +868,35 @@ struct xfs_icreate_log {
>>   	__be32		icl_gen;	/* inode generation number to use */
>>   };
>>   
>> +/*
>> + * Flags for deferred attribute operations.
>> + * Upper bits are flags, lower byte is type code
>> + */
>> +#define XFS_ATTR_OP_FLAGS_SET		1	/* Set the attribute */
>> +#define XFS_ATTR_OP_FLAGS_REMOVE	2	/* Remove the attribute */
>> +#define XFS_ATTR_OP_FLAGS_TYPE_MASK	0x0FF	/* Flags type mask */
> 
> 0xFF, not 0x0FF?
> 
>> +
>> +/*
>> + * This is the structure used to lay out an attr log item in the
>> + * log.
>> + */
>> +struct xfs_attri_log_format {
>> +	uint16_t	alfi_type;	/* attri log item type */
>> +	uint16_t	alfi_size;	/* size of this item */
>> +	uint32_t	__pad;		/* pad to 64 bit aligned */
>> +	uint64_t	alfi_id;	/* attri identifier */
>> +	uint64_t	alfi_ino;	/* the inode for this attr operation */
>> +	uint32_t	alfi_op_flags;	/* marks the op as a set or remove */
>> +	uint32_t	alfi_name_len;	/* attr name length */
>> +	uint32_t	alfi_value_len;	/* attr value length */
>> +	uint32_t	alfi_attr_flags;/* attr flags */
>> +};
>> +
>> +struct xfs_attrd_log_format {
>> +	uint16_t	alfd_type;	/* attrd log item type */
>> +	uint16_t	alfd_size;	/* size of this item */
>> +	uint32_t	__pad;		/* pad to 64 bit aligned */
>> +	uint64_t	alfd_alf_id;	/* id of corresponding attri */
>> +};
>> +
>>   #endif /* __XFS_LOG_FORMAT_H__ */
>> diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
>> index 3cca2bf..b6e5514 100644
>> --- a/fs/xfs/libxfs/xfs_log_recover.h
>> +++ b/fs/xfs/libxfs/xfs_log_recover.h
>> @@ -72,6 +72,8 @@ extern const struct xlog_recover_item_ops xlog_rui_item_ops;
>>   extern const struct xlog_recover_item_ops xlog_rud_item_ops;
>>   extern const struct xlog_recover_item_ops xlog_cui_item_ops;
>>   extern const struct xlog_recover_item_ops xlog_cud_item_ops;
>> +extern const struct xlog_recover_item_ops xlog_attri_item_ops;
>> +extern const struct xlog_recover_item_ops xlog_attrd_item_ops;
>>   
>>   /*
>>    * Macros, structures, prototypes for internal log manager use.
>> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
>> index cadfd57..32e46f8 100644
>> --- a/fs/xfs/scrub/common.c
>> +++ b/fs/xfs/scrub/common.c
>> @@ -23,6 +23,8 @@
>>   #include "xfs_rmap_btree.h"
>>   #include "xfs_log.h"
>>   #include "xfs_trans_priv.h"
>> +#include "xfs_da_format.h"
>> +#include "xfs_da_btree.h"
>>   #include "xfs_attr.h"
>>   #include "xfs_reflink.h"
>>   #include "xfs_ag.h"
>> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
>> index d02bef2..b8673c6 100644
>> --- a/fs/xfs/xfs_acl.c
>> +++ b/fs/xfs/xfs_acl.c
>> @@ -10,6 +10,8 @@
>>   #include "xfs_trans_resv.h"
>>   #include "xfs_mount.h"
>>   #include "xfs_inode.h"
>> +#include "xfs_da_format.h"
>> +#include "xfs_da_btree.h"
>>   #include "xfs_attr.h"
>>   #include "xfs_trace.h"
>>   #include "xfs_error.h"
>> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
>> new file mode 100644
>> index 0000000..c9033e2
>> --- /dev/null
>> +++ b/fs/xfs/xfs_attr_item.c
>> @@ -0,0 +1,460 @@
>> +// SPDX-License-Identifier: GPL-2.0-or-later
>> +/*
>> + * Copyright (C) 2021 Oracle.  All Rights Reserved.
>> + * Author: Allison Collins <allison.henderson@oracle.com>
>> + */
>> +
>> +#include "xfs.h"
>> +#include "xfs_fs.h"
>> +#include "xfs_format.h"
>> +#include "xfs_log_format.h"
>> +#include "xfs_trans_resv.h"
>> +#include "xfs_bit.h"
>> +#include "xfs_shared.h"
>> +#include "xfs_mount.h"
>> +#include "xfs_defer.h"
>> +#include "xfs_da_format.h"
>> +#include "xfs_log_format.h"
>> +#include "xfs_trans.h"
>> +#include "xfs_bmap.h"
>> +#include "xfs_bmap_btree.h"
>> +#include "xfs_trans_priv.h"
>> +#include "xfs_buf_item.h"
>> +#include "xfs_attr_item.h"
>> +#include "xfs_log.h"
>> +#include "xfs_btree.h"
>> +#include "xfs_rmap.h"
>> +#include "xfs_inode.h"
>> +#include "xfs_icache.h"
>> +#include "xfs_da_format.h"
>> +#include "xfs_da_btree.h"
>> +#include "xfs_attr.h"
>> +#include "xfs_shared.h"
>> +#include "xfs_attr_item.h"
>> +#include "xfs_alloc.h"
>> +#include "xfs_bmap.h"
>> +#include "xfs_trace.h"
>> +#include "libxfs/xfs_da_format.h"
>> +#include "xfs_inode.h"
>> +#include "xfs_quota.h"
>> +#include "xfs_trans_space.h"
>> +#include "xfs_error.h"
>> +#include "xfs_log_priv.h"
>> +#include "xfs_log_recover.h"
>> +
>> +static const struct xfs_item_ops xfs_attri_item_ops;
>> +static const struct xfs_item_ops xfs_attrd_item_ops;
>> +
>> +/* iovec length must be 32-bit aligned */
>> +static inline size_t ATTR_NVEC_SIZE(size_t size)
>> +{
>> +	return size == sizeof(int32_t) ? size :
>> +	       sizeof(int32_t) + round_up(size, sizeof(int32_t));
>> +}
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
>> +	struct xfs_log_item	*lip,
>> +	int			*nvecs,
>> +	int			*nbytes)
>> +{
>> +	struct xfs_attri_log_item       *attrip = ATTRI_ITEM(lip);
>> +
>> +	*nvecs += 1;
>> +	*nbytes += sizeof(struct xfs_attri_log_format);
>> +
>> +	/* Attr set and remove operations require a name */
>> +	ASSERT(attrip->attri_name_len > 0);
>> +
>> +	*nvecs += 1;
>> +	*nbytes += ATTR_NVEC_SIZE(attrip->attri_name_len);
>> +
>> +	/*
>> +	 * Set ops can accept a value of 0 len to clear an attr value.  Remove
>> +	 * ops do not need a value at all.  So only account for the value
> 
> Is this still true now that xfs_attr_set calls xfs_attr_remove_args
> if there's no value?  IOWS I think the comment can go away.
> 
Yes, I think people are used to that interface now, so will remove this line

>> +	 * when it is needed.
>> +	 */
>> +	if (attrip->attri_value_len > 0) {
>> +		*nvecs += 1;
>> +		*nbytes += ATTR_NVEC_SIZE(attrip->attri_value_len);
>> +	}
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
>> +			ATTR_NVEC_SIZE(attrip->attri_name_len));
>> +	if (attrip->attri_value_len > 0)
>> +		xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_VALUE,
>> +				attrip->attri_value,
>> +				ATTR_NVEC_SIZE(attrip->attri_value_len));
>> +}
>> +
>> +/*
>> + * The unpin operation is the last place an ATTRI is manipulated in the log. It
>> + * is either inserted in the AIL or aborted in the event of a log I/O error. In
>> + * either case, the ATTRI transaction has been successfully committed to make
>> + * it this far. Therefore, we expect whoever committed the ATTRI to either
>> + * construct and commit the ATTRD or drop the ATTRD's reference in the event of
>> + * error. Simply drop the log's ATTRI reference now that the log is done with
>> + * it.
>> + */
>> +STATIC void
>> +xfs_attri_item_unpin(
>> +	struct xfs_log_item	*lip,
>> +	int			remove)
>> +{
>> +	xfs_attri_release(ATTRI_ITEM(lip));
>> +}
>> +
>> +
>> +STATIC void
>> +xfs_attri_item_release(
>> +	struct xfs_log_item	*lip)
>> +{
>> +	xfs_attri_release(ATTRI_ITEM(lip));
>> +}
>> +
>> +/*
>> + * Allocate and initialize an attri item.  Caller may allocate an additional
>> + * trailing buffer of the specified size
>> + */
>> +STATIC struct xfs_attri_log_item *
>> +xfs_attri_init(
>> +	struct xfs_mount		*mp,
>> +	int				buffer_size)
>> +
>> +{
>> +	struct xfs_attri_log_item	*attrip;
>> +	uint				size;
>> +
>> +	size = sizeof(struct xfs_attri_log_item) + buffer_size;
>> +	attrip = kmem_alloc_large(size, KM_ZERO);
>> +	if (attrip == NULL)
>> +		return NULL;
>> +
>> +	xfs_log_item_init(mp, &attrip->attri_item, XFS_LI_ATTRI,
>> +			  &xfs_attri_item_ops);
>> +	attrip->attri_format.alfi_id = (uintptr_t)(void *)attrip;
>> +	atomic_set(&attrip->attri_refcount, 2);
>> +
>> +	return attrip;
>> +}
>> +
>> +/*
>> + * Copy an attr format buffer from the given buf, and into the destination attr
>> + * format structure.
>> + */
>> +STATIC int
>> +xfs_attri_copy_format(
>> +	struct xfs_log_iovec		*buf,
>> +	struct xfs_attri_log_format	*dst_attr_fmt)
>> +{
>> +	struct xfs_attri_log_format	*src_attr_fmt = buf->i_addr;
>> +	uint				len;
>> +
>> +	len = sizeof(struct xfs_attri_log_format);
>> +	if (buf->i_len != len)
>> +		return -EFSCORRUPTED;
> 
> This function is involved with log recovery, which means that an
> improperly sized buffer really ought to log something in dmesg.
> 
> 	if (buf->i_len != len) {
> 		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
> 		return -EFSCORRUPTED;
> 	}
> 
Ok, will add

>> +
>> +	memcpy((char *)dst_attr_fmt, (char *)src_attr_fmt, len);
>> +	return 0;
>> +}
>> +
>> +static inline struct xfs_attrd_log_item *ATTRD_ITEM(struct xfs_log_item *lip)
>> +{
>> +	return container_of(lip, struct xfs_attrd_log_item, attrd_item);
>> +}
>> +
>> +STATIC void
>> +xfs_attrd_item_free(struct xfs_attrd_log_item *attrdp)
>> +{
>> +	kmem_free(attrdp->attrd_item.li_lv_shadow);
>> +	kmem_free(attrdp);
>> +}
>> +
>> +STATIC void
>> +xfs_attrd_item_size(
>> +	struct xfs_log_item		*lip,
>> +	int				*nvecs,
>> +	int				*nbytes)
>> +{
>> +	*nvecs += 1;
>> +	*nbytes += sizeof(struct xfs_attrd_log_format);
>> +}
>> +
>> +/*
>> + * This is called to fill in the log iovecs for the given attrd log item. We use
>> + * only 1 iovec for the attrd_format, and we point that at the attr_log_format
>> + * structure embedded in the attrd item.
>> + */
>> +STATIC void
>> +xfs_attrd_item_format(
>> +	struct xfs_log_item	*lip,
>> +	struct xfs_log_vec	*lv)
>> +{
>> +	struct xfs_attrd_log_item	*attrdp = ATTRD_ITEM(lip);
>> +	struct xfs_log_iovec		*vecp = NULL;
>> +
>> +	attrdp->attrd_format.alfd_type = XFS_LI_ATTRD;
>> +	attrdp->attrd_format.alfd_size = 1;
>> +
>> +	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTRD_FORMAT,
>> +			&attrdp->attrd_format,
>> +			sizeof(struct xfs_attrd_log_format));
>> +}
>> +
>> +/*
>> + * The ATTRD is either committed or aborted if the transaction is canceled. If
>> + * the transaction is canceled, drop our reference to the ATTRI and free the
>> + * ATTRD.
>> + */
>> +STATIC void
>> +xfs_attrd_item_release(
>> +	struct xfs_log_item		*lip)
>> +{
>> +	struct xfs_attrd_log_item	*attrdp = ATTRD_ITEM(lip);
>> +
>> +	xfs_attri_release(attrdp->attrd_attrip);
>> +	xfs_attrd_item_free(attrdp);
>> +}
>> +
>> +STATIC xfs_lsn_t
>> +xfs_attri_item_committed(
>> +	struct xfs_log_item		*lip,
>> +	xfs_lsn_t			lsn)
>> +{
>> +	struct xfs_attri_log_item	*attrip;
> 
> 	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
> 
>> +	/*
> 
> Style nit: blank line after the variable declarations.
ok, will fix nits

> 
>> +	 * The attrip refers to xfs_attr_item memory to log the name and value
>> +	 * with the intent item. This already occurred when the intent was
>> +	 * committed so these fields are no longer accessed. Clear them out of
>> +	 * caution since we're about to free the xfs_attr_item.
>> +	 */
>> +	attrip = ATTRI_ITEM(lip);
>> +	attrip->attri_name = NULL;
>> +	attrip->attri_value = NULL;
> 
> It's been too long since I read this patchset.  Where do these memory
> buffers get freed?
It happens in xfs_attri_release.  The entire log item is freed along 
with a trailing buffer in which name and value are stored.  These 
pointers point to that space, so we dont free them separatly.  There is 
some documentation for this above the xfs_attri_log_item struct


> 
> 
>> +
>> +	/*
>> +	 * The ATTRI is logged only once and cannot be moved in the log, so
>> +	 * simply return the lsn at which it's been logged.
>> +	 */
>> +	return lsn;
>> +}
>> +
>> +STATIC bool
>> +xfs_attri_item_match(
>> +	struct xfs_log_item	*lip,
>> +	uint64_t		intent_id)
>> +{
>> +	return ATTRI_ITEM(lip)->attri_format.alfi_id == intent_id;
>> +}
>> +
>> +static const struct xfs_item_ops xfs_attrd_item_ops = {
>> +	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
>> +	.iop_size	= xfs_attrd_item_size,
>> +	.iop_format	= xfs_attrd_item_format,
>> +	.iop_release    = xfs_attrd_item_release,
>> +};
>> +
>> +/* Is this recovered ATTRI ok? */
>> +static inline bool
>> +xfs_attri_validate(
>> +	struct xfs_mount		*mp,
>> +	struct xfs_attri_log_item	*attrip)
>> +{
>> +	struct xfs_attri_log_format     *attrp = &attrip->attri_format;
>> +
>> +	/* alfi_op_flags should be either a set or remove */
>> +	if (attrp->alfi_op_flags != XFS_ATTR_OP_FLAGS_SET &&
>> +	    attrp->alfi_op_flags != XFS_ATTR_OP_FLAGS_REMOVE)
> 
> These comparisons ought to be masked so that we don't leave a logic bomb
> if someone ever defines a new opflag, e.g.
> 
> 	unsigned int	op = attrp->alfi_op_flags & XFS_ATTR_OP_FLAGS_MASK;
> 
> 	if (op != XFS_ATTR_OP_FLAGS_SET && op != XFS_ATTR_OP_FLAGS_REMOVE)
> 		return false;
> 
Ok, will update

>> +		return false;
>> +
>> +	if (attrp->alfi_value_len > XATTR_SIZE_MAX)
>> +		return false;
>> +
>> +	if ((attrp->alfi_name_len > XATTR_NAME_MAX) ||
>> +	    (attrp->alfi_name_len == 0))
>> +		return false;
>> +
>> +	if (!xfs_verify_ino(mp, attrp->alfi_ino))
>> +		return false;
>> +
>> +	return xfs_hasdelattr(mp);
> 
> Hrmm.  This will cause recovery failures if there's a dirty attri item
> in the log but the sysadmin forgets to mount with -o delattr.  That
> seems like a bit of a sharp edge, but I guess you're fine with that?

Yes, I figure since we're plumbing in a secret mount option that only 
advanced users are supposed to know about, they should also know to use 
the same option during a recovery.  If I recall correctly, the plan is 
that eventually delayed attrs becomes the norm, so the mount option 
would eventually go away.

> 
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
>> +
>> +
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
>> +	if (attri_formatp->__pad != 0 || attri_formatp->alfi_name_len == 0 ||
>> +	    (attri_formatp->alfi_op_flags == XFS_ATTR_OP_FLAGS_REMOVE &&
>> +	    attri_formatp->alfi_value_len != 0)) {
>> +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
>> +		return -EFSCORRUPTED;
>> +	}
>> +
>> +	buffer_size = attri_formatp->alfi_name_len +
>> +		      attri_formatp->alfi_value_len;
>> +
>> +	attrip = xfs_attri_init(mp, buffer_size);
>> +	if (attrip == NULL)
>> +		return -ENOMEM;
>> +
>> +	error = xfs_attri_copy_format(&item->ri_buf[region],
>> +				      &attrip->attri_format);
>> +	if (error) {
>> +		xfs_attri_item_free(attrip);
>> +		return error;
>> +	}
>> +
>> +	attrip->attri_name_len = attri_formatp->alfi_name_len;
>> +	attrip->attri_value_len = attri_formatp->alfi_value_len;
>> +	region++;
>> +	name = ((char *)attrip) + sizeof(struct xfs_attri_log_item);
>> +	memcpy(name, item->ri_buf[region].i_addr, attrip->attri_name_len);
>> +	attrip->attri_name = name;
>> +
>> +	if (attrip->attri_value_len > 0) {
>> +		region++;
>> +		value = ((char *)attrip) + sizeof(struct xfs_attri_log_item) +
>> +			attrip->attri_name_len;
>> +		memcpy(value, item->ri_buf[region].i_addr,
>> +			attrip->attri_value_len);
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
>> +}
>> +
>> +const struct xlog_recover_item_ops xlog_attri_item_ops = {
>> +	.item_type	= XFS_LI_ATTRI,
>> +	.commit_pass2	= xlog_recover_attri_commit_pass2,
>> +};
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
>> +	ASSERT((item->ri_buf[0].i_len ==
>> +				(sizeof(struct xfs_attrd_log_format))));
> 
> This is metadata corruption, please XFS_ERROR_REPORT() and return
> -EFSCORRUPTED, since this fails silently on non-debug kernels.
Sure, will add

> 
>> +
>> +	xlog_recover_release_intent(log, XFS_LI_ATTRI,
>> +				    attrd_formatp->alfd_alf_id);
>> +	return 0;
>> +}
>> +
>> +const struct xlog_recover_item_ops xlog_attrd_item_ops = {
>> +	.item_type	= XFS_LI_ATTRD,
>> +	.commit_pass2	= xlog_recover_attrd_commit_pass2,
>> +};
>> diff --git a/fs/xfs/xfs_attr_item.h b/fs/xfs/xfs_attr_item.h
>> new file mode 100644
>> index 0000000..594a5dd
>> --- /dev/null
>> +++ b/fs/xfs/xfs_attr_item.h
>> @@ -0,0 +1,52 @@
>> +/* SPDX-License-Identifier: GPL-2.0-or-later
>> + *
>> + * Copyright (C) 2019 Oracle.  All Rights Reserved.
>> + * Author: Allison Collins <allison.henderson@oracle.com>
> 
> Time to update the copyright?

Yep, alrighty, thanks for the review!
Allison
> 
> Aside from those nitpicky things, this part looks like it's in fairly
> good shape.
> 
> --D
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
>> + * Define ATTR flag bits. Manipulated by set/clear/test_bit operators.
>> + */
>> +#define	XFS_ATTRI_RECOVERED	1
>> +
>> +
>> +/*
>> + * This is the "attr intention" log item.  It is used to log the fact that some
>> + * attribute operations need to be processed.  An operation is currently either
>> + * a set or remove.  Set or remove operations are described by the xfs_attr_item
>> + * which may be logged to this intent.
>> + *
>> + * During a normal attr operation, name and value point to the name and value
>> + * fields of the calling functions xfs_da_args.  During a recovery, the name
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
>> +	struct xfs_attri_log_item	*attrd_attrip;
>> +	struct xfs_log_item		attrd_item;
>> +	struct xfs_attrd_log_format	attrd_format;
>> +};
>> +
>> +#endif	/* __XFS_ATTR_ITEM_H__ */
>> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
>> index 25dcc98..81e167a 100644
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
>> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
>> index 0f67943..ff635f9 100644
>> --- a/fs/xfs/xfs_ioctl.c
>> +++ b/fs/xfs/xfs_ioctl.c
>> @@ -15,6 +15,8 @@
>>   #include "xfs_iwalk.h"
>>   #include "xfs_itable.h"
>>   #include "xfs_error.h"
>> +#include "xfs_da_format.h"
>> +#include "xfs_da_btree.h"
>>   #include "xfs_attr.h"
>>   #include "xfs_bmap.h"
>>   #include "xfs_bmap_util.h"
>> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
>> index e650677..cb9f036 100644
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
>> index 93c082d..6f15cad 100644
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
>> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
>> index 6ab467b..ef038f0 100644
>> --- a/fs/xfs/xfs_log_recover.c
>> +++ b/fs/xfs/xfs_log_recover.c
>> @@ -1776,6 +1776,8 @@ static const struct xlog_recover_item_ops *xlog_recover_item_ops[] = {
>>   	&xlog_cud_item_ops,
>>   	&xlog_bui_item_ops,
>>   	&xlog_bud_item_ops,
>> +	&xlog_attri_item_ops,
>> +	&xlog_attrd_item_ops,
>>   };
>>   
>>   static const struct xlog_recover_item_ops *
>> diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
>> index 2599192..758702b 100644
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
>> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
>> index 0d050f8..66b334f 100644
>> --- a/fs/xfs/xfs_xattr.c
>> +++ b/fs/xfs/xfs_xattr.c
>> @@ -12,6 +12,7 @@
>>   #include "xfs_trans_resv.h"
>>   #include "xfs_mount.h"
>>   #include "xfs_inode.h"
>> +#include "xfs_da_btree.h"
>>   #include "xfs_attr.h"
>>   #include "xfs_acl.h"
>>   #include "xfs_da_btree.h"
>> -- 
>> 2.7.4
>>
