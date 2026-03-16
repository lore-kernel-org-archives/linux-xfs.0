Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A31328260
	for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2026 16:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773678597; cv=none; b=W+btfxojpzDP3y9FtBRrWthYdTVJYFhFHJtuwV52E/xfqvVfqToh4JYollQ3jaJ5n+O94ldfpUdSPoK0nGoAv/DNpnNTvvgYOGHcl2+trTTufditjDyyyM0S/RA9MkrbrNlsjNvfajX3RaYCVXQiMYooD2yYNN6woy0iuQKU6sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773678597; c=relaxed/simple;
	bh=Ko4oz75nWKA4w7ykV46P4N6zAz2dpXkajmRri5Dd2iE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PxZrp9HfpfkhBUehHc6/hqcOpL4LZULrrghlF6CS+MpGkOY5ECvhiIuFwx8n985qda8SeoxxMaW6rDVQB0d6CHvrUf/Hk2M2TB/FRdAMGR9EQ/5mXqAlEp5gLDvBpPlfrhYRFKJh5w/PY4NDPslabTNTvJTYGHcmyxPXv0Mfp84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VXC53mez; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VXC53mez"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02659C2BC87;
	Mon, 16 Mar 2026 16:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773678597;
	bh=Ko4oz75nWKA4w7ykV46P4N6zAz2dpXkajmRri5Dd2iE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VXC53mez1spk4FYSIi2VPKWaXd2A5Ujc6/pm4+OOySNENbJ32CLDfWbERwkhnzAVi
	 LK1RtqTaOVnNYbk33O24GNf8n84iABk2zqDxy6Q0nlPpT6a7f/Vv8nXzwV8V42fBSo
	 /bx6dZIfkVIFf22dJPnudrCgoApGNwGMaA6/N0SFIJOkrBM9BQMJVrzzyrwgQZJqXY
	 BsYq6FxytQw0J85D8aOcAP7TSVj/BLf32wXvHHrE4GSx6mkxzAFzIyeoNBQ2b+/NP+
	 uw6sLgAlbHAez0z0Q55Ws+24G+f1lXHmDnm2U+9iQ5y/UynFGmISxgiKTHUG22hG1f
	 z2yp28Qmw60qw==
Date: Mon, 16 Mar 2026 09:29:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com,
	lonuxli.64@gmail.com
Subject: Re: [PATCH v2 4/4] xfs: close crash window in attr dabtree
 inactivation
Message-ID: <20260316162955.GX1770774@frogsfrogsfrogs>
References: <20260312085800.1213919-1-leo.lilong@huawei.com>
 <20260312085800.1213919-5-leo.lilong@huawei.com>
 <20260314001856.GS1770774@frogsfrogsfrogs>
 <20260316045613.GU1770774@frogsfrogsfrogs>
 <abfAIz5yfqdG8SgR@localhost.localdomain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abfAIz5yfqdG8SgR@localhost.localdomain>

