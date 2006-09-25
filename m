Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Sep 2006 11:30:18 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8PIUBaG021651
	for <xfs@oss.sgi.com>; Mon, 25 Sep 2006 11:30:12 -0700
Received: from kendy.up.ac.za (kendy.up.ac.za [137.215.101.101])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 24AEE3E99B9
	for <xfs@oss.sgi.com>; Mon, 25 Sep 2006 11:29:31 -0700 (PDT)
Received: from postino.up.ac.za ([137.215.6.15] helo=mx1.up.ac.za)
	by kendy.up.ac.za with esmtp (Exim 4.50)
	id 1GRvCV-0000zl-Qd
	for xfs@oss.sgi.com; Mon, 25 Sep 2006 20:29:07 +0200
Received: from cleopatra.up.ac.za ([137.215.124.210])
	by mx1.up.ac.za with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA:32)
	(Exim 4.50)
	id 1GRvCU-0002dB-O6
	for xfs@oss.sgi.com; Mon, 25 Sep 2006 20:29:07 +0200
Message-ID: <45181FF0.7030105@up.ac.za>
Date: Mon, 25 Sep 2006 20:29:04 +0200
From: Paul Schutte <paul@up.ac.za>
MIME-Version: 1.0
Subject: DMAPI problem on the cvs tree of (2.6.17) SGI-XFS CVS-2006-08-26
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

I am trying to get the DMAPI stuff going on xfs again. I last played
with it back in the 2.4.25 kernel and it worked great.
I now want to resume the work that I started back then, but are unable
to get the dmapi to work on any recent kernel. I tried both 2.4.33 from
the cvs and 2.6.17 from the cvs. (Both checked out on 2006-08-26).

2.4.33 was unable to compile.

make[3]: Entering directory `/mnt/linux-2.4-xfs/fs/dmapi'
gcc -D__KERNEL__ -I/mnt/linux-2.4-xfs/include -Wall -Wstrict-prototypes
-Wno-trigraphs -O2 -fno-strict-aliasing -fno-common -fomit-frame-pointer
-pipe -mpreferred-stack-boundary=2 -march=athlon -fno-unit-at-a-time
-fno-optimize-sibling-calls  -DDEBUG -g -nostdinc -iwithprefix include
-DKBUILD_BASENAME=dmapi_sysent  -DEXPORT_SYMTAB -c dmapi_sysent.c
dmapi_sysent.c:54: error: conflicting types for 'dm_fsreg_cachep'
dmapi_private.h:44: error: previous declaration of 'dm_fsreg_cachep' was
here

The following fixed that:
----------------------------------------------------------------------
--- /usr/src/linux-2.4-xfs/fs/dmapi/dmapi_private.h     2005-12-05
22:35:19.000000000 +0200
+++ linux-2.4-xfs/fs/dmapi/dmapi_private.h      2006-09-25
18:17:56.047674000 +0200
@@ -41,11 +41,11 @@
  #define DMAPI_DBG_PROCFS       "fs/dmapi_d" /* DMAPI debugging dir */
  #endif

-extern struct kmem_cache       *dm_fsreg_cachep;
-extern struct kmem_cache       *dm_tokdata_cachep;
-extern struct kmem_cache       *dm_session_cachep;
-extern struct kmem_cache       *dm_fsys_map_cachep;
-extern struct kmem_cache       *dm_fsys_vptr_cachep;
+extern kmem_cache_t    *dm_fsreg_cachep;
+extern kmem_cache_t    *dm_tokdata_cachep;
+extern kmem_cache_t    *dm_session_cachep;
+extern kmem_cache_t    *dm_fsys_map_cachep;
+extern kmem_cache_t    *dm_fsys_vptr_cachep;

  typedef struct dm_tokdata {
         struct dm_tokdata *td_next;
--------------------------------------------------------------------

Then I had hit:

make[4]: Entering directory `/mnt/linux-2.4-xfs/fs/xfs/dmapi'
gcc -D__KERNEL__ -I/mnt/linux-2.4-xfs/include -Wall -Wstrict-prototypes
-Wno-trigraphs -O2 -fno-strict-aliasing -fno-common -fomit-frame-pointer
-pipe -mpreferred-stack-boundary=2 -march=athlon -fno-unit-at-a-time
-fno-optimize-sibling-calls  -I /mnt/linux-2.4-xfs/fs/xfs -I
/mnt/linux-2.4-xfs/fs/xfs/linux-2.4 -I /mnt/linux-2.4-xfs/fs/dmapi
-nostdinc -iwithprefix include -DKBUILD_BASENAME=xfs_dm  -c -o xfs_dm.o
xfs_dm.c
In file included from /mnt/linux-2.4-xfs/fs/xfs/xfs.h:25,
                  from xfs_dm.c:18:
