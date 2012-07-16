Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6GLRwFR017343 for <xfs@oss.sgi.com>; Mon, 16 Jul 2012 16:27:58 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id WlRCQ7kUGWsvXcJl
	for <xfs@oss.sgi.com>; Mon, 16 Jul 2012 14:27:56 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 6BA586C08F
	for <xfs@oss.sgi.com>; Mon, 16 Jul 2012 16:27:56 -0500 (CDT)
Message-ID: <5004875D.1020305@hardwarefreak.com>
Date: Mon, 16 Jul 2012 16:27:57 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: A little RAID experiment
References: <CAAxjCEzh3+doupD=LmgqSbCeYWzn9Ru-vE4T8tOJmoud+28FDQ@mail.gmail.com>
	<CAAxjCEzEiXv5Kna9zxZ-ePbhNg6nfRinkU=PCuyX3QHesq5qcg@mail.gmail.com>
In-Reply-To: <CAAxjCEzEiXv5Kna9zxZ-ePbhNg6nfRinkU=PCuyX3QHesq5qcg@mail.gmail.com>
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
To: xfs@oss.sgi.com

On 7/16/2012 2:57 PM, Stefan Ring wrote:

> If I thought that the internal RAID was bad, that's only because I
> have not yet experienced an external enclosure from HP attached via
> FibreChannel (P2000 G3 MSA, QLogic Corp. ISP2532-based 8Gb Fibre
> Channel to PCI Express HBA). Unfortunately, I don't have detailed
> information about the configuration of this enclosure, except that
> it's a RAID6 volume, with 10 or 12 disks, I believe.

Without that information the numbers below may tend to be a bit meaningless.

> Witness this horrendous tanking of write throughput:
> 
> [   2s] reads: 0.00 MB/s writes: 0.07 MB/s fsyncs: 0.00/s response
> time: 0.616ms (95%)
> [   4s] reads: 0.00 MB/s writes: 14.10 MB/s fsyncs: 0.00/s response
> time: 0.481ms (95%)
> [   6s] reads: 0.00 MB/s writes: 15.28 MB/s fsyncs: 0.00/s response
> time: 0.458ms (95%)
> [   8s] reads: 0.00 MB/s writes: 14.65 MB/s fsyncs: 0.00/s response
> time: 0.464ms (95%)
> [  10s] reads: 0.00 MB/s writes: 15.32 MB/s fsyncs: 0.00/s response
> time: 0.447ms (95%)
> [  12s] reads: 0.00 MB/s writes: 15.18 MB/s fsyncs: 0.00/s response
> time: 0.460ms (95%)
> [  14s] reads: 0.00 MB/s writes: 15.18 MB/s fsyncs: 0.00/s response
> time: 0.471ms (95%)
> [  16s] reads: 0.00 MB/s writes: 14.06 MB/s fsyncs: 0.00/s response
> time: 0.468ms (95%)

Up to this point it appears the BBWC is acknowledging write completion,
as the response times are less than 1ms, 16-40 times lower than a disk
drive response.  If this is the case, the transfer rates should be close
to 800MB/s, the limit for 8Gb FC.

> [  18s] reads: 0.00 MB/s writes: 0.43 MB/s fsyncs: 0.00/s response
> time: 3.933ms (95%)
> [  20s] reads: 0.00 MB/s writes: 0.00 MB/s fsyncs: 0.00/s response
> time: 985.122ms (95%)
> [  22s] reads: 0.00 MB/s writes: 0.01 MB/s fsyncs: 0.00/s response
> time: 1435.164ms (95%)
> [  24s] reads: 0.00 MB/s writes: 0.00 MB/s fsyncs: 0.00/s response
> time: 1194.568ms (95%)
> [  26s] reads: 0.00 MB/s writes: 0.00 MB/s fsyncs: 0.00/s response
> time: 1112.091ms (95%)
> [  28s] reads: 0.00 MB/s writes: 0.01 MB/s fsyncs: 0.00/s response
> time: 1443.350ms (95%)
> [  30s] reads: 0.00 MB/s writes: 0.00 MB/s fsyncs: 0.00/s response
> time: 1078.972ms (95%)

These writes appear to all be larger than the BBWC, according to the
response times.  It's odd that the data written is 0.00MB/s, meaning
nothing was actually written.  How does writing nothing takes over 1 second?

Either there is something wrong with your test, critical data omitted
from these reports, it isn't reporting coherent data, or I'm simply not
"trained" to read this output.  The output doesn't make any sense.

