Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0AHWvPd090214 for <xfs@oss.sgi.com>; Tue, 10 Jan 2012 11:33:00 -0600
Received: from crunch.scalableinformatics.com
	(173-10-54-97-Michigan.hfc.comcastbusiness.net [173.10.54.97])
	by cuda.sgi.com with ESMTP id PFz3QRsaJx1PV8Ho for
	<xfs@oss.sgi.com>; Tue, 10 Jan 2012 09:32:49 -0800 (PST)
Message-ID: <4F0C763E.2060207@scalableinformatics.com>
Date: Tue, 10 Jan 2012 12:32:46 -0500
From: Joe Landman <landman@scalableinformatics.com>
MIME-Version: 1.0
Subject: Re: bug: xfs_repair becomes very slow when file system has a large
	sparse file
References: <4E4E9131.2050807@scalableinformatics.com>
	<20110820002657.GF32358@dastard>
In-Reply-To: <20110820002657.GF32358@dastard>
Reply-To: landman@scalableinformatics.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

User just gave us permission to work on the system now, and we can be 
destructive if needed.  Took a few months, but we have a full 
backup/snapshot which is now the primary, and this is an "extra" system 
to be remissioned, but still exhibits the problem reported last August.


FWIW:

[root@jr4-4 ~]# df -h /data
Filesystem            Size  Used Avail Use% Mounted on
/dev/md2               33T   30T  3.0T  92% /data



