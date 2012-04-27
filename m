Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3RDopJ8171389 for <xfs@oss.sgi.com>; Fri, 27 Apr 2012 08:50:51 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id pRjftpNC2K959XYu
	for <xfs@oss.sgi.com>; Fri, 27 Apr 2012 06:50:50 -0700 (PDT)
Message-ID: <4F9AA43A.1060509@hardwarefreak.com>
Date: Fri, 27 Apr 2012 08:50:50 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: A little RAID experiment
References: <CAAxjCEzh3+doupD=LmgqSbCeYWzn9Ru-vE4T8tOJmoud+28FDQ@mail.gmail.com>
In-Reply-To: <CAAxjCEzh3+doupD=LmgqSbCeYWzn9Ru-vE4T8tOJmoud+28FDQ@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
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

On 4/25/2012 3:07 AM, Stefan Ring wrote:
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
> From the other controller in this machine (RAID 1, SmartArray P410i,
> 2x 15k disks), I get:
> 
> Read 0b  Written 276.85Mb  Total transferred 276.85Mb  (18.447Mb/sec)
>  2361.21 Requests/sec executed
> 
> The better result might be caused by the better controller or the RAID
> 1, with the latter reason being more likely.

Stefan, you should be able to simply clear the P410i configuration in
the BIOS, power down, then simply connect the 6 drive backplane cable to
the 410i, load the config from the disks, and go.  This allows head to
head RAID6 comparison between the P400 and P410i.  No doubt the 410i
will be quicker.  This procedure will tell you how much quicker.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
