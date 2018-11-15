Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58188 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726432AbeKPBqi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Nov 2018 20:46:38 -0500
Date: Thu, 15 Nov 2018 10:38:16 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Fwd: xfs remove / unlink extremely slow ?
Message-ID: <20181115153815.GA27512@bfoster>
References: <3927644F-734A-4A2A-BACB-DE44CBC812EB@berlin.de>
 <14251045-1CCF-4E35-95F1-F6597FD8FD8C@berlin.de>
 <20181114144511.GB19257@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181114144511.GB19257@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Michael Arndt <Michael.Arndt@berlin.de>
Cc: linux-xfs@vger.kernel.org

On Wed, Nov 14, 2018 at 09:45:11AM -0500, Brian Foster wrote:
> On Wed, Nov 14, 2018 at 12:42:49PM +0100, Michael Arndt wrote:
> > Hello XFS Gurus,
> > 
> > Problem: /bin/rm extremely slow on a major xfs (SSD based) HPC Storage
> > slow == 90 seconds for unlink of an empty file without any extents
> > strace says: time completely used for unlink call
> > 
> > Question; Is there any issue resolution ?
> > 
> > Information re XFS Version and OS at end of this Post
> > 
> > Example of issue:
> > 
> > 
> > [root@atgrzsl3150 DOM_0]# xfs_bmap -a .AN_720.0000122.fl3step_0.lock 
> > 
> > .AN_720.0000122.fl3step_0.lock: no extents
> > [root@atgrzsl3150 DOM_0]# ls -laFtr .AN_720.0000122.fl3step_0.lock 
> > 
> > -rw-rw-r-- 1 user group 0 Oct 22 14:14 .AN_720.0000122.fl3step_0.lock
> > 
> > 
> > strace -T -tt /bin/rm .AN_720.0000122.fl3step_0.lock 
> > 
> > 
> > 1:41:11.621005 execve("/bin/rm", ["/bin/rm", ".AN_720.0000122.fl3step_0.lock"], [/* 31 vars */]) = 0 <0.000169>11:41:11.621312 brk(NULL)               = 0x6f5000 <0.000023>11:41:11.621378 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f4d96017000 <0.000058>
> > …….
> > 11:41:11.622485 newfstatat(AT_FDCWD, ".AN_720.0000122.fl3step_0.lock", {st_mode=S_IFREG|0664, st_size=0, ...}, AT_SYMLINK_NOFOLLOW) = 0 <0.000009>
> > 11:41:11.622522 geteuid()               = 0 <0.000009>
> > -> 11:41:11.622546 unlinkat(AT_FDCWD, ".AN_720.0000122.fl3step_0.lock", 0) = 0 <89.612833>
> > -> 11:42:41.235428 lseek(0, 0, SEEK_CUR)   = -1 ESPIPE (Illegal seek) <0.000065>
> > 11:42:41.235548 close(0)                = 0 <0.000052>
> > 11:42:41.235689 close(1)                = 0 <0.000011>
> > 11:42:41.235738 close(2)                = 0 <0.000055>
> > 11:42:41.235830 exit_group(0)           = ?
> > 11:42:41.235941 +++ exited with 0 +++
> > 
> 
> It might be useful to do something like:
> 
>   trace-cmd record -e xfs:* <rm command>
> 
> ... and either put the resulting trace.dat somewhere where it can be
> downloaded or if not too large, run 'trace-cmd report' and copy the text
> into a mail (without reformatting it).
> 
> Brian
> 

Michael provided the tracepoint data requested above privately. In
short, it shows the delay but doesn't provide enough context to root
cause. The relevant snippets are shown below.

rm-23740 [003] 1902680.707761: xfs_filemap_fault:    dev 253:0 ino 0x8e392
...
rm-23740 [042] 1902680.708246: xfs_iunlock:          dev 253:0 ino 0x201b46a flags MMAPLOCK_SHARED caller xfs_filemap_fault
rm-23740 [022] 1902770.759100: xfs_remove:           dev 253:84 dp ino 0xb00a143cd name .AN_718.0000122.fl3step_0.lock
...
rm-23740 [022] 1902770.759276: xfs_iunlock:          dev 253:0 ino 0x201b463 flags IOLOCK_EXCL caller xfs_release

This shows the very first event emitted by the process, up through the
xfs_remove event, followed by the very last event emitted by the
process. The time between XFS receiving the unlink request and the last
event is under 1ms. The time between the first event and xfs_remove is
90s, but that's about the same gap as between the event immediately
prior to xfs_remove so we don't know exactly what's happening there.

The strace shows this time within unlinkat(), so I suspect some portion
of the VFS aspect of this operation is consuming this time. If lookups
were the problem, I'd expect to see xfs_lookup events in the trace.

Hmm, I think you might have to try and collect some more data to
identify the problem. A simple thing to check might be to 'cat /proc/<rm
pid>/stack' while the rm is stuck and see if that shows anything useful.
If not, perhaps 'trace-cmd record -p function_graph <rm cmd>' will show
enough to make sense of the problem. Note that the latter might generate
a ton of data and so might be easier to trace through yourself. Run
'trace-cmd report > trace.out' to generate a text file from the
resulting trace.dat and poke through that to try and find the
delay/latency.

Brian

> > xfs_info /dev/mapper/vg_calc2-calc2
> > meta-data=/dev/mapper/vg_calc2-calc2 isize=512    agcount=50, agsize=268435448 blks
> >         =                       sectsz=512   attr=2, projid32bit=1
> >         =                       crc=1        finobt=0 spinodes=0
> > data     =                       bsize=4096   blocks=13421711360, imaxpct=20
> >         =                       sunit=8      swidth=40 blks
> > naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> > log      =internal               bsize=4096   blocks=521728, version=2
> >         =                       sectsz=512   sunit=8 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > 
> > Issue on:
> > 
> > xfsprogs-4.5.0-18.el7.x86_64
> > xfsdump-3.1.7-1.el7.x86_64
> > Red Hat Enterprise Linux Server release 7.4 (Maipo)
> > df -kh .
> > Filesystem                  Size  Used Avail Use% Mounted on
> > /dev/mapper/vg_calc2        50T   20T   31T  40% /calc2
> > 
> > Layers: 
> > 
> > SSD based commercial Storage exports many small LUN’s -> LUN#s striped via LVM2 for speed, xfs with default opts on top of LVM
> > Currently no discard Option for mount and no fstrim manually called
> > 
> > Mount Options used
> > /dev/mapper/vg_calc2-calc2 /calc2 xfs noatime,delaylog,nobarrier,nodiratime,logbsize=256k,logbufs=8 0 0 
> > 
> > thanks for any tip / hint / question
> > Micha
> > 
