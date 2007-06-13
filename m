Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 13 Jun 2007 04:48:49 -0700 (PDT)
Received: from mail.ukfsn.org (s2.ukfsn.org [217.158.120.143])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5DBmdWt008995
	for <xfs@oss.sgi.com>; Wed, 13 Jun 2007 04:48:41 -0700
Message-ID: <466FD214.9070603@dgreaves.com>
Date: Wed, 13 Jun 2007 12:16:36 +0100
From: David Greaves <david@dgreaves.com>
MIME-Version: 1.0
Subject: Re: 2.6.22-rc3 hibernate(?) fails totally - regression (xfs on raid6)
References: <200706020122.49989.rjw@sisk.pl> <4661EFBB.5010406@dgreaves.com> <alpine.LFD.0.98.0706021538360.23741@woody.linux-foundation.org> <4662D852.4000005@dgreaves.com> <46667160.80905@gmail.com> <46668EE0.2030509@dgreaves.com> <46679D56.7040001@gmail.com> <4667DE2D.6050903@dgreaves.com> <20070607110708.GS86004887@sgi.com> <46680F5E.6070806@dgreaves.com> <20070607222813.GG85884050@sgi.com> <4669A965.20403@dgreaves.com> <alpine.LFD.0.98.0706121123550.14121@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0706121123550.14121@woody.linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Chinner <dgc@sgi.com>, Tejun Heo <htejun@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, xfs@oss.sgi.com, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, linux-pm <linux-pm@lists.osdl.org>, Neil Brown <neilb@suse.de>, Jeff Garzik <jgarzik@pobox.com>

Linus Torvalds wrote:
> 
> On Fri, 8 Jun 2007, David Greaves wrote:
>> positive: I can now get sysrq-t :)
> 
> Ok, so color me confused,
So what do you think that makes me <grin>

> and maybe I have missed some of the emails or 
> skimmed over them too fast (there's been too many of them ;),

You may have missed these 'tests' with rc4+Tejun's fix:
* clean boot, unmounting the xfs fs : normal hibernate/resume
* clean boot, remount ro xfs fs : normal hibernate/resume
* clean boot, touch; sync; echo 1 > /proc/sys/vm/drop_caches: normal 
hibernate/resume
* clean boot, touch; sync; echo 2 > /proc/sys/vm/drop_caches: hang hibernating
* clean boot, touch; sync; echo 3 > /proc/sys/vm/drop_caches: hang hibernating

Dave asked me to do them but hasn't responded yet.

> but
> 
>  - I haven't actually seen any traces for this (netconsole apparently 
>    doesn't work for you, and I'm not surprised: it never really worked 
>    well for me over suspend/resume either, but I think I saw a mention of 
>    serial console?)
Well, I got netconsole working but needed to buildin the skge and that changed 
the behaviour a bit... let me know if that's interesting. I've left skge as a 
module as originally reported.
I have however configured serial and serial console and plugged in a cable so I 
can capture data there. Sysrq at the end.


>  - You apparently bisected it down to the range
> 
> 	0a3fd051c7036ef71b58863f8e5da7c3dabd9d3f <- works
> 	1d30c33d8d07868199560b24f10ed6280e78a89c <- breaks
> 
>    but some of the intermediates in that range didn't compile. Correct?
Yes, then applying the sata_via patch confirmed
9666f4009c22f6520ac3fb8a19c9e32ab973e828  libata: reimplement suspend/resume 
support using sdev->manage_start_stop
was the first to cause the problems.

However....
> Can you try to bisect down a bit more, despite the compile error? Just do
> 
> 	git bisect start
> 	git bisect good 0a3fd051c7036ef71b58863f8e5da7c3dabd9d3f
> 	git bisect bad 1d30c33d8d07868199560b24f10ed6280e78a89c
> 
> and it should pick 
> 
> 	f4d6d004: libata: ignore EH scheduling during initialization
> 
> for you to test. It will apparently break on the fact that "sata_via.c" 
> wants "ata_scsi_device_resume/suspend" for the initialization of the
> resume/suspend things in the scsi_host_template, but you should just 
> remove those lines, and the compile hopefully completes cleanly after 
> that.
> 
> IOW, it *should* be easy enough to pinpoint this from 9 changes down to 
> just one.
... let me reconfirm - there's been a lot of testing and I don't want my 
recollection causing problems...

These tests have had the config changed to include serial+console I also 
configured CONFIG_DISABLE_CONSOLE_SUSPEND=y

2.6.21-gf4d6d004-dirty : bad
2.6.21-g920a4b10-dirty : bad
2.6.21-g9666f400-dirty : bad

git-bisect bad
9666f4009c22f6520ac3fb8a19c9e32ab973e828 is first bad commit
commit 9666f4009c22f6520ac3fb8a19c9e32ab973e828
Author: Tejun Heo <htejun@gmail.com>
Date:   Fri May 4 21:27:47 2007 +0200

     libata: reimplement suspend/resume support using sdev->manage_start_stop

Good.

> Jeff added to the Cc, since he may not have noticed that one of the most 
> long-running issues is apparently sata-related.
> 
> (Jeff: David Greaves _also_ had issues with -rc4 due to the SETFXSR 
> change, but that should hopefully be resolved and is presumably an 
> independent bug. Apart from the fact that "sata_via.c" seems problematic)
> 
> 		Linus

So here's a sysrq-t from a failed resume. Ask if you'd like anything else...


SysRq : Show State

                          free                        sibling
   task             PC    stack   pid father child younger older
init          D 00000001     0     1      0 (NOTLB)
        c1941ea0 00000082 00000000 00000001 00000001 00000000 466fc747 28d2d41a
        466fc747 28d2d41a 9120edc4 000001b3 000943a3 00000000 c192e030 c192eb3c
        00000086 00001182 9136dece 000001b3 00000000 00000000 00000000 c1941f08
Call Trace:
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c022f282>] copy_to_user+0x32/0x50
  [<c016a6f9>] sys_select+0x149/0x170
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
kthreadd      S F6BA3F04     0     2      0 (L-TLB)
        c1943fd0 00000046 00000001 f6ba3f04 c1943fb0 c0117627 00000000 00000000
        ffffffff c0104a04 f6ba3f04 00000000 00000003 00000296 f72e15b0 c192e63c
        c1943fd0 00000048 6e2deb31 0000000c 00000a74 c0431298 00000000 00000000
Call Trace:
  [<c0117627>] __wake_up_common+0x37/0x60
  [<c0104a04>] kernel_thread_helper+0x0/0x3c
  [<c012b411>] kthreadd+0x71/0xa0
  [<c012b3a0>] kthreadd+0x0/0xa0
  [<c0104a0b>] kernel_thread_helper+0x7/0x3c
  =======================
ksoftirqd/0   S 000001B3     0     3      2 (L-TLB)
        c1945fc0 00000046 68967778 000001b3 000000fc 00000000 f72eaad0 c192e140
        00000073 c192ea30 68967778 000001b3 c1945f90 00000000 f73a5a50 c192e13c
        c1945fb0 000000a5 9136e544 000001b3 c1945fc0 00000000 c011ef70 fffffffc
Call Trace:
  [<c011ef70>] ksoftirqd+0x0/0x90
  [<c011efeb>] ksoftirqd+0x7b/0x90
  [<c011ef70>] ksoftirqd+0x0/0x90
  [<c012b20a>] kthread+0x6a/0x70
  [<c012b1a0>] kthread+0x0/0x70
  [<c0104a0b>] kernel_thread_helper+0x7/0x3c
  =======================
watchdog/0    S C0369725     0     4      2 (L-TLB)
        c1947fc0 00000046 c1943f70 c0369725 c1947fd0 00000046 c048e0e0 c1932a50
        c1947f90 00000296 2dbc9200 000012ae 5716de49 00000009 c1932550 c1932b5c
        fffffffc 00000ab5 ab8b6f40 00000004 c1947fd0 00000000 c0140290 fffffffc
Call Trace:
  [<c0369725>] schedule+0x2e5/0x580
  [<c0140290>] watchdog+0x0/0x70
  [<c01402de>] watchdog+0x4e/0x70
  [<c0140290>] watchdog+0x0/0x70
  [<c012b20a>] kthread+0x6a/0x70
  [<c012b1a0>] kthread+0x0/0x70
  [<c0104a0b>] kernel_thread_helper+0x7/0x3c
  =======================
events/0      R running     0     5      2 (L-TLB)
khelper       S 00000286     0     6      2 (L-TLB)
        c194bf80 00000046 00000060 00000286 00000000 00000000 c1914c20 c0127a80
        c194bf60 00000001 f66ebb60 c0127a80 00000000 c0127aa5 f73a5a50 c193215c
        c1914c20 000008c7 b1f02986 0000000f c194bfd0 c1914c20 c194bfa8 c1914c28
Call Trace:
  [<c0127a80>] __call_usermodehelper+0x0/0x70
  [<c0127a80>] __call_usermodehelper+0x0/0x70
  [<c0127aa5>] __call_usermodehelper+0x25/0x70
  [<c01280f4>] worker_thread+0xe4/0xf0
  [<c012b5e0>] autoremove_wake_function+0x0/0x50
  [<c012b5e0>] autoremove_wake_function+0x0/0x50
  [<c0128010>] worker_thread+0x0/0xf0
  [<c012b20a>] kthread+0x6a/0x70
  [<c012b1a0>] kthread+0x0/0x70
  [<c0104a0b>] kernel_thread_helper+0x7/0x3c
  =======================
kblockd/0     S C021F890     0    35      2 (L-TLB)
        c19a7f80 00000046 c19146e0 c021f890 00000000 c021f85b c19146e0 c0225790
        f7ea2438 c021f869 5fe478a8 00000009 028a6b4f c021f89b c19b7a70 c19616dc
        0000006e 0000003c 8c1ad4be 00000013 ffffff10 c19146e0 c19a7fa8 c19146e8
Call Trace:
  [<c021f890>] blk_unplug_work+0x0/0x10
  [<c021f85b>] __generic_unplug_device+0x2b/0x30
  [<c0225790>] as_work_handler+0x0/0x20
  [<c021f869>] generic_unplug_device+0x9/0x10
  [<c021f89b>] blk_unplug_work+0xb/0x10
  [<c01280f4>] worker_thread+0xe4/0xf0
  [<c012b5e0>] autoremove_wake_function+0x0/0x50
  [<c012b5e0>] autoremove_wake_function+0x0/0x50
  [<c0128010>] worker_thread+0x0/0xf0
  [<c012b20a>] kthread+0x6a/0x70
  [<c012b1a0>] kthread+0x0/0x70
  [<c0104a0b>] kernel_thread_helper+0x7/0x3c
  =======================
kacpid        S 000012B0     0    36      2 (L-TLB)
        c19a9f80 00000046 8e56e600 000012b0 58472b73 00000009 c192e530 ac2395b9
        c19a9f60 c0116ce7 ac239cdd 00000004 00000077 00000000 c192e530 c19611dc
        00000078 00000117 ac239df7 00000004 c19a9fd0 c19145e0 c19a9fa8 c19145e8
Call Trace:
  [<c0116ce7>] activate_task+0x37/0xb0
  [<c01280f4>] worker_thread+0xe4/0xf0
  [<c012b5e0>] autoremove_wake_function+0x0/0x50
  [<c012b5e0>] autoremove_wake_function+0x0/0x50
  [<c0128010>] worker_thread+0x0/0xf0
  [<c012b20a>] kthread+0x6a/0x70
  [<c012b1a0>] kthread+0x0/0x70
  [<c0104a0b>] kernel_thread_helper+0x7/0x3c
  =======================