On 08/19/2011 08:26 PM, Dave Chinner wrote:
> On Fri, Aug 19, 2011 at 12:37:05PM -0400, Joe Landman wrote:
>> (If you prefer we file this on a bug reporting system, please let me
>> know where and I'll do this).
>>
>> Scenario:  xfs_repair being run against an about 17TB volume,
>> containing 1 large sparse file.  Logical size of 7 PB, actual size,
>> a few hundred GB.
>>
>> Metadata:  Kernel = 2.6.32.41, 2.6.39.4, and others. Xfstools 3.1.5.
>> Hardware RAID ~17TB LUN.  Base OS: Centos 5.6 + updates + updated
>> xfs tools + our kernels.  Using external journal on a different
>> device
>>
>> What we observe:
>>
>> Running xfs_repair
>>
>> 	xfs_repair -l /dev/md2 -vv /dev/sdd2
>
> can you post the actual output of xfs_repair?
>

Will do below.

>>
>> the system gets to stage 3 and the first ag.  Then it appears to
>> stop. After an hour or so, we strace it, and we see
>>
>> 	pread(...) = 4096
>
> and the same for the strace, along with syscall completion time?
> (i.e. strace -ttt -T .....) That will tell us if the time is spend
> doing IO or in the repair binary.
>

Ok.  Will do below as well.

> What is the CPU usage when this happens? How much memory do you

A single CPU filled.

> have? Is the machine swapping while it is slowing down? A couple of

No.  Checked that.

> minutes output of 'vmstat 5' when it is in this state would be handy.

Ok, will append this as well.

>
>> occurring about 2-3 per second.  An hour later, its down to 1 per
>> second.   An hour after that, its once every 2 seconds.
>>
>> Also, somewhere on this disk, someone has created an unfortunately
>> large file
>>
>> [root@jr4-2 ~]# ls -alF /data/brick-sdd2/dht/scratch/xyzpdq
>> total 4652823496
>> d---------   2 1232 1000               86 Jun 27 20:31 ./
>> drwx------ 104 1232 1000            65536 Aug 17 23:53 ../
>> -rw-------   1 1232 1000               21 Jun 27 09:57 Default.Route
>> -rw-------   1 1232 1000              250 Jun 27 09:57 Gau-00000.inp
>> -rw-------   1 1232 1000                0 Jun 27 09:57 Gau-00000.d2e
>> -rw-------   1 1232 1000 7800416534233088 Jun 27 20:18 Gau-00000.rwf
>>
>> [root@jr4-2 ~]# ls -ahlF /data/brick-sdd2/dht/scratch/xyzpdq
>> total 4.4T
>> d---------   2 1232 1000   86 Jun 27 20:31 ./
>> drwx------ 104 1232 1000  64K Aug 17 23:53 ../
>> -rw-------   1 1232 1000   21 Jun 27 09:57 Default.Route
>> -rw-------   1 1232 1000  250 Jun 27 09:57 Gau-00000.inp
>> -rw-------   1 1232 1000    0 Jun 27 09:57 Gau-00000.d2e
>> -rw-------   1 1232 1000 7.0P Jun 27 20:18 Gau-00000.rwf
>>
>> This isn't a 7PB file system, its a 100TB file system across 3
>> machines, roughly 17TB per brick or OSS.  The Gau-00000.rwf is
>> obviously a sparse file, as could be seen with an ls -alsF
>
> What does du tell you about it?  xfs_io -f -c "stat"<large file>?
> xfs_bmap -vp<large file>?

In the cases presented below, none of the files are sparse.  I am 
wondering if it simply happens for large files.  I scanned the file 
system for large files (greater than 10GB in size), and found quite a 
few ... a number of which were at 250+ GB size.

>
>> Upon removing that file, the xfs_repair completes within ~10
>> minutes. Leaving that file on there, the xfs_repair does not
>> terminate, it just gets asymptotically slower.

I'd like to leave these in place until you tell me you need them to be 
removed/looked at.

>
> That could simply be the memory footprint causing more swapping per
> operation to occur. Or it could be that something is simply getting
> too large for the index type being used. If the machine is not
> swapping, can you point 'perf top -p<pid of xfs_repair>' at it so
> we might see where that CPU time is being spent?  (you might need to
> use a non-stripped version of the binary to get any useful
> information)

Ok.  I'll generate that if needed.

>
>> Please let me know if you need more information, or if you would
>> like me to file this somewhere else for official reportage.
>
> This is the right place to let us know about problems.
>

Separating with 8x========== on top and ==========x8 on bottom, with 
additional meta-data below the 8x ... portion

8x========== xfs_repair output for
# nohup xfs_repair  -m 16384 -vvv -l /dev/md10 /dev/md2 > \
#            repair.out 2>&1 &

[root@jr4-4 ~]# cat repair.out
Phase 1 - find and verify superblock...
         - max_mem = 16777216, icount = 15540800, imem = 60706, dblock = 
8782223872, dmem = 4288195
         - block cache size set to 1547288 entries
Phase 2 - using external log on /dev/md10
         - zero log...
zero_log: head block 2 tail block 2
         - scan filesystem freespace and inode maps...
         - found root inode chunk
libxfs_bcache: 0x8804c0
Max supported entries = 1547288
Max utilized entries = 11850
Active entries = 11850
Hash table size = 193411
Hits = 0
Misses = 11850
Hit ratio =  0.00
MRU 0 entries =  11850 (100%)
MRU 1 entries =      0 (  0%)
MRU 2 entries =      0 (  0%)
MRU 3 entries =      0 (  0%)
MRU 4 entries =      0 (  0%)
MRU 5 entries =      0 (  0%)
MRU 6 entries =      0 (  0%)
MRU 7 entries =      0 (  0%)
MRU 8 entries =      0 (  0%)
MRU 9 entries =      0 (  0%)
MRU 10 entries =      0 (  0%)
MRU 11 entries =      0 (  0%)
MRU 12 entries =      0 (  0%)
MRU 13 entries =      0 (  0%)
MRU 14 entries =      0 (  0%)
MRU 15 entries =      0 (  0%)
Hash buckets with   0 entries 182822 (  0%)
Hash buckets with   1 entries   9785 ( 82%)
Hash buckets with   2 entries    530 (  8%)
Hash buckets with   3 entries    108 (  2%)
Hash buckets with   4 entries    155 (  5%)
Hash buckets with   5 entries      9 (  0%)
Hash buckets with   8 entries      2 (  0%)
Phase 3 - for each AG...
         - scan and clear agi unlinked lists...
         - process known inodes and perform inode discovery...
         - agno = 0
         - agno = 1
         - agno = 2
         - agno = 3
         - agno = 4
         - agno = 5
         - agno = 6
         - agno = 7

# stuck here for more than 1 hour now
==========x8

8x========== top output
#

[root@jr4-4 ~]# top

top - 11:30:27 up 160 days, 13:42,  2 users,  load average: 0.87, 0.86, 0.87
Tasks: 384 total,   2 running, 382 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.0%us,  0.8%sy,  0.0%ni, 98.2%id,  0.8%wa,  0.0%hi,  0.2%si, 
0.0%st
Mem:  49459860k total, 15226800k used, 34233060k free,      380k buffers
Swap: 13670752k total,        0k used, 13670752k free,     9612k cached

   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND 

16623 root      20   0 15.6g  14g  908 R 99.9 30.0 121:00.98 xfs_repair 

17099 root      20   0 12880 1232  732 R  2.0  0.0   0:00.02 top 

     1 root      20   0 10360  636  520 S  0.0  0.0   1:20.24 init 

     2 root      20   0     0    0    0 S  0.0  0.0   0:00.02 kthreadd 

     3 root      RT   0     0    0    0 S  0.0  0.0   3:44.51 
migration/0 

     4 root      20   0     0    0    0 S  0.0  0.0  88:34.79 
ksoftirqd/0

==========x8

8x========== vmstat 5 output for
# nohup vmstat 5 > vmstat.out 2>&1 &
# started the xfs_repair after starting this, so this is the initial
# data, subsequent data after the ... where xfs_repair appears to be
# mired down.

[root@jr4-4 ~]# tail -f vmstat.out
procs -----------memory---------- ---swap-- -----io---- --system-- 
-----cpu------
  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy 
id wa st
  0  0      0 49093752    868  11020    0    0   744   249    0    0  0 
  1 98  1  0
  0  0      0 49094260    868  11020    0    0     0     4 1616  264  0 
  0 100  0  0
  0  0      0 49094384    876  11020    0    0     0     8 1614  262  0 
  0 100  0  0
  0  0      0 49094320    876  11020    0    0     0     0 1614  271  0 
  0 100  0  0
  0  0      0 49094332    884  11020    0    0     0    10 1619  275  0 
  0 100  0  0
  1  0      0 45504692    884  11020    0    0 647582 24578 57587 68969 
  8  4 84  3  0
  1  1      0 45481944    892  11020    0    0  2436     9 2232 1490  6 
  0 94  0  0
  1  0      0 45478984    892  11020    0    0   306     7 1698  423  6 
  0 94  0  0
  1  0      0 45477620    900  11020    0    0   134    10 1656  344  6 
  0 94  0  0
  1  0      0 45476380    900  11020    0    0   106     0 1643  322  6 
  0 94  0  0
  1  0      0 45475264    908  11020    0    0    90     6 1642  314  6 
  0 94  0  0
  1  0      0 45474396    908  11020    0    0    76     4 1638  308  6 
  0 94  0  0
  1  0      0 45473528    916  11020    0    0    74     6 1639  308  6 
  0 94  0  0
  1  0      0 45472784    916  11020    0    0    66     0 1634  301  6 
  0 94  0  0
  0  1      0 45471544    924  11020    0    0   174    10 1666  359  6 
  0 94  1  0
  1  0      0 45470428    924  11020    0    0   179     4 1667  364  4 
  0 94  2  0
  1  0      0 45469684    932  11020    0    0   114     6 1648  327  5 
  0 94  2  0
  1  0      0 45469188    932  11020    0    0    94     0 1639  315  5 
  0 94  1  0
  1  0      0 45468692    940  11020    0    0    85     6 1640  312  5 
  0 94  1  0
  0  1      0 45467328    940  11020    0    0   246     0 1677  391  4 
  0 94  3  0
  1  0      0 45466584    948  11020    0    0   135     6 1653  337  5 
  0 94  2  0
procs -----------memory---------- ---swap-- -----io---- --system-- 
-----cpu------
  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy 
id wa st
  1  0      0 45465964    952  11016    0    0   101     2 1641  318  5 
  0 94  1  0
  1  0      0 45465468    956  11020    0    0    88     7 1644  314  5 
  0 94  1  0
  1  0      0 45464972    964  11020    0    0    80     6 1640  313  5 
  0 94  1  0
  1  4      0 43957340    964  11020    0    0 251558     0 14506 21971 
  4  1 87  8  0
  0  1      0 43732652    972  11020    0    0 75435     6 2454 1011  1 
  0 90  9  0
  0  1      0 43728312    972  11020    0    0   355     0 1704  443  1 
  0 94  5  0
  0  1      0 43724220    980  11020    0    0   310     6 1697  431  1 
  0 94  5  0
  0  1      0 43721244    980  11020    0    0   315     0 1694  423  0 
  0 94  6  0
  0  1      0 43719508    988  11020    0    0   325    11 1703  438  1 
  0 94  5  0
  0  5      0 43475228    988  11020    0    0  7897     4 5164 2114  2 
  0 92  5  0
  0  1      0 43239876    996  11020    0    0 81598     6 2387  967  1 
  0 90  9  0
  0  1      0 43234048    996  11020    0    0   378     0 1710  455  1 
  0 94  6  0
  0  1      0 42899620   1004  11020    0    0 63013     6 3309 3314  2 
  0 93  5  0
  0  5      0 42643932   1004  11020    0    0 48565     0 2664 2174  1 
  0 92  7  0
  1  0      0 42390972   1012  11020    0    0 47660     6 2905 1949  1 
  0 92  6  0
  1  0      0 42389236   1012  11020    0    0   237     4 1679  388  4 
  0 94  2  0
  0  1      0 42373472    324   9724    0    0  2662    34 1786  584  1 
  0 94  5  0
  0  1      0 42367004    348   9740    0    0   333    10 1704  445  0 
  0 94  6  0
  0  1      0 42362664    348   9740    0    0   326     0 1698  435  0 
  0 94  6  0
  0  1      0 42358944    356   9740    0    0   326     6 1702  434  0 
  0 94  6  0
  0  1      0 42354728    356   9740    0    0   758     0 1705  437  0 
  0 94  6  0
procs -----------memory---------- ---swap-- -----io---- --system-- 
-----cpu------
  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy 
id wa st
  1  4      0 42313932    364   9740    0    0  6844     6 2211  765  0 
  0 93  6  0
  0  5      0 41600312    364   9740    0    0 126161     6 8847 7009  2 
  1 89  8  0
  1  0      0 40934052    372   9744    0    0 141561    20 16966 12097 
  3  1 88  8  0
  0  1      0 40546056    372   9744    0    0 75141     0 4493 3544  2 
  0 91  7  0
  0  5      0 40097548    380   9744    0    0 83139     6 11961 5714  2 
  1 89  8  0
  1  4      0 39235500    380   9744    0    0 162830     0 21207 15579 
  3  1 88  9  0
  1  4      0 36952660    388   9744    0    0 470646     6 73141 48593 
  6  3 77 15  0
  0  5      0 36735288    400   9744    0    0 41452     0 6851 2697  1 
  1 86 13  0
  3  3      0 35785820    408   9744    0    0 134878    10 33292 18313 
  3  1 85 10  0
  1  4      0 35285976    408   9744    0    0 171517     0 9015 5008  1 
  1 85 13  0
  0  1      0 35154040    416   9744    0    0 336041    10 4593 2815  2 
  1 86 12  0
  0  1      0 35145980    416   9744    0    0   309     0 1770  426  0 
  0 94  6  0
  0  1      0 35141268    424   9744    0    0   279     6 1758  412  3 
  0 94  3  0
  0  1      0 35140028    424   9744    0    0   198     0 1715  366  3 
  0 94  3  0
  1  0      0 35138540    432   9744    0    0   240     6 1740  391  3 
  0 94  3  0
  1  0      0 35135688    432   9744    0    0   232     4 1733  388  3 
  0 94  3  0
  0  1      0 35130480    440   9744    0    0   352     6 1795  446  1 
  0 94  5  0
  0  1      0 35127628    444   9744    0    0   375     0 1802  455  0 
  0 94  6  0
  0  1      0 35118576    452   9744    0    0   346    10 1792  446  2 
  0 94  4  0
  0  1      0 35114484    452   9744    0    0   514     0 1872  528  0 
  0 94  6  0
  0  1      0 35111260    460   9744    0    0   329     6 1782  434  0 
  0 94  6  0
procs -----------memory---------- ---swap-- -----io---- --system-- 
-----cpu------
  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy 
id wa st
  0  1      0 35108408    464   9740    0    0   338     2 1785  438  1 
  0 94  6  0
  0  1      0 35105432    468   9744    0    0   361     7 1800  451  1 
  0 94  6  0
  0  1      0 35102828    476   9744    0    0   326     6 1783  439  0 
  0 94  6  0
  0  1      0 35099852    476   9744    0    0   365     0 1797  450  0 
  0 94  6  0
  0  1      0 35097000    484   9744    0    0   362     6 1800  453  0 
  0 94  6  0
  0  1      0 35094272    484   9744    0    0   371     0 1801  456  1 
  0 94  6  0
  0  1      0 35091172    492   9744    0    0   355     6 1798  452  0 
  0 94  6  0
  0  1      0 35088320    492   9744    0    0   355     0 1792  444  1 
  0 94  6  0
  0  1      0 35085716    500   9744    0    0   346    10 1794  447  1 
  0 94  6  0
  0  1      0 35083112    500   9744    0    0   344     0 1786  441  1 
  0 94  6  0
  0  1      0 35080136    508   9744    0    0   341     6 1789  445  0 
  0 94  6  0
  1  0      0 35077408    508   9744    0    0   345     0 1787  440  0 
  0 94  6  0
  0  1      0 35074556    516   9744    0    0   372    10 1810  462  0 
  0 94  6  0
  0  1      0 35071704    516   9744    0    0   338     0 1785  437  0 
  0 94  6  0
  0  1      0 35069224    524   9744    0    0   306     6 1771  427  1 
  0 94  6  0
  1  0      0 35066992    524   9744    0    0   305     4 1769  423  1 
  0 94  6  0
  0  5      0 35026196    532   9744    0    0 127340     6 3111 3127  2 
  0 89  9  0
  0  1      0 35013052    540   9744    0    0 113392     6 2554 2902  2 
  0 90  8  0
  0  1      0 35010200    540   9744    0    0 16826     0 1854  891  1 
  0 94  6  0
  0  1      0 35005860    548   9744    0    0 28107     6 2006 1215  0 
  0 93  7  0
  0  5      0 34971388    548   9744    0    0 82062     4 3487 4203  2 
  0 87 10  0
procs -----------memory---------- ---swap-- -----io---- --system-- 
-----cpu------
  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy 
id wa st
  0  5      0 34900836    556   9744    0    0 395478   433 4399 3190  3 
  1 83 14  0
  0  1      0 34876656    556   9744    0    0 40074     4 2049  765  1 
  0 91  8  0
  0  1      0 34872564    564   9744    0    0   300    10 1696  423  1 
  0 94  5  0
  0  1      0 34869836    564   9744    0    0   334     0 1699  437  1 
  0 94  6  0
  0  1      0 34867480    572   9744    0    0   329     6 1700  434  1 
  0 94  5  0
  0  1      0 34865000    572   9748    0    0   311     0 1693  424  0 
  0 94  6  0

... (after 30 minutes)

1  0      0 34250164    540   9492    0    0     3     8 1619  285  6  0 
94  0  0
  1  0      0 34249920    548   9492    0    0     4     4 1618  288  6 
  0 94  0  0
  1  0      0 34249920    548   9500    0    0     5     2 1617  289  6 
  0 94  0  0
procs -----------memory---------- ---swap-- -----io---- --system-- 
-----cpu------
  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy 
id wa st
  1  0      0 34249920    556   9500    0    0     4    14 1624  293  6 
  0 94  0  0
  1  0      0 34249796    564   9504    0    0     3     8 1620  286  6 
  0 94  0  0
  1  0      0 34249800    572   9504    0    0     4     6 1619  290  6 
  0 94  0  0
  1  0      0 34249676    580   9504    0    0     5     6 1622  293  6 
  0 94  0  0
  1  0      0 34255388    588   9508    0    0     4     6 1618  289  6 
  0 94  0  0
  1  0      0 34255388    608   9500    0    0    43     9 1624  304  6 
  0 94  0  0
  1  0      0 34255080    616   9692    0    0     4     6 1619  289  6 
  0 94  0  0
  1  0      0 34255080    624   9692    0    0     4    16 1623  288  6 
  0 94  0  0
  1  0      0 34254956    632   9688    0    0     4     8 1619  286  6 
  0 94  0  0
  1  0      0 34254836    640   9692    0    0     3     4 1617  281  6 
  0 94  0  0
  1  0      0 34254836    640   9696    0    0     4     2 1617  285  6 
  0 94  0  0
  1  0      0 34254836    648   9696    0    0     3    10 1620  286  6 
  0 94  0  0
  1  0      0 34254712    656   9700    0    0     5     8 1620  290  6 
  0 94  0  0
  1  0      0 34254716    664   9700    0    0     4     6 1619  286  6 
  0 94  0  0

==========x8

8x========== strace output for
# nohup strace -p 16623 -ttt -T > strace.out 2>&1 &

1326216486.322990 pread(4, 
"BMAP\0\0\0\376\0\0\0\0r\\\310@\0\0\0\0\v\367\342\271\0\0\0BQ\33j\0"..., 
4096, 7859072671744) = 4096 <0.010081>
1326216487.813946 mprotect(0x7fe40cfe7000, 4096, PROT_READ|PROT_WRITE) = 
0 <0.000028>
1326216487.814068 pread(4, 
"BMAP\0\0\0\260\0\0\0\0r]T\242\0\0\0\0r]\323O\0\0\0BQ\270f\0"..., 4096, 
822455537664) = 4096 <0.017904>
1326216488.866388 mprotect(0x7fe40cfe8000, 4096, PROT_READ|PROT_WRITE) = 
0 <0.000023>
1326216488.866519 pread(4, 
"BMAP\0\0\0\376\0\0\0\0\v\367\342\271\0\0\0\0r]t\317\0\0\0BR\35\350\0"..., 
4096, 7859205500928) = 4096 <0.009517>
1326216490.356207 mprotect(0x7fe40cfe9000, 4096, PROT_READ|PROT_WRITE) = 
0 <0.000033>
1326216490.356330 pread(4, 
"BMAP\0\0\0\376\0\0\0\0r]\323O\0\0\0\0ri\357\305\0\0\0BS\301\300\0"..., 
4096, 7859106410496) = 4096 <0.010006>
1326216491.846474 mprotect(0x7fe40cfea000, 4096, PROT_READ|PROT_WRITE) = 
0 <0.000030>
1326216491.846590 pread(4, 
"BMAP\0\0\0\201\0\0\0\0r]t\317\0\0\0\0rj'\7\0\0\0Bl\321j\0"..., 4096, 
7862456569856) = 4096 <0.012849>
1326216492.611395 mprotect(0x7fe40cfeb000, 4096, PROT_READ|PROT_WRITE) = 
0 <0.000032>
1326216492.611518 pread(4, 
"BMAP\0\0\0\200\0\0\0\0ri\357\305\0\0\0\0\v\371R\374\0\0\0Bm\236f\0"..., 
4096, 7862514511872) = 4096 <0.011286>
1326216493.369264 mprotect(0x7fe40cfec000, 8192, PROT_READ|PROT_WRITE) = 
0 <0.000028>
1326216493.369388 pread(4, 
"BMAP\0\0\0\376\0\0\0\0rj'\7\0\0\0\0\v\371\220\230\0\0\0Bm\351N\0"..., 
4096, 822841688064) = 4096 <0.014758>
1326216494.873466 mprotect(0x7fe40cfee000, 4096, PROT_READ|PROT_WRITE) = 
0 <0.000030>
1326216494.873586 pread(4, 
"BMAP\0\0\0\223\0\0\0\0\v\371R\374\0\0\0\0\v\372#\237\0\0\0BnqT\0"..., 
4096, 822906290176) = 4096 <0.011972>
1326216495.742900 mprotect(0x7fe40cfef000, 4096, PROT_READ|PROT_WRITE) = 
0 <0.000031>
1326216495.743018 pread(4, 
"BMAP\0\0\0\376\0\0\0\0\v\371\220\230\0\0\0\0\v\371\315\370\0\0\0Bn\316V\0"..., 
4096, 823060459520) = 4096 <0.014324>
1326216497.238220 mprotect(0x7fe40cff0000, 4096, PROT_READ|PROT_WRITE) = 
0 <0.000032>
1326216497.238347 pread(4, 
"BMAP\0\0\0\204\0\0\0\0\v\372#\237\0\0\0\0\v\372\357I\0\0\0Bom \0"..., 
4096, 822970646528) = 4096 <0.014281>
1326216498.022466 mprotect(0x7fe40cff1000, 4096, PROT_READ|PROT_WRITE) = 
0 <0.000032>
1326216498.022584 pread(4, 
"BMAP\0\1\0\376\0\0\0\0r\21N=\0\0\0\0\f\200+\217\0\0\0\0!7\347S"..., 
4096, 823104323584) = 4096 <0.011951>
1326216498.034632 mprotect(0x7fe40cff2000, 4096, PROT_READ|PROT_WRITE) = 
0 <0.000023>
1326216498.034712 pread(4, 
"BMAP\0\0\0\210\0\0\0\0\v\371\315\370\0\0\0\0\v\372Ms\0\0\0Bo\316\246\0"..., 
4096, 823274016768) = 4096 <0.015055>
1326216498.843386 mprotect(0x7fe40cff3000, 4096, PROT_READ|PROT_WRITE) = 
0 <0.000033>
1326216498.843504 pread(4, 
"BMAP\0\0\0\376\0\0\0\0\v\372\357I\0\0\0\0\v\372\225c\0\0\0Bp'4\0"..., 
4096, 823104319488) = 4096 <0.015296>
1326216500.339933 mprotect(0x7fe40cff4000, 4096, PROT_READ|PROT_WRITE) = 
0 <0.000022>
1326216500.340026 pread(4, 
"BMAP\0\0\0\201\0\0\0\0\v\372Ms\0\0\0\0rjU\251\0\0\0Bp\312\24\0"..., 
4096, 823179751424) = 4096 <0.009657>
1326216501.101929 mprotect(0x7fe40cff5000, 8192, PROT_READ|PROT_WRITE) = 
0 <0.000029>
1326216501.102049 pread(4, 
"BMAP\0\0\0\201\0\0\0\0\v\372\225c\0\0\0\0\v\372\320<\0\0\0Bq\23\244\0"..., 
4096, 7862563409920) = 4096 <0.016088>
1326216501.871373 mprotect(0x7fe40cff7000, 4096, PROT_READ|PROT_WRITE) = 
0 <0.000030>
1326216501.871494 pread(4, 
"BMAP\0\0\0\376\0\0\0\0rjU\251\0\0\0\0\v\373\20\341\0\0\0BqG\200\0"..., 
4096, 823241457664) = 4096 <0.010275>
1326216503.364635 mprotect(0x7fe40cff8000, 4096, PROT_READ|PROT_WRITE) = 
0 <0.000031>
1326216503.364755 pread(4, 
"BMAP\0\0\0\200\0\0\0\0\v\372\320<\0\0\0\0\v\373\355\360\0\0\0Bq\303\242\0"..., 
4096, 823309242368) = 4096 <0.016705>
1326216504.128107 mprotect(0x7fe40cff9000, 4096, PROT_READ|PROT_WRITE) = 
0 <0.000028>
1326216504.128232 pread(4, 
"BMAP\0\0\0\236\0\0\0\0\v\373\20\341\0\0\0\0\v\373f\25\0\0\0Br\37D\0"..., 4096, 
823541039104) = 4096 <0.017153>
1326216505.076279 mprotect(0x7fe40cffa000, 4096, PROT_READ|PROT_WRITE) = 
0 <0.000033>
1326216505.076395 pread(4, 
"BMAP\0\0\0\376\0\0\0\0\v\373\355\360\0\0\0\0\v\373\246i\0\0\0Br|\246\0"..., 
4096, 823398584320) = 4096 <0.017912>
1326216506.576563 mprotect(0x7fe40cffb000, 4096, PROT_READ|PROT_WRITE) = 
0 <0.000031>
1326216506.576682 pread(4, 
"BMAP\0\0\0\220\0\0\0\0\v\373f\25\0\0\0\0\v\374\1774\0\0\0Bs!H\0"..., 
4096, 823466037248) = 4096 <0.011574>
1326216507.429031 mprotect(0x7fe40cffc000, 4096, PROT_READ|PROT_WRITE) = 
0 <0.000033>
1326216507.429174 pread(4, 
"BMAP\0\0\0\303\0\0\0\0\v\373\246i\0\0\0\0\v\373\357/\0\0\0Bs~\346\0"..., 4096, 
823693361152) = 4096 <0.014163>
1326216508.580628 mprotect(0x7fe40cffd000, 4096, PROT_READ|PROT_WRITE) = 
0 <0.000029>
1326216508.580747 pread(4, 
"BMAP\0\0\0\376\0\0\0\0\v\374\1774\0\0\0\0\v\3746\372\0\0\0Bs\361P\0"..., 4096, 
823542345728) = 4096 <0.018541>
1326216510.081415 mprotect(0x7fe40cffe000, 8192, PROT_READ|PROT_WRITE) = 
0 <0.000029>
1326216510.081540 pread(4, 
"BMAP\0\0\0\235\0\0\0\0\v\373\357/\0\0\0\0\v\375&\346\0\0\0Bt\212b\0"..., 4096, 
823617626112) = 4096 <0.014412>
1326216511.012066 mprotect(0x7fe40d000000, 4096, PROT_READ|PROT_WRITE) = 
0 <0.000033>
1326216511.012190 pread(4, 
"BMAP\0\0\0\313\0\0\0\0\v\3746\372\0\0\0\0\v\374t\263\0\0\0Bt\312\24\0"..., 
4096, 823869202432) = 4096 <0.011888>
1326216512.208978 mprotect(0x7fe40d001000, 4096, PROT_READ|PROT_WRITE) = 
0 <0.000030>
1326216512.209100 pread(4, 
"BMAP\0\0\0\376\0\0\0\0\v\375&\346\0\0\0\0\v\374\304\346\0\0\0Bu9,\0"..., 4096, 
823682347008) = 4096 <0.015123>
1326216513.706751 mprotect(0x7fe40d002000, 4096, PROT_READ|PROT_WRITE) = 
0 <0.000032>
1326216513.706873 pread(4, 
"BMAP\0\0\0\237\0\0\0\0\v\374t\263\0\0\0\0\v\375\255\0\0\0\0Bu\257\354\0"..., 
4096, 823766441984) = 4096 <0.015348>
1326216514.650434 mprotect(0x7fe40d003000, 4096, PROT_READ|PROT_WRITE) = 
0 <0.000027>
1326216514.650554 pread(4, 
"BMAP\0\0\0\271\0\0\0\0\v\374\304\346\0\0\0\0\v\375\6\263\0\0\0Bv\f\202\0"..., 
4096, 824009818112) = 4096 <0.008932>
1326216515.739710 mprotect(0x7fe40d004000, 4096, PROT_READ|PROT_WRITE) = 
0 <0.000029>
1326216515.739834 pread(4, 
"BMAP\0\0\0\376\0\0\0\0\v\375\255\0\0\0\0\0\211f\332_\0\0\0Bvr\324\0"..., 4096, 
823835439104) = 4096 <0.019711>
1326216517.242497 mprotect(0x7fe40d005000, 4096, PROT_READ|PROT_WRITE) = 
0 <0.000031>
1326216517.242618 pread(4, 
"BMAP\0\0\0\214\0\0\0\0\v\375\6\263\0\0\0\0\v\376i\317\0\0\0Bw\32\320\0"..., 
4096, 9442176659456) = 4096 <0.012487>
1326216518.072182 mprotect(0x7fe40d006000, 4096, PROT_READ|PROT_WRITE) = 
0 <0.000029>
1326216518.072303 pread(4, 
"BMAP\0\0\0\253\0\0\0\0\211f\332_\0\0\0\0\215\30W\303\0\0\0BwT\254\0"..., 4096, 
824207798272) = 4096 <0.013816>
1326216519.084891 mprotect(0x7fe40d007000, 8192, PROT_READ|PROT_WRITE) = 
0 <0.000031>
1326216519.085008 pread(4, 
"BMAP\0\0\0\376\0\0\0\0\v\376i\317\0\0\0\0\v\375\352p\0\0\0Bw\262d\0"..., 4096, 
9695979646976) = 4096 <0.014198>
1326216520.581764 mprotect(0x7fe40d009000, 4096, PROT_READ|PROT_WRITE) = 
0 <0.000030>
1326216520.581881 pread(4, 
"BMAP\0\0\0\177\0\0\0\0\215\30W\303\0\0\0\0rj\230 \0\0\0Bxa\266\0"..., 
4096, 824074240000) = 4096 <0.012057>
1326216521.335842 mprotect(0x7fe40d00a000, 4096, PROT_READ|PROT_WRITE) = 
0 <0.000031>
1326216521.335962 pread(4, 
"BMAP\0\0\0\376\0\0\0\0\v\375\352p\0\0\0\0\v\376F\310\0\0\0Bx\253\24\0"..., 
4096, 7862633103360) = 4096 <0.012886>
1326216522.832068 mprotect(0x7fe40d00b000, 4096, PROT_READ|PROT_WRITE) = 
0 <0.000029>
1326216522.832189 pread(4, "BMAP\0\0\0\376\0\0\0\0rj\230 
\0\0\0\0\216\261\21\313\0\0\0By\351\0\0"..., 4096, 824171069440) = 4096 
<0.015956>
1326216524.331849 mprotect(0x7fe40d00c000, 4096, PROT_READ|PROT_WRITE) = 
0 <0.000033>
1326216524.331975 pread(4, 
"BMAP\0\0\0\376\0\0\0\0\v\376F\310\0\0\0\0\v\377\210\237\0\0\0B{\237\300\0"..., 
4096, 9805696380928) = 4096 <0.012498>
1326216525.828539 mprotect(0x7fe40d00d000, 4096, PROT_READ|PROT_WRITE) = 
0 <0.000029>
1326216525.828659 pread(4, 
"BMAP\0\0\0\266\0\0\0\0\216\261\21\313\0\0\0\0rp2:\0\0\0B\206\243:\0"..., 4096, 
824508542976) = 4096 <0.005462>
1326216526.897970 mprotect(0x7fe40d00e000, 4096, PROT_READ|PROT_WRITE) = 
0 <0.000031>
1326216526.898094 pread(4, 
"BMAP\0\0\0\376\0\0\0\0\v\377\210\237\0\0\0\0\f\21.7\0\0\0B\246\324\"\0"..., 
4096, 7864136867840) = 4096 <0.009157>
1326216528.390700 mprotect(0x7fe40d00f000, 4096, PROT_READ|PROT_WRITE) = 
0 <0.000028>
1326216528.390822 pread(4, 
"BMAP\0\0\0\203\0\0\0\0rp2:\0\0\0\0\f\22\240\370\0\0\0B\252\332\22\0"..., 4096, 
829245583360) = 4096 <0.014973>
1326216529.171630 mprotect(0x7fe40d010000, 8192, PROT_READ|PROT_WRITE) = 
0 <0.000032>
1326216529.171750 pread(4, 
"BMAP\0\0\0\234\0\0\0\0\f\21.7\0\0\0\0\f\22%?\0\0\0B\253\2174\0"..., 
4096, 829634347008) = 4096 <0.012732>
1326216530.095737 mprotect(0x7fe40d012000, 4096, PROT_READ|PROT_WRITE) = 
0 <0.000032>
1326216530.095856 pread(4, 
"BMAP\0\0\0\376\0\0\0\0\f\22\240\370\0\0\0\0\f\23\243\232\0\0\0B\254g\360\0"..., 
4096, 829504614400) = 4096 <0.017642>
1326216531.597565 mprotect(0x7fe40d013000, 4096, PROT_READ|PROT_WRITE) = 
0 <0.000031>
1326216531.597683 pread(4, 
"BMAP\0\0\0\261\0\0\0\0\f\22%?\0\0\0\0\f\23\301\353\0\0\0B\255\263\212\0"..., 
4096, 829905543168) = 4096 <0.012275>
1326216532.644040 mprotect(0x7fe40d014000, 4096, PROT_READ|PROT_WRITE) = 
0 <0.000030>
1326216532.644162 pread(4, 
"BMAP\0\0\0\210\0\0\0\0\f\23\243\232\0\0\0\0\f\22\374\322\0\0\0B\256\202\24\0"..., 
4096, 829937332224) = 4096 <0.011165>
1326216533.450555 mprotect(0x7fe40d015000, 4096, PROT_READ|PROT_WRITE) = 
0 <0.000027>
1326216533.450677 pread(4, 
"BMAP\0\0\0\376\0\0\0\0\f\23\301\353\0\0\0\0\f\24>\245\0\0\0B\257]\6\0"..., 
4096, 829730660352) = 4096 <0.011231>
1326216534.946533 mprotect(0x7fe40d016000, 4096, PROT_READ|PROT_WRITE) = 
0 <0.000032>
1326216534.946653 pread(4, 
"BMAP\0\0\0\264\0\0\0\0\f\22\374\322\0\0\0\0\f\26\230!\0\0\0B\261\226\330\0"..., 
4096, 830068117504) = 4096 <0.011953>
1326216536.010196 mprotect(0x7fe40d017000, 4096, PROT_READ|PROT_WRITE) = 
0 <0.000028>
1326216536.010308 pread(4, 
"BMAP\0\0\0\376\0\0\0\0\f\24>\245\0\0\0\0\f\26<\246\0\0\0B\262\371R\0"..., 
4096, 830698819584) = 4096 <0.014615>
1326216537.509542 mprotect(0x7fe40d018000, 4096, PROT_READ|PROT_WRITE) = 
0 <0.000030>
1326216537.509665 pread(4, 
"BMAP\0\0\0\177\0\0\0\0\f\26\230!\0\0\0\0\f\30\32\36\0\0\0B\264\2260\0"..., 
4096, 830602895360) = 4096 <0.016656>
1326216538.268615 mprotect(0x7fe40d019000, 8192, PROT_READ|PROT_WRITE) = 
0 <0.000033>
1326216538.268743 pread(4, 
"BMAP\0\0\0\376\0\0\0\0\f\26<\246\0\0\0\0\f\0306\336\0\0\0B\265f\n\0"..., 4096, 
831103557632) = 4096 <0.015820>
1326216539.777465 mprotect(0x7fe40d01b000, 4096, PROT_READ|PROT_WRITE) = 
0 <0.000032>
1326216539.777582 pread(4, 
"BMAP\0\0\0\220\0\0\0\0\f\30\32\36\0\0\0\0\f\34\312\215\0\0\0B\267C^\0"..., 
4096, 831133704192) = 4096 <0.018219>
1326216540.637506 mprotect(0x7fe40d01c000, 4096, PROT_READ|PROT_WRITE) = 
0 <0.000030>
1326216540.637626 pread(4, 
"BMAP\0\0\0\311\0\0\0\0\f\0306\336\0\0\0\0rp\216\374\0\0\0B\270sV\0"..., 
4096, 832362303488) = 4096 <0.011067>
1326216541.823721 mprotect(0x7fe40d01d000, 4096, PROT_READ|PROT_WRITE) = 
0 <0.000030>
1326216541.823839 pread(4, 
"BMAP\0\0\0\376\0\0\0\0\f\34\312\215\0\0\0\0rp\302F\0\0\0B\271\320,\0"..., 
4096, 7864234131456) = 4096 <0.015157>


==========x8

[root@jr4-4 ~]# uname -r
2.6.32.41.scalable


Let me know if you need anything else.

> Cheers,
>
> Dave.


-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/sicluster
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
