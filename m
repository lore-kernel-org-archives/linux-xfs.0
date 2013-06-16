Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2E3B87F37
	for <xfs@oss.sgi.com>; Sun, 16 Jun 2013 08:27:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A2C33AC001
	for <xfs@oss.sgi.com>; Sun, 16 Jun 2013 06:27:16 -0700 (PDT)
Received: from mail.itpas.no ([85.19.192.5]) by cuda.sgi.com with ESMTP id
	rOZCeS66pb4926Gl for <xfs@oss.sgi.com>;
	Sun, 16 Jun 2013 06:27:13 -0700 (PDT)
Message-ID: <51BDBD2B.70003@itpas.no>
Date: Sun, 16 Jun 2013 15:27:07 +0200
From: =?ISO-8859-1?Q?Torbj=F8rn_Skagestad?= <torbjorn@itpas.no>
MIME-Version: 1.0
Subject: Re: Kernel bug when mounting xfs on dm-crypt + md-raid6 using 3.10-rc5
References: <51B9C28F.2020703@skagestad.org> <51B9C4C9.5000803@sandeen.net>
	<51B9C943.4030900@skagestad.org>
In-Reply-To: <51B9C943.4030900@skagestad.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On 06/13/2013 03:29 PM, Torbj=F8rn wrote:
> On 06/13/2013 03:10 PM, Eric Sandeen wrote:
>> On 6/13/13 8:01 AM, Torbj=F8rn wrote:
>>> Hi,
>>>
>>> I have a 8 drive md-raid6 + dm-crypt with xfs on top.
>>> When trying to mount using 3.10-rc5 (ubuntu mainline ppa) I get the =

>>> following kernel bug:
>>>
>>> [ 1017.056091] SGI XFS with ACLs, security attributes, realtime, =

