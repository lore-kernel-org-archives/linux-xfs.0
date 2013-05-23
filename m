Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0B91A7F37
	for <xfs@oss.sgi.com>; Thu, 23 May 2013 01:38:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D25648F8033
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 23:38:42 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	trJtAwhyIQAOoj6U for <xfs@oss.sgi.com>;
	Wed, 22 May 2013 23:38:37 -0700 (PDT)
Date: Thu, 23 May 2013 16:38:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Lockdep message on 3.9.3 (already fixed?)...
Message-ID: <20130523063834.GZ24543@dastard>
References: <519B9EF5.5060809@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <519B9EF5.5060809@gmail.com>
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
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, May 21, 2013 at 12:21:09PM -0400, Michael L. Semon wrote:
> Hi!  I'm beginning to lose track of lockdep messages and feel like a
> new message is sneaking in there.
> 
> This lockdep comes from kernel 3.9.3, which I was asked to use in
> order to gather DRM info.  The PC was booted to a console and left
> to do a long 24kB/s download and default distro cron duties (slocate
> and such), in hopes that console inactivity, console blanking, and
> monitor sleep would kick up a soft oops from DRM like it does on
> 3.10.0-rc.
> 
> This may also apply to the devel kernels, but the PC needs to be
> left alone for me to verify this.
> 
> I've read the Dave Chinner position on stable kernels but don't know
> if they apply to the first stable kernel out of
> mainline...especially because that kernel has a lifespan of a
> housefly nowadays...
> 
> As always, thanks for reading!
> 
> Michael
> 
> =================================
> [ INFO: inconsistent lock state ]
> 3.9.3 #1 Not tainted
> ---------------------------------
> inconsistent {RECLAIM_FS-ON-R} -> {IN-RECLAIM_FS-W} usage.
> kswapd0/18 [HC0[0]:SC0[0]:HE1:SE1] takes:
>  (&(&ip->i_lock)->mr_lock){++++-?}, at: [<c120e2ea>] xfs_ilock+0xff/0x15e
> {RECLAIM_FS-ON-R} state was registered at:
>   [<c10638e7>] mark_held_locks+0x80/0xcb
>   [<c1063e18>] lockdep_trace_alloc+0x59/0x9d
>   [<c10a9846>] __alloc_pages_nodemask+0x70/0x6f2
>   [<c10a9ee4>] __get_free_pages+0x1c/0x3d
>   [<c1025644>] pte_alloc_one_kernel+0x14/0x16
>   [<c10beb1b>] __pte_alloc_kernel+0x16/0x71
>   [<c10c8380>] vmap_page_range_noflush+0x12e/0x13c
>   [<c10c9480>] vm_map_ram+0x3b9/0x46c
>   [<c11c0739>] _xfs_buf_map_pages+0x5b/0xe7
>   [<c11c1372>] xfs_buf_get_map+0x67/0x13a
>   [<c11c1ff2>] xfs_buf_read_map+0x1f/0xc0
>   [<c11c20da>] xfs_buf_readahead_map+0x47/0x57
>   [<c11ffc18>] xfs_da_reada_buf+0xaf/0xbd
>   [<c120276c>] xfs_dir2_data_readahead+0x2f/0x36

Known issue. vm_map_ram() won't let us pass GFP_NOFS, so it does
GFP_KERNEL allocations in places that cause lockdep to go nuts. This
one here is not going to deadlock, but there are other cases where
it potentially could...

The VM folk refuse to allow us to pass gfp flags, so we're stuck
we're stuck with this lockdep noise.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
