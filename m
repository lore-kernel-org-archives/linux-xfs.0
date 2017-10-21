Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41974 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753242AbdJUBNy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Oct 2017 21:13:54 -0400
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH 17/17] Add the parent pointer support to the superblock
 version 5.
References: <1508367333-3237-1-git-send-email-allison.henderson@oracle.com>
 <1508367333-3237-18-git-send-email-allison.henderson@oracle.com>
 <20171019194527.GK4755@magnolia>
Message-ID: <38f34ac4-7209-28b5-bee4-9c0f74bb05df@oracle.com>
Date: Fri, 20 Oct 2017 18:13:43 -0700
MIME-Version: 1.0
In-Reply-To: <20171019194527.GK4755@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
Cc: linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On 10/19/2017 12:45 PM, Darrick J. Wong wrote:
> On Wed, Oct 18, 2017 at 03:55:33PM -0700, Allison Henderson wrote:
>> [dchinner: forward ported and cleaned up]
>> [achender: rebased and added parent pointer attribute to
>>             compatible attributes mask]
>>
>> Signed-off-by: Mark Tinguely<tinguely@sgi.com>
>> Signed-off-by: Dave Chinner<dchinner@redhat.com>
>> Signed-off-by: Allison Henderson<allison.henderson@oracle.com>
>> ---
>> v2: remove unrelated type clean up in xfs_format.h
>>
>> Signed-off-by: Allison Henderson<allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_format.h | 7 +++++--
>>   fs/xfs/libxfs/xfs_fs.h     | 1 +
>>   fs/xfs/xfs_fsops.c         | 4 +++-
>>   3 files changed, 9 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
>> index 121862a..f3e3132 100644
>> --- a/fs/xfs/libxfs/xfs_format.h
>> +++ b/fs/xfs/libxfs/xfs_format.h
>> @@ -459,10 +459,12 @@ xfs_sb_has_compat_feature(
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
>> @@ -558,7 +560,8 @@ static inline bool xfs_sb_version_hasreflink(struct xfs_sb *sbp)
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
>> index 8c61f21..b8108f8 100644
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
>> index 8f22fc5..9a0ce52 100644
>> --- a/fs/xfs/xfs_fsops.c
>> +++ b/fs/xfs/xfs_fsops.c
>> @@ -111,7 +111,9 @@ xfs_fs_geometry(
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
> xfs_fs_fill_super ought to have a warning about parent pointers being
> experimental.
>
> --D
Sure, I will add a warning blurb in there
>> -- 
>> 2.7.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message tomajordomo@vger.kernel.org
>> More majordomo info athttp://vger.kernel.org/majordomo-info.html

