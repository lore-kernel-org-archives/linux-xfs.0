Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 598127F3F
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 16:29:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 314B68F804B
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 14:29:07 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id NnrK7ANF3Kn6vnar
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 14:29:05 -0700 (PDT)
Message-ID: <53A9EDA1.5070702@hardwarefreak.com>
Date: Tue, 24 Jun 2014 16:29:05 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS Repair hangs at inode repair in phase3
References: <trinity-b39adaf7-dd99-402d-abf3-62c4cf219f22-1403640162902@3capp-gmx-bs71>
In-Reply-To: <trinity-b39adaf7-dd99-402d-abf3-62c4cf219f22-1403640162902@3capp-gmx-bs71>
Reply-To: stan@hardwarefreak.com
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
To: Dragon <Sunghost@gmx.de>, xfs@oss.sgi.com

On 6/24/2014 3:02 PM, Dragon wrote:
> Hello,
> i actually try to backup the data. Next is that what my lock shows:
> [start]
> XFS (md2): Internal error xfs_da_do_buf(2) at line 2097 of file 
> /build/linux-5U_ZPM/linux-3.2.57/fs/xfs/xfs_da_btree.c.  Caller 0xffffffffa03e9940
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.454987]
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.476710] Pid: 3352, comm: mc Not 
> tainted 3.2.0-4-amd64 #1 Debian 3.2.57-3+deb7u2
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.476718] Call Trace:
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.476763]  [<ffffffffa03c2731>] ? 
> xfs_corruption_error+0x54/0x6f [xfs]
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.476818]  [<ffffffffa03e9940>] ? 
> xfs_da_read_buf+0x1a/0x1f [xfs]
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.476868]  [<ffffffffa03e982f>] ? 
> xfs_da_do_buf+0x47e/0x53c [xfs]
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.476916]  [<ffffffffa03e9940>] ? 
> xfs_da_read_buf+0x1a/0x1f [xfs]
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.476932]  [<ffffffff810cb42d>] ? 
> zone_statistics+0x41/0x74
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.476980]  [<ffffffffa03e9940>] ? 
> xfs_da_read_buf+0x1a/0x1f [xfs]
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.477029]  [<ffffffffa03e9940>] ? 
> xfs_da_read_buf+0x1a/0x1f [xfs]
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.477078]  [<ffffffffa03ee7b2>] ? 
> xfs_dir2_leaf_lookup_int+0x54/0x24b [xfs]
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.477125]  [<ffffffffa03dfa0c>] ? 
> xfs_bmap_last_extent.constprop.22+0x57/0x66 [xfs]
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.477174]  [<ffffffffa03eeda9>] ? 
> xfs_dir2_leaf_lookup+0x4b/0xdc [xfs]
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.477223]  [<ffffffffa03eb4fa>] ? 
> xfs_dir2_isleaf+0x18/0x45 [xfs]
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.477272]  [<ffffffffa03eb949>] ? 
> xfs_dir_lookup+0xf7/0x137 [xfs]
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.477316]  [<ffffffffa03d0386>] ? 
> xfs_lookup+0x76/0xd3 [xfs]
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.477331]  [<ffffffff810ed405>] ? 
> kmem_cache_alloc+0x86/0xea
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.477370]  [<ffffffffa03c8e5a>] ? 
> xfs_vn_lookup+0x3f/0x7e [xfs]
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.477386]  [<ffffffff81102d15>] ? 
> d_alloc_and_lookup+0x3a/0x60
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.477401]  [<ffffffff811037b9>] ? 
> walk_component+0x219/0x406
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.477415]  [<ffffffff811102ee>] ? 
> mntget+0x17/0x1c
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.477429]  [<ffffffff8110464d>] ? 
> path_lookupat+0x7c/0x2bd
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.477443]  [<ffffffff81036628>] ? 
> should_resched+0x5/0x23
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.477457]  [<ffffffff8134e90c>] ? 
> _cond_resched+0x7/0x1c
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.477472]  [<ffffffff811048aa>] ? 
> do_path_lookup+0x1c/0x87
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.477487]  [<ffffffff81106333>] ? 
> user_path_at_empty+0x47/0x7b
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.477501]  [<ffffffff810fe1b9>] ? 
> cp_new_stat+0xe6/0xfa
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.477515]  [<ffffffff810380dd>] ? 
> set_next_entity+0x32/0x55
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.477531]  [<ffffffff8100d750>] ? 
> __switch_to+0x1e5/0x258
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.477543]  [<ffffffff810fe386>] ? 
> vfs_fstatat+0x32/0x60
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.477557]  [<ffffffff810fe4e7>] ? 
> sys_newlstat+0x12/0x2b
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.477571]  [<ffffffff81354c12>] ? 
> system_call_fastpath+0x16/0x1b
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.477583] XFS (md2): Corruption 
> detected. Unmount and run xfs_repair
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.488542] ffff8801e3545000: 44 c1 52 
> 1c 70 87 80 ee c9 b8 26 ad fc cb 65 4d  D.R.p.....&...eM
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.492077] XFS (md2): Internal error 
> xfs_da_do_buf(2) at line 2097 of file 
> /build/linux-5U_ZPM/linux-3.2.57/fs/xfs/xfs_da_btree.c.  Caller 0xffffffffa03e9940
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.492080]
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.503378] Pid: 3352, comm: mc Not 
> tainted 3.2.0-4-amd64 #1 Debian 3.2.57-3+deb7u2
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.503381] Call Trace:
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.503391]  [<ffffffffa03c2731>] ? 
> xfs_corruption_error+0x54/0x6f [xfs]
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.503406]  [<ffffffffa03e9940>] ? 
> xfs_da_read_buf+0x1a/0x1f [xfs]
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.503420]  [<ffffffffa03e982f>] ? 
> xfs_da_do_buf+0x47e/0x53c [xfs]
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.503434]  [<ffffffffa03e9940>] ? 
> xfs_da_read_buf+0x1a/0x1f [xfs]
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.503438]  [<ffffffff810cb42d>] ? 
> zone_statistics+0x41/0x74
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.503452]  [<ffffffffa03e9940>] ? 
> xfs_da_read_buf+0x1a/0x1f [xfs]
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.503469]  [<ffffffffa03e9940>] ? 
> xfs_da_read_buf+0x1a/0x1f [xfs]
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.503488]  [<ffffffffa03ee7b2>] ? 
> xfs_dir2_leaf_lookup_int+0x54/0x24b [xfs]
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.503506]  [<ffffffffa03dfa0c>] ? 
> xfs_bmap_last_extent.constprop.22+0x57/0x66 [xfs]
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.503524]  [<ffffffffa03eeda9>] ? 
> xfs_dir2_leaf_lookup+0x4b/0xdc [xfs]
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.503542]  [<ffffffffa03eb4fa>] ? 
> xfs_dir2_isleaf+0x18/0x45 [xfs]
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.503561]  [<ffffffffa03eb949>] ? 
> xfs_dir_lookup+0xf7/0x137 [xfs]
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.503578]  [<ffffffffa03d0386>] ? 
> xfs_lookup+0x76/0xd3 [xfs]
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.503585]  [<ffffffff810ed405>] ? 
> kmem_cache_alloc+0x86/0xea
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.503600]  [<ffffffffa03c8e5a>] ? 
> xfs_vn_lookup+0x3f/0x7e [xfs]
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.503607]  [<ffffffff81102d15>] ? 
> d_alloc_and_lookup+0x3a/0x60
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.503615]  [<ffffffff811037b9>] ? 
> walk_component+0x219/0x406
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.503622]  [<ffffffff811102ee>] ? 
> mntget+0x17/0x1c
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.503630]  [<ffffffff8110464d>] ? 
> path_lookupat+0x7c/0x2bd
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.503637]  [<ffffffff81036628>] ? 
> should_resched+0x5/0x23
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.503644]  [<ffffffff8134e90c>] ? 
> _cond_resched+0x7/0x1c
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.503652]  [<ffffffff811048aa>] ? 
> do_path_lookup+0x1c/0x87
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.503660]  [<ffffffff81106333>] ? 
> user_path_at_empty+0x47/0x7b
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.503667]  [<ffffffff810fe1b9>] ? 
> cp_new_stat+0xe6/0xfa
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.503674]  [<ffffffff810380dd>] ? 
> set_next_entity+0x32/0x55
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.503682]  [<ffffffff8100d750>] ? 
> __switch_to+0x1e5/0x258
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.503689]  [<ffffffff810fe386>] ? 
> vfs_fstatat+0x32/0x60
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.503696]  [<ffffffff810fe4e7>] ? 
> sys_newlstat+0x12/0x2b
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.503704]  [<ffffffff81354c12>] ? 
> system_call_fastpath+0x16/0x1b
> Jun 24 22:00:50 clusternode01 kernel: [ 5461.503709] XFS (md2): Corruption 
> detected. Unmount and run xfs_repair
> [END]
> Any Idea?

The error msg above tells you what to do.  Follow Eric's suggestion,
install the latest xfsprogs, unmount, and run xfs_repair.


Cheers,

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
