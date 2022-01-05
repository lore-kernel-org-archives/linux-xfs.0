Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32353C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Jan 2022 13:48:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240427AbiAENsM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Jan 2022 08:48:12 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:44766 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229601AbiAENsM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jan 2022 08:48:12 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 205D4MD2027777;
        Wed, 5 Jan 2022 13:48:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=aQlkDF9OLGaEwroE5fPL/KMvj1MawKkE+ie4oAjqyB0=;
 b=QZA76q/UU8lzjMGVIRSyRA1RWT1M/pNUA1govghu/+YF069sLBcH4ELWxtE8tEgWTTEE
 DEq4FURcKDOOc60jYSopvfgQ5VzMqM1Ylb+10b5u0z4if6X/ZeGxqTXYIMEXiITxpUSy
 5MxEM2EP4AUDyCOEXOJ1dG570/UVOlUWlvDnYMr4VBYqZLx00gFSWKRoBHNn0vLgLZFd
 fgO1tc7+tat6ri00VevI65vYibwx4N1a35dEbxkVYhG9kHt+6tNbXc0uamWpu+ECZf3+
 ly/6rmkaJnUvC1n3HkLXXHHafbmtsGamZqKIOjd/AClzA4xCY5VW8zL7iNpSroLpgZcj Xg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dc9d940a6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Jan 2022 13:48:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 205Djm74091179;
        Wed, 5 Jan 2022 13:48:05 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by userp3030.oracle.com with ESMTP id 3dac2ycyr2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Jan 2022 13:48:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QiyxwcEpUNLmoM+m5gu3Q/y70YD5aR5brgqSvqshY2M2Qtd2FiQFv/evim4ZVgPR54wyQhAvk6J658hzSzxnvAcDQATahOOeqryafH25We9Tkq7havfkEyRlZYlgyF+mOvqatTUXJPJvjY6cshuRh/HrAqdt9iAmdQekZJZpFXURASJiqoEFbBufK3xw+Z3EcsLeBuVMqIGDjOXeGu+wW/KsUNLeVabsKKRpW3DQzryR8AhC7esoqXYDuWRxaXG0eBkw7O7cZ8czi2HvfeBOP0Hw1F7Zp7V5kcU2Zy6RT5h5IlDkKMb/N8qHgW9ivyLkeKBBT2MxOpa9Gao8fb+QIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aQlkDF9OLGaEwroE5fPL/KMvj1MawKkE+ie4oAjqyB0=;
 b=XkjGZjyiESdp3kcu7kDKxu9R9oBXR/dJYYXR+jgoCak0M4K5tOHwlucrfyATX1VM5jfcYFA7MzaA06LPRz6QW0MQ1eAjd5I8WwR6K75+qQixp2ChnSntjlnMyqSTZWJk82ZUz7dEe5BUHqNpulRz8xjT38DyHxVajSTn7P5FFHL5zViWK+g8+Q4E8zGEg/19jaPTd8RcXJ71cM04Jbob7GEGvVjGKpOXDXn9GBC4zghM7Ri0RbU9djpjasEeXtJbZjwZ7CJRPSJ7YOBzfAQx+7NzXZjsHtZmk4djZywzFPsQlxZ2VN5hklQx+AocToEj6TjnqUMeqFecRYQuYPn5Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aQlkDF9OLGaEwroE5fPL/KMvj1MawKkE+ie4oAjqyB0=;
 b=LxSu/mA4zqxN04tKVntxCxYTsCEeUa9psmWbrubq0bYWpMpasJqiVusd0VXoIXcqlnuLg9nMnwU1tYdDBO0VB70yeNkOJKmYv1DdaCVDzGH9JhnzsS951mcMyyOhdD2GAYNmOQ1TbMxaLrsaM4AAv1RQojKgK6Im5RRMEvU+nWE=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2928.namprd10.prod.outlook.com (2603:10b6:805:d2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Wed, 5 Jan
 2022 13:48:02 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%7]) with mapi id 15.20.4867.009; Wed, 5 Jan 2022
 13:48:02 +0000
