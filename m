Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376D03CF689
	for <linux-xfs@vger.kernel.org>; Thu,  7 May 2026 11:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778154121; cv=none; b=C1JIXBz2DCwlWsg/9v1w4sCD+GSy198+a6Gh7Rjr4k61qz21mIyZaitiVN1oo7bB8NWPNIH5DV0WWbCbHSubAQz6rISg/tpihyH1dRFgtQ7bewyOySMD6RMSDJQH0wffBwDMJS7FkQZ6OK0TlVUMBwRNqKmfB7Dk4m/jQrec098=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778154121; c=relaxed/simple;
	bh=e5OpCutFpOomACd+a0RhSUYSjHxROAHQ1BaP2A3AzOI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=aY4HSRBI/OsYm/vhkeYQK+lVgn1XRFQ/6lNvnA7nZ+iWUbvS/ShpuGl+CGpI7RrP1tyBifloy82ntR3g29zDVc0CKuWeelQu3EZrJAAhGyyvXEM4tiuzy7GhjbgNT6taFF3OsBdZNiCe2SfmmOEC+x1jNXzNjP2mt/JASDeuXF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MEN9VINV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MEN9VINV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DAA2C2BCB2;
	Thu,  7 May 2026 11:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778154120;
	bh=e5OpCutFpOomACd+a0RhSUYSjHxROAHQ1BaP2A3AzOI=;
	h=Date:From:To:Cc:Subject:From;
	b=MEN9VINVcVFVJ/z2eSWFLVuTLg0QbXQrDXTmd1CEFzFmusXcXgG4UBTdfY9dYWBME
	 FHzEauKsfvhxU+clk5guM3BxrCMjdWca6zb+iul/gruSnxcanKyg7pj+U6PqcGy5JV
	 3YQ8bDiSxKng9qwQblG9IvqwHXfAxNE+6GyCsVZX0KkljA/RnkUbNtVA8k+HUete2b
	 bpe55Rb2zMs8WCmabZ/ZzqbJlBxP0wld3mZbR2iBAzr5aVP/25ouQON1g9yaHcx5pl
	 7rRLY4yhJuduyDVht2cm/AmEaZ8P0XlZpPmCTZu4gkqzA9eXxpzliMgH4mU0n8lbTh
	 bneasKHIoSpvA==
Date: Thu, 7 May 2026 13:41:53 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org, cem@kernel.org, cmaiolino@redhat.com, 
	djwong@kernel.org, dlemoal@kernel.org, gedalya@gedalya.net, hans.holmberg@wdc.com, 
	hch@lst.de, hongao@uniontech.com, kees@kernel.org, leo.lilong@huawei.com, 
	linux-xfs@vger.kernel.org, mark.tinguely@oracle.com, morbo@google.com, 
	nirjhar.roy.lists@gmail.com, patrick.fischer@siedl.net, ravising@redhat.com, 
	shinsj4653@gmail.com, souptick.joarder@hpe.com, tbecker@redhat.com, 
	torvalds@linux-foundation.org, wilfred.mallawa@wdc.com
Subject: [ANNOUNCE] xfsprogs: v7.0.0 released
Message-ID: <afqdmyddmm4vexlwauaf427c4vxic2qk2z5qtwvgr5eaywb2rq@mjdtmyloke7v>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The xfsprogs master branch in repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

This release introduces xfs_healer utility and health monitor daemon. The kernel
part of things was merged and this release adds userspace interfaces. The health
daemon monitors filesystem events produced by kernel and tries to fix/heal them
with targeted repairs on online filesystem. Debian package enables this daemon
for root and any other filesystem by default. mkfs.xfs now enables online repair
if all backrefs (parent pointers and rmapbt) are enabled.

