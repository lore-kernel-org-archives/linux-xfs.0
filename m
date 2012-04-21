Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3L0TcCQ034784 for <xfs@oss.sgi.com>; Fri, 20 Apr 2012 19:29:39 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	yacTfWeGl9UmBFxS for <xfs@oss.sgi.com>;
	Fri, 20 Apr 2012 17:29:36 -0700 (PDT)
Date: Sat, 21 Apr 2012 10:29:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: task blocked for more than 120 seconds
Message-ID: <20120421002932.GG9541@dastard>
References: <20120418151139.GC4652@poseidon.cudanet.local>
	<20120418234821.GR6734@dastard>
	<20120419154601.GB8230@poseidon.cudanet.local>
	<20120419225603.GA9541@dastard>
	<20120420135820.GB9189@poseidon.cudanet.local>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120420135820.GB9189@poseidon.cudanet.local>
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
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: xfs@oss.sgi.com

On Fri, Apr 20, 2012 at 09:58:20AM -0400, Josef 'Jeff' Sipek wrote:
> On Fri, Apr 20, 2012 at 08:56:03AM +1000, Dave Chinner wrote:
> > On Thu, Apr 19, 2012 at 11:46:02AM -0400, Josef 'Jeff' Sipek wrote:
> FWIW, the filesystem was made using the default mkfs options (IOW: mkfs.xfs
> /dev/sda4).  I didn't even notice the log being 2GB.  (I just assumed it'd
> be the good ol' 128MB.)

OK.

> ...
> > > The following applies to all of the spikes, but I'm specifically talking about
> > > the spike from this morning.  During the ~45 minute spike, there seems to be
> > > very little disk I/O (<1 MByte/s compared to the usual 10 MBytes/s).  Since
> > 
> > That sounds like it might have dropped into random 4k write IO or
> > inode cluster RMW cycles - a single large RAID6 volume is going to
> > be no faster than a single spindle at this. Can you get `iostat -d
> > -m -x 5` output when the next slowdown occurs so we can see the IOPS
> > and utilisation as well as the bandwidth?
> 
> Right.  Here's the output from a few minutes ago (I removed the empty lines
> and redundant column headings):

Thanks, that makes it easy to read ;)

> fs3.ess ~ # iostat -d -m -x 5
> Linux 3.2.2 (fs3.ess.sfj.cudaops.com) 	04/20/12 	_x86_64_	(6 CPU)
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
> sda              11.90   129.18  261.81  457.22     2.81     6.76    27.26     4.44    6.18    9.60    4.22   0.82  59.02
> sda               0.00     0.20   61.20  112.60     0.49     0.88    16.17     1.50    8.64   17.66    3.74   5.74  99.76
> sda               0.00     0.60   61.40  117.60     0.48     0.92    16.02     1.33    7.41   16.18    2.82   5.56  99.52
> sda               0.00     1.20   63.40  104.20     0.50     0.82    16.09     1.28    7.65   15.70    2.75   5.94  99.60

Ok, so the queue depth here is showing serialised IO (barely above
1), and the request size is 8k, which will be inode clusters. The
service time for reads is around 16ms, which assuming SATA drives is
a full disk seek. The writes are much faster dues to the BBWC. it
looks, however, like it is reading inodes from all over the drive,
and that is the delay factor here. The serialisation indicates that
it is either log tail pushing or low-memory inode reclaim that is
slowing everyone down here.

Now comes the "more data needed" bit. I still need the sysrq-w
output, but also given the length of the incident, some other data
is definitely needed:

	- a 30s event trace - it'll compress pretty well
	  (trace-cmd record -e xfs* sleep 30; trace-cmd report > output.txt)
	- vmstat 1 output for the same period
	- output of /proc/meminfo at the same time
	- the same iostat output for comparison.

> And now while the system is coming back to the usual loadavg (of 30):
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
> sda               0.00    26.00   29.00 1235.40     0.13    17.10    27.91   202.30  161.37 1792.52  123.08   0.79 100.00
> sda               0.00    29.80   26.20 1095.60     0.11    15.34    28.22   185.88  187.19 2248.92  137.89   0.89 100.00
> sda               0.00    28.20   11.80 1527.20     0.06    19.80    26.44   165.23  112.77  665.83  108.50   0.65 100.00

Yeah, that looks more like a properly working filesystem :/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
