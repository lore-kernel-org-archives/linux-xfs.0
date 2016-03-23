Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 37A197CA0
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2016 04:44:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 571A6AC005
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2016 02:44:04 -0700 (PDT)
Received: from mail-oi0-f44.google.com (mail-oi0-f44.google.com
	[209.85.218.44]) by cuda.sgi.com with ESMTP id Oyky5ov6Gw5eHjVM
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 23 Mar 2016 02:43:59 -0700 (PDT)
Received: by mail-oi0-f44.google.com with SMTP id d205so12065109oia.0
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2016 02:43:59 -0700 (PDT)
From: Shyam Kaushik <shyam@zadarastorage.com>
References: <f049419a2ab10f8e3c4fef0e4f4ca1ba@mail.gmail.com>
	<20160322121922.GA53693@bfoster.bfoster>
	<6457b1d9de271ec6cca6bc2626aac161@mail.gmail.com>
	<20160322140345.GA54245@bfoster.bfoster>
In-Reply-To: <20160322140345.GA54245@bfoster.bfoster>
MIME-Version: 1.0
Date: Wed, 23 Mar 2016 15:13:57 +0530
Message-ID: <0f3832c45509f444f55fda2aaf9c9deb@mail.gmail.com>
Subject: RE: XFS hung task in xfs_ail_push_all_sync() when unmounting FS after
	disk failure/recovery
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
To: Brian Foster <bfoster@redhat.com>
Cc: Alex Lyakas <alex@zadarastorage.com>, xfs@oss.sgi.com

Hi Brian,

Here are two inodes on which the xfsaild is looping over & over during
unmount. This captures right from the cp that I started with copying some
files to xfs while the drive was pulled out, later drive was pushed back &
unmount was attempted. Does this give you better picture on the issue?
Please let me know if you prefer to do some other steps in the reproducer.

              cp-30344 [001] ...1  7474.284000: xfs_iget_miss: dev 253:11
ino 0x103c84a
              cp-30344 [001] ...2  7474.284000: xfs_ilock_nowait: dev
253:11 ino 0x103c84a flags ILOCK_EXCL caller xfs_iget [xfs]
              cp-30344 [001] ...1  7474.284004: xfs_dir2_block_addname:
dev 253:11 ino 0x103c839 name drop-append.gif namelen 15 hashval
0x23c66973 inumber 0x103c84a op_flags ADDNAME|OKNOENT
              cp-30344 [001] ...1  7474.284014: xfs_inode_pin: dev 253:11
ino 0x103c84a count 1 pincount 0 caller xfs_cil_prepare_item.isra.1 [xfs]
              cp-30344 [001] ...1  7474.284021: xfs_iunlock: dev 253:11
ino 0x103c84a flags ILOCK_EXCL caller xfs_inode_item_unlock [xfs]
              cp-30344 [001] ...1  7474.284028: xfs_getattr: dev 253:11
ino 0x103c84a
              cp-30344 [001] ...1  7474.284033: xfs_ilock: dev 253:11 ino
0x103c84a flags IOLOCK_EXCL caller xfs_file_buffered_aio_write.isra.9
[xfs]
              cp-30344 [001] ...1  7474.284034: xfs_file_buffered_write:
dev 253:11 ino 0x103c84a size 0x0 offset 0x0 count 0x3e9 ioflags
              cp-30344 [001] ...1  7474.284038: xfs_ilock: dev 253:11 ino
0x103c84a flags ILOCK_EXCL caller __xfs_get_blocks [xfs]
              cp-30344 [001] ...1  7474.284040: xfs_iext_insert: dev
253:11 ino 0x103c84a state  idx 0 offset 0 block 4503599627239429 count 1
flag 0 caller xfs_bmap_add_extent_hole_delay [xfs]
              cp-30344 [001] ...1  7474.284040: xfs_iunlock: dev 253:11
ino 0x103c84a flags ILOCK_EXCL caller __xfs_get_blocks [xfs]
              cp-30344 [001] ...1  7474.284041: xfs_get_blocks_alloc: dev