On Mon, Mar 16, 2026 at 04:32:35PM +0800, Long Li wrote:
> On Sun, Mar 15, 2026 at 09:56:13PM -0700, Darrick J. Wong wrote:
> > On Fri, Mar 13, 2026 at 05:18:56PM -0700, Darrick J. Wong wrote:
> > > On Thu, Mar 12, 2026 at 04:58:00PM +0800, Long Li wrote:
> > > > When inactivating an inode with node-format extended attributes,
> > > > xfs_attr3_node_inactive() invalidates all child leaf/node blocks via
> > > > xfs_trans_binval(), but intentionally does not remove the corresponding
> > > > entries from their parent node blocks.  The implicit assumption is that
> > > > xfs_attr_inactive() will truncate the entire attr fork to zero extents
> > > > afterwards, so log recovery will never reach the root node and follow
> > > > those stale pointers.
> > > > 
> > > > However, if a log shutdown occurs after the leaf/node block cancellations
> > > > commit but before the attr bmap truncation commits, this assumption
> > > > breaks.  Recovery replays the attr bmap intact (the inode still has
> > > > attr fork extents), but suppresses replay of all cancelled leaf/node
> > > > blocks, maybe leaving them as stale data on disk.  On the next mount,
> > > > xlog_recover_process_iunlinks() retries inactivation and attempts to
> > > > read the root node via the attr bmap. If the root node was not replayed,
> > > > reading the unreplayed root block triggers a metadata verification
> > > > failure immediately; if it was replayed, following its child pointers
> > > > to unreplayed child blocks triggers the same failure:
> > > > 
> > > >  XFS (pmem0): Metadata corruption detected at
> > > >  xfs_da3_node_read_verify+0x53/0x220, xfs_da3_node block 0x78
> > > >  XFS (pmem0): Unmount and run xfs_repair
> > > >  XFS (pmem0): First 128 bytes of corrupted metadata buffer:
> > > >  00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > > >  00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > > >  00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > > >  00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > > >  00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > > >  00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > > >  00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > > >  00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > > >  XFS (pmem0): metadata I/O error in "xfs_da_read_buf+0x104/0x190" at daddr 0x78 len 8 error 117
> > > > 
> > > > Fix this in two places:
> > > > 
> > > > In xfs_attr3_node_inactive(), after calling xfs_trans_binval() on a
> > > > child block, immediately remove the entry that references it from the
> > > > parent node in the same transaction.  This eliminates the window where
> > > > the parent holds a pointer to a cancelled block.  Once all children are
> > > > removed, the now-empty root node is converted to a leaf block within the
> > > > same transaction. This node-to-leaf conversion is necessary for crash
> > > > safety. If the system shutdown after the empty node is written to the
> > > > log but before the second-phase bmap truncation commits, log recovery
> > > > will attempt to verify the root block on disk. xfs_da3_node_verify()
> > > > does not permit a node block with count == 0; such a block will fail
> > > > verification and trigger a metadata corruption shutdown. on the other
> > > > hand, leaf blocks are allowed to have this transient state.
> > > > 
> > > > In xfs_attr_inactive(), split the attr fork truncation into two explicit
> > > > phases.  First, truncate all extents beyond the root block (the child
> > > > extents whose parent references have already been removed above).
> > > > Second, invalidate the root block and truncate the attr bmap to zero in
> > > > a single transaction.  The two operations in the second phase must be
> > > > atomic: as long as the attr bmap has any non-zero length, recovery can
> > > > follow it to the root block, so the root block invalidation must commit
> > > > together with the bmap-to-zero truncation.
> > > > 
> > > > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > > > Cc: <stable@vger.kernel.org>
> > > > Signed-off-by: Long Li <leo.lilong@huawei.com>
> > > 
> > > I think this looks ok, but let me run it through g753 over the weekend
> > > to see if it fixes that problem too.  Thanks for answering my questions
> > > the last time through.
> > > 
> > > Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> > 
> > In retesting generic/753, I noticed that this patchset *does* actually
> > fix the problem of xfs_repair complaining about random contents in attr
> > block 0.  So, I think you've fixed that problem, yay!
> > 
> 
> That sounds great, thank you for the test.
> 
> > However, I noticed an additional thing -- if attr block 0 happened to be
> > a leaf node (i.e. not a da3 node) AND that leaf happened to contain a
> > non-INCOMPLETE remote attr entry AND the fs went down after the first
> > bunmapi (that removes all but block0) but before the second bunmapi
> > (which eliminates block 0), that remote entry will point to blocks
> > that have been bunmapi'd, and xfs_repair will complain about that too.
> > 
> > So, I think this patch needs to reinit old leaf blocks too; see below.
> 
> Agree with you, thanks for pointint this out. 
> 
> For non-root leaf blocks, the remote value block cancellation and the
> removal of the leaf entry from its parent node are already in the same
> transaction, so that case is safe.

Agreed.

> For the root leaf block, it is reachable as long as the attr bmap is
> non-zero, so the remote value block cancellations and the leaf reinit
> must be atomic.

Agreed.

> > Note that xfs_repair also needs a patch to teach it not to zap the
> > entire attr fork just because it found one incomplete attr entry in a
> > leaf block.
> > 
> > Thoughts?
> 
> With the leaf reinit added, xfs_repair maybe encounter an empty leaf at
> block 0 with no entries referencing the remote blocks. So I don't understand
> under what circumstances there would be an "incomplete attr entry", perhaps
> I missed something?

Oh, sorry, I should've been more clear about what went where.  There are
two scenarios that still caused problems over the weekend:

a) You create a file, start adding large attrs, and crash.  After
recovery, the file will still be linked into the directory tree, but its
attr structure will have INCOMPLETE attrs.

In this case, I don't think the user wants us to destroy the entire attr
structure, so it's necessary to patch xfs_repair to be ok with
INCOMPLETE attrs.

b) You create a file with a few large attrs.  After a long life without
drama, you start to delete the file, and crash after bunmapi'ing
everything *except* for block 0.  IOWs, the old leaf root block is still
intact.  If you then run xfs_repair, it will complain about the
non-INCOMPLETE remote attr value because valueblk points to an unmapped
region of the attr fork.

This is the case for adding the extra xfs_attr3_leaf_init call.

--D
