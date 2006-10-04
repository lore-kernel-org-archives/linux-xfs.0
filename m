Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 04 Oct 2006 03:24:27 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k94AOLaG012920
	for <xfs@oss.sgi.com>; Wed, 4 Oct 2006 03:24:22 -0700
Received: from tyo202.gate.nec.co.jp (TYO202.gate.nec.co.jp [202.32.8.206])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A80B9D17BB66
	for <xfs@oss.sgi.com>; Wed,  4 Oct 2006 02:20:17 -0700 (PDT)
Received: from mailgate3.nec.co.jp (mailgate53.nec.co.jp [10.7.69.192])
	by tyo202.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id k949KFDK006201
	for <xfs@oss.sgi.com>; Wed, 4 Oct 2006 18:20:15 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id k949KFG15016 for xfs@oss.sgi.com; Wed, 4 Oct 2006 18:20:15 +0900 (JST)
Received: from mailsv.linux.bs1.fc.nec.co.jp (mailsv.linux.bs1.fc.nec.co.jp [10.34.125.2]) by mailsv5.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id k949KEi07028 for <xfs@oss.sgi.com>; Wed, 4 Oct 2006 18:20:14 +0900 (JST)
Received: from [10.34.125.197] (johnny.linux.bs1.fc.nec.co.jp [10.34.125.197])
	by mailsv.linux.bs1.fc.nec.co.jp (Postfix) with ESMTP id 6623FE4824A
	for <xfs@oss.sgi.com>; Wed,  4 Oct 2006 18:20:14 +0900 (JST)
Message-ID: <45237CCE.4010007@ah.jp.nec.com>
Date: Wed, 04 Oct 2006 18:20:14 +0900
From: Takenori Nagano <t-nagano@ah.jp.nec.com>
MIME-Version: 1.0
Subject: [patch] Fix xfs_iunpin() sets I_DIRTY_SYNC after clear_inode().
Content-Type: multipart/mixed;
 boundary="------------030508040500000105030608"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------030508040500000105030608
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Hi,

The patch attached to this mail is a fix for a race of xfs_iunpin()
and generic_delete_inode().

generic_delete_inode() checks inode->i_state using BUG_ON() after
clear_inode(). At this point inode->i_state value must be I_CLEAR after
clear_inode().

But we detected inode->i_state was not I_CLEAR after clear_inode().
Kernel panic occurred by BUG_ON(inode->i_state != I_CLEAR). We
analyzed the memory dump, then we found I_DIRTY_SYNC and I_CLEAR ware
set. The function to set I_DIRTY_SYNC is only __mark_inode_dirty(). We
took a backtrace when i_state is I_CLEAR in __mark_inode_dirty().

This is a backtrace when inode->i_state=I_CLEAR in __mark_inode_dirty().

> > Call Trace:
> >  [<a000000100019980>] show_stack+0x80/0xa0
> >                                 sp=e00000012c077970 bsp=e00000012c0713e8
> >  [<a00000010003d1e0>] die+0x1c0/0x2e0
> >                                 sp=e00000012c077b40 bsp=e00000012c0713b0
> >  [<a00000010003e810>] ia64_bad_break+0x2f0/0x400
> >                                 sp=e00000012c077b40 bsp=e00000012c071388
> >  [<a000000100010180>] ia64_leave_kernel+0x0/0x260
> >                                 sp=e00000012c077bd0 bsp=e00000012c071388
> >  [<a0000001001c6170>] __mark_inode_dirty+0x390/0x3a0
> >                                 sp=e00000012c077da0 bsp=e00000012c071330
> >  [<a00000021c88a070>] xfs_iunpin+0x110/0x120 [xfs]
> >                                 sp=e00000012c077da0 bsp=e00000012c071310
> >  [<a00000021c892550>] xfs_inode_item_unpin+0x30/0x60 [xfs]
> >                                 sp=e00000012c077da0 bsp=e00000012c0712f0
> >  [<a00000021c8b1d00>] xfs_trans_chunk_committed+0x280/0x380 [xfs]
> >                                 sp=e00000012c077da0 bsp=e00000012c071298
> >  [<a00000021c8b1e80>] xfs_trans_committed+0x80/0x320 [xfs]
> >                                 sp=e00000012c077da0 bsp=e00000012c071248
> >  [<a00000021c898280>] xlog_state_do_callback+0x4a0/0xa20 [xfs]
> >                                 sp=e00000012c077da0 bsp=e00000012c0711b0
> >  [<a00000021c898990>] xlog_iodone+0x190/0x300 [xfs]
> >                                 sp=e00000012c077da0 bsp=e00000012c071168
> >  [<a00000021c8e6280>] pagebuf_iodone_work+0xc0/0x120 [xfs]
> >                                 sp=e00000012c077da0 bsp=e00000012c071148
> >  [<a0000001000d2f50>] worker_thread+0x3f0/0x5c0
> >                                 sp=e00000012c077da0 bsp=e00000012c0710b0
> >  [<a0000001000dd3e0>] kthread+0x220/0x280
> >                                 sp=e00000012c077e10 bsp=e00000012c071068
> >  [<a0000001000181a0>] kernel_thread_helper+0xe0/0x100
> >                                 sp=e00000012c077e30 bsp=e00000012c071040

