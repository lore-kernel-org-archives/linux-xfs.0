Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:3113 "EHLO
        ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727026AbeKQGvy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 17 Nov 2018 01:51:54 -0500
Date: Sat, 17 Nov 2018 07:37:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH] xfs: flush posteof zeroing before reflink truncation
Message-ID: <20181116203756.GF19305@dastard>
References: <20181116190724.GW4235@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181116190724.GW4235@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Fri, Nov 16, 2018 at 11:07:24AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If we're remapping into a range that starts beyond EOF, we have to zero
> the memory between EOF and the start of the target range, as established
> in 410fdc72b05af.  However, in 4918ef4ea008, we extended the pagecache
> truncation range downwards to a page boundary to guarantee that
> pagecache pages are removed and that there's no possibility that we end
> up zeroing subpage blocks within a page.  Unfortunately, we never commit
> the posteof zeroing to disk, so on a filesystem where page size > block
> size the truncation partially undoes the zeroing and we end up with
> stale disk contents.
> 
> Brian and I reproduced this problem by running generic/091 on a 1k block
> xfs filesystem, assuming fsx in fstests supports clone/dedupe/copyrange.
> 
> Fixes: 410fdc72b05a ("xfs: zero posteof blocks when cloning above eof")
> Fixes: 4918ef4ea008 ("xfs: fix pagecache truncation prior to reflink")
> Simultaneously-diagnosed-by: Brian Foster <bfoster@redhat.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Ok, I have a different fix for this again.

> ---
> Note: I haven't tested this thoroughly but wanted to push this out for
> everyone to look at ASAP.
> ---
>  fs/xfs/xfs_reflink.c |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index c56bdbfcf7ae..8ea09a7e550c 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1255,13 +1255,19 @@ xfs_reflink_zero_posteof(
>  	loff_t			pos)
>  {
>  	loff_t			isize = i_size_read(VFS_I(ip));
> +	int			error;
>  
>  	if (pos <= isize)
>  		return 0;
>  
>  	trace_xfs_zero_eof(ip, isize, pos - isize);
> -	return iomap_zero_range(VFS_I(ip), isize, pos - isize, NULL,
> +	error = iomap_zero_range(VFS_I(ip), isize, pos - isize, NULL,
>  			&xfs_iomap_ops);
> +	if (error)
> +		return error;
> +
> +	return filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
> +			isize, pos - 1);

This doesn't work on block size > page size setups, unfortunately.

Immediately after this we truncate the page cache, which also
doesn't do the right thing on block size > page cache setups.
So there's a couple of bugs here.

IMO, the truncate needs fixing, not the zeroing. Flushing after
zeroing leaves a potential landmine of other dirty data not getting
flushed properly before the truncate, so we should fix the truncate
to do a flush first. And we should fix it in a way that doesn't mean
we need to fix it again in the very near future. i.e. the patch
below that uses xfs_flush_unmap_range().

FWIW, I'm workng on cleaning up the ~10 patches I have for various
fsx and other corruption fixes so I can post them - it'll be monday
before I get that done - but if you're having fsx failures w/
copy/dedupe/clone on fsx I've probably already got a fix for it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


xfs: flush removing page cache in xfs_reflink_remap_prep

From: Dave Chinner <dchinner@redhat.com>

On a sub-page block size filesystem, fsx is failing with a data
corruption after a series of operations involving copying a file
with the destination offset beyond EOF of the destination of the file:

8093(157 mod 256): TRUNCATE DOWN        from 0x7a120 to 0x50000 ******WWWW
8094(158 mod 256): INSERT 0x25000 thru 0x25fff  (0x1000 bytes)
8095(159 mod 256): COPY 0x18000 thru 0x1afff    (0x3000 bytes) to 0x2f400
8096(160 mod 256): WRITE    0x5da00 thru 0x651ff        (0x7800 bytes) HOLE
8097(161 mod 256): COPY 0x2000 thru 0x5fff      (0x4000 bytes) to 0x6fc00

The second copy here is beyond EOF, and it is to sub-page (4k) but
block aligned (1k) offset. The clone runs the EOF zeroing, landing
in a pre-existing post-eof delalloc extent. This zeroes the post-eof
extents in the page cache just fine, dirtying the pages correctly.

The problem is that xfs_reflink_remap_prep() now truncates the page
cache over the range that it is copying it to, and rounds that down
to cover the entire start page. This removes the dirty page over the
delalloc extent from the page cache without having written it back.
Hence later, when the page cache is flushed, the page at offset
0x6f000 has not been written back and hence exposes stale data,
which fsx trips over less than 10 operations later.

Fix this by changing xfs_reflink_remap_prep() to use
xfs_flush_unmap_range().

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap_util.c | 2 +-
 fs/xfs/xfs_bmap_util.h | 3 +++
 fs/xfs/xfs_reflink.c   | 7 +++----
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index cc7a0d47c529..3e66cf0520a9 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1042,7 +1042,7 @@ xfs_unmap_extent(
 	goto out_unlock;
 }
 
-static int
+int
 xfs_flush_unmap_range(
 	struct xfs_inode	*ip,
 	xfs_off_t		offset,
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 87363d136bb6..7a78229cf1a7 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -80,4 +80,7 @@ int xfs_bmap_count_blocks(struct xfs_trans *tp, struct xfs_inode *ip,
 			  int whichfork, xfs_extnum_t *nextents,
 			  xfs_filblks_t *count);
 
+int	xfs_flush_unmap_range(struct xfs_inode *ip, xfs_off_t offset,
+			      xfs_off_t len);
+
 #endif	/* __XFS_BMAP_UTIL_H__ */
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index ecdb086bc23e..bd9135afe3f4 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1351,10 +1351,9 @@ xfs_reflink_remap_prep(
 	if (ret)
 		goto out_unlock;
 
-	/* Zap any page cache for the destination file's range. */
-	truncate_inode_pages_range(&inode_out->i_data,
-			round_down(pos_out, PAGE_SIZE),
-			round_up(pos_out + *len, PAGE_SIZE) - 1);
+	ret = xfs_flush_unmap_range(dest, pos_out, *len);
+	if (ret)
+		goto out_unlock;
 
 	return 1;
 out_unlock:
