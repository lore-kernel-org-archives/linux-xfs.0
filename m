Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8SKfQou049291 for <xfs@oss.sgi.com>; Fri, 28 Sep 2012 15:41:26 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id m16ukbJs7gK7f0Fx for
	<xfs@oss.sgi.com>; Fri, 28 Sep 2012 13:42:46 -0700 (PDT)
Message-ID: <50660B65.6010204@redhat.com>
Date: Fri, 28 Sep 2012 16:41:09 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH v4 3/8] xfs: create helper to check whether to free
	eofblocks on inode
References: <1348767952-24229-1-git-send-email-bfoster@redhat.com>
	<1348767952-24229-4-git-send-email-bfoster@redhat.com>
	<20120928065917.GF25626@dastard>
In-Reply-To: <20120928065917.GF25626@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 09/28/2012 02:59 AM, Dave Chinner wrote:
> On Thu, Sep 27, 2012 at 01:45:47PM -0400, Brian Foster wrote:
>> This check is used in multiple places to determine whether we
>> should check for (and potentially free) post EOF blocks on an
>> inode. Add a helper to consolidate the check.
>>
>> Note that when we remove an inode from the cache (xfs_inactive()),
>> we are required to trim post-EOF blocks even if the inode is marked
>> preallocated or append-only to maintain correct space accounting.
>> The 'force' parameter to xfs_can_free_eofblocks() specifies whether
>> we should ignore the prealloc/append-only status of the inode.
>>
>> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ....
>> diff --git a/fs/xfs/xfs_vnodeops.h b/fs/xfs/xfs_vnodeops.h
>> index 447e146..d5701e3 100644
>> --- a/fs/xfs/xfs_vnodeops.h
>> +++ b/fs/xfs/xfs_vnodeops.h
>> @@ -1,6 +1,10 @@
>>  #ifndef _XFS_VNODEOPS_H
>>  #define _XFS_VNODEOPS_H 1
>>  
>> +#include "xfs_bmap_btree.h"
>> +#include "xfs_dinode.h"
>> +#include "xfs_inode.h"
>> +
>>  struct attrlist_cursor_kern;
>>  struct file;
>>  struct iattr;
> 
> Generally we try to avoid including XFS header files in XFS
> header files, and instead order the header files in the .c files
> appropriately.
> 

Ok, good to know. I'll try to clean that up.

>> @@ -9,8 +13,42 @@ struct iovec;
>>  struct kiocb;
>>  struct pipe_inode_info;
>>  struct uio;
>> -struct xfs_inode;
>>  
>> +/*
>> + * Test whether it is appropriate to check an inode for and free post EOF
>> + * blocks. The 'force' parameter determines whether we should also consider
>> + * regular files that are marked preallocated or append-only.
>> + */
>> +static inline bool
>> +xfs_can_free_eofblocks(struct xfs_inode *ip, bool force)
>> +{
>> +	/* prealloc/delalloc exists only on regular files */
>> +	if (!S_ISREG(ip->i_d.di_mode))
>> +		return false;
>> +
>> +	/*
>> +	 * Zero sized files with no cached pages and delalloc blocks will not
>> +	 * have speculative prealloc/delalloc blocks to remove.
>> +	 */
>> +	if (VFS_I(ip)->i_size == 0 &&
>> +	    VN_CACHED(VFS_I(ip)) == 0 &&
>> +	    ip->i_delayed_blks == 0)
>> +		return false;
>> +
>> +	/* If we haven't read in the extent list, then don't do it now. */
>> +	if (!(ip->i_df.if_flags & XFS_IFEXTENTS))
>> +		return false;
>> +
>> +	/*
>> +	 * Do not free real preallocated or append-only files unless the file
>> +	 * has delalloc blocks and we are forced to remove them.
>> +	 */
>> +	if (ip->i_d.di_flags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND))
>> +		if (!force || ip->i_delayed_blks == 0)
>> +			return false;
>> +
>> +	return true;
>> +}
> 
> And I'd say that function is too large for a static inline function
> in a header file, so moving it to xfs_inode.c is probably
> appropriate. I know, I asked you to write it like this, but
> not looking at it for a couple weeks brings new persepctive ;)
> 

No problem. I guess that takes care of the include problem. :)

Brian

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
