Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726164AbfAaSJb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 Jan 2019 13:09:31 -0500
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 00/10] xfs: stable fixes for v4.19.y
Date: Thu, 31 Jan 2019 10:09:09 -0800
Message-Id: <20190131180919.2500-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org, Alexander.Levin@microsoft.com
Cc: amir73il@gmail.com, hch@infradead.org, Luis Chamberlain <mcgrof@kernel.org>

I've volunteered to help with stable XFS maintenance at LSFMM. This is
the initial set of work as a result of this.

For stable v4.20.y I have not identified any candidate fixes. I'll keep
monitoring development for potential fixes.

For v4.19.y I have identified 10 candidate fixes I'd like to propose and
if there are no issues found with them by folks, I'd like to ask for
these to be merged on the next v4.19.y stable push. They are available
in git form on my linux-stable linux-xfs-4.19.y branch [0] and consist
of the patches posted in this series.

As part of this effort I've established and will be tracking a baseline
for fstests for XFS for v4.20.y and v4.19.y on oscheck [1], an OS
wrapper for fstests check, so long as they are maintained as longterm
kernels by the stable kernel team.  Since an issue creeped up with 64k
blocks recently [2] I've decided to extend my test coverage to also
include 64k block sizes on XFS. For this I'm using a powerpc ppc64le
system provided by Brazil's OpenPOWER@UNICAMP [3], a university effort.
This is refleced by a new section to test on oscheck "xfs_bigblock".
One patch in this series fixes that issue on v4.19.y.

I'm aware of Brian Foster's patch "xfs: eof trim writeback mapping as
soon as it is cached" which I do confirm fixes fstests generic/464, as
soon as that gets merged on Linus' tree we can push it through.

Perhaps the most questionable fixes are two fixes extracted from a
series of 7 by David Chinner [4]. I'm farily certain these two patches
are independent, however further feedback / confirmation from others is
greatly appreciated:

xfs: fix transient reference count error in xfs_buf_resubmit_failed_buffers
xfs: delalloc -> unwritten COW fork allocation can go wrong

As promised at LSFMM, to help with even further being careful about
stable XFS patches I would have at least another pair of eyeballs review
this new stable effort, as such I volunteered Amir Goldstein's eyeballs
for this series and he also concurs that the set of fixes are sensible
and independent -- they don't have any missing dependencies.

Worth noting is that since VFS iomap fixes are trickling through the XFS
tree, I asked Christoph to take a look at those independently, and he's
willing to do so. If we want to eventually bundle those together with
XFS stable fixes we can, its just they will require further review from
Christoph.

Reviews, questions, or rants are greatly appreciated.

[0] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux-stable.git/log/?h=linux-xfs-4.19.y
[1] https://gitlab.com/mcgrof/oscheck.git
[2] https://bugzilla.kernel.org/show_bug.cgi?id=201577
[3] http://openpower.ic.unicamp.br/
[4] https://patchwork.kernel.org/cover/10689445/

Brian Foster (1):
  xfs: fix shared extent data corruption due to missing cow reservation

Carlos Maiolino (1):
  xfs: Fix xqmstats offsets in /proc/fs/xfs/xqmstat

Christoph Hellwig (1):
  xfs: cancel COW blocks before swapext

Christophe JAILLET (1):
  xfs: Fix error code in 'xfs_ioc_getbmap()'

Darrick J. Wong (1):
  xfs: fix PAGE_MASK usage in xfs_free_file_space

Dave Chinner (3):
  xfs: fix overflow in xfs_attr3_leaf_verify
  xfs: fix transient reference count error in
    xfs_buf_resubmit_failed_buffers
  xfs: delalloc -> unwritten COW fork allocation can go wrong

Eric Sandeen (1):
  xfs: fix inverted return from xfs_btree_sblock_verify_crc

Ye Yin (1):
  fs/xfs: fix f_ffree value for statfs when project quota is set

 fs/xfs/libxfs/xfs_attr_leaf.c | 11 +++++++++--
 fs/xfs/libxfs/xfs_bmap.c      |  5 ++++-
 fs/xfs/libxfs/xfs_btree.c     |  2 +-
 fs/xfs/xfs_bmap_util.c        | 10 ++++++++--
 fs/xfs/xfs_buf_item.c         | 28 +++++++++++++++++++++-------
 fs/xfs/xfs_ioctl.c            |  2 +-
 fs/xfs/xfs_qm_bhv.c           |  2 +-
 fs/xfs/xfs_reflink.c          |  1 +
 fs/xfs/xfs_stats.c            |  2 +-
 9 files changed, 47 insertions(+), 16 deletions(-)

-- 
2.18.0
