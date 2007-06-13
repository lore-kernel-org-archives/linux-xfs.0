Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 13 Jun 2007 15:02:29 -0700 (PDT)
Received: from mail.ukfsn.org (s2.ukfsn.org [217.158.120.143])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5DM2KWt010878
	for <xfs@oss.sgi.com>; Wed, 13 Jun 2007 15:02:21 -0700
Message-ID: <46706968.7000703@dgreaves.com>
Date: Wed, 13 Jun 2007 23:02:16 +0100
From: David Greaves <david@dgreaves.com>
MIME-Version: 1.0
Subject: Re: 2.6.22-rc3 hibernate(?) fails totally - regression (xfs on raid6)
References: <200706020122.49989.rjw@sisk.pl> <4661EFBB.5010406@dgreaves.com> <alpine.LFD.0.98.0706021538360.23741@woody.linux-foundation.org> <4662D852.4000005@dgreaves.com> <46667160.80905@gmail.com> <46668EE0.2030509@dgreaves.com> <46679D56.7040001@gmail.com> <4667DE2D.6050903@dgreaves.com> <20070607110708.GS86004887@sgi.com> <46680F5E.6070806@dgreaves.com> <20070607222813.GG85884050@sgi.com> <4669A965.20403@dgreaves.com> <alpine.LFD.0.98.0706121123550.14121@woody.linux-foundation.org> <466FD214.9070603@dgreaves.com> <alpine.LFD.0.98.0706131344550.14121@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0706131344550.14121@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Chinner <dgc@sgi.com>, Tejun Heo <htejun@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, xfs@oss.sgi.com, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, linux-pm <linux-pm@lists.osdl.org>, Neil Brown <neilb@suse.de>, Jeff Garzik <jgarzik@pobox.com>

Linus Torvalds wrote:
> 
> On Wed, 13 Jun 2007, David Greaves wrote:
>> git-bisect bad
>> 9666f4009c22f6520ac3fb8a19c9e32ab973e828 is first bad commit
>> commit 9666f4009c22f6520ac3fb8a19c9e32ab973e828
>> Author: Tejun Heo <htejun@gmail.com>
>> Date:   Fri May 4 21:27:47 2007 +0200
>>
>>     libata: reimplement suspend/resume support using sdev->manage_start_stop
>>
>> Good.
> 
> Ok, good. So the bug is apparently in the generic SCSI layer start/stop
> handling. I'm not entirely surprised, most people would never have 
> triggered it (I _think_ it's disabled by default for all devices, and that 
> the libata-scsi.c change was literally the first thing to ever enable it 
> by default for anything!)
> 
>> So here's a sysrq-t from a failed resume. Ask if you'd like anything else...
> 
> I'm not seeing anything really obvious. The traces would probably look 
> better if you enabled CONFIG_FRAME_POINTER, though. That should cut down 
> on some of the noise and make the traces a bit more readable.

I can do that...

> "hibernate" is definitely stuck on the new code: it's in the 
> "sd_start_stop_device()" call-chain, but I note that ata_aux at the same 
> time is also doing some sd_spinup_disk logic as part of rescanning. Maybe 
> that's part of the confusion: trying to rescan the bus at the same time 
> upper layers (who already *know* the disks that are there) are trying to 
> spin up the devices.
> 
> Tejun? Jeff?

SysRq : Show State

                          free                        sibling
   task             PC    stack   pid father child younger older
init          D 28D10C50     0     1      0 (NOTLB)
        c1941ea0 00000082 46706775 28d10c50 46706775 28d10c50 00001000 f64b4000
        c1941e80 c04250e0 d5151017 00000018 00002e2e 00000000 f7cb15b0 c192eb3c
        00000073 00000207 d5157d78 00000018 c1941ea0 00000000 00000000 c1941f08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
kthreadd      S C192E530     0     2      0 (L-TLB)
        c1943fd0 00000046 00000000 c192e530 c01175f0 00000000 f6967ed4 00000000
        00000003 00000292 f6967eb8 00000000 c1943fc0 00000292 f7122090 c192e63c
        c1943fc0 00000060 d3a629f3 0000000b c1943fd0 c042d298 00000000 00000000
Call Trace:
  [<c012b454>] kthreadd+0x74/0xa0
  [<c01049fb>] kernel_thread_helper+0x7/0x4c
  =======================
ksoftirqd/0   S C04903C8     0     3      2 (L-TLB)
        c1945fb0 00000046 00000000 c04903c8 c1945f70 00000046 c1932550 c192e140
        c1945f80 c011ee7c c6c1e024 00000000 c1945fa0 c011ec21 f6ba0ad0 c192e13c
        c1945fa0 00000db7 1ba6eda3 00000009 c1945fb0 00000000 c011ef80 fffffffc
Call Trace:
  [<c011effb>] ksoftirqd+0x7b/0x90
  [<c012b247>] kthread+0x67/0x70
  [<c01049fb>] kernel_thread_helper+0x7/0x4c
  =======================
watchdog/0    S C0364CA5     0     4      2 (L-TLB)
        c1947fb0 00000046 c1943f70 c0364ca5 c1947f70 00000292 c048b0e0 c1932a50
        ac6b4e00 000011ef f7d635a7 00000008 c1947fb0 00000000 c1932550 c1932b5c
        c1947fa0 00000a3e 7beb1af2 00000004 c1947fb0 00000000 c0140310 fffffffc
Call Trace:
  [<c014035e>] watchdog+0x4e/0x70
  [<c012b247>] kthread+0x67/0x70
  [<c01049fb>] kernel_thread_helper+0x7/0x4c
  =======================
events/0      R running     0     5      2 (L-TLB)
khelper       S 00000000     0     6      2 (L-TLB)
        c194bf60 00000046 00000000 00000000 c194bf20 00000001 f6bf8160 c0127a40
        c194bf30 c0127a67 f6bf8160 c1914c20 c194bf60 c0127ebd f65890b0 c193215c
        ad284200 000008d8 0b3c4782 0000000f 00000246 c1914c20 c194bf88 c1914c28
Call Trace:
  [<c012808c>] worker_thread+0xec/0xf0
  [<c012b247>] kthread+0x67/0x70
  [<c01049fb>] kernel_thread_helper+0x7/0x4c
  =======================
kblockd/0     S F7EA2438     0    35      2 (L-TLB)
        c19a7f60 00000046 c19146e0 f7ea2438 c19a7f20 c021ac9c c19146e0 c021acc0
        c19a7f30 c021acce 2bfa8b70 00000009 c19a7f60 c0127ebd c19b3a50 c19616dc
        0000006e 00000047 e0f8a696 00000010 00000246 c19146e0 c19a7f88 c19146e8
