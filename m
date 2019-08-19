Return-Path: <SRS0=Z/aa=WP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 163A8C3A5A0
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Aug 2019 18:03:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB89322CEB
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Aug 2019 18:03:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbfHSSDp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Aug 2019 14:03:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53444 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727744AbfHSSDp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Aug 2019 14:03:45 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AACF4800DE1;
        Mon, 19 Aug 2019 18:03:44 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 54A641E9;
        Mon, 19 Aug 2019 18:03:44 +0000 (UTC)
Date:   Mon, 19 Aug 2019 14:03:42 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 1/4] xfs: track active state of allocation btree
 cursors
Message-ID: <20190819180342.GC2875@bfoster>
References: <20190815125538.49570-1-bfoster@redhat.com>
 <20190815125538.49570-2-bfoster@redhat.com>
 <20190817005149.GA752159@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190817005149.GA752159@magnolia>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.67]); Mon, 19 Aug 2019 18:03:44 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 16, 2019 at 05:51:49PM -0700, Darrick J. Wong wrote:
> On Thu, Aug 15, 2019 at 08:55:35AM -0400, Brian Foster wrote:
> > The upcoming allocation algorithm update searches multiple
> > allocation btree cursors concurrently. As such, it requires an
> > active state to track when a particular cursor should continue
> > searching. While active state will be modified based on higher level
> > logic, we can define base functionality based on the result of
> > allocation btree lookups.
> > 
> > Define an active flag in the private area of the btree cursor.
> > Update it based on the result of lookups in the existing allocation
> > btree helpers. Finally, provide a new helper to query the current
> > state.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c       | 24 +++++++++++++++++++++---
> >  fs/xfs/libxfs/xfs_alloc_btree.c |  1 +
> >  fs/xfs/libxfs/xfs_btree.h       |  3 +++
> >  3 files changed, 25 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index 372ad55631fc..6340f59ac3f4 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -146,9 +146,13 @@ xfs_alloc_lookup_eq(
> >  	xfs_extlen_t		len,	/* length of extent */
> >  	int			*stat)	/* success/failure */
> >  {
> > +	int			error;
> > +
> >  	cur->bc_rec.a.ar_startblock = bno;
> >  	cur->bc_rec.a.ar_blockcount = len;
> > -	return xfs_btree_lookup(cur, XFS_LOOKUP_EQ, stat);
> > +	error = xfs_btree_lookup(cur, XFS_LOOKUP_EQ, stat);
> > +	cur->bc_private.a.priv.abt.active = *stat;
> 
> <urk> Not really a fan of mixing types (even if they are bool and int),
> how hard would it be to convert some of these *stat to bool?
> 

Hmm... that might be slightly annoying because some of these functions
use an 'i' variable and pass it all around to various other similar
helpers that expect an int. I was trying to break that mold by using a
boolean here, but not necessarily tie in this kind of refactoring as a
dependency for this work, particularly since it will ultimately replace
much of the allocator code. 

I could either code this without the direct assignment between int/bool
or just use an int for 'active' for now (and even rename it to stat if
that's more clear) and switch both over to bool once the other
allocation modes are done. Thoughts?

> Does abt.active have a use outside of the struct xfs_alloc_cur in the
> next patch?
> 

No. It was originally a field in the xfs_alloc_cur and then pushed down
into the cursor private area based on feedback on previous versions of
this set.

Brian

> --D
> 
> > +	return error;
> >  }
> >  
> >  /*
> > @@ -162,9 +166,13 @@ xfs_alloc_lookup_ge(
> >  	xfs_extlen_t		len,	/* length of extent */
> >  	int			*stat)	/* success/failure */
> >  {
> > +	int			error;
> > +
> >  	cur->bc_rec.a.ar_startblock = bno;
> >  	cur->bc_rec.a.ar_blockcount = len;
> > -	return xfs_btree_lookup(cur, XFS_LOOKUP_GE, stat);
> > +	error = xfs_btree_lookup(cur, XFS_LOOKUP_GE, stat);
> > +	cur->bc_private.a.priv.abt.active = *stat;
> > +	return error;
> >  }
> >  
> >  /*
> > @@ -178,9 +186,19 @@ xfs_alloc_lookup_le(
> >  	xfs_extlen_t		len,	/* length of extent */
> >  	int			*stat)	/* success/failure */
> >  {
> > +	int			error;
> >  	cur->bc_rec.a.ar_startblock = bno;
> >  	cur->bc_rec.a.ar_blockcount = len;
> > -	return xfs_btree_lookup(cur, XFS_LOOKUP_LE, stat);
> > +	error = xfs_btree_lookup(cur, XFS_LOOKUP_LE, stat);
> > +	cur->bc_private.a.priv.abt.active = *stat;
> > +	return error;
> > +}
> > +
> > +static inline bool
> > +xfs_alloc_cur_active(
> > +	struct xfs_btree_cur	*cur)
> > +{
> > +	return cur && cur->bc_private.a.priv.abt.active;
> >  }
> >  
> >  /*
> > diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> > index 2a94543857a1..279694d73e4e 100644
> > --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> > +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> > @@ -507,6 +507,7 @@ xfs_allocbt_init_cursor(
> >  
> >  	cur->bc_private.a.agbp = agbp;
> >  	cur->bc_private.a.agno = agno;
> > +	cur->bc_private.a.priv.abt.active = false;
> >  
> >  	if (xfs_sb_version_hascrc(&mp->m_sb))
> >  		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
> > diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> > index fa3cd8ab9aba..a66063c356cc 100644
> > --- a/fs/xfs/libxfs/xfs_btree.h
> > +++ b/fs/xfs/libxfs/xfs_btree.h
> > @@ -183,6 +183,9 @@ union xfs_btree_cur_private {
> >  		unsigned long	nr_ops;		/* # record updates */
> >  		int		shape_changes;	/* # of extent splits */
> >  	} refc;
> > +	struct {
> > +		bool		active;		/* allocation cursor state */
> > +	} abt;
> >  };
> >  
> >  /*
> > -- 
> > 2.20.1
> > 
