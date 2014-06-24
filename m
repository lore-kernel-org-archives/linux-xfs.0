Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A23A229DF8
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 09:25:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0DD5AAC002
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 07:25:42 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id vgcrHHPEeK3nrdGW (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Jun 2014 07:25:41 -0700 (PDT)
Date: Tue, 24 Jun 2014 10:25:36 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [XFS updates] XFS development tree branch,
	xfs-libxfs-restructure, updated. xfs-for-linus-3.16-rc1-13107-gc59a5ac
Message-ID: <20140624142522.GB45839@bfoster.bfoster>
References: <20140623072359.C16CF7F47@oss.sgi.com>
	<20140623080618.GY9508@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140623080618.GY9508@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Jun 23, 2014 at 06:06:18PM +1000, Dave Chinner wrote:
> On Mon, Jun 23, 2014 at 02:23:59AM -0500, xfs@oss.sgi.com wrote:
> > This is an automated email from the git hooks/post-receive script. It was
> > generated because a ref change was pushed to the repository containing
> > the project "XFS development tree".
> > 
> > The branch, xfs-libxfs-restructure has been updated
> >   discards  fcec2eb6a31bde491f4ce9ddd94b41c8aacccd43 (commit)
> >   discards  e3584e38615389850684fcffd699d97e2e06f2d6 (commit)
> >   discards  f212d6fcf5c1cc3a3980dd320804c1dfb9f49b75 (commit)
> >   discards  e10404cf914273de8016d5992c7049bdb9a9a089 (commit)
> >   discards  f3a19b3ad85dcc4a073270e1fb594eff37709788 (commit)
> >   discards  d5a6cda3cf2c0860543db26bb5df7ed4404f74cd (commit)
> >   c59a5ac xfs: global error sign conversion
> >   63d512e libxfs: move source files
> >   547a71f libxfs: move header files
> >   62c9454 xfs: create libxfs infrastructure
> >   b474c7a xfs: Nuke XFS_ERROR macro
> >   d99831f xfs: return is not a function
> >   16b9057 Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
> >   9c1d528 Merge commit '9f12600fe425bc28f0ccba034a77783c09c15af4' into for-linus
> >   8d02076 ->splice_write() via ->write_iter()
> >   412dd3a Merge tag 'xfs-for-linus-3.16-rc1' of git://oss.sgi.com/xfs/xfs
> >   23adbe1 fs,userns: Change inode_capable to capable_wrt_inode_uidgid
> >   bf97f3b xfs: switch to ->write_iter()
> >   b4f5d2c xfs: switch to ->read_iter()
> >   b318891 xfs: trim the argument lists of xfs_file_{dio,buffered}_aio_write()
> >   0c94933 iov_iter_truncate()
> >   71d8e53 start adding the tag to iov_iter
> >   31b1403 switch {__,}blockdev_direct_IO() to iov_iter
> >   a6cbcd4 get rid of pointless iov_length() in ->direct_IO()
> >   d8d3d94 pass iov_iter to ->direct_IO()
> >   cb66a7a kill generic_segment_checks()
> >   f8579f8 generic_file_direct_write(): switch to iov_iter
> >       from  fcec2eb6a31bde491f4ce9ddd94b41c8aacccd43 (commit)
> > 
> > Those revisions listed above that are new to this repository have
> > not appeared on any other notification email; so we list those
> > revisions in full, below.
> 
> This looks like a lot of non-libxfs changes, but it's mostly just
> noise from the rebase from 3.15.0 to the current master branch at
> 3.16-rc2.
> 
> I've added all the negation fixes that Brian noted, and tested all
> the different config options (m,y,n) for the libxfs restructure. I
> haven't come across any problems over the weekend, so I'd like to
> push this out so that we can get this dev cycle properly underway.
> If people can ack this, I'll add all the appropriate sign-offs and
> push it.
> 

The changes look good to me and I don't see any failures that aren't
common with for-next, so:

Reviewed-by: Brian Foster <bfoster@redhat.com>

That said, I am seeing a BUG() on for-next kernels via repeated xfs/297
runs. Output is appended below.

Brian

------------[ cut here ]------------
kernel BUG at fs/xfs/xfs_aops.c:1373!
invalid opcode: 0000 [#1] SMP 
Modules linked in: xfs(OE) libcrc32c sunrpc ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables binfmt_misc ipmi_si ipmi_msghandler acpi_power_meter dcdbas pcspkr serio_raw ixgbe dca ptp pps_core mdio ses enclosure amd64_edac_mod edac_core edac_mce_amd k10temp sp5100_tco i2c_piix4 sg bnx2 ext4(E) jbd2(E) mbcache(E) sr_mod(E) cdrom(E) sd_mod(E) crc_t10dif(E) crct10dif_common(E) megaraid_sas(E) mpt2sas(E) scsi_transport_sas(E) raid_class(E) usb_storage(E) mgag200(E) ttm(E) drm_kms_helper(E) drm(E) i2c_algo_bit(E) sysimgblt(E) sysfillrect(E) i2c_core(E) syscopyarea(E) dm_mirror(E) dm_region_hash(E) dm_log(E) dm_mod(E) [last unloaded: xfs]
CPU: 10 PID: 14202 Comm: fsstress Tainted: G           OE 3.16.0-rc2+ #5
Hardware name: Dell Inc. PowerEdge R715/0G2DP3, BIOS 2.3.0 10/18/2011
task: ffff88061c47d880 ti: ffff88061c4dc000 task.ti: ffff88061c4dc000
RIP: 0010:[<ffffffffa04f79d8>]  [<ffffffffa04f79d8>] __xfs_get_blocks+0x548/0x550 [xfs]
RSP: 0018:ffff88061c4df918  EFLAGS: 00010202
RAX: ffff8808347c8680 RBX: ffff88062cac5b08 RCX: 0000000000000200
RDX: 0000000000000001 RSI: 0000000000000008 RDI: ffff88062cac5b08
RBP: ffff88061c4df9a8 R08: 00000000000001a3 R09: ffff88061c4df8cc
R10: 00007fc884019000 R11: 0000000000000000 R12: 000000000018a000
R13: ffff88061c4dfbc8 R14: ffff8800b213e800 R15: 0000000000019000
FS:  00007fc88be5b700(0000) GS:ffff880437c20000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000003a6dd92448 CR3: 000000063152d000 CR4: 00000000000006e0
Stack:
 ffff88061c4df938 00007fc884018fff 01ff880600000000 0000000100000008
 000000000000018a ffff88062cac5940 0000000000000179 ffffffffffffffff
 0000000000000087 ffffffff00000000 0000000000000009 000000011c3e6e28
Call Trace:
 [<ffffffffa04f79f4>] xfs_get_blocks_direct+0x14/0x20 [xfs]
 [<ffffffff81220b3b>] do_direct_IO+0x1cb/0x1100
 [<ffffffff81221bc3>] ? do_blockdev_direct_IO+0x153/0xc00
 [<ffffffff81221e01>] do_blockdev_direct_IO+0x391/0xc00
 [<ffffffff8117cd25>] ? pagevec_lookup_tag+0x25/0x40
 [<ffffffff8117a94f>] ? write_cache_pages+0x12f/0x4c0
 [<ffffffffa04f79e0>] ? __xfs_get_blocks+0x550/0x550 [xfs]
 [<ffffffff8117ad3c>] ? generic_writepages+0x5c/0x80
 [<ffffffff812226bc>] __blockdev_direct_IO+0x4c/0x50
 [<ffffffffa04f79e0>] ? __xfs_get_blocks+0x550/0x550 [xfs]
 [<ffffffffa04f7216>] xfs_vm_direct_IO+0x136/0x140 [xfs]
 [<ffffffffa04f79e0>] ? __xfs_get_blocks+0x550/0x550 [xfs]
 [<ffffffff81170d63>] generic_file_read_iter+0x143/0x150
 [<ffffffffa050457a>] xfs_file_read_iter+0x12a/0x280 [xfs]
 [<ffffffff811e6e3f>] new_sync_read+0x8f/0xc0
 [<ffffffff811e7343>] vfs_read+0xa3/0x110
 [<ffffffff812043a3>] ? __fdget+0x13/0x20
 [<ffffffff811e7906>] SyS_read+0x56/0xd0
 [<ffffffff8164ada9>] system_call_fastpath+0x16/0x1b
Code: 00 00 00 f7 d8 e9 51 fd ff ff 66 0f 1f 84 00 00 00 00 00 80 7d 87 00 74 0a 49 89 5d 40 f0 41 80 4d 02 01 f0 41 80 4d 01 10 eb c0 <0f> 0b eb fe 0f 1f 40 00 55 48 89 e5 66 66 66 66 90 41 b8 01 00 
RIP  [<ffffffffa04f79d8>] __xfs_get_blocks+0x548/0x550 [xfs]
 RSP <ffff88061c4df918>
---[ end trace ef315dcf69ea8a1f ]---

> Once that is done, I'll start pulling in all the outstanding
> patchsets and work through getting them through reviews and
> into for-next....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