>>> large block/inode numbers, no debug enabled
>>> [ 1017.057607] XFS (dm-11): Mounting Filesystem
>>> [ 1017.195409] ------------[ cut here ]------------
>>> [ 1017.195881] Kernel BUG at ffffffff81485fb2 [verbose debug info =

>>> unavailable]
>> Hm that's not so helpful :(  So we don't have thread info or
>> line number information.
>>
>>> [ 1017.196603] invalid opcode: 0000 [#1] SMP
>>> [ 1017.197050] Modules linked in: xfs vhost_net macvtap macvlan =

>>> ip6table_filter ip6_tables ebtable_nat ebtables ipt_MASQUERADE =

>>> ipt_REJECT xt_CHECKSUM sch_prio bridge stp llc xt_state =

>>> iptable_filter dm_crypt xt_CLASSIFY xt_tcpudp xt_DSCP iptable_mangle =

>>> iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat =

>>> nf_conntrack ip_tables x_tables intel_powerclamp kvm_intel kvm =

>>> psmouse serio_raw microcode ppdev lpc_ich mac_hid parport_pc =

>>> w83627ehf hwmon_vid coretemp nfsd lp nfs_acl auth_rpcgss nfs parport =

>>> fscache lockd sunrpc btrfs zlib_deflate libcrc32c raid1 raid0 =

>>> multipath linear raid456 async_pq async_xor xor async_memcpy =

>>> async_raid6_recov raid6_pq async_tx raid10 hid_generic usbhid hid =

>>> ast ttm crc32_pclmul drm_kms_helper ghash_clmulni_intel drm =

>>> aesni_intel ablk_helper cryptd lrw gf128mul glue_helper e1000e =

>>> mpt2sas i2c_algo_bit ptp sysimgblt sysfillrect pps_core ahci =

>>> aes_x86_64 syscopyarea scsi_transport_sas libahci raid_class video
>>> [ 1017.206695] CPU: 1 PID: 486 Comm: md0_raid6 Not tainted =

>>> 3.10.0-031000rc5-generic #201306082135
>>> [ 1017.207603] Hardware name: To be filled by O.E.M. To be filled by =

>>> O.E.M./P8B-X series, BIOS 2107 05/04/2012
>>> [ 1017.208681] task: ffff88040e509770 ti: ffff88040de2a000 task.ti: =

>>> ffff88040de2a000
>>> [ 1017.209498] RIP: 0010:[<ffffffff81485fb2>] [<ffffffff81485fb2>] =

>>> scsi_setup_fs_cmnd.part.32+0x82/0x90
>> so it crashed in scsi, and nothing in the stack is from xfs.
>>
>> Barring weird interactions, I think you need to look elsewhere for =

>> the bug;
>> this doesn't look like an xfs problem to me.
>>
>> Actually,
>> https://lkml.org/lkml/2013/6/12/440 looks relevant, which references
>> https://lkml.org/lkml/2013/5/19/75
>>
>> Guessing this is an md bug.
Just for the archives: The patch at https://lkml.org/lkml/2013/5/19/75 =

fixed the issue. It was definitely an md bug. The patch was part of 3.10-rc6
Thanks.
>>
>> -Eric
>>
>>> [ 1017.210467] RSP: 0018:ffff88040de2bb68  EFLAGS: 00010046
>>> [ 1017.211021] RAX: 0000000000000000 RBX: ffff8804106d4800 RCX: =

>>> 0000000000000002
>>> [ 1017.211772] RDX: 0000000000001000 RSI: ffff8803d3b89028 RDI: =

>>> ffff8804106d4800
>>> [ 1017.212521] RBP: ffff88040de2bb78 R08: ffff8803d3b88f30 R09: =

>>> ffff9ef774422900
>>> [ 1017.213300] R10: 0000000018422880 R11: 00000000ffffffff R12: =

>>> ffff8803d3b89028
>>> [ 1017.214054] R13: 0000000000000001 R14: ffff8804106d4800 R15: =

>>> ffff88041032a800
>>> [ 1017.214802] FS:  0000000000000000(0000) GS:ffff88042fc40000(0000) =

>>> knlGS:0000000000000000
>>> [ 1017.215691] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [ 1017.216287] CR2: 00007f9eaa5a4000 CR3: 0000000001c0c000 CR4: =

>>> 00000000001427e0
>>> [ 1017.217069] DR0: 0000000000000000 DR1: 0000000000000000 DR2: =

>>> 0000000000000000
>>> [ 1017.217819] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: =

>>> 0000000000000400
>>> [ 1017.218568] Stack:
>>> [ 1017.218769]  ffff8804106d4800 ffff8803d3b89028 ffff88040de2bb98 =

>>> ffffffff81485fef
>>> [ 1017.219577]  ffff8803d3b89028 ffff8804106ac100 ffff88040de2bc08 =

>>> ffffffff81496c0f
>>> [ 1017.220379]  ffff88040de2bbd8 ffffffff81328aa5 ffff880400001000 =

>>> 0000000018422880
>>> [ 1017.221176] Call Trace:
>>> [ 1017.221415]  [<ffffffff81485fef>] scsi_setup_fs_cmnd+0x2f/0x40
>>> [ 1017.222024]  [<ffffffff81496c0f>] sd_prep_fn+0xff/0xb00
>>> [ 1017.222567]  [<ffffffff81328aa5>] ? =

>>> deadline_remove_request.isra.3+0x55/0x90
>>> [ 1017.223336]  [<ffffffff81310d0e>] blk_peek_request+0xfe/0x270
>>> [ 1017.223953]  [<ffffffff8148588f>] scsi_request_fn+0x4f/0x430
>>> [ 1017.224546]  [<ffffffff8130b757>] __blk_run_queue+0x37/0x50
>>> [ 1017.225145]  [<ffffffff8130d9fd>] queue_unplugged+0x3d/0xc0
>>> [ 1017.225723]  [<ffffffff81311203>] blk_flush_plug_list+0x183/0x210
>>> [ 1017.226360]  [<ffffffff813112a8>] blk_finish_plug+0x18/0x50
>>> [ 1017.226943]  [<ffffffffa0148497>] raid5d+0x1b7/0x1d0 [raid456]
>>> [ 1017.227548]  [<ffffffff8153b66d>] md_thread+0x11d/0x170
>>> [ 1017.228090]  [<ffffffff8106c070>] ? add_wait_queue+0x60/0x60
>>> [ 1017.228681]  [<ffffffff8153b550>] ? md_rdev_init+0x110/0x110
>>> [ 1017.229274]  [<ffffffff8106b8b0>] kthread+0xc0/0xd0
>>> [ 1017.229795]  [<ffffffff8106b7f0>] ? flush_kthread_worker+0xb0/0xb0
>>> [ 1017.230468]  [<ffffffff816d545c>] ret_from_fork+0x7c/0xb0
>>> [ 1017.231048]  [<ffffffff8106b7f0>] ? flush_kthread_worker+0xb0/0xb0
>>> [ 1017.231719] Code: fd ff ff 5b 41 5c 5d c3 48 8b 00 48 85 c0 74 b7 =

>>> 48 8b 40 48 48 85 c0 74 ae ff d0 85 c0 74 a8 eb e2 b8 02 00 00 00 0f =

>>> 1f 00 eb d8 <0f> 0b 66 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 =

>>> 00 55 48
>>> [ 1017.234403] RIP  [<ffffffff81485fb2>] =

>>> scsi_setup_fs_cmnd.part.32+0x82/0x90
>>> [ 1017.235121]  RSP <ffff88040de2bb68>
>>> [ 1017.482522] ---[ end trace fa18c0d8cd90bd2f ]---
>>>
>>> 3.10-rc4 has the same issue. I have not tried any earlier 3.10 kernels
>>> The system mounts fine using 3.9.5 (also ubuntu ppa)
>>>
>>> If I can provide any other info to help, please let me know.
>>>
>>> -- =

>>> Torbj=F8rn
>>>
>>> _______________________________________________
>>> xfs mailing list
>>> xfs@oss.sgi.com
>>> http://oss.sgi.com/mailman/listinfo/xfs
>>>
> Hi,
>
> Thanks for the insight Eric.
> I'll compile a kernel with proper debug info, and see if linux-raid =

> can make any use of it.
>
> -- =

> Torbj=F8rn
>
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
--
Torbj=F8rn

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