253:11 ino 0x103c84a size 0x0 offset 0x0 count 4096 type 0x0 startoff 0x0
startblock -1 blockcount 0x1
              cp-30344 [001] ...1  7474.284044: xfs_iunlock: dev 253:11
ino 0x103c84a flags IOLOCK_EXCL caller xfs_file_buffered_aio_write.isra.9
[xfs]
              cp-30344 [001] ...1  7474.284047: xfs_ilock: dev 253:11 ino
0x103c84a flags ILOCK_SHARED caller xfs_free_eofblocks [xfs]
              cp-30344 [001] ...1  7474.284048: xfs_iunlock: dev 253:11
ino 0x103c84a flags ILOCK_SHARED caller xfs_free_eofblocks [xfs]
              cp-30344 [001] ...1  7474.284048: xfs_ilock_nowait: dev
253:11 ino 0x103c84a flags IOLOCK_EXCL caller xfs_free_eofblocks [xfs]
              cp-30344 [001] ...1  7474.284051: xfs_ilock: dev 253:11 ino
0x103c84a flags ILOCK_EXCL caller xfs_free_eofblocks [xfs]
              cp-30344 [001] ...1  7474.284051:
xfs_itruncate_extents_start: dev 253:11 ino 0x103c84a size 0x0 new_size
0x3e9
              cp-30344 [001] ...1  7474.284052: xfs_bunmap: dev 253:11 ino
0x103c84a size 0x0 bno 0x1 len 0x8000000000000flags  caller
xfs_itruncate_extents [xfs]
              cp-30344 [001] ...1  7474.284055: xfs_itruncate_extents_end:
dev 253:11 ino 0x103c84a size 0x0 new_size 0x3e9
              cp-30344 [001] ...2  7474.284058:
xfs_inode_clear_eofblocks_tag: dev 253:11 ino 0x103c84a
              cp-30344 [001] ...1  7474.284059: xfs_iunlock: dev 253:11
ino 0x103c84a flags ILOCK_EXCL caller xfs_free_eofblocks [xfs]
              cp-30344 [001] ...1  7474.284060: xfs_iunlock: dev 253:11
ino 0x103c84a flags IOLOCK_EXCL caller xfs_free_eofblocks [xfs]
    kworker/0:1H-257   [000] ...1  7477.849984: xfs_inode_unpin: dev
253:11 ino 0x103c84a count 1 pincount 1 caller xfs_trans_committed_bulk
[xfs]
   xfsaild/dm-11-22098 [002] ...1  7484.461991: xfs_ilock_nowait: dev
253:11 ino 0x103c84a flags ILOCK_SHARED caller xfs_iflush_cluster [xfs]
   xfsaild/dm-11-22098 [002] ...1  7484.461991: xfs_iunlock: dev 253:11
ino 0x103c84a flags ILOCK_SHARED caller xfs_iflush_cluster [xfs]
   xfsaild/dm-11-22098 [002] ...2  7484.462174: xfs_ilock_nowait: dev
253:11 ino 0x103c84a flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7484.462174: xfs_iunlock: dev 253:11
ino 0x103c84a flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7514.831384: xfs_ilock_nowait: dev
253:11 ino 0x103c84a flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7514.831384: xfs_iunlock: dev 253:11
ino 0x103c84a flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7514.855242: xfs_ilock_nowait: dev
253:11 ino 0x103c84a flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7514.855242: xfs_iunlock: dev 253:11
ino 0x103c84a flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7514.876488: xfs_ilock_nowait: dev
253:11 ino 0x103c84a flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7514.876489: xfs_iunlock: dev 253:11
ino 0x103c84a flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7514.898474: xfs_ilock_nowait: dev
253:11 ino 0x103c84a flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7514.898474: xfs_iunlock: dev 253:11
ino 0x103c84a flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7514.920398: xfs_ilock_nowait: dev
253:11 ino 0x103c84a flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7514.920398: xfs_iunlock: dev 253:11
ino 0x103c84a flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7514.942246: xfs_ilock_nowait: dev
253:11 ino 0x103c84a flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7514.942246: xfs_iunlock: dev 253:11
ino 0x103c84a flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7514.963293: xfs_ilock_nowait: dev
253:11 ino 0x103c84a flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7514.963293: xfs_iunlock: dev 253:11
ino 0x103c84a flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7514.984229: xfs_ilock_nowait: dev
253:11 ino 0x103c84a flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7514.984229: xfs_iunlock: dev 253:11
ino 0x103c84a flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] .N.2  7515.005554: xfs_ilock_nowait: dev
253:11 ino 0x103c84a flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] .N.2  7515.005555: xfs_iunlock: dev 253:11
ino 0x103c84a flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7515.027267: xfs_ilock_nowait: dev
253:11 ino 0x103c84a flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7515.027267: xfs_iunlock: dev 253:11
ino 0x103c84a flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] .N.2  7515.048246: xfs_ilock_nowait: dev
253:11 ino 0x103c84a flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] .N.2  7515.048246: xfs_iunlock: dev 253:11
ino 0x103c84a flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7515.069222: xfs_ilock_nowait: dev
253:11 ino 0x103c84a flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   ....
   xfsaild/dm-11-22098 [002] ...2  7616.981090: xfs_iunlock: dev 253:11
