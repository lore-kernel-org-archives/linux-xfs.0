Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C9E8C4332F
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Feb 2022 10:05:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234561AbiBGKC3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Feb 2022 05:02:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245362AbiBGJrJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Feb 2022 04:47:09 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7156C043181
        for <linux-xfs@vger.kernel.org>; Mon,  7 Feb 2022 01:47:07 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2178ACXN009053;
        Mon, 7 Feb 2022 09:47:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=cZ+8vwrs2tYkXOc6Z8SBn8An+e+pQ+nZqJ8JklQ1lBU=;
 b=bbt5xsK8rSDUUO7VYB9BxbEiQHnxzdZD6nK5vIh1ArfMsT/1IQiaqJMWCmOw+jjf70R0
 ZedzINKZNiW1jLX6HTJRwobsxvPfz9sX4T8rfGQl2kAxvzQZXswYrsuDClAwPZIef1vn
 rAtNokLlOraGl1PRBeMDrjfsANNhzWwAZPcf0cQIj/dZRNYyWiaoOuwrNfsgAVkd+qiO
 s7PweqIrDG/YE6cJBkyD+jiHSizq+ERX/aq2WWnck/MNxhpI7yARG9DnNDuqPQR1NMGj
 3Kwwdb8ke8Rx4egg+T03z+mi9ksKd0Z8ro0TOwkR0LSDDP3Uj7GZZuW8GjhlSqHonq6G Gg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e1fu2npef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Feb 2022 09:47:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2179jLAA126234;
        Mon, 7 Feb 2022 09:47:03 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by userp3020.oracle.com with ESMTP id 3e1jpn79vq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Feb 2022 09:47:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ci6jy35yndPKsbLCvucHiGwlTPq64jBcF9BAdSnZ93jmma/zcmT8eznaeAGsUEUKH7CFBUUbxL8rf/moVG2t9p6Lc0/Ms18OqXCYb9Atz5OtQ+1184tVniV4fWyHxjRGRBKwpkNBoG6PwwO/SCOqWWlleDnci4Lh4nD5HHsVQc+qQxnJ+AOnDHCNKYtwBoDrZ/m6JRqu8FEULFHR8YpMue8Wu59p9QcwFrpPTYooiFJ0tmStJM57o/DhQWVeVRqEHCIzh1S8DdRARngdjKBlY4rLOwtodOh653l/9IJNdmnm2MNn9v+ACoYoHCemBCpGAihK5lT/k62KE/Dk+55VpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cZ+8vwrs2tYkXOc6Z8SBn8An+e+pQ+nZqJ8JklQ1lBU=;
 b=eZYHRhKRKTpq8yd/C5k/V7vCIPowO7jkdjzfDLbd47ABtnfs8qH+zwdbS+glc4IM/13YhnRHQATs9zto67S11fujgt8kfFfRuvqXNyMvBko5oUJVla4uqIeo1uwRXi9+v5QJXLTjmcW7zvExojW8kP3DFM8Dke4q2Py+7vO9aX6Eku4nxFD4OW87WnVeru4yDocNnjE9yIQpqWndCtK3brOgk9bK+/im97mSDDWkGuwO3M0QWnJW7PECjouX1ol39V2KeQ81tocSg1y9sRIXu4ronT2fKKKSiP2qw5PJ2Ae6shlxJofFAqXcWlfkZz2M7yk5z7BxCPXMxFN9U/63Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cZ+8vwrs2tYkXOc6Z8SBn8An+e+pQ+nZqJ8JklQ1lBU=;
 b=MlREyKf9I92eR6oG6OD9f+vee8jHoCz/7a0L1TZNEBiO1WvgWI8Sh+IF8mqUtiYL0Hb5NU/ssnbZRC8sMBvFMypAnlfF8Dn2nRxnl6KvdSdd5NgBnysT4Lvjqry/s8yniHhpHR2e4G0Jc+ZpaDHapQfRlU/TNZ35ODuNev3H6rI=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BY5PR10MB4355.namprd10.prod.outlook.com (2603:10b6:a03:20a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.11; Mon, 7 Feb
 2022 09:47:00 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::fc8e:7310:2762:be9e]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::fc8e:7310:2762:be9e%5]) with mapi id 15.20.4951.018; Mon, 7 Feb 2022
 09:47:00 +0000