kacpi_notify  S 000012B0     0    37      2 (L-TLB)
        c19abf80 00000046 8ef1f200 000012b0 584778f9 00000009 c192e530 ac23bc7c
        c19abf60 c0116ce7 ac6306e3 00000004 00000154 00000000 c1932050 c1969b3c
        00000078 000002f9 ac630a09 00000004 c19abfd0 c19145a0 c19abfa8 c19145a8
Call Trace:
  [<c0116ce7>] activate_task+0x37/0xb0
  [<c01280f4>] worker_thread+0xe4/0xf0
  [<c012b5e0>] autoremove_wake_function+0x0/0x50
  [<c012b5e0>] autoremove_wake_function+0x0/0x50
  [<c0128010>] worker_thread+0x0/0xf0
  [<c012b20a>] kthread+0x6a/0x70
  [<c012b1a0>] kthread+0x0/0x70
  [<c0104a0b>] kernel_thread_helper+0x7/0x3c
  =======================
ata/0         S 0000000A     0   121      2 (L-TLB)
        c19ddf80 00000046 00000060 0000000a 00000000 00000009 f7f40000 f7f41e90
        00000000 c02c9acb 64c028bc 00000009 00023d66 00000000 c19615d0 c19b3b5c
        0000006e 00003906 64c028bc 00000009 c19ddfd0 c19989e0 c19ddfa8 c19989e8
Call Trace:
  [<c02c9acb>] ata_pio_task+0x5b/0xe0
  [<c01280f4>] worker_thread+0xe4/0xf0
  [<c012b5e0>] autoremove_wake_function+0x0/0x50
  [<c012b5e0>] autoremove_wake_function+0x0/0x50
  [<c0128010>] worker_thread+0x0/0xf0
  [<c012b20a>] kthread+0x6a/0x70
  [<c012b1a0>] kthread+0x0/0x70
  [<c0104a0b>] kernel_thread_helper+0x7/0x3c
  =======================
ata_aux       D F65F09A4     0   122      2 (L-TLB)
        c19dfd20 00000046 f786c800 f65f09a4 f7ea23b8 c02bcdef ce2e3b9f 4d64703f
        ffffcfff f7ea23b8 00000082 f7ea2418 0005eb1d 00000082 f7c9f0b0 c196913c
        f786c800 000003d4 605db977 00000009 f7ea23b8 c19dfe08 f65f09a4 c19dfd3c
Call Trace:
  [<c02bcdef>] scsi_prep_fn+0x8f/0x130
  [<c0369a24>] wait_for_completion+0x64/0xa0
  [<c01175e0>] default_wake_function+0x0/0x10
  [<c021f85b>] __generic_unplug_device+0x2b/0x30
  [<c01175e0>] default_wake_function+0x0/0x10
  [<c02207a7>] blk_execute_rq+0xa7/0xe0
  [<c0220970>] blk_end_sync_rq+0x0/0x30
  [<c0146a8f>] buffered_rmqueue+0x9f/0x100
  [<c0146c50>] get_page_from_freelist+0x80/0xc0
  [<c02bbd48>] scsi_execute+0xb8/0x110
  [<c02bbe0b>] scsi_execute_req+0x6b/0x90
  [<c02c22f6>] sd_spinup_disk+0x76/0x440
  [<c02c36fe>] sd_revalidate_disk+0x6e/0x160
  [<c02c17a4>] __scsi_disk_get+0x34/0x40
  [<c02c200d>] sd_rescan+0x1d/0x40
  [<c02bf350>] scsi_rescan_device+0x40/0x50
  [<c02ce39c>] ata_scsi_dev_rescan+0x5c/0x70
  [<c02ce340>] ata_scsi_dev_rescan+0x0/0x70
  [<c0127f2a>] run_workqueue+0x4a/0xf0
  [<c01280dd>] worker_thread+0xcd/0xf0
  [<c012b5e0>] autoremove_wake_function+0x0/0x50
  [<c012b5e0>] autoremove_wake_function+0x0/0x50
  [<c0128010>] worker_thread+0x0/0xf0
  [<c012b20a>] kthread+0x6a/0x70
  [<c012b1a0>] kthread+0x0/0x70
  [<c0104a0b>] kernel_thread_helper+0x7/0x3c
  =======================
kseriod       D C0369725     0   123      2 (L-TLB)
        c1971f60 00000046 f6d0ff90 c0369725 c1971f70 00000046 c0443c08 c1971fa8
        00000000 c0444de0 91c4e988 000001b3 00002028 00000000 c19b3050 c196963c
        00000073 00000120 91c535b2 000001b3 00000000 00000000 c02da2d0 c1971fa8
Call Trace:
  [<c0369725>] schedule+0x2e5/0x580
  [<c02da2d0>] serio_thread+0x0/0x100
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c02da3c8>] serio_thread+0xf8/0x100
  [<c0117627>] __wake_up_common+0x37/0x60
  [<c012b5e0>] autoremove_wake_function+0x0/0x50
  [<c012b5e0>] autoremove_wake_function+0x0/0x50
  [<c02da2d0>] serio_thread+0x0/0x100
  [<c012b20a>] kthread+0x6a/0x70
  [<c012b1a0>] kthread+0x0/0x70
  [<c0104a0b>] kernel_thread_helper+0x7/0x3c
  =======================
pdflush       D C0369725     0   145      2 (L-TLB)
        c19cdf70 00000046 c1971f60 c0369725 c19cdf80 00000046 ef006e00 000012ca
        65778037 00000009 91c4eb5e 000001b3 00002124 00000000 c19b7a70 c19b315c
        00000073 0000006a 91c539de 000001b3 00000000 00000000 c19cdfa8 fffffffc
Call Trace:
  [<c0369725>] schedule+0x2e5/0x580
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01487c5>] __pdflush+0x145/0x150
  [<c01487d0>] pdflush+0x0/0x30
  [<c01487d0>] pdflush+0x0/0x30
  [<c01487f5>] pdflush+0x25/0x30
  [<c01487d0>] pdflush+0x0/0x30
  [<c012b20a>] kthread+0x6a/0x70
  [<c012b1a0>] kthread+0x0/0x70
  [<c0104a0b>] kernel_thread_helper+0x7/0x3c
  =======================
pdflush       D C0369725     0   146      2 (L-TLB)
        c19cff70 00000046 c19cdf70 c0369725 c19cff80 00000046 00000001 c19cff48
        c19cff74 c19615d0 91c4f11f 000001b3 00002016 00000000 f7d5f550 c19b7b7c
        00000076 00000067 4270ffb6 0000000a 00000000 00000000 c19cffa8 fffffffc
Call Trace:
  [<c0369725>] schedule+0x2e5/0x580
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01487c5>] __pdflush+0x145/0x150
  [<c01487d0>] pdflush+0x0/0x30
  [<c01487d0>] pdflush+0x0/0x30
  [<c01487f5>] pdflush+0x25/0x30
  [<c0147c30>] wb_kupdate+0x0/0xf0
  [<c01487d0>] pdflush+0x0/0x30
  [<c012b20a>] kthread+0x6a/0x70
  [<c012b1a0>] kthread+0x0/0x70
  [<c0104a0b>] kernel_thread_helper+0x7/0x3c
  =======================
kswapd0       D C0369725     0   147      2 (L-TLB)
        c1981f50 00000046 f67a5e90 c0369725 c1981f60 00000046 c1955550 00000000
        c1981f78 c018dcac 91c4dbf7 000001b3 00000c71 00000000 f7d61070 c19b767c
        0000006e 000000c5 91c4f96f 000001b3 00000000 00000000 c0434f44 00000000
Call Trace:
  [<c0369725>] schedule+0x2e5/0x580
  [<c018dcac>] proc_flush_task+0x4c/0x1a0
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c014b4d1>] kswapd+0xe1/0x110
  [<c0369725>] schedule+0x2e5/0x580
  [<c012b5e0>] autoremove_wake_function+0x0/0x50
  [<c012b5e0>] autoremove_wake_function+0x0/0x50
  [<c014b3f0>] kswapd+0x0/0x110
  [<c012b20a>] kthread+0x6a/0x70
  [<c012b1a0>] kthread+0x0/0x70
  [<c0104a0b>] kernel_thread_helper+0x7/0x3c
  =======================
aio/0         S 000012CA     0   148      2 (L-TLB)
        c1a71f80 00000046 f91aea00 000012ca 657c8d75 00000009 c192e530 b2be46ba
        c1a71f60 c0116ce7 b2c07abe 00000004 000000b0 00000000 c192e530 c19b717c
        00000078 000001a2 b2c07c5f 00000004 c1a71fd0 c199be20 c1a71fa8 c199be28
Call Trace:
  [<c0116ce7>] activate_task+0x37/0xb0
  [<c01280f4>] worker_thread+0xe4/0xf0
  [<c012b5e0>] autoremove_wake_function+0x0/0x50
  [<c012b5e0>] autoremove_wake_function+0x0/0x50
  [<c0128010>] worker_thread+0x0/0xf0
  [<c012b20a>] kthread+0x6a/0x70
  [<c012b1a0>] kthread+0x0/0x70
  [<c0104a0b>] kernel_thread_helper+0x7/0x3c
  =======================
xfslogd/0     S F74D6EE0     0   149      2 (L-TLB)
        c1a73f80 00000046 f74d2500 f74d6ee0 f78a64e0 c01f3421 00000000 b2c09d9a
        c1a73f60 00000246 f6f22840 c199b9e0 f6f22cc0 f6f22d1c c199b9e0 c19bbb9c
        00000000 0000004a 91980244 000001b3 c1a73fd0 c199b9e0 c1a73fa8 c199b9e8
Call Trace:
  [<c01f3421>] xlog_iodone+0x51/0xd0
  [<c01280f4>] worker_thread+0xe4/0xf0
  [<c012b5e0>] autoremove_wake_function+0x0/0x50
  [<c012b5e0>] autoremove_wake_function+0x0/0x50
  [<c0128010>] worker_thread+0x0/0xf0
  [<c012b20a>] kthread+0x6a/0x70
  [<c012b1a0>] kthread+0x0/0x70
  [<c0104a0b>] kernel_thread_helper+0x7/0x3c
  =======================
xfsdatad/0    S 00000000     0   150      2 (L-TLB)
        c1a75f80 00000046 00000000 00000000 00000000 00000246 00000000 c19e17f0
        00000000 c199e820 c199b9a0 c020c690 00000000 c014557a c19b7a70 c19bb69c
        c199b9a0 00000049 91b5c447 000001b3 c1a75fd0 c199b9a0 c1a75fa8 c199b9a8
Call Trace:
  [<c020c690>] xfs_end_bio_read+0x0/0x10
  [<c014557a>] mempool_free+0x2a/0x60
  [<c01280f4>] worker_thread+0xe4/0xf0
  [<c012b5e0>] autoremove_wake_function+0x0/0x50
  [<c012b5e0>] autoremove_wake_function+0x0/0x50
  [<c0128010>] worker_thread+0x0/0xf0
  [<c012b20a>] kthread+0x6a/0x70
  [<c012b1a0>] kthread+0x0/0x70
  [<c0104a0b>] kernel_thread_helper+0x7/0x3c
  =======================
