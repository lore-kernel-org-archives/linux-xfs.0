Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 24DF17F58
	for <xfs@oss.sgi.com>; Sat, 20 Jun 2015 07:16:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 134538F8033
	for <xfs@oss.sgi.com>; Sat, 20 Jun 2015 05:16:54 -0700 (PDT)
Received: from mail.vlasiu.net (mail.vlasiu.net [91.223.50.125]) by
	cuda.sgi.com with ESMTP id KQy5tFJIAe94VWw0 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 20 Jun 2015 05:16:49 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by mail.vlasiu.net (Postfix) with ESMTP id B03D7A01DA
	for <xfs@oss.sgi.com>; Sat, 20 Jun 2015 15:16:47 +0300 (EEST)
Received: from mail.vlasiu.net ([127.0.0.1])
	by localhost (mail.vlasiu.net [127.0.0.1]) (amavisd-new, port 10026)
	with LMTP id M9I3BJ4BLXQ6 for <xfs@oss.sgi.com>;
	Sat, 20 Jun 2015 15:16:41 +0300 (EEST)
Received: from localhost (localhost [127.0.0.1])
	by mail.vlasiu.net (Postfix) with ESMTP id 65CCBA01DA
	for <xfs@oss.sgi.com>; Sat, 20 Jun 2015 15:16:40 +0300 (EEST)
Date: Sat, 20 Jun 2015 15:16:26 +0300 (EEST)
From: Gabriel VLASIU <gabriel@vlasiu.net>
Subject: xfs_repair and xfs filesystem strange behaviour
Message-ID: <alpine.LRH.2.11.1506201447380.21027@mail.vlasiu.net>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-547652302-1377685718-1434802600=:21291"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---547652302-1377685718-1434802600=:21291
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Hi.

After a power failure I had a couple of hours ago, I run xfs_repair to=20
check if everything is fine with our filesystem.

umount /target
xfs_repair /dev/xxx

Unfortunately, I xfs_repair found some errors, saved some lost files save=
d=20
in lost+found directory and exit successfully. I re-run xfs_repair and=20
everything was fine.

This is the output of first instance of xfs_repair:

Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
agi unlinked bucket 19 is 1334291 in ag 1 (inode=3D1075076115)
agi unlinked bucket 41 is 1334313 in ag 1 (inode=3D1075076137)
agi unlinked bucket 49 is 1334321 in ag 1 (inode=3D1075076145)
agi unlinked bucket 59 is 442363 in ag 1 (inode=3D1074184187)
agi unlinked bucket 54 is 166036854 in ag 3 (inode=3D3387262326)
agi unlinked bucket 55 is 166036855 in ag 3 (inode=3D3387262327)
agi unlinked bucket 1 is 2656257 in ag 2 (inode=3D2150139905)
agi unlinked bucket 2 is 2656258 in ag 2 (inode=3D2150139906)
agi unlinked bucket 6 is 2656070 in ag 2 (inode=3D2150139718)
agi unlinked bucket 11 is 1994635 in ag 2 (inode=3D2149478283)
agi unlinked bucket 62 is 2656126 in ag 2 (inode=3D2150139774)
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno =3D 0
        - agno =3D 1
        - agno =3D 2
        - agno =3D 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno =3D 0
        - agno =3D 1
        - agno =3D 2
        - agno =3D 3
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
disconnected inode 1074184187, moving to lost+found
disconnected inode 1075076115, moving to lost+found
disconnected inode 1075076137, moving to lost+found
disconnected inode 1075076145, moving to lost+found
disconnected inode 2149478283, moving to lost+found
disconnected inode 2150139718, moving to lost+found
disconnected inode 2150139774, moving to lost+found
disconnected inode 2150139905, moving to lost+found
disconnected inode 2150139906, moving to lost+found
disconnected inode 3387262326, moving to lost+found
disconnected inode 3387262327, moving to lost+found
Phase 7 - verify and correct link counts...
done

Since all files where 0 bytes in size:
# ls -l lost+found/
total 0
- -rw-------. 1 1000 1000 0 Jun 10 20:57 1074184187
- -rw-------. 1 1000 1000 0 Jun 10 20:58 1075076115
- -rw-------. 1 1000 1000 0 Jun 10 20:57 1075076137
- -rw-------. 1 1000 1000 0 Jun 10 20:58 1075076145
- -rw-r--r--. 1 1000 1000 0 Jun 10 20:59 2149478283
- -rw-r--r--. 1 1000 1000 0 Jun 10 20:59 2150139718
- -rw-r--r--. 1 1000 1000 0 Jun 10 20:59 2150139774
- -rw-r--r--. 1 1000 1000 0 Jun 10 20:59 2150139905
- -rw-r--r--. 1 1000 1000 0 Jun 10 20:59 2150139906
- -rw-r--r--. 1 1000 1000 0 Jun 10 20:57 3387262326
- -rw-r--r--. 1 1000 1000 0 Jun 10 20:58 3387262327

I tried to remove them but I got this errors on terminal:
[root@xxxxxxx lost+found]# rm -fv *
[11176.880224] XFS (loop0): xfs_dabuf_map: bno 0 dir: inode 1074184187
[11176.880786] XFS (loop0): [00] br_startoff 0 br_startblock -2 br_blockc=
ount 1
br_state 0
[11176.881878] XFS (loop0): Internal error xfs_da_do_buf(1) at line 2515 =
of file fs/xfs/libxfs/xfs_da_btree.c.  Caller xfs_da_read_buf+0x64/0x100 =
[xfs]
removed =A11074184187'
[11176.885041] XFS (loop0): xfs_dabuf_map: bno 0 dir: inode 1075076115
[11176.885635] XFS (loop0): [00] br_startoff 0 br_startblock -2 br_blockc=
ount 1
br_state 0
[11176.886677] XFS (loop0): Internal error xfs_da_do_buf(1) at line 2515 =
of file fs/xfs/libxfs/xfs_da_btree.c.  Caller xfs_da_read_buf+0x64/0x100 =
[xfs]
removed =A11075076115'
[11176.928470] XFS (loop0): xfs_dabuf_map: bno 0 dir: inode 1075076137
[11176.929063] XFS (loop0): [00] br_startoff 0 br_startblock -2 br_blockc=
ount 1
br_state 0
[11176.930103] XFS (loop0): Internal error xfs_da_do_buf(1) at line 2515 =
of file fs/xfs/libxfs/xfs_da_btree.c.  Caller xfs_da_read_buf+0x64/0x100 =
[xfs]
removed =A11075076137'
[11176.933086] XFS (loop0): xfs_dabuf_map: bno 0 dir: inode 1075076145
...
[11176.964640] XFS (loop0): xfs_dabuf_map: bno 0 dir: inode 2150139905
[11176.965573] XFS (loop0): [00] br_startoff 0 br_startblock -2 br_blockc=
ount 1
br_state 0
[11176.966606] XFS (loop0): Internal error xfs_da_do_buf(1) at line 2515 =
of file fs/xfs/libxfs/xfs_da_btree.c.  Caller xfs_da_read_buf+0x64/0x100 =
[xfs]
removed =A12150139905'
[11176.969763] XFS (loop0): xfs_dabuf_map: bno 0 dir: inode 2150139906
[11176.970450] XFS (loop0): [00] br_startoff 0 br_startblock -2 br_blockc=
ount 1
br_state 0
[11176.971582] XFS (loop0): Internal error xfs_da_do_buf(1) at line 2515 =
of file fs/xfs/libxfs/xfs_da_btree.c.  Caller xfs_da_read_buf+0x64/0x100 =
[xfs]
removed =A12150139906'
[11176.984857] XFS (loop0): xfs_dabuf_map: bno 0 dir: inode 3387262326
[11176.985444] XFS (loop0): [00] br_startoff 0 br_startblock -2 br_blockc=
ount 1
br_state 0
[11176.986544] XFS (loop0): Internal error xfs_da_do_buf(1) at line 2515 =
of file fs/xfs/libxfs/xfs_da_btree.c.  Caller xfs_da_read_buf+0x64/0x100 =
[xfs]
removed =A13387262326'
[11176.989480] XFS (loop0): xfs_dabuf_map: bno 0 dir: inode 3387262327
[11176.990080] XFS (loop0): [00] br_startoff 0 br_startblock -2 br_blockc=
ount 1
br_state 0
[11176.991114] XFS (loop0): Internal error xfs_da_do_buf(1) at line 2515 =
of file fs/xfs/libxfs/xfs_da_btree.c.  Caller xfs_da_read_buf+0x64/0x100 =
[xfs]
removed =A13387262327'

and this in /var/log/messages:

Jun 20 11:52:34 xxxxxxx kernel: [  452.334590] XFS (loop0): Mounting V4 F=
ilesystem
Jun 20 11:52:34 xxxxxxx kernel: [  452.486279] XFS (loop0): Ending clean =
mount
Jun 20 11:52:45 xxxxxxx kernel: [  463.448643] XFS (loop0): xfs_dabuf_map=
: bno 0 dir: inode 1074184187
Jun 20 11:52:45 xxxxxxx kernel: [  463.448804] XFS (loop0): [00] br_start=
off 0 br_startblock -2 br_blockcount 1 br_state 0
Jun 20 11:52:45 xxxxxxx kernel: [  463.449047] XFS (loop0): Internal erro=
r xfs_da_do_buf(1) at line 2515 of file fs/xfs/libxfs/xfs_da_btree.c.  Ca=
ller xfs_da_read_buf+0x64/0x100 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.449276] CPU: 1 PID: 1545 Comm: mc =
Tainted: P           O    4.0.5-200.AES.f21g.x86_64 #1
Jun 20 11:52:45 xxxxxxx kernel: [  463.449281] Hardware name: Hewlett-Pac=
kard HP Compaq 8710w (GC124EA#ABB)/30C3, BIOS 68MAD Ver. F.20 12/07/2011
Jun 20 11:52:45 xxxxxxx kernel: [  463.449286]  0000000000000000 00000000=
3de140fd ffff8800b9943b78 ffffffff81771467
Jun 20 11:52:45 xxxxxxx kernel: [  463.449296]  0000000000000000 ffff8800=
aaf34000 ffff8800b9943b98 ffffffffa00c2711
Jun 20 11:52:45 xxxxxxx kernel: [  463.449304]  ffffffffa009eff4 00000000=
00000001 ffff8800b9943c48 ffffffffa009def5
Jun 20 11:52:45 xxxxxxx kernel: [  463.449313] Call Trace:
Jun 20 11:52:45 xxxxxxx kernel: [  463.449330]  [<ffffffff81771467>] dump=
_stack+0x45/0x57
Jun 20 11:52:45 xxxxxxx kernel: [  463.449390]  [<ffffffffa00c2711>] xfs_=
error_report+0x41/0x50 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.449438]  [<ffffffffa009eff4>] ? xf=
s_da_read_buf+0x64/0x100 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.449485]  [<ffffffffa009def5>] xfs_=
dabuf_map.constprop.16+0x165/0x3b0 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.449502]  [<ffffffff8119819e>] ? fi=
nd_get_entries+0x19e/0x1e0
Jun 20 11:52:45 xxxxxxx kernel: [  463.449552]  [<ffffffffa009eff4>] xfs_=
da_read_buf+0x64/0x100 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.449561]  [<ffffffff8139f108>] ? pr=
andom_u32+0x18/0x20
Jun 20 11:52:45 xxxxxxx kernel: [  463.449573]  [<ffffffff811f3c66>] ? km=
em_cache_alloc+0x1e6/0x220
Jun 20 11:52:45 xxxxxxx kernel: [  463.449635]  [<ffffffffa00ddfa7>] ? km=
em_zone_alloc+0x67/0x100 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.449686]  [<ffffffffa009f0b3>] xfs_=
da3_node_read+0x23/0xd0 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.449751]  [<ffffffffa00dd08a>] ? xf=
s_trans_add_item+0x4a/0x60 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.449808]  [<ffffffffa00b9f02>] xfs_=
attr3_root_inactive+0x42/0x120 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.449864]  [<ffffffffa00ba133>] xfs_=
attr_inactive+0x153/0x1b0 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.449926]  [<ffffffffa00d3595>] xfs_=
inactive+0x85/0x140 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.449989]  [<ffffffffa00d915f>] xfs_=
fs_evict_inode+0x6f/0xb0 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.450002]  [<ffffffff8122f107>] evic=
t+0xa7/0x190
Jun 20 11:52:45 xxxxxxx kernel: [  463.450035]  [<ffffffff8122fabf>] iput=
+0x18f/0x200
Jun 20 11:52:45 xxxxxxx kernel: [  463.450044]  [<ffffffff81223c21>] do_u=
nlinkat+0x181/0x370
Jun 20 11:52:45 xxxxxxx kernel: [  463.450059]  [<ffffffff8102322c>] ? do=
_audit_syscall_entry+0x6c/0x70
Jun 20 11:52:45 xxxxxxx kernel: [  463.450066]  [<ffffffff8102478b>] ? sy=
scall_trace_enter_phase1+0x13b/0x1a0
Jun 20 11:52:45 xxxxxxx kernel: [  463.450075]  [<ffffffff81024b56>] ? sy=
scall_trace_leave+0xc6/0x130
Jun 20 11:52:45 xxxxxxx kernel: [  463.450083]  [<ffffffff81225106>] SyS_=
unlink+0x16/0x20
Jun 20 11:52:45 xxxxxxx kernel: [  463.450095]  [<ffffffff81777a49>] syst=
em_call_fastpath+0x12/0x17
Jun 20 11:52:45 xxxxxxx kernel: [  463.450502] XFS (loop0): xfs_dabuf_map=
: bno 0 dir: inode 1075076115
Jun 20 11:52:45 xxxxxxx kernel: [  463.450687] XFS (loop0): [00] br_start=
off 0 br_startblock -2 br_blockcount 1 br_state 0
Jun 20 11:52:45 xxxxxxx kernel: [  463.450916] XFS (loop0): Internal erro=
r xfs_da_do_buf(1) at line 2515 of file fs/xfs/libxfs/xfs_da_btree.c.  Ca=
ller xfs_da_read_buf+0x64/0x100 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.451125] CPU: 1 PID: 1545 Comm: mc =
Tainted: P           O    4.0.5-200.AES.f21g.x86_64 #1
Jun 20 11:52:45 xxxxxxx kernel: [  463.451134] Hardware name: Hewlett-Pac=
kard HP Compaq 8710w (GC124EA#ABB)/30C3, BIOS 68MAD Ver. F.20 12/07/2011
Jun 20 11:52:45 xxxxxxx kernel: [  463.451138]  0000000000000000 00000000=
3de140fd ffff8800b9943b78 ffffffff81771467
Jun 20 11:52:45 xxxxxxx kernel: [  463.451147]  0000000000000000 ffff8800=
aaf34000 ffff8800b9943b98 ffffffffa00c2711
Jun 20 11:52:45 xxxxxxx kernel: [  463.451155]  ffffffffa009eff4 00000000=
00000001 ffff8800b9943c48 ffffffffa009def5
Jun 20 11:52:45 xxxxxxx kernel: [  463.451166] Call Trace:
Jun 20 11:52:45 xxxxxxx kernel: [  463.451176]  [<ffffffff81771467>] dump=
_stack+0x45/0x57
Jun 20 11:52:45 xxxxxxx kernel: [  463.451236]  [<ffffffffa00c2711>] xfs_=
error_report+0x41/0x50 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.451286]  [<ffffffffa009eff4>] ? xf=
s_da_read_buf+0x64/0x100 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.451334]  [<ffffffffa009def5>] xfs_=
dabuf_map.constprop.16+0x165/0x3b0 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.451343]  [<ffffffff8119819e>] ? fi=
nd_get_entries+0x19e/0x1e0
Jun 20 11:52:45 xxxxxxx kernel: [  463.451395]  [<ffffffffa009eff4>] xfs_=
da_read_buf+0x64/0x100 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.451404]  [<ffffffff8139f108>] ? pr=
andom_u32+0x18/0x20
Jun 20 11:52:45 xxxxxxx kernel: [  463.451412]  [<ffffffff811f3c66>] ? km=
em_cache_alloc+0x1e6/0x220
Jun 20 11:52:45 xxxxxxx kernel: [  463.451475]  [<ffffffffa00ddfa7>] ? km=
em_zone_alloc+0x67/0x100 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.451524]  [<ffffffffa009f0b3>] xfs_=
da3_node_read+0x23/0xd0 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.451588]  [<ffffffffa00dd08a>] ? xf=
s_trans_add_item+0x4a/0x60 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.451644]  [<ffffffffa00b9f02>] xfs_=
attr3_root_inactive+0x42/0x120 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.451700]  [<ffffffffa00ba133>] xfs_=
attr_inactive+0x153/0x1b0 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.451761]  [<ffffffffa00d3595>] xfs_=
inactive+0x85/0x140 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.451824]  [<ffffffffa00d915f>] xfs_=
fs_evict_inode+0x6f/0xb0 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.451837]  [<ffffffff8122f107>] evic=
t+0xa7/0x190
Jun 20 11:52:45 xxxxxxx kernel: [  463.451844]  [<ffffffff8122fabf>] iput=
+0x18f/0x200
Jun 20 11:52:45 xxxxxxx kernel: [  463.451852]  [<ffffffff81223c21>] do_u=
nlinkat+0x181/0x370
Jun 20 11:52:45 xxxxxxx kernel: [  463.451863]  [<ffffffff8102322c>] ? do=
_audit_syscall_entry+0x6c/0x70
Jun 20 11:52:45 xxxxxxx kernel: [  463.451871]  [<ffffffff8102478b>] ? sy=
scall_trace_enter_phase1+0x13b/0x1a0
Jun 20 11:52:45 xxxxxxx kernel: [  463.451880]  [<ffffffff81024b56>] ? sy=
scall_trace_leave+0xc6/0x130
Jun 20 11:52:45 xxxxxxx kernel: [  463.451888]  [<ffffffff81225106>] SyS_=
unlink+0x16/0x20
Jun 20 11:52:45 xxxxxxx kernel: [  463.451898]  [<ffffffff81777a49>] syst=
em_call_fastpath+0x12/0x17
Jun 20 11:52:45 xxxxxxx kernel: [  463.488517] XFS (loop0): xfs_dabuf_map=
: bno 0 dir: inode 1075076137
Jun 20 11:52:45 xxxxxxx kernel: [  463.488676] XFS (loop0): [00] br_start=
off 0 br_startblock -2 br_blockcount 1 br_state 0
Jun 20 11:52:45 xxxxxxx kernel: [  463.488882] XFS (loop0): Internal erro=
r xfs_da_do_buf(1) at line 2515 of file fs/xfs/libxfs/xfs_da_btree.c.  Ca=
ller xfs_da_read_buf+0x64/0x100 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.489088] CPU: 1 PID: 1545 Comm: mc =
Tainted: P           O    4.0.5-200.AES.f21g.x86_64 #1
Jun 20 11:52:45 xxxxxxx kernel: [  463.489093] Hardware name: Hewlett-Pac=
kard HP Compaq 8710w (GC124EA#ABB)/30C3, BIOS 68MAD Ver. F.20 12/07/2011
Jun 20 11:52:45 xxxxxxx kernel: [  463.489098]  0000000000000000 00000000=
3de140fd ffff8800b9943b78 ffffffff81771467
Jun 20 11:52:45 xxxxxxx kernel: [  463.489107]  0000000000000000 ffff8800=
aaf34000 ffff8800b9943b98 ffffffffa00c2711
Jun 20 11:52:45 xxxxxxx kernel: [  463.489119]  ffffffffa009eff4 00000000=
00000001 ffff8800b9943c48 ffffffffa009def5
Jun 20 11:52:45 xxxxxxx kernel: [  463.489127] Call Trace:
Jun 20 11:52:45 xxxxxxx kernel: [  463.489139]  [<ffffffff81771467>] dump=
_stack+0x45/0x57
Jun 20 11:52:45 xxxxxxx kernel: [  463.489200]  [<ffffffffa00c2711>] xfs_=
error_report+0x41/0x50 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.489250]  [<ffffffffa009eff4>] ? xf=
s_da_read_buf+0x64/0x100 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.489298]  [<ffffffffa009def5>] xfs_=
dabuf_map.constprop.16+0x165/0x3b0 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.489308]  [<ffffffff8119819e>] ? fi=
nd_get_entries+0x19e/0x1e0
Jun 20 11:52:45 xxxxxxx kernel: [  463.489360]  [<ffffffffa009eff4>] xfs_=
da_read_buf+0x64/0x100 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.489370]  [<ffffffff8139f108>] ? pr=
andom_u32+0x18/0x20
Jun 20 11:52:45 xxxxxxx kernel: [  463.489377]  [<ffffffff811f3c66>] ? km=
em_cache_alloc+0x1e6/0x220
Jun 20 11:52:45 xxxxxxx kernel: [  463.489440]  [<ffffffffa00ddfa7>] ? km=
em_zone_alloc+0x67/0x100 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.489490]  [<ffffffffa009f0b3>] xfs_=
da3_node_read+0x23/0xd0 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.489553]  [<ffffffffa00dd08a>] ? xf=
s_trans_add_item+0x4a/0x60 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.489608]  [<ffffffffa00b9f02>] xfs_=
attr3_root_inactive+0x42/0x120 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.489664]  [<ffffffffa00ba133>] xfs_=
attr_inactive+0x153/0x1b0 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.489726]  [<ffffffffa00d3595>] xfs_=
inactive+0x85/0x140 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.489789]  [<ffffffffa00d915f>] xfs_=
fs_evict_inode+0x6f/0xb0 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.489802]  [<ffffffff8122f107>] evic=
t+0xa7/0x190
Jun 20 11:52:45 xxxxxxx kernel: [  463.489809]  [<ffffffff8122fabf>] iput=
+0x18f/0x200
Jun 20 11:52:45 xxxxxxx kernel: [  463.489817]  [<ffffffff81223c21>] do_u=
nlinkat+0x181/0x370
Jun 20 11:52:45 xxxxxxx kernel: [  463.489829]  [<ffffffff8102322c>] ? do=
_audit_syscall_entry+0x6c/0x70
Jun 20 11:52:45 xxxxxxx kernel: [  463.489836]  [<ffffffff8102478b>] ? sy=
scall_trace_enter_phase1+0x13b/0x1a0
Jun 20 11:52:45 xxxxxxx kernel: [  463.489845]  [<ffffffff81024b56>] ? sy=
scall_trace_leave+0xc6/0x130
Jun 20 11:52:45 xxxxxxx kernel: [  463.489853]  [<ffffffff81225106>] SyS_=
unlink+0x16/0x20
Jun 20 11:52:45 xxxxxxx kernel: [  463.489863]  [<ffffffff81777a49>] syst=
em_call_fastpath+0x12/0x17
Jun 20 11:52:45 xxxxxxx kernel: [  463.490286] XFS (loop0): xfs_dabuf_map=
: bno 0 dir: inode 1075076145
Jun 20 11:52:45 xxxxxxx kernel: [  463.490466] XFS (loop0): [00] br_start=
off 0 br_startblock -2 br_blockcount 1 br_state 0
Jun 20 11:52:45 xxxxxxx kernel: [  463.490688] XFS (loop0): Internal erro=
r xfs_da_do_buf(1) at line 2515 of file fs/xfs/libxfs/xfs_da_btree.c.  Ca=
ller xfs_da_read_buf+0x64/0x100 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.490857] CPU: 1 PID: 1545 Comm: mc =
Tainted: P           O    4.0.5-200.AES.f21g.x86_64 #1
Jun 20 11:52:45 xxxxxxx kernel: [  463.490861] Hardware name: Hewlett-Pac=
kard HP Compaq 8710w (GC124EA#ABB)/30C3, BIOS 68MAD Ver. F.20 12/07/2011
Jun 20 11:52:45 xxxxxxx kernel: [  463.490865]  0000000000000000 00000000=
3de140fd ffff8800b9943b78 ffffffff81771467
Jun 20 11:52:45 xxxxxxx kernel: [  463.490874]  0000000000000000 ffff8800=
aaf34000 ffff8800b9943b98 ffffffffa00c2711
Jun 20 11:52:45 xxxxxxx kernel: [  463.490882]  ffffffffa009eff4 00000000=
00000001 ffff8800b9943c48 ffffffffa009def5
Jun 20 11:52:45 xxxxxxx kernel: [  463.490890] Call Trace:
Jun 20 11:52:45 xxxxxxx kernel: [  463.490900]  [<ffffffff81771467>] dump=
_stack+0x45/0x57
Jun 20 11:52:45 xxxxxxx kernel: [  463.490957]  [<ffffffffa00c2711>] xfs_=
error_report+0x41/0x50 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.491004]  [<ffffffffa009eff4>] ? xf=
s_da_read_buf+0x64/0x100 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.491084]  [<ffffffffa009def5>] xfs_=
dabuf_map.constprop.16+0x165/0x3b0 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.491097]  [<ffffffff8119819e>] ? fi=
nd_get_entries+0x19e/0x1e0
Jun 20 11:52:45 xxxxxxx kernel: [  463.491146]  [<ffffffffa009eff4>] xfs_=
da_read_buf+0x64/0x100 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.491156]  [<ffffffff8139f108>] ? pr=
andom_u32+0x18/0x20
Jun 20 11:52:45 xxxxxxx kernel: [  463.491164]  [<ffffffff811f3c66>] ? km=
em_cache_alloc+0x1e6/0x220
Jun 20 11:52:45 xxxxxxx kernel: [  463.491225]  [<ffffffffa00ddfa7>] ? km=
em_zone_alloc+0x67/0x100 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.491275]  [<ffffffffa009f0b3>] xfs_=
da3_node_read+0x23/0xd0 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.491338]  [<ffffffffa00dd08a>] ? xf=
s_trans_add_item+0x4a/0x60 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.491392]  [<ffffffffa00b9f02>] xfs_=
attr3_root_inactive+0x42/0x120 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.491448]  [<ffffffffa00ba133>] xfs_=
attr_inactive+0x153/0x1b0 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.491509]  [<ffffffffa00d3595>] xfs_=
inactive+0x85/0x140 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.491572]  [<ffffffffa00d915f>] xfs_=
fs_evict_inode+0x6f/0xb0 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.491585]  [<ffffffff8122f107>] evic=
t+0xa7/0x190
Jun 20 11:52:45 xxxxxxx kernel: [  463.491592]  [<ffffffff8122fabf>] iput=
+0x18f/0x200
Jun 20 11:52:45 xxxxxxx kernel: [  463.491600]  [<ffffffff81223c21>] do_u=
nlinkat+0x181/0x370
Jun 20 11:52:45 xxxxxxx kernel: [  463.491611]  [<ffffffff8102322c>] ? do=
_audit_syscall_entry+0x6c/0x70
Jun 20 11:52:45 xxxxxxx kernel: [  463.491619]  [<ffffffff8102478b>] ? sy=
scall_trace_enter_phase1+0x13b/0x1a0
Jun 20 11:52:45 xxxxxxx kernel: [  463.491628]  [<ffffffff81024b56>] ? sy=
scall_trace_leave+0xc6/0x130
Jun 20 11:52:45 xxxxxxx kernel: [  463.491636]  [<ffffffff81225106>] SyS_=
unlink+0x16/0x20
Jun 20 11:52:45 xxxxxxx kernel: [  463.491644]  [<ffffffff81777a49>] syst=
em_call_fastpath+0x12/0x17
Jun 20 11:52:45 xxxxxxx kernel: [  463.510669] XFS (loop0): xfs_dabuf_map=
: bno 0 dir: inode 2149478283
Jun 20 11:52:45 xxxxxxx kernel: [  463.510827] XFS (loop0): [00] br_start=
off 0 br_startblock -2 br_blockcount 1 br_state 0
Jun 20 11:52:45 xxxxxxx kernel: [  463.511028] XFS (loop0): Internal erro=
r xfs_da_do_buf(1) at line 2515 of file fs/xfs/libxfs/xfs_da_btree.c.  Ca=
ller xfs_da_read_buf+0x64/0x100 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.511255] CPU: 1 PID: 1545 Comm: mc =
Tainted: P           O    4.0.5-200.AES.f21g.x86_64 #1
Jun 20 11:52:45 xxxxxxx kernel: [  463.511260] Hardware name: Hewlett-Pac=
kard HP Compaq 8710w (GC124EA#ABB)/30C3, BIOS 68MAD Ver. F.20 12/07/2011
Jun 20 11:52:45 xxxxxxx kernel: [  463.511264]  0000000000000000 00000000=
3de140fd ffff8800b9943b78 ffffffff81771467
Jun 20 11:52:45 xxxxxxx kernel: [  463.511273]  0000000000000000 ffff8800=
aaf34000 ffff8800b9943b98 ffffffffa00c2711
Jun 20 11:52:45 xxxxxxx kernel: [  463.511281]  ffffffffa009eff4 00000000=
00000001 ffff8800b9943c48 ffffffffa009def5
Jun 20 11:52:45 xxxxxxx kernel: [  463.511290] Call Trace:
Jun 20 11:52:45 xxxxxxx kernel: [  463.511300]  [<ffffffff81771467>] dump=
_stack+0x45/0x57
Jun 20 11:52:45 xxxxxxx kernel: [  463.511359]  [<ffffffffa00c2711>] xfs_=
error_report+0x41/0x50 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.511407]  [<ffffffffa009eff4>] ? xf=
s_da_read_buf+0x64/0x100 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.511453]  [<ffffffffa009def5>] xfs_=
dabuf_map.constprop.16+0x165/0x3b0 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.511462]  [<ffffffff8119819e>] ? fi=
nd_get_entries+0x19e/0x1e0
Jun 20 11:52:45 xxxxxxx kernel: [  463.511511]  [<ffffffffa009eff4>] xfs_=
da_read_buf+0x64/0x100 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.511519]  [<ffffffff8139f108>] ? pr=
andom_u32+0x18/0x20
Jun 20 11:52:45 xxxxxxx kernel: [  463.511527]  [<ffffffff811f3c66>] ? km=
em_cache_alloc+0x1e6/0x220
Jun 20 11:52:45 xxxxxxx kernel: [  463.511587]  [<ffffffffa00ddfa7>] ? km=
em_zone_alloc+0x67/0x100 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.511636]  [<ffffffffa009f0b3>] xfs_=
da3_node_read+0x23/0xd0 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.511699]  [<ffffffffa00dd08a>] ? xf=
s_trans_add_item+0x4a/0x60 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.511753]  [<ffffffffa00b9f02>] xfs_=
attr3_root_inactive+0x42/0x120 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.511807]  [<ffffffffa00ba133>] xfs_=
attr_inactive+0x153/0x1b0 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.511866]  [<ffffffffa00d3595>] xfs_=
inactive+0x85/0x140 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.511926]  [<ffffffffa00d915f>] xfs_=
fs_evict_inode+0x6f/0xb0 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.511936]  [<ffffffff8122f107>] evic=
t+0xa7/0x190
Jun 20 11:52:45 xxxxxxx kernel: [  463.511944]  [<ffffffff8122fabf>] iput=
+0x18f/0x200
Jun 20 11:52:45 xxxxxxx kernel: [  463.511951]  [<ffffffff81223c21>] do_u=
nlinkat+0x181/0x370
Jun 20 11:52:45 xxxxxxx kernel: [  463.511961]  [<ffffffff8102322c>] ? do=
_audit_syscall_entry+0x6c/0x70
Jun 20 11:52:45 xxxxxxx kernel: [  463.511968]  [<ffffffff8102478b>] ? sy=
scall_trace_enter_phase1+0x13b/0x1a0
Jun 20 11:52:45 xxxxxxx kernel: [  463.511976]  [<ffffffff81024b56>] ? sy=
scall_trace_leave+0xc6/0x130
Jun 20 11:52:45 xxxxxxx kernel: [  463.511984]  [<ffffffff81225106>] SyS_=
unlink+0x16/0x20
Jun 20 11:52:45 xxxxxxx kernel: [  463.511991]  [<ffffffff81777a49>] syst=
em_call_fastpath+0x12/0x17
Jun 20 11:52:45 xxxxxxx kernel: [  463.512407] XFS (loop0): xfs_dabuf_map=
: bno 0 dir: inode 2150139718
Jun 20 11:52:45 xxxxxxx kernel: [  463.512590] XFS (loop0): [00] br_start=
off 0 br_startblock -2 br_blockcount 1 br_state 0
Jun 20 11:52:45 xxxxxxx kernel: [  463.512827] XFS (loop0): Internal erro=
r xfs_da_do_buf(1) at line 2515 of file fs/xfs/libxfs/xfs_da_btree.c.  Ca=
ller xfs_da_read_buf+0x64/0x100 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.513051] CPU: 1 PID: 1545 Comm: mc =
Tainted: P           O    4.0.5-200.AES.f21g.x86_64 #1
Jun 20 11:52:45 xxxxxxx kernel: [  463.513057] Hardware name: Hewlett-Pac=
kard HP Compaq 8710w (GC124EA#ABB)/30C3, BIOS 68MAD Ver. F.20 12/07/2011
Jun 20 11:52:45 xxxxxxx kernel: [  463.513061]  0000000000000000 00000000=
3de140fd ffff8800b9943b78 ffffffff81771467
Jun 20 11:52:45 xxxxxxx kernel: [  463.513072]  0000000000000000 ffff8800=
aaf34000 ffff8800b9943b98 ffffffffa00c2711
Jun 20 11:52:45 xxxxxxx kernel: [  463.513080]  ffffffffa009eff4 00000000=
00000001 ffff8800b9943c48 ffffffffa009def5
Jun 20 11:52:45 xxxxxxx kernel: [  463.513090] Call Trace:
Jun 20 11:52:45 xxxxxxx kernel: [  463.513101]  [<ffffffff81771467>] dump=
_stack+0x45/0x57
Jun 20 11:52:45 xxxxxxx kernel: [  463.513160]  [<ffffffffa00c2711>] xfs_=
error_report+0x41/0x50 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.513209]  [<ffffffffa009eff4>] ? xf=
s_da_read_buf+0x64/0x100 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.513254]  [<ffffffffa009def5>] xfs_=
dabuf_map.constprop.16+0x165/0x3b0 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.513306]  [<ffffffffa009eff4>] xfs_=
da_read_buf+0x64/0x100 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.513316]  [<ffffffff8139f108>] ? pr=
andom_u32+0x18/0x20
Jun 20 11:52:45 xxxxxxx kernel: [  463.513324]  [<ffffffff811f3c66>] ? km=
em_cache_alloc+0x1e6/0x220
Jun 20 11:52:45 xxxxxxx kernel: [  463.513386]  [<ffffffffa00ddfa7>] ? km=
em_zone_alloc+0x67/0x100 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.513436]  [<ffffffffa009f0b3>] xfs_=
da3_node_read+0x23/0xd0 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.513499]  [<ffffffffa00dd08a>] ? xf=
s_trans_add_item+0x4a/0x60 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.513553]  [<ffffffffa00b9f02>] xfs_=
attr3_root_inactive+0x42/0x120 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.513609]  [<ffffffffa00ba133>] xfs_=
attr_inactive+0x153/0x1b0 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.513670]  [<ffffffffa00d3595>] xfs_=
inactive+0x85/0x140 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.513732]  [<ffffffffa00d915f>] xfs_=
fs_evict_inode+0x6f/0xb0 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.513745]  [<ffffffff8122f107>] evic=
t+0xa7/0x190
Jun 20 11:52:45 xxxxxxx kernel: [  463.513752]  [<ffffffff8122fabf>] iput=
+0x18f/0x200
Jun 20 11:52:45 xxxxxxx kernel: [  463.513760]  [<ffffffff81223c21>] do_u=
nlinkat+0x181/0x370
Jun 20 11:52:45 xxxxxxx kernel: [  463.513772]  [<ffffffff8102322c>] ? do=
_audit_syscall_entry+0x6c/0x70
Jun 20 11:52:45 xxxxxxx kernel: [  463.513779]  [<ffffffff8102478b>] ? sy=
scall_trace_enter_phase1+0x13b/0x1a0
Jun 20 11:52:45 xxxxxxx kernel: [  463.513788]  [<ffffffff81024b56>] ? sy=
scall_trace_leave+0xc6/0x130
Jun 20 11:52:45 xxxxxxx kernel: [  463.513796]  [<ffffffff81225106>] SyS_=
unlink+0x16/0x20
Jun 20 11:52:45 xxxxxxx kernel: [  463.513806]  [<ffffffff81777a49>] syst=
em_call_fastpath+0x12/0x17
Jun 20 11:52:45 xxxxxxx kernel: [  463.514192] XFS (loop0): xfs_dabuf_map=
: bno 0 dir: inode 2150139774
Jun 20 11:52:45 xxxxxxx kernel: [  463.514372] XFS (loop0): [00] br_start=
off 0 br_startblock -2 br_blockcount 1 br_state 0
Jun 20 11:52:45 xxxxxxx kernel: [  463.514615] XFS (loop0): Internal erro=
r xfs_da_do_buf(1) at line 2515 of file fs/xfs/libxfs/xfs_da_btree.c.  Ca=
ller xfs_da_read_buf+0x64/0x100 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.514796] CPU: 1 PID: 1545 Comm: mc =
Tainted: P           O    4.0.5-200.AES.f21g.x86_64 #1
Jun 20 11:52:45 xxxxxxx kernel: [  463.514801] Hardware name: Hewlett-Pac=
kard HP Compaq 8710w (GC124EA#ABB)/30C3, BIOS 68MAD Ver. F.20 12/07/2011
Jun 20 11:52:45 xxxxxxx kernel: [  463.514805]  0000000000000000 00000000=
3de140fd ffff8800b9943b78 ffffffff81771467
Jun 20 11:52:45 xxxxxxx kernel: [  463.514813]  0000000000000000 ffff8800=
aaf34000 ffff8800b9943b98 ffffffffa00c2711
Jun 20 11:52:45 xxxxxxx kernel: [  463.514821]  ffffffffa009eff4 00000000=
00000001 ffff8800b9943c48 ffffffffa009def5
Jun 20 11:52:45 xxxxxxx kernel: [  463.514829] Call Trace:
Jun 20 11:52:45 xxxxxxx kernel: [  463.514839]  [<ffffffff81771467>] dump=
_stack+0x45/0x57
Jun 20 11:52:45 xxxxxxx kernel: [  463.514896]  [<ffffffffa00c2711>] xfs_=
error_report+0x41/0x50 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.514943]  [<ffffffffa009eff4>] ? xf=
s_da_read_buf+0x64/0x100 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.514988]  [<ffffffffa009def5>] xfs_=
dabuf_map.constprop.16+0x165/0x3b0 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.515033]  [<ffffffffa009eff4>] xfs_=
da_read_buf+0x64/0x100 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.515087]  [<ffffffff8139f108>] ? pr=
andom_u32+0x18/0x20
Jun 20 11:52:45 xxxxxxx kernel: [  463.515103]  [<ffffffff811f3c66>] ? km=
em_cache_alloc+0x1e6/0x220
Jun 20 11:52:45 xxxxxxx kernel: [  463.515164]  [<ffffffffa00ddfa7>] ? km=
em_zone_alloc+0x67/0x100 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.515219]  [<ffffffffa009f0b3>] xfs_=
da3_node_read+0x23/0xd0 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.515282]  [<ffffffffa00dd08a>] ? xf=
s_trans_add_item+0x4a/0x60 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.515335]  [<ffffffffa00b9f02>] xfs_=
attr3_root_inactive+0x42/0x120 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.515389]  [<ffffffffa00ba133>] xfs_=
attr_inactive+0x153/0x1b0 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.515448]  [<ffffffffa00d3595>] xfs_=
inactive+0x85/0x140 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.515508]  [<ffffffffa00d915f>] xfs_=
fs_evict_inode+0x6f/0xb0 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.515519]  [<ffffffff8122f107>] evic=
t+0xa7/0x190
Jun 20 11:52:45 xxxxxxx kernel: [  463.515526]  [<ffffffff8122fabf>] iput=
+0x18f/0x200
Jun 20 11:52:45 xxxxxxx kernel: [  463.515533]  [<ffffffff81223c21>] do_u=
nlinkat+0x181/0x370
Jun 20 11:52:45 xxxxxxx kernel: [  463.515543]  [<ffffffff8102322c>] ? do=
_audit_syscall_entry+0x6c/0x70
Jun 20 11:52:45 xxxxxxx kernel: [  463.515551]  [<ffffffff8102478b>] ? sy=
scall_trace_enter_phase1+0x13b/0x1a0
Jun 20 11:52:45 xxxxxxx kernel: [  463.515558]  [<ffffffff81024b56>] ? sy=
scall_trace_leave+0xc6/0x130
Jun 20 11:52:45 xxxxxxx kernel: [  463.515566]  [<ffffffff81225106>] SyS_=
unlink+0x16/0x20
Jun 20 11:52:45 xxxxxxx kernel: [  463.515574]  [<ffffffff81777a49>] syst=
em_call_fastpath+0x12/0x17
Jun 20 11:52:45 xxxxxxx kernel: [  463.515899] XFS (loop0): xfs_dabuf_map=
: bno 0 dir: inode 2150139905
Jun 20 11:52:45 xxxxxxx kernel: [  463.516087] XFS (loop0): [00] br_start=
off 0 br_startblock -2 br_blockcount 1 br_state 0
Jun 20 11:52:45 xxxxxxx kernel: [  463.516325] XFS (loop0): Internal erro=
r xfs_da_do_buf(1) at line 2515 of file fs/xfs/libxfs/xfs_da_btree.c.  Ca=
ller xfs_da_read_buf+0x64/0x100 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.516529] CPU: 1 PID: 1545 Comm: mc =
Tainted: P           O    4.0.5-200.AES.f21g.x86_64 #1
Jun 20 11:52:45 xxxxxxx kernel: [  463.516533] Hardware name: Hewlett-Pac=
kard HP Compaq 8710w (GC124EA#ABB)/30C3, BIOS 68MAD Ver. F.20 12/07/2011
Jun 20 11:52:45 xxxxxxx kernel: [  463.516539]  0000000000000000 00000000=
3de140fd ffff8800b9943b78 ffffffff81771467
Jun 20 11:52:45 xxxxxxx kernel: [  463.516548]  0000000000000000 ffff8800=
aaf34000 ffff8800b9943b98 ffffffffa00c2711
Jun 20 11:52:45 xxxxxxx kernel: [  463.516558]  ffffffffa009eff4 00000000=
00000001 ffff8800b9943c48 ffffffffa009def5
Jun 20 11:52:45 xxxxxxx kernel: [  463.516566] Call Trace:
Jun 20 11:52:45 xxxxxxx kernel: [  463.516576]  [<ffffffff81771467>] dump=
_stack+0x45/0x57
Jun 20 11:52:45 xxxxxxx kernel: [  463.516635]  [<ffffffffa00c2711>] xfs_=
error_report+0x41/0x50 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.516683]  [<ffffffffa009eff4>] ? xf=
s_da_read_buf+0x64/0x100 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.516730]  [<ffffffffa009def5>] xfs_=
dabuf_map.constprop.16+0x165/0x3b0 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.516781]  [<ffffffffa009eff4>] xfs_=
da_read_buf+0x64/0x100 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.516788]  [<ffffffff8139f108>] ? pr=
andom_u32+0x18/0x20
Jun 20 11:52:45 xxxxxxx kernel: [  463.516798]  [<ffffffff811f3c66>] ? km=
em_cache_alloc+0x1e6/0x220
Jun 20 11:52:45 xxxxxxx kernel: [  463.516858]  [<ffffffffa00ddfa7>] ? km=
em_zone_alloc+0x67/0x100 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.516909]  [<ffffffffa009f0b3>] xfs_=
da3_node_read+0x23/0xd0 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.516972]  [<ffffffffa00dd08a>] ? xf=
s_trans_add_item+0x4a/0x60 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.517028]  [<ffffffffa00b9f02>] xfs_=
attr3_root_inactive+0x42/0x120 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.517103]  [<ffffffffa00ba133>] xfs_=
attr_inactive+0x153/0x1b0 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.517164]  [<ffffffffa00d3595>] xfs_=
inactive+0x85/0x140 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.517225]  [<ffffffffa00d915f>] xfs_=
fs_evict_inode+0x6f/0xb0 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.517238]  [<ffffffff8122f107>] evic=
t+0xa7/0x190
Jun 20 11:52:45 xxxxxxx kernel: [  463.517245]  [<ffffffff8122fabf>] iput=
+0x18f/0x200
Jun 20 11:52:45 xxxxxxx kernel: [  463.517254]  [<ffffffff81223c21>] do_u=
nlinkat+0x181/0x370
Jun 20 11:52:45 xxxxxxx kernel: [  463.517264]  [<ffffffff8102322c>] ? do=
_audit_syscall_entry+0x6c/0x70
Jun 20 11:52:45 xxxxxxx kernel: [  463.517273]  [<ffffffff8102478b>] ? sy=
scall_trace_enter_phase1+0x13b/0x1a0
Jun 20 11:52:45 xxxxxxx kernel: [  463.517281]  [<ffffffff81024b56>] ? sy=
scall_trace_leave+0xc6/0x130
Jun 20 11:52:45 xxxxxxx kernel: [  463.517290]  [<ffffffff81225106>] SyS_=
unlink+0x16/0x20
Jun 20 11:52:45 xxxxxxx kernel: [  463.517298]  [<ffffffff81777a49>] syst=
em_call_fastpath+0x12/0x17
Jun 20 11:52:45 xxxxxxx kernel: [  463.517656] XFS (loop0): xfs_dabuf_map=
: bno 0 dir: inode 2150139906
Jun 20 11:52:45 xxxxxxx kernel: [  463.517848] XFS (loop0): [00] br_start=
off 0 br_startblock -2 br_blockcount 1 br_state 0
Jun 20 11:52:45 xxxxxxx kernel: [  463.518103] XFS (loop0): Internal erro=
r xfs_da_do_buf(1) at line 2515 of file fs/xfs/libxfs/xfs_da_btree.c.  Ca=
ller xfs_da_read_buf+0x64/0x100 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.518308] CPU: 1 PID: 1545 Comm: mc =
Tainted: P           O    4.0.5-200.AES.f21g.x86_64 #1
Jun 20 11:52:45 xxxxxxx kernel: [  463.518313] Hardware name: Hewlett-Pac=
kard HP Compaq 8710w (GC124EA#ABB)/30C3, BIOS 68MAD Ver. F.20 12/07/2011
Jun 20 11:52:45 xxxxxxx kernel: [  463.518317]  0000000000000000 00000000=
3de140fd ffff8800b9943b78 ffffffff81771467
Jun 20 11:52:45 xxxxxxx kernel: [  463.518328]  0000000000000000 ffff8800=
aaf34000 ffff8800b9943b98 ffffffffa00c2711
Jun 20 11:52:45 xxxxxxx kernel: [  463.518336]  ffffffffa009eff4 00000000=
00000001 ffff8800b9943c48 ffffffffa009def5
Jun 20 11:52:45 xxxxxxx kernel: [  463.518344] Call Trace:
Jun 20 11:52:45 xxxxxxx kernel: [  463.518356]  [<ffffffff81771467>] dump=
_stack+0x45/0x57
Jun 20 11:52:45 xxxxxxx kernel: [  463.518413]  [<ffffffffa00c2711>] xfs_=
error_report+0x41/0x50 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.518462]  [<ffffffffa009eff4>] ? xf=
s_da_read_buf+0x64/0x100 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.518507]  [<ffffffffa009def5>] xfs_=
dabuf_map.constprop.16+0x165/0x3b0 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.518559]  [<ffffffffa009eff4>] xfs_=
da_read_buf+0x64/0x100 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.518569]  [<ffffffff8139f108>] ? pr=
andom_u32+0x18/0x20
Jun 20 11:52:45 xxxxxxx kernel: [  463.518577]  [<ffffffff811f3c66>] ? km=
em_cache_alloc+0x1e6/0x220
Jun 20 11:52:45 xxxxxxx kernel: [  463.518639]  [<ffffffffa00ddfa7>] ? km=
em_zone_alloc+0x67/0x100 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.518688]  [<ffffffffa009f0b3>] xfs_=
da3_node_read+0x23/0xd0 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.518752]  [<ffffffffa00dd08a>] ? xf=
s_trans_add_item+0x4a/0x60 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.518808]  [<ffffffffa00b9f02>] xfs_=
attr3_root_inactive+0x42/0x120 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.518865]  [<ffffffffa00ba133>] xfs_=
attr_inactive+0x153/0x1b0 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.518926]  [<ffffffffa00d3595>] xfs_=
inactive+0x85/0x140 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.518988]  [<ffffffffa00d915f>] xfs_=
fs_evict_inode+0x6f/0xb0 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.519001]  [<ffffffff8122f107>] evic=
t+0xa7/0x190
Jun 20 11:52:45 xxxxxxx kernel: [  463.519026]  [<ffffffff8122fabf>] iput=
+0x18f/0x200
Jun 20 11:52:45 xxxxxxx kernel: [  463.519048]  [<ffffffff81223c21>] do_u=
nlinkat+0x181/0x370
Jun 20 11:52:45 xxxxxxx kernel: [  463.519069]  [<ffffffff8102322c>] ? do=
_audit_syscall_entry+0x6c/0x70
Jun 20 11:52:45 xxxxxxx kernel: [  463.519093]  [<ffffffff8102478b>] ? sy=
scall_trace_enter_phase1+0x13b/0x1a0
Jun 20 11:52:45 xxxxxxx kernel: [  463.519112]  [<ffffffff81024b56>] ? sy=
scall_trace_leave+0xc6/0x130
Jun 20 11:52:45 xxxxxxx kernel: [  463.519131]  [<ffffffff81225106>] SyS_=
unlink+0x16/0x20
Jun 20 11:52:45 xxxxxxx kernel: [  463.519151]  [<ffffffff81777a49>] syst=
em_call_fastpath+0x12/0x17
Jun 20 11:52:45 xxxxxxx kernel: [  463.536603] XFS (loop0): xfs_dabuf_map=
: bno 0 dir: inode 3387262326
Jun 20 11:52:45 xxxxxxx kernel: [  463.536762] XFS (loop0): [00] br_start=
off 0 br_startblock -2 br_blockcount 1 br_state 0
Jun 20 11:52:45 xxxxxxx kernel: [  463.536963] XFS (loop0): Internal erro=
r xfs_da_do_buf(1) at line 2515 of file fs/xfs/libxfs/xfs_da_btree.c.  Ca=
ller xfs_da_read_buf+0x64/0x100 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.537161] CPU: 1 PID: 1545 Comm: mc =
Tainted: P           O    4.0.5-200.AES.f21g.x86_64 #1
Jun 20 11:52:45 xxxxxxx kernel: [  463.537166] Hardware name: Hewlett-Pac=
kard HP Compaq 8710w (GC124EA#ABB)/30C3, BIOS 68MAD Ver. F.20 12/07/2011
Jun 20 11:52:45 xxxxxxx kernel: [  463.537170]  0000000000000000 00000000=
3de140fd ffff8800b9943b78 ffffffff81771467
Jun 20 11:52:45 xxxxxxx kernel: [  463.537180]  0000000000000000 ffff8800=
aaf34000 ffff8800b9943b98 ffffffffa00c2711
Jun 20 11:52:45 xxxxxxx kernel: [  463.537191]  ffffffffa009eff4 00000000=
00000001 ffff8800b9943c48 ffffffffa009def5
Jun 20 11:52:45 xxxxxxx kernel: [  463.537199] Call Trace:
Jun 20 11:52:45 xxxxxxx kernel: [  463.537210]  [<ffffffff81771467>] dump=
_stack+0x45/0x57
Jun 20 11:52:45 xxxxxxx kernel: [  463.537271]  [<ffffffffa00c2711>] xfs_=
error_report+0x41/0x50 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.537320]  [<ffffffffa009eff4>] ? xf=
s_da_read_buf+0x64/0x100 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.537368]  [<ffffffffa009def5>] xfs_=
dabuf_map.constprop.16+0x165/0x3b0 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.537418]  [<ffffffffa009eff4>] xfs_=
da_read_buf+0x64/0x100 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.537426]  [<ffffffff8139f108>] ? pr=
andom_u32+0x18/0x20
Jun 20 11:52:45 xxxxxxx kernel: [  463.537436]  [<ffffffff811f3c66>] ? km=
em_cache_alloc+0x1e6/0x220
Jun 20 11:52:45 xxxxxxx kernel: [  463.537497]  [<ffffffffa00ddfa7>] ? km=
em_zone_alloc+0x67/0x100 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.537548]  [<ffffffffa009f0b3>] xfs_=
da3_node_read+0x23/0xd0 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.537612]  [<ffffffffa00dd08a>] ? xf=
s_trans_add_item+0x4a/0x60 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.537667]  [<ffffffffa00b9f02>] xfs_=
attr3_root_inactive+0x42/0x120 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.537724]  [<ffffffffa00ba133>] xfs_=
attr_inactive+0x153/0x1b0 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.537785]  [<ffffffffa00d3595>] xfs_=
inactive+0x85/0x140 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.537847]  [<ffffffffa00d915f>] xfs_=
fs_evict_inode+0x6f/0xb0 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.537860]  [<ffffffff8122f107>] evic=
t+0xa7/0x190
Jun 20 11:52:45 xxxxxxx kernel: [  463.537867]  [<ffffffff8122fabf>] iput=
+0x18f/0x200
Jun 20 11:52:45 xxxxxxx kernel: [  463.537875]  [<ffffffff81223c21>] do_u=
nlinkat+0x181/0x370
Jun 20 11:52:45 xxxxxxx kernel: [  463.537887]  [<ffffffff8102322c>] ? do=
_audit_syscall_entry+0x6c/0x70
Jun 20 11:52:45 xxxxxxx kernel: [  463.537894]  [<ffffffff8102478b>] ? sy=
scall_trace_enter_phase1+0x13b/0x1a0
Jun 20 11:52:45 xxxxxxx kernel: [  463.537903]  [<ffffffff81024b56>] ? sy=
scall_trace_leave+0xc6/0x130
Jun 20 11:52:45 xxxxxxx kernel: [  463.537911]  [<ffffffff81225106>] SyS_=
unlink+0x16/0x20
Jun 20 11:52:45 xxxxxxx kernel: [  463.537921]  [<ffffffff81777a49>] syst=
em_call_fastpath+0x12/0x17
Jun 20 11:52:45 xxxxxxx kernel: [  463.538313] XFS (loop0): xfs_dabuf_map=
: bno 0 dir: inode 3387262327
Jun 20 11:52:45 xxxxxxx kernel: [  463.538489] XFS (loop0): [00] br_start=
off 0 br_startblock -2 br_blockcount 1 br_state 0
Jun 20 11:52:45 xxxxxxx kernel: [  463.538724] XFS (loop0): Internal erro=
r xfs_da_do_buf(1) at line 2515 of file fs/xfs/libxfs/xfs_da_btree.c.  Ca=
ller xfs_da_read_buf+0x64/0x100 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.538897] CPU: 1 PID: 1545 Comm: mc =
Tainted: P           O    4.0.5-200.AES.f21g.x86_64 #1
Jun 20 11:52:45 xxxxxxx kernel: [  463.538902] Hardware name: Hewlett-Pac=
kard HP Compaq 8710w (GC124EA#ABB)/30C3, BIOS 68MAD Ver. F.20 12/07/2011
Jun 20 11:52:45 xxxxxxx kernel: [  463.538906]  0000000000000000 00000000=
3de140fd ffff8800b9943b78 ffffffff81771467
Jun 20 11:52:45 xxxxxxx kernel: [  463.538915]  0000000000000000 ffff8800=
aaf34000 ffff8800b9943b98 ffffffffa00c2711
Jun 20 11:52:45 xxxxxxx kernel: [  463.538922]  ffffffffa009eff4 00000000=
00000001 ffff8800b9943c48 ffffffffa009def5
Jun 20 11:52:45 xxxxxxx kernel: [  463.538931] Call Trace:
Jun 20 11:52:45 xxxxxxx kernel: [  463.538941]  [<ffffffff81771467>] dump=
_stack+0x45/0x57
Jun 20 11:52:45 xxxxxxx kernel: [  463.538998]  [<ffffffffa00c2711>] xfs_=
error_report+0x41/0x50 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.539078]  [<ffffffffa009eff4>] ? xf=
s_da_read_buf+0x64/0x100 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.539128]  [<ffffffffa009def5>] xfs_=
dabuf_map.constprop.16+0x165/0x3b0 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.539178]  [<ffffffffa009eff4>] xfs_=
da_read_buf+0x64/0x100 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.539186]  [<ffffffff8139f108>] ? pr=
andom_u32+0x18/0x20
Jun 20 11:52:45 xxxxxxx kernel: [  463.539196]  [<ffffffff811f3c66>] ? km=
em_cache_alloc+0x1e6/0x220
Jun 20 11:52:45 xxxxxxx kernel: [  463.539256]  [<ffffffffa00ddfa7>] ? km=
em_zone_alloc+0x67/0x100 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.539307]  [<ffffffffa009f0b3>] xfs_=
da3_node_read+0x23/0xd0 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.539371]  [<ffffffffa00dd08a>] ? xf=
s_trans_add_item+0x4a/0x60 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.539427]  [<ffffffffa00b9f02>] xfs_=
attr3_root_inactive+0x42/0x120 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.539483]  [<ffffffffa00ba133>] xfs_=
attr_inactive+0x153/0x1b0 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.539544]  [<ffffffffa00d3595>] xfs_=
inactive+0x85/0x140 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.539606]  [<ffffffffa00d915f>] xfs_=
fs_evict_inode+0x6f/0xb0 [xfs]
Jun 20 11:52:45 xxxxxxx kernel: [  463.539619]  [<ffffffff8122f107>] evic=
t+0xa7/0x190
Jun 20 11:52:45 xxxxxxx kernel: [  463.539626]  [<ffffffff8122fabf>] iput=
+0x18f/0x200
Jun 20 11:52:45 xxxxxxx kernel: [  463.539634]  [<ffffffff81223c21>] do_u=
nlinkat+0x181/0x370
Jun 20 11:52:45 xxxxxxx kernel: [  463.539646]  [<ffffffff8102322c>] ? do=
_audit_syscall_entry+0x6c/0x70
Jun 20 11:52:45 xxxxxxx kernel: [  463.539653]  [<ffffffff8102478b>] ? sy=
scall_trace_enter_phase1+0x13b/0x1a0
Jun 20 11:52:45 xxxxxxx kernel: [  463.539662]  [<ffffffff81024b56>] ? sy=
scall_trace_leave+0xc6/0x130
Jun 20 11:52:45 xxxxxxx kernel: [  463.539670]  [<ffffffff81225106>] SyS_=
unlink+0x16/0x20
Jun 20 11:52:45 xxxxxxx kernel: [  463.539680]  [<ffffffff81777a49>] syst=
em_call_fastpath+0x12/0x17
Jun 20 11:53:50 xxxxxxx kernel: [  528.397750] XFS (loop0): Mounting V4 F=
ilesystem
Jun 20 11:53:50 xxxxxxx kernel: [  528.531490] XFS (loop0): Ending clean =
mount
Jun 20 11:54:05 xxxxxxx kernel: [  543.106412] XFS (loop0): xfs_dabuf_map=
: bno 0 dir: inode 1074184187
Jun 20 11:54:05 xxxxxxx kernel: [  543.106975] XFS (loop0): [00] br_start=
off 0 br_startblock -2 br_blockcount 1 br_state 0
Jun 20 11:54:05 xxxxxxx kernel: [  543.108075] XFS (loop0): Internal erro=
r xfs_da_do_buf(1) at line 2515 of file fs/xfs/libxfs/xfs_da_btree.c.  Ca=
ller xfs_da_read_buf+0x64/0x100 [xfs]
Jun 20 11:54:05 xxxxxxx kernel: [  543.109219] CPU: 0 PID: 1650 Comm: rm =
Tainted: P           O    4.0.5-200.AES.f21g.x86_64 #1
Jun 20 11:54:05 xxxxxxx kernel: [  543.109225] Hardware name: Hewlett-Pac=
kard HP Compaq 8710w (GC124EA#ABB)/30C3, BIOS 68MAD Ver. F.20 12/07/2011
Jun 20 11:54:05 xxxxxxx kernel: [  543.109231]  0000000000000000 00000000=
889de3fb ffff8800b0e2bb78 ffffffff81771467
Jun 20 11:54:05 xxxxxxx kernel: [  543.109241]  0000000000000000 ffff8800=
aaf37000 ffff8800b0e2bb98 ffffffffa00c2711
Jun 20 11:54:05 xxxxxxx kernel: [  543.109249]  ffffffffa009eff4 00000000=
00000001 ffff8800b0e2bc48 ffffffffa009def5
Jun 20 11:54:05 xxxxxxx kernel: [  543.109257] Call Trace:
Jun 20 11:54:05 xxxxxxx kernel: [  543.109273]  [<ffffffff81771467>] dump=
_stack+0x45/0x57
Jun 20 11:54:05 xxxxxxx kernel: [  543.109333]  [<ffffffffa00c2711>] xfs_=
error_report+0x41/0x50 [xfs]
Jun 20 11:54:05 xxxxxxx kernel: [  543.109381]  [<ffffffffa009eff4>] ? xf=
s_da_read_buf+0x64/0x100 [xfs]
Jun 20 11:54:05 xxxxxxx kernel: [  543.109427]  [<ffffffffa009def5>] xfs_=
dabuf_map.constprop.16+0x165/0x3b0 [xfs]
Jun 20 11:54:05 xxxxxxx kernel: [  543.109477]  [<ffffffffa009eff4>] xfs_=
da_read_buf+0x64/0x100 [xfs]
Jun 20 11:54:05 xxxxxxx kernel: [  543.109486]  [<ffffffff8139f108>] ? pr=
andom_u32+0x18/0x20
Jun 20 11:54:05 xxxxxxx kernel: [  543.109496]  [<ffffffff811f3c66>] ? km=
em_cache_alloc+0x1e6/0x220
Jun 20 11:54:05 xxxxxxx kernel: [  543.109557]  [<ffffffffa00ddfa7>] ? km=
em_zone_alloc+0x67/0x100 [xfs]
Jun 20 11:54:05 xxxxxxx kernel: [  543.109606]  [<ffffffffa009f0b3>] xfs_=
da3_node_read+0x23/0xd0 [xfs]
Jun 20 11:54:05 xxxxxxx kernel: [  543.109669]  [<ffffffffa00dd08a>] ? xf=
s_trans_add_item+0x4a/0x60 [xfs]
Jun 20 11:54:05 xxxxxxx kernel: [  543.109724]  [<ffffffffa00b9f02>] xfs_=
attr3_root_inactive+0x42/0x120 [xfs]
Jun 20 11:54:05 xxxxxxx kernel: [  543.109778]  [<ffffffffa00ba133>] xfs_=
attr_inactive+0x153/0x1b0 [xfs]
Jun 20 11:54:05 xxxxxxx kernel: [  543.109837]  [<ffffffffa00d3595>] xfs_=
inactive+0x85/0x140 [xfs]
Jun 20 11:54:05 xxxxxxx kernel: [  543.109897]  [<ffffffffa00d915f>] xfs_=
fs_evict_inode+0x6f/0xb0 [xfs]
Jun 20 11:54:05 xxxxxxx kernel: [  543.109909]  [<ffffffff8122f107>] evic=
t+0xa7/0x190
Jun 20 11:54:05 xxxxxxx kernel: [  543.109916]  [<ffffffff8122fabf>] iput=
+0x18f/0x200
Jun 20 11:54:05 xxxxxxx kernel: [  543.109925]  [<ffffffff81223c21>] do_u=
nlinkat+0x181/0x370
Jun 20 11:54:05 xxxxxxx kernel: [  543.109937]  [<ffffffff8102322c>] ? do=
_audit_syscall_entry+0x6c/0x70
Jun 20 11:54:05 xxxxxxx kernel: [  543.109944]  [<ffffffff8102478b>] ? sy=
scall_trace_enter_phase1+0x13b/0x1a0
Jun 20 11:54:05 xxxxxxx kernel: [  543.109953]  [<ffffffff81064081>] ? do=
_page_fault+0x31/0x70
Jun 20 11:54:05 xxxxxxx kernel: [  543.109961]  [<ffffffff812250cb>] SyS_=
unlinkat+0x1b/0x40
Jun 20 11:54:05 xxxxxxx kernel: [  543.109970]  [<ffffffff81777a49>] syst=
em_call_fastpath+0x12/0x17
Jun 20 11:56:00 xxxxxxx kernel: [  658.890098] XFS (loop0): Mounting V4 F=
ilesystem
Jun 20 11:56:01 xxxxxxx kernel: [  659.042968] XFS (loop0): Ending clean =
mount

Every time I erase the files in lost+found directory and then run=20
xfs_repair I got the same errors and the same files are saved back to=20
lost+found. If I do not remove anything from lost+found directory no=20
errors are reported by xfs_repair.

xfsprogs 3.2.1
kernel  4.0.5 x86_64

How can I get rid of the 0 bytes files in lost+found directory?
Thank you.


Sincerely,
Gabriel

- --=20

// Gabriel VLASIU
//
// OpenGPG-KeyID      : 44952F15
// OpenGPG-Fingerprint: 4AC5 7C26 2FE9 02DA 4906  24B2 D32B 7ED7 4495 2F1=
5
// OpenGPG-URL        : http://www.vlasiu.net/public.key


-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJVhVmaAAoJENMrftdElS8VYr4P/i1o0qseIjqzZzOHorehZg+R
fNvJtZcLB/Z8yHaocUGwRtvyaW84vmFP0i5VZ8ygH2MiEOJYsb2UYlt+ah9vjuAr
m2sSIl15dd2PQ5YdbI1NZyjBGgvuAA/9Rz8XHx8Y48Szz9YYdwb/WaweYNuZrqbd
JTWk75nXUm2YYS8u1t8PvSdBzYBhZi8nwVz5CZ8ENNGEVpcypFCcVgL7z6Yq6CK7
V+zg2kO0lPLTqkr9OqDEbMqAoA4q4g1U7CSDWnhNN4BIiPucULB/UOkA9TBUgrCR
jHQk/Ui3yV/20WqdghyOQltN6CTepsK6zuyXUImpt9YtHNfgQJQRsVt70o2L+pYV
+8KEcV11x/vjJT//xUFIkyP+F9br0c3W/qdPv3pfnKUYe4zDajuZ6m7QAsQHLXL+
7CSF4hL1mdsCo0MQCt6biPtKnOLaPiSgrkxlVCy35jFnTY3XsKfR/ls+pcIuvFoB
DRJowD0E/qU6x7Wvh1AZjQ0Rl3W6PveQHo/89pzDg1wzo6GlFSQwJUgX8Hb/JqJG
PcuFxeSNJJDOMvrOgzGR007gt8XJbIoJJFAz3phhYjfep4WUjdC3Ev+59m16lwTh
4aZk94IxIF1N6SXp2owQQYMPoIEulLAACCNdL/5i+YXEL5a05pm/EIz+qSna+tiA
+EjZl9QQ/jPzgEW1VKtE
=3DOoqW
-----END PGP SIGNATURE-----
---547652302-1377685718-1434802600=:21291
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

---547652302-1377685718-1434802600=:21291--