References: <20220121051857.221105-1-chandan.babu@oracle.com>
 <20220121051857.221105-15-chandan.babu@oracle.com>
 <20220201192449.GB8338@magnolia>
 <87o83jmg0a.fsf@debian-BULLSEYE-live-builder-AMD64>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V5 14/16] xfs: Enable bulkstat ioctl to support 64-bit
 per-inode extent counters
In-reply-to: <87o83jmg0a.fsf@debian-BULLSEYE-live-builder-AMD64>
Message-ID: <87leynm2k3.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Mon, 07 Feb 2022 15:16:52 +0530
Content-Type: text/plain
X-ClientProxiedBy: TY2PR02CA0039.apcprd02.prod.outlook.com
 (2603:1096:404:a6::27) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6aec7452-b556-4b67-a143-08d9ea1ec97c
X-MS-TrafficTypeDiagnostic: BY5PR10MB4355:EE_
X-Microsoft-Antispam-PRVS: <BY5PR10MB4355FF3616AE93F03CE276A7F62C9@BY5PR10MB4355.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tSi/9zzNWn7lh0wk6HnzQTIaoVXTaAxwaZBnwdHtSyBBqrJ/GDmBKEOqG4YD5bQfnmCyjuBOtmdKYNcfMW0/NwkqliuOXJ3kYMKre7/ekl1tUDafH89lge5zvs3BEmzrXOcWe3LcnyBy2YpmRxWDlO3Rs3dbohLMHx6hRpUvP0ZIjHcbDbKWfuzmrNQ9IZcfhIg3jw16K32OIbkVQgZgYRze/0NJFhGt/JUqqpZKgby7wkMdIfhK74FPQMxbkfYGJgy/cWVEGF+/3m4g0kHA3G5iFogpmnpKoFgJUHm0BmfhYboGiTVeYGroUmGBC8KiILCAcR8R5DrO4XluZYlurihaUkPzS+siFC5ntqHZiVrNcyurcSQ5LMIWg6n0VBiaiUNyD2T/PvMuqvypSr445DnYmE6uqZMmY/Wb+Kgllz+U4/uHi5KnT8nuBriNhhtMVgdpKKn7j2yfl2uKIXxw0hFd87buYs84mgOBwnXkZ5+y5VekImHflMzd4LvQmDZLa65Z/swjxhvFxuvA3+DjBNWnE43NRoTApQVBh9tcLh8r9BmF2Dwd48QYAYp4w9GL05IlI5jYBc4djFRMVqDUDiSr2elTCJrVNlSBCEJ6TBAZc/26KS16kdHdIN4Nr7Pk5eq5JNE8whp4NNjFLCIYINBQMX91h35pkjQGvJepi5gznparZSCkJOmxXKkQxDCh5IEofNvpmd47A/oKWd2Gpw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(4326008)(186003)(26005)(5660300002)(33716001)(83380400001)(86362001)(66946007)(66476007)(66556008)(6486002)(8936002)(8676002)(9686003)(6512007)(6666004)(2906002)(6506007)(38350700002)(38100700002)(53546011)(52116002)(508600001)(316002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iFv83ZoX6cl6GXPtTPWHzDZKLNc1QA0hwD2km82srNR9zpIBMGn4UeQRD5I6?=
 =?us-ascii?Q?CFL4dDXPcSHf3v26E7p3XvNazRRTd8/eiAFlyNeYovoBSjlqAxrHHeVkBdS1?=
 =?us-ascii?Q?lCon8GfK4MsQBUtoXpkZWxTyyRQxCeGeuGYfZDsV0+F+z3SRbxfu8Gt29jsC?=
 =?us-ascii?Q?+GgIvwjD23l43TxHcYfWdSv92hakPADrAuEdZCG3swgo/h32EyMZ2JmE5D9+?=
 =?us-ascii?Q?vXUdcaxxeLJnyTI5gadWYgLaoL1kuvJYNt8MT3pkw4PG6buyRNw4sQ8Bsiks?=
 =?us-ascii?Q?A2AMVk07aIIMbntRHdIgKavzqmmxLGB8NpNBRTlwyP/jCXdUjeq+/e9GJqmK?=
 =?us-ascii?Q?7Cp2KilqIrYgnxHxQTz1WK/4/gO/U5LP/wSh6kNWE6iZ7cbQtNNbATbGAkAS?=
 =?us-ascii?Q?A/dgA3XVCsUdzZyiMwPA3swypon7mjTv9fuytdrj3T4GmUZAOIYm6iLqMwTv?=
 =?us-ascii?Q?hHvzQhYZR2YxoV+6Dz7ndVoS4NWaL/Nync9lqLBJ5T6bh5tBF6jJXpMb0plm?=
 =?us-ascii?Q?FEeZpQAku4lbpPsI0sI45Xd3+ZE73HUOBW8pZXEx8TdD674ZG8Gqtxvfiu9i?=
 =?us-ascii?Q?pgaHbLhc+iKuwRuxkqKN9Cr9ZNNudTotAhw/mCKvbGkgioHJgtvZumHKn3eJ?=
 =?us-ascii?Q?4sCIwEFbNUZQGBrwtPRZ5G6JALdGr6EcSd6FLGHrwGZHs1mT3he17b7thSA7?=
 =?us-ascii?Q?6L4mcA37+KUSucK/RXw/ezpQW9MGNdtzTn5apvYf9KOOgnhEkPxEUGQ5AcZN?=
 =?us-ascii?Q?YgAXLJrlaY6fMtEvhNzHhuOnjP91lm/gRb8yMEaT2hiHQ8/ThnwHzu4Od/+z?=
 =?us-ascii?Q?N4wFuHLES3Cgr4zuVvuFoiHf5l/Rw47pbxnBZ+mrO6HEjXzMW7DqRjA4x+6C?=
 =?us-ascii?Q?9yJLu3GnKpndGA+6Vmk/bvhy+iSa4h8EqpXcGNRIO6MM2IdA7DhqCS/S78tq?=
 =?us-ascii?Q?vxGagFwZuCHQXhr0eye9dwrQUnVxgIle5LnVzzvvim94Lm/YDVPM3nNj//Zw?=
 =?us-ascii?Q?G3JBeoioQxC6wdwd+p/EUFQnEV7uaFpHcn6Jyfmr5bKva9W2GmeU9c89bCbh?=
 =?us-ascii?Q?Rdzt0sbilGu5rO2YeUlgW9cZGsTD6r3DgJAjJmCnqYcN3J6K5mzoaD4hgiix?=
 =?us-ascii?Q?aRQEbcVcRdAwj/+CG6zJPXQLC+2fcxU5NA2JeC96SXUsVHRmNTScIdsyeDt5?=
 =?us-ascii?Q?mmHLxrM9mmadAszcraWqvCeaEwfOqiekXBmNeFKrDnzGJN29kZK9oMBRaVmD?=
 =?us-ascii?Q?aOAcFqmYmD7KTDVbdee0xWAptI11PwyIyVIYAKsPd/cwZGasOM/6qy5gezYU?=
 =?us-ascii?Q?58KrsCFnJbyx5wD9D2xvti4cltvk/1bVjKTf01fwMd4GITNi/vrP4IIUEYIT?=
 =?us-ascii?Q?50Z6t+D538hoNlbxGG9Ts80UOhlI7pK1N+li5fLcPhNWOByruLpQhSEhC3ot?=
 =?us-ascii?Q?N6Sq1BtxymLqb+WzEvyqRTWKYMRvBl1jpdt1tbvZ8y+VcsjlJiAqpNAM/vsc?=
 =?us-ascii?Q?/VdNdn7ECS3YrkMjnEV1sL/bd1q3XPS6UQHUk5Ff8YM2rgQIV66XvFEY2+ra?=
 =?us-ascii?Q?R2W1+zYLDxifPAEApWDGjAtyCKEBPxg1AXbhNbVME5d4UVicy/1b9ltkCZ3J?=
 =?us-ascii?Q?+hhpqiX9zesOXX7yOqaPoAk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6aec7452-b556-4b67-a143-08d9ea1ec97c
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 09:47:00.2285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /pDC8iTpaCAmoAqTYZcYq7FxQTDq/l59aKkwblp+kcHaQ/gEUd/qcOatlrcGbtCeczbRiiAPj7oxTR5iCz382Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4355
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10250 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 phishscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202070063
X-Proofpoint-ORIG-GUID: 4vYDTXW0DcNbK8Dcrpcki_v_92H01h-V
X-Proofpoint-GUID: 4vYDTXW0DcNbK8Dcrpcki_v_92H01h-V
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 07 Feb 2022 at 10:26, Chandan Babu R wrote:
> On 02 Feb 2022 at 00:54, Darrick J. Wong wrote:
>> On Fri, Jan 21, 2022 at 10:48:55AM +0530, Chandan Babu R wrote:
>>> The following changes are made to enable userspace to obtain 64-bit extent
>>> counters,
>>> 1. Carve out a new 64-bit field xfs_bulkstat->bs_extents64 from
>>>    xfs_bulkstat->bs_pad[] to hold 64-bit extent counter.
>>> 2. Define the new flag XFS_BULK_IREQ_BULKSTAT for userspace to indicate that
>>>    it is capable of receiving 64-bit extent counters.
>>> 
>>> Suggested-by: Darrick J. Wong <djwong@kernel.org>
>>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>>> ---
>>>  fs/xfs/libxfs/xfs_fs.h | 12 ++++++++----
>>>  fs/xfs/xfs_ioctl.c     |  3 +++
>>>  fs/xfs/xfs_itable.c    | 27 +++++++++++++++++++++++++--
>>>  fs/xfs/xfs_itable.h    |  7 ++++++-
>>>  fs/xfs/xfs_iwalk.h     |  7 +++++--
>>>  5 files changed, 47 insertions(+), 9 deletions(-)
>>> 
>>> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
>>> index 42bc39501d81..4e12530eb518 100644
>>> --- a/fs/xfs/libxfs/xfs_fs.h
>>> +++ b/fs/xfs/libxfs/xfs_fs.h
>>> @@ -393,7 +393,7 @@ struct xfs_bulkstat {
>>>  	uint32_t	bs_extsize_blks; /* extent size hint, blocks	*/
>>>  
>>>  	uint32_t	bs_nlink;	/* number of links		*/
>>> -	uint32_t	bs_extents;	/* number of extents		*/
>>> +	uint32_t	bs_extents;	/* 32-bit data fork extent counter */
>>>  	uint32_t	bs_aextents;	/* attribute number of extents	*/
>>>  	uint16_t	bs_version;	/* structure version		*/
>>>  	uint16_t	bs_forkoff;	/* inode fork offset in bytes	*/
>>> @@ -402,8 +402,9 @@ struct xfs_bulkstat {
>>>  	uint16_t	bs_checked;	/* checked inode metadata	*/
>>>  	uint16_t	bs_mode;	/* type and mode		*/
>>>  	uint16_t	bs_pad2;	/* zeroed			*/
>>> +	uint64_t	bs_extents64;	/* 64-bit data fork extent counter */
>>>  
>>> -	uint64_t	bs_pad[7];	/* zeroed			*/
>>> +	uint64_t	bs_pad[6];	/* zeroed			*/
>>>  };
>>>  
>>>  #define XFS_BULKSTAT_VERSION_V1	(1)
>>> @@ -484,8 +485,11 @@ struct xfs_bulk_ireq {
>>>   */
>>>  #define XFS_BULK_IREQ_SPECIAL	(1 << 1)
>>>  
>>> -#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO | \
>>> -				 XFS_BULK_IREQ_SPECIAL)
>>> +#define XFS_BULK_IREQ_NREXT64	(1 << 2)
>>
>> This needs a comment specifying the behavior of this flag.
>>
>> If the flag is set and the data fork extent count fits in both fields,
>> will they both be filled out?
>
> If the flag is set, xfs_bulkstat->bs_extents64 field will be assigned the data
> fork extent count and xfs_bulkstat->bs_extents will be set to 0
> (xfs_bulkstat() allocates xfs_bstat_chunk->buf by invoking kmem_zalloc()).
>
> If the flag is not set, xfs_bulkstat->bs_extents field will be assigned the
> data fork extent count and xfs_bulkstat->bs_extents64 will be set to 0.
>
>>
>> If the flag is set but the data fork extent count only fits in
>> bs_extents64, what will be written to bs_extents?
>
> bs_extents will be set to zero.
>
>>
>> If the flag is not set and the data fork extent count won't fit in
>> bs_extents, do we return an error value?  Fill it with garbage?
>>
>
> In this case, we return -EOVERFLOW and the contents of bs_extents will be set
> to zero. This happens because xfs_bulkstat() will return success even if
> xfs_iwalk() returned an error provided that we already have collected details
> about one more inodes. The next call to xfs_ioc_bulkstat() will start from the
> problematic inode. Here we allocate xfs_bstat_chunk->buf using kmem_zalloc()
> which zeroes the contents of the allocated memory and returns -EOVERFLOW to
> userspace.
>

Sorry, I forgot to mention that I will add the above data points as a comment
before posting the next version of the patchset.

-- 
chandan