scsi_eh_0     S F7C98084     0   774      2 (L-TLB)
        f7fa1fc0 00000046 00000246 f7c98084 f7c98000 00000246 c1a6f044 00000001
        00000003 00000000 a35b398a 00000005 00000e17 00000000 c1932550 f7cbab5c
        0000006e 0019a81a a35b398a 00000005 00000000 c1a6f000 c02bb740 fffffffc
Call Trace:
  [<c02bb740>] scsi_error_handler+0x0/0xa0
  [<c02bb781>] scsi_error_handler+0x41/0xa0
  [<c02bb740>] scsi_error_handler+0x0/0xa0
  [<c012b20a>] kthread+0x6a/0x70
  [<c012b1a0>] kthread+0x0/0x70
  [<c0104a0b>] kernel_thread_helper+0x7/0x3c
  =======================
scsi_eh_1     S F7C64084     0   776      2 (L-TLB)
        c1ad3fc0 00000046 00000246 f7c64084 f7c64000 00000246 f78b3c44 00000001
        00000003 00000000 00000292 fffffffc c1ad3fb0 00000246 c192ea30 f7d6167c
        00000000 0019d570 c305aee5 00000005 00000000 f78b3c00 c02bb740 fffffffc
Call Trace:
  [<c02bb740>] scsi_error_handler+0x0/0xa0
  [<c02bb781>] scsi_error_handler+0x41/0xa0
  [<c02bb740>] scsi_error_handler+0x0/0xa0
  [<c012b20a>] kthread+0x6a/0x70
  [<c012b1a0>] kthread+0x0/0x70
  [<c0104a0b>] kernel_thread_helper+0x7/0x3c
  =======================
scsi_eh_2     S C1AD4084     0   778      2 (L-TLB)
        f7d5dfc0 00000046 00000246 c1ad4084 c1ad4000 00000246 f78b3844 00000001
        00000003 00000000 00000292 fffffffc f7d5dfb0 00000246 c192ea30 f7efd65c
        00000000 001a0997 e2bc559e 00000005 00000000 f78b3800 c02bb740 fffffffc
Call Trace:
  [<c02bb740>] scsi_error_handler+0x0/0xa0
  [<c02bb781>] scsi_error_handler+0x41/0xa0
  [<c02bb740>] scsi_error_handler+0x0/0xa0
  [<c012b20a>] kthread+0x6a/0x70
  [<c012b1a0>] kthread+0x0/0x70
  [<c0104a0b>] kernel_thread_helper+0x7/0x3c
  =======================
scsi_eh_3     S F7FC4084     0   780      2 (L-TLB)
        c1a77fc0 00000046 00000246 f7fc4084 f7fc4000 00000246 f78b3444 00000001
        00000003 00000000 02d2bfed 00000006 0000067f 00000000 c1932550 f7d61b7c
        0000006e 001c7d7b 02d2bfed 00000006 00000000 f78b3400 c02bb740 fffffffc
Call Trace:
  [<c02bb740>] scsi_error_handler+0x0/0xa0
  [<c02bb781>] scsi_error_handler+0x41/0xa0
  [<c02bb740>] scsi_error_handler+0x0/0xa0
  [<c012b20a>] kthread+0x6a/0x70
  [<c012b1a0>] kthread+0x0/0x70
  [<c0104a0b>] kernel_thread_helper+0x7/0x3c
  =======================
scsi_eh_4     S F786C800     0   803      2 (L-TLB)
        f7fc3fc0 00000046 f786c800 f786c800 f7ea23b8 c02bd166 f7964044 f7ea23b8
        00000292 c021f7f2 6154d436 00000009 002f304e 00000000 c1932550 f7d0915c
        0000006e 000ec1d6 6154d436 00000009 00000000 f7964000 c02bb740 fffffffc
Call Trace:
  [<c02bd166>] scsi_request_fn+0x196/0x280
  [<c021f7f2>] blk_remove_plug+0x32/0x70
  [<c02bb740>] scsi_error_handler+0x0/0xa0
  [<c02bb781>] scsi_error_handler+0x41/0xa0
  [<c02bb740>] scsi_error_handler+0x0/0xa0
  [<c012b20a>] kthread+0x6a/0x70
  [<c012b1a0>] kthread+0x0/0x70
  [<c0104a0b>] kernel_thread_helper+0x7/0x3c
  =======================
scsi_eh_5     S F786C400     0   805      2 (L-TLB)
        f7e3ffc0 00000046 f786c400 f786c400 f7ea2730 c02bd166 f786cc44 f7ea2730
        00000292 c021f7f2 67583eed 00000009 002f0e42 00000000 c19615d0 f7c9f1bc
        0000006e 000ec010 67583eed 00000009 00000000 f786cc00 c02bb740 fffffffc
Call Trace:
  [<c02bd166>] scsi_request_fn+0x196/0x280
  [<c021f7f2>] blk_remove_plug+0x32/0x70
  [<c02bb740>] scsi_error_handler+0x0/0xa0
  [<c02bb781>] scsi_error_handler+0x41/0xa0
  [<c02bb740>] scsi_error_handler+0x0/0xa0
  [<c012b20a>] kthread+0x6a/0x70
  [<c012b1a0>] kthread+0x0/0x70
  [<c0104a0b>] kernel_thread_helper+0x7/0x3c
  =======================
kpsmoused     S 000019B6     0   826      2 (L-TLB)
        f7e81f80 00000046 b68df400 000019b6 db5b46fa 0000000c c192e530 6dada37d
        f7e81f60 c0116ce7 6dadbfd3 00000006 000000a8 00000000 c1932050 f7d5fb5c
        00000078 00000029 6dadc163 00000006 f7e81fd0 f7fa9c20 f7e81fa8 f7fa9c28
Call Trace:
  [<c0116ce7>] activate_task+0x37/0xb0
  [<c01280f4>] worker_thread+0xe4/0xf0
  [<c012b5e0>] autoremove_wake_function+0x0/0x50
  [<c012b5e0>] autoremove_wake_function+0x0/0x50
  [<c0128010>] worker_thread+0x0/0xf0
  [<c012b20a>] kthread+0x6a/0x70
  [<c012b1a0>] kthread+0x0/0x70
  [<c0104a0b>] kernel_thread_helper+0x7/0x3c
  =======================
md0_raid5     D 1D3836C7     0   836      2 (L-TLB)
        f7cbfdf0 00000046 f7ea3888 1d3836c7 00000008 c0221036 06a47600 00011210
        c191ede0 c01454ba 5324bddc 00000009 0002fb08 00000000 f7d09050 f7e2c6bc
        0000006e 0000320f 532bcd0b 00000009 f7ea3888 c1a4f000 f7cbfe18 c1a4f13c
Call Trace:
  [<c0221036>] generic_make_request+0x146/0x1d0
  [<c01454ba>] mempool_alloc+0x2a/0xc0
  [<c02f639e>] md_super_wait+0x7e/0xc0
  [<c012b5e0>] autoremove_wake_function+0x0/0x50
  [<c017eff1>] bio_clone+0x31/0x40
  [<c012b5e0>] autoremove_wake_function+0x0/0x50
  [<c02fe880>] write_sb_page+0x50/0x80
  [<c02fe9c2>] write_page+0x112/0x120
  [<c02f8247>] sync_sbs+0x77/0xe0
  [<c02fed09>] bitmap_update_sb+0x69/0xa0
  [<c02f83e8>] md_update_sb+0x138/0x2c0
  [<c0369725>] schedule+0x2e5/0x580
  [<c02fe2dd>] md_check_recovery+0x2dd/0x360
  [<c02f11e0>] raid5d+0x10/0xe0
  [<c02fc7c5>] md_thread+0x55/0x110
  [<c012b5e0>] autoremove_wake_function+0x0/0x50
  [<c012b5e0>] autoremove_wake_function+0x0/0x50
  [<c02fc770>] md_thread+0x0/0x110
  [<c012b20a>] kthread+0x6a/0x70
  [<c012b1a0>] kthread+0x0/0x70
  [<c0104a0b>] kernel_thread_helper+0x7/0x3c
  =======================
xfsbufd       D F7D6117C     0   839      2 (L-TLB)
        f74dffa0 00000046 00000282 f7d6117c 0005eadc 000000de 00000282 f74dff88
        00000000 00000282 91c4e16c 000001b3 00000eb5 00000000 f7c51a30 f7d6117c
        0000006e 00000115 91c50443 000001b3 00000000 00000000 00000000 f74ccfa0
Call Trace:
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c020fd80>] xfsbufd+0xf0/0x100
  [<c020fc90>] xfsbufd+0x0/0x100
  [<c012b20a>] kthread+0x6a/0x70
  [<c012b1a0>] kthread+0x0/0x70
  [<c0104a0b>] kernel_thread_helper+0x7/0x3c
  =======================
xfssyncd      D F7D5F65C     0   840      2 (L-TLB)
        f775ff90 00000046 00000282 f7d5f65c 00060a54 00001d76 00000282 f775ff78
        00000000 00000282 91c4fd9e 000001b3 00001d19 00000000 f7348090 f7d5f65c
        00000078 000002b5 91c5428a 000001b3 00000000 00000000 f775ffb8 f78a93dc
Call Trace:
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c0215aab>] xfssyncd+0x15b/0x160
  [<c0215950>] xfssyncd+0x0/0x160
  [<c012b20a>] kthread+0x6a/0x70
  [<c012b1a0>] kthread+0x0/0x70
  [<c0104a0b>] kernel_thread_helper+0x7/0x3c
  =======================
udevd         D 00000010     0   921      1 (NOTLB)
        f7043ea0 00000082 f66ec590 00000010 c1913ba0 f67ba22c 407ef268 00000010
        c1913ba0 f7fa5cb4 9133dae2 000001b3 00006df1 00000000 f7348590 f7cba65c
        00000075 00000567 9134df46 000001b3 00000000 00000000 00000000 f7043f08
Call Trace:
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c011d7bb>] do_wait+0x1bb/0x3b0
  [<c016e8bd>] shrink_dcache_parent+0xd/0x30
  [<c01175e0>] default_wake_function+0x0/0x10
  [<c016a659>] sys_select+0xa9/0x170
  [<c011da71>] sys_wait4+0x31/0x40
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
ksuspend_usbd S 00002061     0  1822      2 (L-TLB)
        f6c81f80 00000046 f9766400 00002061 30fcbb32 00000010 c192e530 187e5d99
        f6c81f60 c0116ce7 c048e0e0 c192e530 f6c81f60 c0116be1 f7c51a30 f735867c
        f7358570 000003e1 19639b4d 00000008 f6c81fd0 f71611a0 f6c81fa8 f71611a8
Call Trace:
  [<c0116ce7>] activate_task+0x37/0xb0
  [<c0116be1>] __activate_task+0x21/0x40
  [<c01280f4>] worker_thread+0xe4/0xf0
  [<c012b5e0>] autoremove_wake_function+0x0/0x50
  [<c012b5e0>] autoremove_wake_function+0x0/0x50
  [<c0128010>] worker_thread+0x0/0xf0
  [<c012b20a>] kthread+0x6a/0x70
  [<c012b1a0>] kthread+0x0/0x70
  [<c0104a0b>] kernel_thread_helper+0x7/0x3c
  =======================
