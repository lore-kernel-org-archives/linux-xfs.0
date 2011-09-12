Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8CB31sp251039 for <xfs@oss.sgi.com>; Mon, 12 Sep 2011 06:03:01 -0500
Received: from mail-fx0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D740D54CD5C
	for <xfs@oss.sgi.com>; Mon, 12 Sep 2011 04:02:58 -0700 (PDT)
Received: from mail-fx0-f53.google.com (mail-fx0-f53.google.com
	[209.85.161.53]) by cuda.sgi.com with ESMTP id MXqdXMFm6h6BFCry
	for <xfs@oss.sgi.com>; Mon, 12 Sep 2011 04:02:58 -0700 (PDT)
Received: by fxh2 with SMTP id 2so1411700fxh.26
	for <xfs@oss.sgi.com>; Mon, 12 Sep 2011 04:02:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADDb1s1fr8fiRMAUTvnSqpKeLGJdUPAbEfLNpwb2-iVd+mjw4w@mail.gmail.com>
References: <CADDb1s2QDk7y+JgMikoje35LviYQwzpgFihndUPuZx2VXYV4Ew@mail.gmail.com>
	<20110910183028.GA23537@infradead.org>
	<CADDb1s1fr8fiRMAUTvnSqpKeLGJdUPAbEfLNpwb2-iVd+mjw4w@mail.gmail.com>
Date: Mon, 12 Sep 2011 16:32:57 +0530
Message-ID: <CADDb1s3CyxD6a4sKhAFB6vSYYB=+Sy8V5ZNNNrV7-Y181nMD5Q@mail.gmail.com>
Subject: Re: XFS: Observed Crash followed by deadlock of khubd/sync/XFS
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Kernel Version:
Linux version 3.0.3 (root@localhost.localdomain) (gcc version 4.4.4
20100503 (Red Hat 4.4.4-2) (GCC) ) #5 SMP Fri Sep 9 11:00:53 IST 2011
Target: x86


