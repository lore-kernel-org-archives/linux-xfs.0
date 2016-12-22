Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39538 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1765192AbcLVRl4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Dec 2016 12:41:56 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8A6983D95D
        for <linux-xfs@vger.kernel.org>; Thu, 22 Dec 2016 17:41:56 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id uBMHft0R031681
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Dec 2016 12:41:56 -0500
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/3] xfs: reduce boilerplate around xfs_btree_init_block
Message-ID: <670e1f09-754d-4171-0a73-f918956eba2d@redhat.com>
Date: Thu, 22 Dec 2016 11:41:55 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

We have this pattern all over the kernel & userspace:

                if (xfs_sb_version_hascrc(&mp->m_sb))
                        xfs_btree_init_block(mp, bp, XFS_ABTB_CRC_MAGIC, 0, 1,
                                                agno, XFS_BTREE_CRC_BLOCKS);
                else
                        xfs_btree_init_block(mp, bp, XFS_ABTB_MAGIC, 0, 1,
                                                agno, 0);

The last flag (XFS_BTREE_CRC_BLOCKS) can be gleaned from
the features on the superblock via mp just as the if/else does,
so no need to pass that in from the caller.  That's patch 1.

Then the difference is simply CRC vs not-CRC magic.  This can also
be determined inside the called function by passing in a btree number,
and looking up the proper magic in the xfs_magics array.

patch2 makes xfs_btree_magic() more generic, taking a 
crc flag & btnum, instead of just a cursor.

patch3 then makes use of xfs_btree_magic in the block init routine
to determine the proper magic.

With those changes, the if/else can go away, and we can simply call:

xfs_btree_init_block(mp, bp, XFS_BTNUM_BNO, 0, 1, agno, 0);

and let the lower function sort out crc vs. no crc differences
by itself.

It's not a huge reduction in code, but it reduces a lot of the
boilerplate, particularly in growfs code.  This may also make it
slightly easier to factor the growfs tree init code into a loop
(not sure about that, yet) and/or to move mkfs & growfs tree init
code into a libxfs/ call.

 libxfs/xfs_bmap.c       |   19 ++++---------------
 libxfs/xfs_bmap_btree.c |   10 ++--------
 libxfs/xfs_btree.c      |   34 +++++++++++++++++++++-------------
 libxfs/xfs_btree.h      |    4 ++--
 libxfs/xfs_types.h      |    2 ++
 xfs_fsops.c             |   39 +++++++++------------------------------
 6 files changed, 40 insertions(+), 68 deletions(-)

-Eric
