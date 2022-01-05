Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AD06C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Jan 2022 13:47:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240429AbiAENrK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Jan 2022 08:47:10 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:46488 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240427AbiAENrJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jan 2022 08:47:09 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 205D4GZN024981;
        Wed, 5 Jan 2022 13:47:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=GGoop5T7BsH/NWzNlyq8Axnd342hpX+EdLEtgZ4WeTg=;
 b=NMyozjtv/b0qhyujycOLbitgDowz2Nr9BqgT9AaM49G0+bMwhN4+EFqM5pg1yubMULqe
 drLplkXJ1rKOacPz2/U/YIwS24bZQ5NLnKIV7d7Um0cZipJaKEOHxEjgp1NhD/potLBw
 wjNE4GdKIISYWRLmOlJhWxREq9SkT0iS38ULmIoVd8+nSopLxtEso/u9PRKBInbuKUCa
 SvjbX1UqIMkdP/5dx9D+9TtMw1Jwk5a+9M5dpB5KSQVpDT9S/rfuwbdHLV6jiS6HHSro
 PyjiaXZ+sMI4h13M+X4bFjq2KGtctVd/Rlk1N0v0DUMZN70H7obGTNzRb5j4PlB3q+Bs 2w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dc43gctff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Jan 2022 13:47:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 205Djmco091184;
        Wed, 5 Jan 2022 13:47:05 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2040.outbound.protection.outlook.com [104.47.51.40])
        by userp3030.oracle.com with ESMTP id 3dac2ycwqg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Jan 2022 13:47:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AlaAixYjeuxw4FmZmuP6mLRnmoz++I96gX3pntSpB/x6yZ10vruPFxsBc3TrZPCJ6KBoLBxYfzF4Eb8Y6LIqV6QJno1HJxbCglO9zC8UsY3cyuTO3OryS2dtJDfr0EdA+afXFLYUvOZtBf/Qsrjb3hE6oiqmepByqLJhR+gvHeoVn8mV8uE3tEA2Mw4PGcxPWHKSc5KWsOeIx9GZ5jjyARt52l8jdGRB3TpE7vNpfIrrP4sOfZPkknbQiLXyLgRov0tUn6ODOEy+eup7UuOvU20I9NLiA7cq9nwKoeNvtvIFOxaHhE5pEMrIAxYZMsC5Yr0HXaMpYEeQISkKQklIVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GGoop5T7BsH/NWzNlyq8Axnd342hpX+EdLEtgZ4WeTg=;
 b=jOIaX996RVnzFfnmHInDPfi8Zakhi/wqVvWcrJu+k19FP5k49+KbfNOHqfwzi/+xDAJwL51Y/r8JhsJGme7J9ijcf7guUTDyBvl5M1lLSm2Ka2PiWJNgd1uRVvBD/AKGu7xeGYz9wb0X1hwo7uuOjeKa6zevwlbljSXXVPcf5KluDJczQeu4pt2yD0CEpLfxQZJdTuFx9NJKVh3ZJcdo35KEAnYfvyMR47GL0iXkg55WHKLDl1z8pwj/tofNmKEe4oaxnDI1CkN+R3mk+qH1PoEySXRjzivAL60MuUX0NzumgYNaWp3eInFhl11KMcWmlOOu8eUip1VlhSpOveLkmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GGoop5T7BsH/NWzNlyq8Axnd342hpX+EdLEtgZ4WeTg=;
 b=PU1GhgOxMx8WlYw8bzq5wDVWWczfNQQCDNOVssiExqSwBPQcigjU8/QurcJ0RqYV19/3DFrL9z1S6m8BA2PIhsI5Kqw+dYz2wlSwCdPs8LjWR/WML8LQazXJlw4ZXNQbVYTZhXrdZASNL0qi1QPE/Axn+u0m6jjH+nW1j+Sv4NE=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB3037.namprd10.prod.outlook.com (2603:10b6:805:dc::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Wed, 5 Jan
 2022 13:47:03 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%7]) with mapi id 15.20.4867.009; Wed, 5 Jan 2022
 13:47:03 +0000
References: <20211214084519.759272-1-chandan.babu@oracle.com>
 <20211214084519.759272-12-chandan.babu@oracle.com>
 <20220105004205.GR31583@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V4 11/16] xfs: Introduce macros to represent new maximum
 extent counts for data/attr forks
