Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 90B707F4E
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 15:02:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4C5128F8054
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 13:02:50 -0700 (PDT)
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18]) by cuda.sgi.com
	with ESMTP id VBEUSPWDTDO4rToE (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Jun 2014 13:02:44 -0700 (PDT)
MIME-Version: 1.0
Message-ID: <trinity-b39adaf7-dd99-402d-abf3-62c4cf219f22-1403640162902@3capp-gmx-bs71>
From: Dragon <Sunghost@gmx.de>
Subject: Re: XFS Repair hangs at inode repair in phase3
Date: Tue, 24 Jun 2014 22:02:42 +0200
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1722079464676654932=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============1722079464676654932==
Content-Type: text/html; charset=UTF-8

<html><head></head><body><div style="font-family: Verdana;font-size: 12.0px;"><div>Hello,
<div>i actually try to backup the data. Next is that what my lock shows:</div>

<div>[start]</div>

<div>XFS (md2): Internal error xfs_da_do_buf(2) at line 2097 of file /build/linux-5U_ZPM/linux-3.2.57/fs/xfs/xfs_da_btree.c.&nbsp; Caller 0xffffffffa03e9940<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.454987]<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.476710] Pid: 3352, comm: mc Not tainted 3.2.0-4-amd64 #1 Debian 3.2.57-3+deb7u2<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.476718] Call Trace:<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.476763]&nbsp; [&lt;ffffffffa03c2731&gt;] ? xfs_corruption_error+0x54/0x6f [xfs]<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.476818]&nbsp; [&lt;ffffffffa03e9940&gt;] ? xfs_da_read_buf+0x1a/0x1f [xfs]<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.476868]&nbsp; [&lt;ffffffffa03e982f&gt;] ? xfs_da_do_buf+0x47e/0x53c [xfs]<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.476916]&nbsp; [&lt;ffffffffa03e9940&gt;] ? xfs_da_read_buf+0x1a/0x1f [xfs]<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.476932]&nbsp; [&lt;ffffffff810cb42d&gt;] ? zone_statistics+0x41/0x74<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.476980]&nbsp; [&lt;ffffffffa03e9940&gt;] ? xfs_da_read_buf+0x1a/0x1f [xfs]<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.477029]&nbsp; [&lt;ffffffffa03e9940&gt;] ? xfs_da_read_buf+0x1a/0x1f [xfs]<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.477078]&nbsp; [&lt;ffffffffa03ee7b2&gt;] ? xfs_dir2_leaf_lookup_int+0x54/0x24b [xfs]<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.477125]&nbsp; [&lt;ffffffffa03dfa0c&gt;] ? xfs_bmap_last_extent.constprop.22+0x57/0x66 [xfs]<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.477174]&nbsp; [&lt;ffffffffa03eeda9&gt;] ? xfs_dir2_leaf_lookup+0x4b/0xdc [xfs]<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.477223]&nbsp; [&lt;ffffffffa03eb4fa&gt;] ? xfs_dir2_isleaf+0x18/0x45 [xfs]<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.477272]&nbsp; [&lt;ffffffffa03eb949&gt;] ? xfs_dir_lookup+0xf7/0x137 [xfs]<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.477316]&nbsp; [&lt;ffffffffa03d0386&gt;] ? xfs_lookup+0x76/0xd3 [xfs]<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.477331]&nbsp; [&lt;ffffffff810ed405&gt;] ? kmem_cache_alloc+0x86/0xea<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.477370]&nbsp; [&lt;ffffffffa03c8e5a&gt;] ? xfs_vn_lookup+0x3f/0x7e [xfs]<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.477386]&nbsp; [&lt;ffffffff81102d15&gt;] ? d_alloc_and_lookup+0x3a/0x60<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.477401]&nbsp; [&lt;ffffffff811037b9&gt;] ? walk_component+0x219/0x406<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.477415]&nbsp; [&lt;ffffffff811102ee&gt;] ? mntget+0x17/0x1c<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.477429]&nbsp; [&lt;ffffffff8110464d&gt;] ? path_lookupat+0x7c/0x2bd<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.477443]&nbsp; [&lt;ffffffff81036628&gt;] ? should_resched+0x5/0x23<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.477457]&nbsp; [&lt;ffffffff8134e90c&gt;] ? _cond_resched+0x7/0x1c<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.477472]&nbsp; [&lt;ffffffff811048aa&gt;] ? do_path_lookup+0x1c/0x87<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.477487]&nbsp; [&lt;ffffffff81106333&gt;] ? user_path_at_empty+0x47/0x7b<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.477501]&nbsp; [&lt;ffffffff810fe1b9&gt;] ? cp_new_stat+0xe6/0xfa<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.477515]&nbsp; [&lt;ffffffff810380dd&gt;] ? set_next_entity+0x32/0x55<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.477531]&nbsp; [&lt;ffffffff8100d750&gt;] ? __switch_to+0x1e5/0x258<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.477543]&nbsp; [&lt;ffffffff810fe386&gt;] ? vfs_fstatat+0x32/0x60<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.477557]&nbsp; [&lt;ffffffff810fe4e7&gt;] ? sys_newlstat+0x12/0x2b<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.477571]&nbsp; [&lt;ffffffff81354c12&gt;] ? system_call_fastpath+0x16/0x1b<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.477583] XFS (md2): Corruption detected. Unmount and run xfs_repair<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.488542] ffff8801e3545000: 44 c1 52 1c 70 87 80 ee c9 b8 26 ad fc cb 65 4d&nbsp; D.R.p.....&amp;...eM<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.492077] XFS (md2): Internal error xfs_da_do_buf(2) at line 2097 of file /build/linux-5U_ZPM/linux-3.2.57/fs/xfs/xfs_da_btree.c.&nbsp; Caller 0xffffffffa03e9940<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.492080]<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.503378] Pid: 3352, comm: mc Not tainted 3.2.0-4-amd64 #1 Debian 3.2.57-3+deb7u2<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.503381] Call Trace:<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.503391]&nbsp; [&lt;ffffffffa03c2731&gt;] ? xfs_corruption_error+0x54/0x6f [xfs]<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.503406]&nbsp; [&lt;ffffffffa03e9940&gt;] ? xfs_da_read_buf+0x1a/0x1f [xfs]<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.503420]&nbsp; [&lt;ffffffffa03e982f&gt;] ? xfs_da_do_buf+0x47e/0x53c [xfs]<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.503434]&nbsp; [&lt;ffffffffa03e9940&gt;] ? xfs_da_read_buf+0x1a/0x1f [xfs]<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.503438]&nbsp; [&lt;ffffffff810cb42d&gt;] ? zone_statistics+0x41/0x74<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.503452]&nbsp; [&lt;ffffffffa03e9940&gt;] ? xfs_da_read_buf+0x1a/0x1f [xfs]<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.503469]&nbsp; [&lt;ffffffffa03e9940&gt;] ? xfs_da_read_buf+0x1a/0x1f [xfs]<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.503488]&nbsp; [&lt;ffffffffa03ee7b2&gt;] ? xfs_dir2_leaf_lookup_int+0x54/0x24b [xfs]<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.503506]&nbsp; [&lt;ffffffffa03dfa0c&gt;] ? xfs_bmap_last_extent.constprop.22+0x57/0x66 [xfs]<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.503524]&nbsp; [&lt;ffffffffa03eeda9&gt;] ? xfs_dir2_leaf_lookup+0x4b/0xdc [xfs]<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.503542]&nbsp; [&lt;ffffffffa03eb4fa&gt;] ? xfs_dir2_isleaf+0x18/0x45 [xfs]<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.503561]&nbsp; [&lt;ffffffffa03eb949&gt;] ? xfs_dir_lookup+0xf7/0x137 [xfs]<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.503578]&nbsp; [&lt;ffffffffa03d0386&gt;] ? xfs_lookup+0x76/0xd3 [xfs]<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.503585]&nbsp; [&lt;ffffffff810ed405&gt;] ? kmem_cache_alloc+0x86/0xea<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.503600]&nbsp; [&lt;ffffffffa03c8e5a&gt;] ? xfs_vn_lookup+0x3f/0x7e [xfs]<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.503607]&nbsp; [&lt;ffffffff81102d15&gt;] ? d_alloc_and_lookup+0x3a/0x60<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.503615]&nbsp; [&lt;ffffffff811037b9&gt;] ? walk_component+0x219/0x406<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.503622]&nbsp; [&lt;ffffffff811102ee&gt;] ? mntget+0x17/0x1c<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.503630]&nbsp; [&lt;ffffffff8110464d&gt;] ? path_lookupat+0x7c/0x2bd<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.503637]&nbsp; [&lt;ffffffff81036628&gt;] ? should_resched+0x5/0x23<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.503644]&nbsp; [&lt;ffffffff8134e90c&gt;] ? _cond_resched+0x7/0x1c<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.503652]&nbsp; [&lt;ffffffff811048aa&gt;] ? do_path_lookup+0x1c/0x87<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.503660]&nbsp; [&lt;ffffffff81106333&gt;] ? user_path_at_empty+0x47/0x7b<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.503667]&nbsp; [&lt;ffffffff810fe1b9&gt;] ? cp_new_stat+0xe6/0xfa<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.503674]&nbsp; [&lt;ffffffff810380dd&gt;] ? set_next_entity+0x32/0x55<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.503682]&nbsp; [&lt;ffffffff8100d750&gt;] ? __switch_to+0x1e5/0x258<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.503689]&nbsp; [&lt;ffffffff810fe386&gt;] ? vfs_fstatat+0x32/0x60<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.503696]&nbsp; [&lt;ffffffff810fe4e7&gt;] ? sys_newlstat+0x12/0x2b<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.503704]&nbsp; [&lt;ffffffff81354c12&gt;] ? system_call_fastpath+0x16/0x1b<br/>
Jun 24 22:00:50 clusternode01 kernel: [ 5461.503709] XFS (md2): Corruption detected. Unmount and run xfs_repair</div>

<div>[END]</div>

<div>&nbsp;</div>

<div>Any Idea?</div>
</div></div></body></html>


--===============1722079464676654932==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1722079464676654932==--
