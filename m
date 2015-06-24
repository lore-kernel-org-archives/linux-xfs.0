Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 780937F56
	for <xfs@oss.sgi.com>; Wed, 24 Jun 2015 02:39:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D7E00AC007
	for <xfs@oss.sgi.com>; Wed, 24 Jun 2015 00:39:52 -0700 (PDT)
Received: from columba.intomics.com (columba.intomics.com [77.72.50.68]) by
	cuda.sgi.com with ESMTP id 9JO45rt1txUdiO6f for
	<xfs@oss.sgi.com>; Wed, 24 Jun 2015 00:39:48 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by columba.intomics.com (Postfix) with ESMTP id 308F022049B
	for <xfs@oss.sgi.com>; Wed, 24 Jun 2015 09:39:48 +0200 (CEST)
Received: from columba ([127.0.0.1])
	by localhost (columba.intomics.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id ZdleCXT7rQOH for <xfs@oss.sgi.com>;
	Wed, 24 Jun 2015 09:39:46 +0200 (CEST)
Received: from dhcp-0-1-67.intomics.com (dhcp-0-1-67.intomics.com [10.0.1.67])
	(Authenticated sender: rbh)
	by columba.intomics.com (Postfix) with ESMTPSA id 2AC1D220488
	for <xfs@oss.sgi.com>; Wed, 24 Jun 2015 09:39:46 +0200 (CEST)
From: Rasmus Borup Hansen <rbh@intomics.com>
Subject: "Internal error xfs_attr3_leaf_write_verify at line 216",
	"directory flags set on non-directory inode" and other errors
Message-Id: <FD7C5F18-48F3-461B-9604-0E3BDBB7AD69@intomics.com>
Date: Wed, 24 Jun 2015 09:39:45 +0200
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7064282631238869077=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============7064282631238869077==
Content-Type: multipart/alternative; boundary="Apple-Mail=_714F1230-E0A0-4C10-BA32-4F38EBA286AB"


--Apple-Mail=_714F1230-E0A0-4C10-BA32-4F38EBA286AB
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Hi! Yesterday I got the following error messages from the kernel (Ubuntu =
trusty, 3.13.0-55):

[601201.817664] ffff88016e03e000: 00 00 00 00 00 00 00 00 fb ee 00 00 00 =
00 00 00  ................
[601201.818224] ffff88016e03e010: 10 00 00 00 00 20 0f e0 00 00 00 00 00 =
00 00 00  ..... ..........
[601201.818827] ffff88016e03e020: 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00  ................
[601201.819429] ffff88016e03e030: 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00  ................
[601201.820013] XFS (dm-0): Internal error xfs_attr3_leaf_write_verify =
at line 216 of file /build/buildd/linux-3.13.0/fs/xfs/xfs_attr_leaf.c.  =
Caller 0xffffffffa00996f0
[601201.820910] CPU: 1 PID: 421 Comm: xfsaild/dm-0 Not tainted =
3.13.0-55-generic #92-Ubuntu
[601201.820913] Hardware name: Dell Inc. PowerEdge R310/05XKKK, BIOS =
1.8.2 08/17/2011
[601201.820914]  0000000000000001 ffff880035cc3bd0 ffffffff81723294 =
ffff8802ac71d800
[601201.820918]  ffff880035cc3be8 ffffffffa009d6fb ffffffffa00996f0 =
ffff880035cc3c20
[601201.820919]  ffffffffa009d755 000000d800205500 ffff88001aa2a400 =
ffff880050acc2b8
[601201.820922] Call Trace:
[601201.820930]  [<ffffffff81723294>] dump_stack+0x45/0x56
[601201.820964]  [<ffffffffa009d6fb>] xfs_error_report+0x3b/0x40 [xfs]
[601201.820974]  [<ffffffffa00996f0>] ? _xfs_buf_ioapply+0x70/0x3a0 =
[xfs]
[601201.820984]  [<ffffffffa009d755>] xfs_corruption_error+0x55/0x80 =
[xfs]
[601201.820997]  [<ffffffffa00bab50>] =
xfs_attr3_leaf_write_verify+0x100/0x120 [xfs]
[601201.821007]  [<ffffffffa00996f0>] ? _xfs_buf_ioapply+0x70/0x3a0 =
[xfs]
[601201.821016]  [<ffffffffa009b3d5>] ? xfs_bdstrat_cb+0x55/0xb0 [xfs]
[601201.821026]  [<ffffffffa00996f0>] _xfs_buf_ioapply+0x70/0x3a0 [xfs]
[601201.821030]  [<ffffffff8109abc0>] ? wake_up_state+0x20/0x20
[601201.821040]  [<ffffffffa009b3d5>] ? xfs_bdstrat_cb+0x55/0xb0 [xfs]
[601201.821050]  [<ffffffffa009b336>] xfs_buf_iorequest+0x46/0x90 [xfs]
[601201.821060]  [<ffffffffa009b3d5>] xfs_bdstrat_cb+0x55/0xb0 [xfs]
[601201.821070]  [<ffffffffa009b56b>] =
__xfs_buf_delwri_submit+0x13b/0x210 [xfs]
[601201.821081]  [<ffffffffa009c000>] ? =
xfs_buf_delwri_submit_nowait+0x20/0x30 [xfs]
[601201.821100]  [<ffffffffa00faaa0>] ? =
xfs_trans_ail_cursor_first+0x90/0x90 [xfs]
[601201.821110]  [<ffffffffa009c000>] =
xfs_buf_delwri_submit_nowait+0x20/0x30 [xfs]
[601201.821127]  [<ffffffffa00facd7>] xfsaild+0x237/0x5c0 [xfs]
[601201.821145]  [<ffffffffa00faaa0>] ? =
xfs_trans_ail_cursor_first+0x90/0x90 [xfs]
[601201.821148]  [<ffffffff8108b702>] kthread+0xd2/0xf0
[601201.821150]  [<ffffffff8108b630>] ? =
kthread_create_on_node+0x1c0/0x1c0
[601201.821153]  [<ffffffff81733ca8>] ret_from_fork+0x58/0x90
[601201.821155]  [<ffffffff8108b630>] ? =
kthread_create_on_node+0x1c0/0x1c0
[601201.821158] XFS (dm-0): Corruption detected. Unmount and run =
xfs_repair
[601201.821581] XFS (dm-0): xfs_do_force_shutdown(0x8) called from line =
1320 of file /build/buildd/linux-3.13.0/fs/xfs/xfs_buf.c.  Return =
address =3D 0xffffffffa009971c
[601201.832780] XFS (dm-0): Corruption of in-memory data detected.  =
Shutting down filesystem
[601201.833292] XFS (dm-0): Please umount the filesystem and rectify the =
problem(s)
[601201.843375] ffff880238b00000: 58 44 32 42 01 00 0e c0 00 00 00 00 00 =
00 00 00  XD2B............
[601201.843924] ffff880238b00010: 00 00 00 20 3d a7 0c 7b 01 2e 8d 9e 01 =
88 00 10  ... =3D..{........
[601201.844472] ffff880238b00020: 00 00 00 19 21 a9 2d 2f 02 2e 2e 9e 01 =
88 00 20  ....!.-/.......
[601201.845031] ffff880238b00030: 00 00 00 07 39 2b 68 20 18 4d 4f 42 31 =
41 5f 48  ....9+h .MOB1A_H
[601201.845585] XFS (dm-0): Internal error xfs_da3_node_read_verify at =
line 240 of file /build/buildd/linux-3.13.0/fs/xfs/xfs_da_btree.c.  =
Caller 0xffffffffa009a885
[601201.858885] CPU: 1 PID: 2806 Comm: kworker/1:1H Not tainted =
3.13.0-55-generic #92-Ubuntu
[601201.858889] Hardware name: Dell Inc. PowerEdge R310/05XKKK, BIOS =
1.8.2 08/17/2011
[601201.858938] Workqueue: xfslogd xfs_buf_iodone_work [xfs]
[601201.858941]  0000000000000001 ffff8802af9cbd68 ffffffff81723294 =
ffff8802ac71d800
[601201.858944]  ffff8802af9cbd80 ffffffffa009d6fb ffffffffa009a885 =
ffff8802af9cbdb8
[601201.858945]  ffffffffa009d755 000000f0810a0465 ffff880031b35b00 =
ffff880238b00000
[601201.858948] Call Trace:
[601201.858958]  [<ffffffff81723294>] dump_stack+0x45/0x56
[601201.858969]  [<ffffffffa009d6fb>] xfs_error_report+0x3b/0x40 [xfs]
[601201.858979]  [<ffffffffa009a885>] ? xfs_buf_iodone_work+0x85/0xf0 =
[xfs]
[601201.858989]  [<ffffffffa009d755>] xfs_corruption_error+0x55/0x80 =
[xfs]
[601201.859005]  [<ffffffffa00d146c>] =
xfs_da3_node_read_verify+0x8c/0x180 [xfs]
[601201.859014]  [<ffffffffa009a885>] ? xfs_buf_iodone_work+0x85/0xf0 =
[xfs]
[601201.859024]  [<ffffffffa009a885>] xfs_buf_iodone_work+0x85/0xf0 =
[xfs]
[601201.859028]  [<ffffffff81083b22>] process_one_work+0x182/0x450
[601201.859030]  [<ffffffff81084911>] worker_thread+0x121/0x410
[601201.859032]  [<ffffffff810847f0>] ? rescuer_thread+0x430/0x430
[601201.859035]  [<ffffffff8108b702>] kthread+0xd2/0xf0
[601201.859037]  [<ffffffff8108b630>] ? =
kthread_create_on_node+0x1c0/0x1c0
[601201.859040]  [<ffffffff81733ca8>] ret_from_fork+0x58/0x90
[601201.859042]  [<ffffffff8108b630>] ? =
kthread_create_on_node+0x1c0/0x1c0
[601201.859044] XFS (dm-0): Corruption detected. Unmount and run =
xfs_repair
[601201.872288] XFS (dm-0): metadata I/O error: block 0x101ed393c0 =
("xfs_trans_read_buf_map") error 117 numblks 8
[601201.942054] XFS (dm-0): xfs_imap_to_bp: xfs_trans_read_buf() =
returned error 5.
[601209.420268] XFS (dm-0): xfs_log_force: error 5 returned.
[601239.529710] XFS (dm-0): xfs_log_force: error 5 returned.
[601269.639150] XFS (dm-0): xfs_log_force: error 5 returned.
[601299.748593] XFS (dm-0): xfs_log_force: error 5 returned.
[601329.858034] XFS (dm-0): xfs_log_force: error 5 returned.

I'm currently running xfs_repair -n and so far I've seen the following =
output:

Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno =3D 0
doubling cache size to 591200
directory flags set on non-directory inode 206624
directory flags set on non-directory inode 206625
directory flags set on non-directory inode 206626
directory flags set on non-directory inode 206627
directory flags set on non-directory inode 206628
directory flags set on non-directory inode 206629
directory flags set on non-directory inode 206630
directory flags set on non-directory inode 206631
directory flags set on non-directory inode 206632
directory flags set on non-directory inode 206633
directory flags set on non-directory inode 206634

Only the first 20 lines are included. There are currently 250000+ more =
lines with "directory flags set on non-directory inode" and the check is =
still running (the mostly small files take up around 30 TB, so it'll =
probably take a while).

I recently enabled user and project quota and updated from 3.13.0-53. =
The file system has been heavily used for the last month or so.

Does anyone have any thoughts on this? I'm tempted to stop using quotas =
when the file system (hopefully) works again, as it's my impression that =
project quotas are not widely used.

Best,

Rasmus

Intomics is a contract research organization specialized in deriving =
core biological insight from large scale data. We help our clients in =
the pharmaceutical industry develop tomorrow's medicines better, faster, =
and cheaper through optimized use of biomedical data.
-----------------------------------------------------------------
Hansen, Rasmus Borup              Intomics - from data to biology
System Administrator              Diplomvej 377
Scientific Programmer             DK-2800 Kgs. Lyngby
                                  Denmark
E: rbh@intomics.com               W: http://www.intomics.com/
P: +45 5167 7972                  P: +45 8880 7979


--Apple-Mail=_714F1230-E0A0-4C10-BA32-4F38EBA286AB
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=us-ascii

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html =
charset=3Dus-ascii"></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space;" =
class=3D""><div class=3D"">Hi! Yesterday I got the following error =
messages from the kernel (Ubuntu trusty, 3.13.0-55):</div><div =
class=3D""><br class=3D""></div><div class=3D""><div class=3D""><font =
face=3D"Courier New" class=3D"">[601201.817664] ffff88016e03e000: 00 00 =
00 00 00 00 00 00 fb ee 00 00 00 00 00 00 =
&nbsp;................</font></div><div class=3D""><font face=3D"Courier =
New" class=3D"">[601201.818224] ffff88016e03e010: 10 00 00 00 00 20 0f =
e0 00 00 00 00 00 00 00 00 &nbsp;..... ..........</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">[601201.818827] =
ffff88016e03e020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
&nbsp;................</font></div><div class=3D""><font face=3D"Courier =
New" class=3D"">[601201.819429] ffff88016e03e030: 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 &nbsp;................</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">[601201.820013] XFS =
(dm-0): <b class=3D"">Internal error xfs_attr3_leaf_write_verify at line =
216 of file /build/buildd/linux-3.13.0/fs/xfs/xfs_attr_leaf.c.</b> =
&nbsp;Caller 0xffffffffa00996f0</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">[601201.820910] CPU: 1 PID: 421 Comm: =
xfsaild/dm-0 Not tainted 3.13.0-55-generic #92-Ubuntu</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">[601201.820913] =
Hardware name: Dell Inc. PowerEdge R310/05XKKK, BIOS 1.8.2 =
08/17/2011</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">[601201.820914] &nbsp;0000000000000001 ffff880035cc3bd0 =
ffffffff81723294 ffff8802ac71d800</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">[601201.820918] &nbsp;ffff880035cc3be8 =
ffffffffa009d6fb ffffffffa00996f0 ffff880035cc3c20</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">[601201.820919] =
&nbsp;ffffffffa009d755 000000d800205500 ffff88001aa2a400 =
ffff880050acc2b8</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">[601201.820922] Call Trace:</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">[601201.820930] =
&nbsp;[&lt;ffffffff81723294&gt;] dump_stack+0x45/0x56</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">[601201.820964] =
&nbsp;[&lt;ffffffffa009d6fb&gt;] xfs_error_report+0x3b/0x40 =
[xfs]</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">[601201.820974] &nbsp;[&lt;ffffffffa00996f0&gt;] ? =
_xfs_buf_ioapply+0x70/0x3a0 [xfs]</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">[601201.820984] =
&nbsp;[&lt;ffffffffa009d755&gt;] xfs_corruption_error+0x55/0x80 =
[xfs]</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">[601201.820997] &nbsp;[&lt;ffffffffa00bab50&gt;] =
xfs_attr3_leaf_write_verify+0x100/0x120 [xfs]</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">[601201.821007] =
&nbsp;[&lt;ffffffffa00996f0&gt;] ? _xfs_buf_ioapply+0x70/0x3a0 =
[xfs]</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">[601201.821016] &nbsp;[&lt;ffffffffa009b3d5&gt;] ? =
xfs_bdstrat_cb+0x55/0xb0 [xfs]</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">[601201.821026] =
&nbsp;[&lt;ffffffffa00996f0&gt;] _xfs_buf_ioapply+0x70/0x3a0 =
[xfs]</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">[601201.821030] &nbsp;[&lt;ffffffff8109abc0&gt;] ? =
wake_up_state+0x20/0x20</font></div><div class=3D""><font face=3D"Courier =
New" class=3D"">[601201.821040] &nbsp;[&lt;ffffffffa009b3d5&gt;] ? =
xfs_bdstrat_cb+0x55/0xb0 [xfs]</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">[601201.821050] =
&nbsp;[&lt;ffffffffa009b336&gt;] xfs_buf_iorequest+0x46/0x90 =
[xfs]</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">[601201.821060] &nbsp;[&lt;ffffffffa009b3d5&gt;] =
xfs_bdstrat_cb+0x55/0xb0 [xfs]</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">[601201.821070] =
&nbsp;[&lt;ffffffffa009b56b&gt;] __xfs_buf_delwri_submit+0x13b/0x210 =
[xfs]</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">[601201.821081] &nbsp;[&lt;ffffffffa009c000&gt;] ? =
xfs_buf_delwri_submit_nowait+0x20/0x30 [xfs]</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">[601201.821100] =
&nbsp;[&lt;ffffffffa00faaa0&gt;] ? xfs_trans_ail_cursor_first+0x90/0x90 =
[xfs]</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">[601201.821110] &nbsp;[&lt;ffffffffa009c000&gt;] =
xfs_buf_delwri_submit_nowait+0x20/0x30 [xfs]</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">[601201.821127] =
&nbsp;[&lt;ffffffffa00facd7&gt;] xfsaild+0x237/0x5c0 =
[xfs]</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">[601201.821145] &nbsp;[&lt;ffffffffa00faaa0&gt;] ? =
xfs_trans_ail_cursor_first+0x90/0x90 [xfs]</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">[601201.821148] =
&nbsp;[&lt;ffffffff8108b702&gt;] kthread+0xd2/0xf0</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">[601201.821150] =
&nbsp;[&lt;ffffffff8108b630&gt;] ? =
kthread_create_on_node+0x1c0/0x1c0</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">[601201.821153] =
&nbsp;[&lt;ffffffff81733ca8&gt;] =
ret_from_fork+0x58/0x90</font></div><div class=3D""><font face=3D"Courier =
New" class=3D"">[601201.821155] &nbsp;[&lt;ffffffff8108b630&gt;] ? =
kthread_create_on_node+0x1c0/0x1c0</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">[601201.821158] XFS (dm-0): <b =
class=3D"">Corruption detected. Unmount and run =
xfs_repair</b></font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">[601201.821581] XFS (dm-0): xfs_do_force_shutdown(0x8) called =
from line 1320 of file /build/buildd/linux-3.13.0/fs/xfs/xfs_buf.c. =
&nbsp;Return address =3D 0xffffffffa009971c</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">[601201.832780] XFS =
(dm-0): <b class=3D"">Corruption of in-memory data detected. =
&nbsp;Shutting down filesystem</b></font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">[601201.833292] XFS (dm-0): Please =
umount the filesystem and rectify the problem(s)</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">[601201.843375] =
ffff880238b00000: 58 44 32 42 01 00 0e c0 00 00 00 00 00 00 00 00 =
&nbsp;XD2B............</font></div><div class=3D""><font face=3D"Courier =
New" class=3D"">[601201.843924] ffff880238b00010: 00 00 00 20 3d a7 0c =
7b 01 2e 8d 9e 01 88 00 10 &nbsp;... =3D..{........</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">[601201.844472] =
ffff880238b00020: 00 00 00 19 21 a9 2d 2f 02 2e 2e 9e 01 88 00 20 =
&nbsp;....!.-/.......</font></div><div class=3D""><font face=3D"Courier =
New" class=3D"">[601201.845031] ffff880238b00030: 00 00 00 07 39 2b 68 =
20 18 4d 4f 42 31 41 5f 48 &nbsp;....9+h .MOB1A_H</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">[601201.845585] XFS =
(dm-0): <b class=3D"">Internal error xfs_da3_node_read_verify at line =
240 of file /build/buildd/linux-3.13.0/fs/xfs/xfs_da_btree.c.</b> =
&nbsp;Caller 0xffffffffa009a885</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">[601201.858885] CPU: 1 PID: 2806 Comm: =
kworker/1:1H Not tainted 3.13.0-55-generic #92-Ubuntu</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">[601201.858889] =
Hardware name: Dell Inc. PowerEdge R310/05XKKK, BIOS 1.8.2 =
08/17/2011</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">[601201.858938] Workqueue: xfslogd xfs_buf_iodone_work =
[xfs]</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">[601201.858941] &nbsp;0000000000000001 ffff8802af9cbd68 =
ffffffff81723294 ffff8802ac71d800</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">[601201.858944] &nbsp;ffff8802af9cbd80 =
ffffffffa009d6fb ffffffffa009a885 ffff8802af9cbdb8</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">[601201.858945] =
&nbsp;ffffffffa009d755 000000f0810a0465 ffff880031b35b00 =
ffff880238b00000</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">[601201.858948] Call Trace:</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">[601201.858958] =
&nbsp;[&lt;ffffffff81723294&gt;] dump_stack+0x45/0x56</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">[601201.858969] =
&nbsp;[&lt;ffffffffa009d6fb&gt;] xfs_error_report+0x3b/0x40 =
[xfs]</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">[601201.858979] &nbsp;[&lt;ffffffffa009a885&gt;] ? =
xfs_buf_iodone_work+0x85/0xf0 [xfs]</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">[601201.858989] =
&nbsp;[&lt;ffffffffa009d755&gt;] xfs_corruption_error+0x55/0x80 =
[xfs]</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">[601201.859005] &nbsp;[&lt;ffffffffa00d146c&gt;] =
xfs_da3_node_read_verify+0x8c/0x180 [xfs]</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">[601201.859014] =
&nbsp;[&lt;ffffffffa009a885&gt;] ? xfs_buf_iodone_work+0x85/0xf0 =
[xfs]</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">[601201.859024] &nbsp;[&lt;ffffffffa009a885&gt;] =
xfs_buf_iodone_work+0x85/0xf0 [xfs]</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">[601201.859028] =
&nbsp;[&lt;ffffffff81083b22&gt;] =
process_one_work+0x182/0x450</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">[601201.859030] =
&nbsp;[&lt;ffffffff81084911&gt;] =
worker_thread+0x121/0x410</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">[601201.859032] =
&nbsp;[&lt;ffffffff810847f0&gt;] ? =
rescuer_thread+0x430/0x430</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">[601201.859035] =
&nbsp;[&lt;ffffffff8108b702&gt;] kthread+0xd2/0xf0</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">[601201.859037] =
&nbsp;[&lt;ffffffff8108b630&gt;] ? =
kthread_create_on_node+0x1c0/0x1c0</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">[601201.859040] =
&nbsp;[&lt;ffffffff81733ca8&gt;] =
ret_from_fork+0x58/0x90</font></div><div class=3D""><font face=3D"Courier =
New" class=3D"">[601201.859042] &nbsp;[&lt;ffffffff8108b630&gt;] ? =
kthread_create_on_node+0x1c0/0x1c0</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">[601201.859044] XFS (dm-0): <b =
class=3D"">Corruption detected. Unmount and run =
xfs_repair</b></font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">[601201.872288] XFS (dm-0): metadata I/O error: block =
0x101ed393c0 ("xfs_trans_read_buf_map") error 117 numblks =
8</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">[601201.942054] XFS (dm-0): xfs_imap_to_bp: =
xfs_trans_read_buf() returned error 5.</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">[601209.420268] XFS (dm-0): <b =
class=3D"">xfs_log_force: error 5 returned.</b></font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">[601239.529710] XFS =
(dm-0): xfs_log_force: error 5 returned.</font></div><div class=3D""><font=
 face=3D"Courier New" class=3D"">[601269.639150] XFS (dm-0): =
xfs_log_force: error 5 returned.</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">[601299.748593] XFS (dm-0): =
xfs_log_force: error 5 returned.</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">[601329.858034] XFS (dm-0): =
xfs_log_force: error 5 returned.</font></div></div><div class=3D""><br =
class=3D""></div><div class=3D"">I'm currently running <font =
face=3D"Courier New" class=3D"">xfs_repair -n</font> and so far I've =
seen the following output:</div><div class=3D""><br class=3D""></div><div =
class=3D""><div class=3D"">Phase 1 - find and verify =
superblock...</div><div class=3D"">Phase 2 - using internal =
log</div><div class=3D"">&nbsp; &nbsp; &nbsp; &nbsp; - scan filesystem =
freespace and inode maps...</div><div class=3D"">&nbsp; &nbsp; &nbsp; =
&nbsp; - found root inode chunk</div><div class=3D"">Phase 3 - for each =
AG...</div><div class=3D"">&nbsp; &nbsp; &nbsp; &nbsp; - scan (but don't =
clear) agi unlinked lists...</div><div class=3D"">&nbsp; &nbsp; &nbsp; =
&nbsp; - process known inodes and perform inode discovery...</div><div =
class=3D"">&nbsp; &nbsp; &nbsp; &nbsp; - agno =3D 0</div><div =
class=3D"">doubling cache size to 591200</div><div class=3D"">directory =
flags set on non-directory inode 206624</div><div class=3D"">directory =
flags set on non-directory inode 206625</div><div class=3D"">directory =
flags set on non-directory inode 206626</div><div class=3D"">directory =
flags set on non-directory inode 206627</div><div class=3D"">directory =
flags set on non-directory inode 206628</div><div class=3D"">directory =
flags set on non-directory inode 206629</div><div class=3D"">directory =
flags set on non-directory inode 206630</div><div class=3D"">directory =
flags set on non-directory inode 206631</div><div class=3D"">directory =
flags set on non-directory inode 206632</div><div class=3D"">directory =
flags set on non-directory inode 206633</div><div class=3D"">directory =
flags set on non-directory inode 206634</div></div><div class=3D""><br =
class=3D""></div><div class=3D"">Only the first 20 lines are included. =
There are currently 250000+ more lines with "directory flags set on =
non-directory inode" and the check is still running (the mostly small =
files take up around 30 TB, so it'll probably take a while).</div><div =
class=3D""><br class=3D""></div><div class=3D"">I recently enabled user =
and project quota and updated from&nbsp;3.13.0-53. The file system has =
been heavily used for the last month or so.</div><div class=3D""><br =
class=3D""></div><div class=3D"">Does anyone have any thoughts on this? =
I'm tempted to stop using quotas when the file system (hopefully) works =
again, as it's my impression that project quotas are not widely =
used.</div><div class=3D""><br class=3D""></div><div =
class=3D"">Best,</div><div class=3D""><br class=3D""></div><div =
class=3D"">Rasmus</div><br class=3D""><div apple-content-edited=3D"true" =
class=3D"">
<span class=3D"Apple-style-span" style=3D"border-collapse: separate; =
border-spacing: 0px;"><i class=3D"">Intomics is a contract research =
organization specialized in deriving core biological insight from large =
scale data. We help our clients in the pharmaceutical&nbsp;industry =
develop tomorrow's medicines better, faster, and cheaper through =
optimized use of biomedical data.</i><span class=3D"Apple-style-span" =
style=3D"border-collapse: separate; color: rgb(0, 0, 0); font-family: =
Helvetica; font-style: normal; font-variant: normal; font-weight: =
normal; letter-spacing: normal; line-height: normal; orphans: 2; =
text-align: -webkit-auto; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-border-horizontal-spacing: 0px; -webkit-border-vertical-spacing: =
0px; -webkit-text-decorations-in-effect: none; -webkit-text-size-adjust: =
auto; -webkit-text-stroke-width: 0px;  "><div style=3D"word-wrap: =
break-word; -webkit-nbsp-mode: space; -webkit-line-break: =
after-white-space; " class=3D""><div class=3D""><font =
class=3D"Apple-style-span" face=3D"'Courier =
New'">-----------------------------------------------------------------</f=
ont></div><div class=3D""><font class=3D"Apple-style-span" =
face=3D"'Courier New'">Hansen, Rasmus Borup &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp;Intomics - from data to biology</font></div><div =
class=3D""><font class=3D"Apple-style-span" face=3D"'Courier =
New'">System Administrator &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp;Diplomvej 377</font></div><div class=3D""><font =
class=3D"Apple-style-span" face=3D"'Courier New'">Scientific Programmer =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; DK-2800 Kgs. =
Lyngby</font></div><div class=3D""><font class=3D"Apple-style-span" =
face=3D"'Courier New'">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
Denmark</font></div><div class=3D""><font class=3D"Apple-style-span" =
face=3D"'Courier New'">E: <a href=3D"mailto:rbh@intomics.com" =
class=3D"">rbh@intomics.com</a> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; W: <a href=3D"http://www.intomics.com/" =
class=3D"">http://www.intomics.com/</a></font></div><div class=3D""><font =
class=3D"Apple-style-span" face=3D"'Courier New'">P: +45 5167 7972 =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;P: +45 =
8880 7979</font></div></div></span></span>
</div>
<br class=3D""></body></html>=

--Apple-Mail=_714F1230-E0A0-4C10-BA32-4F38EBA286AB--


--===============7064282631238869077==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7064282631238869077==--
