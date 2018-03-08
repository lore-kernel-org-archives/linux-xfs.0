Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56394 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750755AbeCHTq0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 8 Mar 2018 14:46:26 -0500
Date: Thu, 8 Mar 2018 14:46:21 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: do not log/recover swapext extent owner changes for
 deleted inodes
Message-ID: <20180308194620.GA29251@bfoster.bfoster>
References: <f2dcef25-01f2-d7fe-3b2d-f54a809215a5@redhat.com>
 <20180226163951.GC51394@bfoster.bfoster>
 <20180226205622.GD51394@bfoster.bfoster>
 <20228c4e-eac9-edc7-a364-27fd387b916d@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20228c4e-eac9-edc7-a364-27fd387b916d@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Mar 07, 2018 at 01:58:31PM -0600, Eric Sandeen wrote:
> 
> 
> On 2/26/18 2:56 PM, Brian Foster wrote:
> > On Mon, Feb 26, 2018 at 11:39:51AM -0500, Brian Foster wrote:
> >> On Fri, Feb 23, 2018 at 05:49:41PM -0600, Eric Sandeen wrote:
> >>> Today if we run swapext and crash, log replay can fail because
> >>> the recovery code tries to instantiate the donor inode from
> >>> disk to replay the swapext, but it's been deleted and we throw
> >>> corruption failures if we try to get an inode off disk with
> >>> i_mode == 0.
> >>>
> >>> This fixes both sides: We don't log the swapext change if the
> >>> inode has been deleted, and we don't try to recover it either.
> >>>
> >>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >>> ---
> >>>
> >>> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> >>> index 26f2413..de48eb8 100644
> >>> --- a/fs/xfs/xfs_inode_item.c
> >>> +++ b/fs/xfs/xfs_inode_item.c
> >>> @@ -436,6 +436,12 @@ xfs_inode_item_format(
> >>>  			~(XFS_ILOG_ADATA | XFS_ILOG_ABROOT | XFS_ILOG_AEXT);
> >>>  	}
> >>>  
> >>> +	/* If this inode has been deleted do not log swapext owner changes */
> >>> +	if (VFS_I(ip)->i_mode == 0) {
> >>> +		ilf->ilf_fields &= ~(XFS_ILOG_DOWNER | XFS_ILOG_AOWNER);
> >>> +		iip->ili_fields &= ~(XFS_ILOG_DOWNER | XFS_ILOG_AOWNER);
> >>> +	}
> >>> +
> >>
> >> Do you have any more details on the context that leads to this issue?
> >> More specifically, is the problem limited to/because of the case where
> >> the inode is relogged and the owner change flag carries forward to the
> >> transaction that ultimately frees it (which seems to me is what the
> >> above prevents)? Or is there some other scenario that can lead to this?
> >>
> >> I guess I'm kind of wondering if this can still happen in spite of the
> >> above, if the extent swap -> unlink happens in separate log formats and
> >> the inode happens to be written back before a crash and the log tail
> >> being unpinned. Now that I think of it I suppose the log recovery lsn
> >> ordering should prevent that kind of thing on v5 filesystems, at least.
> >>
> > 
> > After playing around a bit I think I managed to set myself straight on
> > this. Indeed, I think the above recovery LSN ordering rules hold for any
> > separately logged extent swap and subsequent inode free on v5
> > filesystems. It essentially doesn't matter on v4 filesystems because
> > there is no metadata owner update on extent swap, since that format
> > doesn't have the owner info in the bmbt buffers.
> > 
> > So I think this covers everything. My only remaining comments are to
> > perhaps add a bit more detail in the commit log and/or code comments to
> > document the situation. Also, have you considered defining a new
> > function to perform this update on the inode item explicitly from
> > xfs_ifree() rather than burying it down in xfs_inode_item_format() (more
> > for clarity than any technical reason that I can think of)?
> 
> Sorry for the late reply.
> 
> I'm not sure I see a way to do this in xfs_ifree, because we don't have
> access to the inode log format to make the necessary changes at that point.
> Or am I missing something?
> 

Don't you just have to clear the owner change flag from the inode log
item log flags (->ili_fields)? If so, ISTM you could just do that from
wherever you have the inode (via ->i_itemp).

> And, um, you've probably been more methodical than I have in checking out
> the change - can I ask for a suggestion of what sorts of comments you'd
> like to see to make things more clear?  I fear I'm in "unknown unknowns"
> territory.
> 

I don't quite recall exactly what I was thinking here. Reading the above
again, perhaps it just wasn't immediately clear that a removed file was
a critical aspect of the problem. "Run swapext" doesn't really imply it,
but I suppose that's the common sequence with xfs_fsr (alloc donor file,
swap extents, unlink donor).

WRT to the code comment, it might be useful to note why we clear the
owner change flag rather than just restate what the code does (i.e.,
IIRC because log recovery might attempt the owner change sequence if
that state is relogged with the transaction that actually unlinks the
inode, and that apparently explodes..).

Brian

> Thanks,
> -Eric
> 
> 
> > Brian
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
