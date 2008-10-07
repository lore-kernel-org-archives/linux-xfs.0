Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 06 Oct 2008 17:43:41 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m970hdSj010449
	for <xfs@oss.sgi.com>; Mon, 6 Oct 2008 17:43:39 -0700
Message-ID: <48EAB118.7070606@sgi.com>
Date: Tue, 07 Oct 2008 11:45:12 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: Adding attr, inode reference query
References: <op.uimntunh3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.uimntunh3jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

Barry Naujok wrote:
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
> 
> It seems most other routines do call xfs_trans_ihold, esp in the attr code.
> 
> Also, it seems IHOLD isn't normally called in these routine in the
> core XFS code.
> 
> Is this a bug in xfs_bmap_add_attrfork?
Yeah, it looks wrong to me too.

doucette  |1.153|                            |  ASSERT(ip->i_d.di_anextents == 0);
doucette  |1.148|                            |  VN_HOLD(XFS_ITOV(ip));
doucette  |1.146|                            |  xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
doucette  |1.213|                            |  xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);

----------------------------
revision 1.148
date: 1995/05/19 22:41:52;  author: doucette;  state: Exp;  lines: +5 -4
More progress on attributes: fix the transaction reservation in
xfs_bmap_add_attrfork (to be permanent).  Hold the vnode so it won't
go away at transaction commit.
----------------------------

So the xfs_trans_ihold sets a flag on item:
ip->i_itemp->ili_flags |= XFS_ILI_HOLD;
preventing an xfs_iput (unlock, irele) from xfs_inode_item_unlock, from IOP_UNLOCK,
from xfs_trans_unlock_chunk() from xfs_trans_unlock_items() from
_xfs_trans_commit etc...
i.e. from unlocking,unrefing on transaction commit.

So I guess, in current code we are taking an extra reference here instead of just stopping
the inode from being unlocked, and a ref dropped at commit time.

Be interesting to see where we do this throughout the code -> audit.
And why have we normally gotten away with this?

--Tim
