Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0254C7F3F
	for <xfs@oss.sgi.com>; Fri, 25 Oct 2013 06:23:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C5F02304059
	for <xfs@oss.sgi.com>; Fri, 25 Oct 2013 04:23:46 -0700 (PDT)
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20]) by cuda.sgi.com
	with ESMTP id H3idR7lchrOvAv5A (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 25 Oct 2013 04:23:44 -0700 (PDT)
Received: from 3capp-gmx-bs25.server.lan ([172.19.170.77]) by
	mrigmx.server.lan (mrigmx002) with ESMTP (Nemesis) id
	0MDjZQ-1VTdrc3pdO-00HACn for <xfs@oss.sgi.com>;
	Fri, 25 Oct 2013 13:23:42 +0200
MIME-Version: 1.0
Message-ID: <trinity-561a8e56-e327-4695-b591-ab534badbca2-1382700222681@3capp-gmx-bs25>
From: "Jan Yves Brueckner" <jyb@gmx.com>
Subject: Aw: Re: xfs_repair segfaulting in phase 3
Date: Fri, 25 Oct 2013 13:23:42 +0200 (CEST)
In-Reply-To: <52273823.6050704@sandeen.net>
References: <trinity-9e6d7620-812f-48a7-9a7e-3098368ff59a-1376307533158@3capp-gmx-bs36>,
	<52273823.6050704@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0834813366587376949=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

--===============0834813366587376949==
Content-Type: text/html; charset=UTF-8

<html><head></head><body><div style="font-family: Verdana;font-size: 12.0px;"><div>
<div>Thanks a lot for taking care,&nbsp;</div>

<div>&nbsp;</div>

<div>I just teted with 3.2 alpha1 and had these results:</div>

<div>&nbsp;</div>

<div>corrupt block 21 in directory inode 39869938<br/>
&nbsp; &nbsp; &nbsp; &nbsp; will junk block<br/>
xfs_dir3_data_read_verify: XFS_CORRUPTION_ERROR<br/>
corrupt block 34 in directory inode 39869938<br/>
&nbsp; &nbsp; &nbsp; &nbsp; will junk block<br/>
xfs_dir3_data_read_verify: XFS_CORRUPTION_ERROR<br/>
corrupt block 35 in directory inode 39869938<br/>
&nbsp; &nbsp; &nbsp; &nbsp; will junk block<br/>
xfs_dir3_data_read_verify: XFS_CORRUPTION_ERROR<br/>
corrupt block 51 in directory inode 39869938<br/>
&nbsp; &nbsp; &nbsp; &nbsp; will junk block<br/>
xfs_da3_node_read_verify: XFS_CORRUPTION_ERROR<br/>
Segmentation fault</div>

<div>&nbsp;</div>

<div>&nbsp;</div>

<div>Should I go on with git latest?</div>

<div>&nbsp;</div>

<div>Thanks,</div>

<div>&nbsp;</div>

<div>Jan</div>

<div>&nbsp;
<div name="quote" style="margin:10px 5px 5px 10px; padding: 10px 0 10px 10px; border-left:2px solid #C3D9E5; word-wrap: break-word; -webkit-nbsp-mode: space; -webkit-line-break: after-white-space;">
<div style="margin:0 0 10px 0;"><b>Gesendet:</b>&nbsp;Mittwoch, 04. September 2013 um 15:39 Uhr<br/>
<b>Von:</b>&nbsp;&quot;Eric Sandeen&quot; &lt;sandeen@sandeen.net&gt;<br/>
<b>An:</b>&nbsp;&quot;Jan Yves Brueckner&quot; &lt;jyb@gmx.com&gt;<br/>
<b>Cc:</b>&nbsp;xfs@oss.sgi.com<br/>
<b>Betreff:</b>&nbsp;Re: xfs_repair segfaulting in phase 3</div>

<div name="quoted-content">On 8/12/13 6:38 AM, Jan Yves Brueckner wrote:<br/>
&gt; Hi there,<br/>
&gt;<br/>
&gt; as in previous posts we&#39;ve got a problem in repair/dir2.c after a<br/>
&gt; xfs_repair -L -m 60000 segfaulting reproducibly at the very same<br/>
&gt; point of recovery;<br/>
&gt;<br/>
&gt; I did the initial repair with debianish 2.9.8 (some patches applied);<br/>
&gt; then upgrading to latest stable 3.1.11 where the problem persists.<br/>
&gt;<br/>
&gt; 3.1.11 when compiled w/o optimization and run with gdb however<br/>
&gt; segfaulted in libpthread so I repeated with an -O0 of 2.9.8 to get<br/>
&gt; the debugging information:<br/>
&gt;<br/>
<br/>
Jan - 3 bugfixes into this, and I can get repair to complete w/o<br/>
a segv. However, the fs is still not fully repaired.<br/>
Nor is it fully repaired after the 2nd pass, etc etc. :(<br/>
<br/>
So you may have contributed a bit to xfs_repair stability<br/>
by uncovering this, but I&#39;m not sure I will be able to contribute<br/>
to recovery of your (apparently _severely_ damaged) filesystem.<br/>
<br/>
:(<br/>
<br/>
-Eric<br/>
<br/>
&gt; corrupt block 35 in directory inode 39869938<br/>
&gt;<br/>
&gt; will junk block<br/>
&gt;<br/>
&gt; corrupt block 51 in directory inode 39869938<br/>
&gt;<br/>
&gt; will junk block<br/>
&gt;<br/>
&gt;<br/>
&gt;<br/>
&gt; Program received signal SIGSEGV, Segmentation fault.<br/>
&gt;<br/>
&gt; [Switching to Thread 0x7fcd982ae730 (LWP 19563)]<br/>
&gt;<br/>
&gt; 0x0000000000419428 in verify_dir2_path (mp=0x7ffff8381580,<br/>
&gt; cursor=0x7ffff8380f10, p_level=0) at dir2.c:619<br/>
&gt;<br/>
&gt; 619 node = cursor-&gt;level[this_level].bp-&gt;data;<br/>
&gt;<br/>
&gt; (gdb) info locals<br/>
&gt;<br/>
&gt; node = (xfs_da_intnode_t *) 0x7ffff8380e94<br/>
&gt;<br/>
&gt; newnode = (xfs_da_intnode_t *) 0x52202867f8380de0<br/>
&gt;<br/>
&gt; dabno = 0<br/>
&gt;<br/>
&gt; bp = (xfs_dabuf_t *) 0x80000200000001<br/>
&gt;<br/>
&gt; bad = -474527744<br/>
&gt;<br/>
&gt; entry = 0<br/>
&gt;<br/>
&gt; this_level = 1<br/>
&gt;<br/>
&gt; bmp = (bmap_ext_t *) 0x1<br/>
&gt;<br/>
&gt; nex = 134250496<br/>
&gt;<br/>
&gt; lbmp = {startoff = 8459390528, startblock = 72058695280238674,<br/>
&gt; blockcount = 140737357811264, flag = 4309438}<br/>
&gt;<br/>
&gt; __PRETTY_FUNCTION__ = &quot;verify_dir2_path&quot;<br/>
&gt;<br/>
&gt; (gdb)<br/>
&gt;<br/>
&gt;<br/>
&gt;<br/>
&gt; (gdb) bt<br/>
&gt;<br/>
&gt; #0 0x0000000000419428 in verify_dir2_path (mp=0x7ffff8381580,<br/>
&gt; cursor=0x7ffff8380f10, p_level=0) at dir2.c:619<br/>
&gt;<br/>
&gt; #1 0x000000000041c441 in process_leaf_level_dir2 (mp=0x7ffff8381580,<br/>
&gt; da_cursor=0x7ffff8380f10, repair=0x7ffff8381134)<br/>
&gt;<br/>
&gt; at dir2.c:1899<br/>
&gt;<br/>
&gt; #2 0x000000000041c61e in process_node_dir2 (mp=0x7ffff8381580,<br/>
&gt; ino=39869938, dip=0x7fc9e2b38000, blkmap=0x7fca249ffd40,<br/>
&gt;<br/>
&gt; repair=0x7ffff8381134) at dir2.c:1979<br/>
&gt;<br/>
&gt; #3 0x000000000041c8cf in process_leaf_node_dir2 (mp=0x7ffff8381580,<br/>
&gt; ino=39869938, dip=0x7fc9e2b38000, ino_discovery=1,<br/>
&gt;<br/>
&gt; dirname=0x4911f6 &quot;&quot;, parent=0x7ffff8381398, blkmap=0x7fca249ffd40,<br/>
&gt; dot=0x7ffff838113c, dotdot=0x7ffff8381138,<br/>
&gt;<br/>
&gt; repair=0x7ffff8381134, isnode=1) at dir2.c:2059<br/>
&gt;<br/>
&gt; #4 0x000000000041cb33 in process_dir2 (mp=0x7ffff8381580,<br/>
&gt; ino=39869938, dip=0x7fc9e2b38000, ino_discovery=1,<br/>
&gt;<br/>
&gt; dino_dirty=0x7ffff8381390, dirname=0x4911f6 &quot;&quot;,<br/>
&gt; parent=0x7ffff8381398, blkmap=0x7fca249ffd40) at dir2.c:2113<br/>
&gt;<br/>
&gt; #5 0x00000000004127ac in process_dinode_int (mp=0x7ffff8381580,<br/>
&gt; dino=0x7fc9e2b38000, agno=0, ino=39869938, was_free=0,<br/>
&gt;<br/>
&gt; dirty=0x7ffff8381390, cleared=0x7ffff838138c, used=0x7ffff8381394,<br/>
&gt; verify_mode=0, uncertain=0, ino_discovery=1,<br/>
&gt;<br/>
&gt; check_dups=0, extra_attr_check=1, isa_dir=0x7ffff8381388,<br/>
&gt; parent=0x7ffff8381398) at dinode.c:2783<br/>
&gt;<br/>
&gt; #6 0x0000000000412d94 in process_dinode (mp=0x7ffff8381580,<br/>
&gt; dino=0x7fc9e2b38000, agno=0, ino=39869938, was_free=0,<br/>
&gt;<br/>
&gt; dirty=0x7ffff8381390, cleared=0x7ffff838138c, used=0x7ffff8381394,<br/>
&gt; ino_discovery=1, check_dups=0, extra_attr_check=1,<br/>
&gt;<br/>
&gt; isa_dir=0x7ffff8381388, parent=0x7ffff8381398) at dinode.c:3017<br/>
&gt;<br/>
&gt; #7 0x000000000040b607 in process_inode_chunk (mp=0x7ffff8381580,<br/>
&gt; agno=0, num_inos=64, first_irec=0x751c810, ino_discovery=1,<br/>
&gt;<br/>
&gt; check_dups=0, extra_attr_check=1, bogus=0x7ffff8381430) at<br/>
&gt; dino_chunks.c:778<br/>
&gt;<br/>
&gt; #8 0x000000000040bf46 in process_aginodes (mp=0x7ffff8381580,<br/>
&gt; pf_args=0x75e6810, agno=0, ino_discovery=1, check_dups=0,<br/>
&gt;<br/>
&gt; extra_attr_check=1) at dino_chunks.c:1025<br/>
&gt;<br/>
&gt; #9 0x0000000000421db3 in process_ag_func (wq=0x1fe3790, agno=0,<br/>
&gt; arg=0x75e6810) at phase3.c:162<br/>
&gt;<br/>
&gt; #10 0x0000000000421f84 in process_ags (mp=0x7ffff8381580) at<br/>
&gt; phase3.c:201<br/>
&gt;<br/>
&gt; #11 0x00000000004220aa in phase3 (mp=0x7ffff8381580) at phase3.c:240<br/>
&gt;<br/>
&gt; #12 0x000000000043bec4 in main (argc=5, argv=0x7ffff83818c8) at<br/>
&gt; xfs_repair.c:697<br/>
&gt;<br/>
&gt;<br/>
&gt;<br/>
&gt;<br/>
&gt;<br/>
&gt; I&#39;ll get the metadump on request.<br/>
&gt;<br/>
&gt;<br/>
&gt;<br/>
&gt;<br/>
&gt;<br/>
&gt; Thanks for helping,<br/>
&gt;<br/>
&gt;<br/>
&gt;<br/>
&gt; Jan<br/>
&gt;<br/>
&gt;<br/>
&gt;<br/>
&gt; _______________________________________________ xfs mailing list<br/>
&gt; xfs@oss.sgi.com <a href="http://oss.sgi.com/mailman/listinfo/xfs" target="_blank">http://oss.sgi.com/mailman/listinfo/xfs</a><br/>
&gt;<br/>
&nbsp;</div>
</div>
</div>
</div></div></body></html>


--===============0834813366587376949==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0834813366587376949==--
