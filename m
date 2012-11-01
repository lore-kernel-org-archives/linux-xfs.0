Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA1JSNVY049739 for <xfs@oss.sgi.com>; Thu, 1 Nov 2012 14:28:23 -0500
Received: from sam.nabble.com (sam.nabble.com [216.139.236.26]) by
	cuda.sgi.com with ESMTP id Khl4UzHGWWLg4dZI (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 01 Nov 2012 12:30:14 -0700 (PDT)
Received: from telerig.nabble.com ([192.168.236.162])
	by sam.nabble.com with esmtp (Exim 4.72)
	(envelope-from <lists@nabble.com>) id 1TU0Sz-0004YT-T8
	for xfs@oss.sgi.com; Thu, 01 Nov 2012 12:30:13 -0700
Message-ID: <34630253.post@talk.nabble.com>
Date: Thu, 1 Nov 2012 12:30:13 -0700 (PDT)
From: Kamal Dasu <kdasu.kdev@gmail.com>
Subject: Re: xfs filesystem corruption with kernel 2.6.37
In-Reply-To: <20121025224713.GF29378@dastard>
MIME-Version: 1.0
References: <CAC=U0a2T_J9Y6WzvWyFfbBSDy__Pr7f4gfQBie2o0VhAm2jCaQ@mail.gmail.com>
	<20121025224713.GF29378@dastard>
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


Dave,

Thanks for you reply.

I am trying to act on the hints you gave me but I still have a few
questions.

On Thu, Oct 25, 2012 at 6:47 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Oct 25, 2012 at 09:45:10AM -0400, Kamal Dasu wrote:
>> with  "CONFIG_XFS_DEBUG=y" I get the following assertion:
>>
>> Assertion failed: prev.br_state == XFS_EXT_NORM, file:
>> fs/xfs/xfs_bmap.c, line: 5192
>
> Yup, that's pretty clear indication of a corrupted extent record.
>

What is the best way to prevent  transactions that record bad
extent length and block numbers.

>> would have cleared inode 6776
>>         - agno = 1
>> 771a3500: Badness in key lookup (length)
>> bp=(bno 16107312, len 16384 bytes) key=(bno 16107312, len 8192 bytes)
>>         - agno = 2
>> bad nblocks 5120 for inode 33701135, would reset to 4096
>> inode 34297761 - bad rt extent start block number 2392537303836672,
>                                                 0x88000001B6800
>
> That's the open, unlinked file at the time the system crashed. That
> may be where your problems are coming from. The RT is mostly
> untested, and we sure as anything don't do any crash resiliency or
> recovery testing on it, so there's a good chance there are bugs in
> it that might show up in situations like this....
>
> You need to detect extents with invalid lengths in them and trigger
> a corruption-based filesystem shutdown.
>

Looked at the log during one of the filesystem shutdown when the
I/O error occurs. is this an indication of already corrupted log due to
corrupted in-memory metadata structures?.
===
attempt to access beyond end of device
sda2: rw=0, want=33792081130943048, limit=31471329
I/O error in filesystem ("sda2") meta-data dev sda2 block
0x780db80007f240       ("xfs_trans_read_buf") error 5 buf count 4096
xfs_force_shutdown(sda2,0x1) called from line 395 of file
fs/xfs/xfs_trans_buf.c.  Return address = 0x801f4f88
Filesystem "sda2": I/O Error Detected.  Shutting down filesystem: sda2
Please umount the filesystem, and rectify the problem(s)
====

However the log is already corrupted. So is there a check on a write
to the log ?.

>> also if there is something that can be done to avoid this situation in
>> the first place.
>
> Track down where those stray upper bits in the block numbers are
> coming from, and you'll have your answer.
>

Have not been able to track this down yet. But could it be a possible memory
corruption, leading to the in-memory metadata to get corrupted.

On a similar occurrence of this issue on recovery after a reboot seems
to always go through the evict path

Filesystem "sda2": XFS internal error xfs_trans_cancel at line 1815
of file fs/xfs/xfs_trans.c.  Caller 0x801f8524

Call Trace:
[<80439d2c>] dump_stack+0x8/0x34
[<801f3bec>] xfs_trans_cancel+0x10c/0x128
[<801f8524>] xfs_inactive+0x2fc/0x450
[<800dcd54>] evict+0x28/0xd0
[<800dd300>] iput+0x19c/0x2d8
[<801e5bcc>] xlog_recover_process_one_iunlink+0xec/0x130
[<801e7b60>] xlog_recover_process_iunlinks.clone.25+0xa8/0x108
[<801eb360>] xlog_recover_finish+0x40/0x100
[<801eedd8>] xfs_mountfs+0x434/0x654
..
.
Filesystem "sda2": Corruption of in-memory data detected.  Shutting
down filesystem: sda2

-- 
View this message in context: http://old.nabble.com/xfs-filesystem-corruption-with-kernel-2.6.37-tp34601185p34630253.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
