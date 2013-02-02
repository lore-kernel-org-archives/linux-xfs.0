Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 32D377F50
	for <xfs@oss.sgi.com>; Sat,  2 Feb 2013 13:20:14 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1EBD130404E
	for <xfs@oss.sgi.com>; Sat,  2 Feb 2013 11:20:11 -0800 (PST)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by
	cuda.sgi.com with ESMTP id RVpjvFyUS7MWA8Pa (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 02 Feb 2013 11:20:09 -0800 (PST)
Date: Sat, 2 Feb 2013 20:20:07 +0100
From: Andi Kleen <andi@firstfloor.org>
Subject: xfs deadlock on buffer semaphore while reading directory
Message-ID: <20130202192007.GS30577@one.firstfloor.org>
Mime-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


On a older 3.6-rc9 opensuse kernel I had the following deadlock with
a "find" running on a USB hard disk. I first thought it was some 
IO request getting stuck from another process (USB can be flakey),
but after looking through sysrq-t there is nothing else active
in XFS. So looks like some kind of XFS race or deadlock?

-Andi

[233265.161582] find            D ffff88042a8e4820     0 17774      1
0x00000004
[233265.161586]  ffff880212ad36c8 0000000000000086 0000000000000000
ffff880212ad3fd8
[233265.161590]  ffff880212ad3fd8 000000000000a000 ffff88042d9596c0
ffff88042a8e4440
[233265.161593]  00000000000128c0 ffff88042a192a00 ffff88042a192a00
0000000000000000
[233265.161596] Call Trace:
[233265.161606]  [<ffffffff81531eec>] ? __schedule+0x3fc/0x8c0
[233265.161610]  [<ffffffff8110a1c0>] ?
get_page_from_freelist+0x170/0x310
[233265.161628]  [<ffffffffa06207e3>] ? _xfs_buf_find+0xe3/0x240 [xfs]
[233265.161632]  [<ffffffff81532469>] schedule+0x29/0x70
[233265.161635]  [<ffffffff815308c5>] schedule_timeout+0x1d5/0x230
[233265.161638]  [<ffffffff8110a9d5>] ?
__alloc_pages_nodemask+0xe5/0x7e0
[233265.161650]  [<ffffffffa06207e3>] ? _xfs_buf_find+0xe3/0x240 [xfs]
[233265.161654]  [<ffffffff815314c1>] __down+0x6a/0x97
[233265.161657]  [<ffffffff81065ee1>] down+0x41/0x50
[233265.161669]  [<ffffffffa0620634>] xfs_buf_lock+0x44/0x110 [xfs]
[233265.161680]  [<ffffffffa06207e3>] _xfs_buf_find+0xe3/0x240 [xfs]
[233265.161692]  [<ffffffffa0620ba1>] xfs_buf_get_map+0x171/0x1b0 [xfs]
[233265.161703]  [<ffffffffa06218fd>] xfs_buf_read_map+0x2d/0x110 [xfs]
[233265.161739]  [<ffffffffa06550c9>] ? xfs_dabuf_map.isra.2+0x239/0x250
[xfs]
[233265.161759]  [<ffffffffa067c3f5>] xfs_trans_read_buf_map+0x265/0x480
[xfs]
[233265.161776]  [<ffffffffa0656486>] xfs_da_read_buf+0xc6/0x1f0 [xfs]
[233265.161787]  [<ffffffffa06202de>] ? xfs_buf_rele+0x4e/0x130 [xfs]
[233265.161799]  [<ffffffffa062096d>] ? xfs_buf_unlock+0x2d/0xa0 [xfs]
[233265.161814]  [<ffffffffa0657893>] xfs_da_node_lookup_int+0xa3/0x2c0
[xfs]
[233265.161830]  [<ffffffffa0660161>] xfs_dir2_node_lookup+0x51/0x170
[xfs]
[233265.161845]  [<ffffffffa0658b86>] ? xfs_dir2_isleaf+0x26/0x60 [xfs]
[233265.161860]  [<ffffffffa065911d>] xfs_dir_lookup+0x15d/0x170 [xfs]
[233265.161874]  [<ffffffffa063488f>] xfs_lookup+0xcf/0x130 [xfs]
[233265.161887]  [<ffffffffa062b9d1>] xfs_vn_lookup+0x51/0x90 [xfs]
[233265.161891]  [<ffffffff81159a8b>] ? lookup_dcache+0xab/0xd0
[233265.161894]  [<ffffffff8115952d>] lookup_real+0x1d/0x60
[233265.161898]  [<ffffffff81159ae8>] __lookup_hash+0x38/0x50
[233265.161901]  [<ffffffff8115a7ee>] lookup_slow+0x4e/0xc0
[233265.161904]  [<ffffffff8115c7ef>] path_lookupat+0x73f/0x790
[233265.161908]  [<ffffffff8115c871>] do_path_lookup+0x31/0xc0
[233265.161911]  [<ffffffff8115eb69>] user_path_at_empty+0x59/0xa0
[233265.161915]  [<ffffffff8116c879>] ? mntput_no_expire+0x49/0x160
[233265.161918]  [<ffffffff811535d7>] ? cp_new_stat+0x107/0x120
[233265.161921]  [<ffffffff8115ebc1>] user_path_at+0x11/0x20
[233265.161924]  [<ffffffff811537ba>] vfs_fstatat+0x3a/0x70
[233265.161927]  [<ffffffff811539ea>] sys_newfstatat+0x1a/0x40
[233265.161930]  [<ffffffff8153b712>] system_call_fastpath+0x16/0x1b


-- 
ak@linux.intel.com -- Speaking for myself only.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
