Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0AEB929DFB
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 21:25:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DAEEB8F8040
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 19:25:23 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Njcb8BoBVRERA9vm for <xfs@oss.sgi.com>;
	Thu, 01 Aug 2013 19:25:22 -0700 (PDT)
Date: Fri, 2 Aug 2013 12:25:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Performance decrease over time
Message-ID: <20130802022518.GZ7118@dastard>
References: <20130801202108.GA355@x4>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130801202108.GA355@x4>
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
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: xfs@oss.sgi.com

On Thu, Aug 01, 2013 at 10:21:08PM +0200, Markus Trippelsdorf wrote:
> Yesterday I noticed that the nightly rsync run that backups my root
> fs took over 8 minutes to complete. Half a year ago when the backup disk
> was freshly formated it only took 2 minutes. (The size of my root fs stayed
> constant during this time).
> 
> So I decided to reformat the drive, but first took some measurements.
> The drive in question also contains my film and music collection,
> several git trees and is used to compile projects quite often.

So, lots of static files mixed in with lots of temporary files and
small changing files. And heavy usage. Sounds like a pretty normal
case for slowly fragmenting free space as data of different temporal
locality slowly intermingles....

> Model Family:     Seagate Barracuda Green (AF)
> Device Model:     ST1500DL003-9VT16L

So, slow rotation speed, and an average seek time of 13ms? Given the
track-to-track seek times of 1ms, that means worst case seek times
are going to be in the order of 25ms. IOWs, you're using close to
the slowest disk on the market, and so seeks are going to have an
abnormally high impact on performance.

Oh, and the disk has a 64MB cache on board, so the test file size
you are using of 100MB will mostly fit in the cache....

> /dev/sdb on /var type xfs (rw,relatime,attr2,inode64,logbsize=256k,noquota)
> /dev/sdb       xfs       1.4T  702G  695G  51% /var
> 
>  # xfs_db -c frag -r /dev/sdb
> actual 1540833, ideal 1529956, fragmentation factor 0.71%
> 
> # iozone -I -a -s 100M -r 4k -r 64k -r 512k -i 0 -i 1 -i 2
>         Iozone: Performance Test of File I/O
>                 Version $Revision: 3.408 $
>                 Compiled for 64 bit mode.
>                 Build: linux-AMD64 
> ...
>         Run began: Thu Aug  1 12:55:09 2013
> 
>         O_DIRECT feature enabled
>         Auto Mode
>         File size set to 102400 KB
>         Record Size 4 KB
>         Record Size 64 KB
>         Record Size 512 KB
>         Command line used: iozone -I -a -s 100M -r 4k -r 64k -r 512k -i 0 -i 1 -i 2
>         Output is in Kbytes/sec
>         Time Resolution = 0.000001 seconds.
>         Processor cache size set to 1024 Kbytes.
>         Processor cache line size set to 32 bytes.
>         File stride size set to 17 * record size.
>                                                             random  random    bkwd   record   stride                                   
>               KB  reclen   write rewrite    read    reread    read   write    read  rewrite     read   fwrite frewrite   fread  freread
>           102400       4    8083    9218     3817     3786     515     789                                                          

4k single threaded direct IO can do 8MB/s on a spinning disk? I
think you are hitting the disk cache with these tests, and so they
aren't really representative of application performance at all.
All these numbers reflect is how contiguous the files are on disk.

>           102400      64   56905   48177    17239    26347    7381   15643                                                          
>           102400     512  113689   86344    84583    83192   37136   63275                                                          
> 
> After fresh format and restore from another backup, performance is much
> better again:
> 
> # iozone -I -a -s 100M -r 4k -r 64k -r 512k -i 0 -i 1 -i 2
>                                                             random  random    bkwd   record   stride                                   
>               KB  reclen   write rewrite    read    reread    read   write    read  rewrite     read   fwrite frewrite   fread  freread
>           102400       4   13923   18760    19461    27305     761     652                                                          
>           102400      64   95822   95724    82331    90763   10455   11944                                                          
>           102400     512   93343   95386    94504    95073   43282   69179 
> 
> Couple of questions. Is it normal that throughput decreases this much in
> half a year on a heavily used disk that is only half full?

The process you went through will have completely defragmented your
filesystem, and so now IOZone will be operating on completely
contiguous files and hence getting more disk cache hits.

So really, the numbers only reflect a difference in layout of the
files being tested. And using small direct IO means that the
filesystem will tend to fill small free spaces close to the
inode first, and so will fragment the file based on the locality of
fragmented free space to the owner inode. In the case of the new
filesystem, there is only large, contiguous free space near the
inode....

So, what you are seeing is typical for a heavily used filesystem,
and it's probably more significant for you because of the type of
drive you are using....

> What can be
> done (as a user) to mitigate this effect? 

Buy faster disks ;)

Seriously, all filesystems age and get significantly slower as they
get used. XFS is not really designed for single spindles - it's
algorithms are designed to spread data out over the entire device
and so be able to make use of many, many spindles that make up the
device. The behaviour it has works extremely well for this sort of
large scale scenario, but it's close to the worst case aging
behaviour for a single, very slow spindle like you are using.  Hence
once the filesystem is over the "we have pristine, contiguous
freespace" hump on your hardware, it's all downhill and there's not
much you can do about it....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
