Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51B2EC4167D
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Feb 2022 06:18:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238311AbiBGGRv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Feb 2022 01:17:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352329AbiBGE7W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Feb 2022 23:59:22 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C360C043181
        for <linux-xfs@vger.kernel.org>; Sun,  6 Feb 2022 20:59:18 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21713nHF011697;
        Mon, 7 Feb 2022 04:55:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : message-id : in-reply-to : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=6ThNZSlBm47CKOtUQ6HVRMV0CDA8ciweFPZopLbSyk0=;
 b=OciWg9m+3A3vn2z1c45IvrVLyUEC6VaCENGF5V1xA9YcT/93pz0IGgtoNAOgkO5lldVr
 I6cbhqM9xqx5nl3TBbO8A61BAc1AlPkyaoNcohNrMi9UeiOOo8bga6I7gUAh20z4yUbM
 NcvGdRajiTIOYcSsb6nPTPTTmHSOAvII4cwB2G+6EkG+Q2tg3KBDN5li1UCTpTOXlAlY
 dthMMYVjH2eSv7U7Kblzcp0H+SGSE8bbiE+GAL4hM7ZeuFZkBDjK85COQ1qIfD592npH
 CQNGqJpOWEtHSt2Gi2v4zL1eXM4GcvdiVmEK51pjLv0tBIbHDY92vk7zB2oTHtw8/cMc qw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e1hsu4tv3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Feb 2022 04:55:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2174khfT188862;
        Mon, 7 Feb 2022 04:55:11 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by userp3020.oracle.com with ESMTP id 3e1jpmud1c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Feb 2022 04:55:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OVOT7Dkf7As6lWpKdYY62aoyff7C2amjPlJcRlkjrg1M9vqAUHNN6lLWHK0rblU/u1NUeZgTtfSwUlA16D0XoFsFKNxzme4bAGcVAPoyemUQYa+aYLOPKc7Dcv7WmnSSxO1LM5A0IMzagX7hYMeXjdZOk4JqjvJmbiS1VEVd4CJc75tvlb9Lw+kPx9vJFwcWwZix7qsPzg3dSQJxtRemkrNeGY4ysV+3UfTQgAGWEpIsOCkGRH/BmN5O3CBxvlLIU5kpZCbAhvkWuFXAL+jOfXFwQAKQWuo0iP8RvbrPIQ/aO3AeJghVqMlfKd8nGOCQXZUIJ+WEezAzzF5qO2DFKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ThNZSlBm47CKOtUQ6HVRMV0CDA8ciweFPZopLbSyk0=;
 b=YFPhZfFMGuTOQSTnSbupZsfPXCFcI71OQxk/KG3vwdsxaGeYUNPz9/fc2htuoH7NVwZSodynK8OCfflbC+e9qOdPvM45i3yU6QutCIrjWuhV2HFYkorrKLfBS6vYfr+maZsCcMHT1YMFofNa/WCnwPQTMkLoG6MA6KpCy1brG7bzhcDnkKmbuWOoYrTI990kk8lqnRe3VjUqLvIPIJvzGXK12dl2tvQITsE2det56Q6Gt19+FW+l/sKCAls3M+/8kERvYRoDjhIfgjQpPzonlLlLls4duL+AW1wskKBabQy2lm6o9Tj4jt7LLdBJaKV6Ml2zEqwFiOJaPQMHVbZn+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ThNZSlBm47CKOtUQ6HVRMV0CDA8ciweFPZopLbSyk0=;
 b=lF6GBXPDEcjxXo0Hxj5Sbn++djAi5D2PnnrA1EEhqB0jYRuL7AGBNlut/GMZLHarSe/24urFrZao3kyn3oAoPWvTu+9fuJProKwRexsf/tABWVee4D9DxySd2sEWgCTATz3wLdY8Illacsfhfy9jfI0LtPnl7rVKjGACgKuBbUI=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by CO1PR10MB4641.namprd10.prod.outlook.com (2603:10b6:303:6d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Mon, 7 Feb
 2022 04:55:07 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::fc8e:7310:2762:be9e]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::fc8e:7310:2762:be9e%5]) with mapi id 15.20.4951.018; Mon, 7 Feb 2022
 04:55:07 +0000