Call Trace:
  [<c012808c>] worker_thread+0xec/0xf0
  [<c012b247>] kthread+0x67/0x70
  [<c01049fb>] kernel_thread_helper+0x7/0x4c
  =======================
kacpid        S C192E530     0    36      2 (L-TLB)
        c19a9f60 00000046 c048b0e0 c192e530 c19a9f20 c0116be1 c192e530 7c841b53
        c19a9f40 c0116d2b 7c842264 00000004 00000087 00000000 c192e530 c19611dc
        00000078 0000013f 7c8423a7 00000004 00000246 c19145e0 c19a9f88 c19145e8
Call Trace:
  [<c012808c>] worker_thread+0xec/0xf0
  [<c012b247>] kthread+0x67/0x70
  [<c01049fb>] kernel_thread_helper+0x7/0x4c
  =======================
kacpi_notify  S C192E530     0    37      2 (L-TLB)
        c19abf60 00000046 c048b0e0 c192e530 c19abf20 c0116be1 c192e530 7c844295
        c19abf40 c0116d2b 7cc769c0 00000004 0000015e 00000000 c1932050 c1969b3c
        00000078 00000328 7cc76cfd 00000004 00000246 c19145a0 c19abf88 c19145a8
Call Trace:
  [<c012808c>] worker_thread+0xec/0xf0
  [<c012b247>] kthread+0x67/0x70
  [<c01049fb>] kernel_thread_helper+0x7/0x4c
  =======================
ata/0         S C192E530     0   121      2 (L-TLB)
        c19f5f60 00000046 00000001 c192e530 c19f5f20 c0116be1 c192e530 7dd68bdb
        c19f5f40 f7839f60 31d38c75 00000009 00023cf6 00000000 c19615d0 c1a021bc
        0000006e 0000391c 31d38c75 00000009 00000246 c1a1a9e0 c19f5f88 c1a1a9e8
Call Trace:
  [<c012808c>] worker_thread+0xec/0xf0
  [<c012b247>] kthread+0x67/0x70
  [<c01049fb>] kernel_thread_helper+0x7/0x4c
  =======================
ata_aux       D F7945000     0   122      2 (L-TLB)
        c19f7ce0 00000046 f7ea23b8 f7945000 c19f7ca0 c0121d67 c198d800 f7ea23b8
        c19f7cb0 c02261b7 f6af7964 f7ea23b8 c19f7cc0 c0293942 f7e865d0 c1a026bc
        c19f7cf0 000003ae 2dae0756 00000009 c19f7cf0 c19f7dc8 f6af7964 c19f7cfc
Call Trace:
  [<c0364fa4>] wait_for_completion+0x64/0xa0
  [<c021bb7d>] blk_execute_rq+0x8d/0xb0
  [<c02b7a88>] scsi_execute+0xb8/0x110
  [<c02b7b48>] scsi_execute_req+0x68/0x90
  [<c02bdefd>] sd_spinup_disk+0x6d/0x400
  [<c02bf25b>] sd_revalidate_disk+0x6b/0x160
  [<c02bdc1f>] sd_rescan+0x1f/0x30
  [<c02bb002>] scsi_rescan_device+0x42/0x50
  [<c02c9e10>] ata_scsi_dev_rescan+0x60/0x70
  [<c0127ebd>] run_workqueue+0x4d/0xf0
  [<c012806d>] worker_thread+0xcd/0xf0
  [<c012b247>] kthread+0x67/0x70
  [<c01049fb>] kernel_thread_helper+0x7/0x4c
  =======================
kseriod       D C0364CA5     0   123      2 (L-TLB)
        c19e9f50 00000046 f6723e40 c0364ca5 c19e9f60 00000046 c043fc08 00000000
        c19e9f30 c0440de0 d568e80c 00000018 00000db6 00000000 c19b3550 c1a02bbc
        0000006e 000000d3 d5690886 00000018 c19e9f50 00000000 c02d57a0 c19e9f98
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c02d5889>] serio_thread+0xe9/0x100
  [<c012b247>] kthread+0x67/0x70
  [<c01049fb>] kernel_thread_helper+0x7/0x4c
  =======================
pdflush       D C0364CA5     0   145      2 (L-TLB)
        c1a49f50 00000046 f6a95f00 c0364ca5 c1a49f60 00000046 c048b0e0 c192e530
        c1a49f20 fffee524 d5691002 00000018 000021c7 00000000 f7cfda70 c196913c
        0000007d 00000088 d5696002 00000018 c1a49f50 00000000 c1a49f98 fffffffc
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c01487c6>] __pdflush+0x146/0x150
  [<c01487f5>] pdflush+0x25/0x30
  [<c012b247>] kthread+0x67/0x70
  [<c01049fb>] kernel_thread_helper+0x7/0x4c
  =======================
pdflush       D C0364CA5     0   146      2 (L-TLB)
        c1a4bf50 00000046 f6811f80 c0364ca5 c1a4bf60 00000046 c048b0e0 c192e530
        00002afd c19615d0 d569120c 00000018 000018e4 00000000 f7cafa90 c19b3b5c
        00000073 00000129 b6997622 00000009 c1a4bf50 00000000 c1a4bf98 fffffffc
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c01487c6>] __pdflush+0x146/0x150
  [<c01487f5>] pdflush+0x25/0x30
  [<c012b247>] kthread+0x67/0x70
  [<c01049fb>] kernel_thread_helper+0x7/0x4c
  =======================
kswapd0       D C0364CA5     0   147      2 (L-TLB)
        c1999f40 00000046 c19e9f50 c0364ca5 c1999f50 00000046 c1999f28 0000000d
        7054e600 0000120c d568ec56 00000018 00000ecb 00000000 c19b7070 c19b365c
        0000006e 000000af d5690f62 00000018 c1999f40 00000000 c0430f44 00000000
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c014b451>] kswapd+0xd1/0x100
  [<c012b247>] kthread+0x67/0x70
  [<c01049fb>] kernel_thread_helper+0x7/0x4c
  =======================
aio/0         S C192E530     0   148      2 (L-TLB)
        c19d1f60 00000046 c048b0e0 c192e530 c19d1f20 c0116be1 c192e530 831e4802
        c19d1f40 c0116d2b 8320a84a 00000004 000000e6 00000000 c192e530 c19b315c
        00000078 0000025c 8320aa6d 00000004 00000246 c194de20 c19d1f88 c194de28
Call Trace:
  [<c012808c>] worker_thread+0xec/0xf0
  [<c012b247>] kthread+0x67/0x70
  [<c01049fb>] kernel_thread_helper+0x7/0x4c
  =======================
