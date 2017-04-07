Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48517 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933312AbdDGRgL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Apr 2017 13:36:11 -0400
Date: Fri, 7 Apr 2017 10:35:40 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: lockdep warning on 4.11.0-rc5 kernel
Message-ID: <20170407173540.GL4864@birch.djwong.org>
References: <20170405205211.GB4475@redhat.com>
 <20170407151009.GA55851@bfoster.bfoster>
 <20170407165843.GI4864@birch.djwong.org>
 <20170407172828.GB55851@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170407172828.GB55851@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-xfs@vger.kernel.org, hch@infradead.org

On Fri, Apr 07, 2017 at 01:28:31PM -0400, Brian Foster wrote:
> On Fri, Apr 07, 2017 at 09:58:43AM -0700, Darrick J. Wong wrote:
> > On Fri, Apr 07, 2017 at 11:10:09AM -0400, Brian Foster wrote:
> > > On Wed, Apr 05, 2017 at 04:52:11PM -0400, Vivek Goyal wrote:
> > > > Hi,
> > > > 
> > > > I am running 4.11.0-rc5 kernel and did a kernel build and noticed
> > > > following lockdep warning on console. Have not analyzed it. Lots of
> > > > xfs in backtrace, so sending it to xfs mailing list.
> > > > 
> > > 
> > > Darrick pointed out on irc yesterday that this is likely due to the
> > > lock_inode() call in chmod_common(). I was confused as to where the
> > > iolock came into play here, but apparently we now reuse the core
> > > inode->i_rwsem for that.
> > > 
> > > In any event, I was playing around with this and reproduce pretty easily
> > > by populating an fs with a bunch files with speculative preallocation
> > > and then generating some memory pressure. I reproduce with the following
> > > stack, however:
> > > 
> > > [  434.220605] =================================
> > > [  434.222286] [ INFO: inconsistent lock state ]
> > > [  434.224092] 4.11.0-rc4+ #36 Tainted: G           OE  
> > > [  434.225839] ---------------------------------
> > > [  434.227587] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W}
> > > usage.
> > > [  434.229995] kswapd0/59 [HC0[0]:SC0[0]:HE1:SE1] takes:
> > > [  434.231851]  (&sb->s_type->i_mutex_key#17){+.+.?.}, at:
> > > [<ffffffffc078e0aa>] xfs_ilock+0x20a/0x300 [xfs]
> > > [  434.235473] {RECLAIM_FS-ON-W} state was registered at:
> > > [  434.237427]   mark_held_locks+0x76/0xa0
> > > [  434.238840]   lockdep_trace_alloc+0x7d/0xe0
> > > [  434.240362]   kmem_cache_alloc+0x2f/0x2d0
> > > [  434.241871]   kmem_zone_alloc+0x81/0x120 [xfs]
> > > [  434.243559]   xfs_trans_alloc+0x6c/0x130 [xfs]
> > > [  434.245233]   xfs_vn_update_time+0x75/0x230 [xfs]
> > > [  434.247031]   file_update_time+0xbc/0x110
> > > [  434.248593]   xfs_file_aio_write_checks+0x19b/0x1c0 [xfs]
> > > [  434.250762]   xfs_file_buffered_aio_write+0x75/0x350 [xfs]
> > > [  434.252978]   xfs_file_write_iter+0x103/0x150 [xfs]
> > > [  434.254935]   __vfs_write+0xe8/0x160
> > > [  434.256325]   vfs_write+0xcb/0x1f0
> > > [  434.257625]   SyS_pwrite64+0x98/0xc0
> > > [  434.258963]   entry_SYSCALL_64_fastpath+0x1f/0xc2
> > > 
> > > ... so this isn't just a chmod thing. OTOH, I think we agree that this
> > > is not a real deadlock vector because the iolock is taken in the
> > > destroy_inode() path and so there should be no other reference to the
> > > inode.
> > > 
> > > That aside, the IOLOCK_EXCL was added to xfs_inactive() in commit
> > > a36b926180 ("xfs: pull up iolock from xfs_free_eofblocks()") purely to
> > > honor the cleaner call semantics that patch defined for
> > > xfs_free_eofblocks(). We could probably either drop the iolock from here
> > > (though we would then have to kill the assert in xfs_free_eofblocks()),
> > > or use something like the diff below that quiets the lockdep splat for
> > > me. Thoughts?
> > 
> > Well... the inode is inactive, which means there won't be any io to
> > protect ourselves against, so we don't need to take the iolock, right?
> > Why not remove the iolock grabbing and either change the iolock assert
> > in _free_eofblocks to detect that we're coming from _inactive and not
> > blow the assert, or just make a __xfs_free_eofblocks that skips the
> > assert.
> > 
> 
> Correct, the iolock is not necessary here and historically was not
> taken. It was added in the commit above to clean up the function, more
> specifically to support the assert. I'd rather not go and uglify the
> whole thing again (might as well just revert the patch in that case).
> 
> I guess we could just kill the assert then. How about the appended?

Looks reasonable.  Test, patchify, and send to list?

--D

> 
> Brian
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 4d1920e..de94798 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -903,9 +903,9 @@ xfs_can_free_eofblocks(struct xfs_inode *ip, bool force)
>  }
>  
>  /*
> - * This is called by xfs_inactive to free any blocks beyond eof
> - * when the link count isn't zero and by xfs_dm_punch_hole() when
> - * punching a hole to EOF.
> + * This is called to free any blocks beyond eof. The caller must hold
> + * IOLOCK_EXCL unless we are in the inode reclaim path and have the only
> + * reference to the inode.
>   */
>  int
>  xfs_free_eofblocks(
> @@ -920,8 +920,6 @@ xfs_free_eofblocks(
>  	struct xfs_bmbt_irec	imap;
>  	struct xfs_mount	*mp = ip->i_mount;
>  
> -	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
> -
>  	/*
>  	 * Figure out if there are any blocks beyond the end
>  	 * of the file.  If not, then there is nothing to do.
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 7605d83..e36c2c3 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1906,12 +1906,13 @@ xfs_inactive(
>  		 * force is true because we are evicting an inode from the
>  		 * cache. Post-eof blocks must be freed, lest we end up with
>  		 * broken free space accounting.
> +		 *
> +		 * Note: don't bother with iolock here since lockdep complains
> +		 * about acquiring it in reclaim context. We have the only
> +		 * reference to the inode at this point anyways.
>  		 */
> -		if (xfs_can_free_eofblocks(ip, true)) {
> -			xfs_ilock(ip, XFS_IOLOCK_EXCL);
> +		if (xfs_can_free_eofblocks(ip, true))
>  			xfs_free_eofblocks(ip);
> -			xfs_iunlock(ip, XFS_IOLOCK_EXCL);
> -		}
>  
>  		return;
>  	}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
