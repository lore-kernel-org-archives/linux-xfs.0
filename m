Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906603DBA0
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 14:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773154003; cv=none; b=rzd2BlEuFNa0pltHFcAHa5/kC3v+P67apA2RPWYbVe8Wbn3QC63wummqLG+wDxBtMZCbmDryR7CcjoY5iDv+gJ702JuZM7qrEC0bYGd1lW41APhPbGYAeluhBYbqH++ZPPnvQg/9PIEufcfmMR74A9EJ/fRqwm1bfgdy5X2NoEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773154003; c=relaxed/simple;
	bh=okL5Fd2wBdg/KGo53zrTPhcEtm99oniOTdzw5f3TWO0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BUAp6cxgS7SUTROB/NwuNma1NUd3pA/QzAimLpe7+lZehOJJxBocep9s51cBZ9kqWkyLEnuJ0IM1OjU6m7ap9ZAKxJ9JOytk8t7W0e3ihkDF92JrJB8Jf9pchlnNQm+ACzZwS0bPY1bnlKv+RmTCUGu5qFZ0rRKxGf7LyufGYYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Av7xZVvR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Av7xZVvR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25285C19423;
	Tue, 10 Mar 2026 14:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773154003;
	bh=okL5Fd2wBdg/KGo53zrTPhcEtm99oniOTdzw5f3TWO0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Av7xZVvRRd5b+rMxhY29DLhMo7WteXRzTGDr1ktrsjQou1Rd0lz+8EkN97WCeuNbF
	 uVJPCIBP+exrTscJqd9VwqH0jseNKD8WHijXFE8J4gQ6CCBkqoNVl5ummP8D+ISCat
	 EfWW0mybq1j6kUGqAZ3Gp3LnTTpwvIBOBbYGtpgi8sNrfZr1VUwS99P/6piVUAJ4rT
	 NB2RbviXcesSoAZ7VwtODhwn6IySyWPpUXxkNfyLXUdGgDVSCfFaYu3aKsG1cd7J0N
	 XdP+E84pcC6E5hSgDiaYDOfZUho8mue9tqVeih9fqaVnI7PXTnur9MSsCe0PZbODoE
	 c9VXw+gdQ8QRA==
Date: Tue, 10 Mar 2026 07:46:42 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com,
	lonuxli.64@gmail.com
Subject: Re: [PATCH 4/4] xfs: close crash window in attr dabtree inactivation
Message-ID: <20260310144642.GK1105363@frogsfrogsfrogs>
References: <20260309082752.2039861-1-leo.lilong@huawei.com>
 <20260309082752.2039861-5-leo.lilong@huawei.com>
 <20260309165933.GK6033@frogsfrogsfrogs>
 <aa_UFVW5bPLk8iBK@localhost.localdomain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa_UFVW5bPLk8iBK@localhost.localdomain>