ino 0x103c84a flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7617.032312: xfs_ilock_nowait: dev
253:11 ino 0x103c84a flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7617.032312: xfs_iunlock: dev 253:11
ino 0x103c84a flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7617.083162: xfs_ilock_nowait: dev
253:11 ino 0x103c84a flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7617.083163: xfs_iunlock: dev 253:11
ino 0x103c84a flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7617.134140: xfs_ilock_nowait: dev
253:11 ino 0x103c84a flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7617.134140: xfs_iunlock: dev 253:11
ino 0x103c84a flags ILOCK_SHARED caller xfs_inode_item_push [xfs]




              cp-30344 [001] ...1  7474.284111: xfs_iget_miss: dev 253:11
ino 0x103c84b
              cp-30344 [001] ...2  7474.284112: xfs_ilock_nowait: dev
253:11 ino 0x103c84b flags ILOCK_EXCL caller xfs_iget [xfs]
              cp-30344 [001] ...1  7474.284115: xfs_dir2_block_addname:
dev 253:11 ino 0x103c839 name s.gif namelen 5 hashval 0x35d9f4e1 inumber
0x103c84b op_flags ADDNAME|OKNOENT
              cp-30344 [001] ...1  7474.284126: xfs_inode_pin: dev 253:11
ino 0x103c84b count 1 pincount 0 caller xfs_cil_prepare_item.isra.1 [xfs]
              cp-30344 [001] ...1  7474.284133: xfs_iunlock: dev 253:11
ino 0x103c84b flags ILOCK_EXCL caller xfs_inode_item_unlock [xfs]
              cp-30344 [001] ...1  7474.284139: xfs_getattr: dev 253:11
ino 0x103c84b
              cp-30344 [001] ...1  7474.284145: xfs_ilock: dev 253:11 ino
0x103c84b flags IOLOCK_EXCL caller xfs_file_buffered_aio_write.isra.9
[xfs]
              cp-30344 [001] ...1  7474.284146: xfs_file_buffered_write:
dev 253:11 ino 0x103c84b size 0x0 offset 0x0 count 0x2b ioflags
              cp-30344 [001] ...1  7474.284153: xfs_ilock: dev 253:11 ino
0x103c84b flags ILOCK_EXCL caller __xfs_get_blocks [xfs]
              cp-30344 [001] ...1  7474.284155: xfs_iext_insert: dev
253:11 ino 0x103c84b state  idx 0 offset 0 block 4503599627239429 count 1
flag 0 caller xfs_bmap_add_extent_hole_delay [xfs]
              cp-30344 [001] ...1  7474.284156: xfs_iunlock: dev 253:11
ino 0x103c84b flags ILOCK_EXCL caller __xfs_get_blocks [xfs]
              cp-30344 [001] ...1  7474.284156: xfs_get_blocks_alloc: dev
253:11 ino 0x103c84b size 0x0 offset 0x0 count 4096 type 0x0 startoff 0x0
startblock -1 blockcount 0x1
              cp-30344 [001] ...1  7474.284159: xfs_iunlock: dev 253:11