We found __mark_inode_dirty() was called by xfs_iunpin().
xfs_iunpin() sets I_DIRTY_SYNC on inode->i_state if i_pincount is 0.

If __mark_inode_dirty() is running simultaneously between
clear_inode() and BUG_ON() in generic_delete_inode(), BUG_ON() is
called. We think this is a cause of this bug.

All dirty buffers are invalidated by clear_inode(), but in-core log is
not deleted and the state will be inconsistent. The in-core log is
written by xfs_logd even if inode was already deleted. A cause of this
bug is xfs does not care in-core log after deleting the inode.

xfs_fs_clear_inode() calls xfs_reclaim(). We think the recent fixes to
xfs_iunpin() were not correct. With those patches, xfs_iunpin() now
can determine whether xfs_inode is recycled or not, but it is not
essential way to fix this bug. xfs_iunpin() must never touch xfs_inode
which is already freed. If try_to_free_page() collects some slabs
including pinned inode, it is possible to result in memory corruption.

We come up with three possible solutions:
1. xfs_fs_clear_inode() waits for i_pincount to become 0.
2. xfs_fs_clear_inode() syncs in-core log if i_pincount is not 0.
3. xfs_fs_clear_inode() invalidates in-core log that relates to the
deleted inode.

We chose 2, because the frequency of sync is almost same to as that of
BUG(), and it is the same way to sync in-core log in xfs_fsync() when
inode is still pinned. It has very very little effect for xfs performance.

This patch fixes to sync in-core log if i_pincount is not 0 in
xfs_fs_clear_inode(). We think this is essential.
We already tested this patch for more than 100 hours in kernel-2.6.18.
If we did not use this patch, BUG() was called within only 5 minutes
on 32way Itanium server.
We used a test program that repeats open(), write() and unlink() in
parallel.

Best Regards,
--
Takenori Nagano, NEC
t-nagano@ah.jp.nec.com

--------------030508040500000105030608
Content-Type: text/plain;
 name="xfs-fix-log-race.patch"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="xfs-fix-log-race.patch"

ZGlmZiAtTmFydSBsaW51eC0yLjYuMTgub3JpZy9mcy94ZnMvbGludXgtMi42
L3hmc19zdXBlci5jIGxpbnV4LTIuNi4xOC9mcy94ZnMvbGludXgtMi42L3hm
c19zdXBlci5jDQotLS0gbGludXgtMi42LjE4Lm9yaWcvZnMveGZzL2xpbnV4
LTIuNi94ZnNfc3VwZXIuYwkyMDA2LTA5LTIwIDEyOjQyOjA2LjAwMDAwMDAw
MCArMDkwMA0KKysrIGxpbnV4LTIuNi4xOC9mcy94ZnMvbGludXgtMi42L3hm
c19zdXBlci5jCTIwMDYtMDktMjggMTg6MTY6MDIuMjgwMDAwMDAwICswOTAw
DQpAQCAtNDMzLDYgKzQzMyw3IEBADQogCXN0cnVjdCBpbm9kZQkJKmlub2Rl
KQ0KIHsNCiAJYmh2X3Zub2RlX3QJCSp2cCA9IHZuX2Zyb21faW5vZGUoaW5v
ZGUpOw0KKwl4ZnNfaW5vZGVfdAkJKmlwOw0KIA0KIAl2bl90cmFjZV9lbnRy
eSh2cCwgX19GVU5DVElPTl9fLCAoaW5zdF90ICopX19yZXR1cm5fYWRkcmVz
cyk7DQogDQpAQCAtNDUyLDEwICs0NTMsMTQgQEANCiAJdnAtPnZfZmxhZyAm
PSB+Vk1PRElGSUVEOw0KIAlWTl9VTkxPQ0sodnAsIDApOw0KIA0KLQlpZiAo
Vk5IRUFEKHZwKSkNCisJaWYgKFZOSEVBRCh2cCkpIHsNCisJCWlwID0gWEZT
X0JIVlRPSShWTkhFQUQodnApKTsNCisJCWlmICh4ZnNfaXBpbmNvdW50KGlw
KSkgDQorCQkJeGZzX2xvZ19mb3JjZShpcC0+aV9tb3VudCwgKHhmc19sc25f
dCkwLA0KKwkJCQkgICAgICBYRlNfTE9HX0ZPUkNFIHwgWEZTX0xPR19TWU5D
KTsNCiAJCWlmIChiaHZfdm9wX3JlY2xhaW0odnApKQ0KIAkJCXBhbmljKCIl
czogY2Fubm90IHJlY2xhaW0gMHglcFxuIiwgX19GVU5DVElPTl9fLCB2cCk7
DQotDQorCX0NCiAJQVNTRVJUKFZOSEVBRCh2cCkgPT0gTlVMTCk7DQogDQog
I2lmZGVmIFhGU19WTk9ERV9UUkFDRQ0K

--------------030508040500000105030608--
