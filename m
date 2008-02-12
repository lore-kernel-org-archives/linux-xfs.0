Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 12 Feb 2008 13:01:49 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1CL1hnP027620
	for <linux-xfs@oss.sgi.com>; Tue, 12 Feb 2008 13:01:45 -0800
Message-ID: <47B2094D.50406@tlinx.org>
Date: Tue, 12 Feb 2008 13:02:05 -0800
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: xfs [_fsr] probs in 2.6.24.0
References: <47B0F00D.3060802@tlinx.org> <20080212085802.GA155407@sgi.com>
In-Reply-To: <20080212085802.GA155407@sgi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Linux-Xfs <linux-xfs@oss.sgi.com>, LKML <linux-kernel@vger.kernel.org>



David Chinner wrote:
> Filesystem bugs rarely hang systems hard like that - more likely is
> a hardware or driver problem. And neither of the lockdep reports
> below are likely to be responsible for a system wide, no-response
> hang.
---
	"Ish", the 32-bitter, has been the only hard-hanger.  Since
upgrading to 2.6.24, it's crashed once, inexplicably, but has since
stayed up longer than it has since I started with the whole SATA
fiasco (which I intend to inflict upon myself again, as soon as I
get back to a "stable" config -- masochistic nature I suppose).

> If your hardware or drivers are unstable, then XFS cannot be
> expected to reliably work. Given that xfs_fsr apparently triggers
> the hangs, I'd suggest putting lots of I/O load on your disk subsystem
> by copying files around with direct I/O (just like xfs_fsr does) to
> try to reproduce the problem.
---
	The hardware drivers in ish are the older PATA drivers --
nothing new...cept I did add tickless option for system clock.
I've only been running XFS on this system (mostly same hardware,
disks upgraded), for about 6-7 years.

> Perhaps by running xfs_fsr manually you could reproduce the
> problem while you are sitting in front of the machine...
----
	Um...yeah, AND with multiple "cp's of multi-gig files
going on at same time, both local, by a sister machine via NFS,
and and a 3rd machine tapping (not banging) away via CIFS.
These were on top of normal server duties.  Whenever I stress
it on *purpose* and watch it, works fine.   GRRRRRRR....I HATE
  THAT!!!


>> xfs_fsr/2119 is trying to acquire lock:
>> (&mm->mmap_sem){----}, at: [<b01a3432>] dio_get_page+0x62/0x160
>>
>> but task is already holding lock:
>> (&(&ip->i_iolock)->mr_lock){----}, at: [<b02651db>] xfs_ilock+0x5b/0xb0
> 
> dio_get_page() takes the mmap_sem of the processes
> vma that has the pages we do I/O into. That's not new.
> We're holding the xfs inode iolock at this point to protect
> against truncate  and simultaneous buffered I/O races and
> this is also unchanged.  i.e. this is normal.
---
	Uh huh...please note I'm not, trying to point fingers at
xfs_fsr, but the locking diagnostics associated with xfs_fsr have
been the only "hint" of anything "irregular", _at_ _least_, that is,
since I've removed the SATA controller+disk) on 'ish32'.

	The file system(s) going "offline" due