/mnt/linux-2.4-xfs/fs/xfs/linux-2.4/xfs_linux.h:35:18: warning: extra
tokens at end of #undef directive
xfs_dm.c: In function `xfs_dm_set_fileattr':
xfs_dm.c:2913: error: request for member `tv_sec' in something not a
structure or union
make[4]: *** [xfs_dm.o] Error 1
make[4]: Leaving directory `/mnt/linux-2.4-xfs/fs/xfs/dmapi'
make[3]: *** [first_rule] Error 2
make[3]: Leaving directory `/mnt/linux-2.4-xfs/fs/xfs/dmapi'
make[2]: *** [_subdir_dmapi] Error 2
make[2]: Leaving directory `/mnt/linux-2.4-xfs/fs/xfs'
make[1]: *** [_subdir_xfs] Error 2
make[1]: Leaving directory `/mnt/linux-2.4-xfs/fs'
make: *** [_dir_fs] Error 2

I then did: (which I know is not a proper fix, but I was desperate to
get it to compile and was'nt too concerned about atime problems)

----------------------------------------------------------------------
-------------------- /usr/src/linux-2.4-xfs/fs/xfs/dmapi/xfs_dm.c
  2006-08-26 16:01:18.000000000 +0200
+++ linux-2.4-xfs/fs/xfs/dmapi/xfs_dm.c 2006-09-25 18:29:49.836283000 +0200
@@ -2910,7 +2910,7 @@
                 vat.va_mask |= XFS_AT_ATIME;
                 vat.va_atime.tv_sec = stat.fa_atime;
                 vat.va_atime.tv_nsec = 0;
-                inode->i_atime.tv_sec = stat.fa_atime;
+//                inode->i_atime.tv_sec = stat.fa_atime;
         }
         if (mask & DM_AT_MTIME) {
                 vat.va_mask |= XFS_AT_MTIME;
----------------------------------------------------------------------

It did compile then, but could not mount a filesystem with dmapi.
Unfortunatedly I did'nt save the kernel output.

The 2.6.17 compiled cleanly, but also could not mount.
I got the following dump:


[17179626.228000] kobject xfs: registering. parent: <NULL>, set: module
[17179626.228000] kobject_uevent
[17179626.228000] fill_kobj_path: path = '/module/xfs'
[17179626.244000] SGI-XFS CVS-2006-08-26_07:00_UTC with ACLs, security
attributes, realtime, large block numbers, tracing, debug enabled
[17179626.248000] xfs_dmapi: module license 'unspecified' taints kernel.
[17179626.252000] kobject xfs_dmapi: registering. parent: <NULL>, set:
module
[17179626.252000] kobject_uevent
[17179626.252000] fill_kobj_path: path = '/module/xfs_dmapi'
[17179626.264000] SGI XFS Data Management API subsystem
[17179626.264000] ftype_list/348: Current ftype_list
[17179626.264000] ftype_list/351: FS 0xdc3733c0, ftype 0xe15bc080 xfs
[17179626.264000] ftype_list/353: Done ftype_list
[17179649.888000] Large kmem_alloc attempt, size=6144
[17179649.888000]  <c01040c0> show_trace+0x20/0x30  <c01041de>
dump_stack+0x1e/0x20
[17179649.888000]  <e1572df4> kmem_alloc+0x134/0x140 [xfs]  <e1572e1e>
kmem_zalloc+0x1e/0x50 [xfs]
[17179649.888000]  <e1571fa8> xfs_alloc_bufhash+0x48/0xd0 [xfs]
<e1572473> xfs_alloc_buftarg+0x63/0x90 [xfs]
[17179649.888000]  <e15530cc> xfs_mount+0x24c/0x730 [xfs]  <e156e46b>
vfs_mount+0x9b/0xb0 [xfs]
[17179649.892000]  <e0c78074> xfs_dm_mount+0x74/0x130 [xfs_dmapi]
<e156e46b> vfs_mount+0x9b/0xb0 [xfs]
[17179649.892000]  <e156e20a> xfs_fs_fill_super+0x9a/0x230 [xfs]
<c0168560> get_sb_bdev+0x100/0x170
[17179649.892000]  <e156e3ce> xfs_fs_get_sb+0x2e/0x30 [xfs]  <c01687e6>
do_kern_mount+0x56/0xd0
[17179649.892000]  <c0180db8> do_new_mount+0x58/0xb0  <c018147f>
do_mount+0x19f/0x1d0
[17179649.892000]  <c0181837> sys_mount+0x97/0xe0  <c0103283>
sysenter_past_esp+0x54/0x75
[17179649.892000] Filesystem "md1": Disabling barriers, not supported by
the underlying device
[17179649.912000] XFS mounting filesystem md1
[17179650.028000] Ending clean XFS mount for filesystem: md1
[17179650.028000] ftype_list/348: Current ftype_list
[17179650.028000] ftype_list/351: FS 0xdc3733c0, ftype 0xe15bc080 xfs
[17179650.028000] ftype_list/353: Done ftype_list
[17179650.028000] sb_list/330: Current sb_list
[17179650.028000] sb_list/335: Done sb_list
[17179650.028000] ftype_list/348: Current ftype_list
[17179650.028000] ftype_list/351: FS 0xdc3733c0, ftype 0xe15bc080 xfs
[17179650.028000] ftype_list/353: Done ftype_list
[17179650.028000] DMAPI assertion failed: fstype, file:
fs/dmapi/dmapi_mountinfo.c, line: 280
[17179650.028000] ------------[ cut here ]------------
[17179650.028000] kernel BUG at fs/dmapi/dmapi_port.h:72!
[17179650.028000] invalid opcode: 0000 [#1]
[17179650.028000] PREEMPT
[17179650.028000] Modules linked in: xfs_dmapi xfs tuner saa7134
video_buf compat_ioctl32 v4l2_common v4l1_compat ir_kbd_i2c ir_common
videodev ohci1394 ieee
1394 pdc202xx_new ide_cd cdrom
[17179650.028000] CPU:    0
[17179650.028000] EIP:    0060:[<c019f7c4>]    Tainted: P      VLI
[17179650.028000] EFLAGS: 00010296   (2.6.17-dmapi #1)
[17179650.028000] EIP is at dm_fsys_map_by_fstype+0x64/0x70
[17179650.028000] eax: 00000061   ebx: 00000000   ecx: 00000000   edx:
00000001
[17179650.028000] esi: 00000000   edi: dc368d2c   ebp: dc2ffc9c   esp:
dc2ffc84
[17179650.028000] ds: 007b   es: 007b   ss: 0068
[17179650.028000] Process mount (pid: 2836, threadinfo=dc2fe000
task=df97c0b0)
[17179650.028000] Stack: c0554fb8 c054f4ac c054f488 00000118 dc368d2c
00000000 dc2ffcc8 c019f846
[17179650.028000]        00000000 c019f9ac c054f501 c051e534 00000161
dc3733c0 e15bc080 dc368d2c
[17179650.028000]        00000000 dc2ffcf4 c019faa0 e1574680 dfeef4c4
dc2ffd08 c015ceca c14b0960
[17179650.028000] Call Trace:
[17179650.028000]  <c0104160> show_stack_log_lvl+0x90/0xc0  <c0104383>
show_registers+0x1a3/0x220
[17179650.028000]  <c01045a8> die+0x118/0x240  <c0104757> do_trap+0x87/0xd0
[17179650.028000]  <c0104a35> do_invalid_op+0xb5/0xc0  <c0103d7f>
error_code+0x4f/0x54
[17179650.028000]  <c019f846> sb_list+0x16/0xf0  <c019faa0>
dm_fsys_ops+0x30/0x1e0
[17179650.028000]  <c01a1200> dm_ip_to_handle+0x20/0x100  <c019db99>
dm_ip_data+0xa9/0x110
[17179650.028000]  <c019e142> dm_send_mount_event+0x72/0x430  <e0c7812c>
xfs_dm_mount+0x12c/0x130 [xfs_dmapi]
[17179650.028000]  <e156e46b> vfs_mount+0x9b/0xb0 [xfs]  <e156e20a>
xfs_fs_fill_super+0x9a/0x230 [xfs]
[17179650.028000]  <c0168560> get_sb_bdev+0x100/0x170  <e156e3ce>
xfs_fs_get_sb+0x2e/0x30 [xfs]
[17179650.028000]  <c01687e6> do_kern_mount+0x56/0xd0  <c0180db8>
do_new_mount+0x58/0xb0
[17179650.028000]  <c018147f> do_mount+0x19f/0x1d0  <c0181837>
sys_mount+0x97/0xe0
[17179650.028000]  <c0103283> sysenter_past_esp+0x54/0x75
[17179650.028000] Code: c6 5b 89 f0 5e c9 c3 c7 44 24 0c 18 01 00 00 c7
44 24 08 88 f4 54 c0 c7 44 24 04 ac f4 54 c0 c7 04 24 b8 4f 55 c0 e8 8c
da f7 ff <0f>
  0b 48 00 72 f4 54 c0 eb a3 89 f6 55 89 e5 56 31 f6 53 83 ec
[17179650.028000] EIP: [<c019f7c4>] dm_fsys_map_by_fstype+0x64/0x70
SS:ESP 0068:dc2ffc84
[17179650.028000]  <6>note: mount[2836] exited with preempt_count 1
[17179652.952000] BUG: sleeping function called from invalid context at
include/linux/rwsem.h:43
[17179652.952000] in_atomic():1, irqs_disabled():0
[17179652.952000]  <c01040c0> show_trace+0x20/0x30  <c01041de>
dump_stack+0x1e/0x20
[17179652.952000]  <c01195c1> __might_sleep+0xa1/0xc0  <c011ec0c>
exit_mm+0x3c/0x140
[17179652.952000]  <c011f4ba> do_exit+0xda/0x460  <c01046ca> die+0x23a/0x240
[17179652.952000]  <c0104757> do_trap+0x87/0xd0  <c0104a35>
do_invalid_op+0xb5/0xc0
[17179652.952000]  <c0103d7f> error_code+0x4f/0x54  <c019f846>
sb_list+0x16/0xf0
[17179652.952000]  <c019faa0> dm_fsys_ops+0x30/0x1e0  <c01a1200>
dm_ip_to_handle+0x20/0x100
[17179652.952000]  <c019db99> dm_ip_data+0xa9/0x110  <c019e142>
dm_send_mount_event+0x72/0x430
[17179652.952000]  <e0c7812c> xfs_dm_mount+0x12c/0x130 [xfs_dmapi]
<e156e46b> vfs_mount+0x9b/0xb0 [xfs]
[17179652.952000]  <e156e20a> xfs_fs_fill_super+0x9a/0x230 [xfs]
<c0168560> get_sb_bdev+0x100/0x170
[17179652.952000]  <e156e3ce> xfs_fs_get_sb+0x2e/0x30 [xfs]  <c01687e6>
do_kern_mount+0x56/0xd0
[17179652.956000]  <c0180db8> do_new_mount+0x58/0xb0  <c018147f>
do_mount+0x19f/0x1d0
[17179652.956000]  <c0181837> sys_mount+0x97/0xe0  <c0103283>
sysenter_past_esp+0x54/0x75


I used "mount /dev/md1 -o dmapi,mtpt=/mnt /mnt" to try and mount the
filesystem in all the cases (which worked great back in 2.4.25).


I would appreciate any help.

Regards
Paul Schutte
