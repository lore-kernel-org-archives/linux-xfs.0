Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34182 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751423AbeBZU42 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Feb 2018 15:56:28 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F1DD0356CD
        for <linux-xfs@vger.kernel.org>; Mon, 26 Feb 2018 20:56:27 +0000 (UTC)
Date: Mon, 26 Feb 2018 15:56:23 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: do not log/recover swapext extent owner changes for
 deleted inodes
Message-ID: <20180226205622.GD51394@bfoster.bfoster>
References: <f2dcef25-01f2-d7fe-3b2d-f54a809215a5@redhat.com>
 <20180226163951.GC51394@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180226163951.GC51394@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Feb 26, 2018 at 11:39:51AM -0500, Brian Foster wrote:
> On Fri, Feb 23, 2018 at 05:49:41PM -0600, Eric Sandeen wrote:
> > Today if we run swapext and crash, log replay can fail because
> > the recovery code tries to instantiate the donor inode from
> > disk to replay the swapext, but it's been deleted and we throw
> > corruption failures if we try to get an inode off disk with
> > i_mode == 0.
> > 
> > This fixes both sides: We don't log the swapext change if the
> > inode has been deleted, and we don't try to recover it either.
> > 
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > ---
> > 
> > diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> > index 26f2413..de48eb8 100644
> > --- a/fs/xfs/xfs_inode_item.c
> > +++ b/fs/xfs/xfs_inode_item.c
> > @@ -436,6 +436,12 @@ xfs_inode_item_format(
> >  			~(XFS_ILOG_ADATA | XFS_ILOG_ABROOT | XFS_ILOG_AEXT);
> >  	}
> >  
> > +	/* If this inode has been deleted do not log swapext owner changes */
> > +	if (VFS_I(ip)->i_mode == 0) {
> > +		ilf->ilf_fields &= ~(XFS_ILOG_DOWNER | XFS_ILOG_AOWNER);
> > +		iip->ili_fields &= ~(XFS_ILOG_DOWNER | XFS_ILOG_AOWNER);
> > +	}
> > +
> 
> Do you have any more details on the context that leads to this issue?
> More specifically, is the problem limited to/because of the case where
> the inode is relogged and the owner change flag carries forward to the
> transaction that ultimately frees it (which seems to me is what the
> above prevents)? Or is there some other scenario that can lead to this?
> 
> I guess I'm kind of wondering if this can still happen in spite of the
> above, if the extent swap -> unlink happens in separate log formats and
> the inode happens to be written back before a crash and the log tail
> being unpinned. Now that I think of it I suppose the log recovery lsn
> ordering should prevent that kind of thing on v5 filesystems, at least.
> 

After playing around a bit I think I managed to set myself straight on
this. Indeed, I think the above recovery LSN ordering rules hold for any
separately logged extent swap and subsequent inode free on v5
filesystems. It essentially doesn't matter on v4 filesystems because
there is no metadata owner update on extent swap, since that format
doesn't have the owner info in the bmbt buffers.

So I think this covers everything. My only remaining comments are to
perhaps add a bit more detail in the commit log and/or code comments to
document the situation. Also, have you considered defining a new
function to perform this update on the inode item explicitly from
xfs_ifree() rather than burying it down in xfs_inode_item_format() (more
for clarity than any technical reason that I can think of)?

Brian

> Note that I'd expect the log recovery side change to detect that
> regardless, I'm more just wondering if we need both if the above is not
> necessarily sufficient.
> 
> Brian
> 
> >  	/* update the format with the exact fields we actually logged */
> >  	ilf->ilf_fields |= (iip->ili_fields & ~XFS_ILOG_TIMESTAMP);
> >  }
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index 5e219d9..d0e33b9 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -3199,7 +3199,9 @@ xlog_recover_inode_pass2(
> >  	}
> >  
> >  out_owner_change:
> > -	if (in_f->ilf_fields & (XFS_ILOG_DOWNER|XFS_ILOG_AOWNER))
> > +	/* Recover the swapext owner change unless inode has been deleted */
> > +	if ((in_f->ilf_fields & (XFS_ILOG_DOWNER|XFS_ILOG_AOWNER)) &&
> > +	    (dip->di_mode != 0))
> >  		error = xfs_recover_inode_owner_change(mp, dip, in_f,
> >  						       buffer_list);
> >  	/* re-generate the checksum. */
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