xfslogd/0     S C194D9E0     0   149      2 (L-TLB)
        c19d3f60 00000046 f74c8140 c194d9e0 c195f4e0 f74c8140 c194d9e0 c020a5f0
        c19d3f30 c020a629 fe7b2b4b f74c819c c19d3f60 c0127ebd f6ba0ad0 c19b7b7c
        00000073 00000486 d8c04420 00000018 00000246 c194d9e0 c19d3f88 c194d9e8
Call Trace:
  [<c012808c>] worker_thread+0xec/0xf0
  [<c012b247>] kthread+0x67/0x70
  [<c01049fb>] kernel_thread_helper+0x7/0x4c
  =======================
xfsdatad/0    S F6E1F240     0   150      2 (L-TLB)
        c19d5f60 00000046 c048b0e0 f6e1f240 c19d5f20 c1a31be0 c1a31968 c194d9a0
        c19d5f30 c0207f8e 832a8b34 c1a31c08 c19d5f60 c0127ebd c19b3a50 c19b767c
        00000078 00000077 d5327a77 00000018 00000246 c194d9a0 c19d5f88 c194d9a8
Call Trace:
  [<c012808c>] worker_thread+0xec/0xf0
  [<c012b247>] kthread+0x67/0x70
  [<c01049fb>] kernel_thread_helper+0x7/0x4c
  =======================
scsi_eh_0     S 00000001     0   774      2 (L-TLB)
        f7e1dfb0 00000046 c199d044 00000001 00000003 00000246 00000296 00000246
        00000000 00000246 c199d000 fffffffc f7e1df90 c02b822e c192ea30 f7d0915c
        f7e1dfb0 0019aedd 7711c10e 00000005 c199d000 c199d000 c02b7440 fffffffc
Call Trace:
  [<c02b7481>] scsi_error_handler+0x41/0xb0
  [<c012b247>] kthread+0x67/0x70
  [<c01049fb>] kernel_thread_helper+0x7/0x4c
  =======================
scsi_eh_1     S 00000001     0   776      2 (L-TLB)
        f7f63fb0 00000046 f7ff3c44 00000001 00000003 00000246 00000296 00000246
        00000000 00000246 f7ff3c00 fffffffc f7f63f90 c02b822e c192ea30 f7d76b9c
        f7f63fb0 0019dca3 96bbf4e7 00000005 f7ff3c00 f7ff3c00 c02b7440 fffffffc
Call Trace:
  [<c02b7481>] scsi_error_handler+0x41/0xb0
  [<c012b247>] kthread+0x67/0x70
  [<c01049fb>] kernel_thread_helper+0x7/0x4c
  =======================
scsi_eh_2     S 00000001     0   778      2 (L-TLB)
        f7d7ffb0 00000046 f7ff3844 00000001 00000003 00000246 00000296 00000246
        00000000 00000246 f7ff3800 fffffffc f7d7ff90 c02b822e c192ea30 f7f56b7c
        f7d7ffb0 001a10a7 b67304f7 00000005 f7ff3800 f7ff3800 c02b7440 fffffffc
Call Trace:
  [<c02b7481>] scsi_error_handler+0x41/0xb0
  [<c012b247>] kthread+0x67/0x70
  [<c01049fb>] kernel_thread_helper+0x7/0x4c
  =======================
scsi_eh_3     S 00000001     0   780      2 (L-TLB)
        c1973fb0 00000046 f7ff3444 00000001 00000003 00000246 00000296 00000246
        00000000 00000246 f7ff3400 fffffffc c1973f90 c02b822e c192ea30 f7d7217c
        c1973fb0 001c81ca d688c25d 00000005 f7ff3400 f7ff3400 c02b7440 fffffffc
Call Trace:
  [<c02b7481>] scsi_error_handler+0x41/0xb0
  [<c012b247>] kthread+0x67/0x70
  [<c01049fb>] kernel_thread_helper+0x7/0x4c
  =======================
scsi_eh_4     S F7945000     0   803      2 (L-TLB)
        c19a1fb0 00000046 c198d808 f7945000 c19a1f80 c02b44b2 00000296 00000246
        c198d800 c198d800 2ea53f8d 00000009 002f2c50 00000000 c19615d0 f7cb4bdc
        0000006e 000ec5ac 2ea53f8d 00000009 f7945000 f7945000 c02b7440 fffffffc
Call Trace:
  [<c02b7481>] scsi_error_handler+0x41/0xb0
  [<c012b247>] kthread+0x67/0x70
  [<c01049fb>] kernel_thread_helper+0x7/0x4c
  =======================
scsi_eh_5     S C198DC00     0   805      2 (L-TLB)
        f7957fb0 00000046 c198d408 c198dc00 f7957f80 c02b44b2 00000296 00000246
        c198d400 c198d400 34285c1c 00000009 002f23b7 00000000 c19615d0 f7e866dc
        0000006e 000ec3bc 34285c1c 00000009 c198dc00 c198dc00 c02b7440 fffffffc
Call Trace:
  [<c02b7481>] scsi_error_handler+0x41/0xb0
  [<c012b247>] kthread+0x67/0x70
  [<c01049fb>] kernel_thread_helper+0x7/0x4c
  =======================
kpsmoused     S C192E530     0   826      2 (L-TLB)
        f7f65f60 00000046 c048b0e0 c192e530 f7f65f20 c0116be1 c192e530 40af11dc
        f7f65f40 c0116d2b 40af2e63 00000006 000000b8 00000000 c1932050 c196963c
        00000078 0000002d 40af301a 00000006 00000246 f7898c20 f7f65f88 f7898c28
Call Trace:
  [<c012808c>] worker_thread+0xec/0xf0
  [<c012b247>] kthread+0x67/0x70
  [<c01049fb>] kernel_thread_helper+0x7/0x4c
  =======================
md0_raid5     D F7F4D000     0   836      2 (L-TLB)
        f78a3da0 00000046 f7f4d000 f7f4d000 f78a3da0 c01454b6 c048b0e0 f6ba0ad0
        f78a3d70 c0116be1 00010ad0 d5658227 f78a3d90 f7853000 f70c4ae0 f7f5617c
        f78a3de0 00003440 1be4a921 00000009 00000246 f7853000 f78a3dc8 f785313c
Call Trace:
  [<c02f1287>] md_super_wait+0x77/0xc0
  [<c02f993f>] write_sb_page+0x4f/0x80
  [<c02f9a72>] write_page+0x102/0x110
  [<c02f9db9>] bitmap_update_sb+0x89/0x90
  [<c02f3353>] md_update_sb+0x123/0x2a0
  [<c02f93c2>] md_check_recovery+0x302/0x340
  [<c02ec1f2>] raid5d+0x12/0xf0
  [<c02f7746>] md_thread+0x56/0x110
  [<c012b247>] kthread+0x67/0x70
  [<c01049fb>] kernel_thread_helper+0x7/0x4c
  =======================
