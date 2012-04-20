Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3KDwPBm226956 for <xfs@oss.sgi.com>; Fri, 20 Apr 2012 08:58:26 -0500
Received: from josefsipek.net (josefsipek.net [64.9.206.49]) by cuda.sgi.com
	with ESMTP id EM9Ji9yHHUJaBaiK for <xfs@oss.sgi.com>;
	Fri, 20 Apr 2012 06:58:23 -0700 (PDT)
Date: Fri, 20 Apr 2012 09:58:20 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: task blocked for more than 120 seconds
Message-ID: <20120420135820.GB9189@poseidon.cudanet.local>
References: <20120418151139.GC4652@poseidon.cudanet.local>
	<20120418234821.GR6734@dastard>
	<20120419154601.GB8230@poseidon.cudanet.local>
	<20120419225603.GA9541@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120419225603.GA9541@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Apr 20, 2012 at 08:56:03AM +1000, Dave Chinner wrote:
> On Thu, Apr 19, 2012 at 11:46:02AM -0400, Josef 'Jeff' Sipek wrote:
...
> > /dev/sda4 /var/data/disk0 xfs rw,noatime,attr2,filestreams,delaylog,nobarrier,inode64,logbufs=8,logbsize=256k,noquota 0 0
> 
> Only unusual thing is the filestreams allocator is in use...

Yep.  It seemed to make sense to use it since we just want the files to get
to disk.

> > fs3.ess ~ # xfs_info /var/data/disk0/
> > meta-data=/dev/sda4              isize=256    agcount=32, agsize=268435455 blks
> >          =                       sectsz=512   attr=2
> > data     =                       bsize=4096   blocks=8519632640, imaxpct=5
> >          =                       sunit=0      swidth=0 blks
> > naming   =version 2              bsize=4096   ascii-ci=0
> > log      =internal               bsize=4096   blocks=521728, version=2
> 
> and it is a large log, so that's a definite candidate for long
> stalls pushing the tail of the log. The typical push that you'll get
> stalled on is trying to keep 25% fthe log space free, so there's
> potentially hundreds of megabytes of random 4/8k metadata writes to
> be done to free that space in the log...

FWIW, the filesystem was made using the default mkfs options (IOW: mkfs.xfs
/dev/sda4).  I didn't even notice the log being 2GB.  (I just assumed it'd
be the good ol' 128MB.)

> What was the size of the log on the previous incarnation of the
> filesystem?

I don't know.  I checked the other file server that was set up at the same
time, and it has a log that's the same size.

...
> > The following applies to all of the spikes, but I'm specifically talking about
> > the spike from this morning.  During the ~45 minute spike, there seems to be
> > very little disk I/O (<1 MByte/s compared to the usual 10 MBytes/s).  Since
> 
> That sounds like it might have dropped into random 4k write IO or
> inode cluster RMW cycles - a single large RAID6 volume is going to
> be no faster than a single spindle at this. Can you get `iostat -d
> -m -x 5` output when the next slowdown occurs so we can see the IOPS
> and utilisation as well as the bandwidth?

Right.  Here's the output from a few minutes ago (I removed the empty lines
and redundant column headings):