khubd         D C0369725     0  1825      2 (L-TLB)
        f75adf70 00000046 f74dffa0 c0369725 f75adf80 00000046 00000023 00000011
        00000002 f882a3a5 91c4e5a2 000001b3 000010e3 00000000 f73a25d0 f7c51b3c
        0000006e 000000f0 91c50da4 000001b3 00000000 00000000 f882d180 f75adfa8
Call Trace:
  [<c0369725>] schedule+0x2e5/0x580
  [<f882a3a5>] usb_get_intf+0x15/0x20 [usbcore]
  [<f882d180>] hub_thread+0x0/0xf0 [usbcore]
  [<c013b27c>] refrigerator+0x3c/0x50
  [<f882d1d5>] hub_thread+0x55/0xf0 [usbcore]
  [<c012b5e0>] autoremove_wake_function+0x0/0x50
  [<c012b5e0>] autoremove_wake_function+0x0/0x50
  [<f882d180>] hub_thread+0x0/0xf0 [usbcore]
  [<c012b20a>] kthread+0x6a/0x70
  [<c012b1a0>] kthread+0x0/0x70
  [<c0104a0b>] kernel_thread_helper+0x7/0x3c
  =======================
ksnapd        S 000025EF     0  2132      2 (L-TLB)
        f7237f80 00000046 6f8a7a00 000025ef f7b7c53d 00000012 c192e530 7bdbe29e
        f7237f60 c0116ce7 c048e0e0 c192e530 f7237f60 c0116be1 c19bb090 f730e67c
        f730e570 0000007c 7bea9794 00000009 f7237fd0 f71c9360 f7237fa8 f71c9368
Call Trace:
  [<c0116ce7>] activate_task+0x37/0xb0
  [<c0116be1>] __activate_task+0x21/0x40
  [<c01280f4>] worker_thread+0xe4/0xf0
  [<c012b5e0>] autoremove_wake_function+0x0/0x50
  [<c012b5e0>] autoremove_wake_function+0x0/0x50
  [<c0128010>] worker_thread+0x0/0xf0
  [<c012b20a>] kthread+0x6a/0x70
  [<c012b1a0>] kthread+0x0/0x70
  [<c0104a0b>] kernel_thread_helper+0x7/0x3c
  =======================
kjournald     D C0369725     0  2178      2 (L-TLB)
        f6d71f40 00000046 f75adf70 c0369725 f6d71f50 00000046 00000000 f6d0dd38
        00000000 c0117627 91c4e939 000001b3 000012d7 00000000 c19bb090 f73a26dc
        0000006e 000000d2 91c515db 000001b3 00000000 00000000 f73a25d0 00000001
Call Trace:
  [<c0369725>] schedule+0x2e5/0x580
  [<c0117627>] __wake_up_common+0x37/0x60
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01ac221>] kjournald+0xd1/0x1d0
  [<c012b5e0>] autoremove_wake_function+0x0/0x50
  [<c012b5e0>] autoremove_wake_function+0x0/0x50
  [<c01ac150>] kjournald+0x0/0x1d0
  [<c012b20a>] kthread+0x6a/0x70
  [<c012b1a0>] kthread+0x0/0x70
  [<c0104a0b>] kernel_thread_helper+0x7/0x3c
  =======================
xfsbufd       D C19BB19C     0  2179      2 (L-TLB)
        f6d29fa0 00000046 00000282 c19bb19c 0005eb4b 00000085 00000282 f6d29f88
        00000000 00000282 91c4ec56 000001b3 0000145d 00000000 c1961ad0 c19bb19c
        0000006e 000000ab 91c51c91 000001b3 00000000 00000000 00000000 f6d44aa0
Call Trace:
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c020fd80>] xfsbufd+0xf0/0x100
  [<c020fc90>] xfsbufd+0x0/0x100
  [<c012b20a>] kthread+0x6a/0x70
  [<c012b1a0>] kthread+0x0/0x70
  [<c0104a0b>] kernel_thread_helper+0x7/0x3c
  =======================
xfssyncd      D C1961BDC     0  2183      2 (L-TLB)
        f6881f90 00000046 00000282 c1961bdc 0005f177 00000269 00000282 f6881f78
        00000000 00000282 91c4efba 000001b3 000015d2 00000000 f7cb10b0 c1961bdc
        0000006e 000000af 91c52369 000001b3 00000000 00000000 f6881fb8 f6d45c3c
Call Trace:
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c0215aab>] xfssyncd+0x15b/0x160
  [<c0215950>] xfssyncd+0x0/0x160
  [<c012b20a>] kthread+0x6a/0x70
  [<c012b1a0>] kthread+0x0/0x70
  [<c0104a0b>] kernel_thread_helper+0x7/0x3c
  =======================
xfsbufd       D F7CB11BC     0  2184      2 (L-TLB)
        f6a33fa0 00000046 00000282 f7cb11bc 0005eb9d 00000067 00000282 f6a33f88
        00000000 00000282 91c4f278 000001b3 0000171e 00000000 f73945b0 f7cb11bc
        0000006e 00000094 91c52939 000001b3 00000000 00000000 00000000 f74cc720
Call Trace:
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c020fd80>] xfsbufd+0xf0/0x100
  [<c020fc90>] xfsbufd+0x0/0x100
  [<c012b20a>] kthread+0x6a/0x70
  [<c012b1a0>] kthread+0x0/0x70
  [<c0104a0b>] kernel_thread_helper+0x7/0x3c
  =======================
xfssyncd      D F73946BC     0  2185      2 (L-TLB)
        f6d0ff90 00000046 00000282 f73946bc 0005f197 00000153 00000282 f6d0ff78
        00000000 00000282 91c4e688 000001b3 00001e93 00000000 c1969530 f73946bc
        00000072 00000092 91c52ef2 000001b3 00000000 00000000 f6d0ffb8 f6d4573c
Call Trace:
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c0215aab>] xfssyncd+0x15b/0x160
  [<c0215950>] xfssyncd+0x0/0x160
  [<c012b20a>] kthread+0x6a/0x70
  [<c012b1a0>] kthread+0x0/0x70
  [<c0104a0b>] kernel_thread_helper+0x7/0x3c
  =======================
portmap       D F6BA6684     0  2341      1 (NOTLB)
        f6d0dea0 00000086 00000282 f6ba6684 f6ba64a0 c033b7e6 00000282 f6ba64a0
        f6ba64a0 c034d144 913389cf 000001b3 00002e10 00000000 f7358070 f730cb9c
        00000073 000002ae 9133f6e9 000001b3 00000000 00000000 0804ff78 f6d0df08
Call Trace:
  [<c033b7e6>] inet_csk_clear_xmit_timers+0x36/0x50
  [<c034d144>] tcp_v4_destroy_sock+0x14/0x150
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c017c44d>] invalidate_inode_buffers+0xd/0xa0
  [<c016dfb0>] d_kill+0x40/0x60
  [<c016dfec>] dput+0x1c/0xe0
  [<c015fa94>] __fput+0xf4/0x160
  [<c017272c>] mntput_no_expire+0x1c/0x70
  [<c015e2d3>] filp_close+0x43/0x70
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
syslogd       D F77A1F28     0  2478      1 (NOTLB)
        f77a1ea0 00000086 f7fbe804 f77a1f28 00000000 00000001 ffffffff f7c20940
        00000000 00000000 91338d55 000001b3 00002e6f 00000000 f7358a70 f735817c
        00000073 00000070 9133fb50 000001b3 00000000 00000000 00000000 f77a1f08
Call Trace:
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c015f20a>] do_readv_writev+0xaa/0x190
  [<c0163fb0>] pipe_write+0x0/0x400
  [<c016a659>] sys_select+0xa9/0x170
  [<c0124675>] sigprocmask+0x45/0xb0
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
klogd         D C04953A0     0  2484      1 (NOTLB)
        f6809ea0 00000086 f68d0a20 c04953a0 f6809dc8 f6809e58 00000000 00000000
        f6809eb0 00000001 913380eb 000001b3 0000267d 00000000 f730ca90 f7c9e69c
        00000073 000000b5 9133dc16 000001b3 00000000 00000000 00000000 f6809f08
Call Trace:
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c0111b80>] smp_apic_timer_interrupt+0x30/0x40
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c011a8b2>] do_syslog+0xf2/0x350
  [<c012b5e0>] autoremove_wake_function+0x0/0x50
  [<c012b5e0>] autoremove_wake_function+0x0/0x50
  [<c015ea84>] vfs_read+0xe4/0x110
  [<c015ed07>] sys_read+0x47/0x80
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
sshd          D F7215BF8     0  2506      1 (NOTLB)
        f6a2dea0 00200082 f687e360 f7215bf8 00000000 f6a2de58 00000000 00000000
        f6a2deb0 00000001 91339d89 000001b3 00002dd0 00000000 f730c090 f7358b7c
        00000073 00000179 91340a0c 000001b3 00000000 00000000 00000000 f6a2df08
Call Trace:
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c014eb79>] do_wp_page+0x299/0x3b0
  [<c017c44d>] invalidate_inode_buffers+0xd/0xa0
  [<c016dfb0>] d_kill+0x40/0x60
  [<c016a659>] sys_select+0xa9/0x170
  [<c017272c>] mntput_no_expire+0x1c/0x70
  [<c015e2d3>] filp_close+0x43/0x70
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
exim4         D 00000000     0  2546      1 (NOTLB)
        f6835ea0 00000086 f6520a30 00000000 00000000 f6520a30 f6520a30 00000000
        bf896808 c018dcac f6835e88 0000000d c03f1d32 00000f42 f72e1ab0 f7e2cbbc
        f6835e88 00000235 9134f609 000001b3 00000000 00000000 00000000 f6835f08
Call Trace:
  [<c018dcac>] proc_flush_task+0x4c/0x1a0
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c011d7bb>] do_wait+0x1bb/0x3b0
  [<c011dea1>] do_setitimer+0x1f1/0x280
  [<c016a659>] sys_select+0xa9/0x170
  [<c011da71>] sys_wait4+0x31/0x40
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
inetd         D 00000000     0  2552      1 (NOTLB)
        f6a29ea0 00000082 00000000 00000000 662f6984 c0437200 f6845bc0 f6a29eb8
        c195f8c0 c02101b8 00000001 00000000 00000001 00000000 f7394ab0 f72e1bbc
        f6a29eb0 000004f5 913518bf 000001b3 00000000 00000000 00000000 f6a29f08
Call Trace:
  [<c02101b8>] xfs_file_aio_read+0x78/0x90
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c014f682>] do_no_page+0x162/0x280
  [<c014f9da>] __handle_mm_fault+0xfa/0x1e0
  [<c0115c7b>] do_page_fault+0x39b/0x590
  [<c016a659>] sys_select+0xa9/0x170
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
lpd           D 00000001     0  2556      1 (NOTLB)
        f6a8fea0 00000086 f7ddeb40 00000001 c1913ba0 f6870114 fcd011e4 00000007
        f7312005 c03121f7 00000005 bf9e2660 00000007 00000044 f73a20d0 f7394bbc
        f780c800 00000267 91352994 000001b3 00000000 00000000 00000000 f6a8ff08
