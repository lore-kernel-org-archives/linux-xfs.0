Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p65MaJjK044722 for <xfs@oss.sgi.com>; Tue, 5 Jul 2011 17:36:19 -0500
Subject: Re: [PATCH 08/27] xfs: improve sync behaviour in the fact of
	aggressive dirtying
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110701094603.789209280@bombadil.infradead.org>
References: <20110701094321.936534538@bombadil.infradead.org>
	<20110701094603.789209280@bombadil.infradead.org>
Date: Tue, 5 Jul 2011 17:36:18 -0500
Message-ID: <1309905378.1950.50.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, 2011-07-01 at 05:43 -0400, Christoph Hellwig wrote:
> The following script from Wu Fengguang shows very bad behaviour in XFS
> when aggressively dirtying data during a sync on XFS, with sync times
> up to almost 10 times as long as ext4.

(Note that I skipped over patch 7 for the time being,
trying to skip ahead to simpler changes to review.)

I think the change looks fine but the description doesn't
completely match it (unless I'm missing something).

> A large part of the issue is that XFS writes data out itself two times
> in the ->sync_fs method, overriding the lifelock protection in the core
> writeback code, and another issue is the lock-less xfs_ioend_wait call,
> which doesn't prevent new ioend from beeing queue up while waiting for
> the count to reach zero.

The change affects only the first thing you mention here, not
the second.

Also, if you plan to update the description--some typo's:
- "in the face of" in the subject
- "livelock protection" above
- "beeing" -> "being"


> This patch removes the XFS-internal sync calls and relies on the VFS
> to do it's work just like all other filesystems do.  Note that the
> i_iocount wait which is rather suboptimal is simply removed here.
> We already do it in ->write_inode, which keeps the current supoptimal
> behaviour.  We'll eventually need to remove that as well, but that's
> material for a separate commit.

The i_iocount wait is not affected by your patch.

> ------------------------------ snip ------------------------------
> #!/bin/sh
> 
> umount /dev/sda7
> mkfs.xfs -f /dev/sda7
> # mkfs.ext4 /dev/sda7
> # mkfs.btrfs /dev/sda7
> mount /dev/sda7 /fs
> 
> echo $((50<<20)) > /proc/sys/vm/dirty_bytes
> 
> pid=
> for i in `seq 10`
> do
> 	dd if=/dev/zero of=/fs/zero-$i bs=1M count=1000 &
> 	pid="$pid $!"
> done
> 
> sleep 1
> 
> tic=$(date +'%s')
> sync
> tac=$(date +'%s')
> 
> echo
> echo sync time: $((tac-tic))
> egrep '(Dirty|Writeback|NFS_Unstable)' /proc/meminfo
> 
> pidof dd > /dev/null && { kill -9 $pid; echo sync NOT livelocked; }
> ------------------------------ snip ------------------------------
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reported-by: Wu Fengguang <fengguang.wu@intel.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

I'm OK with the change, but really prefer to have
the description not include stuff that just isn't
there.  If you want me to commit this as-is, just
say so and I will.  Otherwise, post an update and
I'll use that.  In any case, you can consider this
reviewed by me.

Reviewed-by: Alex Elder <aelder@sgi.com>


> Index: xfs/fs/xfs/linux-2.6/xfs_sync.c
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_sync.c	2011-06-29 11:26:14.109219361 +0200
> +++ xfs/fs/xfs/linux-2.6/xfs_sync.c	2011-06-29 11:37:20.642275110 +0200
> @@ -359,14 +359,12 @@ xfs_quiesce_data(
>  {
>  	int			error, error2 = 0;
>  
> -	/* push non-blocking */
> -	xfs_sync_data(mp, 0);
>  	xfs_qm_sync(mp, SYNC_TRYLOCK);
> -
> -	/* push and block till complete */
> -	xfs_sync_data(mp, SYNC_WAIT);
>  	xfs_qm_sync(mp, SYNC_WAIT);
>  
> +	/* force out the newly dirtied log buffers */
> +	xfs_log_force(mp, XFS_LOG_SYNC);
> +
>  	/* write superblock and hoover up shutdown errors */
>  	error = xfs_sync_fsdata(mp);
>  
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