xfsbufd       D 00000018     0   838      2 (L-TLB)
        f74dff90 00000046 be2cd3b0 00000018 00000282 00000282 ffff3153 ffff3153
        f74dff90 c0365572 d568effd 00000018 00001133 00000000 f7e86ad0 c19b717c
        0000006e 000000ef d56918bc 00000018 f74dff90 00000000 00000000 f78981a0
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c020b453>] xfsbufd+0xf3/0x100
  [<c012b247>] kthread+0x67/0x70
  [<c01049fb>] kernel_thread_helper+0x7/0x4c
  =======================
xfssyncd      D 00000017     0   839      2 (L-TLB)
        f75a5f80 00000046 6b45182c 00000017 00000282 00000282 ffff4dc1 ffff4dc1
        f75a5f80 c0365572 d568f322 00000018 00001289 00000000 f7cfd570 f7e86bdc
        0000006e 000000a1 d5691f0a 00000018 f75a5f80 00000000 f75a5fa8 c19c83dc
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0211088>] xfssyncd+0x158/0x160
  [<c012b247>] kthread+0x67/0x70
  [<c01049fb>] kernel_thread_helper+0x7/0x4c
  =======================
udevd         D 00000005     0   920      1 (NOTLB)
        f7657ea0 00000082 08dd4c82 00000005 f7029005 c017bfc0 ffffffff ffffffff
        f7657e70 c017223e d5159415 00000018 00007ccf 00000000 f7e860d0 f7d72b7c
        00000074 0000052e d516bbb0 00000018 f7657ea0 00000000 00000000 f7657f08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
ksuspend_usbd S C192E530     0  1727      2 (L-TLB)
        f7025f60 00000046 c048b0e0 c192e530 f7025f20 c0116be1 c192e530 5513327e
        f7025f40 c0116d2b 00000002 f70fc5c0 c048b0e0 00000003 f7cfd570 f7cac67c
        4ccd1400 0000006f 55e6d417 00000007 00000246 f77644a0 f7025f88 f77644a8
Call Trace:
  [<c012808c>] worker_thread+0xec/0xf0
  [<c012b247>] kthread+0x67/0x70
  [<c01049fb>] kernel_thread_helper+0x7/0x4c
  =======================
khubd         D C0364CA5     0  1728      2 (L-TLB)
        f71edf60 00000046 f75a5f80 c0364ca5 f71edf70 00000046 00000000 000003e8
        f71edf30 f881d3e2 d568f7b8 00000018 00001510 00000000 c1961ad0 f7cfd67c
        0000006e 0000010e d569299c 00000018 f71edf60 00000000 f88201c0 f71edf98
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<f8820216>] hub_thread+0x56/0xf0 [usbcore]
  [<c012b247>] kthread+0x67/0x70
  [<c01049fb>] kernel_thread_helper+0x7/0x4c
  =======================
ksnapd        S C192E530     0  2131      2 (L-TLB)
        f7191f60 00000046 c048b0e0 c192e530 f7191f20 c0116be1 c192e530 d38fa60e
        f7191f40 c0116d2b cec67144 00000008 c048b0e0 00000003 f7d76090 f7122b9c
        3e9b5600 000000a6 d39e34de 00000008 00000246 f77ceda0 f7191f88 f77ceda8
Call Trace:
  [<c012808c>] worker_thread+0xec/0xf0
  [<c012b247>] kthread+0x67/0x70
  [<c01049fb>] kernel_thread_helper+0x7/0x4c
  =======================
kjournald     D C0364CA5     0  2180      2 (L-TLB)
        f7391f30 00000046 f71edf60 c0364ca5 f7391f40 00000046 f7355ce8 00000000
        f7391f20 c0117637 d568fb3b 00000018 00001738 00000000 f7d76090 c1961bdc
        0000006e 000000dc d569323c 00000018 f7391f30 00000000 c1961ad0 00000001
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c01ab19f>] kjournald+0xcf/0x1c0
  [<c012b247>] kthread+0x67/0x70
  [<c01049fb>] kernel_thread_helper+0x7/0x4c
  =======================
xfsbufd       D 00000018     0  2181      2 (L-TLB)
        f7327f90 00000046 a59ec715 00000018 00000282 00000282 ffff30ec ffff30ec
        f7327f90 c0365572 d568fe77 00000018 000018ed 00000000 f7caf090 f7d7619c
        0000006e 000000ba d5693980 00000018 f7327f90 00000000 00000000 f735eae0
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c020b453>] xfsbufd+0xf3/0x100
  [<c012b247>] kthread+0x67/0x70
  [<c01049fb>] kernel_thread_helper+0x7/0x4c
  =======================
xfssyncd      D 00000011     0  2182      2 (L-TLB)
        f6853f80 00000046 756f731d 00000011 00000282 00000282 ffff34c1 ffff34c1
        f6853f80 c0365572 d569014d 00000018 00001a21 00000000 f7d61070 f7caf19c
        0000006e 00000091 d5693f32 00000018 f6853f80 00000000 f6853fa8 f735fc3c
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0211088>] xfssyncd+0x158/0x160
  [<c012b247>] kthread+0x67/0x70
  [<c01049fb>] kernel_thread_helper+0x7/0x4c
  =======================
xfsbufd       D 00000018     0  2183      2 (L-TLB)
        f6fd1f90 00000046 b9683ccc 00000018 00000282 00000282 ffff313f ffff313f
        f6fd1f90 c0365572 d569044b 00000018 00001b3d 00000000 f70fc050 f7d6117c
        0000006e 0000008f d56944ce 00000018 f6fd1f90 00000000 00000000 f7764da0
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c020b453>] xfsbufd+0xf3/0x100
  [<c012b247>] kthread+0x67/0x70
  [<c01049fb>] kernel_thread_helper+0x7/0x4c
  =======================
xfssyncd      D 00000011     0  2184      2 (L-TLB)
        f6811f80 00000046 7d105920 00000011 00000282 00000282 ffff34e1 ffff34e1
        f6811f80 c0365572 d568fa72 00000018 00002175 00000000 c19b3a50 f70fc15c
        00000073 0000007d d56949b2 00000018 f6811f80 00000000 f6811fa8 f735f73c
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0211088>] xfssyncd+0x158/0x160
  [<c012b247>] kthread+0x67/0x70
  [<c01049fb>] kernel_thread_helper+0x7/0x4c
  =======================
portmap       D F64600A0     0  2344      1 (NOTLB)
        f6f8fea0 00000086 00000000 f64600a0 f6f8fe60 c0341701 f649f960 f64600a0
        f6f8fea0 c0343533 d5152861 00000018 00002e3f 00000000 f771a5d0 f7cb16bc
        00000073 00000271 d51595e9 00000018 f6f8fea0 00000000 0804ff78 f6f8ff08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