xfs_quota now shows default limits for all users, previously those weren't shown
for users without any quota used up. xfs_fsr now prints errors by default,
previously it was printing them in debug/verbose mode only, also it prints
previous missed errors for file extents swap. xfs_scrub now uses new media
verification ioctl XFS_IOC_VERIFY_MEDIA if available in the kernel. xfs_scrub
warns about unicode variation selectors in names which could be used to hide
payload in filenames. xfs_scrub dropped the warning about mixed bidirectional
codepoints in names as those are common in some language. xfs_io gained
healthmon, listmount and statmount commands. xfs_scrub_all was deadlocking on
huge list of devices in lsblk output, this is fixed now.

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The for-next branch has also been updated to match the state of master.

The new head of the master branch is commit:

640999ac318eb8550b86a178ad592c7d9ab58c48

New commits:

Andrey Albershteyn (1):
      [640999ac318e] xfsprogs: Release v7.0.0

Bill Wendling (1):
      [df91bc3bdc9b] xfs: annotate struct xfs_attr_list_context with __counted_by_ptr

Carlos Maiolino (3):
      [50d29084e53a] xfs: fix returned valued from xfs_defer_can_append
      [bf1007391a32] fsr: package function should check for negative errors
      [a799c98743c9] fsr: always print error messages from xfrog_defragrange()

Christoph Hellwig (15):
      [319921d5773b] xfs: move struct xfs_log_iovec to xfs_log_priv.h
      [d73928379174] xfs: directly include xfs_platform.h
      [13bfe767e058] xfs: remove xfs_attr_leaf_hasname
      [521c29955c4c] xfs: add a xfs_rtgroup_raw_size helper
      [08b2e420e141] xfs: split and refactor zone validation
      [1edef5ba034f] xfs: don't validate error tags in the I/O path
      [8d800684e9ef] xfs: add zone reset error injection
      [a4bb45b0e5ae] xfs: give the defer_relog stat a xs_ prefix
      [4b3284ed006f] xfs: remove metafile inodes from the active inode stat
      [9ad485e75832] scrub: remove the unused io_disk field in struct read_verify
      [f529481a7a72] scrub: simplify the read_verify_pool_alloc interface
      [6ce165b0f44a] scrub: use enum xfs_device for read verification
      [1ef66d39b75b] scrub: simplify verifier threads calculation
      [9cd59bf3cf78] xfs_scrub: move disk media verification error injection
      [d0ba8a9348ae] scrub: don't allocate disk for ioctl-based media verify

Damien Le Moal (1):
      [df9839b1dd08] xfs: add missing forward declaration in xfs_zones.h