On Tue, Mar 10, 2026 at 04:19:33PM +0800, Long Li wrote:
> On Mon, Mar 09, 2026 at 09:59:33AM -0700, Darrick J. Wong wrote:
> > On Mon, Mar 09, 2026 at 04:27:52PM +0800, Long Li wrote:
> > > When inactivating an inode with node-format extended attributes,
> > > xfs_attr3_node_inactive() invalidates all child leaf/node blocks via
> > > xfs_trans_binval(), but intentionally does not remove the corresponding
> > > entries from their parent node blocks.  The implicit assumption is that
> > > xfs_attr_inactive() will truncate the entire attr fork to zero extents
> > > afterwards, so log recovery will never reach the root node and follow
> > > those stale pointers.
> > > 
> > > However, if a log shutdown occurs after the child block cancellations
> > > commit but before the attr bmap truncation commits, this assumption
> > > breaks.  Recovery replays the attr bmap intact (the inode still has
> > > attr fork extents), but suppresses replay of all cancelled child
> > > blocks, maybe leaving them as stale data on disk.  On the next mount,
> > > xlog_recover_process_iunlinks() retries inactivation and attempts to
> > > read the root node via the attr bmap. If the root node was not replayed,
> > > reading the unreplayed root block triggers a metadata verification
> > > failure immediately; if it was replayed, following its child pointers
> > > to unreplayed child blocks triggers the same failure:
> > > 
> > >  XFS (pmem0): Metadata corruption detected at
> > >  xfs_da3_node_read_verify+0x53/0x220, xfs_da3_node block 0x78
> > >  XFS (pmem0): Unmount and run xfs_repair
> > >  XFS (pmem0): First 128 bytes of corrupted metadata buffer:
> > >  00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > >  00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > >  00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > >  00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > >  00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > >  00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > >  00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > >  00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > >  XFS (pmem0): metadata I/O error in "xfs_da_read_buf+0x104/0x190" at daddr 0x78 len 8 error 117
> > 
> > Did you hit this through a customer issue?  Or is this the same "corrupt
> > block 0 of inode 25165954 attribute fork" problem exposed by generic/753
> > last week?  Or possibly both?
> > 
> > https://lore.kernel.org/linux-xfs/CAF-d4Oscq=qaCd9dbbEZjG8dA5Q7erdWSszoxY1migM8j85eRw@mail.gmail.com/
> 
> We encountered this issue while performing disk fault injection tests, 
> rather than through the generic/753. When I construct the problem
> and use xfs_repair to repair it, the error message "corrupt block 0" can
> be reported as follows:
> 
>   Metadata corruption detected at 0x452a9c, xfs_da3_node block 0x78/0x1000
>   corrupt block 0 of inode 131 attribute fork
>   problem with attribute contents in inode 131
>   clearing inode 131 attributes
>   correcting nblocks for inode 131, was 1 - counted 0
> 
> So the problem you encountered before might be this issue.
> 
> > 
> > > Fix this in two places:
> > > 
> > > In xfs_attr3_node_inactive(), after calling xfs_trans_binval() on a
> > > child block, immediately remove the entry that references it from the
> > > parent node in the same transaction.  This eliminates the window where
> > > the parent holds a pointer to a cancelled block.  Once all children are
> > > removed, the now-empty root node is converted to a leaf block within the
> > > same transaction. This node-to-leaf conversion is necessary for crash
> > > safety. If the system shutdown after the empty node is written to the
> > > log but before the second-phase bmap truncation commits, log recovery
> > > will attempt to verify the root block on disk. xfs_da3_node_verify()
> > > does not permit a node block with count == 0; such a block will fail
> > > verification and trigger a metadata corruption shutdown. on the other
> > > hand, leaf blocks are allowed to have this transient state.
> > 
> > Hrmmm... this really does sound like the "corrupt block 0" problem
> > referenced above.
> > 
> > > In xfs_attr_inactive(), split the attr fork truncation into two explicit
> > > phases.  First, truncate all extents beyond the root block (the child
> > > extents whose parent references have already been removed above).
> > > Second, invalidate the root block and truncate the attr bmap to zero in
> > > a single transaction.  The two operations in the second phase must be
> > > atomic: as long as the attr bmap has any non-zero length, recovery can
> > > follow it to the root block, so the root block invalidation must commit
> > > together with the bmap-to-zero truncation.
> > > 
> > > Signed-off-by: Long Li <leo.lilong@huawei.com>
> 
> ......
> 
> > > @@ -283,6 +283,16 @@ xfs_attr3_root_inactive(
> > >  	case cpu_to_be16(XFS_DA_NODE_MAGIC):
> > >  	case cpu_to_be16(XFS_DA3_NODE_MAGIC):
> > >  		error = xfs_attr3_node_inactive(trans, dp, bp, 1);
> > > +		if (error)
> > > +			return error;
> > > +
> > > +		/*
> > > +		 * Empty root node block are not allowed, convert it to leaf.
> > > +		 */
> > > +		error = xfs_attr3_leaf_init(*trans, dp, 0);
> > 
> > Responding to my own question: Ah, I see -- "leaf init" doesn't use the
> > bp anymore and it's attached to the transaction so it doesn't leak.
> > That's a little subtle since there's nothing preventing someone from
> > calling xfs_attr3_leaf_init(NULL, dp, 0).
> 
> Indeed, there should be an increase in explanatory comments and an empty
> check for the tp.
> 
> > 
> > > +		if (error)
> > > +			return error;
> > > +		error = xfs_trans_roll_inode(trans, dp);
> > 
> > If we have an xattr structure with multiple levels of dabtree nodes, can
> > this lead to the somewhat odd situation where the tree levels are
> > uneven during deconstruction?  For example
> > 
> >       root
> >       /  \
> >  node     empty_leaf
> >  |  \
> >  |   \
> > node node
> > |       \
> > leaves  more_leaves
> > 
> > Does this matter, or can the inactivation code already handle it?  I
> > suppose since we're inactivating (either in inodegc or in recovery after
> > a crash) user programs will never see this so the window of confusion
> > might be pretty small.
> > 
> > --D
> 
> For the reason of simplicity and efficiency, the dead code does not consider
> this tree imbalance scenario, and I understand that this would not cause
> any practical issues. 

"dead" code?  Did you mean to say that the code that the patch removes
did not consider this imbalanced tree scenario?  "Dead" code usually
refers to code that's still in the codebase that nobody calls or
executes.

I /think/ what I'm hearing is that the the attr inactivation code can
handle the system going down midway through removing the attr structure,
so it doesn't matter if log recovery finds an imbalanced tree because
all it's really doing is walking the dabtree to each leaf and nuking the
path to that leaf; and now it'll also rewrite each emptied-out node with
an empty leaf to ensure that a second log recovery can resume if the
first recovery attempt fails due to system crash etc.

(Is that correct?)

--D

> 
> Best regards,
> Long Li
> 