References: <20220121051857.221105-1-chandan.babu@oracle.com>
 <20220121051857.221105-13-chandan.babu@oracle.com>
 <20220201191056.GK8313@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH V5 12/16] xfs: Introduce per-inode 64-bit extent counters
Message-ID: <87tudgarix.fsf@debian-BULLSEYE-live-builder-AMD64>
In-reply-to: <20220201191056.GK8313@magnolia>
Date:   Mon, 07 Feb 2022 10:24:56 +0530
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0037.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::9) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c2dd95a-0978-4f31-7109-08d9e9f60301
X-MS-TrafficTypeDiagnostic: CO1PR10MB4641:EE_
X-Microsoft-Antispam-PRVS: <CO1PR10MB4641C73920299E36D9FA7AC8F62C9@CO1PR10MB4641.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:115;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BHtNQ5++vMTiwlfEdtr6oIWzBs1MGY72gm8c1QJ2XROhWY+nHzTDrQLNNsVM1l57gwjzTcrbJ/lt8lzRs+orqPCHV3+ni381x4+HiJIy4TX7IIkVv5bigK8yE1aXjxLKScnd+c3yhjf7jtizmLfGf/f1eULfjMYlQuh+s0XnRupeJgNe6UVaG4ziPvduvTwj3OCPhIGmT0SUkHKQhTwVtl8i2O+uB5rsSZ7o5tTO+kMiHRMDQT9gelalJFNSZ8Eqc2TDIOFL5XYo8sBQwCppoXMo1QY7d2boElkChuaaJUpYy4dK/WBmkd0FOri+z+KiYPW2exkLIwVUNIo4qlqpOlekTy5s5dZJam7qj0bzgOwXD9LfAcQMNGEdbZ5ZqQqg5RB6SOzEwt9koO4u3AISYl3+3CbI2ro2Nlqw0QjWg1spmkTeHJpkpzVLyFNmBF5QWxBz5q8blfx6p4XOXWLTdFP3xgF5yBonza79oSzfiLR6qole4ir8xUVjyobOpvQoNyhgr1jHkiJhJAXwRK7yi/o3eChAeivDJ5LoN3qJmOSU+T7KnJbe3eXHvC/hYuAbyyX3Mbho3ZioFZdZj+aBP1K8xYFWT0RbIC4ao1q+Nrvh+k741PdAhZKZJwMgaURV7xUhWGNPKzzeUelbVkkhT5HfnP9GpCo/TQT8+LKFhTaM3FK3tmOY4N6HjSbemDmBKn+jwQXN6zSpRPCsvzfR0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(30864003)(66946007)(86362001)(8936002)(4326008)(8676002)(66476007)(66556008)(83380400001)(6486002)(5660300002)(508600001)(6666004)(6916009)(26005)(186003)(6506007)(316002)(6512007)(9686003)(33716001)(38350700002)(53546011)(52116002)(38100700002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f+YllQSYPmctfG/7ezWk2/C0V31Dn0Zs9sa5XWkxkWsFFvkwtY07LwlDZPfC?=
 =?us-ascii?Q?OnzThdaz4uD+mBbU4Aa/oj+y5bX7DB2DxYdqglQzPjivBnCeW1JAfm1+JWof?=
 =?us-ascii?Q?nkAJH8ZRoouO2Yox1+C5tAdi4gMsZHxJ2ToFQ+dzm4x+GlI0uuFj3A+AjIpE?=
 =?us-ascii?Q?gWeoGe1lID1+qeUFwppvn4pONGZ1kPEdditS+ugbb8BBRwbPyOKvC94Tr8pT?=
 =?us-ascii?Q?UWllcYQEIr4p644pK9C87Qk9GR5qBtkSwRfv7XwV5EpmS3UW6qOLm/h9i8Vv?=
 =?us-ascii?Q?WUkk+QhcUh6soH6Is9U//wbz4a/U+dm6G9xftvXAVE1sEr6N1HTOw84j/IDk?=
 =?us-ascii?Q?oFNe7Y8IjlMCpfmeLvnnd8q/cRKoX3KEaMXyM+3QwX9RDvH6C/XoXBmidj9F?=
 =?us-ascii?Q?HPUgfkc/pqh8t6LH9VYbm0R4LAlmmCA2y84OmwdjQ/iHuDS76LfNQWjEQB8p?=
 =?us-ascii?Q?aGb8OXfOyv9O3v8Zf/ac/c8K6u+cs2IPu8nOasAzwF0IZ+KVkGYcwChNTxz2?=
 =?us-ascii?Q?3ugKVNscAZ2efe6w1WiEvWdgGT52wzcMK11Y9p3nQA9lpLeKzdylrTZEK2yV?=
 =?us-ascii?Q?GsOhEGexGJamBeQQfJZOfgQTl7K9tr7pFVjqfswveFwHM4J5n1vOmXEtj/Lo?=
 =?us-ascii?Q?6Q3qzgKdYq+pJOL3DHQbZTo9OLh4925AuEp+8Vg8fcPk/hrPL5x7q9XH70W4?=
 =?us-ascii?Q?0R/ptIe8Mooaed+IwEH43wSgJedcxja6T5VXMwKU6Bf1tI3p3TN0oD8ZLwtg?=
 =?us-ascii?Q?KvtzfjVe0m10R9rmMsGS7S9JLlmKchVOEpg6yIHx5TyhTAxcEd9AaOp3ASrJ?=
 =?us-ascii?Q?iTdBYHLMJwcLUcQfAUCxcYxlppJI3b82T0J+17x+gf7JAoYqxj4TnQGBTi/F?=
 =?us-ascii?Q?esY5bBhZj3RC6LJxhrfRJPLIWnGh5Q8Ssue0WCDELIG9opVDsQd94BpdFm+O?=
 =?us-ascii?Q?cGkhVh79uU917XLzzcblg+vPQG3qajy0vHgVulxKlMQLPZYE9UTtcbo6wsBF?=
 =?us-ascii?Q?/8V2GHYI7BGyPfXEe4isSycZ/227MaGPIs3KOdW1w4C6c24DctbhnfQIuilV?=
 =?us-ascii?Q?Px/cAjoulYvLTUq4btF4bGTOfSKVV7Q4PTuvia4iO55GmCLYBSMCMoULFzah?=
 =?us-ascii?Q?NGWcj/fUUURI8sCVVdg5bxnUqasMHHYls82CLjMqu0q4dADOq71mQB5ttUXu?=
 =?us-ascii?Q?oWgBxZ+SE98IpHuP7xiN9vU5BBnLwfu2u/IckC7SNPdAFaIOPfQU5qaxMhJW?=
 =?us-ascii?Q?krXOR71sXH0JRi9yg6ROFn9oTnW9eCXwR2KGAlQ4YDchqE9brRA6Xj+g4use?=
 =?us-ascii?Q?JD1ayZzEeqq7pybrZe/bLlDLRbr84i/5BpgKdpG9G50oK7U1nNjD/z8IwR1E?=
 =?us-ascii?Q?d7C6AgXQMXr4aVEYI9DmKJhmMZJczg42Hc+6k2yGNDq6HtkfvaTifqZD+LlH?=
 =?us-ascii?Q?pp4QQKALlnrzvzgr8PiajGmktS2k4lnvZb1Twqz/QOIrR6AUBXzs7InT5BSJ?=
 =?us-ascii?Q?YTdoc1O/2uw5Jvp2HlWEBZAyZIpQBMHz1WmEma+YjiPNTpeq4Eg6nCa262X+?=
 =?us-ascii?Q?7m4X3C1HVPFnag/WinJyZ3ChjXYgTCAVMumoqdDKXDIysWAxLz77RvQHqlPM?=
 =?us-ascii?Q?9uucPmJvcZJA+vaGLqcZ6/8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c2dd95a-0978-4f31-7109-08d9e9f60301
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 04:55:07.7537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IOztpGlKiwygwQg9FgKFz0vohlONdQAU8vMoiWqXSIKJcy/jHtmw8gEVeyQJYFQJk1zy9o2ZkODMWT+O1/tN7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4641
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10250 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 phishscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202070029
X-Proofpoint-ORIG-GUID: QNAprGa2zxercA_UcuzjLLvgcLTPvmpQ
X-Proofpoint-GUID: QNAprGa2zxercA_UcuzjLLvgcLTPvmpQ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 02 Feb 2022 at 00:40, Darrick J. Wong wrote:
> On Fri, Jan 21, 2022 at 10:48:53AM +0530, Chandan Babu R wrote:
>> This commit introduces new fields in the on-disk inode format to support
>> 64-bit data fork extent counters and 32-bit attribute fork extent
>> counters. The new fields will be used only when an inode has
>> XFS_DIFLAG2_NREXT64 flag set. Otherwise we continue to use the regular 32-bit
>> data fork extent counters and 16-bit attribute fork extent counters.
>> 
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> Suggested-by: Dave Chinner <dchinner@redhat.com>
>> ---
>>  fs/xfs/libxfs/xfs_format.h      | 22 +++++++--
>>  fs/xfs/libxfs/xfs_inode_buf.c   | 49 ++++++++++++++++++--
>>  fs/xfs/libxfs/xfs_inode_fork.h  |  6 +++
>>  fs/xfs/libxfs/xfs_log_format.h  | 22 +++++++--
>>  fs/xfs/xfs_inode_item.c         | 23 ++++++++--
>>  fs/xfs/xfs_inode_item_recover.c | 79 ++++++++++++++++++++++++++++-----
>>  6 files changed, 174 insertions(+), 27 deletions(-)
>> 
>> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
>> index d3dfd45c39e0..df1d6ec39c45 100644
>> --- a/fs/xfs/libxfs/xfs_format.h
>> +++ b/fs/xfs/libxfs/xfs_format.h
>> @@ -792,16 +792,30 @@ struct xfs_dinode {
>>  	__be32		di_nlink;	/* number of links to file */
>>  	__be16		di_projid_lo;	/* lower part of owner's project id */
>>  	__be16		di_projid_hi;	/* higher part owner's project id */
>> -	__u8		di_pad[6];	/* unused, zeroed space */
>> -	__be16		di_flushiter;	/* incremented on flush */
>> +	union {
>> +		__be64	di_big_nextents;/* NREXT64 data extents */
>> +		__u8	di_v3_pad[8];	/* !NREXT64 V3 inode zeroed space */
>> +		struct {
>> +			__u8	di_v2_pad[6];	/* V2 inode zeroed space */
>> +			__be16	di_flushiter;	/* V2 inode incremented on flush */
>> +		};
>> +	};
>
> I think it might be time to reflow part of the comments for these fields
> away from inline...
>
> 	union {
> 		/* Number of data fork extents if NREXT64 is set */
> 		__be64	di_big_nextents;
>
> 		/* Padding for V3 inodes without NREXT64 set. */
> 		__be64	di_v3_pad;
>
> 		/* Padding and inode flush counter for V2 inodes. */
> 		struct {
> 			__u8	di_v2_pad[6];
> 			__be16	di_flushiter;
> 		};
> 	};
>

Ok. I will include these changes in the next version.

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
>> +			__be32	di_big_anextents; /* NREXT64 attr extents */
>> +			__be16	di_nrext64_pad; /* NREXT64 unused, zero */
>> +		} __packed;
>> +		struct {
>> +			__be32	di_nextents;	/* !NREXT64 data extents */
>> +			__be16	di_anextents;	/* !NREXT64 attr extents */
>> +		} __packed;
>> +	};
>
>
> 	union {
> 		/*
> 		 * For V2 inodes and V3 inodes without NREXT64 set, this
> 		 * is the number of data and attr fork extents.
> 		 */
> 		struct {
> 			__be32	di_nextents;
> 			__be16	di_anextents;
> 		} __packed;
>
> 		/* Number of attr fork extents if NREXT64 is set. */
> 		struct {
> 			__be32	di_big_anextents;
> 			__be16	di_nrext64_pad;
> 		} __packed;
> 	} __packed;
>
>>  	__u8		di_forkoff;	/* attr fork offs, <<3 for 64b align */
>>  	__s8		di_aformat;	/* format of attr fork's data */
>>  	__be32		di_dmevmask;	/* DMIG event mask */
>> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
>> index 34f360a38603..2200526bcee0 100644
>> --- a/fs/xfs/libxfs/xfs_inode_buf.c
>> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
>> @@ -279,6 +279,25 @@ xfs_inode_to_disk_ts(
>>  	return ts;
>>  }
>>  
>> +static inline void
>> +xfs_inode_to_disk_iext_counters(
>> +	struct xfs_inode	*ip,
>> +	struct xfs_dinode	*to)
>> +{
>> +	if (xfs_inode_has_nrext64(ip)) {
>> +		to->di_big_nextents = cpu_to_be64(xfs_ifork_nextents(&ip->i_df));
>> +		to->di_big_anextents = cpu_to_be32(xfs_ifork_nextents(ip->i_afp));
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
>> @@ -296,7 +315,6 @@ xfs_inode_to_disk(
>>  	to->di_projid_lo = cpu_to_be16(ip->i_projid & 0xffff);
>>  	to->di_projid_hi = cpu_to_be16(ip->i_projid >> 16);
>>  
>> -	memset(to->di_pad, 0, sizeof(to->di_pad));
>>  	to->di_atime = xfs_inode_to_disk_ts(ip, inode->i_atime);
>>  	to->di_mtime = xfs_inode_to_disk_ts(ip, inode->i_mtime);
>>  	to->di_ctime = xfs_inode_to_disk_ts(ip, inode->i_ctime);
>> @@ -307,8 +325,6 @@ xfs_inode_to_disk(
>>  	to->di_size = cpu_to_be64(ip->i_disk_size);
>>  	to->di_nblocks = cpu_to_be64(ip->i_nblocks);
>>  	to->di_extsize = cpu_to_be32(ip->i_extsize);
>> -	to->di_nextents = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
>> -	to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
>>  	to->di_forkoff = ip->i_forkoff;
>>  	to->di_aformat = xfs_ifork_format(ip->i_afp);
>>  	to->di_flags = cpu_to_be16(ip->i_diflags);
>> @@ -323,11 +339,14 @@ xfs_inode_to_disk(
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
>> @@ -397,6 +416,24 @@ xfs_dinode_verify_forkoff(
>>  	return NULL;
>>  }
>>  
>> +static xfs_failaddr_t
>> +xfs_dinode_verify_nextents(
>> +	struct xfs_mount	*mp,
>> +	struct xfs_dinode	*dip)
>> +{
>> +	if (xfs_dinode_has_nrext64(dip)) {
>> +		if (!xfs_has_nrext64(mp))
>> +			return __this_address;
>> +		if (dip->di_nrext64_pad != 0)
>> +			return __this_address;
>
> Don't we need to check that:
>
> 		if (xfs_dfork_data_extents(dip) > XFS_MAX_EXTCNT_DATA_FORK)
> 			return __this_address;
> 		if (xfs_dfork_attr_extents(dip) > XFS_MAX_EXTCNT_ATTR_FORK)
> 			return __this_address;
>
> here?
>
> OH, the actual checking of the extent count fields is in
> xfs_dinode_verify_fork, isn't it?
>
> I think that means this function exists to check the consistency of the
> nrext64 inode flag vs. the superblock nrext64 flag and the padding
> fields, right?
>
> In which case... perhaps this should be xfs_dinode_verify_nrext64() ?
>

You are right. The name xfs_dinode_verify_nextents implies that we are
verifying the values of extent counters. I will fix this.

>> +	} else {
>> +		if (dip->di_version == 3 && dip->di_big_nextents != 0)
>> +			return __this_address;
>
> We're using tagged unions in xfs_dinode, then "di_big_nextents" is
> meaningless on an inode that doesn't have NREXT64 set.  IOWs,
>
> 	} else if (dip->di_version >= 3) {
> 		if (dip->di_v3_pad != 0)
> 			return __this_address;
> 	}
>
> (Note that I changed the type of di_v3_pad above.)
>

Thanks for the suggestion. I will fix this as well.

>> +	}
>> +
>> +	return NULL;
>> +}
>> +
>>  xfs_failaddr_t
>>  xfs_dinode_verify(
>>  	struct xfs_mount	*mp,
>> @@ -440,6 +477,10 @@ xfs_dinode_verify(
>>  	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
>>  		return __this_address;
>>  
>> +	fa = xfs_dinode_verify_nextents(mp, dip);
>> +	if (fa)
>> +		return fa;
>> +
>>  	nextents = xfs_dfork_data_extents(dip);
>>  	nextents += xfs_dfork_attr_extents(dip);
>>  	nblocks = be64_to_cpu(dip->di_nblocks);
>> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
>> index e56803436c61..8e6221e32660 100644
>> --- a/fs/xfs/libxfs/xfs_inode_fork.h
>> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
>> @@ -156,6 +156,9 @@ static inline xfs_extnum_t
>>  xfs_dfork_data_extents(
>>  	struct xfs_dinode	*dip)
>>  {
>> +	if (xfs_dinode_has_nrext64(dip))
>> +		return be64_to_cpu(dip->di_big_nextents);
>> +
>>  	return be32_to_cpu(dip->di_nextents);
>>  }
>>  
>> @@ -163,6 +166,9 @@ static inline xfs_extnum_t
>>  xfs_dfork_attr_extents(
>>  	struct xfs_dinode	*dip)
>>  {
>> +	if (xfs_dinode_has_nrext64(dip))
>> +		return be32_to_cpu(dip->di_big_anextents);
>> +
>>  	return be16_to_cpu(dip->di_anextents);
>>  }
>>  
>> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
>> index fd66e70248f7..7f4ebf112a3c 100644
>> --- a/fs/xfs/libxfs/xfs_log_format.h
>> +++ b/fs/xfs/libxfs/xfs_log_format.h
>> @@ -388,16 +388,30 @@ struct xfs_log_dinode {
>>  	uint32_t	di_nlink;	/* number of links to file */
>>  	uint16_t	di_projid_lo;	/* lower part of owner's project id */
>>  	uint16_t	di_projid_hi;	/* higher part of owner's project id */
>> -	uint8_t		di_pad[6];	/* unused, zeroed space */
>> -	uint16_t	di_flushiter;	/* incremented on flush */
>> +	union {
>> +		uint64_t	di_big_nextents;/* NREXT64 data extents */
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
>> +			uint32_t  di_big_anextents; /* NREXT64 attr extents */
>> +			uint16_t  di_nrext64_pad; /* NREXT64 unused, zero */
>> +		} __packed;
>> +		struct {
>> +			uint32_t  di_nextents;	  /* !NREXT64 data extents */
>> +			uint16_t  di_anextents;	  /* !NREXT64 attr extents */
>> +		} __packed;
>> +	};
>
> I think you could apply the same transformations as I did to xfs_dinode
> above.
>

Sure. I will make relevant changes to xfs_log_dinode.

> --D
>
>>  	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
>>  	int8_t		di_aformat;	/* format of attr fork's data */
>>  	uint32_t	di_dmevmask;	/* DMIG event mask */
>> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
>> index 90d8e591baf8..8304ce062e43 100644
>> --- a/fs/xfs/xfs_inode_item.c
>> +++ b/fs/xfs/xfs_inode_item.c
>> @@ -358,6 +358,21 @@ xfs_copy_dm_fields_to_log_dinode(
>>  	}
>>  }
>>  
>> +static inline void
>> +xfs_inode_to_log_dinode_iext_counters(
>> +	struct xfs_inode	*ip,
>> +	struct xfs_log_dinode	*to)
>> +{
>> +	if (xfs_inode_has_nrext64(ip)) {
>> +		to->di_big_nextents = xfs_ifork_nextents(&ip->i_df);
>> +		to->di_big_anextents = xfs_ifork_nextents(ip->i_afp);
>> +		to->di_nrext64_pad = 0;
>> +	} else {
>> +		to->di_nextents = xfs_ifork_nextents(&ip->i_df);
>> +		to->di_anextents = xfs_ifork_nextents(ip->i_afp);
>> +	}
>> +}
>> +
>>  static void
>>  xfs_inode_to_log_dinode(
>>  	struct xfs_inode	*ip,
>> @@ -373,7 +388,6 @@ xfs_inode_to_log_dinode(
>>  	to->di_projid_lo = ip->i_projid & 0xffff;
>>  	to->di_projid_hi = ip->i_projid >> 16;
>>  
>> -	memset(to->di_pad, 0, sizeof(to->di_pad));
>>  	memset(to->di_pad3, 0, sizeof(to->di_pad3));
>>  	to->di_atime = xfs_inode_to_log_dinode_ts(ip, inode->i_atime);
>>  	to->di_mtime = xfs_inode_to_log_dinode_ts(ip, inode->i_mtime);
>> @@ -385,8 +399,6 @@ xfs_inode_to_log_dinode(
>>  	to->di_size = ip->i_disk_size;
>>  	to->di_nblocks = ip->i_nblocks;
>>  	to->di_extsize = ip->i_extsize;
>> -	to->di_nextents = xfs_ifork_nextents(&ip->i_df);
>> -	to->di_anextents = xfs_ifork_nextents(ip->i_afp);
>>  	to->di_forkoff = ip->i_forkoff;
>>  	to->di_aformat = xfs_ifork_format(ip->i_afp);
>>  	to->di_flags = ip->i_diflags;
>> @@ -406,11 +418,14 @@ xfs_inode_to_log_dinode(
>>  		to->di_lsn = lsn;
>>  		memset(to->di_pad2, 0, sizeof(to->di_pad2));
>>  		uuid_copy(&to->di_uuid, &ip->i_mount->m_sb.sb_meta_uuid);
>> -		to->di_flushiter = 0;
>> +		memset(to->di_v3_pad, 0, sizeof(to->di_v3_pad));
>>  	} else {
>>  		to->di_version = 2;
>>  		to->di_flushiter = ip->i_flushiter;
>> +		memset(to->di_v2_pad, 0, sizeof(to->di_v2_pad));
>>  	}
>> +
>> +	xfs_inode_to_log_dinode_iext_counters(ip, to);
>>  }
>>  
>>  /*
>> diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
>> index 767a551816a0..fa3556633ca9 100644
>> --- a/fs/xfs/xfs_inode_item_recover.c
>> +++ b/fs/xfs/xfs_inode_item_recover.c
>> @@ -148,6 +148,22 @@ static inline bool xfs_log_dinode_has_nrext64(const struct xfs_log_dinode *ld)
>>  	       (ld->di_flags2 & XFS_DIFLAG2_NREXT64);
>>  }
>>  
>> +static inline void
>> +xfs_log_dinode_to_disk_iext_counters(
>> +	struct xfs_log_dinode	*from,
>> +	struct xfs_dinode	*to)
>> +{
>> +	if (xfs_log_dinode_has_nrext64(from)) {
>> +		to->di_big_nextents = cpu_to_be64(from->di_big_nextents);
>> +		to->di_big_anextents = cpu_to_be32(from->di_big_anextents);
>> +		to->di_nrext64_pad = cpu_to_be16(from->di_nrext64_pad);
>> +	} else {
>> +		to->di_nextents = cpu_to_be32(from->di_nextents);
>> +		to->di_anextents = cpu_to_be16(from->di_anextents);
>> +	}
>> +
>> +}
>> +
>>  STATIC void
>>  xfs_log_dinode_to_disk(
>>  	struct xfs_log_dinode	*from,
>> @@ -164,7 +180,6 @@ xfs_log_dinode_to_disk(
>>  	to->di_nlink = cpu_to_be32(from->di_nlink);
>>  	to->di_projid_lo = cpu_to_be16(from->di_projid_lo);
>>  	to->di_projid_hi = cpu_to_be16(from->di_projid_hi);
>> -	memcpy(to->di_pad, from->di_pad, sizeof(to->di_pad));
>>  
>>  	to->di_atime = xfs_log_dinode_to_disk_ts(from, from->di_atime);
>>  	to->di_mtime = xfs_log_dinode_to_disk_ts(from, from->di_mtime);
>> @@ -173,8 +188,6 @@ xfs_log_dinode_to_disk(
>>  	to->di_size = cpu_to_be64(from->di_size);
>>  	to->di_nblocks = cpu_to_be64(from->di_nblocks);
>>  	to->di_extsize = cpu_to_be32(from->di_extsize);
>> -	to->di_nextents = cpu_to_be32(from->di_nextents);
>> -	to->di_anextents = cpu_to_be16(from->di_anextents);
>>  	to->di_forkoff = from->di_forkoff;
>>  	to->di_aformat = from->di_aformat;
>>  	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
>> @@ -192,10 +205,13 @@ xfs_log_dinode_to_disk(
>>  		to->di_lsn = cpu_to_be64(lsn);
>>  		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
>>  		uuid_copy(&to->di_uuid, &from->di_uuid);
>> -		to->di_flushiter = 0;
>> +		memcpy(to->di_v3_pad, from->di_v3_pad, sizeof(to->di_v3_pad));
>>  	} else {
>>  		to->di_flushiter = cpu_to_be16(from->di_flushiter);
>> +		memcpy(to->di_v2_pad, from->di_v2_pad, sizeof(to->di_v2_pad));
>>  	}
>> +
>> +	xfs_log_dinode_to_disk_iext_counters(from, to);
>>  }
>>  
>>  STATIC int
>> @@ -209,6 +225,8 @@ xlog_recover_inode_commit_pass2(
>>  	struct xfs_mount		*mp = log->l_mp;
>>  	struct xfs_buf			*bp;
>>  	struct xfs_dinode		*dip;
>> +	xfs_extnum_t                    nextents;
>> +	xfs_aextnum_t                   anextents;
>>  	int				len;
>>  	char				*src;
>>  	char				*dest;
>> @@ -348,21 +366,60 @@ xlog_recover_inode_commit_pass2(
>>  			goto out_release;
>>  		}
>>  	}
>> -	if (unlikely(ldip->di_nextents + ldip->di_anextents > ldip->di_nblocks)){
>> -		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(5)",
>> +
>> +	if (xfs_log_dinode_has_nrext64(ldip)) {
>> +		if (!xfs_has_nrext64(mp) || (ldip->di_nrext64_pad != 0)) {
>> +			XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(5)",
>> +				     XFS_ERRLEVEL_LOW, mp, ldip,
>> +				     sizeof(*ldip));
>> +			xfs_alert(mp,
>> +				"%s: Bad inode log record, rec ptr "PTR_FMT", "
>> +				"dino ptr "PTR_FMT", dino bp "PTR_FMT", "
>> +				"ino %Ld, xfs_has_nrext64(mp) = %d, "
>> +				"ldip->di_nrext64_pad = %u",
>> +				__func__, item, dip, bp, in_f->ilf_ino,
>> +				xfs_has_nrext64(mp), ldip->di_nrext64_pad);
>> +			error = -EFSCORRUPTED;
>> +			goto out_release;
>> +		}
>> +	} else {
>> +		if (ldip->di_version == 3 && ldip->di_big_nextents != 0) {
>> +			XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(6)",
>> +				     XFS_ERRLEVEL_LOW, mp, ldip,
>> +				     sizeof(*ldip));
>> +			xfs_alert(mp,
>> +				"%s: Bad inode log record, rec ptr "PTR_FMT", "
>> +				"dino ptr "PTR_FMT", dino bp "PTR_FMT", "
>> +				"ino %Ld, ldip->di_big_dextcnt = %llu",
>> +				__func__, item, dip, bp, in_f->ilf_ino,
>> +				ldip->di_big_nextents);
>> +			error = -EFSCORRUPTED;
>> +			goto out_release;
>> +		}
>> +	}
>> +
>> +	if (xfs_log_dinode_has_nrext64(ldip)) {
>> +		nextents = ldip->di_big_nextents;
>> +		anextents = ldip->di_big_anextents;
>> +	} else {
>> +		nextents = ldip->di_nextents;
>> +		anextents = ldip->di_anextents;
>> +	}
>> +
>> +	if (unlikely(nextents + anextents > ldip->di_nblocks)) {
>> +		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(7)",
>>  				     XFS_ERRLEVEL_LOW, mp, ldip,
>>  				     sizeof(*ldip));
>>  		xfs_alert(mp,
>>  	"%s: Bad inode log record, rec ptr "PTR_FMT", dino ptr "PTR_FMT", "
>> -	"dino bp "PTR_FMT", ino %Ld, total extents = %d, nblocks = %Ld",
>> +	"dino bp "PTR_FMT", ino %Ld, total extents = %llu, nblocks = %Ld",
>>  			__func__, item, dip, bp, in_f->ilf_ino,
>> -			ldip->di_nextents + ldip->di_anextents,
>> -			ldip->di_nblocks);
>> +			nextents + anextents, ldip->di_nblocks);
>>  		error = -EFSCORRUPTED;
>>  		goto out_release;
>>  	}
>>  	if (unlikely(ldip->di_forkoff > mp->m_sb.sb_inodesize)) {
>> -		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(6)",
>> +		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(8)",
>>  				     XFS_ERRLEVEL_LOW, mp, ldip,
>>  				     sizeof(*ldip));
>>  		xfs_alert(mp,
>> @@ -374,7 +431,7 @@ xlog_recover_inode_commit_pass2(
>>  	}
>>  	isize = xfs_log_dinode_size(mp);
>>  	if (unlikely(item->ri_buf[1].i_len > isize)) {
>> -		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(7)",
>> +		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(9)",
>>  				     XFS_ERRLEVEL_LOW, mp, ldip,
>>  				     sizeof(*ldip));
>>  		xfs_alert(mp,
>> -- 
>> 2.30.2
>> 


-- 
chandan