Call Trace:
  [<c03121f7>] sys_socketcall+0x87/0x250
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c015db55>] chown_common+0xa5/0xd0
  [<c016dfec>] dput+0x1c/0xe0
  [<c03115c2>] sys_listen+0x42/0x70
  [<c016a659>] sys_select+0xa9/0x170
  [<c0124675>] sigprocmask+0x45/0xb0
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
mysqld_safe   D F721BBF8     0  2571      1 (NOTLB)
        f6acdea0 00000086 00000010 f721bbf8 f722f8c0 f71fb700 00000000 00000004
        c0434f00 f7240bf8 f721bbf8 bf953000 bf953000 c014d94d f72ea5d0 f73a21dc
        f73a20d0 00000148 9135328e 000001b3 00000000 00000000 081041c8 f6acdf08
Call Trace:
  [<c014d94d>] copy_page_range+0x9d/0xd0
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c011d7bb>] do_wait+0x1bb/0x3b0
  [<c01175e0>] default_wake_function+0x0/0x10
  [<c0124e76>] do_sigaction+0x116/0x150
  [<c01175e0>] default_wake_function+0x0/0x10
  [<c012513d>] sys_rt_sigaction+0x8d/0xa0
  [<c011da71>] sys_wait4+0x31/0x40
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
mysqld        D 00000000     0  2608   2571 (NOTLB)
        f685fea0 00000086 f77b87bc 00000000 00000001 c0434c64 c0434f04 00000044
        c0434f00 c0146c50 9133fd28 000001b3 00008a1b 00000000 f72e10b0 f72ea6dc
        00000076 00000287 91354440 000001b3 00000000 00000000 00000000 f685ff08
Call Trace:
  [<c0146c50>] get_page_from_freelist+0x80/0xc0
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c011952d>] copy_process+0x55d/0xb30
  [<c01527e8>] change_protection+0x78/0xc0
  [<c0116be1>] __activate_task+0x21/0x40
  [<c016a659>] sys_select+0xa9/0x170
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
mysqld        D F7127D94     0  2610   2571 (NOTLB)
        f6a25ea0 00000086 08a45aa0 f7127d94 08a45aa0 c0134f9c 00000246 c17a5ca0
        c0434da8 c0146a8f 00000000 00000000 f7348590 00000001 f7e2cab0 f734869c
        c0434f14 000000e9 9134e692 000001b3 00000000 00000000 00000000 f6a25f08
Call Trace:
  [<c0134f9c>] futex_wait+0x2fc/0x3c0
  [<c0146a8f>] buffered_rmqueue+0x9f/0x100
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c014f4a5>] do_anonymous_page+0xb5/0x130
  [<c014f98f>] __handle_mm_fault+0xaf/0x1e0
  [<c01175e0>] default_wake_function+0x0/0x10
  [<c0135cf3>] do_futex+0x53/0x130
  [<c0135e35>] sys_futex+0x65/0xf0
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
mysqld        D F7127D94     0  2611   2571 (NOTLB)
        f6a03ea0 00000086 08a45b10 f7127d94 08a45b10 c0134f9c 00000000 f6a03ee0
        f6a03e70 c0369f41 9133a6b3 000001b3 000030e1 00000000 f730c590 f730c19c
        00000073 000001a4 91341a7a 000001b3 00000000 00000000 00000000 f6a03f08
Call Trace:
  [<c0134f9c>] futex_wait+0x2fc/0x3c0
  [<c0369f41>] io_schedule+0x11/0x20
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c014975a>] pagevec_lookup_tag+0x2a/0x50
  [<c014951b>] __pagevec_release+0x1b/0x30
  [<c01423ea>] wait_on_page_writeback_range+0x6a/0x110
  [<c020128c>] xfs_trans_ijoin+0x2c/0x80
  [<c01175e0>] default_wake_function+0x0/0x10
  [<c0206555>] xfs_fsync+0x1b5/0x1d0
  [<c0135cf3>] do_futex+0x53/0x130
  [<c0135e35>] sys_futex+0x65/0xf0
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
mysqld        D F7127D94     0  2612   2571 (NOTLB)
        f6a09ea0 00000086 08a45b80 f7127d94 08a45b80 c0134f9c 00000246 c1760960
        c0434da8 c0146a8f 00000000 00000000 f72e10b0 0000001b f7d5f050 f72e11bc
        c0434f14 0000011d 91354c0e 000001b3 00000000 00000000 00000000 f6a09f08
Call Trace:
  [<c0134f9c>] futex_wait+0x2fc/0x3c0
  [<c0146a8f>] buffered_rmqueue+0x9f/0x100
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c014f4a5>] do_anonymous_page+0xb5/0x130
  [<c014f98f>] __handle_mm_fault+0xaf/0x1e0
  [<c01175e0>] default_wake_function+0x0/0x10
  [<c0135cf3>] do_futex+0x53/0x130
  [<c0135e35>] sys_futex+0x65/0xf0
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
mysqld        D F7127D94     0  2613   2571 (NOTLB)
        f6a2bea0 00000086 08a45bf0 f7127d94 08a45bf0 c0134f9c c048e0e0 f7cb15b0
        f6a2be70 c0116be1 9133b006 000001b3 00002fcc 00000000 f7d09a50 f730c69c
        00000073 000000ac 9134213a 000001b3 00000000 00000000 00000000 f6a2bf08
Call Trace:
  [<c0134f9c>] futex_wait+0x2fc/0x3c0
  [<c0116be1>] __activate_task+0x21/0x40
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c0133d5e>] wake_futex+0x2e/0x50
  [<c01348a7>] futex_requeue+0xb7/0x1d0
  [<c01175e0>] default_wake_function+0x0/0x10
  [<c0135cf3>] do_futex+0x53/0x130
  [<c0135e35>] sys_futex+0x65/0xf0
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
mysqld        D 00000001     0  2616   2571 (NOTLB)
        f6ff7ea0 00000086 f72944a0 00000001 00000000 c014557a f6ff7e68 c1965e94
        f72944a0 c017eef6 c176b8e0 00000000 00000086 00000048 f7c9f5b0 f7d5f15c
        00000001 000001a6 9135579c 000001b3 00000000 00000000 00000000 f6ff7f08
Call Trace:
  [<c014557a>] mempool_free+0x2a/0x60
  [<c017eef6>] bio_put+0x26/0x40
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c02a70c7>] __ide_end_request+0x87/0xe0
  [<c021d404>] elv_queue_empty+0x24/0x30
  [<c02a8417>] ide_do_request+0x67/0x330
  [<c02aeafd>] ide_dma_intr+0x7d/0xc0
  [<c022f282>] copy_to_user+0x32/0x50
  [<c016a6f9>] sys_select+0x149/0x170
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
mysqld        D 00000000     0  2617   2571 (NOTLB)
        f6ff9ea0 00000086 00000000 00000000 00000000 00000000 00000000 00000000
        00000000 00000000 00000000 00000000 00000000 00000000 f72ea0d0 f7c9f6bc
        00000000 000001a8 91356336 000001b3 00000000 00000000 00000000 f6ff9f08
Call Trace:
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c014f682>] do_no_page+0x162/0x280
  [<c014f9da>] __handle_mm_fault+0xfa/0x1e0
  [<c0115c7b>] do_page_fault+0x39b/0x590
  [<c022f282>] copy_to_user+0x32/0x50
  [<c016a6f9>] sys_select+0x149/0x170
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
mysqld        D F7127D94     0  2618   2571 (NOTLB)
        f6ffbea0 00000086 08700fe0 f7127d94 08700fe0 c0134f9c 80b65200 00003dd4
        ea405b29 0000001e 913481e3 000001b3 0000ea28 00000000 f72e15b0 f7cb16bc
        0000007a 0000019b 9136ac79 000001b3 00000000 00000000 00000000 f6ffbf08
Call Trace:
  [<c0134f9c>] futex_wait+0x2fc/0x3c0
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c01348a7>] futex_requeue+0xb7/0x1d0
  [<c0133d5e>] wake_futex+0x2e/0x50
  [<c0133fc6>] futex_wake+0x76/0xb0
  [<c01175e0>] default_wake_function+0x0/0x10
  [<c0135cf3>] do_futex+0x53/0x130
  [<c0135e35>] sys_futex+0x65/0xf0
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
mysqld        D F730C590     0  2619   2571 (NOTLB)
        f6ffdea0 00000086 f730c740 f730c590 f7d09a50 f7127d60 f6a2bea0 c0369725
        f6ffdec0 00000086 9133b619 000001b3 000030c3 00000000 f72eaad0 f7d09b5c
        00000073 000000d6 91342999 000001b3 00000000 00000000 00000008 f6ffdf08
Call Trace:
  [<c0369725>] schedule+0x2e5/0x580
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c0122ea1>] dequeue_signal+0x31/0x130
  [<c0124b12>] sys_rt_sigtimedwait+0x172/0x1d0
  [<c0135d12>] do_futex+0x72/0x130
  [<c0124675>] sigprocmask+0x45/0xb0
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
logger        D 000081A4     0  2609   2571 (NOTLB)
        f6aa9ea0 00000086 04003fff 000081a4 00000001 00000000 00000000 00800081
        00000000 00000000 f6f50cd8 00000400 fffffe00 00000000 f7c53050 f72ea1dc
        f6aa9eb0 000001fd 91357122 000001b3 00000000 00000000 b7f69420 f6aa9f08
Call Trace:
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c012b5e0>] autoremove_wake_function+0x0/0x50
  [<c0369725>] schedule+0x2e5/0x580
  [<c015ea26>] vfs_read+0x86/0x110
  [<c015ed07>] sys_read+0x47/0x80
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
nrpe          D F6673904     0  2653      1 (NOTLB)
        f6b25ea0 00200086 f6673904 f6673904 f6673904 f67af43c c1910e28 f6673904
        f67af43c c016dfb0 9133cde8 000001b3 00002e52 00000000 f7d09550 f72eabdc
        00000073 000001cd 91343b9d 000001b3 00000000 00000000 bf995dec f6b25f08
Call Trace:
  [<c016dfb0>] d_kill+0x40/0x60
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c014f682>] do_no_page+0x162/0x280
  [<c014f9da>] __handle_mm_fault+0xfa/0x1e0
  [<c0115c7b>] do_page_fault+0x39b/0x590
  [<c022f282>] copy_to_user+0x32/0x50
  [<c016a6f9>] sys_select+0x149/0x170
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
nagios-statd  D F6B1FD44     0  2661      1 (NOTLB)
        f6a19ea0 00200086 f6b1fd44 f6b1fd44 f6b1fd44 f6b689ec c1910e28 f6b1fd44
        f6b689ec c016dfb0 f7c20b20 f6b689ec f7c20b20 c016dfec f73940b0 f7c5315c
        00000008 00000654 91359d74 000001b3 00000000 00000000 bf9c0860 f6a19f08
Call Trace:
  [<c016dfb0>] d_kill+0x40/0x60
  [<c016dfec>] dput+0x1c/0xe0
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c014f682>] do_no_page+0x162/0x280
  [<c014f9da>] __handle_mm_fault+0xfa/0x1e0
  [<c0115c7b>] do_page_fault+0x39b/0x590
  [<c0312231>] sys_socketcall+0xc1/0x250
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
netserver     D F6B1FA84     0  2664      1 (NOTLB)
        f6b49ea0 00000086 f6b1fa84 f6b1fa84 f6b1fa84 f6b68134 c1910e28 f6b1fa84
        f6b68134 c016dfb0 f7c20da0 f6b68134 f7c20da0 c016dfec f7efda50 f73941bc
        00000008 000002be 9135b0ab 000001b3 00000000 00000000 bfdb1550 f6b49f08
