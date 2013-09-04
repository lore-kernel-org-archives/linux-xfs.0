Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B6EC47F53
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 08:39:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9DA898F8039
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 06:39:50 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id H7sH2BFEWsGSFXOA for <xfs@oss.sgi.com>;
	Wed, 04 Sep 2013 06:39:49 -0700 (PDT)
Message-ID: <52273823.6050704@sandeen.net>
Date: Wed, 04 Sep 2013 08:39:47 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair segfaulting in phase 3
References: <trinity-9e6d7620-812f-48a7-9a7e-3098368ff59a-1376307533158@3capp-gmx-bs36>
In-Reply-To: <trinity-9e6d7620-812f-48a7-9a7e-3098368ff59a-1376307533158@3capp-gmx-bs36>
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
To: Jan Yves Brueckner <jyb@gmx.com>
Cc: xfs@oss.sgi.com

On 8/12/13 6:38 AM, Jan Yves Brueckner wrote:
> Hi there,
> 
> as in previous posts we've got a problem in repair/dir2.c after a
> xfs_repair -L -m 60000 segfaulting reproducibly at the very same
> point of recovery;
> 
> I did the initial repair with debianish 2.9.8 (some patches applied);
> then upgrading to latest stable 3.1.11 where the problem persists.
> 
> 3.1.11 when compiled w/o optimization and run with gdb however
> segfaulted in libpthread so I repeated with an -O0 of 2.9.8 to get
> the debugging information:
> 

Jan - 3 bugfixes into this, and I can get repair to complete w/o
a segv.  However, the fs is still not fully repaired.
Nor is it fully repaired after the 2nd pass, etc etc.  :(

So you may have contributed a bit to xfs_repair stability
by uncovering this, but I'm not sure I will be able to contribute
to recovery of your (apparently _severely_ damaged) filesystem.

:(

-Eric

> corrupt block 35 in directory inode 39869938
> 
> will junk block
> 
> corrupt block 51 in directory inode 39869938
> 
> will junk block
> 
> 
> 
> Program received signal SIGSEGV, Segmentation fault.
> 
> [Switching to Thread 0x7fcd982ae730 (LWP 19563)]
> 
> 0x0000000000419428 in verify_dir2_path (mp=0x7ffff8381580,
> cursor=0x7ffff8380f10, p_level=0) at dir2.c:619
> 
> 619             node = cursor->level[this_level].bp->data;
> 
> (gdb) info locals
> 
> node = (xfs_da_intnode_t *) 0x7ffff8380e94
> 
> newnode = (xfs_da_intnode_t *) 0x52202867f8380de0
> 
> dabno = 0
> 
> bp = (xfs_dabuf_t *) 0x80000200000001
> 
> bad = -474527744
> 
> entry = 0
> 
> this_level = 1
> 
> bmp = (bmap_ext_t *) 0x1
> 
> nex = 134250496
> 
> lbmp = {startoff = 8459390528, startblock = 72058695280238674,
> blockcount = 140737357811264, flag = 4309438}
> 
> __PRETTY_FUNCTION__ = "verify_dir2_path"
> 
> (gdb)
> 
> 
> 
> (gdb) bt
> 
> #0  0x0000000000419428 in verify_dir2_path (mp=0x7ffff8381580,
> cursor=0x7ffff8380f10, p_level=0) at dir2.c:619
> 
> #1  0x000000000041c441 in process_leaf_level_dir2 (mp=0x7ffff8381580,
> da_cursor=0x7ffff8380f10, repair=0x7ffff8381134)
> 
> at dir2.c:1899
> 
> #2  0x000000000041c61e in process_node_dir2 (mp=0x7ffff8381580,
> ino=39869938, dip=0x7fc9e2b38000, blkmap=0x7fca249ffd40,
> 
> repair=0x7ffff8381134) at dir2.c:1979
> 
> #3  0x000000000041c8cf in process_leaf_node_dir2 (mp=0x7ffff8381580,
> ino=39869938, dip=0x7fc9e2b38000, ino_discovery=1,
> 
> dirname=0x4911f6 "", parent=0x7ffff8381398, blkmap=0x7fca249ffd40,
> dot=0x7ffff838113c, dotdot=0x7ffff8381138,
> 
> repair=0x7ffff8381134, isnode=1) at dir2.c:2059
> 
> #4  0x000000000041cb33 in process_dir2 (mp=0x7ffff8381580,
> ino=39869938, dip=0x7fc9e2b38000, ino_discovery=1,
> 
> dino_dirty=0x7ffff8381390, dirname=0x4911f6 "",
> parent=0x7ffff8381398, blkmap=0x7fca249ffd40) at dir2.c:2113
> 
> #5  0x00000000004127ac in process_dinode_int (mp=0x7ffff8381580,
> dino=0x7fc9e2b38000, agno=0, ino=39869938, was_free=0,
> 
> dirty=0x7ffff8381390, cleared=0x7ffff838138c, used=0x7ffff8381394,
> verify_mode=0, uncertain=0, ino_discovery=1,
> 
> check_dups=0, extra_attr_check=1, isa_dir=0x7ffff8381388,
> parent=0x7ffff8381398) at dinode.c:2783
> 
> #6  0x0000000000412d94 in process_dinode (mp=0x7ffff8381580,
> dino=0x7fc9e2b38000, agno=0, ino=39869938, was_free=0,
> 
> dirty=0x7ffff8381390, cleared=0x7ffff838138c, used=0x7ffff8381394,
> ino_discovery=1, check_dups=0, extra_attr_check=1,
> 
> isa_dir=0x7ffff8381388, parent=0x7ffff8381398) at dinode.c:3017
> 
> #7  0x000000000040b607 in process_inode_chunk (mp=0x7ffff8381580,
> agno=0, num_inos=64, first_irec=0x751c810, ino_discovery=1,
> 
> check_dups=0, extra_attr_check=1, bogus=0x7ffff8381430) at
> dino_chunks.c:778
> 
> #8  0x000000000040bf46 in process_aginodes (mp=0x7ffff8381580,
> pf_args=0x75e6810, agno=0, ino_discovery=1, check_dups=0,
> 
> extra_attr_check=1) at dino_chunks.c:1025
> 
> #9  0x0000000000421db3 in process_ag_func (wq=0x1fe3790, agno=0,
> arg=0x75e6810) at phase3.c:162
> 
> #10 0x0000000000421f84 in process_ags (mp=0x7ffff8381580) at
> phase3.c:201
> 
> #11 0x00000000004220aa in phase3 (mp=0x7ffff8381580) at phase3.c:240
> 
> #12 0x000000000043bec4 in main (argc=5, argv=0x7ffff83818c8) at
> xfs_repair.c:697
> 
> 
> 
> 
> 
> I'll get the metadump on request.
> 
> 
> 
> 
> 
> Thanks for helping,
> 
> 
> 
> Jan
> 
> 
> 
> _______________________________________________ xfs mailing list 
> xfs@oss.sgi.com http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
