Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:47364 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752968AbdDDTh6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Apr 2017 15:37:58 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 50647782D2E
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2017 14:37:20 -0500 (CDT)
Subject: Re: [ANNOUNCE] xfsprogs: for-next branch updated to 88a4a19
References: <93206337-c274-6415-a068-7e89067a6f8f@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <e72a5a22-47c5-88c5-8789-b02445195083@sandeen.net>
Date: Tue, 4 Apr 2017 14:37:57 -0500
MIME-Version: 1.0
In-Reply-To: <93206337-c274-6415-a068-7e89067a6f8f@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

On 3/29/17 11:28 AM, Eric Sandeen wrote:
> Hi folks,
> 
> The xfsprogs repository at:
> 
> 	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> 
> has just been updated.
> 
> This was only a libxfs syncup; I will get to xfsprogs-proper
> patches soon.  Changes are on the for-next and libxfs-4.11-sync
> branches for now.

Realized that I neglected to add my SOB to any of these.  :/

Unsure if I should rebase these two branches to add them, or
let it go.

Thoughts/preferences?

Sorry about that,
-Eric

> The new head of the for-next branch is commit:
> 
> 88a4a19 xfs: verify inline directory data forks
> 
> New Commits:
> 
> Brian Foster (3):
>       [5894afd] xfs: handle indlen shortage on delalloc extent merge
>       [b226fa5] xfs: split indlen reservations fairly when under reserved
>       [a0b2bb7] xfs: use iomap new flag for newly allocated delalloc blocks
> 
> Chandan Rajendra (1):
>       [b4747e3] xfs: Use xfs_icluster_size_fsb() to calculate inode chunk alignment
> 
> Christoph Hellwig (5):
>       [09af6ff] xfs: go straight to real allocations for direct I/O COW writes
>       [bb47212] xfs: improve handling of busy extents in the low-level allocator
>       [622fea0] xfs: tune down agno asserts in the bmap code
>       [2527a6f] xfs: remove XFS_ALLOCTYPE_ANY_AG and XFS_ALLOCTYPE_START_AG
>       [e2594ba] xfs: try any AG when allocating the first btree block when reflinking
> 
> Darrick J. Wong (7):
>       [0ed1133] xfs: fix toctou race when locking an inode to access the data map
>       [ab021c7] xfs: fail _dir_open when readahead fails
>       [94b269a] xfs: filter out obviously bad btree pointers
>       [c89a743] xfs: check for obviously bad level values in the bmbt root
>       [ec5d083] xfs: verify free block header fields
>       [86107a2] xfs: allow unwritten extents in the CoW fork
>       [88a4a19] xfs: verify inline directory data forks
> 
> Eric Sandeen (4):
>       [d88798d] xfs: glean crc status from mp not flags in xfs_btree_init_block_int
>       [ee3a607] xfs: make xfs_btree_magic more generic
>       [ed849ef] xfs: remove boilerplate around xfs_btree_init_block
>       [7c1c908] xfs: remove unused struct declarations
> 
> 
> Code Diffstat:
> 
>  include/xfs_log_recover.h |   1 -
>  libxfs/libxfs_priv.h      |  16 ++--
>  libxfs/xfs_alloc.c        | 109 ++++++++++------------
>  libxfs/xfs_alloc.h        |   4 -
>  libxfs/xfs_bmap.c         | 233 ++++++++++++++++++++++++++--------------------
>  libxfs/xfs_bmap_btree.c   |  16 +---
>  libxfs/xfs_btree.c        |  48 +++++++---
>  libxfs/xfs_btree.h        |   8 +-
>  libxfs/xfs_da_btree.c     |   6 +-
>  libxfs/xfs_da_btree.h     |   2 +-
>  libxfs/xfs_dir2_node.c    |  51 +++++++++-
>  libxfs/xfs_dir2_priv.h    |   2 +
>  libxfs/xfs_dir2_sf.c      |  87 +++++++++++++++++
>  libxfs/xfs_ialloc.c       |   3 +-
>  libxfs/xfs_inode_fork.c   |  35 +++++--
>  libxfs/xfs_inode_fork.h   |   2 +-
>  mkfs/xfs_mkfs.c           |  35 ++-----
> 
>  18 files changed, 451 insertions(+), 304 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