Call Trace:
  [<c016dfb0>] d_kill+0x40/0x60
  [<c016dfec>] dput+0x1c/0xe0
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c014f682>] do_no_page+0x162/0x280
  [<c014f9da>] __handle_mm_fault+0xfa/0x1e0
  [<c0115c7b>] do_page_fault+0x39b/0x590
  [<c0312231>] sys_socketcall+0xc1/0x250
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c01158e0>] do_page_fault+0x0/0x590
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
lockd         D F734819C     0  2675      2 (L-TLB)
        f6ba3ed0 00000046 f7e2c0b0 f734819c f727c6c0 000012a8 6e33830e 0000000c
        f69d69a0 7fffffff 91c5013c 000001b3 00001ea8 00000000 f7e2c0b0 f734819c
        00000078 00000176 91c549d9 000001b3 00000000 00000000 f6f40000 00000003
Call Trace:
  [<c013b27c>] refrigerator+0x3c/0x50
  [<f918fc82>] svc_recv+0x392/0x420 [sunrpc]
  [<c0116ce7>] activate_task+0x37/0xb0
  [<c01175e0>] default_wake_function+0x0/0x10
  [<c01175e0>] default_wake_function+0x0/0x10
  [<f91b34de>] lockd+0x10e/0x240 [lockd]
  [<c0103dc6>] ret_from_fork+0x6/0x1c
  [<f91b33d0>] lockd+0x0/0x240 [lockd]
  [<f91b33d0>] lockd+0x0/0x240 [lockd]
  [<c0104a0b>] kernel_thread_helper+0x7/0x3c
  =======================
rpciod/0      S F65780A0     0  2676      2 (L-TLB)
        f6ba5f80 00000046 f69d63a0 f65780a0 00000000 f918574f 00000000 f657810c
        f65d506c f65780a4 f65780a0 f65780a4 00000286 f918ade2 f73a5a50 f7cb1bbc
        f918afd0 000002c5 8bb74456 000001b3 f6ba5fd0 f69f88a0 f6ba5fa8 f69f88a8
Call Trace:
  [<f918574f>] rpc_release_client+0x3f/0x70 [sunrpc]
  [<f918ade2>] rpc_release_calldata+0x12/0x20 [sunrpc]
  [<f918afd0>] rpc_async_schedule+0x0/0x10 [sunrpc]
  [<c01280f4>] worker_thread+0xe4/0xf0
  [<c012b5e0>] autoremove_wake_function+0x0/0x50
  [<c012b5e0>] autoremove_wake_function+0x0/0x50
  [<c0128010>] worker_thread+0x0/0xf0
  [<c012b20a>] kthread+0x6a/0x70
  [<c012b1a0>] kthread+0x0/0x70
  [<c0104a0b>] kernel_thread_helper+0x7/0x3c
  =======================
nfsd          D F7E2C1BC     0  2677      2 (L-TLB)
        f6bc7f10 00000046 f73a5050 f7e2c1bc 000cb759 00001972 00000282 f6bc7ef8
        00000000 00000282 91c503f8 000001b3 00001ff2 00000000 f73a5050 f7e2c1bc
        00000078 00000128 91c54fa4 000001b3 00000000 00000000 f6b87000 00000022
Call Trace:
  [<c013b27c>] refrigerator+0x3c/0x50
  [<f918fc82>] svc_recv+0x392/0x420 [sunrpc]
  [<c015e2d3>] filp_close+0x43/0x70
  [<c01175e0>] default_wake_function+0x0/0x10
  [<c01175e0>] default_wake_function+0x0/0x10
  [<f91c456e>] nfsd+0xae/0x240 [nfsd]
  [<f91c44c0>] nfsd+0x0/0x240 [nfsd]
  [<c0104a0b>] kernel_thread_helper+0x7/0x3c
  =======================
nfsd          D F73A515C     0  2678      2 (L-TLB)
        f6be9f10 00000046 f73a5550 f73a515c 000cb759 00000a68 00000282 f6be9ef8
        00000000 00000282 91c506b7 000001b3 0000211f 00000000 f73a5550 f73a515c
        00000078 0000011b 91c5552c 000001b3 00000000 00000000 f6bb0000 00000022
Call Trace:
  [<c013b27c>] refrigerator+0x3c/0x50
  [<f918fc82>] svc_recv+0x392/0x420 [sunrpc]
  [<c015e2d3>] filp_close+0x43/0x70
  [<c01175e0>] default_wake_function+0x0/0x10
  [<c01175e0>] default_wake_function+0x0/0x10
  [<f91c456e>] nfsd+0xae/0x240 [nfsd]
  [<f91c44c0>] nfsd+0x0/0x240 [nfsd]
  [<c0104a0b>] kernel_thread_helper+0x7/0x3c
  =======================
nfsd          D F73A565C     0  2679      2 (L-TLB)
        f6409f10 00000046 f7c53a50 f73a565c 000cb759 00000a75 00000282 f6409ef8
        00000000 00000282 91c50942 000001b3 00002251 00000000 f7c53a50 f73a565c
        00000078 00000112 91c55a89 000001b3 00000000 00000000 f6bd5000 00000022
Call Trace:
  [<c013b27c>] refrigerator+0x3c/0x50
  [<f918fc82>] svc_recv+0x392/0x420 [sunrpc]
  [<c015e2d3>] filp_close+0x43/0x70
  [<c01175e0>] default_wake_function+0x0/0x10
  [<c01175e0>] default_wake_function+0x0/0x10
  [<f91c456e>] nfsd+0xae/0x240 [nfsd]
  [<f91c44c0>] nfsd+0x0/0x240 [nfsd]
  [<c0104a0b>] kernel_thread_helper+0x7/0x3c
  =======================
nfsd          D F7C53B5C     0  2680      2 (L-TLB)
        f642bf10 00000046 f730e070 f7c53b5c 000cb759 0000098a 00000282 f642bef8
        00000000 00000282 91c50bda 000001b3 00002387 00000000 f730e070 f7c53b5c
        00000078 00000117 91c56000 000001b3 00000000 00000000 f6bfa000 00000022
Call Trace:
  [<c013b27c>] refrigerator+0x3c/0x50
  [<f918fc82>] svc_recv+0x392/0x420 [sunrpc]
  [<c015e2d3>] filp_close+0x43/0x70
  [<c01175e0>] default_wake_function+0x0/0x10
  [<c01175e0>] default_wake_function+0x0/0x10
  [<f91c456e>] nfsd+0xae/0x240 [nfsd]
  [<f91c44c0>] nfsd+0x0/0x240 [nfsd]
  [<c0104a0b>] kernel_thread_helper+0x7/0x3c
  =======================
nfsd          D F730E17C     0  2681      2 (L-TLB)
        f644bf10 00000046 f730ea70 f730e17c 000cb759 00000848 00000282 f644bef8
        00000000 00000282 91c50ed9 000001b3 000024a6 00000000 f730ea70 f730e17c
        00000078 00000121 91c565a6 000001b3 00000000 00000000 f641f000 00000022
Call Trace:
  [<c013b27c>] refrigerator+0x3c/0x50
  [<f918fc82>] svc_recv+0x392/0x420 [sunrpc]
  [<c0150701>] remove_vma+0x31/0x50
  [<c015e2d3>] filp_close+0x43/0x70
  [<c01175e0>] default_wake_function+0x0/0x10
  [<c01175e0>] default_wake_function+0x0/0x10
  [<f91c456e>] nfsd+0xae/0x240 [nfsd]
  [<f91c44c0>] nfsd+0x0/0x240 [nfsd]
  [<c0104a0b>] kernel_thread_helper+0x7/0x3c
  =======================
nfsd          D F730EB7C     0  2682      2 (L-TLB)
        f646df10 00000046 f7c9e090 f730eb7c 000cb759 000007b0 00000282 f646def8
        00000000 00000282 91c511a3 000001b3 000025c6 00000000 f7c9e090 f730eb7c
        00000078 00000117 91c56b1c 000001b3 00000000 00000000 f6444000 00000022
Call Trace:
  [<c013b27c>] refrigerator+0x3c/0x50
  [<f918fc82>] svc_recv+0x392/0x420 [sunrpc]
  [<c015e2d3>] filp_close+0x43/0x70
  [<c01175e0>] default_wake_function+0x0/0x10
  [<c01175e0>] default_wake_function+0x0/0x10
  [<f91c456e>] nfsd+0xae/0x240 [nfsd]
  [<f91c44c0>] nfsd+0x0/0x240 [nfsd]
  [<c0104a0b>] kernel_thread_helper+0x7/0x3c
  =======================
nfsd          D F7C9E19C     0  2683      2 (L-TLB)
        f64adf10 00000046 f72e15b0 f7c9e19c 0000007c 00000d7d 00000282 f64adef8
        00000000 00000282 91c51404 000001b3 000026f5 00000000 f73a2ad0 f7c9e19c
        00000078 00000109 91c57049 000001b3 00000000 00000000 f6469000 00000022
Call Trace:
  [<c013b27c>] refrigerator+0x3c/0x50
  [<f918fc82>] svc_recv+0x392/0x420 [sunrpc]
  [<c015e2d3>] filp_close+0x43/0x70
  [<c01175e0>] default_wake_function+0x0/0x10
  [<c01175e0>] default_wake_function+0x0/0x10
  [<f91c456e>] nfsd+0xae/0x240 [nfsd]
  [<f91c44c0>] nfsd+0x0/0x240 [nfsd]
  [<c0104a0b>] kernel_thread_helper+0x7/0x3c
  =======================
nfsd          D F73A2BDC     0  2684      2 (L-TLB)
        f64cdf10 00000046 f7c9e090 f73a2bdc 0000007c 00006c5a 00000282 f64cdef8
        00000000 00000282 00000282 000cb77f 000cb77f c0369fe4 f73a5a50 f73a2bdc
        00000008 000000f6 91c57517 000001b3 00000000 00000000 f648e000 00000022
Call Trace:
  [<c0369fe4>] schedule_timeout+0x54/0xa0
  [<c013b27c>] refrigerator+0x3c/0x50
  [<f918fc82>] svc_recv+0x392/0x420 [sunrpc]
  [<f918fde2>] svc_send+0x92/0x100 [sunrpc]
  [<c01175e0>] default_wake_function+0x0/0x10
  [<c01175e0>] default_wake_function+0x0/0x10
  [<f91c456e>] nfsd+0xae/0x240 [nfsd]
  [<f91c44c0>] nfsd+0x0/0x240 [nfsd]
  [<c0104a0b>] kernel_thread_helper+0x7/0x3c
  =======================
rpc.mountd    D C177B160     0  2688      1 (NOTLB)
        f6b85ea0 00000082 00000246 c177b160 c0434da8 c0146a8f f6b6352c 00000000
        00000000 c0434da8 91344a31 000001b3 00010f88 00000000 c192ea30 f72e16bc
        0000007d 00000af1 9136cd4c 000001b3 00000000 00000000 00000000 f6b85f08
Call Trace:
  [<c0146a8f>] buffered_rmqueue+0x9f/0x100
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c014f682>] do_no_page+0x162/0x280
  [<c014f9da>] __handle_mm_fault+0xfa/0x1e0
  [<c0115c7b>] do_page_fault+0x39b/0x590
  [<c016a659>] sys_select+0xa9/0x170
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
rsync         D 6C720929     0  2694      1 (NOTLB)
        f64d5ea0 00000086 ab800883 6c720929 b43a31c6 81773793 3b011242 3456459e
        3fbc385d af7f93c4 00000000 f69f87e0 f64d5eb8 0000000a f7c51530 f7efdb5c
        f727c650 0000024b 9135c0b9 000001b3 00000000 00000000 00000000 f64d5f08
