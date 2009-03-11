Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2BAh67F003685 for <xfs@oss.sgi.com>; Wed, 11 Mar 2009 05:43:22 -0500
Received: from panacea.ucs.uwa.edu.au (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 61FCC1895EB
	for <xfs@oss.sgi.com>; Wed, 11 Mar 2009 03:42:19 -0700 (PDT)
Received: from panacea.ucs.uwa.edu.au (panacea.ucs.uwa.edu.au
	[130.95.128.132]) by cuda.sgi.com with ESMTP id
	5CzYTz4G5QVJcesG for <xfs@oss.sgi.com>;
	Wed, 11 Mar 2009 03:42:19 -0700 (PDT)
Received: from kas30pipe.localhost (localhost.localdomain [127.0.0.1])
	by panacea.uwa.edu.au (Postfix) with ESMTP id 5F6DE88127
	for <xfs@oss.sgi.com>; Wed, 11 Mar 2009 19:42:17 +0900 (WST)
Received: from panacea (localhost.localdomain [127.0.0.1])
	by panacea.prekas (Postfix) with SMTP id D2AE388111
	for <xfs@oss.sgi.com>; Wed, 11 Mar 2009 19:42:16 +0900 (WST)
Received: from swanee.ee.uwa.edu.au (mailgate.ee.uwa.edu.au [130.95.208.1])
	by panacea.extinput (Postfix) with ESMTP id 8F0ED88127
	for <xfs@oss.sgi.com>; Wed, 11 Mar 2009 19:42:16 +0900 (WST)
Message-ID: <49B79586.5060801@gmail.com>
Date: Wed, 11 Mar 2009 19:42:14 +0900
From: Thomas Gutzler <thomas.gutzler@gmail.com>
MIME-Version: 1.0
Subject: Re: Corruption of in-memory data detected
References: <169670ec0901011846q1d370e6cu31514519afc8295d@mail.gmail.com>	
	<495D88EE.2040406@sandeen.net>
	<169670ec0903101944i2ea05432q7bf9776a347a11a5@mail.gmail.com>
	<49B73E50.5080906@sandeen.net>
In-Reply-To: <49B73E50.5080906@sandeen.net>
Content-Type: multipart/mixed; boundary="------------000302040506060400060204"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------000302040506060400060204
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Eric Sandeen wrote:
> Thomas Gutzler wrote:
>> Hi,
>>
>> a while ago I was having problems with the xfs module on ubuntu
>> feisty. I have then upgraded to 8.10 intrepid and am still getting the
>> occasional bug. 
> 
> although from the looks of it, a different one.  I'm curious, if you log
> these bug with Ubuntu, do they look into it?  It'd be nice to at least
> have initial triage to know for example where in the function it blew up.

I can see myself heading this way.

>> Here's the dmesg output:
>> [1369713.678092] BUG: unable to handle kernel paging request at ffff87f947da5088
>> [1369713.682882] IP: [<ffffffffa01db24f>]
>> xfs_dir2_block_lookup_int+0xcf/0x210 [xfs]
> 
> Ok, so this looks like a different problem; at least a different oops.
> 
>> [1369713.687802] PGD 0
>> [1369713.688055] Oops: 0000 [1] SMP
>> [1369713.688055] CPU 1
>> [1369713.688055] Modules linked in: nls_cp437 cifs nfsd auth_rpcgss
>> exportfs wmi video output sbs sbshc pci
>> _slot container battery ac xt_tcpudp nf_conntrack_ipv4 xt_state
>> nf_conntrack nfs lockd nfs_acl sunrpc ipv6
>> iptable_filter ip_tables x_tables ext3 jbd mbcache cpufreq_userspace
>> cpufreq_stats cpufreq_powersave cpufre
>> q_ondemand cpufreq_conservative acpi_cpufreq freq_table sbp2
>> parport_pc lp parport loop evdev pcspkr iTCO_w
>> dt iTCO_vendor_support button shpchp pci_hotplug intel_agp xfs
>> pata_jmicron sd_mod crc_t10dif sg pata_acpi
>> ata_piix ohci1394 ieee1394 aacraid ata_generic ahci libata scsi_mod
>> e1000e dock uhci_hcd ehci_hcd usbcore t
>> hermal processor fan fuse vesafb fbcon tileblit font bitblit softcursor
>> [1369713.688055] Pid: 5278, comm: smbd Not tainted 2.6.27-11-server #1
>> [1369713.688055] RIP: 0010:[<ffffffffa01db24f>]  [<ffffffffa01db24f>]
>> xfs_dir2_block_lookup_int+0xcf/0x210
>> [xfs]
>> [1369713.688055] RSP: 0018:ffff88007120ba28  EFLAGS: 00010286
>> [1369713.688055] RAX: 00000005a072ded8 RBX: 00000000da072ded RCX:
>> 0000000000000000
>> [1369713.688055] RDX: 00000000b40e5bda RSI: ffff88007a474c48 RDI:
>> ffffffffda072ded
>> [1369713.688055] RBP: ffff88007120ba98 R08: ffff87fa77a0e120 R09:
>> 00000000ffffffff
>> [1369713.688055] R10: 00000000db5b0eb4 R11: ffff88001813bff8 R12:
>> ffff88007120bae8
>> [1369713.688055] R13: 000000000000002a R14: 0000000000000000 R15:
>> ffff88007120bb74
>> [1369713.688055] FS:  00007f79bf44e700(0000) GS:ffff88007f802880(0000)
>> knlGS:0000000000000000
>> [1369713.688055] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> [1369713.688055] CR2: ffff87f947da5088 CR3: 0000000053e88000 CR4:
>> 00000000000006e0
>> [1369713.688055] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
>> 0000000000000000
>> [1369713.688055] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
>> 0000000000000400
>> [1369713.688055] Process smbd (pid: 5278, threadinfo ffff88007120a000,
>> task ffff88000350ace0)
>> [1369713.688055] Stack:  ffff88007120bd68 ffffffff802fa04c
>> ffff88007120bab4 ffff88007120baa8
>> [1369713.688055]  ffff88001813b000 ffff88007acb3000 0000000000000000
>> ffffffffa01d0289
>> [1369713.688055]  ffff88007a474c48 ffff880035a2c8c0 ffff88007120bae8
>> ffff88007120bae8
>> [1369713.688055] Call Trace:
>> [1369713.688055]  [<ffffffff802fa04c>] ? do_select+0x5bc/0x610
>> [1369713.688055]  [<ffffffffa01d0289>] ? xfs_bmbt_get_blockcount+0x9/0x20 [xfs]
>> [1369713.688055]  [<ffffffffa01db470>] xfs_dir2_block_lookup+0x20/0xc0 [xfs]
>> [1369713.688055]  [<ffffffffa01da7e5>] xfs_dir_lookup+0x195/0x1c0 [xfs]
>> [1369713.688055]  [<ffffffffa020a6cb>] xfs_lookup+0x7b/0xe0 [xfs]
>> [1369713.688055]  [<ffffffff802ff9f6>] ? __d_lookup+0x16/0x150
>> [1369713.688055]  [<ffffffffa02159a1>] xfs_vn_lookup+0x51/0x90 [xfs]
>> [1369713.688055]  [<ffffffff802f495e>] real_lookup+0xee/0x170
>> [1369713.688055]  [<ffffffff802f4a90>] do_lookup+0xb0/0x110
>> [1369713.688055]  [<ffffffff802f50fd>] __link_path_walk+0x60d/0xc20
>> [1369713.688055]  [<ffffffff80305ef6>] ? mntput_no_expire+0x36/0x160
>> [1369713.688055]  [<ffffffff802f5c4e>] path_walk+0x6e/0xe0
>> [1369713.688055]  [<ffffffff802f5e63>] do_path_lookup+0xe3/0x200
>> [1369713.688055]  [<ffffffff802f386a>] ? getname+0x4a/0xb0
>> [1369713.688055]  [<ffffffff802f6cbb>] user_path_at+0x7b/0xb0
>> [1369713.688055]  [<ffffffff802eda68>] ? cp_new_stat+0xe8/0x100
>> [1369713.688055]  [<ffffffff802ede7d>] vfs_stat_fd+0x2d/0x60
>> [1369713.688055]  [<ffffffff802edf5c>] sys_newstat+0x2c/0x50
>> [1369713.688055]  [<ffffffff8021285a>] system_call_fastpath+0x16/0x1b
>> [1369713.688055]
>> [1369713.688055]
>> [1369713.688055] Code: f8 31 c9 45 8b 13 4d 89 d8 44 89 d2 0f ca 89 d0
>> 83 ea 01 48 c1 e0 03 49 29 c0 eb 07 8d 4b 01 39 ca 7c 1c 8d 1c 11 d1
>> fb 48 63 fb <41> 8b 04 f8 0f c8 41 39 c5 74 26 77 e4 8d 53 ff 39 ca 7d
>> e4 48
>> [1369713.688055] RIP  [<ffffffffa01db24f>]
>> xfs_dir2_block_lookup_int+0xcf/0x210 [xfs]
>> [1369713.688055]  RSP <ffff88007120ba28>
>> [1369713.688055] CR2: ffff87f947da5088
>> [1369714.057232] ---[ end trace 0735c8702d5e7899 ]---
>>
>> What can I do to help getting this fixed?
>>
> can you make an xfs_metadump of the filesystem in question, and then try
> an xfs_repair?  Capture/save the repair output.  If repair finds errors,
> then perhaps the bug is triggered by bad error checking on a corrupted
> image, and we might reproduce it w/ the metadump image.

I tried...

root@io:~# xfs_metadump /dev/sda xfs_metadump_sda
*** glibc detected *** xfs_db: double free or corruption (out):
0x00000000017b8000 ***
======= Backtrace: =========
/lib/libc.so.6[0x7f4f10298a58]
/lib/libc.so.6(cfree+0x76)[0x7f4f1029b0a6]
xfs_db[0x416f53]
xfs_db[0x4189b9]
xfs_db[0x41b4db]
xfs_db[0x4186f5]
xfs_db[0x41b07e]
xfs_db[0x4186f5]
xfs_db[0x41aa4b]
xfs_db[0x415d03]
/lib/libc.so.6(__libc_start_main+0xe6)[0x7f4f1023d466]
xfs_db[0x4029d9]
======= Memory map: ========
00400000-00477000 r-xp 00000000 08:17 100768239
 /usr/sbin/xfs_db
00676000-00678000 rw-p 00076000 08:17 100768239
 /usr/sbin/xfs_db
00678000-00683000 rw-p 00678000 00:00 0
0176a000-017cc000 rw-p 0176a000 00:00 0
 [heap]
7f4f08000000-7f4f08021000 rw-p 7f4f08000000 00:00 0
7f4f08021000-7f4f0c000000 ---p 7f4f08021000 00:00 0
7f4f0fbc8000-7f4f0fbde000 r-xp 00000000 08:15 50382939
 /lib/libgcc_s.so.1
7f4f0fbde000-7f4f0fdde000 ---p 00016000 08:15 50382939
 /lib/libgcc_s.so.1
7f4f0fdde000-7f4f0fddf000 r--p 00016000 08:15 50382939
 /lib/libgcc_s.so.1
7f4f0fddf000-7f4f0fde0000 rw-p 00017000 08:15 50382939
 /lib/libgcc_s.so.1
7f4f0fde0000-7f4f0fde2000 r-xp 00000000 08:15 50712055
 /lib/libdl-2.8.90.so
7f4f0fde2000-7f4f0ffe2000 ---p 00002000 08:15 50712055
 /lib/libdl-2.8.90.so
7f4f0ffe2000-7f4f0ffe3000 r--p 00002000 08:15 50712055
 /lib/libdl-2.8.90.so
7f4f0ffe3000-7f4f0ffe4000 rw-p 00003000 08:15 50712055
 /lib/libdl-2.8.90.so
7f4f0ffe4000-7f4f1001b000 r-xp 00000000 08:15 50331947
 /lib/libncurses.so.5.6
7f4f1001b000-7f4f1021a000 ---p 00037000 08:15 50331947
 /lib/libncurses.so.5.6
7f4f1021a000-7f4f1021f000 rw-p 00036000 08:15 50331947
 /lib/libncurses.so.5.6
7f4f1021f000-7f4f10388000 r-xp 00000000 08:15 50712052
 /lib/libc-2.8.90.so
7f4f10388000-7f4f10587000 ---p 00169000 08:15 50712052
 /lib/libc-2.8.90.so
7f4f10587000-7f4f1058b000 r--p 00168000 08:15 50712052
 /lib/libc-2.8.90.so
7f4f1058b000-7f4f1058c000 rw-p 0016c000 08:15 50712052
 /lib/libc-2.8.90.so
7f4f1058c000-7f4f10591000 rw-p 7f4f1058c000 00:00 0
7f4f10591000-7f4f105c8000 r-xp 00000000 08:15 50363305
 /lib/libreadline.so.5.2
7f4f105c8000-7f4f107c8000 ---p 00037000 08:15 50363305
 /lib/libreadline.so.5.2
7f4f107c8000-7f4f107d0000 rw-p 00037000 08:15 50363305
 /lib/libreadline.so.5.2
7f4f107d0000-7f4f107d1000 rw-p 7f4f107d0000 00:00 0
7f4f107d1000-7f4f107e8000 r-xp 00000000 08:15 50630786
 /lib/libpthread-2.8.90.so
7f4f107e8000-7f4f109e7000 ---p 00017000 08:15 50630786
 /lib/libpthread-2.8.90.so
7f4f109e7000-7f4f109e8000 r--p 00016000 08:15 50630786
 /lib/libpthread-2.8.90.so
7f4f109e8000-7f4f109e9000 rw-p 00017000 08:15 50630786
 /lib/libpthread-2.8.90.so
7f4f109e9000-7f4f109ed000 rw-p 7f4f109e9000 00:00 0
7f4f109ed000-7f4f109f5000 r-xp 00000000 08:15 50630788
 /lib/librt-2.8.90.so
7f4f109f5000-7f4f10bf4000 ---p 00008000 08:15 50630788
 /lib/librt-2.8.90.so
7f4f10bf4000-7f4f10bf5000 r--p 00007000 08:15 50630788
 /lib/librt-2.8.90.so
7f4f10bf5000-7f4f10bf6000 rw-p 00008000 08:15 50630788
 /lib/librt-2.8.90.so
7f4f10bf6000-7f4f10bf9000 r-xp 00000000 08:15 50331815
 /lib/libuuid.so.1.2
7f4f10bf9000-7f4f10df9000 ---p 00003000 08:15 50331815
 /lib/libuuid.so.1.2
7f4f10df9000-7f4f10dfa000 r--p 00003000 08:15 50331815
 /lib/libuuid.so.1.2
7f4f10dfa000-7f4f10dfb000 rw-p 00004000 08:15 50331815
 /lib/libuuid.so.1.2
7f4f10dfb000-7f4f10e1a000 r-xp 00000000 08:15 50712049
 /lib/ld-2.8.90.so
7f4f10fcc000-7f4f11011000 rw-p 7f4f10fcc000 00:00 0
7f4f11015000-7f4f11019000 rw-p 7f4f11015000 00:00 0
7f4f11019000-7f4f1101a000 r--p 0001e000 08:15 50712049
 /lib/ld-2.8.90.so
7f4f1101a000-7f4f1101b000 rw-p 0001f000 08:15 50712049
 /lib/ld-2.8.90.so
7fff19006000-7fff1901b000 rw-p 7ffffffea000 00:00 0
 [stack]
7fff191ff000-7fff19200000 r-xp 7fff191ff000 00:00 0
 [vdso]
ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0
 [vsyscall]
Aborted

and tried again:
root@io:~# xfs_metadump -w /dev/sda xfs_metadump_sda
root@io:~# ll xfs_metadump_sda
-rw-r--r-- 1 root root 588407296 2009-03-11 19:09 xfs_metadump_sda
(where do I upload this to?)

xfs_repair fixed "bad names" of 4 inodes (see attached log file)

another xfs_metadump /dev/sda xfs_metadump_sda_2 (without -w):
-rw-r--r--  1 root root 588261888 2009-03-11 19:23 xfs_metadump_sda_2

> It'd be nice if ubuntu had debug kernel variants (Fedora does this, I
> dunno about ubuntu) - if you are hitting any kind of memory corruption
> then a kernel with debug checks enabled might catch it sooner.

