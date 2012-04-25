Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3PEKHKl203749 for <xfs@oss.sgi.com>; Wed, 25 Apr 2012 09:20:17 -0500
Received: from b.mx.filmlight.ltd.uk (b.mx.filmlight.ltd.uk [77.107.81.251])
	by cuda.sgi.com with SMTP id A7WJ0kiZYcwTNlt2 for
	<xfs@oss.sgi.com>; Wed, 25 Apr 2012 07:20:16 -0700 (PDT)
Subject: Re: A little RAID experiment
From: Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <CAAxjCEzh3+doupD=LmgqSbCeYWzn9Ru-vE4T8tOJmoud+28FDQ@mail.gmail.com>
References: <CAAxjCEzh3+doupD=LmgqSbCeYWzn9Ru-vE4T8tOJmoud+28FDQ@mail.gmail.com>
Date: Wed, 25 Apr 2012 15:17:03 +0100
Message-Id: <1335363423.4586.431.camel@montana.filmlight.ltd.uk>
Mime-Version: 1.0
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
To: Stefan Ring <stefanrin@gmail.com>
Cc: Linux fs XFS <xfs@oss.sgi.com>

I've tried this on a system with two x 3ware (lsi) 9750-16i4e each
having 12 x Hitachi Deskstar 1TB disks formatted as raid 6; the two
hardware raids combined as a software raid 0 [*].

xfs formatted and mounted with 'noatime,noalign,nobarrier'.

Result (seems reasonably consistent):

Operations performed:  0 Read, 127458 Write, 0 Other = 127458 Total
Read 0b  Written 995.77Mb  Total transferred 995.77Mb  (66.337Mb/sec)
 8491.11 Requests/sec executed]

This with CentOS 5.8 kernel. Note that the 17TB volume is 92% full.

# xfs_bmap test_file.0 
test_file.0:
        0: [0..4963295]: 21324666648..21329629943
        1: [4963296..9919871]: 22779572824..22784529399
        2: [9919872..14871367]: 22769382704..22774334199
        3: [14871368..16777215]: 22767476856..22769382703

--
Roger

[*] actually a variation of raid 0 which distributes the blocks in a
pattern which compensates for the units being much faster at their edge
than at their center, to give a flatter performance curve.


On Wed, 2012-04-25 at 10:07 +0200, Stefan Ring wrote:
> This grew out of the discussion in my other thread ("Abysmal write
> performance because of excessive seeking (allocation groups to
> blame?)") -- that should in fact have been called "Free space
> fragmentation causes excessive seeks".
> 
> Could someone with a good hardware RAID (5 or 6, but also mirrored
> setups would be interesting) please conduct a little experiment for
> me?
> 
> I've put up a modified sysbench here:
> <https://github.com/Ringdingcoder/sysbench>. This tries to simulate
> the write pattern I've seen with XFS. It would be really interesting
> to know how different RAID controllers cope with this.
> 
> - Checkout (or download tarball):
> https://github.com/Ringdingcoder/sysbench/tarball/master
> - ./configure --without-mysql && make
> - fallocate -l 8g test_file.0
> - ./sysbench/sysbench --test=fileio --max-time=15
> --max-requests=10000000 --file-num=1 --file-extra-flags=direct
> --file-total-size=8G --file-block-size=8192 --file-fsync-all=off
> --file-fsync-freq=0 --file-fsync-mode=fdatasync --num-threads=1
> --file-test-mode=ag4 run
> 
> If you don't have fallocate, you can also use the last line with "run"
> replaced by "prepare" to create the file. Run the benchmark a few
> times to check if the numbers are somewhat stable. When doing a few
> runs in direct succession, the first one will likely be faster because
> the cache has not been loaded up yet. The interesting part of the
> output is this:
> 
> Read 0b  Written 64.516Mb  Total transferred 64.516Mb  (4.301Mb/sec)
>   550.53 Requests/sec executed
> 
> That's a measurement from my troubled RAID 6 volume (SmartArray P400,
> 6x 10k disks).
> 
> >From the other controller in this machine (RAID 1, SmartArray P410i,
> 2x 15k disks), I get:
> 
> Read 0b  Written 276.85Mb  Total transferred 276.85Mb  (18.447Mb/sec)
>  2361.21 Requests/sec executed
> 
> The better result might be caused by the better controller or the RAID
> 1, with the latter reason being more likely.
> 
> Regards,
> Stefan
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 
-- 
Roger Willcocks <roger@filmlight.ltd.uk>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
