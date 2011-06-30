Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5U2qglf166650 for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 21:52:42 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 30BA0178295D
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 19:52:41 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	x58s70uLgeLvs9dh for <xfs@oss.sgi.com>;
	Wed, 29 Jun 2011 19:52:41 -0700 (PDT)
Date: Thu, 30 Jun 2011 12:52:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 10/27] xfs: improve sync behaviour in the fact of
	aggressive dirtying
Message-ID: <20110630025211.GD561@dastard>
References: <20110629140109.003209430@bombadil.infradead.org>
	<20110629140338.467151398@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110629140338.467151398@bombadil.infradead.org>
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

On Wed, Jun 29, 2011 at 10:01:19AM -0400, Christoph Hellwig wrote:
> The following script from Wu Fengguang shows very bad behaviour in XFS
> when aggressively dirtying data during a sync on XFS, with sync times
> up to almost 10 times as long as ext4.
> 
> A large part of the issue is that XFS writes data out itself two times
> in the ->sync_fs method, overriding the lifelock protection in the core
> writeback code, and another issue is the lock-less xfs_ioend_wait call,
> which doesn't prevent new ioend from beeing queue up while waiting for
> the count to reach zero.
> 
> This patch removes the XFS-internal sync calls and relies on the VFS
> to do it's work just like all other filesystems do.  Note that the
> i_iocount wait which is rather suboptimal is simply removed here.
> We already do it in ->write_inode, which keeps the current supoptimal
> behaviour.  We'll eventually need to remove that as well, but that's
> material for a separate commit.
> 
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
> 
> Reported-by: Wu Fengguang <fengguang.wu@intel.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