ino 0x103c84b flags IOLOCK_EXCL caller xfs_file_buffered_aio_write.isra.9
[xfs]
              cp-30344 [001] ...1  7474.284162: xfs_ilock: dev 253:11 ino
0x103c84b flags ILOCK_SHARED caller xfs_free_eofblocks [xfs]
              cp-30344 [001] ...1  7474.284163: xfs_iunlock: dev 253:11
ino 0x103c84b flags ILOCK_SHARED caller xfs_free_eofblocks [xfs]
              cp-30344 [001] ...1  7474.284163: xfs_ilock_nowait: dev
253:11 ino 0x103c84b flags IOLOCK_EXCL caller xfs_free_eofblocks [xfs]
              cp-30344 [001] ...1  7474.284165: xfs_ilock: dev 253:11 ino
0x103c84b flags ILOCK_EXCL caller xfs_free_eofblocks [xfs]
              cp-30344 [001] ...1  7474.284165:
xfs_itruncate_extents_start: dev 253:11 ino 0x103c84b size 0x0 new_size
0x2b
              cp-30344 [001] ...1  7474.284166: xfs_bunmap: dev 253:11 ino
0x103c84b size 0x0 bno 0x1 len 0x8000000000000flags  caller
xfs_itruncate_extents [xfs]
              cp-30344 [001] ...1  7474.284169: xfs_itruncate_extents_end:
dev 253:11 ino 0x103c84b size 0x0 new_size 0x2b
              cp-30344 [001] ...2  7474.284172:
xfs_inode_clear_eofblocks_tag: dev 253:11 ino 0x103c84b
              cp-30344 [001] ...1  7474.284173: xfs_iunlock: dev 253:11
ino 0x103c84b flags ILOCK_EXCL caller xfs_free_eofblocks [xfs]
              cp-30344 [001] ...1  7474.284174: xfs_iunlock: dev 253:11
ino 0x103c84b flags IOLOCK_EXCL caller xfs_free_eofblocks [xfs]
    kworker/0:1H-257   [000] ...1  7477.849984: xfs_inode_unpin: dev
253:11 ino 0x103c84b count 1 pincount 1 caller xfs_trans_committed_bulk
[xfs]
   xfsaild/dm-11-22098 [002] ...1  7484.461992: xfs_ilock_nowait: dev
253:11 ino 0x103c84b flags ILOCK_SHARED caller xfs_iflush_cluster [xfs]
   xfsaild/dm-11-22098 [002] ...1  7484.461992: xfs_iunlock: dev 253:11
ino 0x103c84b flags ILOCK_SHARED caller xfs_iflush_cluster [xfs]
   xfsaild/dm-11-22098 [002] ...2  7484.462173: xfs_ilock_nowait: dev
253:11 ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7484.462173: xfs_iunlock: dev 253:11
ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7514.831382: xfs_ilock_nowait: dev
253:11 ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7514.831383: xfs_iunlock: dev 253:11
ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7514.855241: xfs_ilock_nowait: dev
253:11 ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7514.855241: xfs_iunlock: dev 253:11
ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7514.876487: xfs_ilock_nowait: dev
253:11 ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7514.876487: xfs_iunlock: dev 253:11
ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7514.898472: xfs_ilock_nowait: dev
253:11 ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7514.898473: xfs_iunlock: dev 253:11
ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7514.920396: xfs_ilock_nowait: dev
253:11 ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7514.920397: xfs_iunlock: dev 253:11
ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7514.942245: xfs_ilock_nowait: dev
253:11 ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7514.942245: xfs_iunlock: dev 253:11
ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7514.963292: xfs_ilock_nowait: dev
253:11 ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7514.963292: xfs_iunlock: dev 253:11
ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7514.984228: xfs_ilock_nowait: dev
253:11 ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7514.984228: xfs_iunlock: dev 253:11
ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] .N.2  7515.005553: xfs_ilock_nowait: dev
253:11 ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] .N.2  7515.005553: xfs_iunlock: dev 253:11
ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7515.027266: xfs_ilock_nowait: dev
253:11 ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7515.027266: xfs_iunlock: dev 253:11
ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] .N.2  7515.048245: xfs_ilock_nowait: dev
253:11 ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] .N.2  7515.048246: xfs_iunlock: dev 253:11
ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7515.069221: xfs_ilock_nowait: dev
253:11 ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7515.069221: xfs_iunlock: dev 253:11
ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7515.090315: xfs_ilock_nowait: dev
253:11 ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7515.090315: xfs_iunlock: dev 253:11
ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7515.111351: xfs_ilock_nowait: dev
253:11 ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7515.111351: xfs_iunlock: dev 253:11
ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   ....
   xfsaild/dm-11-22098 [002] ...2  7616.673429: xfs_ilock_nowait: dev
