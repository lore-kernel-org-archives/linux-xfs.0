Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58960 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750964AbdAPXNf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Jan 2017 18:13:35 -0500
Subject: Re: [PATCH 0/3] xfs: reduce boilerplate around xfs_btree_init_block
References: <670e1f09-754d-4171-0a73-f918956eba2d@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <8686ca71-8133-1b53-d59e-979da8510372@sandeen.net>
Date: Mon, 16 Jan 2017 17:13:34 -0600
MIME-Version: 1.0
In-Reply-To: <670e1f09-754d-4171-0a73-f918956eba2d@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On 12/22/16 11:41 AM, Eric Sandeen wrote:
> We have this pattern all over the kernel & userspace:
> 
>                 if (xfs_sb_version_hascrc(&mp->m_sb))
>                         xfs_btree_init_block(mp, bp, XFS_ABTB_CRC_MAGIC, 0, 1,
>                                                 agno, XFS_BTREE_CRC_BLOCKS);
>                 else
>                         xfs_btree_init_block(mp, bp, XFS_ABTB_MAGIC, 0, 1,
>                                                 agno, 0);
> 
> The last flag (XFS_BTREE_CRC_BLOCKS) can be gleaned from
> the features on the superblock via mp just as the if/else does,
> so no need to pass that in from the caller.  That's patch 1.

Ping on this series?

Thanks,
-Eric

> Then the difference is simply CRC vs not-CRC magic.  This can also
> be determined inside the called function by passing in a btree number,
> and looking up the proper magic in the xfs_magics array.
> 
> patch2 makes xfs_btree_magic() more generic, taking a 
> crc flag & btnum, instead of just a cursor.
> 
> patch3 then makes use of xfs_btree_magic in the block init routine
> to determine the proper magic.
> 
> With those changes, the if/else can go away, and we can simply call:
> 
> xfs_btree_init_block(mp, bp, XFS_BTNUM_BNO, 0, 1, agno, 0);
> 
> and let the lower function sort out crc vs. no crc differences
> by itself.
> 
> It's not a huge reduction in code, but it reduces a lot of the
> boilerplate, particularly in growfs code.  This may also make it
> slightly easier to factor the growfs tree init code into a loop
> (not sure about that, yet) and/or to move mkfs & growfs tree init
> code into a libxfs/ call.
> 
>  libxfs/xfs_bmap.c       |   19 ++++---------------
>  libxfs/xfs_bmap_btree.c |   10 ++--------
>  libxfs/xfs_btree.c      |   34 +++++++++++++++++++++-------------
>  libxfs/xfs_btree.h      |    4 ++--
>  libxfs/xfs_types.h      |    2 ++
>  xfs_fsops.c             |   39 +++++++++------------------------------
>  6 files changed, 40 insertions(+), 68 deletions(-)
> 
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