Call Trace:
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c034a919>] tcp_v4_get_port+0x19/0x20
  [<c031442e>] release_sock+0xe/0x60
  [<c0358094>] inet_listen+0x34/0x80
  [<c03115c2>] sys_listen+0x42/0x70
  [<c016a659>] sys_select+0xa9/0x170
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
smartd        D 00000000     0  2703      1 (NOTLB)
        f6a0dea0 00000082 00000005 00000000 00000001 00000000 00000200 f65f9400
        bfc7b1b0 f786c400 00004000 f6673e60 f651d960 01d501b0 f65245d0 f7c5163c
        004f0001 00000187 9135cb70 000001b3 00000000 00000000 bfc9abc4 f6a0df08
Call Trace:
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c012d9f9>] ktime_get_ts+0x19/0x50
  [<c022f282>] copy_to_user+0x32/0x50
  [<c012e740>] hrtimer_nanosleep+0x90/0xe0
  [<c012e670>] hrtimer_wakeup+0x0/0x20
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
sshd          D 00000001     0  2705   2506 (NOTLB)
        f6b0dea0 00000082 f687e4c0 00000001 00000000 f6b0de58 00000000 00000000
        f6b0deb0 00000001 9133dac5 000001b3 0000389d 00000000 f65240d0 f7d0965c
        00000073 000003b9 913460db 000001b3 00000000 00000000 00000000 f6b0df08
Call Trace:
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c012b5e0>] autoremove_wake_function+0x0/0x50
  [<c027fcb4>] tty_write+0x94/0x1f0
  [<c016a659>] sys_select+0xa9/0x170
  [<c015ed87>] sys_write+0x47/0x80
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
bash          D C1733820     0  2761   2705 (NOTLB)
        f6b27ea0 00000086 00000246 c1733820 c0434da8 c0146a8f 00000000 00000000
        00000000 c0434da8 9133e08b 000001b3 00003a41 00000000 f6524ad0 f65241dc
        00000073 000000f7 91346a84 000001b3 00000000 00000000 080ffac8 f6b27f08
Call Trace:
  [<c0146a8f>] buffered_rmqueue+0x9f/0x100
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c011d7bb>] do_wait+0x1bb/0x3b0
  [<c01175e0>] default_wake_function+0x0/0x10
  [<c0281589>] tiocspgrp+0xc9/0xe0
  [<c01175e0>] default_wake_function+0x0/0x10
  [<c011da71>] sys_wait4+0x31/0x40
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
rpc.statd     D F6541EA8     0  2768      1 (NOTLB)
        f6541ea0 00000082 00000000 f6541ea8 00000000 c022f282 bffdbb44 00000010
        bffdbb20 c0310235 00000000 f6541ec8 08056a80 f64d3a00 f64c6ab0 f65246dc
        00000190 000002fa 9135e04b 000001b3 00000000 00000000 00000000 f6541f08
Call Trace:
  [<c022f282>] copy_to_user+0x32/0x50
  [<c0310235>] move_addr_to_user+0x65/0x70
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c017c44d>] invalidate_inode_buffers+0xd/0xa0
  [<c016dfb0>] d_kill+0x40/0x60
  [<c016a659>] sys_select+0xa9/0x170
  [<c017272c>] mntput_no_expire+0x1c/0x70
  [<c015e2d3>] filp_close+0x43/0x70
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
rpc.idmapd    D 00008003     0  2776      1 (NOTLB)
        f659fea0 00000082 f6089000 00008003 00000000 f6056c20 00000000 f659ff28
        00000001 c193df40 9133e5ad 000001b3 00003cf9 00000000 f7c53550 f6524bdc
        00000073 00000128 91347618 000001b3 00000000 00000000 00001388 f659ff08
Call Trace:
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c0369fe4>] schedule_timeout+0x54/0xa0
  [<c0185b19>] ep_events_transfer+0x69/0x80
  [<c0122420>] process_timeout+0x0/0x10
  [<c01175e0>] default_wake_function+0x0/0x10
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
ntpd          D F6511E88     0  2791      1 (NOTLB)
        f6511ea0 00200082 00000000 f6511e88 f7fbe7d8 f7c53550 bfeb98fc bfeb98fc
        f7c53760 c0108f0c 9133efd6 000001b3 000042b3 00000000 f64c65b0 f7c5365c
        00000073 0000025f 91348dcf 000001b3 00000000 00000000 00000000 f6511f08
Call Trace:
  [<c0108f0c>] save_i387_fxsave+0x8c/0xb0
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c016a659>] sys_select+0xa9/0x170
  [<c010339d>] restore_sigcontext+0x10d/0x160
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
mdadm         D BF9FDFB4     0  2803      1 (NOTLB)
        f6513ea0 00000086 00000000 bf9fdfb4 c1a4f000 c02fc8a5 00000000 80480911
        c1a4f000 c02fc36d c1a4f000 c1a4f10c c190d8c8 c0180d82 f7c9ea90 f64c6bbc
        c1a4f10c 00000276 9135f186 000001b3 00000000 00000000 bf9fcc58 f6513f08
Call Trace:
  [<c02fc8a5>] md_wakeup_thread+0x25/0x30
  [<c02fc36d>] md_ioctl+0xcd/0x410
  [<c0180d82>] check_disk_change+0x32/0x80
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c02fc2a0>] md_ioctl+0x0/0x410
  [<c0222566>] blkdev_driver_ioctl+0x36/0x60
  [<c015dfa8>] nameidata_to_filp+0x28/0x40
  [<c022261f>] blkdev_ioctl+0x8f/0x1d0
  [<c02f5d79>] mddev_put+0x19/0x80
  [<c0181242>] __blkdev_put+0x62/0x120
  [<c022f282>] copy_to_user+0x32/0x50
  [<c016a6f9>] sys_select+0x149/0x170
  [<c017272c>] mntput_no_expire+0x1c/0x70
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
amd           D 00000010     0  2815      1 (NOTLB)
        f65c3ea0 00000082 f65c3ec8 00000010 f65c3e88 00000001 f65c3e68 00000018
        00000000 00000000 9133fbce 000001b3 000049bf 00000000 f7efd050 f64c66bc
        00000073 000002dd 9134aa7a 000001b3 00000000 00000000 00000000 f65c3f08
Call Trace:
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c014eb79>] do_wp_page+0x299/0x3b0
  [<c014fa96>] __handle_mm_fault+0x1b6/0x1e0
  [<c0115c7b>] do_page_fault+0x39b/0x590
  [<c022f282>] copy_to_user+0x32/0x50
  [<c016a6f9>] sys_select+0x149/0x170
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
atd           D C01D83C0     0  2844      1 (NOTLB)
        f6539ea0 00000082 00000000 c01d83c0 00000000 c01d83c0 00000000 00000000
        f65deb00 c01e8434 f6539f08 00000008 00000000 c0209053 c19b3550 f7c9eb9c
        c0434f14 0000015c 9135fb0a 000001b3 00000000 00000000 bfe5d324 f6539f08
Call Trace:
  [<c01d83c0>] xfs_dir2_put_dirent64_direct+0x0/0xb0
  [<c01d83c0>] xfs_dir2_put_dirent64_direct+0x0/0xb0
  [<c01e8434>] xfs_iunlock+0x84/0x90
  [<c0209053>] xfs_readdir+0x53/0x70
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c012d9f9>] ktime_get_ts+0x19/0x50
  [<c022f282>] copy_to_user+0x32/0x50
  [<c012e740>] hrtimer_nanosleep+0x90/0xe0
  [<c012e670>] hrtimer_wakeup+0x0/0x20
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
cron          D 000081A4     0  2847      1 (NOTLB)
        f661bea0 00000082 04003fff 000081a4 00000001 00000000 00000000 060243d5
        00000000 00000274 91340354 000001b3 00004c36 00000000 f64c60b0 f7efd15c
        00000073 00000155 9134b7d5 000001b3 00000000 00000000 bfb8e8d4 f661bf08
Call Trace:
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c012d9f9>] ktime_get_ts+0x19/0x50
  [<c022f282>] copy_to_user+0x32/0x50
  [<c012e740>] hrtimer_nanosleep+0x90/0xe0
  [<c012e670>] hrtimer_wakeup+0x0/0x20
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
miniserv.pl   D F6F02CA0     0  2864      1 (NOTLB)
        f6631ea0 00000082 f6631eb8 f6f02ca0 f6631e70 c0437200 f667cc00 f6631eb8
        f66647c0 c02101b8 00000001 f6631f00 00000001 00000000 f6520530 c19b365c
        f6631eb0 0000037c 91361374 000001b3 00000000 00000000 00000000 f6631f08
Call Trace:
  [<c02101b8>] xfs_file_aio_read+0x78/0x90
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c011d7bb>] do_wait+0x1bb/0x3b0
  [<c022f282>] copy_to_user+0x32/0x50
  [<c016a6f9>] sys_select+0x149/0x170
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
apache        D C173CD20     0  2951      1 (NOTLB)
        f65e7ea0 00000082 00000246 c173cd20 c0434da8 c0146a8f c0434dcc 00000000
        00000000 c0434da8 9133bf89 000001b3 00006e15 00000000 f7cba550 f64c61bc
        00000074 0000013e 9134c442 000001b3 00000000 00000000 00000000 f65e7f08
Call Trace:
  [<c0146a8f>] buffered_rmqueue+0x9f/0x100
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c014eb79>] do_wp_page+0x299/0x3b0
  [<c011d7bb>] do_wait+0x1bb/0x3b0
  [<c0115c7b>] do_page_fault+0x39b/0x590
  [<c022f282>] copy_to_user+0x32/0x50
  [<c016a6f9>] sys_select+0x149/0x170
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
apache        D C1746100     0  2952   2951 (NOTLB)
        f66a5ea0 00000086 00000246 c1746100 c0434da8 c0146a8f c0434dcc 00000000
        000000b4 c0142b08 c0434f18 00000044 c0434f14 c014290b f7c9fab0 f652063c
        00000000 00000290 91362568 000001b3 00000000 00000000 00000000 f66a5f08
Call Trace:
  [<c0146a8f>] buffered_rmqueue+0x9f/0x100
  [<c0142b08>] find_lock_page+0x18/0x70
  [<c014290b>] unlock_page+0x1b/0x30
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c014f682>] do_no_page+0x162/0x280
  [<c014f9da>] __handle_mm_fault+0xfa/0x1e0
  [<c0115c7b>] do_page_fault+0x39b/0x590
  [<c016a659>] sys_select+0xa9/0x170
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
apache        D C1746480     0  2953   2951 (NOTLB)
        f66d5ea0 00000082 00000246 c1746480 c0434da8 c0146a8f c0434dcc 00000000
        000000b4 c0142b08 c0434f18 00000044 c0434f14 c014290b f64fea50 f7c9fbbc
        00000000 00000211 913633e0 000001b3 00000000 00000000 00000000 f66d5f08
