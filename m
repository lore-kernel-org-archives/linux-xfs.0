Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 09 Mar 2008 14:34:50 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m29LYORI030610
	for <xfs@oss.sgi.com>; Sun, 9 Mar 2008 14:34:30 -0700
Date: Mon, 10 Mar 2008 08:34:41 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: INFO: task mount:11202 blocked for more than 120 seconds
Message-ID: <20080309213441.GQ155407@sgi.com>
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de> <20080307224040.GV155259@sgi.com> <alpine.DEB.1.00.0803080032020.7723@sheep.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0803080032020.7723@sheep.housecafe.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christian Kujau <lists@nerdbynature.de>
Cc: David Chinner <dgc@sgi.com>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, dm-devel@redhat.com

[adding dm-devel to cc list]

On Sat, Mar 08, 2008 at 12:46:40AM +0100, Christian Kujau wrote:
> On Sat, 8 Mar 2008, David Chinner wrote:
> >Well, if that is hung there, something else must be holding on to
> >the iolock it's waiting on. What are the other D state processes in the
> >machine?
> 
> I have 7 processes in D state so far:
> 
> $ ps auxww [....]
> root      9844  0.0  0.0      0     0 ?   D    Mar06   0:22 [pdflush]
> root      2697  0.0  0.0   4712   460 ?   D    Mar07   0:00 sync
> root      8342  0.0  0.0   1780   440 ?   D    Mar07   0:01 /bin/rm -rf 
> /data/md1/stuff
> root     12494  0.0  0.0  11124  1228 ?   D    Mar07   0:14 /usr/bin/rsync 
> root     15008  0.0  0.0   4712   460 ?   D    Mar07   0:00 sync
> root     11202  0.0  0.0   5012   764 ?   D    Mar07   0:00 mount -o 
> remount,ro /data/md1
> root     15936  0.0  0.0   4712   460 ?   D    Mar07   0:00 sync
> 
> At one point I did a sysrq-D and put the results in:
> http://nerdbynature.de/bits/2.6.25-rc4/hung_task/kern.log.gz
> (grep for "SysRq : Show Locks Held" and "SysRq : Show Blocked State")

Ok, this looks like a block layer issue. Everything is waiting in ioschedule()
and so in places we are blocked holding locked inodes. Hence sync, pdflush,
etc are hung waiting for the inode locks to be released. e.g:

INFO: task rm:8342 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
rm            D ee08de8c     0  8342   8199
       f5eebd80 00000086 c0380a16 ee08de8c ee08de8c 00000000 ee08de94 c200ebd0 
       c043ef2b c0146237 c043f1d2 c0146210 ee08de8c 00000000 00000000 db122110 
       c01464ca 00000002 c1865b00 0000000c 00000000 ee3acd60 c012c700 c200ebec 
Call Trace:
 [<c0380a16>] dm_table_unplug_all+0x26/0x40
 [<c043ef2b>] io_schedule+0xb/0x20
 [<c0146237>] sync_page+0x27/0x40
 [<c043f1d2>] __wait_on_bit+0x42/0x70
 [<c0146210>] sync_page+0x0/0x40
 [<c01464ca>] wait_on_page_bit+0x5a/0x60
 [<c012c700>] wake_bit_function+0x0/0x60
 [<c014ec53>] truncate_inode_pages_range+0x223/0x360
 [<c014eda7>] truncate_inode_pages+0x17/0x20
 [<c017b44f>] generic_delete_inode+0xef/0x100
 [<c017a8ac>] iput+0x5c/0x70
 [<c0171e47>] do_unlinkat+0xf7/0x160
 [<c0102e29>] sysenter_past_esp+0x9a/0xa5
 [<c013835c>] trace_hardirqs_on+0x9c/0x110
 [<c0102dee>] sysenter_past_esp+0x5f/0xa5
 =======================
no locks held by rm/8342.

And rsync is stuck in congestion_wait()

SysRq : Show Blocked State
  task                PC stack   pid father
rsync         D 00000292     0 12494      1
       f5dc7b40 00000086 00000000 00000292 f697bcdc 00735f5c 00000000 00000600 
       c043efd9 c013820d f532ed60 c05c0f04 f5cc1b58 00735f5c c0122900 f532ed60 
       c05c0c00 c053eb04 0000000a c043ef0b c01515f8 00000000 f532ed60 c012c6c0 
Call Trace:
 [<c043efd9>] schedule_timeout+0x49/0xc0
 [<c013820d>] mark_held_locks+0x3d/0x70
 [<c0122900>] process_timeout+0x0/0x10
 [<c043ef0b>] io_schedule_timeout+0xb/0x20
 [<c01515f8>] congestion_wait+0x58/0x80
 [<c012c6c0>] autoremove_wake_function+0x0/0x40
 [<c014cc32>] balance_dirty_pages_ratelimited_nr+0xb2/0x240
 [<c0147368>] generic_file_buffered_write+0x1a8/0x650
 [<c028540e>] xfs_log_move_tail+0x3e/0x180
 [<c0440be9>] _spin_lock+0x29/0x40
 [<c02a73cc>] xfs_write+0x7ac/0x8a0
 [<c0174c01>] core_sys_select+0x21/0x350
 [<c02a32bc>] xfs_file_aio_write+0x5c/0x70
 [<c0167d25>] do_sync_write+0xd5/0x120
 [<c0102ed7>] restore_nocheck+0x12/0x15
 [<c012c6c0>] autoremove_wake_function+0x0/0x40
 [<c019d105>] dnotify_parent+0x35/0x90
 [<c0167c50>] do_sync_write+0x0/0x120
 [<c016859f>] vfs_write+0x9f/0x140
 [<c0168b51>] sys_write+0x41/0x70
 [<c0102dee>] sysenter_past_esp+0x5f/0xa5

And this rsync procss will definitely be holding the iolock on an XFS
inode here (which is why other processes are hanging on an inode iolock).

> >Also, the iolock can be held across I/O so it's possible you've lost an 
> >I/O. Any I/O errors in the syslog?
> 
> No, no I/O errors at all. See the kern.log above, I could even do dd(1) 
> from the md1 (dm-crypt on raid1), no errors either.

Oh, dm-crypt. Well, I'd definitely start looking there. XFS has a
history of exposing dm-crypt bugs, and these hangs appear to be I/O
congestion/scheduling related and not XFS. Also, we haven't changed
anything related to plug/unplug of block devices in XFS recently, so
that also points to some other change as well...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