Sep 12 16:15:49 localhost kernel: [  281.879802] sd 5:0:0:0: [sdb]
15625216 512-byte logical blocks: (8.00 GB/7.45 GiB)
Sep 12 16:15:49 localhost kernel: [  281.881664] sd 5:0:0:0: [sdb]
Write Protect is off
Sep 12 16:15:49 localhost kernel: [  281.883307] sd 5:0:0:0: [sdb] No
Caching mode page present
Sep 12 16:15:49 localhost kernel: [  281.883311] sd 5:0:0:0: [sdb]
Assuming drive cache: write through
Sep 12 16:15:49 localhost kernel: [  281.887671] sd 5:0:0:0: [sdb] No
Caching mode page present
Sep 12 16:15:49 localhost kernel: [  281.887676] sd 5:0:0:0: [sdb]
Assuming drive cache: write through
Sep 12 16:15:49 localhost kernel: [  281.890712]  sdb: sdb1 sdb2 sdb3
Sep 12 16:15:49 localhost kernel: [  281.895542] sd 5:0:0:0: [sdb] No
Caching mode page present
Sep 12 16:15:49 localhost kernel: [  281.895545] sd 5:0:0:0: [sdb]
Assuming drive cache: write through
Sep 12 16:15:49 localhost kernel: [  281.895548] sd 5:0:0:0: [sdb]
Attached SCSI removable disk
Sep 12 16:15:49 localhost kernel: [  282.171467] XFS (sdb3): Mounting Files=
ystem
Sep 12 16:15:50 localhost kernel: [  283.264423] XFS (sdb3): Ending clean m=
ount
Sep 12 16:16:37 localhost kernel: [  330.586075] usb 2-6: USB
disconnect, device number 3
Sep 12 16:16:41 localhost kernel: [  334.105070] XFS (sdb3): I/O error
occurred: meta-data dev sdb3 block 0x56f159       ("xlog_iodone")
error 5 buf count 1024
Sep 12 16:16:41 localhost kernel: [  334.105076] XFS (sdb3):
xfs_do_force_shutdown(0x2) called from line 891 of file
fs/xfs/xfs_log.c.  Return address =3D 0xf7b20ae1
Sep 12 16:16:41 localhost kernel: [  334.105084] XFS (sdb3): Log I/O
Error Detected.  Shutting down filesystem
Sep 12 16:16:41 localhost kernel: [  334.105088] XFS (sdb3): Please
umount the filesystem and rectify the problem(s)
Sep 12 16:16:41 localhost kernel: [  334.105093] XFS (sdb3): Unable to
update superblock counters. Freespace may not be correct on next
mount.
Sep 12 16:16:41 localhost kernel: [  334.105147] XFS (=80):
xfs_trans_ail_delete_bulk: attempting to delete a log item that is not
in the AIL
Sep 12 16:16:41 localhost kernel: [  334.105152] XFS (=80):
xfs_do_force_shutdown(0x8) called from line 740 of file
fs/xfs/xfs_trans_ail.c.  Return address =3D 0xf7b2dc7a
Sep 12 16:16:41 localhost kernel: [  334.105168] BUG: unable to handle
kernel NULL pointer dereference at 00000208
Sep 12 16:16:41 localhost kernel: [  334.105243] IP: [<f7b20f73>]
xfs_log_force_umount+0x1d/0x1b5 [xfs]
Sep 12 16:16:41 localhost kernel: [  334.105346] *pde =3D 00000000
Sep 12 16:16:41 localhost kernel: [  334.105377] Oops: 0000 [#1] SMP
Sep 12 16:16:41 localhost kernel: [  334.105414] Modules linked in:
vfat fat usb_storage xfs exportfs fuse sunrpc cpufreq_ondemand
acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6
ip6table_filter ip6_tables ipv6 uinput r8169 microcode
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep i2c_i801
snd_seq snd_seq_device snd_pcm snd_timer snd soundcore snd_page_alloc
mii ppdev parport_pc parport iTCO_wdt iTCO_vendor_support pcspkr i915
drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded:
scsi_wait_scan]
Sep 12 16:16:41 localhost kernel: [  334.105926]
Sep 12 16:16:41 localhost kernel: [  334.105944] Pid: 2233, comm:
umount Not tainted 3.0.3 #5 Hewlett-Packard HP dx2480
MT(KL969AV)/0B08h
Sep 12 16:16:41 localhost kernel: [  334.106005] EIP:
0060:[<f7b20f73>] EFLAGS: 00210202 CPU: 1
Sep 12 16:16:41 localhost kernel: [  334.106005] EIP is at
xfs_log_force_umount+0x1d/0x1b5 [xfs]
Sep 12 16:16:41 localhost kernel: [  334.106005] EAX: f2a1b380 EBX:
000001f4 ECX: f3ccdd5c EDX: 00000000
Sep 12 16:16:41 localhost kernel: [  334.106005] ESI: f2a1b380 EDI:
00000000 EBP: f3ccdd98 ESP: f3ccdd80
Sep 12 16:16:41 localhost kernel: [  334.106005]  DS: 007b ES: 007b
FS: 00d8 GS: 00e0 SS: 0068
Sep 12 16:16:41 localhost kernel: [  334.106005] Process umount (pid:
2233, ti=3Df3ccc000 task=3Df1f957f0 task.ti=3Df3ccc000)
Sep 12 16:16:41 localhost kernel: [  334.106005] Stack:
Sep 12 16:16:41 localhost kernel: [  334.106005]  f7b32547 f2a1b380
00000000 f2a1b380 00000008 00000000 f3ccddb0 f7b32564
Sep 12 16:16:41 localhost kernel: [  334.106005]  00000000 f2a1b000
f2a1b380 00000000 f3ccddec f7b2dc7a 000002e4 f2a1b380
Sep 12 16:16:41 localhost kernel: [  334.106005]  00000004 f7b48bbf
f7b42efc f7b2364d 00000001 f3ccddf4 f2a1b004 00000000
Sep 12 16:16:41 localhost kernel: [  334.106005] Call Trace:
Sep 12 16:16:41 localhost kernel: [  334.106005]  [<f7b32547>] ?
xfs_do_force_shutdown+0x39/0xd6 [xfs]
Sep 12 16:16:41 localhost kernel: [  334.106005]  [<f7b32564>]
xfs_do_force_shutdown+0x56/0xd6 [xfs]
Sep 12 16:16:41 localhost kernel: [  334.106005]  [<f7b2dc7a>]
xfs_trans_ail_delete_bulk+0x83/0xfa [xfs]
Sep 12 16:16:41 localhost kernel: [  334.106005]  [<f7b2364d>] ?
xlog_cil_push+0x2d1/0x2f6 [xfs]
Sep 12 16:16:41 localhost kernel: [  334.106005]  [<f7b35623>] ?
xfs_buf_iodone_work+0x14/0x23 [xfs]
Sep 12 16:16:41 localhost kernel: [  334.106005]  [<f7b09d6f>]
xfs_buf_iodone+0x31/0x3d [xfs]
Sep 12 16:16:41 localhost kernel: [  334.106005]  [<f7b09d1b>]
xfs_buf_do_callbacks+0x24/0x31 [xfs]
Sep 12 16:16:41 localhost kernel: [  334.106005]  [<f7b0a5b7>]
xfs_buf_iodone_callbacks+0x16f/0x1a2 [xfs]
Sep 12 16:16:41 localhost kernel: [  334.106005]  [<f7b35623>]
xfs_buf_iodone_work+0x14/0x23 [xfs]
Sep 12 16:16:41 localhost kernel: [  334.106005]  [<f7b357ec>]
xfs_buf_ioend+0x95/0xa5 [xfs]
Sep 12 16:16:41 localhost kernel: [  334.106005]  [<f7b35954>] ?
xfs_bioerror+0x34/0x3c [xfs]
Sep 12 16:16:41 localhost kernel: [  334.106005]  [<f7b36217>] ?
xfs_flush_buftarg+0x9e/0xe9 [xfs]
Sep 12 16:16:41 localhost kernel: [  334.106005]  [<f7b35954>]
xfs_bioerror+0x34/0x3c [xfs]
Sep 12 16:16:41 localhost kernel: [  334.106005]  [<f7b36169>]
xfs_bdstrat_cb+0x5f/0x6f [xfs]
Sep 12 16:16:41 localhost kernel: [  334.106005]  [<f7b36217>]
xfs_flush_buftarg+0x9e/0xe9 [xfs]
Sep 12 16:16:41 localhost kernel: [  334.106005]  [<f7b36284>]
xfs_free_buftarg+0x22/0x45 [xfs]
Sep 12 16:16:41 localhost kernel: [  334.106005]  [<f7b3c390>]
xfs_close_devices+0x55/0x59 [xfs]
Sep 12 16:16:41 localhost kernel: [  334.106005]  [<f7b3c3e4>]
xfs_fs_put_super+0x50/0x61 [xfs]
Sep 12 16:16:41 localhost kernel: [  334.106005]  [<c04e1432>]
generic_shutdown_super+0x52/0xb0
Sep 12 16:16:41 localhost kernel: [  334.106005]  [<c04e14b2>]
kill_block_super+0x22/0x5e
Sep 12 16:16:41 localhost kernel: [  334.106005]  [<c04e1997>]
deactivate_locked_super+0x1f/0x40
Sep 12 16:16:41 localhost kernel: [  334.106005]  [<c04e21bf>]
deactivate_super+0x37/0x3c
Sep 12 16:16:41 localhost kernel: [  334.106005]  [<c04f40c3>]
mntput_no_expire+0x114/0x11a
Sep 12 16:16:41 localhost kernel: [  334.106005]  [<c04f4a2b>]
sys_umount+0x26e/0x295
Sep 12 16:16:41 localhost kernel: [  334.106005]  [<c04f4a64>]
sys_oldumount+0x12/0x14
Sep 12 16:16:41 localhost kernel: [  334.106005]  [<c07c401f>]
sysenter_do_call+0x12/0x28
Sep 12 16:16:41 localhost kernel: [  334.106005] Code: 05 b8 05 00 00
00 83 c4 10 5b 5e 5f 5d c3 55 89 e5 57 56 53 83 ec 0c 3e 8d 74 26 00
89 55 f0 8b 98 18 01 00 00 89 c6 85 db 74 06 <f6> 43 14 02 74 27 8b 86
e0 00 00 00 31 ff 83 8e cc 01 00 00 10
Sep 12 16:16:41 localhost kernel: [  334.106005] EIP: [<f7b20f73>]
xfs_log_force_umount+0x1d/0x1b5 [xfs] SS:ESP 0068:f3ccdd80
Sep 12 16:16:41 localhost kernel: [  334.106005] CR2: 0000000000000208
Sep 12 16:16:41 localhost kernel: [  334.135511] ---[ end trace
f3af361b30e84114 ]---
Sep 12 16:16:41 localhost kernel: [  334.135514] ------------[ cut
here ]------------
Sep 12 16:16:41 localhost kernel: [  334.135519] WARNING: at
kernel/exit.c:909 do_exit+0x37/0x621()
Sep 12 16:16:41 localhost kernel: [  334.135520] Hardware name: HP
dx2480 MT(KL969AV)
Sep 12 16:16:41 localhost kernel: [  334.135522] Modules linked in:
vfat fat usb_storage xfs exportfs fuse sunrpc cpufreq_ondemand
acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6
ip6table_filter ip6_tables ipv6 uinput r8169 microcode
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep i2c_i801
snd_seq snd_seq_device snd_pcm snd_timer snd soundcore snd_page_alloc
mii ppdev parport_pc parport iTCO_wdt iTCO_vendor_support pcspkr i915
drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded:
scsi_wait_scan]
Sep 12 16:16:41 localhost kernel: [  334.135551] Pid: 2233, comm:
umount Tainted: G      D     3.0.3 #5
Sep 12 16:16:41 localhost kernel: [  334.135553] Call Trace:
Sep 12 16:16:41 localhost kernel: [  334.135557]  [<c0437f03>]
warn_slowpath_common+0x6a/0x7f
Sep 12 16:16:41 localhost kernel: [  334.135559]  [<c043b016>] ?
do_exit+0x37/0x621
Sep 12 16:16:41 localhost kernel: [  334.135562]  [<c0437f2c>]
warn_slowpath_null+0x14/0x18
Sep 12 16:16:41 localhost kernel: [  334.135564]  [<c043b016>]
do_exit+0x37/0x621
Sep 12 16:16:41 localhost kernel: [  334.135566]  [<c043840d>] ?
kmsg_dump+0x3a/0xb3
Sep 12 16:16:41 localhost kernel: [  334.135569]  [<c07bfd15>]
oops_end+0x9d/0xa5
Sep 12 16:16:41 localhost kernel: [  334.135572]  [<c042155b>]
no_context+0x115/0x11f
Sep 12 16:16:41 localhost kernel: [  334.135575]  [<c0421659>]
__bad_area_nosemaphore+0xf4/0xfc
Sep 12 16:16:41 localhost kernel: [  334.135577]  [<c04216b0>]
bad_area+0x3a/0x40
Sep 12 16:16:41 localhost kernel: [  334.135579]  [<c07c15db>]
do_page_fault+0x227/0x376
Sep 12 16:16:41 localhost kernel: [  334.135582]  [<c07c13b4>] ?
spurious_fault+0xba/0xba
Sep 12 16:16:41 localhost kernel: [  334.135585]  [<c07bf3d7>]
error_code+0x67/0x6c
Sep 12 16:16:41 localhost kernel: [  334.135612]  [<f7b20f73>] ?
xfs_log_force_umount+0x1d/0x1b5 [xfs]
Sep 12 16:16:41 localhost kernel: [  334.135636]  [<f7b32547>] ?
xfs_do_force_shutdown+0x39/0xd6 [xfs]
Sep 12 16:16:41 localhost kernel: [  334.135660]  [<f7b32564>]
xfs_do_force_shutdown+0x56/0xd6 [xfs]
Sep 12 16:16:41 localhost kernel: [  334.135683]  [<f7b2dc7a>]
xfs_trans_ail_delete_bulk+0x83/0xfa [xfs]
Sep 12 16:16:41 localhost kernel: [  334.135706]  [<f7b2364d>] ?
xlog_cil_push+0x2d1/0x2f6 [xfs]
Sep 12 16:16:41 localhost kernel: [  334.135730]  [<f7b35623>] ?
xfs_buf_iodone_work+0x14/0x23 [xfs]
Sep 12 16:16:41 localhost kernel: [  334.135750]  [<f7b09d6f>]
xfs_buf_iodone+0x31/0x3d [xfs]
Sep 12 16:16:41 localhost kernel: [  334.135771]  [<f7b09d1b>]
xfs_buf_do_callbacks+0x24/0x31 [xfs]
Sep 12 16:16:41 localhost kernel: [  334.135791]  [<f7b0a5b7>]
xfs_buf_iodone_callbacks+0x16f/0x1a2 [xfs]
Sep 12 16:16:41 localhost kernel: [  334.135815]  [<f7b35623>]
xfs_buf_iodone_work+0x14/0x23 [xfs]
Sep 12 16:16:41 localhost kernel: [  334.135839]  [<f7b357ec>]
xfs_buf_ioend+0x95/0xa5 [xfs]
Sep 12 16:16:41 localhost kernel: [  334.135862]  [<f7b35954>] ?
xfs_bioerror+0x34/0x3c [xfs]
Sep 12 16:16:41 localhost kernel: [  334.135886]  [<f7b36217>] ?
xfs_flush_buftarg+0x9e/0xe9 [xfs]
Sep 12 16:16:41 localhost kernel: [  334.135910]  [<f7b35954>]
xfs_bioerror+0x34/0x3c [xfs]
Sep 12 16:16:41 localhost kernel: [  334.135933]  [<f7b36169>]
xfs_bdstrat_cb+0x5f/0x6f [xfs]
Sep 12 16:16:41 localhost kernel: [  334.135957]  [<f7b36217>]
xfs_flush_buftarg+0x9e/0xe9 [xfs]
Sep 12 16:16:41 localhost kernel: [  334.135981]  [<f7b36284>]
xfs_free_buftarg+0x22/0x45 [xfs]
Sep 12 16:16:41 localhost kernel: [  334.136000]  [<f7b3c390>]
xfs_close_devices+0x55/0x59 [xfs]
Sep 12 16:16:41 localhost kernel: [  334.136032]  [<f7b3c3e4>]
xfs_fs_put_super+0x50/0x61 [xfs]
Sep 12 16:16:41 localhost kernel: [  334.136036]  [<c04e1432>]
generic_shutdown_super+0x52/0xb0
Sep 12 16:16:41 localhost kernel: [  334.136039]  [<c04e14b2>]
kill_block_super+0x22/0x5e
Sep 12 16:16:41 localhost kernel: [  334.136042]  [<c04e1997>]
deactivate_locked_super+0x1f/0x40
Sep 12 16:16:41 localhost kernel: [  334.136045]  [<c04e21bf>]
deactivate_super+0x37/0x3c
Sep 12 16:16:41 localhost kernel: [  334.136049]  [<c04f40c3>]
mntput_no_expire+0x114/0x11a
Sep 12 16:16:41 localhost kernel: [  334.136052]  [<c04f4a2b>]
sys_umount+0x26e/0x295
Sep 12 16:16:41 localhost kernel: [  334.136055]  [<c04f4a64>]
sys_oldumount+0x12/0x14
Sep 12 16:16:41 localhost kernel: [  334.136059]  [<c07c401f>]
sysenter_do_call+0x12/0x28
Sep 12 16:16:41 localhost kernel: [  334.136061] ---[ end trace
f3af361b30e84115 ]---

Thanks & Regards,
Amit Sahrawat

On Sun, Sep 11, 2011 at 10:16 PM, Amit Sahrawat
<amit.sahrawat83@gmail.com> wrote:
> Yes, the patch is applied and the crash is still appearing easily.
>
> On Sun, Sep 11, 2011 at 12:00 AM, Christoph Hellwig <hch@infradead.org> w=
rote:
>> On Thu, Sep 08, 2011 at 04:35:28PM +0530, Amit Sahrawat wrote:
>>> Kernel Version: 2.6.39.4
>>> Target: ARM
>>>
>>> Observed while doing:
>>> Copy some file (any size, I tried with 10MB, 100MB) to XFS partition
>>> After Copy do???sync???
>>> Now immediately, unplug the device.
>>
>> Does this still happen with the patch below applied?
>>
>>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
