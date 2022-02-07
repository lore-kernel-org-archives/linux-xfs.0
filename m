Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 434CDC4321E
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Feb 2022 06:18:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233336AbiBGGRu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Feb 2022 01:17:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242292AbiBGE4g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Feb 2022 23:56:36 -0500
X-Greylist: delayed 71 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 06 Feb 2022 20:56:35 PST
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90E0C043181
        for <linux-xfs@vger.kernel.org>; Sun,  6 Feb 2022 20:56:35 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2173rR4Z027523;
        Mon, 7 Feb 2022 04:56:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=mB7fOBWoiDTsTSsUvwOO8i0Ba8v2NdJJq16VcLiDEo8=;
 b=Qyornsj9pObDHybl4teRwL1UPzKDdV0ir5bB31N3xfk9GJpD4rbnt/Z/h9V8/I6pL2aY
 x87E0J/w1JPV2BMUTsxiVJUs3DrhbFjkfDg80YlDdxuUfX6HV3KQeCPn1NDBSxHzd/X+
 6Xe4tTup93IwEaCwk+g2mVg7K1sB3GP7XRBzQ6jwqHftLjL/Ms6eVKXQK3Thb3Djy+8r
 3f5cK3Hq+z3QudLz83GsHCERW/9St1E9FG3j5qSyRhSuXZEWUE1/7DymXfVHwoNa952u
 70Uzdkvd6YEk2TJyOLjUbS+eLBWYiVZelES5EFiJYWwWfAlBmMGTK6s/oUoacr/k/eHE FA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e1h4b4j1v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Feb 2022 04:56:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2174kpRi189081;
        Mon, 7 Feb 2022 04:56:31 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2049.outbound.protection.outlook.com [104.47.74.49])
        by userp3020.oracle.com with ESMTP id 3e1jpmuehr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Feb 2022 04:56:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oD92nwMAxVn1cAzT/B7gX2NR4+ctGLJnwaqCmRRyfzJ6frBrD6eGgH5de26j/BQ4IeQjW3CDgWKbrGW3KAqEyFCkGats8Dl7Y/eCzuIEyUV8IPXnNaB80aeTiZ5SNTRhRWIG2axD2m/lJL2LIklDxmZy95KSa6vov7fdV6mpsktrnuIvZ4mvn49nlqNSyAR7n7zDwz2DFAJr2bFEWIohUz3aYr6iz4IIsjSjQE0K60kSWZqXp/H0sRZe17OLqmlnTY0+Wmka3aZrgsOas6UJMZmTe7+liNkqFpo597GgFR/SXbZQ61BKuD297SXo1yEJhCeh9OZKh4FoRsz0e48Ixg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mB7fOBWoiDTsTSsUvwOO8i0Ba8v2NdJJq16VcLiDEo8=;
 b=Uc4M6fZV5RS/Tj+q56bKlZbBNwhWdr3I4uBQlOELIyALln4hQpAwiZs601/QIWg7rbKauKRWwAHogPfaCj9hF9NLY+/h8GCzmM0FW08uLZlKw413nsduDoO3x4CUVvbaA8SzObeYjOC0I85tR0G/S5wO4buXWMARCMV7u3FW/Ye5e0E8oznCP3bXkMAWUCaCzAb5KJ50B+Ub2y1SB+C2O/3kuOuE6BEMSf5sYwIDfIKxttEjsXHeyJPW2d6pP/Dh/nWPB3YxuGFqyt+oc2bOpCCCn3rGQQ8VjXzddMTtWzY61fU5i5gsXQn/7os0aI6gtMnpdHAa88acNDz5ZHeBmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mB7fOBWoiDTsTSsUvwOO8i0Ba8v2NdJJq16VcLiDEo8=;
 b=QMNdIjhmlMFXNH81ZwINyTpzO/1jwJkG5kEsum/8FNS4EbBkp95vTeHTz5jzgCqHAvAzl8OrFiYgSf436o3ctXHAxDXNrKLRasIjDa/fsf/Wh+ngSMTMG+/Jt4NmHundpuDSS5hklUkUbPdNxraG4QTCQSxt2XsJEyMx/a8USho=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by DM5PR1001MB2156.namprd10.prod.outlook.com (2603:10b6:4:2b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Mon, 7 Feb
 2022 04:56:29 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::fc8e:7310:2762:be9e]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::fc8e:7310:2762:be9e%5]) with mapi id 15.20.4951.018; Mon, 7 Feb 2022
 04:56:29 +0000
