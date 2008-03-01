Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 01 Mar 2008 03:21:15 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m21BKsHC029320
	for <xfs@oss.sgi.com>; Sat, 1 Mar 2008 03:20:55 -0800
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 74D92F02962
	for <xfs@oss.sgi.com>; Sat,  1 Mar 2008 03:21:21 -0800 (PST)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.126.188]) by cuda.sgi.com with ESMTP id Wv0HxmUxjgp6OEQo for <xfs@oss.sgi.com>; Sat, 01 Mar 2008 03:21:21 -0800 (PST)
Message-ID: <47C93C32.40006@mathtm.de>
Date: Sat, 01 Mar 2008 12:21:22 +0100
From: =?ISO-8859-15?Q?Thomas_M=FCller?= <thomas@mathtm.de>
MIME-Version: 1.0
Subject: Kernel oops / XFS filesystem corruption
Content-Type: multipart/mixed;
 boundary="------------080104030007000406030106"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org, =?ISO-8859-15?Q?Thomas_M=FCller?= <thomas@mathtm.de>

This is a multi-part message in MIME format.
--------------080104030007000406030106
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hello :)

My system just crashed because of a power fluctuation and the root
filesystem was damaged.
The system booted up just fine, but when samba tried to start up
the kernel oops'd.

xfs_repair was apparently able to repair the damage, though I seem
to have lost some files.

I do realize that a lot of awful things can happen if you just cut
the power, but the kernel shouldn't oops on a mounted file
system, right?

Please CC me, as I'm not subscribed to the lists.


Regards
Thomas


$ rpm -q xfsprogs
xfsprogs-2.9.4-4.fc8

$ uname -a
Linux linux.local.loc 2.6.23.15-137.fc8 #1 SMP Sun Feb 10 17:48:34 EST 2008 i686 i686 i386 
GNU/Linux

--------------080104030007000406030106
Content-Type: text/plain;
 name="xfs_check"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xfs_check"

block 0/19018 expected type unknown got free2
agi unlinked bucket 6 is 103430 in ag 3 (inode=12686342)
agi unlinked bucket 14 is 91278 in ag 3 (inode=12674190)
agi unlinked bucket 23 is 106135 in ag 3 (inode=12689047)
agi unlinked bucket 31 is 53279 in ag 3 (inode=12636191)
agi unlinked bucket 35 is 106147 in ag 3 (inode=12689059)
agi unlinked bucket 36 is 60836 in ag 3 (inode=12643748)
agi unlinked bucket 39 is 60839 in ag 3 (inode=12643751)
agi unlinked bucket 41 is 378537 in ag 3 (inode=12961449)
agi unlinked bucket 50 is 91250 in ag 3 (inode=12674162)
agi unlinked bucket 20 is 38996 in ag 4 (inode=16816212)
agi unlinked bucket 57 is 95353 in ag 4 (inode=16872569)
agi unlinked bucket 4 is 199940 in ag 8 (inode=33754372)
agi unlinked bucket 8 is 56392 in ag 8 (inode=33610824)
agi unlinked bucket 21 is 177621 in ag 8 (inode=33732053)
agi unlinked bucket 22 is 56406 in ag 8 (inode=33610838)
agi unlinked bucket 23 is 56407 in ag 8 (inode=33610839)
agi unlinked bucket 27 is 54747 in ag 8 (inode=33609179)
agi unlinked bucket 32 is 67232 in ag 8 (inode=33621664)
agi unlinked bucket 37 is 54757 in ag 8 (inode=33609189)
agi unlinked bucket 39 is 67239 in ag 8 (inode=33621671)
agi unlinked bucket 40 is 67240 in ag 8 (inode=33621672)
agi unlinked bucket 47 is 56367 in ag 8 (inode=33610799)
agi unlinked bucket 0 is 34944 in ag 10 (inode=41977984)
agi unlinked bucket 20 is 42516 in ag 11 (inode=46179860)
agi unlinked bucket 15 is 463 in ag 13 (inode=54526415)
agi unlinked bucket 62 is 154430 in ag 13 (inode=54680382)
block 0/21136 type unknown not expected
allocated inode 12689047 has 0 link count
allocated inode 12689059 has 0 link count
allocated inode 12674162 has 0 link count
allocated inode 12674190 has 0 link count
allocated inode 12636191 has 0 link count
allocated inode 12961449 has 0 link count
allocated inode 12643748 has 0 link count
allocated inode 12643751 has 0 link count
allocated inode 12686342 has 0 link count
allocated inode 16816212 has 0 link count
allocated inode 16872569 has 0 link count
allocated inode 33754372 has 0 link count
allocated inode 33732053 has 0 link count
allocated inode 33621664 has 0 link count
allocated inode 33621671 has 0 link count
allocated inode 33621672 has 0 link count
allocated inode 33609179 has 0 link count
allocated inode 33609189 has 0 link count
allocated inode 33610799 has 0 link count
allocated inode 33610824 has 0 link count
allocated inode 33610838 has 0 link count
allocated inode 33610839 has 0 link count
allocated inode 41977984 has 0 link count
allocated inode 46179860 has 0 link count
allocated inode 54680382 has 0 link count
allocated inode 54526415 has 0 link count
sb_ifree 3257, counted 3259
sb_fdblocks 7248513, counted 7248904

