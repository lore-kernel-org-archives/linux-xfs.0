Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EDE9C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Apr 2022 17:11:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240885AbiDSROb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Apr 2022 13:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356137AbiDSRM7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Apr 2022 13:12:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4393C1FCC0
        for <linux-xfs@vger.kernel.org>; Tue, 19 Apr 2022 10:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE428B819A5
        for <linux-xfs@vger.kernel.org>; Tue, 19 Apr 2022 17:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7FBC385A5;
        Tue, 19 Apr 2022 17:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650388213;
        bh=M/fmluolXJ28S9PfnMsgL0u7Y4Suo9tzJ2oBbTzEInw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jhcEN9tipHc2td46iKR0kqpOMr/4r0H6QYozC2ORGJ+5/MJ6G84SNB4wAi7fweAp9
         Klqfa9GNhZ5jnmR9mWL2uZEF8LTYk5K+2Im4P/4l3l0E6d8IVdrqFbZ5loGu/rEWgC
         PBugSNYrpZ4YwS7mqrHu4X9L/9+Fm2ZDFjxw1YNOv+kNcsSNepRL3qtcujHuY2NFoe
         ZtyiaPXNL0UImeSbA2gq4TVNZYf/rvmXJJFTgOo+KlSjSEiZTGF/hhnPhk1CVQQL1T
         BH/cHoit3idngz3sc90rAEe34Otu4c26mU9LnSyfabzfCpIpE0auPFLosaQgJYo7LP
         UXkucnEnUbItw==
Date:   Tue, 19 Apr 2022 10:10:13 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Andrey Albershteyn <aalbersh@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_db: take BB cluster offset into account when using
 'type' cmd
Message-ID: <20220419171013.GL17025@magnolia>
References: <20220419121951.50412-1-aalbersh@redhat.com>
 <20220419154750.GI17025@magnolia>
 <Yl7poFqm7X9+M3Up@aalbersh.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yl7poFqm7X9+M3Up@aalbersh.remote.csb>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 19, 2022 at 06:56:00PM +0200, Andrey Albershteyn wrote:
> On Tue, Apr 19, 2022 at 08:47:50AM -0700, Darrick J. Wong wrote:
> > On Tue, Apr 19, 2022 at 02:19:51PM +0200, Andrey Albershteyn wrote:
> > > Changing the interpretation type of data under the cursor moves the
> > > cursor to the beginning of BB cluster. When cursor is set to an
> > > inode the cursor is offset in BB buffer. However, this offset is not
> > > considered when type of the data is changed - the cursor points to
> > > the beginning of BB buffer. For example:
> > > 
> > > $ xfs_db -c "inode 131" -c "daddr" -c "type text" \
> > > 	-c "daddr" /dev/sdb1
> > > current daddr is 131
> > > current daddr is 128
> > > 
> > > Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> > > ---
> > >  db/io.c | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > > 
> > > diff --git a/db/io.c b/db/io.c
> > > index df97ed91..107f2e11 100644
> > > --- a/db/io.c
> > > +++ b/db/io.c
> > > @@ -589,6 +589,7 @@ set_iocur_type(
> > >  	const typ_t	*type)
> > >  {
> > >  	int		bb_count = 1;	/* type's size in basic blocks */
> > > +	int boff = iocur_top->boff;
> > 
> > Nit: Please line up the variable names.
> 
> sure ;)
> 
> > 
> > >  
> > >  	/*
> > >  	 * Inodes are special; verifier checks all inodes in the chunk, the
> > > @@ -613,6 +614,9 @@ set_iocur_type(
> > >  		bb_count = BTOBB(byteize(fsize(type->fields,
> > >  				       iocur_top->data, 0, 0)));
> > >  	set_cur(type, iocur_top->bb, bb_count, DB_RING_IGN, NULL);
> > > +	iocur_top->boff = boff;
> > > +	iocur_top->off = ((xfs_off_t)iocur_top->bb << BBSHIFT) + boff;
> > > +	iocur_top->data = (void *)((char *)iocur_top->buf + boff);
> > 
> > It seems reasonable to me to preserve the io cursor's boff when we're
> > setting /only/ the buffer type, but this function and off_cur() could
> > share these three lines of code that (re)set boff/off/data.
> > 
> > Alternately, I guess you could just call off_cur(boff, BBTOB(bb_count))
> > here.
> 
> This won't pass the second condition in off_cur(). I suppose the
> purpose of off_cur() was to shift io cursor in BB buffer. But
> changing the type changes the blen which could be smaller (e.g.
> inode blen == 32 -> text blen == 1). Anyway, will try to come up
> with a meaningful name for this 3 lines function :)

Ooh, a bikeshed!  How about:

static inline void set_cur_boff(int boff)
{
	iocur_top->boff = boff;
	iocur_top->off = ((xfs_off_t)iocur_top->bb << BBSHIFT) + boff;
	iocur_top->data = (void *)((char *)iocur_top->buf + boff);
}

> I think the other solution could be to set boff in set_cur(), but
> this will require more refactoring and I suppose this is the only
> place where newly added argument would be used.
> 
> > 
> > --D
> > 
> > >  }
> > >  
> > >  static void
> > > -- 
> > > 2.27.0
> > > 
> > 
> 
> -- 
> - Andrey
> 