> Operations performed:  0 reads, 53413 writes, 0 Other = 53413 Total
> Read 0b  Written 208.64Mb  Total transferred 208.64Mb  (6.8007Mb/sec)
>  1740.98 Requests/sec executed
> 
> For comparison, this is the SmartArray P400 RAID6 that I initially
> complained about:
> 
> [   2s] reads: 0.00 MB/s writes: 6.34 MB/s fsyncs: 0.00/s response
> time: 0.219ms (95%)
> [   4s] reads: 0.00 MB/s writes: 5.35 MB/s fsyncs: 0.00/s response
> time: 0.217ms (95%)
> [   6s] reads: 0.00 MB/s writes: 5.48 MB/s fsyncs: 0.00/s response
> time: 0.208ms (95%)
> [   8s] reads: 0.00 MB/s writes: 5.30 MB/s fsyncs: 0.00/s response
> time: 0.228ms (95%)
> [  10s] reads: 0.00 MB/s writes: 5.81 MB/s fsyncs: 0.00/s response
> time: 0.226ms (95%)
> [  12s] reads: 0.00 MB/s writes: 6.01 MB/s fsyncs: 0.00/s response
> time: 0.223ms (95%)
> [  14s] reads: 0.00 MB/s writes: 5.39 MB/s fsyncs: 0.00/s response
> time: 0.212ms (95%)
> [  16s] reads: 0.00 MB/s writes: 5.21 MB/s fsyncs: 0.00/s response
> time: 0.225ms (95%)
> [  18s] reads: 0.00 MB/s writes: 5.16 MB/s fsyncs: 0.00/s response
> time: 0.224ms (95%)
> [  20s] reads: 0.00 MB/s writes: 5.97 MB/s fsyncs: 0.00/s response
> time: 0.217ms (95%)
> [  22s] reads: 0.00 MB/s writes: 4.28 MB/s fsyncs: 0.00/s response
> time: 0.228ms (95%)
> [  24s] reads: 0.00 MB/s writes: 7.44 MB/s fsyncs: 0.00/s response
> time: 0.191ms (95%)
> [  26s] reads: 0.00 MB/s writes: 5.30 MB/s fsyncs: 0.00/s response
> time: 0.250ms (95%)
> [  28s] reads: 0.00 MB/s writes: 5.45 MB/s fsyncs: 0.00/s response
> time: 0.258ms (95%)
> [  30s] reads: 0.00 MB/s writes: 5.27 MB/s fsyncs: 0.00/s response
> time: 0.254ms (95%)
> Operations performed:  0 reads, 42890 writes, 0 Other = 42890 Total
> Read 0b  Written 167.54Mb  Total transferred 167.54Mb  (5.5773Mb/sec)
>  1427.80 Requests/sec executed

Again, the response times suggest all these writes are being
acknowledged by BBWC.  Given this is a PCIe RAID HBA, the throughput
numbers to BBWC should be hundreds of megs per second.

> Slow, but at least it's consistent.
> 
> And that's what I would expect, and which a decent RAID controller
> manages to provide (LSI Logic / Symbios Logic MegaRAID SAS 1078):
> 
> [   2s] reads: 0.00 MB/s writes: 56.65 MB/s fsyncs: 0.00/s response
> time: 0.117ms (95%)
> [   4s] reads: 0.00 MB/s writes: 37.15 MB/s fsyncs: 0.00/s response
> time: 0.221ms (95%)
> [   6s] reads: 0.00 MB/s writes: 35.92 MB/s fsyncs: 0.00/s response
> time: 0.225ms (95%)
> [   8s] reads: 0.00 MB/s writes: 34.15 MB/s fsyncs: 0.00/s response
> time: 0.239ms (95%)
> [  10s] reads: 0.00 MB/s writes: 33.19 MB/s fsyncs: 0.00/s response
> time: 0.221ms (95%)
> [  12s] reads: 0.00 MB/s writes: 34.02 MB/s fsyncs: 0.00/s response
> time: 0.229ms (95%)
> [  14s] reads: 0.00 MB/s writes: 36.61 MB/s fsyncs: 0.00/s response
> time: 0.233ms (95%)
> [  16s] reads: 0.00 MB/s writes: 37.62 MB/s fsyncs: 0.00/s response
> time: 0.232ms (95%)
> [  18s] reads: 0.00 MB/s writes: 35.75 MB/s fsyncs: 0.00/s response
> time: 0.228ms (95%)
> [  20s] reads: 0.00 MB/s writes: 35.42 MB/s fsyncs: 0.00/s response
> time: 0.233ms (95%)
> [  22s] reads: 0.00 MB/s writes: 34.63 MB/s fsyncs: 0.00/s response
> time: 0.233ms (95%)
> [  24s] reads: 0.00 MB/s writes: 34.83 MB/s fsyncs: 0.00/s response
> time: 0.230ms (95%)
> [  26s] reads: 0.00 MB/s writes: 36.84 MB/s fsyncs: 0.00/s response
> time: 0.229ms (95%)
> [  28s] reads: 0.00 MB/s writes: 36.15 MB/s fsyncs: 0.00/s response
> time: 0.232ms (95%)
> Operations performed:  0 reads, 284087 writes, 0 Other = 284087 Total
> Read 0b  Written 1.0837Gb  Total transferred 1.0837Gb  (36.99Mb/sec)
>  9469.55 Requests/sec executed

Again, due to the response times, all the writes appear acknowledged by
BBWC.  While the LSI throughput is better, it is still far far lower
than what it should be, i.e. hundreds of megs per second to BBWC.

> The command line used was: sysbench --test=fileio --max-time=30
> --max-requests=10000000 --file-num=1 --file-extra-flags=direct
> --file-total-size=8G --file-block-size=4k --file-fsync-all=off
> --file-fsync-freq=0 --file-fsync-mode=fdatasync --num-threads=1
> --file-test-mode=ag4 --report-interval=2 run

I'm not familiar with sysbench.  That said, your command line seems to
be specifying 8GB files.  Your original issue reported here long ago was
low performance with huge metadata, i.e. deleting kernel trees etc.
What storage characteristics is the command above supposed to test?

> I have not yet uploaded my patched version of the development
> sysbench, but I'm planning to do so, and I'd be really interested if
> someone could run it on a really high-end storage system.

I'd like a pony.  If anyone here were to give me a pony that would
satisfy one desire of one person.  Ergo, if others performing your test
will have a positive impact on the XFS code and user base, and not
simply serve to satisfy the curiosity of one user, I'm sure others would
be glad to run such tests.  At this point though it seems such testing
would only satisfy the former, and not the latter.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