Darrick J. Wong (67):
      [eb06f16ca2e9] xfs_repair: don't fail on INCOMPLETE attrs in leaf blocks
      [b8719a1dd2a0] libxfs: fix XFS_STATS_DEC
      [1b8bca4e0bd1] libxfs: port various kernel apis from 7.0
      [68cbbe7c8c4d] libfrog: hoist some utilities from libxfs
      [a6ff7e6e175c] libfrog: fix missing gettext call in current_fixed_time
      [a1f2281c5987] xfs: start creating infrastructure for health monitoring
      [d5017c673367] xfs: create event queuing, formatting, and discovery infrastructure
      [b8f406861a22] xfs: convey filesystem unmount events to the health monitor
      [207a7d1e6b7c] xfs: convey metadata health events to the health monitor
      [47ab0cd74ec5] xfs: convey filesystem shutdown events to the health monitor
      [e2d9636f998f] xfs: convey externally discovered fsdax media errors to the health monitor
      [00cb02ecf24b] xfs: convey file I/O errors to the health monitor
      [ac360cbefe20] xfs: check if an open file is on the health monitored fs
      [b669642fe6fa] xfs: add media verification ioctl
      [3d1a4fec942d] xfs: delete attr leaf freemap entries when empty
      [726d84515668] xfs: fix freemap adjustments when adding xattrs to leaf blocks
      [eec406054fb1] xfs: refactor attr3 leaf table size computation
      [31d5bf696c60] xfs: strengthen attr leaf block freemap checking
      [75d34e4a58f5] xfs: reduce xfs_attr_try_sf_addname parameters
      [7ba08aabba0c] xfs: speed up parent pointer operations when possible
      [f61109373545] xfs: add a method to replace shortform attrs
      [b2fc3c686b2a] libfrog: add a function to grab the path from an open fd and a file handle
      [3774cbe05939] libfrog: create healthmon event log library functions
      [6839b8314a49] libfrog: add support code for starting systemd services programmatically
      [27ddec39aa0d] libfrog: hoist a couple of service helper functions
      [67fc0c99ea51] libfrog: add wrappers for listmount and statmount
      [92043e66ae68] man2: document the healthmon ioctl
      [d93adb823122] man2: document the media verification ioctl
      [eba72901c88c] xfs_io: monitor filesystem health events
      [bbed6dcf85f3] xfs_io: add a media verify command
      [b9b03770197d] xfs_healer: create daemon to listen for health events
      [6f0f35a87c87] xfs_healer: enable repairing filesystems
      [17d840245c0e] xfs_healer: use getparents to look up file names
      [88825fe0de0d] xfs_healer: create a per-mount background monitoring service
      [428bd63ab404] xfs_healer: create a service to start the per-mount healer service
      [ea178059ff72] xfs_healer: don't start service if kernel support unavailable
      [bf8b99270c6b] xfs_healer: use the autofsck fsproperty to select mode
      [a162dc462186] xfs_healer: run full scrub after lost corruption events or targeted repair failure
      [54c0ba68b007] xfs_healer: use getmntent to find moved filesystems
      [327f964dd6f0] xfs_healer: use statmount to find moved filesystems even faster
      [c2425375f293] xfs_healer: validate that repair fds point to the monitored fs
      [c5d8a2ad1d28] xfs_healer: add a manual page
      [99a6f427c4fd] xfs_scrub: print systemd service names
      [505afcfda5c5] xfs_io: add listmount and statmount commands
      [8aed3354e429] mkfs: enable online repair if all backrefs are enabled
      [dfee401c10bc] debian/control: listify the build dependencies
      [bd61d2b9c852] debian: enable xfs_healer on the root filesystem by default
      [e768971e2fdf] libfrog: allow bitmap_free to handle a null bitmap pointer
      [50d8b74334f1] mkfs: rename byte unit conversion macros
      [e8249d9649ec] libfrog: lift *BYTES helpers to convert.h
      [4e0c9692f6a8] xfs_scrub: report truncated devices as media errors
      [b2a12740b115] xfs_scrub: fix i18n of the decode_special_owner return value
      [acc91b2a53cd] xfs_scrub: move read verification scheduling to phase6.c
      [56e731dac4df] xfs_scrub: don't pass the io_end_arg around everywhere
      [cc2c8a000836] xfs_scrub: rename nr_io_threads
      [02760878dd86] xfs_scrub: use the verify media ioctl during phase 6 if possible
      [95a92c5cecb2] xfs_scrub: perform media scanning of the log region
      [8a537ebc7066] xfs_scrub: index read-verify pools by xfs_device ids
      [58fca77c2d2a] xfs_scrub: move failmap and other outputs into read_verify_pool
      [c2e07d407aee] xfs_scrub: clean up device-related error messages
      [5eb6d67a8319] xfs_scrub: drop SCSI_VERIFY code from disk.
      [8ef7291a272e] xfs_scrub: raise media verification IO limits
      [1a5eeddf738c] xfs_healer: update weakhandle mountpoint when reconnecting
      [1068708f7ada] debian: add version control tags to control
      [95329f9fa130] xfs_scrub: warn about unicode variation selectors in names
      [1c52b36e3234] xfs_scrub_all: fix deadlock if lsblk produces a lot of output
      [5f5d7fe4a7ef] xfs_scrub: drop the warning about mixed bidirectional codepoints in names

Kees Cook (1):
      [7c7f99c57a13] treewide: Replace kmalloc with kmalloc_obj for non-scalar types

Linus Torvalds (1):
      [e89513b094c0] Convert 'alloc_obj' family to use the new default GFP_KERNEL argument