253:11 ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7616.673429: xfs_iunlock: dev 253:11
ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7616.725283: xfs_ilock_nowait: dev
253:11 ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7616.725283: xfs_iunlock: dev 253:11
ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7616.777260: xfs_ilock_nowait: dev
253:11 ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7616.777260: xfs_iunlock: dev 253:11
ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7616.828237: xfs_ilock_nowait: dev
253:11 ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7616.828237: xfs_iunlock: dev 253:11
ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] .N.2  7616.879318: xfs_ilock_nowait: dev
253:11 ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] .N.2  7616.879319: xfs_iunlock: dev 253:11
ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]

xfsaild was stuck towards the end like. The inode number varies, some of
which trace-buffer doesn't capture as with too many events, trace-buffer
lost several events.

   xfsaild/dm-11-22098 [001] ...2  7596.447019: xfs_ilock_nowait: dev
253:11 ino 0x6842bb6 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [001] ...2  7596.447020: xfs_iunlock: dev 253:11
ino 0x6842bb6 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [001] ...2  7596.447020: xfs_ail_flushing: dev
253:11 lip 0xffff880095382130 lsn 4/8128 type XFS_LI_INODE flags IN_AIL
   xfsaild/dm-11-22098 [001] ...2  7596.447020: xfs_ilock_nowait: dev
253:11 ino 0x6842bb4 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [001] ...2  7596.447020: xfs_iunlock: dev 253:11
ino 0x6842bb4 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [001] ...2  7596.447020: xfs_ail_flushing: dev
253:11 lip 0xffff880095382000 lsn 4/8128 type XFS_LI_INODE flags IN_AIL
   xfsaild/dm-11-22098 [001] ...2  7596.447021: xfs_ilock_nowait: dev
253:11 ino 0x58302e1 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [001] ...2  7596.447021: xfs_iunlock: dev 253:11
ino 0x58302e1 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [001] ...2  7596.447021: xfs_ail_flushing: dev
253:11 lip 0xffff880093623ed8 lsn 4/8128 type XFS_LI_INODE flags IN_AIL
   xfsaild/dm-11-22098 [001] ...2  7596.447021: xfs_ilock_nowait: dev
253:11 ino 0x6842bb3 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [001] ...2  7596.447022: xfs_iunlock: dev 253:11
ino 0x6842bb3 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [001] ...2  7596.447022: xfs_ail_flushing: dev
253:11 lip 0xffff8800334fded8 lsn 4/8128 type XFS_LI_INODE flags IN_AIL
   xfsaild/dm-11-22098 [001] ...2  7596.447022: xfs_ilock_nowait: dev
253:11 ino 0x6842bd1 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [001] ...2  7596.447022: xfs_iunlock: dev 253:11
ino 0x6842bd1 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   ....
   xfsaild/dm-11-22098 [002] ...2  7616.673429: xfs_ilock_nowait: dev
253:11 ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7616.673429: xfs_iunlock: dev 253:11
ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7616.725283: xfs_ilock_nowait: dev
253:11 ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7616.725283: xfs_iunlock: dev 253:11
ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7616.777260: xfs_ilock_nowait: dev
253:11 ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7616.777260: xfs_iunlock: dev 253:11
ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7616.828237: xfs_ilock_nowait: dev
253:11 ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] ...2  7616.828237: xfs_iunlock: dev 253:11
ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] .N.2  7616.879318: xfs_ilock_nowait: dev
253:11 ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
   xfsaild/dm-11-22098 [002] .N.2  7616.879319: xfs_iunlock: dev 253:11
