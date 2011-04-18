Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3I1VnjT222933 for <xfs@oss.sgi.com>; Sun, 17 Apr 2011 20:31:49 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 48B943E5AC1
	for <xfs@oss.sgi.com>; Sun, 17 Apr 2011 18:35:13 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	5fcez82zokJhvD52 for <xfs@oss.sgi.com>;
	Sun, 17 Apr 2011 18:35:13 -0700 (PDT)
Date: Mon, 18 Apr 2011 11:35:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_perag_put NULL deference BUG
Message-ID: <20110418013510.GA15763@dastard>
References: <robbat2-20110416T163639-343099416Z@orbis-terrarum.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <robbat2-20110416T163639-343099416Z@orbis-terrarum.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "Robin H. Johnson" <robbat2@gentoo.org>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Sat, Apr 16, 2011 at 05:14:43PM +0000, Robin H. Johnson wrote:
> (Please CC, not subscribed)
> 
> I have an archival setup that makes heavy use of hardlinks, and recently, it
> started needing inode64 (refused to create any more files until I remounted w/
> inode64), and shortly thereafter it went really bad and now after making some
> new files, I get this OOPS and write access to any XFS filesystem on the
> machine stops.

Well, that is strange.

> xfs_check and xfs_repair claim the filesystem is fine, so I wonder if I've just
> run into some corner-case.

No idea.

> Filesystem stats:
> Approx 120K inodes, 6M files.
> Allocated space: 900GiB (on LVM, single volume)
> Actual size: 787GiB
> Apparent size: 23.5TiB
  ^^^^^^^^^^^^^^^^^^^^^^

Which means what?

Can you post the output of 'xfs_info <mntpt>', your mount options,
and spell out the details of your storage stack (assume I know know
nothing about it). Also, what version of xfsprogs are you using?
If it's not recent then there's the possibility that a more recent
version could find something wrong with the fs.

> Hardlink count per inode: mean 51, mode 116, median 33, max 595, min 1.
> 
> [ 5674.213688] BUG: unable to handle kernel NULL pointer dereference at 000000000000000c
> [ 5674.214095] IP: [<ffffffff812391fc>] xfs_perag_put+0x14/0x6d
> [ 5674.214305] PGD 229e7b000 
> [ 5674.214506] Oops: 0002 [#1] SMP 
> [ 5674.214708] last sysfs file: /sys/devices/pci0000:00/0000:00:1c.4/0000:0d:00.0/net/eth0/broadcast
> [ 5674.215108] CPU 0 
> [ 5674.215113] Modules linked in: xt_comment sch_htb nf_conntrack_ipv4 nf_defrag_ipv4 xt_state iptable_filter ipt_addrtype xt_dscp xt_string xt_owner xt_multiport xt_iprange xt_hashlimit xt_conntrack xt_DSCP xt_NFQUEUE xt_mark xt_connmark nf_conntrack ip_tables ipv6 evdev tpm_tis i2c_i801 container tpm iTCO_wdt sg i2c_core tpm_bios processor thermal iTCO_vendor_support thermal_sys ghes hed i3200_edac hwmon button edac_core
> [ 5674.216585] 
> [ 5674.216782] Pid: 26699, comm: rsync Not tainted 2.6.36-hardened-r4-infra17 #3 X7SBi/X7SBi

Ok, so you're running some weird patchset. If you run a vanilla
kernel, does the problem occur?

> [ 5674.217452]  [<ffffffff8120ef52>] xfs_bmap_btalloc_nullfb+0x20e/0x2b4
> [ 5674.217452]  [<ffffffff810b77a5>] ? find_or_create_page+0x31/0x85
> [ 5674.217452]  [<ffffffff8120f1e7>] xfs_bmap_btalloc+0x1ef/0x5b8
> [ 5674.217452]  [<ffffffff8120abe5>] ? xfs_bmap_search_multi_extents+0x63/0xda
> [ 5674.217452]  [<ffffffff8120f5b9>] xfs_bmap_alloc+0x9/0xb
> [ 5674.217452]  [<ffffffff8121146f>] xfs_bmapi+0x6c2/0xd62
> [ 5674.217452]  [<ffffffff812462b6>] ? xfs_buf_rele+0xe6/0xf2
> [ 5674.217452]  [<ffffffff8121b965>] xfs_dir2_grow_inode+0x11d/0x32b
> [ 5674.217452]  [<ffffffff8124d8f6>] ? xfs_setup_inode+0x244/0x24d
> [ 5674.217452]  [<ffffffff81242a09>] ? kmem_free+0x26/0x2f
> [ 5674.217452]  [<ffffffff812285ec>] ? xfs_idata_realloc+0x3f/0x109
> [ 5674.217452]  [<ffffffff8121c538>] xfs_dir2_sf_to_block+0xda/0x5ae
> [ 5674.217452]  [<ffffffff81613956>] ? _raw_spin_lock+0x9/0xd
> [ 5674.217452]  [<ffffffff812234bb>] xfs_dir2_sf_addname+0x1d8/0x507
> [ 5674.217452]  [<ffffffff810eb1cd>] ? kmem_cache_alloc+0x193/0x1fe
> [ 5674.217452]  [<ffffffff8121c332>] xfs_dir_createname+0xee/0x15a
> [ 5674.217452]  [<ffffffff81240203>] xfs_link+0x1f1/0x293
> [ 5674.217452]  [<ffffffff8124d36f>] xfs_vn_link+0x3a/0x62
> [ 5674.217452]  [<ffffffff810fce7f>] vfs_link+0xfd/0x186
> [ 5674.217452]  [<ffffffff81100384>] sys_linkat+0x10a/0x183
> [ 5674.217452]  [<ffffffff810f6b02>] ? sys_newlstat+0x2c/0x3b
> [ 5674.217452]  [<ffffffff81100416>] sys_link+0x19/0x1b
> [ 5674.217452]  [<ffffffff810035a7>] system_call_fastpath+0x16/0x1b

To tell the truth, the only way I can see xfs_bmap_btalloc_nullfb
failing in this way is if the allocation length being asked for is
zero and that is definitely not the case for a directory inode grow.
That's the only way you could get to xfs_perag_put() with a null
parameter. Otherwise it would crash inside the loop dereferencing
pag->pagf_init....


I think the first step is to to reproduce this on an unpatched
mainline kernel, and we can go from there.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