Call Trace:
  [<c0146a8f>] buffered_rmqueue+0x9f/0x100
  [<c0142b08>] find_lock_page+0x18/0x70
  [<c014290b>] unlock_page+0x1b/0x30
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c014f682>] do_no_page+0x162/0x280
  [<c014f9da>] __handle_mm_fault+0xfa/0x1e0
  [<c0115c7b>] do_page_fault+0x39b/0x590
  [<c022f282>] copy_to_user+0x32/0x50
  [<c0108389>] sys_ipc+0x49/0x280
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c01158e0>] do_page_fault+0x0/0x590
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
apache        D C1746800     0  2954   2951 (NOTLB)
        f66d7ea0 00000086 00000246 c1746800 c0434da8 c0146a8f c0434dcc 00000000
        000000b4 c0142b08 c0434f18 00000044 c0434f14 c014290b f6520030 f64feb5c
        00000000 0000012f 91363c2b 000001b3 00000000 00000000 00000000 f66d7f08
Call Trace:
  [<c0146a8f>] buffered_rmqueue+0x9f/0x100
  [<c0142b08>] find_lock_page+0x18/0x70
  [<c014290b>] unlock_page+0x1b/0x30
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c014f682>] do_no_page+0x162/0x280
  [<c014f9da>] __handle_mm_fault+0xfa/0x1e0
  [<c0115c7b>] do_page_fault+0x39b/0x590
  [<c022f282>] copy_to_user+0x32/0x50
  [<c0108389>] sys_ipc+0x49/0x280
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c01158e0>] do_page_fault+0x0/0x590
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
apache        D C1741AC0     0  2955   2951 (NOTLB)
        f66d9ea0 00000086 00000246 c1741ac0 c0434da8 c0146a8f c0434dcc 00000000
        000000b4 c0142b08 c0434f18 00000044 c0434f14 c014290b f64fe050 f652013c
        00000000 0000013c 913644d2 000001b3 00000000 00000000 00000000 f66d9f08
Call Trace:
  [<c0146a8f>] buffered_rmqueue+0x9f/0x100
  [<c0142b08>] find_lock_page+0x18/0x70
  [<c014290b>] unlock_page+0x1b/0x30
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c014f682>] do_no_page+0x162/0x280
  [<c014f9da>] __handle_mm_fault+0xfa/0x1e0
  [<c0115c7b>] do_page_fault+0x39b/0x590
  [<c022f282>] copy_to_user+0x32/0x50
  [<c0108389>] sys_ipc+0x49/0x280
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c01158e0>] do_page_fault+0x0/0x590
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
apache        D C174FBE0     0  2960   2951 (NOTLB)
        f66e3ea0 00000082 00000246 c174fbe0 c0434da8 c0146a8f 00000246 00000000
        000000b4 c0142b08 c0434f18 00000044 c0434f14 c014290b f64fe550 f64fe15c
        00000000 0000012b 91364cff 000001b3 00000000 00000000 00000000 f66e3f08
Call Trace:
  [<c0146a8f>] buffered_rmqueue+0x9f/0x100
  [<c0142b08>] find_lock_page+0x18/0x70
  [<c014290b>] unlock_page+0x1b/0x30
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c014f682>] do_no_page+0x162/0x280
  [<c014f9da>] __handle_mm_fault+0xfa/0x1e0
  [<c0115c7b>] do_page_fault+0x39b/0x590
  [<c022f282>] copy_to_user+0x32/0x50
  [<c0108389>] sys_ipc+0x49/0x280
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c01158e0>] do_page_fault+0x0/0x590
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
munin-node    D 00000000     0  3075      1 (NOTLB)
        f670bea0 00000086 00000000 00000000 00000000 00000000 00000000 00000000
        00000000 00000000 00000000 00000000 00000000 00000000 f64ff090 f64fe65c
        00000000 000002b1 91365fd8 000001b3 00000000 00000000 00000000 f670bf08
Call Trace:
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c014eb79>] do_wp_page+0x299/0x3b0
  [<c014fa96>] __handle_mm_fault+0x1b6/0x1e0
  [<c0115c7b>] do_page_fault+0x39b/0x590
  [<c022f282>] copy_to_user+0x32/0x50
  [<c016a6f9>] sys_select+0x149/0x170
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
getty         D F64FF19C     0  3095      1 (NOTLB)
        f677dea0 00000086 f66f55b0 f64ff19c 00000000 001179b7 abc5f29a 0000000f
        c1a5e008 7fffffff f77ed800 f677defc bfec340b c036a025 f66f55b0 f64ff19c
        f77ed800 000002b0 913672ae 000001b3 00000000 00000000 0804b214 f677df08
Call Trace:
  [<c036a025>] schedule_timeout+0x95/0xa0
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c01175e0>] default_wake_function+0x0/0x10
  [<c027fcb4>] tty_write+0x94/0x1f0
  [<c027fbe2>] tty_read+0x82/0xc0
  [<c015ea26>] vfs_read+0x86/0x110
  [<c015ed07>] sys_read+0x47/0x80
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
getty         D F66F56BC     0  3096      1 (NOTLB)
        f677fea0 00000086 f66df570 f66f56bc f66ef400 00002ba6 abc72425 0000000f
        f66ef400 7fffffff f66ef400 f677fefc bf98d6cb c036a025 f66df570 f66f56bc
        f665e008 0000017c 91367d18 000001b3 00000000 00000000 0804b214 f677ff08
Call Trace:
  [<c036a025>] schedule_timeout+0x95/0xa0
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c01175e0>] default_wake_function+0x0/0x10
  [<c027fcb4>] tty_write+0x94/0x1f0
  [<c027fbe2>] tty_read+0x82/0xc0
  [<c015ea26>] vfs_read+0x86/0x110
  [<c015ed07>] sys_read+0x47/0x80
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
getty         D F66DF67C     0  3097      1 (NOTLB)
        f6781ea0 00000082 f66e8090 f66df67c f651f000 0000232c abc81a59 0000000f
        f651f000 7fffffff f651f000 f6781efc bfb5989b c036a025 f66e8090 f66df67c
        f651f408 00000171 91368732 000001b3 00000000 00000000 0804b214 f6781f08
Call Trace:
  [<c036a025>] schedule_timeout+0x95/0xa0
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c01175e0>] default_wake_function+0x0/0x10
  [<c027fcb4>] tty_write+0x94/0x1f0
  [<c027fbe2>] tty_read+0x82/0xc0
  [<c015ea26>] vfs_read+0x86/0x110
  [<c015ed07>] sys_read+0x47/0x80
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
getty         D F66E819C     0  3098      1 (NOTLB)
        f6783ea0 00000086 f66e7ad0 f66e819c f6f06c00 00002bab abc94c07 0000000f
        f6f06c00 7fffffff f6f06c00 f6783efc bfffad3b c036a025 f66e7ad0 f66e819c
        f66eac08 0000016f 9136913e 000001b3 00000000 00000000 0804b214 f6783f08
Call Trace:
  [<c036a025>] schedule_timeout+0x95/0xa0
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c01175e0>] default_wake_function+0x0/0x10
  [<c027fcb4>] tty_write+0x94/0x1f0
  [<c027fbe2>] tty_read+0x82/0xc0
  [<c015ea26>] vfs_read+0x86/0x110
  [<c015ed07>] sys_read+0x47/0x80
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
getty         D F66E7BDC     0  3102      1 (NOTLB)
        f67a9ea0 00000082 f66f50b0 f66e7bdc f66f2000 00002c4c abca821e 0000000f
        f66f2000 7fffffff f66f2000 f67a9efc bf878dbb c036a025 f66f50b0 f66e7bdc
        f668b008 0000015c 91369ac3 000001b3 00000000 00000000 0804b214 f67a9f08
Call Trace:
  [<c036a025>] schedule_timeout+0x95/0xa0
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c01175e0>] default_wake_function+0x0/0x10
  [<c027fcb4>] tty_write+0x94/0x1f0
  [<c027fbe2>] tty_read+0x82/0xc0
  [<c015ea26>] vfs_read+0x86/0x110
  [<c015ed07>] sys_read+0x47/0x80
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
getty         D F66F51BC     0  3103      1 (NOTLB)
        f67abea0 00000082 00000000 f66f51bc c195b800 00002659 abcb8e91 0000000f
        c195b800 7fffffff 91346dc8 000001b3 0000efed 00000000 f7cb15b0 f66f51bc
        00000079 0000019c 9136a60a 000001b3 00000000 00000000 0804b214 f67abf08
Call Trace:
  [<c013b27c>] refrigerator+0x3c/0x50
  [<c01245f7>] get_signal_to_deliver+0x227/0x230
  [<c0103ca5>] do_signal+0x65/0x140
  [<c01175e0>] default_wake_function+0x0/0x10
  [<c027fcb4>] tty_write+0x94/0x1f0
  [<c027fbe2>] tty_read+0x82/0xc0
  [<c015ea26>] vfs_read+0x86/0x110
  [<c015ed07>] sys_read+0x47/0x80
  [<c0103dbc>] do_notify_resume+0x3c/0x40
  [<c0103f7e>] work_notifysig+0x13/0x19
  =======================
hibernate     D F65F0C64     0  3907   2761 (NOTLB)
        f67a5cd0 00000082 f786c800 f65f0c64 f7ea23b8 c02bcdef f7ea2040 c1ad1180
        f78b3400 f7ea23b8 5b7f815f 00000009 00003442 00000000 c19615d0 f73a5b5c
        0000006e 0005cef4 5b7f815f 00000009 f7ea23b8 f67a5db8 f65f0c64 f67a5cec
Call Trace:
  [<c02bcdef>] scsi_prep_fn+0x8f/0x130
  [<c0369a24>] wait_for_completion+0x64/0xa0
  [<c01175e0>] default_wake_function+0x0/0x10
  [<c021f85b>] __generic_unplug_device+0x2b/0x30
  [<c01175e0>] default_wake_function+0x0/0x10
  [<c02207a7>] blk_execute_rq+0xa7/0xe0
  [<c0220970>] blk_end_sync_rq+0x0/0x30
  [<c011ece2>] irq_exit+0x42/0x70
  [<c0111b80>] smp_apic_timer_interrupt+0x30/0x40
  [<c01048b8>] apic_timer_interrupt+0x28/0x30
  [<c02bbd48>] scsi_execute+0xb8/0x110
  [<c02bbe0b>] scsi_execute_req+0x6b/0x90
  [<c02c3cc0>] sd_start_stop_device+0x70/0x120
  [<c011ae17>] printk+0x17/0x20
  [<c02c4045>] sd_resume+0x55/0xa0
  [<c02c022f>] scsi_bus_resume+0x6f/0x80
  [<c029da36>] resume_device+0x136/0x190
  [<c022aaf5>] kobject_get+0x15/0x20
  [<c0297ad1>] get_device+0x11/0x20
  [<c029dbad>] dpm_resume+0xbd/0xc0
  [<c029dbcb>] device_resume+0x1b/0x40
  [<c013c043>] hibernate+0x103/0x1a0
  [<c013b205>] state_store+0xc5/0x100
  [<c013b140>] state_store+0x0/0x100
  [<c0194080>] sysfs_write_file+0x0/0x80
  [<c0193e7f>] subsys_attr_store+0x3f/0x50
  [<c019406e>] flush_write_buffer+0x2e/0x40
  [<c01940e5>] sysfs_write_file+0x65/0x80
  [<c015ec39>] vfs_write+0x89/0x110
  [<c015ed87>] sys_write+0x47/0x80
  [<c0168c9b>] sys_dup2+0x9b/0xd0
  [<c0103ef0>] syscall_call+0x7/0xb
  =======================
