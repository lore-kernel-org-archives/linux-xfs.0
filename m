Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jul 2008 16:42:00 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6LNfuew022630
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 16:41:56 -0700
Received: from ns3.baby-dragons.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 05781310D72
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 16:43:05 -0700 (PDT)
Received: from ns3.baby-dragons.com (ns3.system-techniques.com [204.91.156.41]) by cuda.sgi.com with ESMTP id pMrITGM1ep91Ex86 for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 16:43:05 -0700 (PDT)
Date: Mon, 21 Jul 2008 15:43:03 -0800 (AKDT)
From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: INFO: task pdflush:393 blocked for more than 120 seconds. & Call
 traces ... (fwd)
In-Reply-To: <18565.6095.988483.628391@notabene.brown>
Message-ID: <Pine.LNX.4.64.0807211529350.7212@filesrv1.baby-dragons.com>
References: <Pine.LNX.4.64.0807210936410.7212@filesrv1.baby-dragons.com>
 <18565.6095.988483.628391@notabene.brown>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Neil Brown <neilb@suse.de>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>, xfs@oss.sgi.com

 	Hello Neil ,

On Tue, 22 Jul 2008, Neil Brown wrote:
> On Monday July 21, babydr@baby-dragons.com wrote:
>> INFO: task pdflush:393 blocked for more than 120 seconds.
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> pdflush       D c8209f80  4748   393      2
>>          f75e5e58 00000046 f7f7ad50 c8209f80 f7f7a8a0 f75e5e24 c014fc57 00000000
>>          f7f7a8a0 e5d0dd00 c8209f80 f75e4000 c0819e00 c8209f80 f7f7aaf4 f75e5e44
>>          00000286 f75e5e80 f510de30 f75e5e58 c0142233 f510de00 f75e5e80 f510de30
>> Call Trace:
>>    [<c014fc57>] ? mark_held_locks+0x67/0x80
>>    [<c0142233>] ? add_wait_queue+0x33/0x50
>>    [<c03a7f85>] xfs_buf_wait_unpin+0xb5/0xe0
>>    [<c0127a60>] ? default_wake_function+0x0/0x10
>>    [<c0127a60>] ? default_wake_function+0x0/0x10
>>    [<c03a84fb>] xfs_buf_iorequest+0x4b/0x80
>>    [<c03adeee>] xfs_bdstrat_cb+0x3e/0x50
>>    [<c03a495c>] xfs_bwrite+0x5c/0xe0
>>    [<c039e941>] xfs_syncsub+0x121/0x2b0
>>    [<c018a43b>] ? lock_super+0x1b/0x20
>>    [<c018a43b>] ? lock_super+0x1b/0x20
>>    [<c039e1d8>] xfs_sync+0x48/0x70
>>    [<c03af833>] xfs_fs_write_super+0x23/0x30
>>    [<c018a80f>] sync_supers+0xaf/0xc0
>
> Looks a lot like an XFS problem to me.
> Or at least, XFS people would be able to interpret this stack the
> best.
 	Hmm ,  Ok ,  I'll post there ,  I can provide a -complete- boot -> 
renboot log of the actions ,  But it ain't small ~ 649K .  So I'll post that on 
the back of my website , ie:

http://www.baby-dragons.com/bonnie++1.03c-2.6.26-rc9.console.trace.log

 	This includes the Sysrq-w & sysrq-b outputs at the bottom .
 	If you're interested in that kind of thing ;-) .


>>    [<c0169259>] wb_kupdate+0x29/0x100
>>    [<c016a0cc>] ? __pdflush+0xcc/0x1a0
>>    [<c016a0d2>] __pdflush+0xd2/0x1a0
>>    [<c016a1a0>] ? pdflush+0x0/0x40
>>    [<c016a1d1>] pdflush+0x31/0x40
>>    [<c0169230>] ? wb_kupdate+0x0/0x100
>>    [<c016a1a0>] ? pdflush+0x0/0x40
>>    [<c0141e2c>] kthread+0x5c/0xa0
>>    [<c0141dd0>] ? kthread+0x0/0xa0
>>    [<c0103d67>] kernel_thread_helper+0x7/0x10
>>    =======================
>> 2 locks held by pdflush/393:
>>    #0:  (&type->s_umount_key#17){----}, at: [<c018a7b2>] sync_supers+0x52/0xc0
>>    #1:  (&type->s_lock_key#7){--..}, at: [<c018a43b>] lock_super+0x1b/0x20
>>
>>     ...snip... Repeats of above message ad-infintum .
>
>
> Hmm... I guess I clipped a bit too much for our XFS friends to know
> the context.
> bonnie is being run on an XFS filesystem on md/raid6. and it gets
> this warning a lot and essentially hangs.
> NeilBrown
 	Nah ,  wasn't you who did the clipping t'was me .  in order to get the 
size of the original message below ~ 80K .

 		Tnx ,  JimL
-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network&System Engineer | 2133    McCullam Ave |  Give me Linux  |
| babydr@baby-dragons.com | Fairbanks, AK. 99701 |   only  on  AXP |
+------------------------------------------------------------------+
