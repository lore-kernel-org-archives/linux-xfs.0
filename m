Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:42612 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725888AbeKPIiY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Nov 2018 03:38:24 -0500
Date: Fri, 16 Nov 2018 09:28:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Fwd: xfs remove / unlink extremely slow ?
Message-ID: <20181115222839.GZ19305@dastard>
References: <3927644F-734A-4A2A-BACB-DE44CBC812EB@berlin.de>
 <14251045-1CCF-4E35-95F1-F6597FD8FD8C@berlin.de>
 <20181114144511.GB19257@bfoster>
 <20181115153815.GA27512@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181115153815.GA27512@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Michael Arndt <Michael.Arndt@berlin.de>, linux-xfs@vger.kernel.org

On Thu, Nov 15, 2018 at 10:38:16AM -0500, Brian Foster wrote:
> On Wed, Nov 14, 2018 at 09:45:11AM -0500, Brian Foster wrote:
> > On Wed, Nov 14, 2018 at 12:42:49PM +0100, Michael Arndt wrote:
> > > Hello XFS Gurus,
> > > 
> > > Problem: /bin/rm extremely slow on a major xfs (SSD based) HPC Storage
> > > slow == 90 seconds for unlink of an empty file without any extents
> > > strace says: time completely used for unlink call
> > > 
> > > Question; Is there any issue resolution ?
> > > 
> > > Information re XFS Version and OS at end of this Post
> > > 
> > > Example of issue:
> > > 
> > > 
> > > [root@atgrzsl3150 DOM_0]# xfs_bmap -a .AN_720.0000122.fl3step_0.lock 
> > > 
> > > .AN_720.0000122.fl3step_0.lock: no extents
> > > [root@atgrzsl3150 DOM_0]# ls -laFtr .AN_720.0000122.fl3step_0.lock 
> > > 
> > > -rw-rw-r-- 1 user group 0 Oct 22 14:14 .AN_720.0000122.fl3step_0.lock
> > > 
> > > 
> > > strace -T -tt /bin/rm .AN_720.0000122.fl3step_0.lock 
> > > 
> > > 
> > > 1:41:11.621005 execve("/bin/rm", ["/bin/rm", ".AN_720.0000122.fl3step_0.lock"], [/* 31 vars */]) = 0 <0.000169>11:41:11.621312 brk(NULL)               = 0x6f5000 <0.000023>11:41:11.621378 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f4d96017000 <0.000058>
> > > …….
> > > 11:41:11.622485 newfstatat(AT_FDCWD, ".AN_720.0000122.fl3step_0.lock", {st_mode=S_IFREG|0664, st_size=0, ...}, AT_SYMLINK_NOFOLLOW) = 0 <0.000009>
> > > 11:41:11.622522 geteuid()               = 0 <0.000009>
> > > -> 11:41:11.622546 unlinkat(AT_FDCWD, ".AN_720.0000122.fl3step_0.lock", 0) = 0 <89.612833>
> > > -> 11:42:41.235428 lseek(0, 0, SEEK_CUR)   = -1 ESPIPE (Illegal seek) <0.000065>
> > > 11:42:41.235548 close(0)                = 0 <0.000052>
> > > 11:42:41.235689 close(1)                = 0 <0.000011>
> > > 11:42:41.235738 close(2)                = 0 <0.000055>
> > > 11:42:41.235830 exit_group(0)           = ?
> > > 11:42:41.235941 +++ exited with 0 +++
> > > 
> > 
> > It might be useful to do something like:
> > 
> >   trace-cmd record -e xfs:* <rm command>
> > 
> > ... and either put the resulting trace.dat somewhere where it can be
> > downloaded or if not too large, run 'trace-cmd report' and copy the text
> > into a mail (without reformatting it).
> > 
> > Brian
> > 
> 
> Michael provided the tracepoint data requested above privately. In
> short, it shows the delay but doesn't provide enough context to root
> cause. The relevant snippets are shown below.
> 
> rm-23740 [003] 1902680.707761: xfs_filemap_fault:    dev 253:0 ino 0x8e392
> ...
> rm-23740 [042] 1902680.708246: xfs_iunlock:          dev 253:0 ino 0x201b46a flags MMAPLOCK_SHARED caller xfs_filemap_fault
> rm-23740 [022] 1902770.759100: xfs_remove:           dev 253:84 dp ino 0xb00a143cd name .AN_718.0000122.fl3step_0.lock
> ...
> rm-23740 [022] 1902770.759276: xfs_iunlock:          dev 253:0 ino 0x201b463 flags IOLOCK_EXCL caller xfs_release

This kinda reminds me of what happens where then is a memory
allocation stall. You just see a long delay between XFS tracepoints
and there's nothing else in the trace. But that's unlikely, because
the brk() call was not delayed at all..

There could be multiple things going on here, though. For example,
before calling ->unlink and getting into XFS, the vfs calls
try_break_deleg() to break delegation leases. If that fails, it
backs out, breaks the delegation and waits on it before retrying the
unlink.

So if the filesystem is exported by NFS, or it's some kind of
userspace delegation lock file, could could see this sort of delay
occurring while the delegation is recalled and released. Indeed,
89.6s is strikingly close to the default NFS reponse timeouts
of 90s.

Food for thought...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
