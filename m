Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 085BE7F4E
	for <xfs@oss.sgi.com>; Thu, 17 Sep 2015 14:21:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9A09AAC003
	for <xfs@oss.sgi.com>; Thu, 17 Sep 2015 12:21:09 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id DCY9bWKwTaNaTuRd (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 17 Sep 2015 12:21:05 -0700 (PDT)
Date: Thu, 17 Sep 2015 15:21:03 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: xfsxyncd in 'D' state
Message-ID: <20150917192102.GA5342@bfoster.bfoster>
References: <2CC86DBF85FEEC41A2DFE1647B40613D5DAF2CA0@NCB-SV-117.DUCOM.edu>
	<2CC86DBF85FEEC41A2DFE1647B40613D5DAF2DB8@NCB-SV-117.DUCOM.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <2CC86DBF85FEEC41A2DFE1647B40613D5DAF2DB8@NCB-SV-117.DUCOM.edu>
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
To: "Earl, Joshua P" <Joshua.Earl@DrexelMed.edu>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, Sep 17, 2015 at 04:45:03PM +0000, Earl, Joshua P wrote:
> Anyone have any ideas on this?  Is this the right mailing list?  It looks like the email I sent with attachments didn't go through, should I copy and paste the outputs into an email?  We are pretty crippled without the use of this drive, and it took several weeks to figure out that it was this process going into uninterruptible sleep that was the 'cause'.   I don't know what causes this however, I'm not sure how to track that down.  There doesn't seem to be anything accessing the drive as far as processes go... but on a clean reboot within about 5 minutes this pops up:
> 

Were the attachments large? You could try to compress them or perhaps
host them somewhere and post a link.

(Also, please try not to top-post).

> root      2216  0.0  0.0      0     0 ?        D    12:24   0:00 [xfssyncd/sdb1]
> 
> And we are dead in the water until it lets go, which is currently hours later.  When we first experienced this problem it would only take a few minutes to get back to a writable state.
> 

That is responsible for writing out metadata and things on older
kernels. When was this problem "first experienced" as opposed to the
current state? Did performance drop off slowly or rapidly?

> Any help would be greatly appreciated!
> 
> Thanks,
> ~josh
> 
> From: xfs-bounces@oss.sgi.com [mailto:xfs-bounces@oss.sgi.com] On Behalf Of Earl, Joshua P
> Sent: Wednesday, September 16, 2015 12:50 PM
> To: xfs@oss.sgi.com
> Subject: RE: xfsxyncd in 'D' state
> 
> I was also able to get the xfs_info after finally getting the drive remounted:
> 
> [root@ncb-sv-016 ~]# xfs_info /home
> meta-data=/dev/sdb1              isize=256    agcount=70, agsize=268435455 blks
>          =                       sectsz=512   attr=2, projid32bit=0
> data     =                       bsize=4096   blocks=18554637056, imaxpct=1
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=521728, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 

So this is a 70TB fs with what looks like mostly default settings. Note
that no stripe unit/width are set, fwiw.

I don't see current fs utilization (df, df -i) or mount options reported
anywhere. Can you provide that information?

> From: Earl, Joshua P
> Sent: Tuesday, September 15, 2015 1:53 PM
> To: 'xfs@oss.sgi.com' <xfs@oss.sgi.com<mailto:xfs@oss.sgi.com>>
> Subject: xfsxyncd in 'D' state
> 
> Hello, I hope I'm writing to the correct list.  I've recently run into a problem, which has me stumped.  I'm running a cluster which shares an xfs filesystem to 10 nodes via nfs.  This has been working for almost two years.  However, I've been running into trouble with the drive where if anything tries to write to it at certain times it will simply hang, and every process trying to write will also hang and go into the 'D' state.  For example (just editing a text file with emacs):
> 

You haven't really described the workload either. If not much is going
on from the server itself, what are those 10 nfs clients doing when this
occurs? In general, the more information you provide about the
environment and workload, the more likely other folks here who might be
more familiar with NFS and/or hwraid might chime in with suggestions.

Not being an NFS expert myself, I'd probably unexport the filesystem,
mount it locally and run some tests there to see what seems to induce
this behavior, if anything. For example, what happens if existing files
are read or directories listed? In terms of writes, does a sequential
file writer have reasonable performance (dd)? Can you allocate inodes
(e.g., create a temp dir somewhere and run a 'touch' loop to create new
files) without any issues? You could also try to untar a tarball, run a
short fio/fsstress/whatever workload, etc.

If nothing seems to trigger it locally, I'd start to look at adding back
the clients to try identify contributors.

> [root@ncb-sv-016 ~]# ps aux|grep D
> USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
> root      2216  0.0  0.0      0     0 ?        D    11:28   0:00 [xfssyncd/sdb1]
> archana   7708  0.0  0.0 249700 13352 pts/0    D    11:35   0:00 emacs things
> root     11453  0.0  0.0 103312   868 pts/1    S+   12:47   0:00 grep D
> 

What's the stack trace for the emacs process when this occurs? I suspect
it would eventually get dumped to the logs as a stalled task, but
/proc/<pid>/stack should show it as well.

> This will remain like this for hours.  Can't remount/unmount drive (sends the unmount command into 'D' state)
> 
> I have no idea what's going on or how to fix it, but I'm hoping you guys might be able to point me in the right direction. Here is the info that's requested in the FAQ:
> ?  kernel version (uname -a)
> Linux ncb-sv-016.ducom.edu 2.6.32-358.23.2.el6.x86_64 #1 SMP Wed Oct 16 18:37:12 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
> ?  xfsprogs version (xfs_repair -V)
> xfs_repair version 3.1.1
> ?  number of CPUs
> 16
> ?  contents of /proc/meminfo
> ?  contents of /proc/mounts
> ?  contents of /proc/partitions
> Attached except for mounts (not currently in the /proc directory, attached the fstab instead (hopefully helpful?)
> ?  RAID layout (hardware and/or software) The RAID-6 is the problem one
> Unit  UnitType  Status         %RCmpl  %V/I/M  Stripe  Size(GB)  Cache  AVrfy
> ------------------------------------------------------------------------------
> u0    RAID-1    OK             -       -       -       3725.28   RiW    ON
> u1    RAID-6    OK             -       -       64K     70780.3   RiW    ON
> u2    SPARE     OK             -       -       -       3726.01   -      OFF
> 
> VPort Status         Unit Size      Type  Phy Encl-Slot    Model
> ------------------------------------------------------------------------------
> p8    OK             u0   3.63 TB   SATA  -   /c0/e0/slt0  WDC WD4000FYYZ-01UL
> p9    OK             u1   3.63 TB   SATA  -   /c0/e0/slt4  WDC WD4000FYYZ-01UL
> p10   OK             u1   3.63 TB   SATA  -   /c0/e0/slt8  WDC WD4000FYYZ-01UL
> p11   OK             u1   3.63 TB   SATA  -   /c0/e0/slt12 WDC WD4000FYYZ-01UL
> p12   OK             u1   3.63 TB   SATA  -   /c0/e0/slt16 WDC WD4000FYYZ-01UL
> p13   OK             u1   3.63 TB   SATA  -   /c0/e0/slt20 WDC WD4000FYYZ-01UL
> p14   OK             u0   3.63 TB   SATA  -   /c0/e0/slt1  WDC WD4000FYYZ-01UL
> p15   OK             u1   3.63 TB   SATA  -   /c0/e0/slt5  WDC WD4000FYYZ-01UL
> p16   OK             u1   3.63 TB   SATA  -   /c0/e0/slt9  WDC WD4000FYYZ-01UL
> p17   OK             u1   3.63 TB   SATA  -   /c0/e0/slt13 WDC WD4000FYYZ-01UL
> p18   OK             u1   3.63 TB   SATA  -   /c0/e0/slt17 WDC WD4000FYYZ-01UL
> p19   OK             u1   3.63 TB   SATA  -   /c0/e0/slt21 WDC WD4000FYYZ-01UL
> p20   OK             u1   3.63 TB   SATA  -   /c0/e0/slt2  WDC WD4000FYYZ-01UL
> p21   OK             u1   3.63 TB   SATA  -   /c0/e0/slt6  WDC WD4000FYYZ-01UL
> p22   OK             u1   3.63 TB   SATA  -   /c0/e0/slt10 WDC WD4000FYYZ-01UL
> p23   OK             u1   3.63 TB   SATA  -   /c0/e0/slt14 WDC WD4000FYYZ-01UL
> p24   OK             u1   3.63 TB   SATA  -   /c0/e0/slt18 WDC WD4000FYYZ-01UL
> p25   OK             u1   3.63 TB   SATA  -   /c0/e0/slt22 WDC WD4000FYYZ-01UL
> p26   OK             u1   3.63 TB   SATA  -   /c0/e0/slt3  WDC WD4000FYYZ-01UL
> p27   OK             u1   3.63 TB   SATA  -   /c0/e0/slt7  WDC WD4000FYYZ-01UL
> p28   OK             u1   3.63 TB   SATA  -   /c0/e0/slt11 WDC WD4000FYYZ-01UL
> p29   OK             u1   3.63 TB   SATA  -   /c0/e0/slt15 WDC WD4000FYYZ-01UL
> p30   OK             u1   3.63 TB   SATA  -   /c0/e0/slt19 WDC WD4000FYYZ-01UL
> p31   OK             u2   3.63 TB   SATA  -   /c0/e0/slt23 WDC WD4000FYYZ-01UL

That's a 21 disk raid6, which seems like a high spindle count for a
stripe geometry like raid6 to me. I guess it depends on the use case.
Was this always the geometry of the array or was it grown over time?

> ?  LVM configuration
> I don't *think* these are in an LVM.. I could be wrong.
> ?  type of disks you are using
> Models included above in raid config.
> ?  write cache status of drives
> ?  size of BBWC and mode it is running in
> ?  xfs_info output on the filesystem in question
> For the above three questions I'm not sure how to get the the cache status of the drives, or what the BBWC is? xfs_info won't currently run (I'm waiting on the drive to unmount) but I ran an xfs_check and an xfs_repair -n and no errors were shown.
> ?  dmesg output showing all error messages and stack traces
> Then you need to describe your workload that is causing the problem, and a demonstration of the bad behaviour that is occurring. If it is a performance problem, then 30s - 1 minute samples of:
> 1.    iostat -x -d -m 5
> [root@ncb-sv-016 ~]# iostat -x -d -m 5
> Linux 2.6.32-358.23.2.el6.x86_64 (ncb-sv-016.ducom.edu)       09/15/2015    _x86_64_      (16 CPU)
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> sda               0.29     3.61    5.78    3.58     0.10     0.03    28.27     0.05    5.19   2.39   2.24
> sdb               1.02     8.66   31.50    3.91     0.33     0.12    26.14     5.94  167.54  27.47  97.25
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> sda               0.00     1.60    0.00    2.00     0.00     0.01    14.40     0.01    4.30   4.30   0.86
> sdb               0.00     0.00    0.00    0.80     0.00     0.03    64.00     6.46 6332.75 1250.00 100.00
> 

It looks like not much write activity causes severe I/O latencies (on
the order of seconds) and 100% device utilization. Without some of the
details noted above, it's kind of hard to grasp at what's going wrong
here beyond the fact that the storage just appears to be running really
slow.

Brian

> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> sda               0.00     3.60    0.00    7.00     0.00     0.04    12.11     0.02    0.60   1.77   1.24
> sdb               0.00     0.00    0.00    1.00     0.00     0.03    64.00     6.28 6256.60 1000.00 100.00
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> sda               0.00     0.00    0.00    0.40     0.00     0.00     8.00     0.00   42.50  12.00   0.48
> sdb               0.00     0.00    0.00    1.20     0.00     0.04    64.00     5.86 5846.33 833.33 100.00
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> sda               0.00     0.60    0.00    0.60     0.00     0.00    16.00     0.01   12.67  12.67   0.76
> sdb               0.00     0.00    0.00    1.00     0.00     0.03    64.00     6.86 5725.20 1000.00 100.00
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
> sdb               0.00     0.00    0.00    1.00     0.00     0.03    64.00     6.06 5459.00 1000.00 100.00
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> sda               0.00     4.00    0.00    1.60     0.00     0.02    26.00     0.01    6.75   6.50   1.04
> sdb               0.00     0.00    0.00    1.00     0.00     0.03    51.20     7.05 5670.40 1000.00 100.00
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> sda               0.00    29.40    0.00    2.60     0.00     0.12    98.46     0.01    4.54   4.08   1.06
> sdb               0.00     0.00    0.00    1.20     0.00     0.03    53.33     6.54 7428.50 833.33 100.00
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> sda               0.00     9.60    0.00   15.80     0.00     0.10    12.86     0.57   35.82   3.37   5.32
> sdb               0.00     0.00    0.00    1.00     0.00     0.03    64.00     6.30 5889.20 1000.00 100.00
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> sda               0.00     7.80    0.00   12.80     0.00     0.08    12.38     0.74   58.09  15.06  19.28
> sdb               0.00     0.00    0.00    1.20     0.00     0.04    64.00     6.49 6140.83 833.33 100.00
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> sda               0.00     4.80    0.00    3.20     0.00     0.03    20.00     0.01    0.06   3.12   1.00
> sdb               0.00     0.00    0.00    0.80     0.00     0.03    64.00     5.10 6489.25 1250.00 100.00
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> sda               0.00     0.00    0.00    0.20     0.00     0.00     8.00     0.02  152.00 103.00   2.06
> sdb               0.00     0.00    0.00    1.00     0.00     0.03    64.00     6.75 5791.00 1000.20 100.02
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> sda               0.00    61.20    0.00   11.80     0.00     0.29    49.49     0.01    0.88   0.69   0.82
> sdb               0.00     0.00    0.00    1.40     0.00     0.04    64.00     6.37 5569.71 714.14  99.98
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> sda               0.00     0.40    0.00    0.60     0.00     0.00    13.33     0.01   24.33  24.33   1.46
> sdb               0.00     0.00    0.00    1.60     0.00     0.05    64.00     5.77 5162.00 625.12 100.02
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> sda               0.00     0.00    0.00    0.40     0.00     0.00     8.00     0.00    3.00   1.50   0.06
> sdb               0.00     0.00    0.00    0.80     0.00     0.03    64.00     5.08 3428.50 1250.00 100.00
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> sda               0.00     1.60    0.00    0.80     0.00     0.01    24.00     0.01   10.75  10.75   0.86
> sdb               0.00     0.00    0.00    1.40     0.00     0.04    64.00     5.86 3932.14 714.29 100.00
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> sda               0.00     2.00    0.00    4.80     0.00     0.03    11.33     0.01    2.21   2.08   1.00
> sdb               0.00     0.00    0.00    1.40     0.00     0.04    64.00     5.60 3992.71 714.29 100.00
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> sda               0.00     5.00    0.00   18.20     0.00     0.09    10.20     0.02    1.13   0.03   0.06
> sdb               0.00     0.00    0.00    1.40     0.00     0.04    64.00     5.44 4208.86 714.29 100.00
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> sda               0.00     1.40    0.00    0.60     0.00     0.01    26.67     0.02   27.00  27.00   1.62
> sdb               0.00     0.00    0.00    1.40     0.00     0.04    64.00     5.22 4325.43 714.29 100.00
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> sda               0.00     0.60    0.00    0.40     0.00     0.00    20.00     0.01   15.50  15.50   0.62
> sdb               0.00     0.00    0.00    1.60     0.00     0.05    64.00     5.06 4022.75 625.00 100.00
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
> sdb               0.00     0.00    0.00    0.80     0.00     0.03    64.00     5.08 3495.50 1250.00 100.00
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> sda               0.00     1.60    0.00    1.60     0.00     0.01    12.00     0.07   42.88  42.50   6.80
> sdb               0.00     0.00    0.00    1.40     0.00     0.04    64.00     5.82 3894.71 714.29 100.00
> 2.    vmstat 5
> [root@ncb-sv-016 ~]# vmstat 5
> procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu-----
> r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
> 0  0      0 126125768  19456 405396    0    0    28    10  421  150  0  0 99  0  0
> 0  0      0 126125520  19464 405396    0    0     0    34 6679 13281  0  0 100  0  0
> 1  0      0 126124896  19472 405392    0    0     0    38 6718 13310  0  0 100  0  0
> 0  0      0 126125312  19472 405400    0    0     0    74 6658 13256  0  0 100  0  0
> 0  0      0 126125440  19480 405392    0    0     0    60 6664 13291  0  0 100  0  0
> 2  0      0 126125440  19480 405400    0    0     0    26 6660 13272  0  0 100  0  0
> 0  0      0 126125680  19488 405400    0    0     0    30 6659 13282  0  0 100  0  0
> 2  0      0 126125696  19496 405396    0    0     0   117 6686 13298  0  0 100  0  0
> 1  0      0 126125568  19496 405400    0    0     0    33 6661 13287  0  0 100  0  0
> 0  0      0 126125816  19504 405400    0    0     0    30 6663 13271  0  0 100  0  0
> 1  0      0 126125816  19504 405400    0    0     0    27 6659 13285  0  0 100  0  0
> 0  0      0 126125696  19512 405400    0    0     0    75 6670 13269  0  0 100  0  0
> 0  0      0 126125816  19520 405400    0    0     0    55 6671 13286  0  0 100  0  0
> 2  0      0 126125696  19528 405396    0    0     0    34 6670 13284  0  0 100  0  0
> 0  0      0 126125272  19528 405400    0    0     0    26 6700 13298  0  0 100  0  0
> 0  0      0 126125408  19536 405400    0    0     0    61 6660 13277  0  0 100  0  0
> 1  0      0 126125536  19544 405392    0    0     0    98 6677 13281  0  0 100  0  0
> can give us insight into the IO and memory utilisation of your machine at the time of the problem.
> If the filesystem is hanging, then capture the output of the dmesg command after running:
> # echo w > /proc/sysrq-trigger
> # dmesg
> will tell us all the hung processes in the machine, often pointing us directly to the cause of the hang.
> Attached
> 
> Thanks!
> 
> Josh Earl, MS
> Research Instructor
> Drexel College of Medicine
> Center for Advanced Microbial Processing (CAMP)
> Institute of Molecular Medicine and Infectious Disease
> (215) 762-8133
> 
> ________________________________
> 
> This email and any accompanying attachments are confidential. The information is intended solely for the use of the individual to whom it is addressed. Any review, disclosure, copying, distribution, or use of this email communication by others is strictly prohibited. If you are not the intended recipient, please notify the sender immediately and delete all copies. Thank you for your cooperation.

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
