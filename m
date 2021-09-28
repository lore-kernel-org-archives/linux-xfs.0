Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F83AC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Sep 2021 09:47:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4700E610E5
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Sep 2021 09:47:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240013AbhI1Jt3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Sep 2021 05:49:29 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:31560 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240011AbhI1Jt2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Sep 2021 05:49:28 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18S8k6Vu002935;
        Tue, 28 Sep 2021 09:47:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=0DkeC26l4k9vF1poNi+qz/4P+gfHPBHVvqDKxJ3dBPg=;
 b=k4a+hOgEqATBWuO9TrophpnYKf1FrjENnRPCMM3uIxStDwjaQtKdQIOV/bGjl/8/MzG2
 9hYxaqgmrONeCDxBGQRceDbWn8duh32W6uIAYd4ZlwrSjwD1XZd5glHAG1oTtzh+UtqH
 +t44y4e++qJurYLE9t6JDIDPRZ4LBiZgkVrZowWy23g7sxZZ8957wpeNU77aVBJNHZoy
 puOTyi0vbhragSfFKQvl2XLKL1GLxizswZnX7gCd+YJf8rw/GmogFVTE/DBfDqZnqzIA
 nOzvZ9ZBmjE3498aDQ7O6wctJi1yrpqbTMatCuw4IIGz+S508ByYzCGMVTae/yhmxNia uQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bbj90mryp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Sep 2021 09:47:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18S9VREx010824;
        Tue, 28 Sep 2021 09:47:47 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2049.outbound.protection.outlook.com [104.47.51.49])
        by aserp3020.oracle.com with ESMTP id 3b9x51ude6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Sep 2021 09:47:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=edyPcrS9Ixu/47OVYFfiAkmy3yLckV3t2IBGOiAuLPfQSr5QkWwOMU4+dO8o9mIk2pjn6l0cp9aw3sv5ZZmpmBOYhYbQakmbvV8iFJTRnSYHh3bk95I6F9vyv9OFigYlQJPhYCL32kNjFvIhJTKQVzzyR8OsYZSla6FTCbkA6Edqsmc/WHO1qDDTACAqfDkKCmh1zYvO7NUEmyXTt/8wLZ60r9ibIr0RmdrSrzIQ1ccbmKMFe8487najOUnAdxOi9+V8I8zpMQ9ih7+YAYvEKIWJDzG6QJULx22Wjb0tqhvTBxZ34rAXxdF5Gdmry7xTP91XKGdJt3vumU/aoK7dlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=0DkeC26l4k9vF1poNi+qz/4P+gfHPBHVvqDKxJ3dBPg=;
 b=Pt8eCoRQ0nwuZOewLpAEiG0d9DlKVCbC0IRF36QAE13HUem2wCbLPpWtRoBawLWajDOULxJOvzvxbv77DULggDOF7oI25d6BCueT012MSZn/f+8onQ1d1U/78foz6yOWF79+6jU8X2sowDOKDFD+/zol/7zY786wGgiQiXYwuFaYLzQZcgQXLQnWvZfJloPJD5pE3yWCPn4zpPcG4X0V1htZYvcJ1yvFkcbvhbINHmDsCcKckiwAjgZO16gXbHkwxYyIK0Zu784NRHffhOCAJZuWe/u3pAce/c/YU8FRt+f8ngbZwAm0AxUSmcptR5kUIqmVeF+YypHTuZqjbNI7xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0DkeC26l4k9vF1poNi+qz/4P+gfHPBHVvqDKxJ3dBPg=;
 b=cl5z3ZBghRXHvdjbsY2efBYVJOWErlZe2FrZj8mbJ0+cMp+mPDlLWv+3zeyy1Xxu8WnVKB6MURtfugNlHOOPUe6v87aRZXJTh3J2aGj3w96vJyhsUyi8ergmyb6HiiBUXyAQusXSDtD4TsGwG2UoUPxYnPQXJbpC+GDotGG4u9M=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB3053.namprd10.prod.outlook.com (2603:10b6:805:d2::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Tue, 28 Sep
 2021 09:47:45 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%8]) with mapi id 15.20.4544.021; Tue, 28 Sep 2021
 09:47:45 +0000
References: <20210916100647.176018-1-chandan.babu@oracle.com>
 <20210916100647.176018-8-chandan.babu@oracle.com>
 <20210927234637.GM1756565@dread.disaster.area>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V3 07/12] xfs: Rename inode's extent counter fields
 based on their width