syslogd       D F77C12C0     0  2477      1 (NOTLB)
        f6e1bea0 00000086 ffffffff f77c12c0 00000000 00000000 00000000 00000000
        f7cb5a30 00000000 d515b595 00000018 0000799b 00000000 f6ac8090 f7cb5b3c
        00000075 00000093 d516d59a 00000018 f6e1bea0 00000000 00000000 f6e1bf08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
klogd         D 00000016     0  2483      1 (NOTLB)
        f75a7ea0 00000086 f7022a20 00000016 e4078600 00006353 f6ba0c80 f6ba0ad0
        f70b5550 f77e6700 d514f394 00000018 000031a7 00000000 c192ea30 f70b565c
        00000073 000000de d515692f 00000018 f75a7ea0 00000000 00000000 f75a7f08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
sshd          D BFBEE000     0  2505      1 (NOTLB)
        f6849ea0 00200086 f68bd4c0 bfbee000 00000000 f6849e58 00000000 00000000
        f6fab910 f70b7a40 d515f375 00000018 000103ef 00000000 f7cb5530 f7cb513c
        00000077 000002e7 d5185b19 00000018 f6849ea0 00000000 00000000 f6849f08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
exim4         D 0000000D     0  2545      1 (NOTLB)
        f68c9ea0 00000086 f68c9e78 0000000d c03edd32 000009f3 f7d79384 f7d61a70
        f70edd40 f70edd40 00c65dd8 00000004 f68c9e78 c0118fd2 f7d61a70 f70fcb5c
        00000000 000001f6 d516f1e6 00000018 f68c9ea0 00000000 00000000 f68c9f08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
inetd         D F6885EB8     0  2551      1 (NOTLB)
        f6885ea0 00000082 f77e0340 f6885eb8 f6885e70 c01490aa 00000001 f6885f00
        f6885e70 c17c0d80 b7f30000 c17c0d80 f6885e80 c0149122 f7d09550 f7d61b7c
        00000000 000004a7 d5171278 00000018 f6885ea0 00000000 00000000 f6885f08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
lpd           D 00000000     0  2555      1 (NOTLB)
        f68cbea0 00000086 00001844 00000000 f68cbe70 f68d8f14 00000001 00000000
        00000004 00000004 00000000 00000000 f68cbed0 c0171008 f7095590 f7d0965c
        00000000 000002b1 d5172550 00000018 f68cbea0 00000000 00000000 f68cbf08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
mysqld_safe   D BFD66000     0  2570      1 (NOTLB)
        f68f1ea0 00000082 f702abfc bfd66000 f68f1e90 c014d81a f7723bfc f75ea224
        bfd51000 bfd66000 d515fa2f 00000018 000105af 00000000 f7cb40d0 f7cb563c
        0000007a 000001cf d51865f6 00000018 f68f1ea0 00000000 081041c8 f68f1f08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
mysqld        D 00000044     0  2607   2570 (NOTLB)
        f6883ea0 00000082 000200d0 00000044 00000001 c16de6c0 c0430f00 00000001
        000200d0 c0430f04 000000d0 f7095590 f6883eb0 c0146ced f7d72570 f709569c
        00000000 0000026e d5173654 00000018 f6883ea0 00000000 00000000 f6883f08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
mysqld        D C17A5D40     0  2609   2570 (NOTLB)
        f6c99ea0 00000082 00000246 c17a5d40 f6c99e80 c0146aac 00000000 00000092
        f6c99eb0 c0493030 d5022392 00000018 000969ea 00000000 c192e030 f7cb41dc
        00000086 0000031a d5186f45 00000018 f6c99ea0 00000000 00000000 f6c99f08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
mysqld        D C0142280     0  2610   2570 (NOTLB)
        f6c9bea0 00000082 00000000 c0142280 c18023d0 f7d72570 c17a5ea0 f6c9be94
        00000001 c0492be0 00000000 00000000 f7d72570 0000000b f70b5050 f7d7267c
        00000000 00000147 d5173f48 00000018 f6c9bea0 00000000 00000000 f6c9bf08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
mysqld        D C17DB760     0  2611   2570 (NOTLB)
        f6c9dea0 00000082 00000246 c17db760 f6c9de80 c0146aac 00000001 f6c9df00
        00000001 c0493180 d515301d 00000018 0000313f 00000000 f771aad0 f771a6dc
        00000073 0000017b d515a4c0 00000018 f6c9dea0 00000000 00000000 f6c9df08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
mysqld        D F7CAC070     0  2612   2570 (NOTLB)
        f6c9fea0 00000082 c048b0e0 f7cac070 f6c9fe60 c0116be1 f7cac070 deff0bf0
        f6c9fe80 c0492c90 00000000 00000000 f70b5050 00000005 f7ca9550 f70b515c
        00000000 000000fd d5174638 00000018 f6c9fea0 00000000 00000000 f6c9ff08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
mysqld        D 00000020     0  2619   2570 (NOTLB)
        f68f3ea0 00000082 c042cf00 00000020 f68f3e80 c0117637 00000000 f68f3ea8
        f68f3e80 c01232e0 d515379d 00000018 000032b5 00000000 f7cac070 f771abdc
        00000073 00000118 d515afb8 00000018 f68f3ea0 00000000 00000000 f68f3f08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
mysqld        D 00000001     0  2620   2570 (NOTLB)
        f6cc9ea0 00000082 f7128e74 00000001 f6cc9e80 c0220656 00000100 00000000
        00000001 f7128e74 00000001 00000000 f6cc9e80 c0229da6 f7ca9050 f7ca965c
        00000000 00000183 d51750ce 00000018 f6cc9ea0 00000000 00000000 f6cc9f08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
mysqld        D 00000005     0  2621   2570 (NOTLB)
        f6ca3ea0 00000082 00000034 00000005 c048b0e0 00000003 f7d72570 c048b0e0
        f6ca3e80 c0492750 d5153bbe 00000018 0000345c 00000000 f7134030 f7cac17c
        00000073 000000cd d515b7c2 00000018 f6ca3ea0 00000000 00000000 f6ca3f08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
mysqld        D C0364CA5     0  2623   2570 (NOTLB)
        f6cebea0 00000082 f6ca3ea0 c0364ca5 f6cebeb0 00000082 f7095590 c048b0e0
        f6cebe80 00000046 d5154280 00000018 00003562 00000000 f70b60b0 f713413c
        00000073 000000eb d515c0f0 00000018 f6cebea0 00000000 00000008 f6cebf08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
logger        D 2A7A7965     0  2608   2570 (NOTLB)
        f68ebea0 00000086 4661e75f 2a7a7965 4661e75f 2a7a7965 00000000 00000000
        00000008 00000000 f6fabcd8 00000400 fffffe00 00000000 f70fc550 f7ca915c
        00000000 00000237 d5176054 00000018 f68ebea0 00000000 b7f11420 f68ebf08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
