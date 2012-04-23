Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3NKOlQR230512 for <xfs@oss.sgi.com>; Mon, 23 Apr 2012 15:24:47 -0500
Received: from josefsipek.net (josefsipek.net [64.9.206.49]) by cuda.sgi.com
	with ESMTP id 8G7iypCAsXm5FTBg for <xfs@oss.sgi.com>;
	Mon, 23 Apr 2012 13:24:44 -0700 (PDT)
Date: Mon, 23 Apr 2012 16:24:41 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: task blocked for more than 120 seconds
Message-ID: <20120423202441.GD21260@poseidon.cudanet.local>
References: <20120418151139.GC4652@poseidon.cudanet.local>
	<20120418234821.GR6734@dastard>
	<20120419154601.GB8230@poseidon.cudanet.local>
	<20120419225603.GA9541@dastard>
	<20120420135820.GB9189@poseidon.cudanet.local>
	<20120421002932.GG9541@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120421002932.GG9541@dastard>
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

On Sat, Apr 21, 2012 at 10:29:32AM +1000, Dave Chinner wrote:
...
> but also given the length of the incident, some other data is definitely
> needed:
> 	- a 30s event trace - it'll compress pretty well
> 	  (trace-cmd record -e xfs* sleep 30; trace-cmd report > output.txt)

http://31bits.net/download/output-1335211829.txt.bz2

> 	- vmstat 1 output for the same period

procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 2  0      0 191064 321700 16540692    0    0   471  1131    1    2  3  2 81 15
 0  0      0 190248 321700 16540696    0    0   624   744  615  289  0  0 100  0
 0  0      0 188728 321708 16540700    0    0   568   732 1544 2427  0  1 99  0
 0  0      0 186848 321708 16540772    0    0   544     0 5789 11321  0  1 99  0
 0  0      0 185856 321708 16540928    0    0   556   728 5801 11318  0  1 99  0
 0  0      0 185608 321708 16541032    0    0   504   704 5952 11360  0  2 98  0
 0  0      0 184740 321708 16541188    0    0   488   792 5799 11293  0  1 99  0
 0  0      0 183996 321708 16541248    0    0   488   608 5937 11369  0  1 99  0
 0  0      0 183004 321716 16541420    0    0   664   504 5834 11396  0  1 99  0
 0  0      0 182136 321716 16541560    0    0   656     0 5790 11332  0  2 98  0
 0  0      0 179408 321716 16544120    0    0   944  1072 5877 11428  0  1 98  0
 1  0      0 177844 321716 16544828    0    0   232 11448 5996 11443  0  1 98  0
 0  0      0 177968 321716 16544944    0    0     0     0 5703 11177  0  1 98  0
 0  0      0 177472 321724 16545028    0    0   264    20 5769 11264  1  1 99  0
 0  0      0 176852 321724 16545116    0    0   672     0 5827 11355  0  2 98  0
 0  0      0 176140 321724 16545164    0    0   656     0 5769 11339  0  1 99  0
 0  0      0 175396 321724 16545304    0    0   664    24 5797 11320  1  2 98  0
 0  0      0 173024 321724 16545408    0    0   668    40 5932 11393  1  1 98  0
 0  0      0 172280 321732 16545504    0    0   544    44 5761 11309  0  1 99  0
 0  0      0 171660 321732 16545632    0    0   632     8 5782 11336  0  1 99  0
 0  0      0 171040 321732 16546000    0    0   648   176 5796 11330  0  1 99  0
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 0  0      0 167320 321732 16548276    0    0  1312     0 5864 11479  0  1 99  0
 0  0      0 165832 321732 16548452    0    0   568  1224 5883 11359  0  1 99  0
 0  0      0 164716 321740 16548524    0    0   640   144 5871 11346  0  2 98  0
 0  0      0 163600 321740 16549920    0    0  1048   576 5876 11411  0  1 99  0
 0  0      0 161988 321740 16551356    0    0   944  1000 5849 11402  0  1 99  0
 0  0      0 161368 321740 16551964    0    0   624    48 5788 11324  0  2 98  0
 0  0      0 160996 321740 16552044    0    0   584     0 5772 11339  0  1 99  0
 0  0      0 160252 321748 16552136    0    0   624    20 5741 11327  0  0 100  0
 0  0      0 165708 321736 16546552    0    0   752   456 5895 11382  0  1 98  0
 0  0      0 164468 321736 16546952    0    0   664   376 5822 11326  0  1 99  0
 0  0      0 163724 321736 16547180    0    0   608   152 5800 11336  0  1 99  0
 0  0      0 163600 321736 16547260    0    0   672   872 4851 9169  0  1 99  0
 0  0      0 162880 321736 16547336    0    0   536     0  457  232  0  0 100  0
 1  0      0 164880 321740 16537360    0    0   376 16020  616  317  5  2 93  0
 1  0      0 167740 321368 16536716    0    0   496   888  597  258 17  0 83  0
 0  0      0 176048 317916 16540552    0    0   480   752  629  248 14  1 85  0
 0  0      0 175684 317916 16540448    0    0   472   800  230  216  0  0 100  0
 0  0      0 175328 317916 16540448    0    0   592   560  217  249  0  0 100  0
 0  0      0 174632 317916 16540488    0    0   600     0  254  257  0  0 100  0
 0  0      0 174508 317924 16540476    0    0   528   364  234  289  0  0 100  0
 0  0      0 173764 317924 16540480    0    0   584   640  290  280  0  0 100  0
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 0  0      0 173392 317924 16540480    0    0   736  1088  310  324  0  0 100  0
 0  0      0 172720 317924 16540480    0    0   608   328  279  301  0  0 100  0
 0  0      0 172100 317924 16540480    0    0   680   744  270  309  0  0 100  0
 0  0      0 171728 317932 16540480    0    0   504    44  197  218  0  0 100  0
 0  0      0 172852 317932 16540484    0    0   504   776  354  270  0  0 100  0
 0  0      0 172380 317932 16540488    0    0   432   680  239  217  0  0 100  0
 0  0      0 171760 317932 16540484    0    0   552   616  208  221  0  0 100  0
 0  0      0 171388 317932 16540484    0    0   528   816  212  229  0  0 100  0

