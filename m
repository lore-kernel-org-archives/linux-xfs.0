Return-Path: <SRS0=IJtx=XO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F343EC3A5A6
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 14:57:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D081820882
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 14:57:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731857AbfISO56 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Sep 2019 10:57:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52000 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728720AbfISO56 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Sep 2019 10:57:58 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0C22B3090FCB;
        Thu, 19 Sep 2019 14:57:58 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A9D1C196AE;
        Thu, 19 Sep 2019 14:57:57 +0000 (UTC)
Date:   Thu, 19 Sep 2019 10:57:55 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 01/11] xfs: track active state of allocation btree
 cursors
Message-ID: <20190919145755.GA35460@bfoster>
References: <20190916121635.43148-1-bfoster@redhat.com>
 <20190916121635.43148-2-bfoster@redhat.com>
 <20190918183818.GP2229799@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918183818.GP2229799@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Thu, 19 Sep 2019 14:57:58 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 18, 2019 at 11:38:18AM -0700, Darrick J. Wong wrote:
> On Mon, Sep 16, 2019 at 08:16:25AM -0400, Brian Foster wrote:
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
> > index 533b04aaf6f6..512a45888e06 100644
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
> > +	cur->bc_private.a.priv.abt.active = *stat == 1 ? true : false;
> 
> I think "cur->bc_private.a.priv.abt.active = (*stat == 1);" would have
> sufficed for these, right?  (Yeah, sorry, picking at nits here...)
> 

Sure, I'll fix those up.

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
> > +	cur->bc_private.a.priv.abt.active = *stat == 1 ? true : false;
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
> > +	cur->bc_private.a.priv.abt.active = *stat == 1 ? true : false;
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
> > index ced1e65d1483..b4e3ec1d7ff9 100644
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