--------------080104030007000406030106
Content-Type: text/plain;
 name="xfs_oops"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xfs_oops"

Mar  1 10:32:03 linux kernel: BUG: unable to handle kernel NULL pointer dereference at virtual address 00000002
Mar  1 10:32:03 linux kernel: printing eip: f8a96141 *pde = 38ccb067 
Mar  1 10:32:03 linux kernel: Oops: 0000 [#1] SMP 
Mar  1 10:32:03 linux kernel: Modules linked in: asb100 hwmon_vid hwmon tun sch_sfq sch_htb pppoe pppox ppp_synctty ppp_async crc_ccitt ppp_generic slhc bridge xt_NOTRACK iptable_raw ipt_MASQUERADE iptable_nat nf_nat ipt_REJECT xt_mac ipt_LOG nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink iptable_filter xt_CLASSIFY xt_length ipt_owner xt_TCPMSS xt_comment xt_tcpudp iptable_mangle ip_tables x_tables ext2 mbcache dm_mirror dm_mod 8139too r8169 mii i2c_i801 iTCO_wdt iTCO_vendor_support i2c_core sg sr_mod cdrom ata_generic ata_piix libata sd_mod scsi_mod xfs ehci_hcd
Mar  1 10:32:03 linux kernel: CPU:    0
Mar  1 10:32:03 linux kernel: EIP:    0060:[<f8a96141>]    Not tainted VLI
Mar  1 10:32:03 linux kernel: EFLAGS: 00010292   (2.6.23.15-137.fc8 #1)
Mar  1 10:32:03 linux kernel: EIP is at xfs_attr_shortform_getvalue+0x15/0xdb [xfs]
Mar  1 10:32:03 linux kernel: eax: 00000000   ebx: f268cddc   ecx: f8ae4d9d   edx: 08d26645
Mar  1 10:32:03 linux kernel: esi: f04d1600   edi: 00000004   ebp: f8ae4d91   esp: f268cdbc
Mar  1 10:32:03 linux kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Mar  1 10:32:03 linux kernel: Process smbd (pid: 2036, ti=f268c000 task=f7207840 task.ti=f268c000)
Mar  1 10:32:03 linux kernel: Stack: 00000003 f37888d4 00000003 f04d1600 f04d1600 f268ce38 f8ae4d91 f8a93a97 
Mar  1 10:32:03 linux kernel: f8ae4d91 0000000c c1ba6000 00000130 00000402 275b19c4 00000000 00000000 
Mar  1 10:32:03 linux kernel: f04d1600 00000000 00000000 00000000 00000000 00000001 00000000 00000000 
Mar  1 10:32:03 linux kernel: Call Trace:
Mar  1 10:32:03 linux kernel: [<f8a93a97>] xfs_attr_fetch+0x9e/0xee [xfs]
Mar  1 10:32:03 linux kernel: [<f8a8d843>] xfs_acl_iaccess+0x59/0xc2 [xfs]
Mar  1 10:32:03 linux kernel: [<f8abe3c2>] xfs_iaccess+0x87/0x15c [xfs]
Mar  1 10:32:03 linux kernel: [<f8ad53ec>] xfs_access+0x26/0x3a [xfs]
Mar  1 10:32:03 linux kernel: [<f8ae08ae>] xfs_vn_permission+0x0/0x13 [xfs]
Mar  1 10:32:03 linux kernel: [<f8ae08bd>] xfs_vn_permission+0xf/0x13 [xfs]
Mar  1 10:32:03 linux kernel: [<c0487419>] permission+0x9e/0xdb
Mar  1 10:32:03 linux kernel: [<c04887d0>] may_open+0x5c/0x205
Mar  1 10:32:03 linux kernel: [<c048a8b4>] open_namei+0x27d/0x576
Mar  1 10:32:03 linux kernel: [<c047fdb7>] do_filp_open+0x2a/0x3e
Mar  1 10:32:03 linux kernel: [<c047fafe>] get_unused_fd_flags+0x52/0xc5
Mar  1 10:32:03 linux kernel: [<c047fe13>] do_sys_open+0x48/0xca
Mar  1 10:32:03 linux kernel: [<c047fece>] sys_open+0x1c/0x1e
Mar  1 10:32:03 linux kernel: [<c040518a>] syscall_call+0x7/0xb
Mar  1 10:32:03 linux kernel: =======================
Mar  1 10:32:03 linux kernel: Code: 00 00 c6 40 02 00 66 c7 00 00 04 8b 47 2c 5b 5e 5f e9 08 bc 03 00 55 57 56 53 89 c3 83 ec 0c 8b 40 20 8b 40 4c 8b 40 14 8d 78 04 <0f> b6 40 02 c7 44 24 08 00 00 00 00 89 44 24 04 e9 96 00 00 00 
Mar  1 10:32:03 linux kernel: EIP: [<f8a96141>] xfs_attr_shortform_getvalue+0x15/0xdb [xfs] SS:ESP 0068:f268cdbc

--------------080104030007000406030106--