sshd          D F715C00C     0  2613   2505 (NOTLB)
        f6ca1ea0 00000082 f68bd620 f715c00c 00000000 f6ca1e58 00000000 00000000
        f6ca1eb0 00000001 d5154f02 00000018 00003edf 00000000 f7ca9a50 f70b61bc
        00000073 0000037f d515e3ea 00000018 f6ca1ea0 00000000 00000000 f6ca1f08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
bash          D CE5E96DF     0  2622   2613 (NOTLB)
        f6ce9ea0 00000086 f6ba0ad0 ce5e96df f6ce9e70 c0116d2b 00000000 00000000
        c0430da8 c0430da8 d5155369 00000018 000040c2 00000000 f70b6ab0 f7ca9b5c
        00000073 000000e3 d515eccc 00000018 f6ce9ea0 00000000 080fff48 f6ce9f08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
nrpe          D F64E9A00     0  2660      1 (NOTLB)
        f6f71ea0 00200082 00000008 f64e9a00 f6f71e80 c015f602 00000000 00000000
        f6f71e90 c0353d53 d5155acb 00000018 000045dc 00000000 f7f56570 f70b6bbc
        00000073 000001f2 d5160042 00000018 f6f71ea0 00000000 bfbe883c f6f71f08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
nagios-statd  D F6CB6460     0  2668      1 (NOTLB)
        f6947ea0 00200086 00000008 f6cb6460 f6947e80 c015f602 00000000 00000000
        f6947e90 c0353d53 d51572ff 00000018 00004dce 00000000 f7122090 f7f5667c
        00000073 0000044d d5162b48 00000018 f6947ea0 00000000 bf800770 f6947f08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
netserver     D F772B780     0  2671      1 (NOTLB)
        f6db3ea0 00000082 00000008 f772b780 f6db3e80 c015f602 00000000 00000000
        f6db3e90 c0353d53 d51575a0 00000018 000092ab 00000000 f7cb5a30 f7e861dc
        00000075 0000025e d516d100 00000018 f6db3ea0 00000000 bfd06990 f6db3f08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
lockd         D F7CFDB7C     0  2682      2 (L-TLB)
        f6967eb0 00000046 f7caca70 f7cfdb7c f6967ec0 0000141f d3abfb17 0000000b
        f70796c0 7fffffff d5691332 00000018 000022a5 00000000 f7caca70 f7cfdb7c
        0000007d 00000540 d5696542 00000018 f6967eb0 00000000 f7557000 00000003
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<f94edd05>] svc_recv+0x385/0x410 [sunrpc]
  [<f913f461>] lockd+0x111/0x240 [lockd]
  [<c01049fb>] kernel_thread_helper+0x7/0x4c
  =======================
rpciod/0      S C192E530     0  2683      2 (L-TLB)
        f696df60 00000046 c048b0e0 c192e530 f696df20 f6bfc114 f6f897a0 f94e8fb0
        f696df30 f94e8fbe 00000002 f7cacae0 f696df60 c0127ebd f6ba0ad0 f7cb46dc
        989a3800 0000047b d07704eb 00000018 00000246 f6f897a0 f696df88 f6f897a8
Call Trace:
  [<c012808c>] worker_thread+0xec/0xf0
  [<c012b247>] kthread+0x67/0x70
  [<c01049fb>] kernel_thread_helper+0x7/0x4c
  =======================
nfsd          D 00000000     0  2684      2 (L-TLB)
        f69adf00 00000046 f69adee8 00000000 f69aded0 00000282 d3ac18fa 0000000b
        00000282 00000282 d56915fd 00000018 00002413 00000000 f7122590 f7cacb7c
        0000007d 0000062d d5696b6f 00000018 f69adf00 00000000 f7283000 00000022
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<f94edd05>] svc_recv+0x385/0x410 [sunrpc]
  [<f93b85ac>] nfsd+0xac/0x240 [nfsd]
  [<c01049fb>] kernel_thread_helper+0x7/0x4c
  =======================
nfsd          D 00000000     0  2685      2 (L-TLB)
        f69cff00 00000046 f69cfee8 00000000 f69cfed0 00000282 d3ac25f1 0000000b
        00000282 00000282 d569187c 00000018 00002518 00000000 f7d09a50 f712269c
        0000007d 000004e9 d5697058 00000018 f69cff00 00000000 f698f000 00000022
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<f94edd05>] svc_recv+0x385/0x410 [sunrpc]
  [<f93b85ac>] nfsd+0xac/0x240 [nfsd]
  [<c01049fb>] kernel_thread_helper+0x7/0x4c
  =======================
nfsd          D 00000000     0  2686      2 (L-TLB)
        f69eff00 00000046 f69efee8 00000000 f69efed0 00000282 d3ac30e9 0000000b
        00000282 00000282 d5691ae8 00000018 0000263a 00000000 f7cb1ab0 f7d09b5c
        0000007d 0000051c d5697574 00000018 f69eff00 00000000 f69b4000 00000022
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<f94edd05>] svc_recv+0x385/0x410 [sunrpc]
  [<f93b85ac>] nfsd+0xac/0x240 [nfsd]
  [<c01049fb>] kernel_thread_helper+0x7/0x4c
  =======================
nfsd          D 00000000     0  2687      2 (L-TLB)
        f6a11f00 00000046 f6a11ee8 00000000 f6a11ed0 00000282 d3ac3dcb 0000000b
        00000282 00000282 d5691df7 00000018 0000276f 00000000 f70b5a50 f7cb1bbc
        0000007d 000005e9 d5697b5d 00000018 f6a11f00 00000000 f69d9000 00000022
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<f94edd05>] svc_recv+0x385/0x410 [sunrpc]
  [<f93b85ac>] nfsd+0xac/0x240 [nfsd]
  [<c01049fb>] kernel_thread_helper+0x7/0x4c
  =======================
nfsd          D 00000000     0  2688      2 (L-TLB)
        f6a31f00 00000046 f6a31ee8 00000000 f6a31ed0 00000282 d3ac48a4 0000000b
        00000282 00000282 d569203a 00000018 0000287a 00000000 f7caf590 f70b5b5c
        0000007d 000004bb d5698018 00000018 f6a31f00 00000000 f69fe000 00000022
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<f94edd05>] svc_recv+0x385/0x410 [sunrpc]
  [<f93b85ac>] nfsd+0xac/0x240 [nfsd]
  [<c01049fb>] kernel_thread_helper+0x7/0x4c
  =======================
