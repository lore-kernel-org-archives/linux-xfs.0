Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qACMYNL2257256 for <xfs@oss.sgi.com>; Mon, 12 Nov 2012 16:34:23 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	T9xdAAwTPBIBn54w for <xfs@oss.sgi.com>;
	Mon, 12 Nov 2012 14:36:25 -0800 (PST)
Date: Tue, 13 Nov 2012 09:36:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Slow performance after ~4.5TB
Message-ID: <20121112223623.GV24575@dastard>
References: <50A0AFD5.2020607@iv.lt> <20121112090448.GS24575@dastard>
	<50A0C590.6020602@iv.lt> <20121112123222.GT24575@dastard>
	<50A10077.2060908@iv.lt>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50A10077.2060908@iv.lt>
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
To: Linas Jankauskas <linas.j@iv.lt>
Cc: xfs@oss.sgi.com

On Mon, Nov 12, 2012 at 03:58:15PM +0200, Linas Jankauskas wrote:
> Hi,
> 
> /dev is automaticaly mounted by automount and it is always equal to
> half physical memory.

Is it? It's not on my RHEL6.3 boxes - it's got a 10MB udev
filesystem mounted on /dev. Anyway, irrelelvant.

> RAID geometry:
>  Logical Drive: 1
>          Size: 20.0 TB
>          Fault Tolerance: RAID 5
...
>          Strip Size: 64 KB

Ok, so su=16, sw=11.

> Here is output of perf top:
> 
> 18.42%  [kernel]            [k] _spin_lock
>  16.07%  [xfs]               [k] xfs_alloc_busy_trim

Whoa, really?

>  10.46%  [xfs]               [k] xfs_alloc_get_rec
>   9.46%  [xfs]               [k] xfs_btree_get_rec
>   8.38%  [xfs]               [k] xfs_btree_increment
>   8.31%  [xfs]               [k] xfs_alloc_ag_vextent_near
>   6.82%  [xfs]               [k] xfs_btree_get_block
>   5.72%  [xfs]               [k] xfs_alloc_compute_aligned
>   4.01%  [xfs]               [k] xfs_btree_readahead
>   3.53%  [xfs]               [k] xfs_btree_rec_offset
>   2.92%  [xfs]               [k] xfs_btree_rec_addr
>   1.30%  [xfs]               [k] _xfs_buf_find

This looks like allocation of extents, not freeing of extents. Can
you attach the entire output?

> strace of rsync process:
> 
> % time     seconds  usecs/call     calls    errors syscall
> ------ ----------- ----------- --------- --------- ----------------
>  99.99   18.362863      165431       111           ftruncate

Which means this must be *extending* files. But an strace is not
what I need right now - the event trace via trace-cmd is what I need
to determine exactly what is happening.  Five seconds of tracing
output while this problem is happening is probably going to be
sufficient.

What I'd really like to know is what type of files you are rsyncing
to this box. can you post your typical rsync command? Are you
rsyncing over the top of existing files, or new copies? How big are
the files? are tehy sparse? what's a typical xfs_bmap -vp output on
one of these files that has taken this long to ftruncate?

Further, I need to know what free space looks like in your
filesystem. the output of something like:

for i in `seq 0 1 19`; do
	echo -s "\nagno: $i\n"
	xfs_db -r -c "freesp -s -a $i" /dev/sda5
done

and this:

xfs_db -r -c "frag" /dev/sda5

While give an indication of the state of freespace in the
filesystem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
