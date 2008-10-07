Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 06 Oct 2008 17:54:28 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m970sKLr011341
	for <xfs@oss.sgi.com>; Mon, 6 Oct 2008 17:54:20 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 035119F293D
	for <xfs@oss.sgi.com>; Mon,  6 Oct 2008 17:55:58 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id DZAOQJII1QzjuHox for <xfs@oss.sgi.com>; Mon, 06 Oct 2008 17:55:58 -0700 (PDT)
Date: Tue, 7 Oct 2008 11:54:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Adding attr, inode reference query
Message-ID: <20081007005409.GD12509@disturbed>
References: <op.uimntunh3jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.uimntunh3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Tue, Oct 07, 2008 at 11:04:32AM +1100, Barry Naujok wrote:
> I'm doing a bit of debugging with attr creation in xfs_repair which uses
> libxfs which has it's own simple cache/ref counting/transaction mechanism
> for inodes and buffers.
>
> I came across a refcounting issue when adding an extended attribute to an
> inode, calling xfs_attr_set_int (indirectly in Phase 6):
>   - if there are no extended attributes, a attr fork area is created within
>     the inode (calling xfs_bmap_add_attrfork). After this call in libxfs,
>     the inode is derefenced.
>   - if extended attributes already exist, the inode isn't dereferenced
>     after calling xfs_attr_set_int.
>
> I seem to have traced this down to xfs_bmap_add_attrfork not calling
> xfs_trans_ihold after calling xfs_trans_ijoin like other similar functions.
> BUT, it does call IHOLD(ip).

The difference between the two is kinda subtle. IHOLD() increments
the reference count to ensure the transaction commit doesn't drop
the last reference to the inode when it unlocks it and hence
cause us to enter reclaim in the commit code.

OTOH, xfs_trans_ihold() holds the inode across the transaction
commit so that it is still locked when xfs_trans_commit() completes.
This is needed for rolling transactions to be able to continue
across duplication and commit without needing to relock inodes.

> It seems most other routines do call xfs_trans_ihold, esp in the attr code.

That's because most of those are in the scope of rolling
transactions, whereas xfs_bmap_add_attrfork() runs a completely
self-contained transaction. Hence we are only concerned about
reference counts to prevent inode reclaim, not continuing to hold
the inode locked for a rolling transaction.

> Also, it seems IHOLD isn't normally called in these routine in the
> core XFS code.
>
> Is this a bug in xfs_bmap_add_attrfork?

No - the inode should exit xfs_bmap_add_attrfork() with the same
reference count it entered with.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
