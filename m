Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5C2FD7F3F
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 14:14:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C3CABAC00B
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 12:14:42 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 92SpD94RyiyAsSwE for
	<xfs@oss.sgi.com>; Wed, 24 Jul 2013 12:14:41 -0700 (PDT)
Message-ID: <51F026DB.9020509@redhat.com>
Date: Wed, 24 Jul 2013 15:11:23 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH v5 6/7] xfs: add permission check to free eofblocks ioctl
References: <20130724005301.0ed718d2@oracle.com> <51EFE45F.4000801@redhat.com>
	<20130724122207.26792088@oracle.com>
In-Reply-To: <20130724122207.26792088@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dwight Engen <dwight.engen@oracle.com>
Cc: xfs@oss.sgi.com

On 07/24/2013 12:22 PM, Dwight Engen wrote:
> On Wed, 24 Jul 2013 10:27:43 -0400
> Brian Foster <bfoster@redhat.com> wrote:
> 
>> On 07/24/2013 12:53 AM, Dwight Engen wrote:
>>> We need to check that userspace callers can only truncate
>>> preallocated blocks from files they have write access to to prevent
>>> them from prematurley reclaiming blocks from another user. The
>>> internal reclaimer will not specify the XFS_EOF_FLAGS_PERM_CHECK
>>> flag, but userspace callers should.
>>>
>>> Add check for read-only filesystem to free eofblocks ioctl.
>>>
>>> Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
>>> ---
>>>  fs/xfs/xfs_fs.h     | 1 +
>>>  fs/xfs/xfs_icache.c | 4 ++++
>>>  fs/xfs/xfs_ioctl.c  | 4 ++++
>>>  3 files changed, 9 insertions(+)
>>>
>>> diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
>>> index 7eb4a5e..aee4b12 100644
>>> --- a/fs/xfs/xfs_fs.h
>>> +++ b/fs/xfs/xfs_fs.h
>>> @@ -361,6 +361,7 @@ struct xfs_fs_eofblocks {
>>>  #define XFS_EOF_FLAGS_GID		(1 << 2) /* filter by gid
>>> */ #define XFS_EOF_FLAGS_PRID		(1 << 3) /* filter by
>>> project id */ #define XFS_EOF_FLAGS_MINFILESIZE	(1 << 4) /*
>>> filter by min file size */ +#define XFS_EOF_FLAGS_PERM_CHECK
>>> (1 << 5) /* check can write inode */ #define
>>> XFS_EOF_FLAGS_VALID	\ (XFS_EOF_FLAGS_SYNC |	\
>>>  	 XFS_EOF_FLAGS_UID |	\
>>
>> We're not updating the VALID definition, which means the ioctl() would
>> fail if the caller sets this flag. I find that a little confusing
>> since we're effectively enforcing it. Given that the new flag would be
>> exported, it might be a better idea to add it to the valid definition
>> even though we don't require the caller to set it.
>>
>> An alternative might be to duplicate the set of flags in xfs_icache.h
>> and not export this one at all, but I don't know it's really worth
>> that.
> 
> I didn't put it in VALID because its really an internal flag, and we
> don't want userspace to think that we will honor them specifying it
> or not. ie. its not a valid bit for them to turn on. I agree it would be
> best not to export it though, how about if we move the definition to
> xfs_icache.h with a guard against someone accidentally adding a new
> duplicate bit in xfs_fs.h, like this:
> 
> #define XFS_EOF_FLAGS_PERM_CHECK        (1 << 5) /* check can write inode */
> #if XFS_EOF_FLAGS_PERM_CHECK & XFS_EOF_FLAGS_VALID
> #error "Internal XFS_EOF_FLAGS_PERM_CHECK duplicated bit from XFS_EOF_FLAGS_VALID"
> #endif
> 
> Maybe since this is internal we should also start at 1<<31 to allow
> room for exported flags to grow?

Fair enough. It sounds reasonable to me to start a separate, internal
only set of flags. I'm not sure if you're suggesting to only use the
msb, or start at the msb in decreasing fashion.

I was going to suggest reserving the last byte for internal flags or
perhaps use a u64 for the internal eofb flags and reserve bits 32-63 for
internal use (or just create another variable). I also think a slight
name change is useful to differentiate the internal flags. Perhaps
XFS_KEOF_*?

Brian

> 
>>> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
>>> index ed35584..823f2c0 100644
>>> --- a/fs/xfs/xfs_icache.c
>>> +++ b/fs/xfs/xfs_icache.c
>>> @@ -1247,6 +1247,10 @@ xfs_inode_free_eofblocks(
>>>  		if (!xfs_inode_match_id(ip, eofb))
>>>  			return 0;
>>>  
>>> +		if ((eofb->eof_flags & XFS_EOF_FLAGS_PERM_CHECK) &&
>>> +		    inode_permission(VFS_I(ip), MAY_WRITE))
>>> +			return 0;
>>> +
>>>  		/* skip the inode if the file size is too small */
>>>  		if (eofb->eof_flags & XFS_EOF_FLAGS_MINFILESIZE &&
>>>  		    XFS_ISIZE(ip) < eofb->eof_min_file_size)
>>> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
>>> index ecab261..c7cb632 100644
>>> --- a/fs/xfs/xfs_ioctl.c
>>> +++ b/fs/xfs/xfs_ioctl.c
>>> @@ -1613,6 +1613,9 @@ xfs_file_ioctl(
>>>  		struct xfs_fs_eofblocks eofb;
>>>  		struct xfs_eofblocks keofb;
>>>  
>>> +		if (IS_RDONLY(inode))
>>> +			return -XFS_ERROR(EROFS);
>>> +
>>>  		if (copy_from_user(&eofb, arg, sizeof(eofb)))
>>>  			return -XFS_ERROR(EFAULT);
>>>  
>>> @@ -1630,6 +1633,7 @@ xfs_file_ioctl(
>>>  		if (error)
>>>  			return -error;
>>>  
>>> +		keofb.eof_flags |= XFS_EOF_FLAGS_PERM_CHECK;
>>
>> And perhaps this should also be in the new helper..?
> 
> Okay, yep I can move this and the other struct xfs_fs_eofblocks checks
> you mentioned into the _from_user() helper.
> 
>> Brian
>>
>>>  		return -xfs_icache_free_eofblocks(mp, &keofb);
>>>  	}
>>>  
>>>
>>
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