References: <20220121051857.221105-1-chandan.babu@oracle.com>
 <20220121051857.221105-15-chandan.babu@oracle.com>
 <20220201192449.GB8338@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V5 14/16] xfs: Enable bulkstat ioctl to support 64-bit
 per-inode extent counters
In-reply-to: <20220201192449.GB8338@magnolia>
Message-ID: <87o83jmg0a.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Mon, 07 Feb 2022 10:26:21 +0530
Content-Type: text/plain
X-ClientProxiedBy: TYBP286CA0005.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:404:ce::17) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c8220c57-abed-4c84-2e1b-08d9e9f633a6
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2156:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB215687362F001D8B59287DF0F62C9@DM5PR1001MB2156.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GQ0gS/sv1Za0hMdYn+YmkNvhsPBGgLpiemEm6bNdSFEJ05SfJy3EFTGQCQHFBBZdCfaHya0BlMuMuRpdQGG4lmQLr4LcCoMn1c8Zr7/d6F49YQHZleCTnAX9zxl4EOsiDUXRCmOnbWCWJHn0c05uimiTpJd3K7Ww2fXeCLRWqcBF5y9S4GVLb1j/ivuZx3VuG1VPxajtDkDJKtNlIIRG/o7jN/AqQNtd2CACA/RzTjzoxH/7RkguMB4fhAFkiWM0UOMCVqEq+qZh8NQDgFIJIIAIQ/KhuoB/G+tLLNgUH1qnRChu7I8bjYypIE390YkZV4ZannyJ3LTPFOSGoMwlmRfJ+PXqzTGIcw/i5jG0j38IBVLLhpw5oBKHfHsXGnqj9YKaoBfP9i8N6vLeKSAMGwLB3X9gZVVEemx7Jw0+4AclqGg/UKC0VwKOQqTg2ZZnAL2YHYJwYIH0PtLeACMMCyrtljV/SL7/ko7eSupjOp5l2Z51oYKvdnbemuGK8BEM9bcWpf10CUIQsvuU0Yh/3Sdwqv5bsw2d8bz/iPEUKmos2BUjzuWOpCJpKX/0h4IXOm59lEUnCg2afyNxsTbGmfmsmJbrlY5Lb7LPpu8CipxXxpdBjFNzWa4Ph349OVcfmJTviV8GkPYKB3QyZKDS113f6wtS2/o3Q08bEw3ZdxxfqCwK/ElEoBl43//xqgxZbXdJx3VLFWn0LEWW7x/JAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(9686003)(38350700002)(6512007)(508600001)(6506007)(6666004)(53546011)(52116002)(66946007)(83380400001)(8676002)(8936002)(66556008)(66476007)(4326008)(6916009)(186003)(86362001)(26005)(316002)(38100700002)(2906002)(5660300002)(33716001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hfJq+F1vuDqxWqFiWVRnXTVvZCIzTsHNtf2vy4QHW7jHz7HJhStc8oqgAC3s?=
 =?us-ascii?Q?bnoWUCbkEoWLhVAAa1D6I7OCq3r+fa/3I+l87Nd7KgguI0YBRp8wcZIxGh7m?=
 =?us-ascii?Q?jWsrv6A//n6Vv7GvSjAqIpkiTdCbZ66+BkHWBaHxDhXYHd8Q/v7XYmkL1rU0?=
 =?us-ascii?Q?UOuMYklT6dPlhVHleRZLYM3vq3/kTir355iNQjEA6QBY/TRCGRegEkhwnoLx?=
 =?us-ascii?Q?+8cNfA0ZMIxNPITsBVIDeGLBHnFGzPyurJvQW6luyAqXF/6hLnhUwFqB0i2o?=
 =?us-ascii?Q?DBOOlK1QvyE+gykYSejiZ7BtT72lPkpcD1LX1gShJd52TKYdclCI5eKOmgzz?=
 =?us-ascii?Q?l1CQdohljT3TjW5+wxooc2Uy56aOCTN5cQDKiPMrO8gY2olZwroV6xk4e1Hb?=
 =?us-ascii?Q?8n3aQ0Ng3NYeZBf4MojG0OA2+zSJous47am62tfauhNYecFOB/Rk6r1i3k4N?=
 =?us-ascii?Q?hUt8Jb4KgsUz8JKbfR2udEOBcgP7XdW1wSHe6nt9tHm6cBm1R/JC1HLBZtsQ?=
 =?us-ascii?Q?A7oJFuxTeVlWA/n0LPpFPCr7cjbMl8seg9u4GfK3F8sv9sxjN2BUzgHKS3Fs?=
 =?us-ascii?Q?PzjfZ2uSKLeTRyenIiVHepK+AOeTdHrPZkupK0zkWy4AhD6hesf1Tx54FICE?=
 =?us-ascii?Q?gqF8wD5fNp6Fhimw/XJyxOfrNfv41EiD3OvUuv5h2m4+z4SCwsxzSHjrCBxO?=
 =?us-ascii?Q?6ZmgloAlA73CiclELIOh/PridAf236jiVkAvWvkqt91tZL8G1Lm1LXKTlO+z?=
 =?us-ascii?Q?lL5ToYjP5MlhysdFpEWH/IKaCnCuKwoCSvOaXhPJyxaCTC32aMW0Y9l6P10C?=
 =?us-ascii?Q?R1lkQ9PECNjxgSvgjuiS22rQW4AJ62JsF925kSj/WS6OrwQsGMY+mk7Rnsus?=
 =?us-ascii?Q?MbMUXCW4BbU9mWF4c8W3Go0HnV5Uryn3VXJE3L55yxLkx+Bf6iF2U8EVoxZt?=
 =?us-ascii?Q?Hy4AHAuhjpSX5qWowuXczOh8O+XLGvVWTDAOyRMFOnzFJq4+Ur0c6JLA9MxF?=
 =?us-ascii?Q?LLi0Xg6ZjiG+g24IryKRwzJ7/nDFMjLTmvMpM8Xy/Q1MX7ytQqjDiJrA6wLa?=
 =?us-ascii?Q?2HjNdIuN46xT1vft3uja5hbWRMB/c8STGSn2AhM0ovTh6ZX0DguyPZ3FxNxr?=
 =?us-ascii?Q?amKTVJd9TYoO8MmzThAVaeLkM/lte74HCyyp8DpvcWRgZ0u14qL6F5xmO+Fi?=
 =?us-ascii?Q?pfo6yoT0+1a06V/0z6MItSHCYuxSYJlq9zzKCyX4FtVzvorRN8+AhT5l3HU/?=
 =?us-ascii?Q?vG4kn/6y3akFTM8MQYmaJUWfnmOBeXsJX6SJBN7IL1Uv8DvfL/NnX2buZf0x?=
 =?us-ascii?Q?XTVTki8eOYfkYNPurYW0daHohhfcFEHN1DZ65rIhhkLs054V/s1BQgHclTpQ?=
 =?us-ascii?Q?Wsic+iUCE/BPgpT7nevM1Iek8lA7uc97IIOpZutZpcX+ex1lUtgzn0kzi8rs?=
 =?us-ascii?Q?gIaxs+19o4fse4m8E032YCGu1FC9iGwhDB36vBNxbAmNdI0OezbP4yWsWcCV?=
 =?us-ascii?Q?RWHuXXLfAicJXLb5URcTCEwWoz9COKdeJ7NpN4p2jRNDLnzgJFXOUqtgIHs6?=
 =?us-ascii?Q?zYUCOl6ck1ftdnHYoxEuHLYyS1X9XdpwOvA+Drsp/MvAaqqbBih3akiSaLe5?=
 =?us-ascii?Q?8se0uqoCXy7yO496gNJzmUg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8220c57-abed-4c84-2e1b-08d9e9f633a6
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 04:56:29.0983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3n0uwmvX99V0b7NUa4uJsFTysUCKdyGFWDXPsvAPMhu7fg2umETpk6nz464qok+LJbj3WTFmUHgihWfCZYGl6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2156
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10250 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 phishscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202070029
X-Proofpoint-GUID: iN-41Bn8hI5D3TgAERB_Uqd3U3s3CC3S
X-Proofpoint-ORIG-GUID: iN-41Bn8hI5D3TgAERB_Uqd3U3s3CC3S
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 02 Feb 2022 at 00:54, Darrick J. Wong wrote:
> On Fri, Jan 21, 2022 at 10:48:55AM +0530, Chandan Babu R wrote:
>> The following changes are made to enable userspace to obtain 64-bit extent
>> counters,
>> 1. Carve out a new 64-bit field xfs_bulkstat->bs_extents64 from
>>    xfs_bulkstat->bs_pad[] to hold 64-bit extent counter.
>> 2. Define the new flag XFS_BULK_IREQ_BULKSTAT for userspace to indicate that
>>    it is capable of receiving 64-bit extent counters.
>> 
>> Suggested-by: Darrick J. Wong <djwong@kernel.org>
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  fs/xfs/libxfs/xfs_fs.h | 12 ++++++++----
>>  fs/xfs/xfs_ioctl.c     |  3 +++
>>  fs/xfs/xfs_itable.c    | 27 +++++++++++++++++++++++++--
>>  fs/xfs/xfs_itable.h    |  7 ++++++-
>>  fs/xfs/xfs_iwalk.h     |  7 +++++--
>>  5 files changed, 47 insertions(+), 9 deletions(-)
>> 
>> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
>> index 42bc39501d81..4e12530eb518 100644
>> --- a/fs/xfs/libxfs/xfs_fs.h
>> +++ b/fs/xfs/libxfs/xfs_fs.h
>> @@ -393,7 +393,7 @@ struct xfs_bulkstat {
>>  	uint32_t	bs_extsize_blks; /* extent size hint, blocks	*/
>>  
>>  	uint32_t	bs_nlink;	/* number of links		*/
>> -	uint32_t	bs_extents;	/* number of extents		*/
>> +	uint32_t	bs_extents;	/* 32-bit data fork extent counter */
>>  	uint32_t	bs_aextents;	/* attribute number of extents	*/
>>  	uint16_t	bs_version;	/* structure version		*/
>>  	uint16_t	bs_forkoff;	/* inode fork offset in bytes	*/
>> @@ -402,8 +402,9 @@ struct xfs_bulkstat {
>>  	uint16_t	bs_checked;	/* checked inode metadata	*/
>>  	uint16_t	bs_mode;	/* type and mode		*/
>>  	uint16_t	bs_pad2;	/* zeroed			*/
>> +	uint64_t	bs_extents64;	/* 64-bit data fork extent counter */
>>  
>> -	uint64_t	bs_pad[7];	/* zeroed			*/
>> +	uint64_t	bs_pad[6];	/* zeroed			*/
>>  };
>>  
>>  #define XFS_BULKSTAT_VERSION_V1	(1)
>> @@ -484,8 +485,11 @@ struct xfs_bulk_ireq {
>>   */
>>  #define XFS_BULK_IREQ_SPECIAL	(1 << 1)
>>  
>> -#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO | \
>> -				 XFS_BULK_IREQ_SPECIAL)
>> +#define XFS_BULK_IREQ_NREXT64	(1 << 2)
>
> This needs a comment specifying the behavior of this flag.
>
> If the flag is set and the data fork extent count fits in both fields,
> will they both be filled out?

If the flag is set, xfs_bulkstat->bs_extents64 field will be assigned the data
fork extent count and xfs_bulkstat->bs_extents will be set to 0
(xfs_bulkstat() allocates xfs_bstat_chunk->buf by invoking kmem_zalloc()).

If the flag is not set, xfs_bulkstat->bs_extents field will be assigned the
data fork extent count and xfs_bulkstat->bs_extents64 will be set to 0.

>
> If the flag is set but the data fork extent count only fits in
> bs_extents64, what will be written to bs_extents?

bs_extents will be set to zero.

>
> If the flag is not set and the data fork extent count won't fit in
> bs_extents, do we return an error value?  Fill it with garbage?
>

In this case, we return -EOVERFLOW and the contents of bs_extents will be set
to zero. This happens because xfs_bulkstat() will return success even if
xfs_iwalk() returned an error provided that we already have collected details
about one more inodes. The next call to xfs_ioc_bulkstat() will start from the
problematic inode. Here we allocate xfs_bstat_chunk->buf using kmem_zalloc()
which zeroes the contents of the allocated memory and returns -EOVERFLOW to
userspace.

>> +
>> +#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO |	 \
>> +				 XFS_BULK_IREQ_SPECIAL | \
>> +				 XFS_BULK_IREQ_NREXT64)
>>  
>>  /* Operate on the root directory inode. */
>>  #define XFS_BULK_IREQ_SPECIAL_ROOT	(1)
>> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
>> index 29231a8c8a45..5d0781745a28 100644
>> --- a/fs/xfs/xfs_ioctl.c
>> +++ b/fs/xfs/xfs_ioctl.c
>> @@ -893,6 +893,9 @@ xfs_bulk_ireq_setup(
>>  	if (XFS_INO_TO_AGNO(mp, breq->startino) >= mp->m_sb.sb_agcount)
>>  		return -ECANCELED;
>>  
>> +	if (hdr->flags & XFS_BULK_IREQ_NREXT64)
>> +		breq->flags |= XFS_IBULK_NREXT64;
>> +
>>  	return 0;
>>  }
>>  
>> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
>> index c08c79d9e311..c9b44e8d0235 100644
>> --- a/fs/xfs/xfs_itable.c
>> +++ b/fs/xfs/xfs_itable.c
>> @@ -20,6 +20,7 @@
>>  #include "xfs_icache.h"
>>  #include "xfs_health.h"
>>  #include "xfs_trans.h"
>> +#include "xfs_errortag.h"
>>  
>>  /*
>>   * Bulk Stat
>> @@ -64,6 +65,7 @@ xfs_bulkstat_one_int(
>>  	struct xfs_inode	*ip;		/* incore inode pointer */
>>  	struct inode		*inode;
>>  	struct xfs_bulkstat	*buf = bc->buf;
>> +	xfs_extnum_t		nextents;
>>  	int			error = -EINVAL;
>>  
>>  	if (xfs_internal_inum(mp, ino))
>> @@ -102,7 +104,27 @@ xfs_bulkstat_one_int(
>>  
>>  	buf->bs_xflags = xfs_ip2xflags(ip);
>>  	buf->bs_extsize_blks = ip->i_extsize;
>> -	buf->bs_extents = xfs_ifork_nextents(&ip->i_df);
>> +
>> +	nextents = xfs_ifork_nextents(&ip->i_df);
>> +	if (!(bc->breq->flags & XFS_IBULK_NREXT64)) {
>> +		xfs_extnum_t max_nextents = XFS_MAX_EXTCNT_DATA_FORK_OLD;
>> +
>> +		if (unlikely(XFS_TEST_ERROR(false, mp,
>> +				XFS_ERRTAG_REDUCE_MAX_IEXTENTS)))
>> +			max_nextents = 10;
>> +
>> +		if (nextents > max_nextents) {
>> +			xfs_iunlock(ip, XFS_ILOCK_SHARED);
>> +			xfs_irele(ip);
>> +			error = -EOVERFLOW;
>> +			goto out;
>> +		}
>> +
>> +		buf->bs_extents = nextents;
>> +	} else {
>> +		buf->bs_extents64 = nextents;
>> +	}
>> +
>>  	xfs_bulkstat_health(ip, buf);
>>  	buf->bs_aextents = xfs_ifork_nextents(ip->i_afp);
>>  	buf->bs_forkoff = XFS_IFORK_BOFF(ip);
>> @@ -279,7 +301,8 @@ xfs_bulkstat(
>>  	if (error)
>>  		goto out;
>>  
>> -	error = xfs_iwalk(breq->mp, tp, breq->startino, breq->flags,
>> +	error = xfs_iwalk(breq->mp, tp, breq->startino,
>> +			breq->flags & XFS_IBULK_IWALK_MASK,
>
> I think it would be cleaner if this function did:
>
> 	unsigned int	iwalk_flags = 0;
>
> 	if (breq->flags & XFS_IBULK_SAME_AG)
> 		iwalk_flags |= XFS_IWALK_SAME_AG;
>
> 	...
>
> 	error = xfs_iwalk(breq->mp, tp, breq->startino, iwalk_flags,
> 			xfs_bulkstat_iwalk, breq->icount, &bc);
>
> to make the flags translation explicit.  That enables a full cleanup
> of...
>
>>  			xfs_bulkstat_iwalk, breq->icount, &bc);
>>  	xfs_trans_cancel(tp);
>>  out:
>> diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
>> index 7078d10c9b12..38f6900176a8 100644
>> --- a/fs/xfs/xfs_itable.h
>> +++ b/fs/xfs/xfs_itable.h
>> @@ -13,12 +13,17 @@ struct xfs_ibulk {
>>  	xfs_ino_t		startino; /* start with this inode */
>>  	unsigned int		icount;   /* number of elements in ubuffer */
>>  	unsigned int		ocount;   /* number of records returned */
>> -	unsigned int		flags;    /* see XFS_IBULK_FLAG_* */
>> +	unsigned long long	flags;    /* see XFS_IBULK_FLAG_* */
>>  };
>>  
>>  /* Only iterate within the same AG as startino */
>>  #define XFS_IBULK_SAME_AG	(XFS_IWALK_SAME_AG)
>>  
>> +#define XFS_IBULK_ONLY_OFFSET	32
>> +#define XFS_IBULK_IWALK_MASK	((1ULL << XFS_IBULK_ONLY_OFFSET) - 1)
>> +
>> +#define XFS_IBULK_NREXT64	(1ULL << XFS_IBULK_ONLY_OFFSET)
>
> ...the code smells in the XFS_IBULK* flag space:
>
> /* Only iterate within the same AG as startino */
> #define XFS_IBULK_SAME_AG	(1 << 0)
>
> /* Whatever it is that nrext64 does */
> #define XFS_IBULK_NREXT64	(1 << 31)
>

Ok. This will indeed make the code more readable. I will include this change
when I post the next version of this patch.

>> +
>>  /*
>>   * Advance the user buffer pointer by one record of the given size.  If the
>>   * buffer is now full, return the appropriate error code.
>> diff --git a/fs/xfs/xfs_iwalk.h b/fs/xfs/xfs_iwalk.h
>> index 37a795f03267..11be9dbb45c7 100644
>> --- a/fs/xfs/xfs_iwalk.h
>> +++ b/fs/xfs/xfs_iwalk.h
>> @@ -26,9 +26,12 @@ int xfs_iwalk_threaded(struct xfs_mount *mp, xfs_ino_t startino,
>>  		unsigned int inode_records, bool poll, void *data);
>>  
>>  /* Only iterate inodes within the same AG as @startino. */
>> -#define XFS_IWALK_SAME_AG	(0x1)
>> +#define XFS_IWALK_SAME_AG	(1 << 0)
>>  
>> -#define XFS_IWALK_FLAGS_ALL	(XFS_IWALK_SAME_AG)
>> +#define XFS_IWALK_NREXT64	(1 << 1)
>> +
>> +#define XFS_IWALK_FLAGS_ALL	(XFS_IWALK_SAME_AG |	\
>> +				 XFS_IWALK_NREXT64)
>
> XFS_IWALK_NREXT64 isn't used anywhere.
>

Sorry, I will remove this.

Thanks for all the review comments.

-- 
chandan