References: <20211214084519.759272-1-chandan.babu@oracle.com>
 <20211214084519.759272-13-chandan.babu@oracle.com>
 <20220105010415.GH31606@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH V4 12/16] xfs: Introduce per-inode 64-bit extent counters
In-reply-to: <20220105010415.GH31606@magnolia>
Message-ID: <87sfu28fav.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Wed, 05 Jan 2022 19:17:52 +0530
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0145.jpnprd01.prod.outlook.com
 (2603:1096:404:7e::13) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21f8e1de-467b-4610-9040-08d9d051fd7b
X-MS-TrafficTypeDiagnostic: SN6PR10MB2928:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB2928BFDF1D244282D63C8215F64B9@SN6PR10MB2928.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:164;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dYVN11wNgCmPIwbZaHmX/WJazYT3OKnuXw5lBt7IDbPHY9WyDcEDM0iwVfLDggfLHeJSqL1LFYccbI57AOnGtV+rTZRriqOolTMASGkysXv5ha/+IrbMoYb9gpdBat16KNOSzpKd7ZIRVGhDwITP11RjKKj4d3C6/QWKBETnj/D9kLL4UzFHQijXuIIjBe836vQPDbKqkTLW7y3ntPNoYehnRBgfrcQ8STi3hPPbw/Gj3rZconw4hm7mx6EzMz/Er6QjYQG3J9Asz1vqm+cdxTQa0eEnhpTB7LAD7RI/b1QEGg1Vn//IAfv/OASdhBWv5CWYq+h4B8jVRmREjstzvwZatlPRC9mmonablfvg+13WI5EC54m0mgRB0sz+YzFccmwVDEghhJW2yOJIrpu1RB2fjUMsbMFNMgzn77iM+P6wI6glWMaa+R+tHAjsfJ2Kh/reXtOGiv47YfAYmNMCt6okfJ+fu5bYeL0dBj3tWUUs7142id02k/tK6EaW1CeHCzM4lraaNyK+h1J5d6T9uCl/chlBRHTP5LtM8uwt+MuOdpMNYcS6gDVbbXpIW1gJxpykzMLAMSoPxuweHRp7MunE18sAh2B8RWRLioftEe6h9pUHVa3izGSBNE6fnWW7MFUrPrYx4ysbLZvAzSkNVytNgz8rBxWliZks28CCD7g6/KvPykU1oOPTOLxeSGUli8RvX08EgsY3ufJ/UBmxJs0xMaGjfMDmHNq9EfM57N8delUeZpRYzE75pGt9WMXQa8t9/M278Okip6K3iftgNt65CBZPQzFjDSMclG0Zu8Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(83380400001)(33716001)(5660300002)(4326008)(508600001)(66556008)(6916009)(2906002)(186003)(52116002)(26005)(6486002)(53546011)(86362001)(6666004)(38100700002)(38350700002)(6506007)(9686003)(6512007)(316002)(66946007)(8676002)(30864003)(8936002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/X5Z556bic8NbbmEtxtXOftBj7Ufg7F4RZgHQABSaZda0oNcJjyYfPPi6mPT?=
 =?us-ascii?Q?uNUG8d+NiUpg/XlAarXsHXTlf42st6hqNpmWp3+srFcPVzCFfJX/x4caC6Dd?=
 =?us-ascii?Q?wPfLLL1cGbTobL06pMh+PC/a7I5xFSVUsmP8W4an4vgAo6DuMU1+fqVAIT1t?=
 =?us-ascii?Q?WTg5VXc7PCSIhkd9RQKKEr1FnXbeMxAt9oEipiRWxiQdVDZIkdf5kYvWVEGc?=
 =?us-ascii?Q?QzyVSmMReKxwutKpHZrdQqDaZgvJ/QlKMe+5zA/TQIJcpJOlXw1E7zEGe5rE?=
 =?us-ascii?Q?pM+xXDSl0prUOzn90awG9E9tug+/ie+QmaoLRJy0pi9wz6lu3aXG3sFN00v/?=
 =?us-ascii?Q?wfVeH+nooK/ehcGpkOZo2SSG/I3TWL37Fyka6oXDcteVqVDgazfw0EeN7HvC?=
 =?us-ascii?Q?xq4MzrwteSMhDplYf1jcgOJjCVtn9llxLqU1DtavTw2XrfVg4e+f721KwYjM?=
 =?us-ascii?Q?xT/gDJGpl/zIR9r8w5u292RQODDiE0TIHZOzvd/xMLW9qASpnnCc1iBf1Z+i?=
 =?us-ascii?Q?RoQG6R3x5Wv8v+gVmfEOQihs2UX0Nb/3TSpRYcNVnkQUYEkM9X16hAcKQ4nh?=
 =?us-ascii?Q?BtwVF1u5sJUlKVfIAn3YtFckXPxPpcHXqpFo2Hd72IoO+Dq1dN0ex0b2r8F3?=
 =?us-ascii?Q?9CRI9csJwDQ1wHi6q2WJDULvW4v7fgjPud9/3XYR5FaV6JsMpdVG2OUshngm?=
 =?us-ascii?Q?H9avVrzGBzcQH7Z8yXmjxpQm/Q3mkJNo1pD6pQSXUxEIMc4XU+9A/0EJn8/x?=
 =?us-ascii?Q?7JLMc0804g7Im7uVzwCoP8ImdpbJ2iSlGvv27l3Hr2U1RVY0d+ETWGCCuVv7?=
 =?us-ascii?Q?QoITcJg+AU5MaN7YPQ9iIOEB4EgBWy5+BIhSPPnq8uQGrFo+yuHgG6DAYCij?=
 =?us-ascii?Q?MrBsdCj9j5IhRPlptODpoG18PhV2Dk1eZnZpCbDrdLOnzaR8OlFg6X3YXP/D?=
 =?us-ascii?Q?9Pz/fSpwg+S6lm8Kzyf5Qj6s6ktYdDCgPjskR1BspL1O6v0z+IeABnbY+8wW?=
 =?us-ascii?Q?gUkMMs+2bmzYFKv31UdDlOZKZNGU36mhVDfcRDFk90yVOgZnBkB6xE7YIgkg?=
 =?us-ascii?Q?4AsgusD0wuoe8ESMluTYOssmd3FFEkiU67t3cOknnb5MXklsYzJAN//1gE1N?=
 =?us-ascii?Q?d2HMGXi5SErjNASkYGEnfctgxaePrhJIz4ex2Ivx2VVTDJWNeSHneJAvaFga?=
 =?us-ascii?Q?spRTlJVSSesc1zNpBGGaD/dVKtsGTNglFq2pZLq0d2kr04AxfODkR8+7jH9X?=
 =?us-ascii?Q?LK2MWLog2x+OeQRJ8V+jAFkoJvsOcFeIJNdSOOOz9NpGJaqa2H8ds56HDH8g?=
 =?us-ascii?Q?1BTse9TzuPtdWVeog10ZqWCKPQtqN8LlkRisugrzfX9Cso3rnTYDNfwvRrLb?=
 =?us-ascii?Q?kEkmL0OqIe+tEGoZPheuScpACbLRAayueE3V2pk3YKiM0CPVA8LxXFRkOu0B?=
 =?us-ascii?Q?Q2Fk6j4bBN3L0FeaVfqY1g7DNEVY9SxrbTv+nmhgKvq/ipRSZOygtiyvqH4D?=
 =?us-ascii?Q?wlxmZBAiZIM3f/xgIAQaMT8ByPZ9jzvXmC4GunQys84gIKQWGNw24tnT4lHh?=
 =?us-ascii?Q?FWpbRIgiIbKqehx03OqCkzb1N17m4gqSv3CzUuVvwH7IuT2myn4WaPbBS6jg?=
 =?us-ascii?Q?oG6DeziO7txnDSHw6wcnwXU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21f8e1de-467b-4610-9040-08d9d051fd7b
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 13:48:02.0864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CMNZVRm5YsS0CbV8bfMDmWcs3/G4hXD0HZ8MIbV05wkJ8+/YKl86q+8NPVY3gUfHnDYHv+OH6YYlRQj44xTgSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2928
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10217 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 spamscore=0 phishscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201050092
X-Proofpoint-ORIG-GUID: -Ma7JfJQnTY6fuFNwDXmtO0lDkb5dM3g
X-Proofpoint-GUID: -Ma7JfJQnTY6fuFNwDXmtO0lDkb5dM3g
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 05 Jan 2022 at 06:34, Darrick J. Wong wrote:
> On Tue, Dec 14, 2021 at 02:15:15PM +0530, Chandan Babu R wrote:
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
>>  fs/xfs/libxfs/xfs_inode_fork.h  | 10 ++++-
>>  fs/xfs/libxfs/xfs_log_format.h  | 22 +++++++--
>>  fs/xfs/xfs_inode_item.c         | 23 ++++++++--
>>  fs/xfs/xfs_inode_item_recover.c | 79 ++++++++++++++++++++++++++++-----
>>  6 files changed, 176 insertions(+), 29 deletions(-)
>> 
>> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
>> index eff86f6c4c99..2868cec1154d 100644
>> --- a/fs/xfs/libxfs/xfs_format.h
>> +++ b/fs/xfs/libxfs/xfs_format.h
>> @@ -792,16 +792,30 @@ struct xfs_dinode {
>>  	__be32		di_nlink;	/* number of links to file */
>>  	__be16		di_projid_lo;	/* lower part of owner's project id */
>>  	__be16		di_projid_hi;	/* higher part owner's project id */
>> -	__u8		di_pad[6];	/* unused, zeroed space */
>> -	__be16		di_flushiter;	/* incremented on flush */
>> +	union {
>> +		__be64	di_big_dextcnt;	/* NREXT64 data extents */
>
> Hm.  I was expecting "__be64 di_big_nextents" and "__be32
> di_big_naextents" but I'm not sure if you're just following what Dave
> suggested back in September or if there's a reason to deviate?
>

Yes, I have followed what Dave had suggested. But I think di_big_n[a]extents
field names are consistent with the existing extent counter field names. I
will fix this up too.

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
>> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
>> index 34f360a38603..fe21e9808f80 100644
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
>> +		to->di_big_dextcnt = cpu_to_be64(xfs_ifork_nextents(&ip->i_df));
>> +		to->di_big_aextcnt = cpu_to_be32(xfs_ifork_nextents(ip->i_afp));
>> +		/*
>> +		 * We might be upgrading the inode to use larger extent counters
>> +		 * than was previously used. Hence zero the unused field.
>> +		 */
>> +		to->di_nrext64_pad = cpu_to_be16(0);
>
> If you upgrade the inode to DIFLAG_NREXT64 in xfs_trans_log_inode, won't
> zeroing xfs_log_dinode.di_nrext64_pad also clean out the xfs_dinode
> field?
>

In the event where the log tail gets unpinned the corresponding inode item
gets pushed (via xfs_inode_item_push()), the incore inode's contents are then
written to the disk by xfs_inode_to_disk(). At this instance, the ondisk inode
can have a non-zero value at xfs_dinode->di_nrext64_pad since this field maps
to the older 16-bit attr fork extent counter. Hence this field has to be
zeroed out.

> For that matter, what /was/ the resolution of the discussion about how
> log recovery should work w.r.t. changing the nrext64 inode flag?  I
> thought that the inode/transaction LSN checks during recovery suffice to
> prevent recovery of pre-change values into a post-change ondisk inode?
>

Yes, The current inode recovery mechanism does prevent overwriting areas of an
upgraded ondisk inode with values from fields belonging to a non-upgraded log
dinode.

The following code snippet from xlog_recover_inode_commit_pass2() skips replay
of xfs_log_dinode entries when ondisk inode's LSN is greater than checkpoint
transaction's LSN,

        if (dip->di_version >= 3) {
                xfs_lsn_t       lsn = be64_to_cpu(dip->di_lsn);

                if (lsn && lsn != -1 && XFS_LSN_CMP(lsn, current_lsn) > 0) {
                        trace_xfs_log_recover_inode_skip(log, in_f);
                        error = 0;
                        goto out_owner_change;
                }
        }


And as Dave had clarified earlier
(https://lore.kernel.org/all/20210916100647.176018-7-chandan.babu@oracle.com/T/#m7b43e474e8473b03cc03e884f23aa173e539a60c),
in the event that we have three checkpoint transactions having the same LSN
with the 3rd one setting DIFLAG_NREXT64 flag, The inode can have inconsistent
data after the 1st and the 2nd transactions are replayed. But we are assured
of the inode returning to its consistent state since the 3rd transaction is
guaranteed to be replayed. However, This scenario should not occur since we
now set DIFLAG_NREXT64 during xfs_inode_from_disk().

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
>> +	} else {
>> +		if (dip->di_version == 3 && dip->di_big_dextcnt != 0)
>> +			return __this_address;
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
>> index 0cfc351648f9..fa5143fb889b 100644
>> --- a/fs/xfs/libxfs/xfs_inode_fork.h
>> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
>> @@ -156,14 +156,20 @@ static inline xfs_extnum_t
>>  xfs_dfork_data_extents(
>>  	struct xfs_dinode	*dip)
>>  {
>> -	return be32_to_cpu(dip->di_nextents);
>> +	if (xfs_dinode_has_nrext64(dip))
>> +		return be64_to_cpu(dip->di_big_dextcnt);
>> +	else
>> +		return be32_to_cpu(dip->di_nextents);
>
> No need for the else in these helpers.
>

Ok. I will fix this.

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
>> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
>> index fd66e70248f7..46aed637c98b 100644
>> --- a/fs/xfs/libxfs/xfs_log_format.h
>> +++ b/fs/xfs/libxfs/xfs_log_format.h
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
>> +			uint32_t  di_nextents;	  /* !NREXT64 data extents */
>> +			uint16_t  di_anextents;	  /* !NREXT64 attr extents */
>> +		} __packed;
>> +	};
>>  	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
>>  	int8_t		di_aformat;	/* format of attr fork's data */
>>  	uint32_t	di_dmevmask;	/* DMIG event mask */
>> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
>> index 90d8e591baf8..82f4b9bb871b 100644
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
>> +		to->di_big_dextcnt = xfs_ifork_nextents(&ip->i_df);
>> +		to->di_big_aextcnt = xfs_ifork_nextents(ip->i_afp);
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
>> index 767a551816a0..7434ad4772dc 100644
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
>> +		to->di_big_dextcnt = cpu_to_be64(from->di_big_dextcnt);
>> +		to->di_big_aextcnt = cpu_to_be32(from->di_big_aextcnt);
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
>> +		if (ldip->di_version == 3 && ldip->di_big_dextcnt != 0) {
>> +			XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(6)",
>> +				     XFS_ERRLEVEL_LOW, mp, ldip,
>> +				     sizeof(*ldip));
>> +			xfs_alert(mp,
>> +				"%s: Bad inode log record, rec ptr "PTR_FMT", "
>> +				"dino ptr "PTR_FMT", dino bp "PTR_FMT", "
>> +				"ino %Ld, ldip->di_big_dextcnt = %llu",
>> +				__func__, item, dip, bp, in_f->ilf_ino,
>> +				ldip->di_big_dextcnt);
>> +			error = -EFSCORRUPTED;
>> +			goto out_release;
>> +		}
>> +	}
>> +
>> +	if (xfs_log_dinode_has_nrext64(ldip)) {
>> +		nextents = ldip->di_big_dextcnt;
>> +		anextents = ldip->di_big_aextcnt;
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