> 	- output of /proc/meminfo at the same time

MemTotal:       33017676 kB
MemFree:          191312 kB
Buffers:          321700 kB
Cached:         16540692 kB
SwapCached:            0 kB
Active:         15167228 kB
Inactive:        9247756 kB
Active(anon):    6736980 kB
Inactive(anon):   817368 kB
Active(file):    8430248 kB
Inactive(file):  8430388 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:       3808252 kB
SwapFree:        3808252 kB
Dirty:            434824 kB
Writeback:             0 kB
AnonPages:       7552692 kB
Mapped:            10380 kB
Shmem:              1740 kB
Slab:            3689788 kB
SReclaimable:    2628672 kB
SUnreclaim:      1061116 kB
KernelStack:        2752 kB
PageTables:        58084 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    20317088 kB
Committed_AS:    9698260 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      329288 kB
VmallocChunk:   34359405376 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:        6720 kB
DirectMap2M:     3137536 kB
DirectMap1G:    30408704 kB

> 	- the same iostat output for comparison.

Linux 3.2.2 (fs3.ess.sfj.cudaops.com) 	04/23/12 	_x86_64_	(6 CPU)

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               8.89    95.35  306.14  470.40     2.75     6.60    24.67     3.52    4.54    5.62    3.83   0.91  70.84
sda               0.00     2.00   70.20   71.80     0.55     0.57    16.07     1.02    7.19   14.54    0.01   7.03  99.84
sda               0.00     2.40   80.80   73.40     0.63     0.58    16.10     1.02    6.58   12.16    0.45   6.39  98.48
sda               0.00    12.20   45.80  275.00     0.36     2.24    16.58     3.96   12.36   21.87   10.78   3.11  99.92
sda               0.00     2.00   78.60    6.40     0.61     0.06    16.19     1.00   11.76   12.71    0.00  11.71  99.52
sda               0.00    30.20  113.00   44.00     0.88     0.57    19.02     0.99    6.29    8.74    0.00   6.30  98.88
sda               0.00     2.40   81.20   20.60     0.63     0.18    16.30     1.00    9.80   12.29    0.00   9.80  99.76
sda               0.00     1.20   67.20   80.00     0.53     3.50    56.03     1.13    7.67   14.88    1.62   6.78  99.84
sda               0.00     2.60   66.80   60.80     0.52     0.48    16.14     1.03    8.08   14.92    0.57   7.82  99.84
sda               0.00     8.00   77.60   64.20     0.61     0.56    16.78     1.01    7.11   12.86    0.16   7.03  99.68

Anything else?

Jeff.

P.S. I had a script prepared to fire off whenever the time came:

# cat run-when-loaded.sh 
#!/bin/sh

TOK=`date +%s`

cat /proc/mounts > ~/mounts-$TOK.txt
cat /proc/meminfo > ~/meminfo-$TOK.txt

(
	vmstat 1 50 > ~/vmstat-$TOK.txt
) &

(
	iostat -d -m -x 5 10 > ~/iostat-$TOK.txt
) &

(
	cd trace-cmd
	./trace-cmd record -e xfs* sleep 30
	./trace-cmd report > ~/output-$TOK.txt
)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
