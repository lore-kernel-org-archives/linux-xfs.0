Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E545A29DF8
	for <xfs@oss.sgi.com>; Fri, 10 May 2013 23:48:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B46608F8049
	for <xfs@oss.sgi.com>; Fri, 10 May 2013 21:48:56 -0700 (PDT)
Received: from mail-gg0-f174.google.com (mail-gg0-f174.google.com
	[209.85.161.174]) by cuda.sgi.com with ESMTP id
	8PWjPNUbovg64hHG (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 May 2013 21:48:55 -0700 (PDT)
Received: by mail-gg0-f174.google.com with SMTP id y1so9446ggc.33
	for <xfs@oss.sgi.com>; Fri, 10 May 2013 21:48:54 -0700 (PDT)
Message-ID: <518DCDB1.30408@gmail.com>
Date: Sat, 11 May 2013 00:48:49 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: Rambling noise #1: generic/230 can trigger kernel debug lock
	detector
References: <518B08D9.1060906@gmail.com> <20130509031646.GN24635@dastard>
	<20130509072045.GO24635@dastard> <518C54AA.7070908@gmail.com>
	<20130510021942.GP23072@dastard>
	<CAJzLF9kmBuQ5+-7NbzPqjUxG5yUELxCxjhh=3NiTFD0dNh-UXQ@mail.gmail.com>
	<20130511011732.GC32675@dastard>
In-Reply-To: <20130511011732.GC32675@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 05/10/2013 09:17 PM, Dave Chinner wrote:
> On Fri, May 10, 2013 at 03:07:19PM -0400, Michael L. Semon wrote:
>> On Thu, May 9, 2013 at 10:19 PM, Dave Chinner <david@fromorbit.com> wrote:
>>> On Thu, May 09, 2013 at 10:00:10PM -0400, Michael L. Semon wrote:

>> Thanks for looking at it.  There are going to be plenty of false
>> positives out there.  Is there a pecking order of what works best?  As
>> in...
>>
>> * IRQ (IRQs-off?) checking: worth reporting...?
>> * sleep inside atomic sections: fascinating, but almost anything can trigger it
>> * multiple-CPU deadlock detection: can only speculate on a uniprocessor system
>> * circular dependency checking: YMMV
>> * reclaim-fs checking: which I knew how much developers need to
>> conform to reclaim-fs, or what it is
>
> If there's XFS in the trace, then just post them. We try to fix
> false positives (as well as real bugs) so lockdep reporting gets more
> accurate and less noisy over time.
>
> Cheers,
>
> Dave.
>

Feel free to ignore and flame them as well.  I'm going to make another 
attempt to triage my eldest Pentium 4, and there's a high chance that 
you'll have to reply, "Despite the xfs_* functions, that looks like a 
DRM issue.  Go bug those guys."

Thanks!

Michael

During generic/249 (lucky, first test out)...
======================================================
[ INFO: possible circular locking dependency detected ]
3.9.0+ #2 Not tainted
-------------------------------------------------------
xfs_io/1181 is trying to acquire lock:
  (sb_writers#3){.+.+.+}, at: [<c10f01be>] 
generic_file_splice_write+0x7e/0x1b0

but task is already holding lock:
  (&(&ip->i_iolock)->mr_lock){++++++}, at: [<c11dca9a>] xfs_ilock+0xea/0x190

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&(&ip->i_iolock)->mr_lock){++++++}:
        [<c1061580>] lock_acquire+0x80/0x100
        [<c1047184>] down_write_nested+0x54/0xa0
        [<c11dca9a>] xfs_ilock+0xea/0x190
        [<c1190d2c>] xfs_setattr_size+0x30c/0x4a0
        [<c1190eec>] xfs_vn_setattr+0x2c/0x30
        [<c10dd40c>] notify_change+0x13c/0x360
        [<c10c233a>] do_truncate+0x5a/0xa0
        [<c10cfcce>] do_last.isra.46+0x31e/0xb90
        [<c10d05db>] path_openat.isra.47+0x9b/0x3e0
        [<c10d0951>] do_filp_open+0x31/0x80
        [<c10c35f1>] do_sys_open+0xf1/0x1c0
        [<c10c36e8>] sys_open+0x28/0x30
        [<c140e1df>] sysenter_do_call+0x12/0x36

-> #1 (&sb->s_type->i_mutex_key#6){+.+.+.}:
        [<c1061580>] lock_acquire+0x80/0x100
        [<c140a1d4>] mutex_lock_nested+0x64/0x2b0
        [<c10c2330>] do_truncate+0x50/0xa0
        [<c10cfcce>] do_last.isra.46+0x31e/0xb90
        [<c10d05db>] path_openat.isra.47+0x9b/0x3e0
        [<c10d0951>] do_filp_open+0x31/0x80
        [<c10c35f1>] do_sys_open+0xf1/0x1c0
        [<c10c36e8>] sys_open+0x28/0x30
        [<c140e1df>] sysenter_do_call+0x12/0x36

-> #0 (sb_writers#3){.+.+.+}:
        [<c1060d55>] __lock_acquire+0x1465/0x1690
        [<c1061580>] lock_acquire+0x80/0x100
        [<c10c75ad>] __sb_start_write+0xad/0x1b0
        [<c10f01be>] generic_file_splice_write+0x7e/0x1b0
        [<c1184813>] xfs_file_splice_write+0x83/0x120
        [<c10ee8c5>] do_splice_from+0x65/0x90
        [<c10ee91b>] direct_splice_actor+0x2b/0x40
        [<c10f03d9>] splice_direct_to_actor+0xb9/0x1e0
        [<c10f0562>] do_splice_direct+0x62/0x80
        [<c10c5166>] do_sendfile+0x1b6/0x2d0
        [<c10c538e>] sys_sendfile64+0x4e/0xb0
        [<c140e1df>] sysenter_do_call+0x12/0x36

other info that might help us debug this:

Chain exists of:
   sb_writers#3 --> &sb->s_type->i_mutex_key#6 --> &(&ip->i_iolock)->mr_lock

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(&(&ip->i_iolock)->mr_lock);
                                lock(&sb->s_type->i_mutex_key#6);
                                lock(&(&ip->i_iolock)->mr_lock);
   lock(sb_writers#3);

  *** DEADLOCK ***

1 lock held by xfs_io/1181:
  #0:  (&(&ip->i_iolock)->mr_lock){++++++}, at: [<c11dca9a>] 
xfs_ilock+0xea/0x190

stack backtrace:
Pid: 1181, comm: xfs_io Not tainted 3.9.0+ #2
Call Trace:
  [<c1406cc7>] print_circular_bug+0x1b8/0x1c2
  [<c1060d55>] __lock_acquire+0x1465/0x1690
  [<c105e4bb>] ? trace_hardirqs_off+0xb/0x10
  [<c1061580>] lock_acquire+0x80/0x100
  [<c10f01be>] ? generic_file_splice_write+0x7e/0x1b0
  [<c10c75ad>] __sb_start_write+0xad/0x1b0
  [<c10f01be>] ? generic_file_splice_write+0x7e/0x1b0
  [<c10f01be>] ? generic_file_splice_write+0x7e/0x1b0
  [<c10f01be>] generic_file_splice_write+0x7e/0x1b0
  [<c11dca9a>] ? xfs_ilock+0xea/0x190
  [<c1184813>] xfs_file_splice_write+0x83/0x120
  [<c1184790>] ? xfs_file_fsync+0x210/0x210
  [<c10ee8c5>] do_splice_from+0x65/0x90
  [<c10ee91b>] direct_splice_actor+0x2b/0x40
  [<c10f03d9>] splice_direct_to_actor+0xb9/0x1e0
  [<c10ee8f0>] ? do_splice_from+0x90/0x90
  [<c10f0562>] do_splice_direct+0x62/0x80
  [<c10c5166>] do_sendfile+0x1b6/0x2d0
  [<c10b45b4>] ? might_fault+0x94/0xa0
  [<c10c538e>] sys_sendfile64+0x4e/0xb0
  [<c140e1df>] sysenter_do_call+0x12/0x36
XFS (sdb5): Mounting Filesystem
XFS (sdb5): Ending clean mount

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
