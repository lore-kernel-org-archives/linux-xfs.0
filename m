Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jul 2008 16:11:18 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6LNBEu2015520
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 16:11:15 -0700
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 28F9E1915296
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 16:12:24 -0700 (PDT)
Received: from mx1.suse.de (mail.suse.de [195.135.220.2]) by cuda.sgi.com with ESMTP id I79PWGhBGpxm6FD7 for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 16:12:24 -0700 (PDT)
From: Neil Brown <neilb@suse.de>
Date: Tue, 22 Jul 2008 09:12:15 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18565.6095.988483.628391@notabene.brown>
Subject: Re: INFO: task pdflush:393 blocked for more than 120 seconds. & Call
 traces ... (fwd)
In-Reply-To: message from Mr. James W. Laferriere on Monday July 21
References: <Pine.LNX.4.64.0807210936410.7212@filesrv1.baby-dragons.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>, xfs@oss.sgi.com

On Monday July 21, babydr@baby-dragons.com wrote:
> INFO: task pdflush:393 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> pdflush       D c8209f80  4748   393      2
>          f75e5e58 00000046 f7f7ad50 c8209f80 f7f7a8a0 f75e5e24 c014fc57 00000000
>          f7f7a8a0 e5d0dd00 c8209f80 f75e4000 c0819e00 c8209f80 f7f7aaf4 f75e5e44
>          00000286 f75e5e80 f510de30 f75e5e58 c0142233 f510de00 f75e5e80 f510de30
> Call Trace:
>    [<c014fc57>] ? mark_held_locks+0x67/0x80
>    [<c0142233>] ? add_wait_queue+0x33/0x50
>    [<c03a7f85>] xfs_buf_wait_unpin+0xb5/0xe0
>    [<c0127a60>] ? default_wake_function+0x0/0x10
>    [<c0127a60>] ? default_wake_function+0x0/0x10
>    [<c03a84fb>] xfs_buf_iorequest+0x4b/0x80
>    [<c03adeee>] xfs_bdstrat_cb+0x3e/0x50
>    [<c03a495c>] xfs_bwrite+0x5c/0xe0
>    [<c039e941>] xfs_syncsub+0x121/0x2b0
>    [<c018a43b>] ? lock_super+0x1b/0x20
>    [<c018a43b>] ? lock_super+0x1b/0x20
>    [<c039e1d8>] xfs_sync+0x48/0x70
>    [<c03af833>] xfs_fs_write_super+0x23/0x30
>    [<c018a80f>] sync_supers+0xaf/0xc0

Looks a lot like an XFS problem to me.
Or at least, XFS people would be able to interpret this stack the
best.

>    [<c0169259>] wb_kupdate+0x29/0x100
>    [<c016a0cc>] ? __pdflush+0xcc/0x1a0
>    [<c016a0d2>] __pdflush+0xd2/0x1a0
>    [<c016a1a0>] ? pdflush+0x0/0x40
>    [<c016a1d1>] pdflush+0x31/0x40
>    [<c0169230>] ? wb_kupdate+0x0/0x100
>    [<c016a1a0>] ? pdflush+0x0/0x40
>    [<c0141e2c>] kthread+0x5c/0xa0
>    [<c0141dd0>] ? kthread+0x0/0xa0
>    [<c0103d67>] kernel_thread_helper+0x7/0x10
>    =======================
> 2 locks held by pdflush/393:
>    #0:  (&type->s_umount_key#17){----}, at: [<c018a7b2>] sync_supers+0x52/0xc0
>    #1:  (&type->s_lock_key#7){--..}, at: [<c018a43b>] lock_super+0x1b/0x20
> 
>     ...snip... Repeats of above message ad-infintum .


Hmm... I guess I clipped a bit too much for our XFS friends to know
the context.
bonnie is being run on an XFS filesystem on md/raid6. and it gets
this warning a lot and essentially hangs.

NeilBrown
