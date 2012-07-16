Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6GJv8LB011011 for <xfs@oss.sgi.com>; Mon, 16 Jul 2012 14:57:09 -0500
Received: from mail-gh0-f181.google.com (mail-gh0-f181.google.com
	[209.85.160.181]) by cuda.sgi.com with ESMTP id
	MGyXN2GWqbGXRKV9 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 16 Jul 2012 12:57:07 -0700 (PDT)
Received: by ghbz13 with SMTP id z13so6955223ghb.26
	for <xfs@oss.sgi.com>; Mon, 16 Jul 2012 12:57:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAxjCEzh3+doupD=LmgqSbCeYWzn9Ru-vE4T8tOJmoud+28FDQ@mail.gmail.com>
References: <CAAxjCEzh3+doupD=LmgqSbCeYWzn9Ru-vE4T8tOJmoud+28FDQ@mail.gmail.com>
Date: Mon, 16 Jul 2012 21:57:06 +0200
Message-ID: <CAAxjCEzEiXv5Kna9zxZ-ePbhNg6nfRinkU=PCuyX3QHesq5qcg@mail.gmail.com>
Subject: Re: A little RAID experiment
From: Stefan Ring <stefanrin@gmail.com>
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
To: Linux fs XFS <xfs@oss.sgi.com>

On Wed, Apr 25, 2012 at 10:07 AM, Stefan Ring <stefanrin@gmail.com> wrote:
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

In the meantime, the very useful --report-interval switch has been
added to development versions of sysbench, and I've had access to one
additional system.

If I thought that the internal RAID was bad, that's only because I
have not yet experienced an external enclosure from HP attached via
FibreChannel (P2000 G3 MSA, QLogic Corp. ISP2532-based 8Gb Fibre
Channel to PCI Express HBA). Unfortunately, I don't have detailed
information about the configuration of this enclosure, except that
it's a RAID6 volume, with 10 or 12 disks, I believe.

Witness this horrendous tanking of write throughput:

[   2s] reads: 0.00 MB/s writes: 0.07 MB/s fsyncs: 0.00/s response
time: 0.616ms (95%)
[   4s] reads: 0.00 MB/s writes: 14.10 MB/s fsyncs: 0.00/s response
time: 0.481ms (95%)
[   6s] reads: 0.00 MB/s writes: 15.28 MB/s fsyncs: 0.00/s response
time: 0.458ms (95%)
[   8s] reads: 0.00 MB/s writes: 14.65 MB/s fsyncs: 0.00/s response
time: 0.464ms (95%)
[  10s] reads: 0.00 MB/s writes: 15.32 MB/s fsyncs: 0.00/s response
time: 0.447ms (95%)
[  12s] reads: 0.00 MB/s writes: 15.18 MB/s fsyncs: 0.00/s response
time: 0.460ms (95%)
[  14s] reads: 0.00 MB/s writes: 15.18 MB/s fsyncs: 0.00/s response
time: 0.471ms (95%)
[  16s] reads: 0.00 MB/s writes: 14.06 MB/s fsyncs: 0.00/s response
time: 0.468ms (95%)
[  18s] reads: 0.00 MB/s writes: 0.43 MB/s fsyncs: 0.00/s response
time: 3.933ms (95%)
[  20s] reads: 0.00 MB/s writes: 0.00 MB/s fsyncs: 0.00/s response
time: 985.122ms (95%)
[  22s] reads: 0.00 MB/s writes: 0.01 MB/s fsyncs: 0.00/s response
time: 1435.164ms (95%)
[  24s] reads: 0.00 MB/s writes: 0.00 MB/s fsyncs: 0.00/s response
time: 1194.568ms (95%)
[  26s] reads: 0.00 MB/s writes: 0.00 MB/s fsyncs: 0.00/s response
time: 1112.091ms (95%)
[  28s] reads: 0.00 MB/s writes: 0.01 MB/s fsyncs: 0.00/s response
time: 1443.350ms (95%)
[  30s] reads: 0.00 MB/s writes: 0.00 MB/s fsyncs: 0.00/s response
time: 1078.972ms (95%)
Operations performed:  0 reads, 53413 writes, 0 Other = 53413 Total
Read 0b  Written 208.64Mb  Total transferred 208.64Mb  (6.8007Mb/sec)
 1740.98 Requests/sec executed

For comparison, this is the SmartArray P400 RAID6 that I initially
complained about:

[   2s] reads: 0.00 MB/s writes: 6.34 MB/s fsyncs: 0.00/s response
time: 0.219ms (95%)
[   4s] reads: 0.00 MB/s writes: 5.35 MB/s fsyncs: 0.00/s response
time: 0.217ms (95%)
[   6s] reads: 0.00 MB/s writes: 5.48 MB/s fsyncs: 0.00/s response
time: 0.208ms (95%)
[   8s] reads: 0.00 MB/s writes: 5.30 MB/s fsyncs: 0.00/s response
time: 0.228ms (95%)
[  10s] reads: 0.00 MB/s writes: 5.81 MB/s fsyncs: 0.00/s response
time: 0.226ms (95%)
[  12s] reads: 0.00 MB/s writes: 6.01 MB/s fsyncs: 0.00/s response
time: 0.223ms (95%)
[  14s] reads: 0.00 MB/s writes: 5.39 MB/s fsyncs: 0.00/s response
time: 0.212ms (95%)
[  16s] reads: 0.00 MB/s writes: 5.21 MB/s fsyncs: 0.00/s response
time: 0.225ms (95%)
[  18s] reads: 0.00 MB/s writes: 5.16 MB/s fsyncs: 0.00/s response
time: 0.224ms (95%)
[  20s] reads: 0.00 MB/s writes: 5.97 MB/s fsyncs: 0.00/s response
time: 0.217ms (95%)
[  22s] reads: 0.00 MB/s writes: 4.28 MB/s fsyncs: 0.00/s response
time: 0.228ms (95%)
[  24s] reads: 0.00 MB/s writes: 7.44 MB/s fsyncs: 0.00/s response
time: 0.191ms (95%)
[  26s] reads: 0.00 MB/s writes: 5.30 MB/s fsyncs: 0.00/s response
time: 0.250ms (95%)
[  28s] reads: 0.00 MB/s writes: 5.45 MB/s fsyncs: 0.00/s response
time: 0.258ms (95%)
[  30s] reads: 0.00 MB/s writes: 5.27 MB/s fsyncs: 0.00/s response
time: 0.254ms (95%)
Operations performed:  0 reads, 42890 writes, 0 Other = 42890 Total
Read 0b  Written 167.54Mb  Total transferred 167.54Mb  (5.5773Mb/sec)
 1427.80 Requests/sec executed

Slow, but at least it's consistent.

And that's what I would expect, and which a decent RAID controller
manages to provide (LSI Logic / Symbios Logic MegaRAID SAS 1078):

[   2s] reads: 0.00 MB/s writes: 56.65 MB/s fsyncs: 0.00/s response
time: 0.117ms (95%)
[   4s] reads: 0.00 MB/s writes: 37.15 MB/s fsyncs: 0.00/s response
time: 0.221ms (95%)
[   6s] reads: 0.00 MB/s writes: 35.92 MB/s fsyncs: 0.00/s response
time: 0.225ms (95%)
[   8s] reads: 0.00 MB/s writes: 34.15 MB/s fsyncs: 0.00/s response
time: 0.239ms (95%)
[  10s] reads: 0.00 MB/s writes: 33.19 MB/s fsyncs: 0.00/s response
time: 0.221ms (95%)
[  12s] reads: 0.00 MB/s writes: 34.02 MB/s fsyncs: 0.00/s response
time: 0.229ms (95%)
[  14s] reads: 0.00 MB/s writes: 36.61 MB/s fsyncs: 0.00/s response
time: 0.233ms (95%)
[  16s] reads: 0.00 MB/s writes: 37.62 MB/s fsyncs: 0.00/s response
time: 0.232ms (95%)
[  18s] reads: 0.00 MB/s writes: 35.75 MB/s fsyncs: 0.00/s response
time: 0.228ms (95%)
[  20s] reads: 0.00 MB/s writes: 35.42 MB/s fsyncs: 0.00/s response
time: 0.233ms (95%)
[  22s] reads: 0.00 MB/s writes: 34.63 MB/s fsyncs: 0.00/s response
time: 0.233ms (95%)
[  24s] reads: 0.00 MB/s writes: 34.83 MB/s fsyncs: 0.00/s response
time: 0.230ms (95%)
[  26s] reads: 0.00 MB/s writes: 36.84 MB/s fsyncs: 0.00/s response
time: 0.229ms (95%)
[  28s] reads: 0.00 MB/s writes: 36.15 MB/s fsyncs: 0.00/s response
time: 0.232ms (95%)
Operations performed:  0 reads, 284087 writes, 0 Other = 284087 Total
Read 0b  Written 1.0837Gb  Total transferred 1.0837Gb  (36.99Mb/sec)
 9469.55 Requests/sec executed

The command line used was: sysbench --test=fileio --max-time=30
--max-requests=10000000 --file-num=1 --file-extra-flags=direct
--file-total-size=8G --file-block-size=4k --file-fsync-all=off
--file-fsync-freq=0 --file-fsync-mode=fdatasync --num-threads=1
--file-test-mode=ag4 --report-interval=2 run

I have not yet uploaded my patched version of the development
sysbench, but I'm planning to do so, and I'd be really interested if
someone could run it on a really high-end storage system.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