I haven't seen any - probably have to build my own debug kernel. Oh joy.

Is the metadump of any use?

Tom

--------------000302040506060400060204
Content-Type: text/plain;
 name="xfs_repair.log"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="xfs_repair.log"

U2NyaXB0IHN0YXJ0ZWQgb24gV2VkIDExIE1hciAyMDA5IDE5OjEyOjMxIFdTVApyb290QGlv
On4jIHhmc19yZXBhaXIgLXYgL2Rldi9zZGEgDQpQaGFzZSAxIC0gZmluZCBhbmQgdmVyaWZ5
IHN1cGVyYmxvY2suLi4NCiAgICAgICAgLSBibG9jayBjYWNoZSBzaXplIHNldCB0byAxMjYz
NDQgZW50cmllcw0KUGhhc2UgMiAtIHVzaW5nIGludGVybmFsIGxvZw0KICAgICAgICAtIHpl
cm8gbG9nLi4uDQp6ZXJvX2xvZzogaGVhZCBibG9jayA5NTQ0NyB0YWlsIGJsb2NrIDk1NDQ3
DQogICAgICAgIC0gc2NhbiBmaWxlc3lzdGVtIGZyZWVzcGFjZSBhbmQgaW5vZGUgbWFwcy4u
Lg0KICAgICAgICAtIGZvdW5kIHJvb3QgaW5vZGUgY2h1bmsNClBoYXNlIDMgLSBmb3IgZWFj
aCBBRy4uLg0KICAgICAgICAtIHNjYW4gYW5kIGNsZWFyIGFnaSB1bmxpbmtlZCBsaXN0cy4u
Lg0KICAgICAgICAtIHByb2Nlc3Mga25vd24gaW5vZGVzIGFuZCBwZXJmb3JtIGlub2RlIGRp
c2NvdmVyeS4uLg0KICAgICAgICAtIGFnbm8gPSAwDQogICAgICAgIC0gYWdubyA9IDENCmF0
dHJpYnV0ZSBlbnRyeSAwIGluIGF0dHIgYmxvY2sgMCwgaW5vZGUgNTM2OTI4ODk2IGhhcyBi
YWQgbmFtZSAobmFtZWxlbiA9IDApDQpwcm9ibGVtIHdpdGggYXR0cmlidXRlIGNvbnRlbnRz
IGluIGlub2RlIDUzNjkyODg5Ng0KY2xlYXJpbmcgaW5vZGUgNTM2OTI4ODk2IGF0dHJpYnV0
ZXMNCmNvcnJlY3RpbmcgbmJsb2NrcyBmb3IgaW5vZGUgNTM2OTI4ODk2LCB3YXMgMSAtIGNv
dW50ZWQgMA0KYXR0cmlidXRlIGVudHJ5IDAgaW4gYXR0ciBibG9jayAwLCBpbm9kZSA1Mzgw
OTU5MjAgaGFzIGJhZCBuYW1lIChuYW1lbGVuID0gMCkNCnByb2JsZW0gd2l0aCBhdHRyaWJ1
dGUgY29udGVudHMgaW4gaW5vZGUgNTM4MDk1OTIwDQpjbGVhcmluZyBpbm9kZSA1MzgwOTU5
MjAgYXR0cmlidXRlcw0KY29ycmVjdGluZyBuYmxvY2tzIGZvciBpbm9kZSA1MzgwOTU5MjAs
IHdhcyAxIC0gY291bnRlZCAwDQogICAgICAgIC0gYWdubyA9IDINCmF0dHJpYnV0ZSBlbnRy
eSAwIGluIGF0dHIgYmxvY2sgMCwgaW5vZGUgMTA3NTAzNTcwOSBoYXMgYmFkIG5hbWUgKG5h
bWVsZW4gPSAwKQ0KcHJvYmxlbSB3aXRoIGF0dHJpYnV0ZSBjb250ZW50cyBpbiBpbm9kZSAx
MDc1MDM1NzA5DQpjbGVhcmluZyBpbm9kZSAxMDc1MDM1NzA5IGF0dHJpYnV0ZXMNCmNvcnJl
Y3RpbmcgbmJsb2NrcyBmb3IgaW5vZGUgMTA3NTAzNTcwOSwgd2FzIDEgLSBjb3VudGVkIDAN
CiAgICAgICAgLSBhZ25vID0gMw0KICAgICAgICAtIGFnbm8gPSA0DQogICAgICAgIC0gYWdu
byA9IDUNCmF0dHJpYnV0ZSBlbnRyeSAwIGluIGF0dHIgYmxvY2sgMCwgaW5vZGUgMjY4NDM3
MTcxNSBoYXMgYmFkIG5hbWUgKG5hbWVsZW4gPSAwKQ0KcHJvYmxlbSB3aXRoIGF0dHJpYnV0
ZSBjb250ZW50cyBpbiBpbm9kZSAyNjg0MzcxNzE1DQpjbGVhcmluZyBpbm9kZSAyNjg0Mzcx
NzE1IGF0dHJpYnV0ZXMNCmNvcnJlY3RpbmcgbmJsb2NrcyBmb3IgaW5vZGUgMjY4NDM3MTcx
NSwgd2FzIDEgLSBjb3VudGVkIDANCiAgICAgICAgLSBhZ25vID0gNg0KICAgICAgICAtIGFn
bm8gPSA3DQogICAgICAgIC0gYWdubyA9IDgNCiAgICAgICAgLSBhZ25vID0gOQ0KICAgICAg
ICAtIGFnbm8gPSAxMA0KICAgICAgICAtIGFnbm8gPSAxMQ0KICAgICAgICAtIGFnbm8gPSAx
Mg0KICAgICAgICAtIGFnbm8gPSAxMw0KICAgICAgICAtIGFnbm8gPSAxNA0KICAgICAgICAt
IGFnbm8gPSAxNQ0KICAgICAgICAtIGFnbm8gPSAxNg0KICAgICAgICAtIGFnbm8gPSAxNw0K
ICAgICAgICAtIGFnbm8gPSAxOA0KICAgICAgICAtIGFnbm8gPSAxOQ0KICAgICAgICAtIGFn
bm8gPSAyMA0KICAgICAgICAtIGFnbm8gPSAyMQ0KICAgICAgICAtIGFnbm8gPSAyMg0KICAg
ICAgICAtIGFnbm8gPSAyMw0KICAgICAgICAtIGFnbm8gPSAyNA0KICAgICAgICAtIGFnbm8g
PSAyNQ0KICAgICAgICAtIGFnbm8gPSAyNg0KICAgICAgICAtIGFnbm8gPSAyNw0KICAgICAg
ICAtIGFnbm8gPSAyOA0KICAgICAgICAtIGFnbm8gPSAyOQ0KICAgICAgICAtIGFnbm8gPSAz
MA0KICAgICAgICAtIGFnbm8gPSAzMQ0KICAgICAgICAtIGFnbm8gPSAzMg0KICAgICAgICAt
IGFnbm8gPSAzMw0KICAgICAgICAtIGFnbm8gPSAzNA0KICAgICAgICAtIGFnbm8gPSAzNQ0K
ICAgICAgICAtIGFnbm8gPSAzNg0KICAgICAgICAtIHByb2Nlc3MgbmV3bHkgZGlzY292ZXJl
ZCBpbm9kZXMuLi4NClBoYXNlIDQgLSBjaGVjayBmb3IgZHVwbGljYXRlIGJsb2Nrcy4uLg0K
ICAgICAgICAtIHNldHRpbmcgdXAgZHVwbGljYXRlIGV4dGVudCBsaXN0Li4uDQogICAgICAg
IC0gY2hlY2sgZm9yIGlub2RlcyBjbGFpbWluZyBkdXBsaWNhdGUgYmxvY2tzLi4uDQogICAg
ICAgIC0gYWdubyA9IDANCiAgICAgICAgLSBhZ25vID0gMQ0KYmFkIGF0dHJpYnV0ZSBmb3Jt
YXQgMSBpbiBpbm9kZSA1MzY5Mjg4OTYsIHJlc2V0dGluZyB2YWx1ZQ0KYmFkIGF0dHJpYnV0
ZSBmb3JtYXQgMSBpbiBpbm9kZSA1MzgwOTU5MjAsIHJlc2V0dGluZyB2YWx1ZQ0KICAgICAg
ICAtIGFnbm8gPSAyDQogICAgICAgIC0gYWdubyA9IDMNCmJhZCBhdHRyaWJ1dGUgZm9ybWF0
IDEgaW4gaW5vZGUgMTA3NTAzNTcwOSwgcmVzZXR0aW5nIHZhbHVlDQogICAgICAgIC0gYWdu
byA9IDQNCiAgICAgICAgLSBhZ25vID0gNQ0KYmFkIGF0dHJpYnV0ZSBmb3JtYXQgMSBpbiBp
bm9kZSAyNjg0MzcxNzE1LCByZXNldHRpbmcgdmFsdWUNCiAgICAgICAgLSBhZ25vID0gNg0K
ICAgICAgICAtIGFnbm8gPSA3DQogICAgICAgIC0gYWdubyA9IDgNCiAgICAgICAgLSBhZ25v
ID0gOQ0KICAgICAgICAtIGFnbm8gPSAxMA0KICAgICAgICAtIGFnbm8gPSAxMQ0KICAgICAg
ICAtIGFnbm8gPSAxMg0KICAgICAgICAtIGFnbm8gPSAxMw0KICAgICAgICAtIGFnbm8gPSAx
NA0KICAgICAgICAtIGFnbm8gPSAxNQ0KICAgICAgICAtIGFnbm8gPSAxNg0KICAgICAgICAt
IGFnbm8gPSAxNw0KICAgICAgICAtIGFnbm8gPSAxOA0KICAgICAgICAtIGFnbm8gPSAxOQ0K
ICAgICAgICAtIGFnbm8gPSAyMA0KICAgICAgICAtIGFnbm8gPSAyMQ0KICAgICAgICAtIGFn
bm8gPSAyMg0KICAgICAgICAtIGFnbm8gPSAyMw0KICAgICAgICAtIGFnbm8gPSAyNA0KICAg
ICAgICAtIGFnbm8gPSAyNQ0KICAgICAgICAtIGFnbm8gPSAyNg0KICAgICAgICAtIGFnbm8g
PSAyNw0KICAgICAgICAtIGFnbm8gPSAyOA0KICAgICAgICAtIGFnbm8gPSAyOQ0KICAgICAg
ICAtIGFnbm8gPSAzMA0KICAgICAgICAtIGFnbm8gPSAzMQ0KICAgICAgICAtIGFnbm8gPSAz
Mg0KICAgICAgICAtIGFnbm8gPSAzMw0KICAgICAgICAtIGFnbm8gPSAzNA0KICAgICAgICAt
IGFnbm8gPSAzNQ0KICAgICAgICAtIGFnbm8gPSAzNg0KUGhhc2UgNSAtIHJlYnVpbGQgQUcg
aGVhZGVycyBhbmQgdHJlZXMuLi4NCiAgICAgICAgLSBhZ25vID0gMA0KICAgICAgICAtIGFn
bm8gPSAxDQogICAgICAgIC0gYWdubyA9IDINCiAgICAgICAgLSBhZ25vID0gMw0KICAgICAg
ICAtIGFnbm8gPSA0DQogICAgICAgIC0gYWdubyA9IDUNCiAgICAgICAgLSBhZ25vID0gNg0K
ICAgICAgICAtIGFnbm8gPSA3DQogICAgICAgIC0gYWdubyA9IDgNCiAgICAgICAgLSBhZ25v
ID0gOQ0KICAgICAgICAtIGFnbm8gPSAxMA0KICAgICAgICAtIGFnbm8gPSAxMQ0KICAgICAg
ICAtIGFnbm8gPSAxMg0KICAgICAgICAtIGFnbm8gPSAxMw0KICAgICAgICAtIGFnbm8gPSAx
NA0KICAgICAgICAtIGFnbm8gPSAxNQ0KICAgICAgICAtIGFnbm8gPSAxNg0KICAgICAgICAt
IGFnbm8gPSAxNw0KICAgICAgICAtIGFnbm8gPSAxOA0KICAgICAgICAtIGFnbm8gPSAxOQ0K
ICAgICAgICAtIGFnbm8gPSAyMA0KICAgICAgICAtIGFnbm8gPSAyMQ0KICAgICAgICAtIGFn
bm8gPSAyMg0KICAgICAgICAtIGFnbm8gPSAyMw0KICAgICAgICAtIGFnbm8gPSAyNA0KICAg
ICAgICAtIGFnbm8gPSAyNQ0KICAgICAgICAtIGFnbm8gPSAyNg0KICAgICAgICAtIGFnbm8g
PSAyNw0KICAgICAgICAtIGFnbm8gPSAyOA0KICAgICAgICAtIGFnbm8gPSAyOQ0KICAgICAg
ICAtIGFnbm8gPSAzMA0KICAgICAgICAtIGFnbm8gPSAzMQ0KICAgICAgICAtIGFnbm8gPSAz
Mg0KICAgICAgICAtIGFnbm8gPSAzMw0KICAgICAgICAtIGFnbm8gPSAzNA0KICAgICAgICAt
IGFnbm8gPSAzNQ0KICAgICAgICAtIGFnbm8gPSAzNg0KICAgICAgICAtIHJlc2V0IHN1cGVy
YmxvY2suLi4NClBoYXNlIDYgLSBjaGVjayBpbm9kZSBjb25uZWN0aXZpdHkuLi4NCiAgICAg
ICAgLSByZXNldHRpbmcgY29udGVudHMgb2YgcmVhbHRpbWUgYml0bWFwIGFuZCBzdW1tYXJ5
IGlub2Rlcw0KICAgICAgICAtIHRyYXZlcnNpbmcgZmlsZXN5c3RlbSAuLi4NCiAgICAgICAg
LSBhZ25vID0gMA0KICAgICAgICAtIGFnbm8gPSAxDQogICAgICAgIC0gYWdubyA9IDINCiAg
ICAgICAgLSBhZ25vID0gMw0KICAgICAgICAtIGFnbm8gPSA0DQogICAgICAgIC0gYWdubyA9
IDUNCiAgICAgICAgLSBhZ25vID0gNg0KICAgICAgICAtIGFnbm8gPSA3DQogICAgICAgIC0g
YWdubyA9IDgNCiAgICAgICAgLSBhZ25vID0gOQ0KICAgICAgICAtIGFnbm8gPSAxMA0KICAg
ICAgICAtIGFnbm8gPSAxMQ0KICAgICAgICAtIGFnbm8gPSAxMg0KICAgICAgICAtIGFnbm8g
PSAxMw0KICAgICAgICAtIGFnbm8gPSAxNA0KICAgICAgICAtIGFnbm8gPSAxNQ0KICAgICAg
ICAtIGFnbm8gPSAxNg0KICAgICAgICAtIGFnbm8gPSAxNw0KICAgICAgICAtIGFnbm8gPSAx
OA0KICAgICAgICAtIGFnbm8gPSAxOQ0KICAgICAgICAtIGFnbm8gPSAyMA0KICAgICAgICAt
IGFnbm8gPSAyMQ0KICAgICAgICAtIGFnbm8gPSAyMg0KICAgICAgICAtIGFnbm8gPSAyMw0K
ICAgICAgICAtIGFnbm8gPSAyNA0KICAgICAgICAtIGFnbm8gPSAyNQ0KICAgICAgICAtIGFn
bm8gPSAyNg0KICAgICAgICAtIGFnbm8gPSAyNw0KICAgICAgICAtIGFnbm8gPSAyOA0KICAg
ICAgICAtIGFnbm8gPSAyOQ0KICAgICAgICAtIGFnbm8gPSAzMA0KICAgICAgICAtIGFnbm8g
PSAzMQ0KICAgICAgICAtIGFnbm8gPSAzMg0KICAgICAgICAtIGFnbm8gPSAzMw0KICAgICAg
ICAtIGFnbm8gPSAzNA0KICAgICAgICAtIGFnbm8gPSAzNQ0KICAgICAgICAtIGFnbm8gPSAz
Ng0KICAgICAgICAtIHRyYXZlcnNhbCBmaW5pc2hlZCAuLi4NCiAgICAgICAgLSBtb3Zpbmcg
ZGlzY29ubmVjdGVkIGlub2RlcyB0byBsb3N0K2ZvdW5kIC4uLg0KUGhhc2UgNyAtIHZlcmlm
eSBhbmQgY29ycmVjdCBsaW5rIGNvdW50cy4uLg0KcmVzZXR0aW5nIGlub2RlIDE1NTg0IG5s
aW5rcyBmcm9tIDIgdG8gNw0KDQogICAgICAgIFhGU19SRVBBSVIgU3VtbWFyeSAgICBXZWQg
TWFyIDExIDE5OjE0OjUxIDIwMDkNCg0KUGhhc2UJCVN0YXJ0CQlFbmQJCUR1cmF0aW9uDQpQ
aGFzZSAxOgkwMy8xMSAxOToxNDoxMwkwMy8xMSAxOToxNDoxMwkNClBoYXNlIDI6CTAzLzEx
IDE5OjE0OjEzCTAzLzExIDE5OjE0OjE3CTQgc2Vjb25kcw0KUGhhc2UgMzoJMDMvMTEgMTk6
MTQ6MTcJMDMvMTEgMTk6MTQ6NDYJMjkgc2Vjb25kcw0KUGhhc2UgNDoJMDMvMTEgMTk6MTQ6
NDYJMDMvMTEgMTk6MTQ6NDgJMiBzZWNvbmRzDQpQaGFzZSA1OgkwMy8xMSAxOToxNDo0OAkw
My8xMSAxOToxNDo0OAkNClBoYXNlIDY6CTAzLzExIDE5OjE0OjQ4CTAzLzExIDE5OjE0OjUw
CTIgc2Vjb25kcw0KUGhhc2UgNzoJMDMvMTEgMTk6MTQ6NTAJMDMvMTEgMTk6MTQ6NTAJDQoN
ClRvdGFsIHJ1biB0aW1lOiAzNyBzZWNvbmRzDQpkb25lDQpyb290QGlvOn4jIGV4aXQNCgpT
Y3JpcHQgZG9uZSBvbiBXZWQgMTEgTWFyIDIwMDkgMTk6MTU6MzMgV1NUCg==
--------------000302040506060400060204
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------000302040506060400060204--