In-reply-to: <20220105004205.GR31583@magnolia>
Message-ID: <87v8yy8fci.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Wed, 05 Jan 2022 19:16:53 +0530
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0096.jpnprd01.prod.outlook.com
 (2603:1096:405:3::36) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e542e5ea-7cad-42b1-16e0-08d9d051da83
X-MS-TrafficTypeDiagnostic: SN6PR10MB3037:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB3037C05A189879A8FA97A1F9F64B9@SN6PR10MB3037.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o7g0VpfE22464QatgeulK2B2ubloB5OS3r1m8n+uDHUH9y4rWh2yKGunux3aD389an65WIy7Off8pjwnZ2ZChJcwUlHNsweMfOWHGbRx+c7ZrdWdRXzJPVb7J6r/rZWeO9aLEPj9A/PyWWTjAliKf30OTE5KBI4FkASGAmlAV+lUJclQwI/Cz8LEl65CHK0K43lvZ5sKe45IwSbaU7hr1EBSeeqYiJFCS4hpQwynWsNImGg1x22HKXAY+FsB4GNCYavRAWitLG8eDiAadMxCpLLLE0qGuGiw4dhNJPRFrRRm2gBvBbTfeoekcSqVquIUx4iVoDRhE+/IsefcoqAHz7yjMhRPyy3eVfQzJeaJHP1WQf422UStRWvJR7saXl3z+ql/1HsUD8wBIFqEXoTPnq66MhPxmc0kK8hMYSb2PKQtXZlzCwcGm7sEeLQe/GyuD+6mvLPdyC56uFNCzEZEtNQ4ogJtNoaAZIv1n6fmMo6ZoRXqR79NfpxQRkNte6VN9T6eivF1Ea1Pn5T5ic6qrysl41P/YA2lIyjISJKLrAjGea0lMwMRw/7WCr2rb5OjAf5rPt1AEUEAoICmnGXEB27WPIGQtT7WT+WUEmZdrdSgR2HQ9szjPZ6EX3IW1IErqdqC1cS50tbmuhFDPQTW0Fx6SQCTa6pBwXZuDRbEfwJAjuqWqW+4bbhGzhmmlZ2ocTIx6AbFzgVsO3YEGWT4MQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(33716001)(86362001)(4326008)(66556008)(6916009)(66476007)(53546011)(6666004)(5660300002)(52116002)(83380400001)(508600001)(6486002)(66946007)(8676002)(2906002)(8936002)(316002)(6512007)(186003)(38100700002)(38350700002)(9686003)(6506007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qCFhma02jUb1qpprrOJxzC0tkcf+dwapXKnkp7qYICqIO2ELqo/oJ83JMzrI?=
 =?us-ascii?Q?OR54STZkGaL1YCKlHBx2Ebpci8Gwxagyjqh1pqv9hx81N7CLfpjCkHAPiOEJ?=
 =?us-ascii?Q?/fPd+ctnlGmjJ6vQTkW82voejDs6MvdBlhSTgUmXdjSGye0GwwcA9axWYAae?=
 =?us-ascii?Q?JNOq5vic7LqIy+JMGC9EyhX/SbhrM0RYLrZ+F9up6Q/e43jcxt04gPrBnqeP?=
 =?us-ascii?Q?WdNTIiXo5tn0jWEzT7UqNQaccoo5FjNzKQdcT3xYKLZxmECqTiQBGanyZfOz?=
 =?us-ascii?Q?nTRUqy5vurYtOdRcu3iknitbWmNVKFYUdEaTa79b1wp9JDUU9CwqEf4a4xHS?=
 =?us-ascii?Q?sweFe/qsbVzDLZgVl0qepImjiQ07Cvi8CG5s3AjkB2UZmWhLmmZvcY5TwhHg?=
 =?us-ascii?Q?RuA9Mzkx62tR2Qu6j73ek5gUlkS7+dweLYRJpqeXUbuhgQ2j43aemZY17qv/?=
 =?us-ascii?Q?OxZdVk+s5AWQbQvyixoBQE8RafCX5ljR1ocCF2Rg4ZfGZtb9jGhkj/zVOynd?=
 =?us-ascii?Q?pi7jW03Pq1q3uFfDaXtCaRQFDc0Apv+jJnOutl60tT0/NvDMY9vGKf1dczUa?=
 =?us-ascii?Q?J/9JXi/6IInXzZE0HO6fGvM2FDUVTmnSwgwfjHJpTqgW0GzUg37JnssBVlTB?=
 =?us-ascii?Q?NamhSURk6oyq+R9IrbTtyo9q4WrVHdyJcRzZzHqleVf7mJN5O2woqvVoE08j?=
 =?us-ascii?Q?EBW6KIxsApTtwdEB3B736BTNAsKmmirqw/V/zoxFz8ebyFcO3Q4ZbxsjZr7m?=
 =?us-ascii?Q?SIRjrjBn0RtzOeA26MJpfKG/QH7oXs3RDNcPSyhnN+AcP9R3YPjQ05VoC28c?=
 =?us-ascii?Q?ksjvXTG08b5Ir4n/JFF1EDYvCdKLG3mNpUDNT8w88nTJ40ZFfkGG3y1FZ8e9?=
 =?us-ascii?Q?D4ehnipbhz/2f2bwAyggIVTuXoR26OAsJJ3qTJwQpBRV9w9MJpeLQeh+D3zA?=
 =?us-ascii?Q?kkKi5loQlfVya/DYMF4ZBiSZp3ggpX0WKDHcSajzlHAUEScDHRtmQ9A9r5ey?=
 =?us-ascii?Q?AqkZuCfkOPUDZmcR4XYrPHO2NExm4zS0O9gril177V+amB6PC3dcKHEzkOgI?=
 =?us-ascii?Q?E8/chh4U2EPLUULhsRuFS8kysnT2SgYAJ+GyzsNyZkxJRKAJ/cjbOqt7jdNY?=
 =?us-ascii?Q?/ulVdo/jXz+aHup+/rEU2PNtxIz9FdGwl1IKmFIea9Nszx0FlNd0iHfB8u8z?=
 =?us-ascii?Q?a4/r2bJLSixAiiiTqQcemaEbifKp2r8w98k2xHLI/CDBY48ntFFobgj0zDRT?=
 =?us-ascii?Q?baYXJ2F07dLcWB3dekejAboL8dFBbz+pkAZoknB8yrOInEzuhhaUbI/nTTBx?=
 =?us-ascii?Q?H70dq4RacyYGHiQnpdnoXKHZVRAsleEl4A2BOGMmED+572+W8Y3d4/458BYz?=
 =?us-ascii?Q?UWR/pXKszp8Lub/HwAhS/Bgeuoabb6wOqgipHAiW2INMFOAcACSaL4vVIKuH?=
 =?us-ascii?Q?LuLM1lQA/k8eJ7btTwKjiPqE3qBFe0jgUgTNL3p2y6OhZqwDIk+L94Q3bZzf?=
 =?us-ascii?Q?SMlLHbdEbqw/0hyTjN9MWD5j5ve0Mka6GVvBxxFhDOTvnOZvuh3EYpx/65kS?=
 =?us-ascii?Q?BOUQz5uKlioJ9KnUuKXJBdjXwq0Q2Py74NUdh6UXWsFjhLbYWA9wsGv37DO5?=
 =?us-ascii?Q?ZtEleT4cMo1Ut18KKRfwfyI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e542e5ea-7cad-42b1-16e0-08d9d051da83
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 13:47:02.9505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: igWvN8/6F2jC5NC7bH9oivPhjnbpSYLUNZthR8nMTFoaYDZWrGC3LzARuRHjnNqxxAE6QsM3Fo20zr9u1mBzHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3037
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10217 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 spamscore=0 phishscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201050092
X-Proofpoint-GUID: -kQ7ptAG1oziIo_o5gsjGEsDaWqXDYrC
X-Proofpoint-ORIG-GUID: -kQ7ptAG1oziIo_o5gsjGEsDaWqXDYrC
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 05 Jan 2022 at 06:12, Darrick J. Wong wrote:
> On Tue, Dec 14, 2021 at 02:15:14PM +0530, Chandan Babu R wrote:
>> This commit defines new macros to represent maximum extent counts allowed by
>> filesystems which have support for large per-inode extent counters.
>> 
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  fs/xfs/libxfs/xfs_bmap.c       |  8 +++-----
>>  fs/xfs/libxfs/xfs_bmap_btree.c |  2 +-
>>  fs/xfs/libxfs/xfs_format.h     |  8 +++++---
>>  fs/xfs/libxfs/xfs_inode_buf.c  |  3 ++-
>>  fs/xfs/libxfs/xfs_inode_fork.c |  2 +-
>>  fs/xfs/libxfs/xfs_inode_fork.h | 19 +++++++++++++++----
>>  6 files changed, 27 insertions(+), 15 deletions(-)
>> 
>> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
>> index 4113622e9733..0ce58e4a9c44 100644
>> --- a/fs/xfs/libxfs/xfs_bmap.c
>> +++ b/fs/xfs/libxfs/xfs_bmap.c
>> @@ -61,10 +61,8 @@ xfs_bmap_compute_maxlevels(
>>  	int		sz;		/* root block size */
>>  
>>  	/*
>> -	 * The maximum number of extents in a file, hence the maximum number of
>> -	 * leaf entries, is controlled by the size of the on-disk extent count,
>> -	 * either a signed 32-bit number for the data fork, or a signed 16-bit
>> -	 * number for the attr fork.
>> +	 * The maximum number of extents in a fork, hence the maximum number of
>> +	 * leaf entries, is controlled by the size of the on-disk extent count.
>>  	 *
>>  	 * Note that we can no longer assume that if we are in ATTR1 that the
>>  	 * fork offset of all the inodes will be
>> @@ -74,7 +72,7 @@ xfs_bmap_compute_maxlevels(
>>  	 * ATTR2 we have to assume the worst case scenario of a minimum size
>>  	 * available.
>>  	 */
>> -	maxleafents = xfs_iext_max_nextents(whichfork);
>> +	maxleafents = xfs_iext_max_nextents(xfs_has_nrext64(mp), whichfork);
>>  	if (whichfork == XFS_DATA_FORK)
>>  		sz = XFS_BMDR_SPACE_CALC(MINDBTPTRS);
>>  	else
>> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
>> index 453309fc85f2..e8d21d69b9ff 100644
>> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
>> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
>> @@ -611,7 +611,7 @@ xfs_bmbt_maxlevels_ondisk(void)
>>  	minrecs[1] = xfs_bmbt_block_maxrecs(blocklen, false) / 2;
>>  
>>  	/* One extra level for the inode root. */
>> -	return xfs_btree_compute_maxlevels(minrecs, MAXEXTNUM) + 1;
>> +	return xfs_btree_compute_maxlevels(minrecs, XFS_MAX_EXTCNT_DATA_FORK) + 1;
>>  }
>>  
>>  /*
>> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
>> index 9934c320bf01..eff86f6c4c99 100644
>> --- a/fs/xfs/libxfs/xfs_format.h
>> +++ b/fs/xfs/libxfs/xfs_format.h
>> @@ -873,9 +873,11 @@ enum xfs_dinode_fmt {
>>  /*
>>   * Max values for extlen, extnum, aextnum.
>>   */
>> -#define	MAXEXTLEN	((xfs_extlen_t)0x001fffff)	/* 21 bits */
>> -#define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
>> -#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
>> +#define	MAXEXTLEN			((xfs_extlen_t)0x1fffff)	/* 21 bits */
>> +#define XFS_MAX_EXTCNT_DATA_FORK	((xfs_extnum_t)0xffffffffffff)	/* Unsigned 48-bits */
>> +#define XFS_MAX_EXTCNT_ATTR_FORK	((xfs_aextnum_t)0xffffffff)	/* Unsigned 32-bits */
>> +#define XFS_MAX_EXTCNT_DATA_FORK_OLD	((xfs_extnum_t)0x7fffffff)	/* Signed 32-bits */
>> +#define XFS_MAX_EXTCNT_ATTR_FORK_OLD	((xfs_aextnum_t)0x7fff)		/* Signed 16-bits */
>
> Could you change the #define value to a shift and subtract like you do
> for MAXEXTLEN^WXFS_MAX_BMBT_EXTLEN in patch 16?
>
> e.g.
>
> #define XFS_MAX_EXTCNT_DATA_FORK	((xfs_extnum_t)((1ULL << 48) - 1))

Sure. I will incorporate the above change.

>
> Also, you might want to document briefly in this header file why it is
> that the bmbt is limited to 2^48 extents even though the dinode fields
> are 64 bits wide and there can be up to 2^54 blocks mapped by a fork.
> ISTR the reason is to avoid having the bmbt cursor cache have to handle
> a 12-level btree or something, right?
>
> (Sorry, it's been a while...)
>

The discussion initially started with the observation that anything more than
2^43 extents on a 1k block sized filesystem can cause a BMBT tree's height to
become larger than XFS_BTREE_MAXLEVELS (i.e. 9). Increasing the value of
XFS_BTREE_MAXLEVELS was not an option since that would cause the following
sequence of events,

1. An increase in the rmapbt's maximum height (on filesystems which have both
   reflink and rmap features enabled).
2. An increase in transaction reservation values.

However this is no longer an issue since the btree cursor now contains a
variable length array and XFS_BTREE_MAXLEVELS is now removed.

2^48 as the maximum extent count was arrived at based on the following logic,

2^63 (max file size) / 64k (max block size) = 2^47

i.e. 2^47 can be a valid upper bound for all block sizes.

Rounding up 47 to the nearest multiple of bits-per-byte results in 48. Hence
2^48 was chosen as the maximum data fork extent count.

I will include the above description in the next version of the patchset.

>>  
>>  /*
>>   * Inode minimum and maximum sizes.
>> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
>> index 860d32816909..34f360a38603 100644
>> --- a/fs/xfs/libxfs/xfs_inode_buf.c
>> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
>> @@ -361,7 +361,8 @@ xfs_dinode_verify_fork(
>>  			return __this_address;
>>  		break;
>>  	case XFS_DINODE_FMT_BTREE:
>> -		max_extents = xfs_iext_max_nextents(whichfork);
>> +		max_extents = xfs_iext_max_nextents(xfs_dinode_has_nrext64(dip),
>> +					whichfork);
>>  		if (di_nextents > max_extents)
>>  			return __this_address;
>>  		break;
>> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
>> index ce690abe5dce..a3a3b54f9c55 100644
>> --- a/fs/xfs/libxfs/xfs_inode_fork.c
>> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
>> @@ -746,7 +746,7 @@ xfs_iext_count_may_overflow(
>>  	if (whichfork == XFS_COW_FORK)
>>  		return 0;
>>  
>> -	max_exts = xfs_iext_max_nextents(whichfork);
>> +	max_exts = xfs_iext_max_nextents(xfs_inode_has_nrext64(ip), whichfork);
>>  
>>  	if (XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
>>  		max_exts = 10;
>> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
>> index 4a8b77d425df..0cfc351648f9 100644
>> --- a/fs/xfs/libxfs/xfs_inode_fork.h
>> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
>> @@ -133,12 +133,23 @@ static inline int8_t xfs_ifork_format(struct xfs_ifork *ifp)
>>  	return ifp->if_format;
>>  }
>>  
>> -static inline xfs_extnum_t xfs_iext_max_nextents(int whichfork)
>> +static inline xfs_extnum_t xfs_iext_max_nextents(bool has_big_extcnt,
>
> has_nrext64, to be consistent with most everywhere else?
>

You are right. I will fix this.

> --D
>
>> +				int whichfork)
>>  {
>> -	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK)
>> -		return MAXEXTNUM;
>> +	switch (whichfork) {
>> +	case XFS_DATA_FORK:
>> +	case XFS_COW_FORK:
>> +		return has_big_extcnt ? XFS_MAX_EXTCNT_DATA_FORK
>> +			: XFS_MAX_EXTCNT_DATA_FORK_OLD;
>> +
>> +	case XFS_ATTR_FORK:
>> +		return has_big_extcnt ? XFS_MAX_EXTCNT_ATTR_FORK
>> +			: XFS_MAX_EXTCNT_ATTR_FORK_OLD;
>>  
>> -	return MAXAEXTNUM;
>> +	default:
>> +		ASSERT(0);
>> +		return 0;
>> +	}
>>  }
>>  
>>  static inline xfs_extnum_t
>> -- 
>> 2.30.2
>> 


-- 
chandan