In-reply-to: <20210927234637.GM1756565@dread.disaster.area>
Message-ID: <877df11170.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Tue, 28 Sep 2021 15:17:31 +0530
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0179.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:d::22) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (122.171.129.29) by MA1PR01CA0179.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a01:d::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15 via Frontend Transport; Tue, 28 Sep 2021 09:47:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ae256ca-9ebc-4d75-cae4-08d9826505ba
X-MS-TrafficTypeDiagnostic: SN6PR10MB3053:
X-Microsoft-Antispam-PRVS: <SN6PR10MB30535B26B10210A79C4E9643F6A89@SN6PR10MB3053.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DtUe5TCDO/Dm5iSMzfUAkw4RifCLSqeW22izL6OjyXXA+aL17ZF5ZwFnpHrZHJTcXHRny2I73rrw3IanFiKWOdv61AsgW05S0Lnv/21077Z3jtf2k4HSsVlTvkZUDE1+RF7QJ2WDKtJCzsiqjuPc5WICMBHJOXeJ4GkmK6ocaCfGMWTSuiEVjQrtqP9FQQAeO8BoYkz3Ma00Ud6MCmrpd9lkcbW+SK90CQlEy8ugWUSsgtledRwp6+z+zXKsL4x59pNOJjCR3ebviuPNgQiddjzFTRonSfcS0WoBSDmQ2dhCOCV+wnQuXRq75eczNBsbYJvUt7hX5AKA/bNPwRp+oNOAatA+wmUWKt73Gxonj6HCMeDsqdl+xeNke2MlCbSZYfNKJGQ6PO3DqJIH+CI25LnC+h6mqqhtepznsDt+UjfzXSZThx4wUo4QgASYuE4COvJbts800cFjFhz5nUqP6pRGaRPrySAYUqNPRBrgINn4U+BqfAF/GfNHxpAQbIEYZlCMnRXZfn8XkCfVCLtO2ZZ01qMASZGIzKWBbcn6yIhw9Truu0/e1Ui8No8QdB6tP8nUHH9qRx3jgqcNZvozpZEYTF817IyunUWo9KX7fKplHKpQz8tb/6eteTDosBy2OO/ju5HkqxQXxtoc9liw7vOhCUpP0X6ORjpop5nnWPFzFZm9kt1jqd/BMwS/dQKE6i+lzYL2ziFBZtxWd+PNVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(316002)(6666004)(6496006)(26005)(52116002)(33716001)(4326008)(508600001)(8676002)(956004)(9686003)(83380400001)(8936002)(38350700002)(86362001)(5660300002)(6916009)(2906002)(6486002)(53546011)(66946007)(66476007)(66556008)(186003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IE7PtGmIwd42HP+5lMyiwKKBsphgxr81FZdDVqqM7e6dgnSHLYey8gSZPH0W?=
 =?us-ascii?Q?L9RWITOhwGOSo6GXS1r59Arm7FRAFXx4tdvvgwgJZNNvYfEupnWlEuxdSNwL?=
 =?us-ascii?Q?neUjzzi3JNHVumr+Q40a7QrkPx7xK6F10LeqdJ+TK4w0AnDTsR7m29iJrn/t?=
 =?us-ascii?Q?LhKtG4Ty551daQCbHxNqOlu9lGugKQraMgKR7RN9iPTpCAbzQg1ouCG4YKgm?=
 =?us-ascii?Q?r806rvK4mbS0vlyWw53tI6q4UwWdwsXD/dmTJHEB/Mqb0srvmWis8crH19en?=
 =?us-ascii?Q?1b9gIsiUyBHYWd1fLpFx268mXSMBOqSVkxvrGKve7+ZVn2nGi8O5VYhwng37?=
 =?us-ascii?Q?nOMEkmQxEE7D4iPGcS1n97OxtmhM2op1kpElHzA8Pb7ZlSw0wtwfvncBbys3?=
 =?us-ascii?Q?3D10D60VnkiYC/+dqe7rjkroDL5KYL4uDruw9aoN2Ftg7YEHuHtmcN9RrHff?=
 =?us-ascii?Q?dQjbjqr2ekJAnR2ZHpWTi9UWloSx2/yYVRaNZd1KchZgmgkZ4ZhnOf844CU4?=
 =?us-ascii?Q?Xw582PJrMTjlBAZvBvMd95DtNupYtNfsBze4CZ4GkVM/52uf56Ojiwe7z5nb?=
 =?us-ascii?Q?gXeuDAwi1wR/Wjfi5FY5ck2wZuCukecI+r/D217HW5ZY5jQtVm6dkBuG/uk+?=
 =?us-ascii?Q?gAR4DJS0fWcpGU5abCz2JLNhhNdSPuoZcs1ZqNFPiOzch3JbOncQCXjjygl9?=
 =?us-ascii?Q?9COBqy0HHZlybLiXBRWtQ4sQcwc4CzuOpkiDprQH9khGtaw6hGfFl9Mh4N4K?=
 =?us-ascii?Q?eiz4+2K6cmZQcurnrh2JpSoXlQzKj0t6B815VdQZxv+aNBbRTPJrN8vuJSw2?=
 =?us-ascii?Q?fVxW4Ieo7S19zTQyq8J0RQZqQSWl4wr2cyS++eCEFpmiBechng3vAS288fcw?=
 =?us-ascii?Q?OSS+mU4LdpqPG4o0FIt3l/kFxiAdnsL+mpMaRoSzEG2PHTA4ytLu7cANqLeD?=
 =?us-ascii?Q?k29q4UOW615YN3K+qqR9Y+3mEdgFygsEjXmfp3q2HUwyUzUsIGYmZYSaZYSX?=
 =?us-ascii?Q?KvmhA0BJx7DJYHu1/SbVZYCcHQlSemcxPHqtcOR/aegOZ+C05aMDJ0RdBpdc?=
 =?us-ascii?Q?XH/qfkXB9+B5rbII7AUekRVo1lgVMXaHmedLUuczwQKVzqJWKZsF749zqQrl?=
 =?us-ascii?Q?yZLBxMkJufttWO5tZevaOipNSy7Bp935f/8/A9wFIszTK1Ro7tHWsj09IxUK?=
 =?us-ascii?Q?PizfiACaueV8FmofO7vWYxXM53QFiqgCYJXL3DoQpocdHNqUSHWMA5Bx3+MH?=
 =?us-ascii?Q?2nC338d6SZEbQLEb4dDBuf4YDw+8LD+ddRVPF5E5EqUdjN5pJo1suAv9hw/u?=
 =?us-ascii?Q?Atd/yHsReLKgsjNY9IIJUFYi?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ae256ca-9ebc-4d75-cae4-08d9826505ba
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 09:47:45.1898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vKx7p22D8tSGB8gsCVKXoDNi7o7+PuS66lh2od5mV4ADvDWNV0u5+DxLhgUMXH4Q9xlDwj/bW6aDYOhDMpTNsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3053
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10120 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 adultscore=0
 mlxscore=0 malwarescore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109280056
X-Proofpoint-GUID: FmJ6ruY8NoxHGUKN1oE415N-irPKOUgN
X-Proofpoint-ORIG-GUID: FmJ6ruY8NoxHGUKN1oE415N-irPKOUgN
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 28 Sep 2021 at 05:16, Dave Chinner wrote:
> On Thu, Sep 16, 2021 at 03:36:42PM +0530, Chandan Babu R wrote:
>> This commit renames extent counter fields in "struct xfs_dinode" and "struct
>> xfs_log_dinode" based on the width of the fields. As of this commit, the
>> 32-bit field will be used to count data fork extents and the 16-bit field will
>> be used to count attr fork extents.
>> 
>> This change is done to enable a future commit to introduce a new 64-bit extent
>> counter field.
>> 
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  fs/xfs/libxfs/xfs_format.h      |  8 ++++----
>>  fs/xfs/libxfs/xfs_inode_buf.c   |  4 ++--
>>  fs/xfs/libxfs/xfs_log_format.h  |  4 ++--
>>  fs/xfs/scrub/inode_repair.c     |  4 ++--
>>  fs/xfs/scrub/trace.h            | 14 +++++++-------
>>  fs/xfs/xfs_inode_item.c         |  4 ++--
>>  fs/xfs/xfs_inode_item_recover.c |  8 ++++----
>>  7 files changed, 23 insertions(+), 23 deletions(-)
>> 
>> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
>> index dba868f2c3e3..87c927d912f6 100644
>> --- a/fs/xfs/libxfs/xfs_format.h
>> +++ b/fs/xfs/libxfs/xfs_format.h
>> @@ -802,8 +802,8 @@ typedef struct xfs_dinode {
>>  	__be64		di_size;	/* number of bytes in file */
>>  	__be64		di_nblocks;	/* # of direct & btree blocks used */
>>  	__be32		di_extsize;	/* basic/minimum extent size for file */
>> -	__be32		di_nextents;	/* number of extents in data fork */
>> -	__be16		di_anextents;	/* number of extents in attribute fork*/
>> +	__be32		di_nextents32;	/* number of extents in data fork */
>> +	__be16		di_nextents16;	/* number of extents in attribute fork*/
>
>
> Hmmm. Having the same field in the inode hold the extent count
> for different inode forks based on a bit in the superblock means the
> on-disk inode format is not self describing. i.e. we can't decode
> the on-disk contents of an inode correctly without knowing whether a
> specific feature bit is set in the superblock or not.
>
> Right now we don't have use external configs to decode the inode.
> Feature level conditional fields are determined by inode version,
> not superblock bits. Optional feature fields easy to deal with -
> zero if the feature is not in use, otherwise we assume it is in use
> and can validity check it appropriately. IOWs, we don't need
> to look at sb feature bits to decode and validate inode fields.
>
> This change means that we can't determine if the extent counts are
> correct just by looking at the on-disk inode. If we just have
> di_nextents32 set to a non-zero value, does that mean we should have
> data fork extents or attribute fork extents present?
>
> Just looking at whether the attr fork is initialised is not
> sufficient - it can be initialised with zero attr fork extents
> present.  We can't look at the literal area contents, either,
> because we don't zero that when we shrink it. We can't look at
> di_nblocks, because that counts both attr and data for blocks. We
> can't look at di_size, because we can have data extents beyond EOF
> and hence a size of zero doesn't mean the data fork is empty.
>
> So if both forks are in extent format, they could be either both
> empty, both contain extents or only one fork contains extents but we
> can't tell which state is the correct one. Hence
> if di_nextents64 if zero, we don't know if di_nextents32 is a count
> of attribute extents or data extents without first looking at the
> superblock feature bit to determine if di_nextents64 is in use or
> not. The inode format is not self describing anymore.
>
> When XFS introduced 32 bit link counts, the inode version was bumped
> from v1 to v2 because it redefined fields in the inode structure
> similar to this proposal[1]. The verison number was then used to
> determine if the inode was in old or new format - it was a self
> describing format change. Hence If we are going to redefine
> di_nextents to be able to hold either data fork extent count (old
> format) or attr fork extent count (new format) we really need to
> bump the inode version so that we can discriminate between the two
> inode formats just by looking at the inode itself.
>
> If we don't want to bump the version, then we need to do something
> like:
>
> -	__be32		di_nextents;	/* number of extents in data fork */
> -	__be16		di_anextents;	/* number of extents in attribute fork*/
> +	__be32		di_nextents_old;/* old number of extents in data fork */
> +	__be16		di_anextents_old;/* old number of extents in attribute fork*/
> .....
> -	__u8            di_pad2[12];
> +	__be64		di_nextents;	/* number of extents in data fork */
> +	__be32		di_anextents;	/* number of extents in attribute fork*/
> +	__u8            di_pad2[4];
>
> So that there is no ambiguity in the on-disk format between the two
> formats - if one set is non-zero, the other set must be zero in this
> sort of setup.
>
> However, I think that redefining the fields and bumping the inode
> version is the better long term strategy, as it allows future reuse
> of the di_anextents_old field, and it uses less of the small amount
> of unused padding we have remaining in the on-disk inode core.
>
> At which point, the feature bit in the superblock becomes "has v4
> inodes", not "has big extent counts". We then use v4 inode format in
> memory for everything (i.e. 64 bit extent counts) and convert
> to/from the ondisk format at IO time like we do with v1/v2 inodes.
>
> Thoughts?

The patch "xfs: Extend per-inode extent counter widths" (which appears later
in the series) adds the new per-inode flag XFS_DIFLAG2_NREXT64. This flag is
set on inodes which use 64-bit data fork extent counter and 32-bit attr fork
extent counter fields. Verifiers can check for the presence/absence of this
flag to determine which extent counter fields to use for verification of an
xfs_dinode structure.

Hence, XFS_DIFLAG2_NREXT64 flag should be sufficient for maintaining the self
describing nature of XFS inodes right?

>
> -Dave.
>
> [1] The change to v2 inodes back in 1995 removed the filesystem UUID
> from the inode and was replaced with a 32 bit link counter, a project ID
> value and padding:
>
> @@ -36,10 +38,12 @@ typedef struct xfs_dinode_core
>         __uint16_t      di_mode;        /* mode and type of file */
>         __int8_t        di_version;     /* inode version */
>         __int8_t        di_format;      /* format of di_c data */
> -       __uint16_t      di_nlink;       /* number of links to file */
> +       __uint16_t      di_onlink;      /* old number of links to file */
>         __uint32_t      di_uid;         /* owner's user id */
>         __uint32_t      di_gid;         /* owner's group id */
> -       uuid_t          di_uuid;        /* file unique id */
> +       __uint32_t      di_nlink;       /* number of links to file */
> +       __uint16_t      di_projid;      /* owner's project id */
> +       __uint8_t       di_pad[10];     /* unused, zeroed space */
>         xfs_timestamp_t di_atime;       /* time last accessed */
>         xfs_timestamp_t di_mtime;       /* time last modified */
>         xfs_timestamp_t di_ctime;       /* time created/inode modified */
> @@ -81,7 +85,13 @@ typedef struct xfs_dinode
>
> it was the redefinition of the di_uuid variable space that required
> the bumping of the inode version...


-- 
chandan
