Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8SKflqf049376 for <xfs@oss.sgi.com>; Fri, 28 Sep 2012 15:41:48 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id qYZvn4T5xDlDFmj2 for
	<xfs@oss.sgi.com>; Fri, 28 Sep 2012 13:43:08 -0700 (PDT)
Message-ID: <50660B7B.7030905@redhat.com>
Date: Fri, 28 Sep 2012 16:41:31 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH v4 5/8] xfs: create function to scan and clear EOFBLOCKS
	inodes
References: <1348767952-24229-1-git-send-email-bfoster@redhat.com>
	<1348767952-24229-6-git-send-email-bfoster@redhat.com>
	<20120928072103.GJ25626@dastard>
In-Reply-To: <20120928072103.GJ25626@dastard>
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

On 09/28/2012 03:21 AM, Dave Chinner wrote:
> On Thu, Sep 27, 2012 at 01:45:49PM -0400, Brian Foster wrote:
>> xfs_inodes_free_eofblocks() implements scanning functionality for
>> EOFBLOCKS inodes. It uses the AG iterator to walk the tagged inodes
>> and free post-EOF blocks via the xfs_inode_free_eofblocks() execute
>> function. The scan can be invoked in best-effort mode or wait
>> (force) mode.
>>
>> A best-effort scan (default) handles all inodes that do not have a
>> dirty cache and we successfully acquire the io lock via trylock. In
>> wait mode, we continue to cycle through an AG until all inodes are
>> handled.
>>
>> Signed-off-by: Brian Foster <bfoster@redhat.com>
> 
> xfs_icache.c rebase, and...
> 
>> ---
>>  fs/xfs/xfs_sync.c  |   40 ++++++++++++++++++++++++++++++++++++++++
>>  fs/xfs/xfs_sync.h  |    1 +
>>  fs/xfs/xfs_trace.h |    1 +
>>  3 files changed, 42 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_sync.c b/fs/xfs/xfs_sync.c
>> index 0da93c9..6854800 100644
>> --- a/fs/xfs/xfs_sync.c
>> +++ b/fs/xfs/xfs_sync.c
>> @@ -1014,6 +1014,46 @@ xfs_reclaim_inodes_count(
>>  	return reclaimable;
>>  }
>>  
>> +STATIC int
>> +xfs_inode_free_eofblocks(
>> +	struct xfs_inode	*ip,
>> +	struct xfs_perag	*pag,
>> +	int			flags,
>> +	void			*args)
>> +{
>> +	int ret;
>> +	bool force = flags & SYNC_WAIT;
>> +
>> +	if (!xfs_can_free_eofblocks(ip, false)) {
>> +		/* inode could be preallocated or append-only */
>> +		trace_xfs_inode_free_eofblocks_invalid(ip);
>> +		xfs_inode_clear_eofblocks_tag(ip);
>> +		return 0;
>> +	}
>> +
>> +	if (!force && mapping_tagged(VFS_I(ip)->i_mapping,
>> +				     PAGECACHE_TAG_DIRTY))
>> +		return 0;
> 
> This reads rather strangely. I'd prefer that you don't use a "force"
> variable because we're not really "forcing" anything. SYNC_WAIT is
> telling us if we should block (wait) or not. i.e.
> 
> 	/*
> 	 * if the mapping is dirty the operation can block and wait
> 	 * for some time. So unless we are waiting, skip it.
> 	 */
> 	if (!(flags & SYNC_WAIT) &&
> 	    (mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_DIRTY)) 
> 		return 0;
> 
> makes more sense and is consistent with xfs_reclaim_inode() usage.
> 

Fair enough. I was thinking of the "force" scan mode as I called it, but
as you point out in the next patch that's inconsistently named as well.
Will fix.

>> +	ret = xfs_free_eofblocks(ip->i_mount, ip, true);
>> +
>> +	/* ignore EAGAIN on a best effort scan */
>> +	if (!force && (ret == EAGAIN))
>> +		ret = 0;
> 
> 	/* don't revisit the inode if we not waiting */
> 	if (ret == EAGAIN && !(flags & SYNC_WAIT))
> 		return 0;
> 	return ret;
>> +
>> +	return ret;
>> +}
>> +
>> +int
>> +xfs_inodes_free_eofblocks(
>> +	struct xfs_mount	*mp,
>> +	int			flags)
>> +{
>> +	ASSERT((flags & ~(SYNC_TRYLOCK|SYNC_WAIT)) == 0);
>> +	return xfs_inode_ag_iterator_tag(mp, xfs_inode_free_eofblocks, flags,
>> +					 NULL, XFS_ICI_EOFBLOCKS_TAG);
>> +}
> 
> TWo functions very similarly named. Perhaps the latter would be
> better named xfs_icache_free_eofblocks() to indicate it is an inode
> cache operation, rather than an inode operation.
> 

Ok, so correct me if I misread your comment. xfs_inodes_free_eofblocks()
goes to xfs_icache_free_eofblocks() and xfs_inode_free_eofblocks()
remains as is.

> Then at some point in another patch set we can rename
> xfs_reclaim_inodes* to xfs_icache_reclaim_* and
> xfs_inode_ag_iterator* to xfs_icache_iterator* and so one so that
> there is a clear naming difference between operations on the inode
> cache and individual inodes...
> 

Sounds logical.

Brian

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