ino 0x103c84b flags ILOCK_SHARED caller xfs_inode_item_push [xfs]

It will be hard for me to shift to a newer kernel. But if you say we are
left with no options to root cause this issue, I can attempt at this
direction. Pls let me know. Thanks.

--Shyam
-----Original Message-----
From: Brian Foster [mailto:bfoster@redhat.com]
Sent: 22 March 2016 19:34
To: Shyam Kaushik
Cc: Alex Lyakas; xfs@oss.sgi.com
Subject: Re: XFS hung task in xfs_ail_push_all_sync() when unmounting FS
after disk failure/recovery

On Tue, Mar 22, 2016 at 06:31:48PM +0530, Shyam Kaushik wrote:
> Hi Brian,
>
> Thanks for your quick reply. I repeated the test & trace-pipe is
> constantly filled with this:
>
>    xfsaild/dm-10-3335  [003] ...2 24890.546491: xfs_ilock_nowait: dev
> 253:10 ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
>    xfsaild/dm-10-3335  [003] ...2 24890.546492: xfs_iunlock: dev 253:10
> ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
>    xfsaild/dm-10-3335  [003] ...2 24890.546493: xfs_ail_flushing: dev
> 253:10 lip 0xffff8800a9f437b8 lsn 1/38624 type XFS_LI_INODE flags IN_AIL
>    xfsaild/dm-10-3335  [003] ...2 24890.596491: xfs_ilock_nowait: dev
> 253:10 ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
>    xfsaild/dm-10-3335  [003] ...2 24890.596492: xfs_iunlock: dev 253:10
> ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
>    xfsaild/dm-10-3335  [003] ...2 24890.596494: xfs_ail_flushing: dev
> 253:10 lip 0xffff8800a9f437b8 lsn 1/38624 type XFS_LI_INODE flags IN_AIL
>    xfsaild/dm-10-3335  [003] ...2 24890.646497: xfs_ilock_nowait: dev
> 253:10 ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
>    xfsaild/dm-10-3335  [003] ...2 24890.646498: xfs_iunlock: dev 253:10
> ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
>    xfsaild/dm-10-3335  [003] ...2 24890.646500: xfs_ail_flushing: dev
> 253:10 lip 0xffff8800a9f437b8 lsn 1/38624 type XFS_LI_INODE flags IN_AIL
>    xfsaild/dm-10-3335  [003] ...2 24890.696467: xfs_ilock_nowait: dev
> 253:10 ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
>    xfsaild/dm-10-3335  [003] ...2 24890.696468: xfs_iunlock: dev 253:10
> ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
>    xfsaild/dm-10-3335  [003] ...2 24890.696468: xfs_ail_flushing: dev
> 253:10 lip 0xffff8800a9f437b8 lsn 1/38624 type XFS_LI_INODE flags IN_AIL
>    xfsaild/dm-10-3335  [003] ...2 24890.746548: xfs_ilock_nowait: dev
> 253:10 ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
>    xfsaild/dm-10-3335  [003] ...2 24890.746550: xfs_iunlock: dev 253:10
> ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
>    xfsaild/dm-10-3335  [003] ...2 24890.746550: xfs_ail_flushing: dev
> 253:10 lip 0xffff8800a9f437b8 lsn 1/38624 type XFS_LI_INODE flags IN_AIL
>    xfsaild/dm-10-3335  [003] ...2 24890.796479: xfs_ilock_nowait: dev
> 253:10 ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
>    xfsaild/dm-10-3335  [003] ...2 24890.796480: xfs_iunlock: dev 253:10
> ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
>    xfsaild/dm-10-3335  [003] ...2 24890.796480: xfs_ail_flushing: dev
> 253:10 lip 0xffff8800a9f437b8 lsn 1/38624 type XFS_LI_INODE flags IN_AIL
>    xfsaild/dm-10-3335  [003] ...2 24890.846467: xfs_ilock_nowait: dev
> 253:10 ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
>    xfsaild/dm-10-3335  [003] ...2 24890.846468: xfs_iunlock: dev 253:10
> ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
>

