Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 83EA87F98
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 06:39:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 47D028F8049
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 04:38:57 -0700 (PDT)
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21]) by cuda.sgi.com
	with ESMTP id QnfyIYFtfN0mJ9kC (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 04:38:55 -0700 (PDT)
Received: from 3capp-gmx-bs36.server.lan ([172.19.170.88]) by
	mrigmx.server.lan (mrigmx001) with ESMTP (Nemesis) id
	0Le7py-1Vu3Jx1T5Q-00puuW for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 13:38:53 +0200
MIME-Version: 1.0
Message-ID: <trinity-9e6d7620-812f-48a7-9a7e-3098368ff59a-1376307533158@3capp-gmx-bs36>
From: "Jan Yves Brueckner" <jyb@gmx.com>
Subject: xfs_repair segfaulting in phase 3
Date: Mon, 12 Aug 2013 13:38:53 +0200 (CEST)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6814832771473405063=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============6814832771473405063==
Content-Type: text/html; charset=UTF-8

<html><head></head><body><div style="font-family: Verdana;font-size: 12.0px;"><div>Hi there,</div>

<div>&nbsp;</div>

<div>as in previous posts we&#39;ve got a problem in repair/dir2.c after a xfs_repair -L -m 60000 segfaulting reproducibly at the very same point of recovery;&nbsp;</div>

<div>&nbsp;</div>

<div>I did the initial repair with debianish 2.9.8 (some patches applied); then upgrading to latest stable 3.1.11 where the problem persists.&nbsp;</div>

<div>&nbsp;</div>

<div>3.1.11 when compiled w/o optimization and run with gdb however segfaulted in libpthread so I repeated with an -O0 of 2.9.8 to get the debugging information:</div>

<div>&nbsp;</div>

<div>
<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">corrupt block 35 in directory inode 39869938</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">&nbsp; &nbsp; &nbsp; &nbsp; will junk block</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">corrupt block 51 in directory inode 39869938</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">&nbsp; &nbsp; &nbsp; &nbsp; will junk block</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767; min-height: 13.0px">&nbsp;</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">Program received signal SIGSEGV, Segmentation fault.</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">[Switching to Thread 0x7fcd982ae730 (LWP 19563)]</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">0x0000000000419428 in verify_dir2_path (mp=0x7ffff8381580, cursor=0x7ffff8380f10, p_level=0) at dir2.c:619</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">619 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; node = cursor-&gt;level[this_level].bp-&gt;data;</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">(gdb) info locals</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">node = (xfs_da_intnode_t *) 0x7ffff8380e94</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">newnode = (xfs_da_intnode_t *) 0x52202867f8380de0</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">dabno = 0</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">bp = (xfs_dabuf_t *) 0x80000200000001</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">bad = -474527744</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">entry = 0</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">this_level = 1</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">bmp = (bmap_ext_t *) 0x1</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">nex = 134250496</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">lbmp = {startoff = 8459390528, startblock = 72058695280238674, blockcount = 140737357811264, flag = 4309438}</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">__PRETTY_FUNCTION__ = &quot;verify_dir2_path&quot;</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">(gdb)&nbsp;</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767; min-height: 13.0px">&nbsp;</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">(gdb) bt</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">#0&nbsp; 0x0000000000419428 in verify_dir2_path (mp=0x7ffff8381580, cursor=0x7ffff8380f10, p_level=0) at dir2.c:619</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">#1&nbsp; 0x000000000041c441 in process_leaf_level_dir2 (mp=0x7ffff8381580, da_cursor=0x7ffff8380f10, repair=0x7ffff8381134)</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">&nbsp; &nbsp; at dir2.c:1899</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">#2&nbsp; 0x000000000041c61e in process_node_dir2 (mp=0x7ffff8381580, ino=39869938, dip=0x7fc9e2b38000, blkmap=0x7fca249ffd40,&nbsp;</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">&nbsp; &nbsp; repair=0x7ffff8381134) at dir2.c:1979</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">#3&nbsp; 0x000000000041c8cf in process_leaf_node_dir2 (mp=0x7ffff8381580, ino=39869938, dip=0x7fc9e2b38000, ino_discovery=1,&nbsp;</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">&nbsp; &nbsp; dirname=0x4911f6 &quot;&quot;, parent=0x7ffff8381398, blkmap=0x7fca249ffd40, dot=0x7ffff838113c, dotdot=0x7ffff8381138,&nbsp;</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">&nbsp; &nbsp; repair=0x7ffff8381134, isnode=1) at dir2.c:2059</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">#4&nbsp; 0x000000000041cb33 in process_dir2 (mp=0x7ffff8381580, ino=39869938, dip=0x7fc9e2b38000, ino_discovery=1,&nbsp;</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">&nbsp; &nbsp; dino_dirty=0x7ffff8381390, dirname=0x4911f6 &quot;&quot;, parent=0x7ffff8381398, blkmap=0x7fca249ffd40) at dir2.c:2113</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">#5&nbsp; 0x00000000004127ac in process_dinode_int (mp=0x7ffff8381580, dino=0x7fc9e2b38000, agno=0, ino=39869938, was_free=0,&nbsp;</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">&nbsp; &nbsp; dirty=0x7ffff8381390, cleared=0x7ffff838138c, used=0x7ffff8381394, verify_mode=0, uncertain=0, ino_discovery=1,&nbsp;</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">&nbsp; &nbsp; check_dups=0, extra_attr_check=1, isa_dir=0x7ffff8381388, parent=0x7ffff8381398) at dinode.c:2783</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">#6&nbsp; 0x0000000000412d94 in process_dinode (mp=0x7ffff8381580, dino=0x7fc9e2b38000, agno=0, ino=39869938, was_free=0,&nbsp;</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">&nbsp; &nbsp; dirty=0x7ffff8381390, cleared=0x7ffff838138c, used=0x7ffff8381394, ino_discovery=1, check_dups=0, extra_attr_check=1,&nbsp;</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">&nbsp; &nbsp; isa_dir=0x7ffff8381388, parent=0x7ffff8381398) at dinode.c:3017</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">#7&nbsp; 0x000000000040b607 in process_inode_chunk (mp=0x7ffff8381580, agno=0, num_inos=64, first_irec=0x751c810, ino_discovery=1,&nbsp;</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">&nbsp; &nbsp; check_dups=0, extra_attr_check=1, bogus=0x7ffff8381430) at dino_chunks.c:778</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">#8&nbsp; 0x000000000040bf46 in process_aginodes (mp=0x7ffff8381580, pf_args=0x75e6810, agno=0, ino_discovery=1, check_dups=0,&nbsp;</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">&nbsp; &nbsp; extra_attr_check=1) at dino_chunks.c:1025</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">#9&nbsp; 0x0000000000421db3 in process_ag_func (wq=0x1fe3790, agno=0, arg=0x75e6810) at phase3.c:162</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">#10 0x0000000000421f84 in process_ags (mp=0x7ffff8381580) at phase3.c:201</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">#11 0x00000000004220aa in phase3 (mp=0x7ffff8381580) at phase3.c:240</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">#12 0x000000000043bec4 in main (argc=5, argv=0x7ffff83818c8) at xfs_repair.c:697</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">&nbsp;</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">&nbsp;</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">I&#39;ll get the metadump on request.&nbsp;</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">&nbsp;</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">&nbsp;</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">Thanks for helping,&nbsp;</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">&nbsp;</p>

<p style="margin: 0.0px 0.0px 0.0px 0.0px; font: 11.0px &#39;Lucida Grande&#39;; color: #676767">Jan</p>
</div></div></body></html>


--===============6814832771473405063==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6814832771473405063==--
