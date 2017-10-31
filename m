Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:40317 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932781AbdJaWmz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Oct 2017 18:42:55 -0400
Date: Wed, 1 Nov 2017 09:42:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: build warning after merge of the xfs tree
Message-ID: <20171101093957.1d1c45d9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, David Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

Hi all,

After merging the xfs tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

fs/xfs/libxfs/xfs_bmap.c: In function 'xfs_bmap_del_extent_delay':
fs/xfs/libxfs/xfs_bmap.c:4648:20: warning: unused variable 'ifp' [-Wunused-variable]
  struct xfs_ifork *ifp = XFS_IFORK_PTR(ip, whichfork);
                    ^
fs/xfs/libxfs/xfs_bmap.c: In function 'xfs_bmap_del_extent_cow':
fs/xfs/libxfs/xfs_bmap.c:4776:20: warning: unused variable 'ifp' [-Wunused-variable]
  struct xfs_ifork *ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
                    ^

Introduced by commit

  ca5d8e5b7b90 ("xfs: move pre/post-bmap tracing into xfs_iext_update_extent")

-- 
Cheers,
Stephen Rothwell
