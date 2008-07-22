Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jul 2008 19:20:01 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6M2JvNE000561
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 19:19:57 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 630C01915DEB
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 19:21:04 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id hU2GEgE1EXuGEcX4 for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 19:21:04 -0700 (PDT)
Date: Tue, 22 Jul 2008 12:20:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: INFO: task pdflush:393 blocked for more than 120 seconds. &
	Call traces ... (fwd)
Message-ID: <20080722022050.GG6761@disturbed>
References: <Pine.LNX.4.64.0807210936410.7212@filesrv1.baby-dragons.com> <18565.6095.988483.628391@notabene.brown> <Pine.LNX.4.64.0807211529350.7212@filesrv1.baby-dragons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0807211529350.7212@filesrv1.baby-dragons.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid maillist <linux-raid@vger.kernel.org>, xfs@oss.sgi.com

On Mon, Jul 21, 2008 at 03:43:03PM -0800, Mr. James W. Laferriere wrote:
> 	Hello Neil ,
>
> On Tue, 22 Jul 2008, Neil Brown wrote:
>> On Monday July 21, babydr@baby-dragons.com wrote:
>>> INFO: task pdflush:393 blocked for more than 120 seconds.
>>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>> pdflush       D c8209f80  4748   393      2
>>>          f75e5e58 00000046 f7f7ad50 c8209f80 f7f7a8a0 f75e5e24 c014fc57 00000000
>>>          f7f7a8a0 e5d0dd00 c8209f80 f75e4000 c0819e00 c8209f80 f7f7aaf4 f75e5e44
>>>          00000286 f75e5e80 f510de30 f75e5e58 c0142233 f510de00 f75e5e80 f510de30
>>> Call Trace:
>>>    [<c014fc57>] ? mark_held_locks+0x67/0x80
>>>    [<c0142233>] ? add_wait_queue+0x33/0x50
>>>    [<c03a7f85>] xfs_buf_wait_unpin+0xb5/0xe0
>>>    [<c0127a60>] ? default_wake_function+0x0/0x10
>>>    [<c0127a60>] ? default_wake_function+0x0/0x10
>>>    [<c03a84fb>] xfs_buf_iorequest+0x4b/0x80
>>>    [<c03adeee>] xfs_bdstrat_cb+0x3e/0x50
>>>    [<c03a495c>] xfs_bwrite+0x5c/0xe0
>>>    [<c039e941>] xfs_syncsub+0x121/0x2b0
>>>    [<c018a43b>] ? lock_super+0x1b/0x20
>>>    [<c018a43b>] ? lock_super+0x1b/0x20
>>>    [<c039e1d8>] xfs_sync+0x48/0x70
>>>    [<c03af833>] xfs_fs_write_super+0x23/0x30
>>>    [<c018a80f>] sync_supers+0xaf/0xc0
>>
>> Looks a lot like an XFS problem to me.
>> Or at least, XFS people would be able to interpret this stack the
>> best.
> 	Hmm ,  Ok ,  I'll post there ,  I can provide a -complete- boot ->  
> renboot log of the actions ,  But it ain't small ~ 649K .  So I'll post 
> that on the back of my website , ie:
>
> http://www.baby-dragons.com/bonnie++1.03c-2.6.26-rc9.console.trace.log

Given that it's a log hang on 2.6.29-rc9, I'd first say add this commit:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=49641f1acfdfd437ed9b0a70b86bf36626c02afe

to your build (went in after -rc9 but before 2.6.26 was released)
and see if that solves the problem.

In more detail, this stack trace implies log I/O has not completed
after the log force was triggered in xfs_buf_wait_unpin(). The above
patch fixes a bug in log I/o dispatch where an non-atomic compare
and decrement would result in log I/O not being dispatched.

So, you've got a hang waiting for log I/o to complete on a kernel
that has a known problem with log I/O dispatch, so it's likely
that's what you've hit.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
