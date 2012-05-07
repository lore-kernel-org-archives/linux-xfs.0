Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q47NgkL3219512 for <xfs@oss.sgi.com>; Mon, 7 May 2012 18:42:46 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	uzbRthfxjvY9tAYM for <xfs@oss.sgi.com>;
	Mon, 07 May 2012 16:42:44 -0700 (PDT)
Date: Tue, 8 May 2012 09:42:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: suddenly slow writes on XFS Filesystem
Message-ID: <20120507234242.GC5091@dastard>
References: <4FA63DDA.9070707@profihost.ag> <20120507013456.GW5091@dastard>
	<4FA76E11.1070708@profihost.ag> <20120507071713.GZ5091@dastard>
	<4FA77842.5010703@profihost.ag>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FA77842.5010703@profihost.ag>
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
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: stan@hardwarefreak.com, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, May 07, 2012 at 09:22:42AM +0200, Stefan Priebe - Profihost AG wrote:
> 
> >> # vmstat
> > "vmstat 5", not vmstat 5 times....  :/
> oh sorry. Sadly the rsync processes do not run right know i've to kill
> them. Is the output still usable?
> # vmstat 5
> procs -----------memory---------- ---swap-- -----io---- -system--
> ----cpu----
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy
> id wa
>  0  1      0 5582136     48 5849956    0    0   176   394   34   54  1
> 16 82  1
>  0  1      0 5552180     48 5854280    0    0  2493  2496 3079 2172  1
> 4 86  9
>  3  2      0 5601308     48 5857672    0    0  1098 28043 5150 1913  0
> 10 73 17
>  0  2      0 5595360     48 5863180    0    0  1098 14336 3945 1897  0
> 8 69 22
>  3  2      0 5594088     48 5865280    0    0   432 15897 4209 2366  0
> 8 71 21
>  0  2      0 5591068     48 5868940    0    0   854 10989 3519 2107  0
> 7 70 23
>  1  1      0 5592004     48 5869872    0    0   180  7886 3605 2436  0
> 3 76 22

It tells me that there is still quite an IO load on the system even
when the rsyncs are not running...

> >> /dev/sdb1             4,6T  4,3T  310G  94% /mnt
> > Well, you've probably badly fragmented the free space you have. what
> > does the 'xfs_db -r -c freesp <dev>' command tell you?
> 
>    from      to extents  blocks    pct
>       1       1  942737  942737   0,87
>       2       3  671860 1590480   1,47
>       4       7  461268 2416025   2,23
>       8      15 1350517 18043063  16,67
>      16      31  111254 2547581   2,35
>      32      63  192032 9039799   8,35

So that's roughly 3.7 million free space extents of 256kB or less
totalling about 32% of the freespace (~100GB).  That's pretty badly
fragmented, and given the workload, probably unrecoverable. Dump,
mkfs and restore is probably the only way to unfragment the free
space now, but that would only be a temporary solution if you
continue to run at >90% full. Even if you do keep it at below 90%
full, such a workload will age the filesystem and slowly fragment
free space, but it should take a lot longer to get to this state...

> >>>> /dev/sdb1            4875737052 4659318044 216419008  96% /mnt
> >>> You have 4.6 *billion* inodes in your filesystem?
> >> Yes - it backups around 100 servers with a lot of files.
> i rechecked this and it seems i sadly copied the wrong output ;-( sorry
> for that.
> 
> Here is the correct one:
> #~ df -i
> /dev/sdb1            975173568 95212355 879961213   10% /mnt

That makes more sense. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