fs3.ess ~ # iostat -d -m -x 5
Linux 3.2.2 (fs3.ess.sfj.cudaops.com) 	04/20/12 	_x86_64_	(6 CPU)

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda              11.90   129.18  261.81  457.22     2.81     6.76    27.26     4.44    6.18    9.60    4.22   0.82  59.02
sda               0.00     0.20   61.20  112.60     0.49     0.88    16.17     1.50    8.64   17.66    3.74   5.74  99.76
sda               0.00     0.60   61.40  117.60     0.48     0.92    16.02     1.33    7.41   16.18    2.82   5.56  99.52
sda               0.00     1.20   63.40  104.20     0.50     0.82    16.09     1.28    7.65   15.70    2.75   5.94  99.60
sda               0.00    43.00   59.20  166.60     0.46     1.64    19.05     1.63    7.23   16.82    3.82   4.41  99.60
sda               0.00     0.40   60.80  139.80     0.47     1.09    16.00     1.32    6.57   16.25    2.36   4.96  99.44
sda               0.00     1.20   59.60  108.00     0.47     0.85    16.08     1.22    7.34   16.82    2.10   5.95  99.68
sda               0.00     0.40   66.60  102.80     0.52     0.80    16.01     1.28    7.57   15.00    2.75   5.88  99.68
sda               0.00     4.80   67.00  111.60     0.52     0.91    16.39     1.21    6.75   14.85    1.88   5.58  99.68
sda               0.00     0.60   64.60  103.40     0.50     0.81    16.02     1.16    6.90   15.48    1.55   5.94  99.76
sda               0.00    23.00   65.20  122.60     0.51     1.14    17.96     1.34    7.13   15.28    2.80   5.31  99.68
sda               0.00     0.60   62.40  153.60     0.49     1.20    16.01     1.40    6.46   15.88    2.63   4.63  99.92
sda               0.00    13.60   56.20  131.20     0.44     1.13    17.13     1.39    7.43   17.81    2.98   5.31  99.52
sda               0.00    18.80   29.80  422.00     0.23     3.44    16.66    20.54   45.46   33.40   46.31   2.20  99.52
sda               0.00     0.40   80.40    2.00     0.63     0.01    15.98     0.99   12.09   12.39    0.00  12.06  99.36
sda               0.00     3.60   70.20   12.60     0.55     0.12    16.64     1.00   11.71   13.81    0.00  12.04  99.68
sda               0.00    28.20   66.60   40.40     0.52     0.54    20.22     1.12   10.68   15.33    3.01   9.29  99.36
sda               0.00     0.80   71.80   89.00     0.56     0.70    16.04     1.24    7.66   13.77    2.72   6.21  99.84
sda               0.00     3.60   56.60  156.00     0.44     1.24    16.24     1.51    7.10   17.58    3.29   4.69  99.68
sda               0.00     0.40   64.80  106.80     0.51     0.84    16.01     1.18    6.93   15.56    1.69   5.82  99.84
sda               0.00     4.60   22.80  439.40     0.18     3.46    16.14    25.95   56.14   43.68   56.78   2.16  99.68
sda               0.00    28.20   70.60   87.60     0.57     0.90    19.02     1.33    8.43   14.29    3.71   6.29  99.52
sda               0.00     0.60   83.60    4.00     0.65     0.03    16.02     0.99   11.33   11.88    0.00  11.33  99.28
sda               0.00    13.20   80.00   44.40     0.62     0.23    14.10     1.00    8.08   12.45    0.20   8.00  99.52
sda               0.00     1.00   74.60   41.40     0.58     0.33    16.06     1.08    9.23   13.22    2.05   8.58  99.52
sda               0.00     0.40   63.00   95.20     0.49     0.74    16.01     1.28    8.16   15.89    3.05   6.28  99.36
sda               0.00     5.00   22.60  482.60     0.18     3.81    16.15     9.94   19.65   43.68   18.53   1.98 100.00
sda               0.00     0.20   75.40   10.60     0.59     0.08    15.98     1.00   11.75   13.40    0.00  11.57  99.52
sda               0.00     0.00   78.00    1.60     0.61     0.01    16.00     1.00   12.50   12.76    0.00  12.53  99.76
sda               0.00    14.40   75.80   52.40     0.59     0.52    17.75     1.15    8.95   13.12    2.93   7.76  99.44
sda               0.00    36.40   70.60  101.80     0.55     1.08    19.34     1.29    7.47   14.11    2.86   5.77  99.44
sda               0.00     0.60   63.80  143.40     0.50     1.12    16.02     1.49    7.18   15.59    3.44   4.81  99.60
sda               0.00    32.80   55.40  197.00     0.43     1.79    18.05     1.67    6.62   17.92    3.44   3.94  99.44
sda               0.00     2.20   62.60  132.20     0.49     1.03    16.02     1.38    7.08   15.96    2.88   5.12  99.76
sda               0.00     6.20   64.20  122.40     0.50     1.00    16.49     1.35    7.20   15.45    2.88   5.34  99.60
sda               0.00     0.00   62.60  111.20     0.49     0.87    16.00     1.28    7.38   16.00    2.53   5.74  99.76
sda               0.00     7.20   58.20  121.60     0.45     1.00    16.61     1.16    6.27   16.54    1.36   5.53  99.36
sda               0.00     0.20   68.20  104.40     0.53     0.81    15.99     1.33    7.88   15.10    3.16   5.78  99.76
sda               0.00    14.60   62.40  122.40     0.49     1.07    17.23     1.49    8.08   16.00    4.04   5.40  99.76


