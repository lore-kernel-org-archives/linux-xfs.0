Received: from buxtehude.debian.org (buxtehude.debian.org [209.87.16.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2AB13603DB
	for <linux-xfs@vger.kernel.org>; Mon, 19 Oct 2026 07:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.87.16.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792393390; cv=none; b=XQPCUayRdZGw0/N0a2B1+WUHZDirQztsF9Xjn3tbpTwnl5Rw1XhLRjqhPGGQNhj/k3nAqHDwLNAa3wWWvX+70TZ/Fzzfs8nkhjuFLmas5Ox7ew0iEdwTloh+ytzSphh80rb8/fkuRXbdO7Bbwsqk5F+F141Zn+0S+KCdVs2mWdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792393390; c=relaxed/simple;
	bh=obrvrLa2H3yQ4YVVTJ5VAigLj6RuppVmzqHiP7MMJgc=;
	h=Subject:References:Date:From:To:Cc:Message-ID:MIME-Version:
	 Content-Type:Content-Disposition; b=NtXwRwJ82xM0+TiW6hKqiRXkfog8PS97mOOhHJHr+Oj1z3F91w458lW8WpTS2TdI+0EXFJRnRTfM+vOENNKP+1w9++voZQ7ms+zq3zmHxSFy7MCx+K801HFgd36Tf8IB4C8Bo+E7uccCAbewqjN6vORDeI+2rUdKvnZ4RumAVgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=buxtehude.debian.org; dkim=fail (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oyWgKHo7 reason="signature verification failed"; arc=none smtp.client-ip=209.87.16.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=buxtehude.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oyWgKHo7"
Received: from debbugs by buxtehude.debian.org with local (Exim 4.96)
	(envelope-from <debbugs@buxtehude.debian.org>)
	id 1xIhOg-005jdB-0H;
	Mon, 19 Oct 2026 07:03:02 +0000
X-Loop: owner@bugs.debian.org
Subject: Bug#1149571: [ANNOUNCE] xfsprogs: v7.2.1 released
Reply-To: Andrey Albershteyn <aalbersh@kernel.org>, 1149571@bugs.debian.org
Resent-From: Andrey Albershteyn <aalbersh@kernel.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-CC: linux-xfs@vger.kernel.org
X-Loop: owner@bugs.debian.org
Resent-Date: Mon, 19 Oct 2026 07:03:02 +0000
Resent-Message-ID: <handler.1149571.B1149571.17923933111366601@bugs.debian.org>
X-Debian-PR-Message: followup 1149571
X-Debian-PR-Package: xfsprogs
X-Debian-PR-Keywords: 
References: <179080491253.7201.8697529754428195540.reportbug@mars>
X-Debian-PR-Source: xfsprogs
Received: via spool by 1149571-submit@bugs.debian.org id=B1149571.17923933111366601
          (code B ref 1149571); Mon, 19 Oct 2026 07:03:02 +0000
Received: (at 1149571) by bugs.debian.org; 19 Oct 2026 07:01:51 +0000
X-Spam-Level: 
X-Spam-Bayes: score:0.0000 Tokens: new, 322; hammy, 150; neutral, 203; spammy,
	0. spammytokens: hammytokens:0.000-+--UD:kernel.org,
	0.000-+--configureac, 0.000-+--configure.ac, 0.000-+--UD:configure.ac,
	0.000-+--diffstat
Received: from sea.source.kernel.org ([172.234.252.31]:60324)
	by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <aalbersh@kernel.org>)
	id 1xIhNX-005jVj-1x
	for 1149571@bugs.debian.org;
	Mon, 19 Oct 2026 07:01:51 +0000
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F03CB40BF1;
	Mon, 19 Oct 2026 07:01:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 892721F000C4;
	Mon, 19 Oct 2026 07:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792393309;
	bh=btUOL1/WSEygXcmgbxsleRb8BS7pEX62qxJ8gYBeFJw=;
	h=Date:From:To:Cc:Subject;
	b=oyWgKHo7Wcx/TGDqR0y4q0hGFS8bUSvj4x7G0y0YZJKWDyJiRI7ei9lZyj9UOOQMT
	 NkBpLbjKM4yj1iOdFGWPTF+VZvm/7bn/juA+XuM5/g+riHBCzt6QGF/yI7UaH3v2A4
	 OvgHLeegV5KiciZfHoedrKUhKnB/9OOZkX2rjSE+7TQRIv1fHxGP0NCqX8Qrae2AC1
	 Dtj7OdQgze2S3g2NSV/UvWQVO4E4zPh0wLEJyRm10fOB/GZpHAU6V8TET5pXNQ7ofU
	 NwqzBZe/Et+9mBwOsBBLuilJxBFgpPNRptNEqyDZHqKpR3p0IZhQfmVUwD8A2rvKML
	 tsh9MmuQw1btw==
Date: Mon, 19 Oct 2026 09:01:45 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: 1149571@bugs.debian.org, aalbersh@kernel.org, biebl@debian.org, 
	djwong@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org, sandeen@redhat.com, 
	wilfred.mallawa@wdc.com
Message-ID: <atXAJ7URtviMiU4g@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Message-ID: <20261019070145.qv5Eo8EfJH-uO1mZRm9j0ZtTzwKjruZDdavyQivmp98@z>

Hi folks,

The xfsprogs master branch in repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

This release fixes xfs_healer service failing for non-xfs / root. The xfs_scrub
services are now stopped on the filesystem unmount, previously these services
kept mount reference preventing umount. The bug in xfs_repair attempting to
repair a rtdev device which is not actually rtdev was fixed. xfs_io's aginfo
command now reports writepointer block offset for realtime/zoned devices. The
mkfs.xfs defaults= and cli quota options now correctly disables quota in the
case when defaults= has quota enabled but cli options disables them. The rest is
internal clean-ups and bugfixes.

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The for-next branch has also been updated to match the state of master.

The new head of the master branch is commit:

5b1b80646faa2c3329e6117c3c8a2641091c4519

New commits:

Andrey Albershteyn (1):
      [5b1b80646faa] xfsprogs: Release v7.2.1

Christoph Hellwig (24):
      [d67bdf8007b6] man: fix alignment of the rtstart field in ioctl_xfs_fsgeometry.2
      [8a4a368b497d] libxfs: refactor the reinit case in libxfs_buftarg_init
      [08c91516ffa7] libxfs: split error injection option parsing out of libxfs_buftarg_init
      [8f9506e2dafc] libxfs: remove buftarg member aliases
      [35e136a42548] libxfs: unify buftarg handling with the kernel
      [55ec0ef299d5] libxfs: make the size check in rtmount_init internal RT device aware
      [c189d771732e] libxfs: don't clear ->dev in libxfs_device_close
      [45c2b2ae6968] libxfs: fix buftarg initialization for the RT device
      [d69aadab419e] libxfs: rename bt_bdev*
      [5f82a09e37bc] libfrog: improve ramdisk handling in platform_flush_device
      [e58810a53900] xfs_db: remove a double-whitespace in rdump_regfile_data
      [9c2eaf73c5c2] libxfs: use libxfs.h in xfs_platform.h
      [33ac6b04db36] libxfs: provide memalloc_nofs_{save,restore} stubs
      [9eff420fe37f] libxfs: remove a spurious xfs_rtbitmap.h include in xfs_sb.c
      [4f91e3833ef1] libxfs: move the xfs_rtbitmap.h include in xfs_bmap.c
      [d4eae695d6fa] libxfs: remove the unused xfs_log_item.li_mountp field
      [02cc96ba6bd3] libxfs: remove the unused xfs_inode_log_item.ili_fsync_fields field
      [d6af7a826718] libxfs: remove the xfs_log_item_t and xfs_buf_log_item_t typedefs
      [54b8f286f080] libxfs: remove libxfs_trans_alloc_rollable
      [7d413dd9c5f2] libxfs: return int from xfs_buf_item_init
      [31d51bd0c487] libxfs: use xfs_buf_item.h and xfs_inode_item.h from the kernel source
      [7e217148b3eb] libxfs: cleanup xfs_trans.h
      [fa19604607c1] libxfs: use xfs_trans.h from the kernel source
      [809419124ced] libxfs: use all log item headers from the kernel

Darrick J. Wong (7):
      [a594f085447f] xfs_scrub: terminate systemd services if the sysadmin unmounts
      [73662a3e91d4] mkfs: allow disabling quota flags
      [f2e443ce2107] xfs_quota: fix XFS_GETQSTAT parameter pointer
      [d28edf8b3722] xfs_healer: correct xfd_ API usage
      [fde1eeed253a] xfs_healer: fail earlier on non-xfs filesystems
      [6c62ff9b47e9] misc: convert as many xfsquotactl callsites to xfrog_quotactl as possible
      [989686ca4e74] quotactl: deploy typechecked helpers

Eric Sandeen (3):
      [196c46c1bd31] libxfs: change cache_node_allocate function signature
      [92d45f837671] libxfs: Return -ENOMEM on actual cache node allocation failures
      [caca7f14b449] libxfs: do not allow cache growth to overflow

Wilfred Mallawa (2):
      [bc84c74ae73d] xfs_io: report rg_writepointer in report rg_info()
      [bf0ec1d8a2b6] man/xfs_rtgroup_geometry: add rg_writepointer field description

Code Diffstat:

 VERSION                                  |   2 +-
 configure.ac                             |   2 +-
 copy/xfs_copy.c                          |   2 +-
 db/io.c                                  |   4 +-
 db/logformat.c                           |   4 +
 db/metadump.c                            |   7 +-
 db/rdump.c                               |   2 +-
 debian/changelog                         |   6 +
 doc/CHANGES                              |  10 ++
 healer/xfs_healer.c                      |  14 +-
 include/atomic.h                         |   1 +
 include/libxfs.h                         |   4 +-
 io/aginfo.c                              |   3 +
 libfrog/linux.c                          |  13 +-
 libfrog/platform.h                       |   2 +-
 libfrog/quotactl.h                       |  60 +++++++
 libxfs/Makefile                          |  18 +-
 libxfs/buf_mem.c                         |   5 +-
 libxfs/cache.c                           |  54 ++++--
 libxfs/defer_item.c                      |   3 +-
 libxfs/defer_item.h                      |  56 ------
 libxfs/init.c                            | 163 ++++++++++--------
 libxfs/inode.c                           |   1 +
 libxfs/iunlink.c                         |  10 +-
 libxfs/libxfs_api_defs.h                 |   1 +
 libxfs/libxfs_io.h                       |   4 +-
 libxfs/logitem.c                         |  19 ++-
 libxfs/rdwr.c                            |  50 +++---
 libxfs/stubs/xfs_inode.h                 |   8 +
 libxfs/stubs/xfs_log.h                   |   7 +
 libxfs/stubs/xfs_mount.h                 |   3 -
 libxfs/stubs/xfs_trans.h                 | 167 ------------------
 libxfs/stubs/xfs_trans_priv.h            |  16 ++
 libxfs/trans.c                           |  68 +++++---
 libxfs/util.c                            |   3 +-
 libxfs/xfs_alloc.c                       |   4 +-
 libxfs/xfs_attr.c                        |   2 +-
 libxfs/xfs_attr_item.h                   |  64 +++++++
 libxfs/xfs_attr_leaf.c                   |   2 +
 libxfs/xfs_bmap.c                        |   5 +-
 libxfs/xfs_bmap_item.h                   |  78 +++++++++
 libxfs/xfs_btree.c                       |   2 +
 libxfs/xfs_btree_mem.c                   |   1 +
 libxfs/xfs_buf_item.h                    |  71 ++++++++
 libxfs/xfs_da_btree.c                    |   2 +
 libxfs/xfs_defer.c                       |   4 +
 libxfs/xfs_dir2_block.c                  |   2 +
 libxfs/xfs_dir2_data.c                   |   2 +
 libxfs/xfs_dir2_leaf.c                   |   1 +
 libxfs/xfs_dir2_node.c                   |   2 +
 libxfs/xfs_exchmaps.c                    |   2 +-
 libxfs/xfs_exchmaps_item.h               |  64 +++++++
 libxfs/xfs_extfree_item.h                | 100 +++++++++++
 libxfs/xfs_ialloc.c                      |   3 +
 libxfs/xfs_icreate_item.h                |  22 +++
 libxfs/xfs_inode_fork.c                  |   1 +
 libxfs/xfs_inode_item.h                  |  62 +++++++
 libxfs/xfs_inode_util.c                  |   3 +-
 libxfs/{iunlink.h => xfs_iunlink_item.h} |  17 +-
 libxfs/xfs_parent.c                      |   2 +-
 libxfs/xfs_platform.h                    |  57 +------
 libxfs/xfs_refcount.c                    |   2 +-
 libxfs/xfs_refcount_item.h               |  82 +++++++++
 libxfs/xfs_rmap.c                        |   2 +-
 libxfs/xfs_rmap_item.h                   |  81 +++++++++
 libxfs/xfs_rtbitmap.c                    |   2 +
 libxfs/xfs_rtgroup.c                     |   1 +
 libxfs/xfs_sb.c                          |   3 +-
 libxfs/xfs_symlink_remote.c              |   2 +
 libxfs/xfs_trans.h                       | 283 +++++++++++++++++++++++++++++++
 libxfs/xfs_trans_inode.c                 |   3 +-
 libxfs/xfs_trans_resv.c                  |   8 +-
 man/man2/ioctl_xfs_fsgeometry.2          |   2 +-
 man/man2/ioctl_xfs_rtgroup_geometry.2    |   8 +-
 mkfs/proto.c                             |   8 +-
 mkfs/xfs_mkfs.c                          |  55 +++---
 quota/edit.c                             |  84 ++++-----
 quota/free.c                             |   6 +-
 quota/path.c                             |   2 +-
 quota/quota.c                            |   4 +-
 quota/report.c                           |  22 +--
 quota/state.c                            |  12 +-
 repair/attr_repair.c                     |  11 +-
 repair/da_util.c                         |   2 +-
 repair/dino_chunks.c                     |   8 +-
 repair/dinode.c                          |   8 +-
 repair/phase2.c                          |   1 +
 repair/phase3.c                          |   2 +-
 repair/phase5.c                          |   9 +-
 repair/phase6.c                          |   3 +-
 repair/prefetch.c                        |   6 +-
 repair/quotacheck.c                      |   2 +-
 repair/rmap.c                            |   5 +-
 repair/rt.c                              |   2 +-
 repair/scan.c                            |  16 +-
 repair/zoned.c                           |   2 +-
 scrub/xfs_scrub@.service.in              |   3 +
 scrub/xfs_scrub_media@.service.in        |   3 +
 spaceman/info.c                          |  15 +-
 99 files changed, 1521 insertions(+), 616 deletions(-)
 delete mode 100644 libxfs/defer_item.h
 create mode 100644 libxfs/stubs/xfs_log.h
 delete mode 100644 libxfs/stubs/xfs_trans.h
 create mode 100644 libxfs/stubs/xfs_trans_priv.h
 create mode 100644 libxfs/xfs_attr_item.h
 create mode 100644 libxfs/xfs_bmap_item.h
 create mode 100644 libxfs/xfs_buf_item.h
 create mode 100644 libxfs/xfs_exchmaps_item.h
 create mode 100644 libxfs/xfs_extfree_item.h
 create mode 100644 libxfs/xfs_icreate_item.h
 create mode 100644 libxfs/xfs_inode_item.h
 rename libxfs/{iunlink.h => xfs_iunlink_item.h} (61%)
 create mode 100644 libxfs/xfs_refcount_item.h
 create mode 100644 libxfs/xfs_rmap_item.h
 create mode 100644 libxfs/xfs_trans.h

-- 
- Andrey
