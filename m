Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:49125 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752306AbdKHFYA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 8 Nov 2017 00:24:00 -0500
Date: Wed, 8 Nov 2017 16:23:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: build failure after merge of the kspp tree
Message-ID: <20171108162358.3a6d96bb@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Kees Cook <keescook@google.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, David Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, David Windsor <dave@nullcore.net>, Christoph Hellwig <hch@lst.de>

Hi Kees,

After merging the kspp tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

In file included from include/linux/compiler_types.h:58:0,
                 from include/uapi/linux/stddef.h:2,
                 from include/linux/stddef.h:5,
                 from include/uapi/linux/posix_types.h:5,
                 from include/uapi/linux/types.h:14,
                 from include/linux/types.h:6,
                 from fs/xfs/xfs_linux.h:21,
                 from fs/xfs/xfs.h:35,
                 from fs/xfs/xfs_super.c:19:
fs/xfs/xfs_super.c: In function 'xfs_init_zones':
include/linux/compiler-gcc.h:166:2: error: 'xfs_ifork_t {aka struct xfs_ifork}' has no member named 'if_u2'
  __builtin_offsetof(a, b)
  ^
include/linux/stddef.h:17:32: note: in expansion of macro '__compiler_offsetof'
 #define offsetof(TYPE, MEMBER) __compiler_offsetof(TYPE, MEMBER)
                                ^
fs/xfs/xfs_super.c:1862:4: note: in expansion of macro 'offsetof'
    offsetof(xfs_inode_t, i_df.if_u2.if_inline_data),
    ^
In file included from include/uapi/linux/posix_types.h:5:0,
                 from include/uapi/linux/types.h:14,
                 from include/linux/types.h:6,
                 from fs/xfs/xfs_linux.h:21,
                 from fs/xfs/xfs.h:35,
                 from fs/xfs/xfs_super.c:19:
fs/xfs/xfs_super.c:1863:34: error: 'xfs_ifork_t {aka struct xfs_ifork}' has no member named 'if_u2'
    sizeof_field(xfs_inode_t, i_df.if_u2.if_inline_data),
                                  ^
include/linux/stddef.h:22:66: note: in definition of macro 'sizeof_field'
 #define sizeof_field(structure, field) sizeof((((structure *)0)->field))
                                                                  ^

Caused by commit

  1d48144b9688 ("xfs: Define usercopy region in xfs_inode slab cache")

interacting with commit

  43518812d297 ("xfs: remove support for inlining data/extents into the inode fork")

from the  tree.

I just reverted the kspp tree commit as it seems like it is no longer
needed.

-- 
Cheers,
Stephen Rothwell
