Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 503E3C432BE
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Aug 2021 23:36:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31ACB60C41
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Aug 2021 23:36:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235510AbhHIXgX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:36:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:45004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235336AbhHIXgX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 9 Aug 2021 19:36:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB56660E52;
        Mon,  9 Aug 2021 23:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628552162;
        bh=am93hnEEYvFW9SCnTlVeQVHL5BxCWjGKVlnhT1Zva6c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r1n044MN42NJ6ykBShYW8QRucgNdqFJr0b9guh7aAEKJinnhoNqnQZ91aJN5R4lof
         aUCsN9a5HIF8Ms5YIm8Wn78cXsSdCwb17J3y4RzhHdyJY2Wbin+a4ztY3gwgzgmtQy
         +DuKVErtMx9wYq4HchXXz2Y/hTUTjhjbyfi81+26Dbjo6jbslCXw3UqH5uYWXkpICh
         BRI5zAfDp0mO5Lp+NyVr1VgzBCKOv6Nx8/PZZIfNBAmeAnHh07QegsXwS7TM92UArq
         XIN9TiFE7g1wPC/Vt9vAwKbQhszWNx1kID85N7cCmElhrciY4NhdhMnO/GTe15SuXJ
         9fEgO0a/uyzsA==
Date:   Mon, 9 Aug 2021 16:36:01 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        hch@infradead.org
Subject: Re: [PATCH 05/14] xfs: per-cpu deferred inode inactivation queues
Message-ID: <20210809233601.GR3601466@magnolia>
References: <162812918259.2589546.16599271324044986858.stgit@magnolia>
 <162812921040.2589546.137433781469727121.stgit@magnolia>
 <20210807002104.GB3601443@magnolia>
 <20210807214900.GB3657114@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210807214900.GB3657114@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Aug 08, 2021 at 07:49:00AM +1000, Dave Chinner wrote:
> On Fri, Aug 06, 2021 at 05:21:04PM -0700, Darrick J. Wong wrote:
> > On Wed, Aug 04, 2021 at 07:06:50PM -0700, Darrick J. Wong wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > 
> > <megasnip> A couple of minor changes that aren't worth reposting the
> > entire series:
> > 
> > > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > > index b9214733d0c3..fedfa40e3cd6 100644
> > > --- a/fs/xfs/xfs_icache.c
> > > +++ b/fs/xfs/xfs_icache.c
> > 
> > <snip>
> > 
> > > @@ -1767,30 +1801,276 @@ xfs_inode_mark_reclaimable(
> > >  		ASSERT(0);
> > >  	}
> > >  
> > > +	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
> > > +	spin_lock(&pag->pag_ici_lock);
> > > +	spin_lock(&ip->i_flags_lock);
> > > +
> > > +	trace_xfs_inode_set_reclaimable(ip);
> > > +	ip->i_flags &= ~(XFS_NEED_INACTIVE | XFS_INACTIVATING);
> > > +	ip->i_flags |= XFS_IRECLAIMABLE;
> > > +	xfs_perag_set_inode_tag(pag, XFS_INO_TO_AGINO(mp, ip->i_ino),
> > > +			XFS_ICI_RECLAIM_TAG);
> > > +
> > > +	spin_unlock(&ip->i_flags_lock);
> > > +	spin_unlock(&pag->pag_ici_lock);
> > > +	xfs_perag_put(pag);
> > > +}
> > > +
> > > +/*
> > > + * Free all speculative preallocations and possibly even the inode itself.
> > > + * This is the last chance to make changes to an otherwise unreferenced file
> > > + * before incore reclamation happens.
> > > + */
> > > +static void
> > > +xfs_inodegc_inactivate(
> > > +	struct xfs_inode	*ip)
> > > +{
> > > +	struct xfs_mount        *mp = ip->i_mount;
> > > +
> > > +	/*
> > > +	* Inactivation isn't supposed to run when the fs is frozen because
> > > +	* we don't want kernel threads to block on transaction allocation.
> > > +	*/
> > > +	ASSERT(mp->m_super->s_writers.frozen < SB_FREEZE_FS);
> > > +
> > 
> > I solved the problems Dave was complaining about (g/390, x/517) by
> > removing this ASSERT.
> > 
> > > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > > index 19260291ff8b..bd8abb50b33a 100644
> > > --- a/fs/xfs/xfs_trace.h
> > > +++ b/fs/xfs/xfs_trace.h
> > > @@ -157,6 +157,48 @@ DEFINE_PERAG_REF_EVENT(xfs_perag_put);
> > >  DEFINE_PERAG_REF_EVENT(xfs_perag_set_inode_tag);
> > >  DEFINE_PERAG_REF_EVENT(xfs_perag_clear_inode_tag);
> > >  
> > > +#define XFS_STATE_FLAGS \
> > > +	{ (1UL << XFS_STATE_INODEGC_ENABLED),		"inodegc" }
> > 
> > I've also changed the name of this to XFS_OPSTATE_STRINGS because we use
> > _STRINGS everywhere else in this file.
> 
> FWIW, can we define this with the definition of the OPSTATE
> variables in xfs_mount.h? THat makes it much easier to keep up to
> date when we add new flags because it's obvious that there are
> tracing flags that also need to be updated when we add a new state
> flag...

Yeah, I'll move the _STRINGS definition and clean up all these names to
have 'OPSTATE' instead of just 'STATE' too.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