Long Li (2):
      [e7aab724c89a] xfs: factor out xfs_attr3_node_entry_remove
      [922f14a9b776] xfs: factor out xfs_attr3_leaf_init

Nirjhar Roy (IBM) (2):
      [1dff948c0bbd] xfs: Refactoring the nagcount and delta calculation
      [806d742e6d03] xfs: Add a comment in xfs_log_sb()

Ravi Singh (1):
      [a8eb7b321371] xfs_quota: display default limits for users with zero usage

Shin Seong-jun (1):
      [d0dd6ec5156a] xfs: fix spacing style issues in xfs_alloc.c

Thiago Becker (1):
      [9d0bd1ecce3d] libxfs: fix printing of cache.c_maxcount.

Wilfred Mallawa (3):
      [5f18c380c619] xfs: fix code alignment issues in xfs_ondisk.c
      [b6a84a375fe0] xfs: remove duplicate static size checks
      [43b6c8457c1a] xfs: add static size checks for ioctl UABI

hongao (1):
      [8a5e47ac6985] xfs: Remove redundant NULL check after __GFP_NOFAIL

Code Diffstat:

 Makefile                                       |   5 +
 VERSION                                        |   4 +-
 configure.ac                                   |  15 +-
 db/bmap_inflate.c                              |   2 +-
 debian/changelog                               |   6 +
 debian/control                                 |  16 +-
 debian/postinst                                |   8 +
 debian/prerm                                   |  13 +
 debian/rules                                   |   3 +-
 doc/CHANGES                                    |  40 ++
 doc/README-env-vars.txt                        |   1 -
 fsr/xfs_fsr.c                                  |  12 +-
 healer/Makefile                                |  69 +++
 healer/fsrepair.c                              | 342 ++++++++++++
 healer/system-xfs_healer.slice                 |  31 ++
 healer/weakhandle.c                            | 324 ++++++++++++
 healer/xfs_healer.c                            | 693 +++++++++++++++++++++++++
 healer/xfs_healer.h                            |  92 ++++
 healer/xfs_healer@.service.in                  | 108 ++++
 healer/xfs_healer_start.c                      | 371 +++++++++++++
 healer/xfs_healer_start.service.in             |  85 +++
 include/builddefs.in                           |  15 +
 include/kmem.h                                 |  50 ++
 include/libxfs.h                               |   7 +-
 include/linux.h                                |   8 +-
 include/platform_defs.h                        |  11 +
 include/xfs_fs_compat.h                        |   8 -
 include/xfs_trace.h                            |   1 +
 io/Makefile                                    |   9 +-
 io/healthmon.c                                 | 191 +++++++
 io/init.c                                      |   3 +
 io/io.h                                        |   8 +
 io/listmount.c                                 | 367 +++++++++++++
 io/verify_media.c                              | 181 +++++++
 libfrog/Makefile                               |  23 +
 libfrog/bitmap.c                               |   3 +
 libfrog/convert.c                              |   7 -
 libfrog/convert.h                              |   7 +
 libfrog/flagmap.c                              |  79 +++
 libfrog/flagmap.h                              |  23 +
 libfrog/fsproperties.h                         |   5 +
 libfrog/getparents.c                           |  93 +++-
 libfrog/getparents.h                           |   4 +
 libfrog/healthevent.c                          | 477 +++++++++++++++++
 libfrog/healthevent.h                          |  55 ++
 libfrog/statmount.c                            |  76 +++
 libfrog/statmount.h                            | 104 ++++
 libfrog/systemd.c                              | 188 +++++++
 libfrog/systemd.h                              |  55 ++
 libfrog/util.c                                 | 166 ++++++
 libfrog/util.h                                 |  21 +
 libxfs/Makefile                                |   4 +-
 libxfs/buf_mem.c                               |   2 +-
 libxfs/cache.c                                 |   4 +-
 libxfs/defer_item.c                            |   2 +-
 libxfs/init.c                                  |   2 +-
 libxfs/inode.c                                 |   2 +-
 libxfs/iunlink.c                               |   2 +-
 libxfs/kmem.c                                  |   2 +-
 libxfs/libxfs_api_defs.h                       |   2 +-
 libxfs/logitem.c                               |   2 +-
 libxfs/rdwr.c                                  |   2 +-
 libxfs/topology.c                              |   2 +-
 libxfs/trans.c                                 |   2 +-
 libxfs/util.c                                  | 162 +-----
 libxfs/xfblob.c                                |   2 +-
 libxfs/xfile.c                                 |   2 +-
 libxfs/xfs_ag.c                                |  32 +-
 libxfs/xfs_ag.h                                |   3 +
 libxfs/xfs_ag_resv.c                           |   2 +-
 libxfs/xfs_alloc.c                             |  10 +-
 libxfs/xfs_alloc_btree.c                       |   2 +-
 libxfs/xfs_attr.c                              | 191 ++++---
 libxfs/xfs_attr.h                              |   9 +-
 libxfs/xfs_attr_leaf.c                         | 219 ++++++--
 libxfs/xfs_attr_leaf.h                         |   4 +
 libxfs/xfs_attr_remote.c                       |   2 +-
 libxfs/xfs_bit.c                               |   2 +-
 libxfs/xfs_bmap.c                              |   2 +-
 libxfs/xfs_bmap_btree.c                        |   2 +-
 libxfs/xfs_btree.c                             |   2 +-
 libxfs/xfs_btree_mem.c                         |   2 +-
 libxfs/xfs_btree_staging.c                     |   2 +-
 libxfs/xfs_da_btree.c                          |  63 ++-
 libxfs/xfs_da_btree.h                          |   2 +
 libxfs/xfs_da_format.h                         |   2 +-
 libxfs/xfs_defer.c                             |   8 +-
 libxfs/xfs_dir2.c                              |  21 +-
 libxfs/xfs_dir2_block.c                        |   2 +-
 libxfs/xfs_dir2_data.c                         |   2 +-
 libxfs/xfs_dir2_leaf.c                         |   2 +-
 libxfs/xfs_dir2_node.c                         |   2 +-
 libxfs/xfs_dir2_sf.c                           |   2 +-
 libxfs/xfs_dquot_buf.c                         |   2 +-
 libxfs/xfs_errortag.h                          |   8 +-
 libxfs/xfs_exchmaps.c                          |   2 +-
 libxfs/xfs_fs.h                                | 189 +++++++
 libxfs/xfs_group.c                             |   2 +-
 libxfs/xfs_health.h                            |   5 +
 libxfs/xfs_ialloc.c                            |   2 +-
 libxfs/xfs_ialloc_btree.c                      |   2 +-
 libxfs/xfs_iext_tree.c                         |   2 +-
 libxfs/xfs_inode_buf.c                         |   6 +-
 libxfs/xfs_inode_fork.c                        |   2 +-
 libxfs/xfs_inode_util.c                        |   2 +-
 libxfs/xfs_log_format.h                        |   7 -
 libxfs/xfs_log_rlimit.c                        |   2 +-
 libxfs/xfs_metadir.c                           |   2 +-
 libxfs/xfs_metafile.c                          |   7 +-
 libxfs/xfs_ondisk.h                            |  52 +-
 libxfs/xfs_parent.c                            |  16 +-
 libxfs/{libxfs_priv.h => xfs_platform.h}       |  25 +-
 libxfs/xfs_refcount.c                          |   6 +-
 libxfs/xfs_refcount_btree.c                    |   2 +-
 libxfs/xfs_rmap.c                              |   2 +-
 libxfs/xfs_rmap_btree.c                        |   2 +-
 libxfs/xfs_rtbitmap.c                          |   2 +-
 libxfs/xfs_rtgroup.c                           |   4 +-
 libxfs/xfs_rtgroup.h                           |  15 +
 libxfs/xfs_rtrefcount_btree.c                  |   2 +-
 libxfs/xfs_rtrmap_btree.c                      |   2 +-
 libxfs/xfs_sb.c                                |   5 +-
 libxfs/xfs_symlink_remote.c                    |   2 +-
 libxfs/xfs_trans_inode.c                       |   2 +-
 libxfs/xfs_trans_resv.c                        |   2 +-
 libxfs/xfs_trans_space.c                       |   2 +-
 libxfs/xfs_types.c                             |   2 +-
 libxfs/xfs_zones.c                             | 151 ++----
 libxfs/xfs_zones.h                             |   6 +-
 libxlog/xfs_log_recover.c                      |   4 +-
 m4/package_libcdev.m4                          | 129 +++++
 man/man2/ioctl_xfs_health_fd_on_monitored_fs.2 |  75 +++
 man/man2/ioctl_xfs_health_monitor.2            | 464 +++++++++++++++++
 man/man2/ioctl_xfs_verify_media.2              | 197 +++++++
 man/man8/Makefile                              |  40 +-
 man/man8/xfs_healer.8                          | 121 +++++
 man/man8/xfs_healer_start.8                    |  37 ++
 man/man8/xfs_io.8                              | 133 +++++
 mdrestore/xfs_mdrestore.c                      |   5 +-
 mkfs/xfs_mkfs.c                                |  47 +-
 quota/quota.c                                  |   9 +-
 repair/agbtree.c                               |   3 +-
 repair/attr_repair.c                           |  22 +-
 repair/bmap_repair.c                           |   3 +-
 repair/rmap.c                                  |   3 +-
 repair/xfs_repair.c                            |   5 +-
 repair/zoned.c                                 |   7 +-
 scrub/Makefile                                 |  16 +-
 scrub/common.c                                 |  19 +-
 scrub/disk.c                                   | 204 --------
 scrub/disk.h                                   |   2 -
 scrub/fscounters.c                             |   4 +-
 scrub/fscounters.h                             |   2 +-
 scrub/phase1.c                                 |  91 +++-
 scrub/phase5.c                                 |   6 +-
 scrub/phase6.c                                 | 424 ++++++++-------
 scrub/phase7.c                                 |   7 +-
 scrub/phase8.c                                 |   3 +-
 scrub/read_verify.c                            | 451 +++++++++++-----
 scrub/read_verify.h                            |  34 +-
 scrub/spacemap.h                               |   5 +
 scrub/unicrash.c                               |  52 +-
 scrub/xfs_scrub.c                              |  83 ++-
 scrub/xfs_scrub.h                              |  12 +-
 scrub/xfs_scrub_all.py.in                      |  13 +-
 165 files changed, 7258 insertions(+), 1291 deletions(-)
 create mode 100644 debian/prerm
 create mode 100644 healer/Makefile
 create mode 100644 healer/fsrepair.c
 create mode 100644 healer/system-xfs_healer.slice
 create mode 100644 healer/weakhandle.c
 create mode 100644 healer/xfs_healer.c
 create mode 100644 healer/xfs_healer.h
 create mode 100644 healer/xfs_healer@.service.in
 create mode 100644 healer/xfs_healer_start.c
 create mode 100644 healer/xfs_healer_start.service.in
 create mode 100644 io/healthmon.c
 create mode 100644 io/listmount.c
 create mode 100644 io/verify_media.c
 create mode 100644 libfrog/flagmap.c
 create mode 100644 libfrog/flagmap.h
 create mode 100644 libfrog/healthevent.c
 create mode 100644 libfrog/healthevent.h
 create mode 100644 libfrog/statmount.c
 create mode 100644 libfrog/statmount.h
 create mode 100644 libfrog/systemd.c
 create mode 100644 libfrog/systemd.h
 rename libxfs/{libxfs_priv.h => xfs_platform.h} (96%)
 create mode 100644 man/man2/ioctl_xfs_health_fd_on_monitored_fs.2
 create mode 100644 man/man2/ioctl_xfs_health_monitor.2
 create mode 100644 man/man2/ioctl_xfs_verify_media.2
 create mode 100644 man/man8/xfs_healer.8
 create mode 100644 man/man8/xfs_healer_start.8

-- 
- Andrey