nfsd          D 00000000     0  2689      2 (L-TLB)
        f6a53f00 00000046 f6a53ee8 00000000 f6a53ed0 00000282 d3ac53f7 0000000b
        00000282 00000282 000cb599 000cb599 f6a53f10 c0365572 f6ba0ad0 f7caf69c
        00000000 000004bc d56984d4 00000018 f6a53f00 00000000 f6a23000 00000022
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<f94edd05>] svc_recv+0x385/0x410 [sunrpc]
  [<f93b85ac>] nfsd+0xac/0x240 [nfsd]
  [<c01049fb>] kernel_thread_helper+0x7/0x4c
  =======================
nfsd          D 00000000     0  2690      2 (L-TLB)
        f6a73f00 00000046 f6a73ee8 00000000 f6a73ed0 00000282 b6d79c59 00000018
        00000282 00000282 d56915b7 00000018 00001ae5 00000000 f7d61570 f7cafb9c
        00000073 000000d7 d569556a 00000018 f6a73f00 00000000 f6a49000 00000022
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<f94edd05>] svc_recv+0x385/0x410 [sunrpc]
  [<f93b85ac>] nfsd+0xac/0x240 [nfsd]
  [<c01049fb>] kernel_thread_helper+0x7/0x4c
  =======================
nfsd          D 00000000     0  2691      2 (L-TLB)
        f6a95f00 00000046 f6a95ee8 00000000 f6a95ed0 00000282 b6d79006 00000018
        00000282 00000282 d568ff0f 00000018 000026e8 00000000 c1969030 f7d6167c
        00000074 00000094 d5695b36 00000018 f6a95f00 00000000 f6a6e000 00000022
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<f94edd05>] svc_recv+0x385/0x410 [sunrpc]
  [<f93b85ac>] nfsd+0xac/0x240 [nfsd]
  [<c01049fb>] kernel_thread_helper+0x7/0x4c
  =======================
rpc.mountd    D F64604C0     0  2695      1 (NOTLB)
        f6ab5ea0 00000082 00000000 f64604c0 f6ab5e60 c0341701 f649f960 f64604c0
        f6ab5ea0 c0343533 d5158432 00000018 00005425 00000000 f7095090 f712219c
        00000073 00000338 d5164b7e 00000018 f6ab5ea0 00000000 00000000 f6ab5f08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
rsync         D 00000002     0  2701      1 (NOTLB)
        f6ab7ea0 00000082 00000000 00000002 00000283 0000000a 00000010 f6968e94
        f6ab7eb0 c0279a20 00000000 f6ab7eb8 c0408d6f 00000246 f6ac8a90 f70fc65c
        00000000 00000233 d5176fba 00000018 f6ab7ea0 00000000 00000000 f6ab7f08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
smartd        D 2A7A7965     0  2710      1 (NOTLB)
        f6badea0 00000086 4661e75f 2a7a7965 4661e75f 2a7a7965 00000000 00000000
        f6a9eb84 f78f5f40 f6a9eb60 f78f5f40 f6badea0 c012f070 f6ba8a50 f6ac8b9c
        00000000 00000183 d5177a53 00000018 f6badea0 00000000 bfeea9e4 f6badf08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
rpc.statd     D 00000000     0  2766      1 (NOTLB)
        f6bc9ea0 00000082 00000000 00000000 00000000 bfe8a9f4 00000010 bfe8a9d0
        f6a9e604 c193fda0 00000002 fffffff3 f6bc9ea8 f6a9e5e0 f7d02ab0 f6ba8b5c
        00000000 000002fe d5178f48 00000018 f6bc9ea0 00000000 00000000 f6bc9f08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
rpc.idmapd    D 00000001     0  2774      1 (NOTLB)
        f642dea0 00000082 0000012b 00000001 c04903b8 00000000 f642de78 c011ec21
        00000000 00000010 d5158962 00000018 00005704 00000000 f6b9e5b0 f709519c
        00000073 00000133 d516577c 00000018 f642dea0 00000000 00001388 f642df08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
ntpd          D BFA422F4     0  2789      1 (NOTLB)
        f6bbfea0 00200086 00000000 bfa422f4 f6bbfe60 c0108f08 3b9aca00 f6b9e5b0
        f6bbfe80 c010364b d5159373 00000018 00005c9b 00000000 f6ba05d0 f6b9e6bc
        00000073 00000254 d5166ec8 00000018 f6bbfea0 00000000 00000000 f6bbff08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
mdadm         D C190D860     0  2802      1 (NOTLB)
        f6f1dea0 00000082 f7d6aea0 c190d860 c190d8c8 c190d860 c195f7e0 f785310c
        f710bca0 f7d6aea0 f6f1df08 00000001 c190d86c 00000000 f7cfd070 f7d02bbc
        00000000 00000291 d517a142 00000018 f6f1dea0 00000000 bfbf3f78 f6f1df08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
amd           D 00000010     0  2814      1 (NOTLB)
        f6f39ea0 00000086 f6f39ec8 00000010 f6f39e88 00000001 f6f39e68 00000018
        00000000 00000000 d515a1d0 00000018 000062c5 00000000 f7134530 f6ba06dc
        00000073 000002e5 d5168bc0 00000018 f6f39ea0 00000000 00000000 f6f39f08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
atd           D C01D5920     0  2843      1 (NOTLB)
        f6465ea0 00000082 00000000 c01d5920 f6465e60 c01e4ce8 00000008 00000000
        f646f2f8 f6aa2660 f6465f08 f6470060 f6465ea0 c012f070 f7cb10b0 f7cfd17c
        00000000 0000016b d517ab31 00000018 f6465ea0 00000000 bfa33f04 f6465f08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
cron          D 0000000D     0  2846      1 (NOTLB)
        f6485ea0 00000086 f6485e78 0000000d c03edd32 00000f20 f7ffbda4 f6b9fa70
        f7086460 f7086460 00cafdb8 00000004 f6485ea0 f7004c80 f70fca50 f6ac819c
        00000000 000001d2 d516e42a 00000018 f6485ea0 00000000 bf7ff544 f6485f08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
miniserv.pl   D F64EDEB8     0  2869      1 (NOTLB)
        f64edea0 00000086 f77ad3a0 f64edeb8 f64ede90 c020b998 00000001 f64edf00
        00000001 00000000 d5156000 00000018 000087dd 00000000 f7d72a70 f713463c
        00000074 00000234 d516a1ca 00000018 f64edea0 00000000 00000000 f64edf08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
apache        D F6463EB8     0  2898      1 (NOTLB)
        f6463ea0 00000082 c1a110e0 f6463eb8 f6463e90 c020b998 00000000 00000000
        c0430da8 c0430da8 c0430f18 00000044 f6463ea0 c0146c5d f6ba6a30 f7cb11bc
        00000000 000001b1 d517b708 00000018 f6463ea0 00000000 00000000 f6463f08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
