Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 025317F37
	for <xfs@oss.sgi.com>; Sun, 13 Sep 2015 18:58:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 696D3AC002
	for <xfs@oss.sgi.com>; Sun, 13 Sep 2015 16:58:42 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	rhCKeGMffRHrOBAw for <xfs@oss.sgi.com>;
	Sun, 13 Sep 2015 16:58:37 -0700 (PDT)
Date: Mon, 14 Sep 2015 09:58:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: add missing ilock around dio write last extent
	alignment
Message-ID: <20150913235835.GV26895@dastard>
References: <1441809812-60175-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1441809812-60175-1-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: David Jeffery <djeffery@redhat.com>, xfs@oss.sgi.com

On Wed, Sep 09, 2015 at 10:43:32AM -0400, Brian Foster wrote:
> The iomap codepath (via get_blocks()) acquires and release the inode
> lock in the case of a direct write that requires block allocation. This
> is because xfs_iomap_write_direct() allocates a transaction, which means
> the ilock must be dropped and reacquired after the transaction is
> allocated and reserved.
> 
> xfs_iomap_write_direct() invokes xfs_iomap_eof_align_last_fsb() before
> the transaction is created and thus before the ilock is reacquired. This
> can lead to calls to xfs_iread_extents() and reads of the in-core extent
> list without any synchronization (via xfs_bmap_eof() and
> xfs_bmap_last_extent()). xfs_iread_extents() assert fails if the ilock
> is not held, but this is not currently seen in practice as the current
> callers had already invoked xfs_bmapi_read().
> 
> What has been seen in practice are reports of crashes down in the
> xfs_bmap_eof() codepath on direct writes due to seemingly bogus pointer
> references from xfs_iext_get_ext(). While an explicit reproducer is not
> currently available to confirm the cause of the problem, crash analysis
> and code inspection from David Jeffrey had identified the insufficient
> locking.
> 
> xfs_iomap_eof_align_last_fsb() is called from other contexts with the
> inode lock already held. __xfs_get_blocks() acquires and drops the ilock
> with variable flags. Therefore, take the simple approach to cycle ilock
> around the last extent alignment call from xfs_iomap_write_direct().
> 
> Reported-by: David Jeffery <djeffery@redhat.com>
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_iomap.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 1f86033..4d7534e 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -142,7 +142,9 @@ xfs_iomap_write_direct(
>  	offset_fsb = XFS_B_TO_FSBT(mp, offset);
>  	last_fsb = XFS_B_TO_FSB(mp, ((xfs_ufsize_t)(offset + count)));
>  	if ((offset + count) > XFS_ISIZE(ip)) {
> +		xfs_ilock(ip, XFS_ILOCK_EXCL);
>  		error = xfs_iomap_eof_align_last_fsb(mp, ip, extsz, &last_fsb);
> +		xfs_iunlock(ip, XFS_ILOCK_EXCL);

XFS_ILOCK_SHARED?

Also, looking at __xfs_get_blocks(), we drop the ilock immediately
before calling xfs_iomap_write_direct(), which we already hold in
shared mode for the xfs_bmapi_read() for direct IO.

Can we push that lock dropping into xfs_iomap_write_direct() after
we've done the xfs_iomap_eof_align_last_fsb() call and before we do
transaction reservations so we don't need an extra lock round-trip
here? e.g. xfs_iomap_write_delay() is called under the lock context
held by __xfs_get_blocks()....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
