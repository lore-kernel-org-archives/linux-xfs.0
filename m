Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5F0G7MU037873 for <xfs@oss.sgi.com>; Thu, 14 Jun 2012 19:16:07 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	rBMG2vznSTqUu2AZ for <xfs@oss.sgi.com>;
	Thu, 14 Jun 2012 17:16:05 -0700 (PDT)
Date: Fri, 15 Jun 2012 10:16:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS hangs and freezes with LSI 9265-8i controller on high i/o
Message-ID: <20120615001602.GF7339@dastard>
References: <4FD66513.2000108@xsnews.nl> <20120612011812.GK22848@dastard>
	<4FD766A7.9030908@xsnews.nl> <20120613011950.GN22848@dastard>
	<4FD8552C.4090208@xsnews.nl> <20120614000411.GY22848@dastard>
	<4FD9F5B3.3040901@xsnews.nl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FD9F5B3.3040901@xsnews.nl>
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
To: Matthew Whittaker-Williams <matthew@xsnews.nl>
Cc: xfs@oss.sgi.com

On Thu, Jun 14, 2012 at 04:31:15PM +0200, Matthew Whittaker-Williams wrote:
> iostat:
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> sda               0.00     0.00   81.80    1.40    10.22     0.18 256.00   531.91 5349.11  12.02 100.00
> sda               0.00     0.00   83.40    1.20    10.37     0.15 254.56   525.35 4350.67  11.82 100.00
> sda               0.00     0.00   79.20    0.80     9.90     0.10 256.00   530.14 3153.38  12.50 100.00
> sda               0.00     0.00   72.80    2.20     9.09     0.13 251.72   546.08 8709.54  13.33 100.00
> sda               0.00     0.00   79.80    1.40     9.95     0.12 254.07   535.35 5172.22  12.32 100.00
> sda               0.00     0.00   99.60    1.20    12.41     0.08 253.86   529.49 3560.89   9.92 100.00
> sda               0.00     0.00   60.80    1.40     7.59     0.11 253.77   527.21 6545.50  16.08 100.00
> sda               0.00     0.00   79.00    1.80     9.84     0.08 251.51   547.93 6400.42  12.38 100.00
> sda               0.00     0.00   82.20    2.20    10.25     0.01 248.93   536.42 7415.77  11.85 100.00
> sda               0.00     0.00   89.40    2.20    11.17     0.01 249.90   525.68 7232.96  10.92 100.00
> sda               0.00     0.00   82.00    1.20    10.22     0.08 253.37   541.60 4170.95  12.02 100.00
> sda               0.00     0.00   62.80    2.60     7.85     0.14 250.31   541.15 11260.81  15.29 100.00
> sda               0.00     0.00   85.00    1.80    10.61     0.21 255.47   529.36 6514.85  11.52 100.00
> sda               0.00     0.00   75.20    1.40     9.38     0.11 253.72   535.68 5416.70  13.05 100.00
> sda               0.00     0.00   66.80    1.20     8.33     0.11 254.19   546.68 5459.11  14.71 100.00
> sda               0.00     0.00   81.40    0.80    10.15     0.10 255.38   540.62 3171.57  12.17 100.00
> sda               0.00     0.00   72.20    1.20     9.02     0.15 255.74   535.26 5345.51  13.62 100.00
> sda               0.00     0.00   91.00    1.00    11.35     0.12 255.44   531.02 3637.72  10.87 100.00
> sda               0.00     0.00   81.00    1.60    10.12     0.20 255.96   524.44 6513.22  12.11 100.00
> sda               0.00     0.00   72.80    2.40     9.04     0.26 253.24   543.25 9071.66  13.30 100.00
> sda               0.00     0.00   73.80    1.20     9.18     0.15 254.63   539.20 5087.91  13.33 100.00
> sda               0.00     0.00   79.20    1.40     9.90     0.18 256.00   532.38 5592.38  12.41 100.00
> sda               0.00     0.20   79.40    1.00     9.90     0.12 255.36   528.07 4091.22  12.44 100.00
> sda               0.00     0.00   88.40    1.20    11.05     0.15 256.00   528.13 4349.35  11.16 100.00
> sda               0.00     0.00   69.60    2.40     8.65     0.23 252.71   527.46 9334.37  13.89 100.00

So, the average service time for an IO is 10-16ms, which is a seek
per IO. You're doing primarily 128k read IOs, and maybe one or 2
writes a second. You have a very deep request queue: > 512 requests.
Have you tuned /sys/block/sda/queue/nr_requests up from the default
of 128? This is going to be one of the causes of your problems - you
have 511 oustanding write requests, and only one read at a time.
Reduce the ioscehduer queue depth, and potentially also the device
CTQ depth.

That tends to indicate that the write requests are causing RMW
cycles in the RAID when flushing the cache, otherwise they'd simply
hit the BBWC and return immediately. The other possibility is that
the BBWC is operating in write-through mode rather than write back,
but this is typical of a writeback cache filling up and then having
to flush and the flush being -extremely- slow due to RMW cycles....

Oh, I just noticed you are might be using CFQ (it's the default in
dmesg). Don't - CFQ is highly unsuited for hardware RAID - it's
hueristically tuned to work well on sngle SATA drives. Use deadline,
or preferably for hardware RAID, noop.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
