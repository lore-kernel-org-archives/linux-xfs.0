Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Dec 2007 10:28:00 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBBIRtse009039
	for <xfs@oss.sgi.com>; Tue, 11 Dec 2007 10:27:56 -0800
Received: from mail.ukfsn.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C62C3B33EA3
	for <xfs@oss.sgi.com>; Tue, 11 Dec 2007 10:28:03 -0800 (PST)
Received: from mail.ukfsn.org (s2.ukfsn.org [217.158.120.143]) by cuda.sgi.com with ESMTP id 4FnMeQq8gQesLcAj for <xfs@oss.sgi.com>; Tue, 11 Dec 2007 10:28:03 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by mail.ukfsn.org (Postfix) with ESMTP id 01D19DF073
	for <xfs@oss.sgi.com>; Tue, 11 Dec 2007 18:28:47 +0000 (GMT)
Received: from mail.ukfsn.org ([127.0.0.1])
	by localhost (smtp-filter.ukfsn.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XwnWAqdnny6l for <xfs@oss.sgi.com>;
	Tue, 11 Dec 2007 18:28:47 +0000 (GMT)
Received: from elm.dgreaves.com (i-83-67-36-194.freedom2surf.net [83.67.36.194])
	by mail.ukfsn.org (Postfix) with ESMTP id 5B9D3DF3E0
	for <xfs@oss.sgi.com>; Tue, 11 Dec 2007 18:28:21 +0000 (GMT)
Received: from ash.dgreaves.com ([10.0.0.90])
	by elm.dgreaves.com with esmtp (Exim 4.62)
	(envelope-from <david@dgreaves.com>)
	id 1J29ol-0002Zh-KQ
	for xfs@oss.sgi.com; Tue, 11 Dec 2007 18:26:55 +0000
Message-ID: <475ED66F.40800@dgreaves.com>
Date: Tue, 11 Dec 2007 18:26:55 +0000
From: David Greaves <david@dgreaves.com>
MIME-Version: 1.0
Subject: XFS internal error xfs_btree_check_sblock 
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi

I've been having problems with this filesystem for a while now.

I upgraded to 2.6.23 to see if it's improved (no).

Once every 2 or 3 cold boots I get this in dmesg as the user logs in and
accesses the /scratch filesystem. If the error doesn't occur as the user logs in
then it won't happen at all.

Filesystem "dm-0": XFS internal error xfs_btree_check_sblock at line 334 of file
fs/xfs/xfs_btree.c.  Caller 0xc01b7bc1
 [<c010511a>] show_trace_log_lvl+0x1a/0x30
 [<c0105d72>] show_trace+0x12/0x20
 [<c0105d95>] dump_stack+0x15/0x20
 [<c01dd34f>] xfs_error_report+0x4f/0x60
 [<c01cfcb6>] xfs_btree_check_sblock+0x56/0xd0
 [<c01b7bc1>] xfs_alloc_lookup+0x181/0x390
 [<c01b7e23>] xfs_alloc_lookup_eq+0x13/0x20
 [<c01b5594>] xfs_free_ag_extent+0x2f4/0x690
 [<c01b7164>] xfs_free_extent+0xb4/0xd0
 [<c01c1979>] xfs_bmap_finish+0x119/0x170
 [<c0209aa7>] xfs_remove+0x247/0x4f0
 [<c0211cc2>] xfs_vn_unlink+0x22/0x50
 [<c0172f28>] vfs_unlink+0x68/0xa0
 [<c01751e9>] do_unlinkat+0xb9/0x140
 [<c0175280>] sys_unlink+0x10/0x20
 [<c010420a>] syscall_call+0x7/0xb
 =======================
xfs_force_shutdown(dm-0,0x8) called from line 4274 of file fs/xfs/xfs_bmap.c.
Return address = 0xc0214dae
Filesystem "dm-0": Corruption of in-memory data detected.  Shutting down
filesystem: dm-0
Please umount the filesystem, and rectify the problem(s)

I ssh in as root, umount, mount, umount and run xfs_repair.

This is what I got this time:

Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
ir_freecount/free mismatch, inode chunk 59/5027968, freecount 27 nfree 26
        - found root inode chunk

All the rest was clean.

It is possible this fs suffered in the 2.6.17 timeframe
It is also possible something got broken whilst I was having lots of issues with
 hibernate (which is still unreliable).

I wonder if the fs is borked and xfs_repair isn't fixing it?

David
PS Please cc on replies.
