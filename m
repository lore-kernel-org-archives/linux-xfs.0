Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B92BC433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 15:23:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FB0361164
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 15:23:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234057AbhDNPYA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Apr 2021 11:24:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:46964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232358AbhDNPYA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Apr 2021 11:24:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E02A6610FC;
        Wed, 14 Apr 2021 15:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618413819;
        bh=su/kIYAgxV1N4qGygNaEhEYJm1fUq24lHsWlE+qhsB0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ufvUorT5hSDLtqAvM0QV2NnWTaOpNoYhjWFCXH6YGjCrPODuvpLKrFSKnVXJ+KBmp
         yiY9INi6Lh/8iVPwXc+GCF92RGNr4qPlaUkPplBhJsoRovn81iPxG5iquK2YHg2hPv
         ovwiOd2UA3PSRJwViHWLgPD9KvfpSIli+N/VaFOuV6TfWU0Xfr4e3c9LEnY9CpnWHk
         6m2AOMEzG/NG15Pow9olQ9okVYWe5M+MotWPXmnjfWOlg9JWXp9FKuEHebMgimGuGK
         gKOaaq/KgjzO89z2P+knXNIlApVq+pHhoO09aWwlSSGbbN4R/z1AhAS+8NiKFQm7ms
         v/rqhmNBohLHg==
Date:   Wed, 14 Apr 2021 08:23:38 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs: remove XFS_IFBROOT
Message-ID: <20210414152338.GA3957620@magnolia>
References: <20210412133819.2618857-1-hch@lst.de>
 <20210412133819.2618857-6-hch@lst.de>
 <YHRvXh+s1ksfbEjm@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YHRvXh+s1ksfbEjm@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 12, 2021 at 12:03:42PM -0400, Brian Foster wrote:
> On Mon, Apr 12, 2021 at 03:38:17PM +0200, Christoph Hellwig wrote:
> > Just check for a btree format fork instead of the using the equivalent
> > in-memory XFS_IFBROOT flag.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c          | 16 +++++++---------
> >  fs/xfs/libxfs/xfs_btree_staging.c |  1 -
> >  fs/xfs/libxfs/xfs_inode_fork.c    |  4 +---
> >  fs/xfs/libxfs/xfs_inode_fork.h    |  1 -
> >  4 files changed, 8 insertions(+), 14 deletions(-)
> > 
> ...
> > diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
> > index f464a7c7cf2246..aa8dc9521c3942 100644
> > --- a/fs/xfs/libxfs/xfs_btree_staging.c
> > +++ b/fs/xfs/libxfs/xfs_btree_staging.c
> > @@ -387,7 +387,6 @@ xfs_btree_bload_prep_block(
> >  		new_size = bbl->iroot_size(cur, nr_this_block, priv);
> >  		ifp->if_broot = kmem_zalloc(new_size, 0);
> >  		ifp->if_broot_bytes = (int)new_size;
> > -		ifp->if_flags |= XFS_IFBROOT;
> >  
> >  		/* Initialize it and send it out. */
> >  		xfs_btree_init_block_int(cur->bc_mp, ifp->if_broot,
> 
> IIRC, these bits are used in xfsprogs for efficient btree repair. Taking
> a closer look, I see AG metadata btree repair implementations, but
> nothing that seems to use the ifake variant. Am I missing something or
> is this code currently unused?

Currently unused.  The first user will be bmbt reconstruction, whenever
I get back to that, some day.  Now that upper levels can relog deferred
ops when the log head approaches the tail, online btree repair can hang
on to EFIs for the new tree blocks during the bulkload without risking a
log livelock.

That series is stuck behind:

 1 Quotaoff cleanups (suggested as part of:)
 2 Incore inode walk refactoring (suggested as part of:)
 3 Preserving inode sickness reports through aborted ireclaim (bugs
   found while working on:)
 4 Deferred inode inactivation (customer requirement / needed for rmapbt
   repairs)
 5 Reducing transaction reservations when reflink/rmap are enabled
   (dchinner complaint)
 6 Various scrub enhancements
 7 Repair infrastructure changes needed for online bulkloading
 8 Online repair of AG btrees

It's 9th in line (and 81st in the patch stack), so it's going to be at
least another ~5 kernel cycles until review completes on the preceeding
patchsets so that repair gets back to the front of the line.

--D

> In any event, the comments for xfs_btree_stage_ifakeroot() suggest that
> ->if_format should be initialized properly when a fake inode fork is
> transferred to a cursor and the rest of the patch looks fine to me:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> > diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> > index 73eea7939b55e4..02ad722004d3f4 100644
> > --- a/fs/xfs/libxfs/xfs_inode_fork.c
> > +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> > @@ -60,7 +60,7 @@ xfs_init_local_fork(
> >  	}
> >  
> >  	ifp->if_bytes = size;
> > -	ifp->if_flags &= ~(XFS_IFEXTENTS | XFS_IFBROOT);
> > +	ifp->if_flags &= ~XFS_IFEXTENTS;
> >  	ifp->if_flags |= XFS_IFINLINE;
> >  }
> >  
> > @@ -214,7 +214,6 @@ xfs_iformat_btree(
> >  	xfs_bmdr_to_bmbt(ip, dfp, XFS_DFORK_SIZE(dip, ip->i_mount, whichfork),
> >  			 ifp->if_broot, size);
> >  	ifp->if_flags &= ~XFS_IFEXTENTS;
> > -	ifp->if_flags |= XFS_IFBROOT;
> >  
> >  	ifp->if_bytes = 0;
> >  	ifp->if_u1.if_root = NULL;
> > @@ -433,7 +432,6 @@ xfs_iroot_realloc(
> >  			XFS_BMBT_BLOCK_LEN(ip->i_mount));
> >  	} else {
> >  		new_broot = NULL;
> > -		ifp->if_flags &= ~XFS_IFBROOT;
> >  	}
> >  
> >  	/*
> > diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> > index 06682ff49a5bfc..8ffaa7cc1f7c3f 100644
> > --- a/fs/xfs/libxfs/xfs_inode_fork.h
> > +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> > @@ -32,7 +32,6 @@ struct xfs_ifork {
> >   */
> >  #define	XFS_IFINLINE	0x01	/* Inline data is read in */
> >  #define	XFS_IFEXTENTS	0x02	/* All extent pointers are read in */
> > -#define	XFS_IFBROOT	0x04	/* i_broot points to the bmap b-tree root */
> >  
> >  /*
> >   * Worst-case increase in the fork extent count when we're adding a single
> > -- 
> > 2.30.1
> > 
> 
