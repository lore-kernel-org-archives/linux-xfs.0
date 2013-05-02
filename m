Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C16037F54
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 02:58:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id ACD02304064
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 00:58:39 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	IjtudKaZUbxnCzFO for <xfs@oss.sgi.com>;
	Thu, 02 May 2013 00:58:38 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1UXoPU-0002Ek-Oz
	for xfs@oss.sgi.com; Thu, 02 May 2013 17:58:36 +1000
Date: Thu, 2 May 2013 17:58:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix sub-page blocksize data integrity writes
Message-ID: <20130502075836.GY10481@dastard>
References: <1367480709-23804-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1367480709-23804-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

On Thu, May 02, 2013 at 05:45:09PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> FSX on 512 byte block size filesystems has been failing for some
> time with corrupted data. The fault dates back to the change in
> the writeback data integrity algorithm that uses a mark-and-sweep
> approach to avoid data writeback livelocks.
.....
> +	 * time this will be the only page inteh file that needs writeback.
> +	 * Hence for more optimal IO patterns, we should always avoid partial
> +	 * page writeback due to multiple mappings on a page here.
> +	 */
> +	if (!xfs_imap_valid(inode, imap, end_offset))
> +		goto fail_unlock_page;
> +
>  	len = 1 << inode->i_blkbits;
>  	p_offset = min_t(unsigned long, end_offset & (PAGE_CACHE_SIZE - 1),
>  					PAGE_CACHE_SIZE);
>  	p_offset = p_offset ? roundup(p_offset, len) : PAGE_CACHE_SIZE;
>  	page_dirty = p_offset / len;
>  
> +

Oh, stray whitespace....

>  	bh = head = page_buffers(page);
>  	do {
>  		if (offset >= end_offset)
> diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
> index 1501f4f..0176bb2 100644
> --- a/fs/xfs/xfs_vnodeops.c
> +++ b/fs/xfs/xfs_vnodeops.c
> @@ -1453,7 +1453,7 @@ xfs_free_file_space(
>  	xfs_mount_t		*mp;
>  	int			nimap;
>  	uint			resblks;
> -	uint			rounding;
> +	xfs_off_t		rounding;
>  	int			rt;
>  	xfs_fileoff_t		startoffset_fsb;
>  	xfs_trans_t		*tp;
> @@ -1482,7 +1482,7 @@ xfs_free_file_space(
>  		inode_dio_wait(VFS_I(ip));
>  	}
>  
> -	rounding = max_t(uint, 1 << mp->m_sb.sb_blocklog, PAGE_CACHE_SIZE);
> +	rounding = max_t(xfs_off_t, 1 << mp->m_sb.sb_blocklog, PAGE_CACHE_SIZE);
>  	ioffset = offset & ~(rounding - 1);
>  	error = -filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
>  					      ioffset, -1);

And I forgot I had noticed a second problem while dealing with this
one (i.e. the rounding masks is wrong for offsets > 32 bits)....

I'll repost them both as separate patches.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
