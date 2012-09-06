Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q86EuEkO097110 for <xfs@oss.sgi.com>; Thu, 6 Sep 2012 09:56:14 -0500
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 54ViTVFWpmeZEI5C (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 06 Sep 2012 07:57:10 -0700 (PDT)
Date: Thu, 6 Sep 2012 16:57:08 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: xfs freeze annotation problem on 3.6.0-rc3+ kernel
Message-ID: <20120906145708.GB12539@quack.suse.cz>
References: <20120906063921.749a850a@corrin.poochiereds.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120906063921.749a850a@corrin.poochiereds.net>
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
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Thu 06-09-12 06:39:21, Jeff Layton wrote:
> I got the following xfs-related lockdep pop on a 3.6.0-rc3+ kernel. 
> I've been able to reproduce this twice now by doing a kernel build on
> xfs.
> 
> The last commit from Linus' tree in this kernel is 9acb172. It also has
> a pile of my own and Al Viro's patches on top, but I don't think any of
> them would affect this. I should be able to test patches for this if
> you come up with one, but since I've only seen it twice I'm not sure
> how reproducible it is yet.
> 
> [ 4175.887865] 
> [ 4175.888032] =========================================================
> [ 4175.888032] [ INFO: possible irq lock inversion dependency detected ]
> [ 4175.888032] 3.6.0-rc3+ #11 Not tainted
> [ 4175.888032] ---------------------------------------------------------
> [ 4175.888032] kswapd0/41 just changed the state of lock:
> [ 4175.888032]  (sb_internal){.+.+.?}, at: [<ffffffffa00f60ad>] xfs_trans_alloc+0x2d/0x50 [xfs]
> [ 4175.888032] but this lock took another, RECLAIM_FS-unsafe lock in the past:
> [ 4175.888032]  (&(&ip->i_lock)->mr_lock/1){+.+.+.}
> [ 4175.888032] 
> [ 4175.888032] and interrupts could create inverse lock ordering between them.
> [ 4175.888032] 
> [ 4175.888032] 
> [ 4175.888032] other info that might help us debug this:
> [ 4175.888032]  Possible interrupt unsafe locking scenario:
> [ 4175.888032] 
> [ 4175.888032]        CPU0                    CPU1
> [ 4175.888032]        ----                    ----
> [ 4175.888032]   lock(&(&ip->i_lock)->mr_lock/1);
> [ 4175.888032]                                local_irq_disable();
> [ 4175.888032]                                lock(sb_internal);
> [ 4175.888032]                                lock(&(&ip->i_lock)->mr_lock/1);
> [ 4175.888032]   <Interrupt>
> [ 4175.888032]     lock(sb_internal);
> [ 4175.888032] 
> [ 4175.888032]  *** DEADLOCK ***
  This is actually known and has nothing to do with fs freezeing AFAICT.
The problem is tham vm_map_ram() can do GFP_KERNEL allocation from deep
inside XFS and that can cause deadlocks...

It has been discussed here https://lkml.org/lkml/2012/6/13/582, but mm guys
have some issues with the simple solution.

								Honza

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
