Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 May 2008 06:47:55 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4TDlpQQ010229
	for <xfs@oss.sgi.com>; Thu, 29 May 2008 06:47:52 -0700
Received: from sargon.lncsa.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4C5171CB3E0
	for <xfs@oss.sgi.com>; Thu, 29 May 2008 06:48:43 -0700 (PDT)
Received: from sargon.lncsa.com (sargon.lncsa.com [212.99.8.251]) by cuda.sgi.com with ESMTP id 6waRAXrv2sV2m8N1 for <xfs@oss.sgi.com>; Thu, 29 May 2008 06:48:43 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by sargon.lncsa.com (Postfix) with ESMTP id 3A3693065E16
	for <xfs@oss.sgi.com>; Thu, 29 May 2008 15:48:42 +0200 (CEST)
Received: from sargon.lncsa.com ([127.0.0.1])
	by localhost (sargon.lncsa.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TIQxwNQ0w30q for <xfs@oss.sgi.com>;
	Thu, 29 May 2008 15:48:42 +0200 (CEST)
Received: from zenon.apartia.fr (zenon.apartia.fr [10.0.3.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "zenon.apartia.fr", Issuer "ca.apartia.fr" (verified OK))
	by sargon.lncsa.com (Postfix) with ESMTP id 0B40B302A203
	for <xfs@oss.sgi.com>; Thu, 29 May 2008 15:48:42 +0200 (CEST)
Date: Thu, 29 May 2008 15:48:38 +0200
From: Louis-David Mitterrand <vindex+lists-xfs@apartia.org>
Subject: XFS internal error XFS_WANT_CORRUPTED_GOTO
Message-ID: <20080529134837.GA4241@apartia.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

I found this in a server's dmesg:

	XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4518 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffff803fc46b
	Pid: 28612, comm: rsync Not tainted 2.6.25.4-1-pyrrhus64 #1

	Call Trace:
	 [<ffffffff803fc46b>] xfs_iread_extents+0xac/0xc8
	 [<ffffffff803dd413>] xfs_bmap_read_extents+0x328/0x34b
	 [<ffffffff803fc46b>] xfs_iread_extents+0xac/0xc8
	 [<ffffffff803dc279>] xfs_bmap_last_offset+0x91/0xd5
	 [<ffffffff803ebb3a>] xfs_dir2_isblock+0x19/0x4a
	 [<ffffffff803e9084>] xfs_da_brelse+0x70/0x9d
	 [<ffffffff803ec1fe>] xfs_dir_lookup+0xb9/0x12b
	 [<ffffffff803d690b>] xfs_attr_leaf_get+0x76/0x99
	 [<ffffffff807c10a3>] __down_write_nested+0x12/0x93
	 [<ffffffff8040f898>] xfs_dir_lookup_int+0x2c/0xc3
	 [<ffffffff803f9730>] xfs_ilock+0x4c/0x70
	 [<ffffffff80411c7c>] xfs_lookup+0x44/0x70
	 [<ffffffff8041c991>] xfs_vn_lookup+0x29/0x5f
	 [<ffffffff8027a641>] do_lookup+0xc5/0x1af
	 [<ffffffff8027c321>] __link_path_walk+0x874/0xd1e
	 [<ffffffff8028583c>] file_update_time+0x30/0xd4
	 [<ffffffff8027c828>] path_walk+0x5d/0xba
	 [<ffffffff8027cb2b>] do_path_lookup+0x14c/0x16f
	 [<ffffffff8027b897>] getname+0x140/0x181
	 [<ffffffff8027d34a>] __user_walk_fd+0x37/0x53
	 [<ffffffff802765b1>] vfs_lstat_fd+0x18/0x47
	 [<ffffffff8022a6e9>] hrtick_set+0x88/0xf6
	 [<ffffffff807c0189>] thread_return+0x68/0xac
	 [<ffffffff802767a3>] sys_newlstat+0x19/0x31
	 [<ffffffff80274492>] sys_write+0x45/0x6e
	 [<ffffffff8020af3b>] system_call_after_swapgs+0x7b/0x80