apache        D 00000000     0  2910   2898 (NOTLB)
        f64f1ea0 00000082 00000000 00000000 f64f1e90 c0158d44 00000000 00000000
        c0430da8 c0430da8 c0430f18 00000044 f68d8064 f68d8154 f7d76590 f6ba6b3c
        00000000 00000265 d517c7cc 00000018 f64f1ea0 00000000 00000000 f64f1f08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
apache        D 00000000     0  2911   2898 (NOTLB)
        f6555ea0 00000082 00000000 00000000 f6555e90 c0158d44 00000000 00000000
        c0430da8 c0430da8 c0430f18 00000044 f68d8064 f68d8154 f6ba6530 f7d7669c
        00000000 0000020d d517d62c 00000018 f6555ea0 00000000 00000000 f6555f08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
apache        D 00000000     0  2912   2898 (NOTLB)
        f6559ea0 00000086 00000000 00000000 f6559e90 c0158d44 00000000 00000000
        c0430da8 c0430da8 c0430f18 00000044 f68d8064 f68d8154 f7134a30 f6ba663c
        00000000 0000011c d517ddf6 00000018 f6559ea0 00000000 00000000 f6559f08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
apache        D 00000000     0  2913   2898 (NOTLB)
        f64a5ea0 00000086 00000000 00000000 f64a5e90 c0158d44 00000000 00000000
        c0430da8 c0430da8 c0430f18 00000044 f68d8064 f68d8154 f6b9f570 f7134b3c
        00000000 00000153 d517e73e 00000018 f64a5ea0 00000000 00000000 f64a5f08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
apache        D 00000000     0  2914   2898 (NOTLB)
        f6573ea0 00000086 00000000 00000000 f6573e90 c0158d44 00000000 00000000
        c0430da8 c0430da8 c0430f18 00000044 f68d8064 f68d8154 f7d025b0 f6b9f67c
        00000000 0000013d d517efea 00000018 f6573ea0 00000000 00000000 f6573f08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
munin-node    D 00000000     0  3040      1 (NOTLB)
        f6831ea0 00000086 00000000 00000000 00000000 00000000 00000000 00000000
        f714a8ac f66b5800 00000000 00000000 00000000 00000000 f70b65b0 f7d026bc
        00000000 000002c2 d518033a 00000018 f6831ea0 00000000 00000000 f6831f08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
getty         D F65F9EEC     0  3066      1 (NOTLB)
        f65f9ea0 00000082 f6d39400 f65f9eec f65f9e90 c03655af 00000000 c1a38800
        00000001 c1846900 f6d39400 00000000 f65f9e80 00000246 f658a5d0 f70b66bc
        00000000 000002b1 d5181617 00000018 f65f9ea0 00000000 0804b214 f65f9f08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
getty         D F65FBEEC     0  3067      1 (NOTLB)
        f65fbea0 00000086 f6587800 f65fbeec f65fbe90 c03655af 7f1c0300 f65fc20e
        00000000 ffffffff 00000008 00000000 f6584c08 00000246 f658aad0 f658a6dc
        00000000 0000018a d51820de 00000018 f65fbea0 00000000 0804b214 f65fbf08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
getty         D F65D1EEC     0  3068      1 (NOTLB)
        f65d1ea0 00000082 f6556c00 f65d1eec f65d1e90 c03655af 7f1c0300 f664020e
        00000000 ffffffff 00000008 00000000 f6587408 00000246 f6582030 f658abdc
        00000000 0000015e d5182a74 00000018 f65d1ea0 00000000 0804b214 f65d1f08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
getty         D F65D3EEC     0  3069      1 (NOTLB)
        f65d3ea0 00000086 f6556400 f65d3eec f65d3e90 c03655af 7f1c0300 f664620e
        00000000 ffffffff 00000008 00000000 f6556808 00000246 f6589ab0 f658213c
        00000000 00000164 d5183434 00000018 f65d3ea0 00000000 0804b214 f65d3f08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
getty         D F6621EEC     0  3070      1 (NOTLB)
        f6621ea0 00000082 f75e5c00 f6621eec f6621e90 c03655af 7f1c0300 f664c20e
        00000000 ffffffff 00000008 00000000 f64de008 00000246 f6585090 f6589bbc
        00000000 00000183 d5183ece 00000018 f6621ea0 00000000 0804b214 f6621f08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
getty         D F6623EEC     0  3071      1 (NOTLB)
        f6623ea0 00000086 f7843800 f6623eec f6623e90 c03655af 7f1c0300 f667220e
        00000000 ffffffff d515e7c5 00000018 00010183 00000000 f7cb5030 f658519c
        00000077 0000018d d51849ac 00000018 f6623ea0 00000000 0804b214 f6623f08
Call Trace:
  [<c013b1ff>] refrigerator+0x3f/0x50
  [<c0124646>] get_signal_to_deliver+0x226/0x230
  [<c0103cab>] do_signal+0x5b/0x120
  [<c0103dad>] do_notify_resume+0x3d/0x40
  [<c0103f6e>] work_notifysig+0x13/0x19
  =======================
hibernate     D F7945000     0  3874   2622 (NOTLB)
        f6723c60 00000086 f7ea23b8 f7945000 f6723c20 c0121d67 c198d800 f7ea23b8
        f6723c30 c02261b7 28ccc170 00000009 00003a03 00000000 c19615d0 f6ba0bdc
        0000006e 0006a677 28ccc170 00000009 f6723c70 f6723d48 f6af7804 f6723c7c
Call Trace:
  [<c0364fa4>] wait_for_completion+0x64/0xa0
  [<c021bb7d>] blk_execute_rq+0x8d/0xb0
  [<c02b7a88>] scsi_execute+0xb8/0x110
  [<c02b7b48>] scsi_execute_req+0x68/0x90
  [<c02bf80f>] sd_start_stop_device+0x6f/0x120
  [<c02bfb9a>] sd_resume+0x6a/0xa0
  [<c02bbe59>] scsi_bus_resume+0x69/0x80
  [<c0299932>] resume_device+0x132/0x190
  [<c0299aab>] dpm_resume+0xbb/0xc0
  [<c0299ace>] device_resume+0x1e/0x40
  [<c013bfd6>] hibernate+0x106/0x1a0
  [<c013b193>] state_store+0xc3/0xf0
  [<c019353b>] subsys_attr_store+0x3b/0x40
  [<c019370e>] flush_write_buffer+0x2e/0x40
  [<c0193781>] sysfs_write_file+0x61/0x70
  [<c015e858>] vfs_write+0x88/0x110
  [<c015e991>] sys_write+0x41/0x70
  [<c0103ee0>] syscall_call+0x7/0xb
  =======================