to xfs-detected filesystem errors has only happened *once* on
asa, the 64-bit machine.  It's a fairly new machine w/o added
hardware -- but this only happened in 2.24.0 when I added the
tickless clock option, which sure seems like a remote possibility for
causing an xfs error, but could be.  A 3rd linux system, hardware poor,
"ast-32", was up over 20 days on 2.23.14 (w/tickless) before I
took it down for a 2.24.2 kernel install (its single 20G disk is so
old that it doesn't support barriers).


> 
>> which lock already depends on the new lock.
>> the existing dependency chain (in reverse order) is:
> 
> munmap() dropping the last reference to it's vm_file and
> calling ->release() which causes a truncate of speculatively
> allocated space to take place. IOWs, ->release() is called
> with the mmap_sem held. Hmmm....
> 
> Looking at it in terms of i_mutex, other filesystems hold
> i_mutex over dio_get_page() (all those that use DIO_LOCKING)
> so question is whether we are allowed to take the i_mutex
> in ->release. I note that both reiserfs and hfsplus take 
> i_mutex in ->release as well as use DIO_LOCKING, so this
> problem is not isolated to XFS.
> 
> However, it would appear that mmap_sem -> i_mutex is illegal
> according to the comment at the head of mm/filemap.c. While we are
> not using i_mutex in this case, the inversion would seem to be
> equivalent in nature.
> 
> There's not going to be a quick fix for this.
----
	What could be the consequences of this locking anomaly?
I.e., for example, in NFS, I have enabled "allow direct I/O on NFS
files". The times when the system has been unstable would be around
the time when the local machine might be running xfs_fsr while
a remote system is using NFS to write its backups.  The exact
timing of things depends on the dump-level and internet-'book-keeping'
work done on the local system which adds an element of uncertainty
as to whether or not xfs_fsr might be running at the same time
NFS might be doing direct I/O.

It's also possible for a local backup to be writing to a backup disk
at the same time xfs_fsr is running, since they trigger off of
different cron entries (xfs_fsr off of cron.daily which runs
"whenever"), and backups which run at mostly fixed times.
The local backup uses xfs_dump (which might use some direct I/O to read?)
but the writes go through compression, and are likely using buffered
i/o.



> 
> And the other one:
> 
>> Feb  7 02:01:50 kern: 
>> -------------------------------------------------------
>> Feb  7 02:01:50 kern: xfs_fsr/6313 is trying to acquire lock:
>> Feb  7 02:01:50 kern:  (&(&ip->i_lock)->mr_lock/2){----}, at: 
>> [<ffffffff803c1b22>] xfs_ilock+0x82/0xc0
>> Feb  7 02:01:50 kern:
>> Feb  7 02:01:50 kern: but task is already holding lock:
>> Feb  7 02:01:50 kern:  (&(&ip->i_iolock)->mr_lock/3){--..}, at: 
>> [<ffffffff803c1b45>] xfs_ilock+0xa5/0xc0
>> Feb  7 02:01:50 kern:
>> Feb  7 02:01:50 kern: which lock already depends on the new lock.
> 
> Looks like yet another false positive. Basically we do this
> in xfs_swap_extents:
> 
> 	inode A: i_iolock class 2
> 	inode A: i_ilock class 2
> 	inode B: i_iolock class 3
> 	inode B: i_ilock class 3
> 	.....
> 	inode A: unlock ilock
> 	inode B: unlock ilock
> 	.....
>>>>>> 	inode A: ilock class 2
> 	inode B: ilock class 3
> 
> And lockdep appears to be complaining about the relocking of inode A
> as class 2 because we've got a class 3 iolock still held, hence
> violating the order it saw initially.  There's no possible deadlock
> here so we'll just have to add more hacks to the annotation code to make
> lockdep happy.
----
	Is there a reason to unlock and relock the same inode while
the level 3 lock is held -- i.e. does 'unlocking ilock' allow some
increased 'throughput' for some other potential process to access
the same inode?  I'd expect not, if the 'iolock' is held, but just
a question.  I certainly don't understand the exact effects of
the various locks in question, but it seems that the 2nd two groups
where the inodes are unlocked and relocked are superfluous if
an iolock for those inodes remains held.  But again, I don't really
know what the locks are doing, so don't know.

	Sorry for all the bother. Just trying to figure out why a
system  that was rock-solid (2-3 month uptimes, easily, only planned
downs), to going all flako on me when I tried to add SATA and upgraded
kernel to include latest SATA code & drivers.  Unfortunately part of
that was adding udev in place of a static /dev, so that's another
unknown that I know is flakey at times (had a SATA sdb disk go off line
with a supposed HW-reset error, then have it come back on line as
"sdc"!)  That's certainly a bit weird from my perspective, but hey,
some might consider it a feature, so who am I to argue....:-)