And now while the system is coming back to the usual loadavg (of 30):

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0.00    26.00   29.00 1235.40     0.13    17.10    27.91   202.30  161.37 1792.52  123.08   0.79 100.00
sda               0.00    29.80   26.20 1095.60     0.11    15.34    28.22   185.88  187.19 2248.92  137.89   0.89 100.00
sda               0.00    28.20   11.80 1527.20     0.06    19.80    26.44   165.23  112.77  665.83  108.50   0.65 100.00
sda               0.20     2.80  412.40  320.20     2.09     7.00    25.40    61.10   87.40   53.49  131.06   1.37 100.00
sda               2.60     1.60 1056.00   52.20     5.82     0.57    11.81    21.87   19.68   20.65    0.03   0.90 100.00
sda               0.00     7.40 1256.40   34.40     5.77     0.30     9.63    24.81   19.33   19.85    0.19   0.77 100.00
sda               0.00    28.80  917.60  273.00     4.18     2.42    11.34    26.72   22.38   27.52    5.12   0.84 100.00
sda               0.00     0.20 1302.00   28.20     5.90     0.37     9.64    24.75   18.69   19.09    0.03   0.75 100.00
sda               0.00    42.60   61.40  964.60     0.30    11.75    24.05   158.59  144.06  323.64  132.63   0.97 100.00
sda               0.00    29.40   24.00  675.00     0.11     5.00    14.96   143.77  209.05 1007.17  180.67   1.43 100.00
sda               0.00    21.60   28.00  785.00     0.16     6.38    16.48   177.47  220.53  930.09  195.22   1.23 100.00
sda               0.00    31.00   24.40  964.20     0.13    10.67    22.36   177.09  177.76  767.02  162.85   1.01 100.00
sda               0.00    27.00   24.80 1174.20     0.11    14.33    24.68   170.26  144.93  911.90  128.73   0.83 100.00
sda               0.00    34.40    9.00  700.80     0.05     2.98     8.73   151.54  212.61  797.51  205.09   1.41 100.00
sda               0.00    37.20    9.00  776.60     0.05     4.09    10.78   152.84  192.65  775.91  185.89   1.27 100.00
sda               0.00    36.60   14.80  716.40     0.07     3.35     9.58   167.69  214.14  769.19  202.68   1.37 100.00
sda               0.00     5.80   54.00 1824.00     0.24    25.04    27.56   200.50  107.98  950.50   83.04   0.53 100.00
sda               0.00     1.80  207.60 1659.60     0.87    36.25    40.72   151.21   89.22  316.71   60.77   0.54 100.00
sda               0.00     2.00 1513.20   33.20     6.96     0.27     9.57    27.73   17.94   18.33    0.10   0.65 100.00
sda               0.00     1.60 1257.00   14.00     5.78     0.68    10.41    24.57   19.34   19.54    1.54   0.79 100.00
sda               0.00    14.20 1214.00  122.80     5.51     5.54    16.93    23.34   17.42   19.05    1.29   0.75 100.00
sda               0.00    13.60  892.80  590.40     4.12     2.67     9.38    25.95   16.39   23.63    5.45   0.67 100.00
sda               0.00    22.00   31.00  775.40     0.15     3.64     9.60    96.49  115.41  671.79   93.16   1.24 100.00
sda               0.00    29.40   29.60  679.40     0.14     4.54    13.52   153.30  215.36  860.62  187.25   1.41 100.00
sda               0.00    20.60   23.00  635.60     0.11     3.06     9.85   136.16  198.69  772.73  177.92   1.52 100.00
sda               0.00    21.40   21.00  909.20     0.10     7.39    16.49   178.96  196.48 1222.10  172.79   1.08 100.00
sda               0.00     6.00   51.80 1457.20     0.23    26.23    35.91   200.49  124.56  666.36  105.30   0.66 100.00
sda               0.00    38.60   29.60  701.00     0.12     3.23     9.40   182.10  267.15 1711.57  206.16   1.37 100.00

Oh, and:

fs3.ess ~ # cat /sys/block/sda/queue/scheduler 
noop [deadline] cfq 

Jeff.

-- 
You measure democracy by the freedom it gives its dissidents, not the
freedom it gives its assimilated conformists.
		- Abbie Hoffman

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
