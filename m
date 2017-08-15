Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45599 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750924AbdHOELH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Aug 2017 00:11:07 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7F4B633005474
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 15 Aug 2017 04:11:07 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7F4B6fK005318
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 15 Aug 2017 04:11:06 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v7F4B5X4017707
        for <linux-xfs@vger.kernel.org>; Tue, 15 Aug 2017 04:11:06 GMT
Subject: Re: [RFC PATCH 13/13] Add the parent pointer support to the
 superblock version 5.
References: <1502329293-4091-1-git-send-email-allison.henderson@oracle.com>
 <1502329293-4091-14-git-send-email-allison.henderson@oracle.com>
 <20170815000741.GT4796@magnolia>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <60fdca27-5a86-2a46-ac43-08be5f545c32@oracle.com>
Date: Mon, 14 Aug 2017 21:11:04 -0700
MIME-Version: 1.0
In-Reply-To: <20170815000741.GT4796@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 08/14/2017 05:07 PM, Darrick J. Wong wrote:

> On Wed, Aug 09, 2017 at 06:41:33PM -0700, Allison Henderson wrote:
>> [dchinner: forward ported and cleaned up]
>> [achender: rebased and added parent pointer attribute to
>>             compatible attributes mask]
>>
>> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
>> Signed-off-by: Dave Chinner <dchinner@redhat.com>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>> :100644 100644 6cedd75... b00bf1d... M	fs/xfs/libxfs/xfs_format.h
>> :100644 100644 fba0105... a18dd0c... M	fs/xfs/libxfs/xfs_fs.h
>> :100644 100644 50fb3a2... d7b9010... M	fs/xfs/xfs_fsops.c
>>   fs/xfs/libxfs/xfs_format.h | 13 ++++++++-----
>>   fs/xfs/libxfs/xfs_fs.h     |  1 +
>>   fs/xfs/xfs_fsops.c         |  4 +++-
>>   3 files changed, 12 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
>> index 6cedd75..b00bf1d 100644
>> --- a/fs/xfs/libxfs/xfs_format.h
>> +++ b/fs/xfs/libxfs/xfs_format.h
>> @@ -464,10 +464,12 @@ xfs_sb_has_compat_feature(
>>   #define XFS_SB_FEAT_RO_COMPAT_FINOBT   (1 << 0)		/* free inode btree */
>>   #define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
>>   #define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/* reflinked files */
>> +#define XFS_SB_FEAT_RO_COMPAT_PARENT	(1 << 3)	/* parent inode ptr */
>>   #define XFS_SB_FEAT_RO_COMPAT_ALL \
>>   		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
>>   		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
>> -		 XFS_SB_FEAT_RO_COMPAT_REFLINK)
>> +		 XFS_SB_FEAT_RO_COMPAT_REFLINK| \
>> +		 XFS_SB_FEAT_RO_COMPAT_PARENT)
>>   #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
>>   static inline bool
>>   xfs_sb_has_ro_compat_feature(
>> @@ -507,17 +509,17 @@ xfs_sb_has_incompat_log_feature(
>>   /*
>>    * V5 superblock specific feature checks
>>    */
>> -static inline int xfs_sb_version_hascrc(struct xfs_sb *sbp)
>> +static inline bool xfs_sb_version_hascrc(struct xfs_sb *sbp)
>>   {
>>   	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
>>   }
>>   
>> -static inline int xfs_sb_version_has_pquotino(struct xfs_sb *sbp)
>> +static inline bool xfs_sb_version_has_pquotino(struct xfs_sb *sbp)
> Not part of parent pointers; if you want to fix this, do it in a separate
> patch, please.
>
> --D

Ok, will drop for now.  I may come back and get them later.  Thanks for 
the review!

Allison
>
>>   {
>>   	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
>>   }
>>   
>> -static inline int xfs_sb_version_hasftype(struct xfs_sb *sbp)
>> +static inline bool xfs_sb_version_hasftype(struct xfs_sb *sbp)
>>   {
>>   	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
>>   		xfs_sb_has_incompat_feature(sbp, XFS_SB_FEAT_INCOMPAT_FTYPE)) ||
>> @@ -563,7 +565,8 @@ static inline bool xfs_sb_version_hasreflink(struct xfs_sb *sbp)
>>   
>>   static inline bool xfs_sb_version_hasparent(struct xfs_sb *sbp)
>>   {
>> -	return false; /* We'll enable this at the end of the set */
>> +	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
>> +		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_PARENT));
>>   }
>>   
>>   /*
>> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
>> index fba0105..a18dd0c 100644
>> --- a/fs/xfs/libxfs/xfs_fs.h
>> +++ b/fs/xfs/libxfs/xfs_fs.h
>> @@ -222,6 +222,7 @@ typedef struct xfs_fsop_resblks {
>>   #define XFS_FSOP_GEOM_FLAGS_SPINODES	0x40000	/* sparse inode chunks	*/
>>   #define XFS_FSOP_GEOM_FLAGS_RMAPBT	0x80000	/* reverse mapping btree */
>>   #define XFS_FSOP_GEOM_FLAGS_REFLINK	0x100000 /* files can share blocks */
>> +#define XFS_FSOP_GEOM_FLAGS_PARENT	0x200000 /* parent pointers */
>>   
>>   /*
>>    * Minimum and maximum sizes need for growth checks.
>> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
>> index 50fb3a2..d7b9010 100644
>> --- a/fs/xfs/xfs_fsops.c
>> +++ b/fs/xfs/xfs_fsops.c
>> @@ -112,7 +112,9 @@ xfs_fs_geometry(
>>   			(xfs_sb_version_hasrmapbt(&mp->m_sb) ?
>>   				XFS_FSOP_GEOM_FLAGS_RMAPBT : 0) |
>>   			(xfs_sb_version_hasreflink(&mp->m_sb) ?
>> -				XFS_FSOP_GEOM_FLAGS_REFLINK : 0);
>> +				XFS_FSOP_GEOM_FLAGS_REFLINK : 0) |
>> +			(xfs_sb_version_hasparent(&mp->m_sb) ?
>> +				XFS_FSOP_GEOM_FLAGS_PARENT : 0);
>>   		geo->logsectsize = xfs_sb_version_hassector(&mp->m_sb) ?
>>   				mp->m_sb.sb_logsectsize : BBSIZE;
>>   		geo->rtsectsize = mp->m_sb.sb_blocksize;
>> -- 
>> 2.7.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