So xfsaild is spinning on this inode. It was presumably modified, logged
and flushed to the log, hence it's sitting in the AIL waiting to be
flushed to disk. xfsaild wants to push it to get it flushed to disk and
off the AIL, but it sees it is already in the flushing state as the
flush lock is held.

It's not clear to me why the inode is not removed from the AIL, or
whether that I/O was actually submitted or aborted with an error. The
shutdown involved here most likely affects this one way or the other.
IIUC, the I/O completion should eventually release the flush lock and
remove the inode from the AIL. A complete trace log of the entire
reproducer might shed more light as to what's going on.

Also, it sounds like you have a reliable reproducer. Does this reproduce
on a recent kernel?

Brian

>
> while regular activity seems to happen on other inodes/kworker threads
>
>     kworker/u8:4-27691 [001] ...1 24895.811474: xfs_writepage: dev
253:10
> ino 0x1801061 pgoff 0x29000 size 0x1aebbc offset 0 length 0 delalloc 1
> unwritten 0
>     kworker/u8:4-27691 [001] ...1 24895.811477: xfs_invalidatepage: dev
> 253:10 ino 0x1801061 pgoff 0x29000 size 0x1aebbc offset 0 length 1000
> delalloc 1 unwritten 0
>     kworker/u8:4-27691 [001] ...1 24895.811478: xfs_releasepage: dev
> 253:10 ino 0x1801061 pgoff 0x29000 size 0x1aebbc offset 0 length 0
> delalloc 0 unwritten 0
>     kworker/u8:4-27691 [001] ...1 24895.811482: xfs_writepage: dev
253:10
> ino 0x4017bdf pgoff 0x29000 size 0x1aebbc offset 0 length 0 delalloc 1
> unwritten 0
>     kworker/u8:4-27691 [001] ...1 24895.811482: xfs_invalidatepage: dev
> 253:10 ino 0x4017bdf pgoff 0x29000 size 0x1aebbc offset 0 length 1000
> delalloc 1 unwritten 0
>     kworker/u8:4-27691 [001] ...1 24895.811483: xfs_releasepage: dev
> 253:10 ino 0x4017bdf pgoff 0x29000 size 0x1aebbc offset 0 length 0
> delalloc 0 unwritten 0
>     kworker/u8:4-27691 [001] ...1 24895.811485: xfs_writepage: dev
253:10
> ino 0x68048c3 pgoff 0x29000 size 0x1aebbc offset 0 length 0 delalloc 1
> unwritten 0
>     kworker/u8:4-27691 [001] ...1 24895.811486: xfs_invalidatepage: dev
> 253:10 ino 0x68048c3 pgoff 0x29000 size 0x1aebbc offset 0 length 1000
> delalloc 1 unwritten 0
>     kworker/u8:4-27691 [001] ...1 24895.811486: xfs_releasepage: dev
> 253:10 ino 0x68048c3 pgoff 0x29000 size 0x1aebbc offset 0 length 0
> delalloc 0 unwritten 0
>     kworker/u8:4-27691 [001] ...1 24895.812381: xfs_writepage: dev
253:10
> ino 0x1805e37 pgoff 0x29000 size 0x68470 offset 0 length 0 delalloc 1
> unwritten 0
>     kworker/u8:4-27691 [001] ...1 24895.812382: xfs_invalidatepage: dev
> 253:10 ino 0x1805e37 pgoff 0x29000 size 0x68470 offset 0 length 1000
> delalloc 1 unwritten 0
>     kworker/u8:4-27691 [001] ...1 24895.812382: xfs_releasepage: dev
> 253:10 ino 0x1805e37 pgoff 0x29000 size 0x68470 offset 0 length 0
delalloc
> 0 unwritten 0
>     kworker/u8:4-27691 [001] ...1 24895.812385: xfs_writepage: dev
253:10
> ino 0x4019c95 pgoff 0x29000 size 0x68470 offset 0 length 0 delalloc 1
> unwritten 0
>     kworker/u8:4-27691 [001] ...1 24895.812385: xfs_invalidatepage: dev
> 253:10 ino 0x4019c95 pgoff 0x29000 size 0x68470 offset 0 length 1000
> delalloc 1 unwritten 0
>
>
> looks like xfsaild is not able to take lock until hung-task timeout
kicks
> in
>
>    xfsaild/dm-10-3335  [003] ...2 25247.649468: xfs_ilock_nowait: dev
> 253:10 ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
>    xfsaild/dm-10-3335  [003] ...2 25247.649469: xfs_iunlock: dev 253:10
> ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
>    xfsaild/dm-10-3335  [003] ...2 25247.649469: xfs_ail_flushing: dev
> 253:10 lip 0xffff8800a9f437b8 lsn 1/38624 type XFS_LI_INODE flags IN_AIL
>    xfsaild/dm-10-3335  [003] ...2 25247.699478: xfs_ilock_nowait: dev
> 253:10 ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
>    xfsaild/dm-10-3335  [003] ...2 25247.699516: xfs_iunlock: dev 253:10
> ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
>    xfsaild/dm-10-3335  [003] ...2 25247.699517: xfs_ail_flushing: dev
> 253:10 lip 0xffff8800a9f437b8 lsn 1/38624 type XFS_LI_INODE flags IN_AIL
>    xfsaild/dm-10-3335  [003] ...2 25247.749471: xfs_ilock_nowait: dev
> 253:10 ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
>    xfsaild/dm-10-3335  [003] ...2 25247.749478: xfs_iunlock: dev 253:10
> ino 0xc0 flags ILOCK_SHARED caller xfs_inode_item_push [xfs]
>    xfsaild/dm-10-3335  [003] ...2 25247.749479: xfs_ail_flushing: dev
> 253:10 lip 0xffff8800a9f437b8 lsn 1/38624 type XFS_LI_INODE flags IN_AIL
>
> Please let me know how to debug this further. Thanks.
>
> --Shyam
> -----Original Message-----
> From: Brian Foster [mailto:bfoster@redhat.com]
> Sent: 22 March 2016 17:49
> To: Shyam Kaushik
> Cc: xfs@oss.sgi.com; Alex Lyakas
> Subject: Re: XFS hung task in xfs_ail_push_all_sync() when unmounting FS
> after disk failure/recovery
>
> On Tue, Mar 22, 2016 at 04:51:39PM +0530, Shyam Kaushik wrote:
> > Hi XFS developers,
> >
> > We are seeing the following issue with XFS on kernel 3.18.19.
> >
> > We have XFS mounted over a raw disk. Disk was pulled out manually.
There
> > were async writes on files that were errored like this
> >
> ...
> >
> > And XFS hit metadata & Log IO errors that it decides to shutdown:
> >
> > Mar 16 16:03:22 host0 kernel: [ 4637.351841] XFS (dm-29): metadata I/O
> > error: block 0x3a27fbd0 ("xlog_iodone") error 5 numblks 64
> > Mar 16 16:03:22 host0 kernel: [ 4637.352820] XFS(dm-29): SHUTDOWN!!!
> > old_flags=0x0 new_flags=0x2
> > Mar 16 16:03:22 host0 kernel: [ 4637.353187] XFS (dm-29): Log I/O
Error
> > Detected.  Shutting down filesystem
> ...
> > Later the drive was re-inserted back. After the drive was re-inserted,
> XFS
> > was attempted to be unmounted
> >
> > Mar 16 16:16:53 host0 controld: [2557] [     ] umount[202]
> > : umount(/sdisk/vol5b0, xfs)
> >
> > But nothing happens except for the 30-secs xfs_log_force errors that
> keeps
> > repeating
> >
> ...
> >
> > This problem doesn't happen consistently, but happens periodically
with
> a
> > drive failure/recovery followed by XFS unmount. I couldn't find this
> issue
> > fixed in later kernels. Can you please suggest how I can debug this
> issue
> > further?
> >
>
> Similar problems have been reproduced due to racy/incorrect EFI/EFD
> object tracking, which are internal data structures associated with
> freeing extents.
>
> What happens if you enable tracepoints while the fs is in this hung
> unmount state?
>
> # trace-cmd start -e "xfs:*"
> # cat /sys/kernel/debug/tracing/trace_pipe
>
> Brian
>
> > Thanks!
> >
> > --Shyam
> >
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
