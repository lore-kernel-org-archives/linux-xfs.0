Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB8B3C001E0
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Jul 2023 20:59:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230446AbjGaU7A (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Jul 2023 16:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230441AbjGaU67 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Jul 2023 16:58:59 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 469A4198C
        for <linux-xfs@vger.kernel.org>; Mon, 31 Jul 2023 13:58:58 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id 5614622812f47-3a7293bb9daso1103782b6e.1
        for <linux-xfs@vger.kernel.org>; Mon, 31 Jul 2023 13:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20221208.gappssmtp.com; s=20221208; t=1690837137; x=1691441937;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Fn9UXqLqskvSmFL3RCdLJpFqCSyoeMY/4TO9KlZvbLg=;
        b=TFj6wesH+LaOAYbGl/10CMXDzUfd319a0+zvZEPpIKcqUIeffmlt40Y4nPLPPlMF06
         fbHgyzK/EeYIiWA3FT0ELfjiKAi7K9GHLqCezIIcrmI6T1CcXLzJ9xLeKWI9DpYU8Vxd
         Mg2kvCoJcQMdChlIICYZihunGqNT75EMCjstspQZCOdLQJJBQtfooaZOwT45f9XDTL5+
         r6ZUGHnpOQQv6AChI+2PckjJSAf31j5LDwp0Eq6mE95SK4xqSSAsYjyAQu+XSrzCfI92
         cGnKN8/3ldj0no/hHlpFX15aPX9zWMORazG/nCJS8i+fNtDj736NOHaUJ1/uvjFlf7Le
         UtkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690837137; x=1691441937;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fn9UXqLqskvSmFL3RCdLJpFqCSyoeMY/4TO9KlZvbLg=;
        b=MEm/o0P74bMEFmlPMjB8oxT7kpp3RACNESjEwc+4H6JzUox7maWPnuYEl22uLXh5Nm
         8dhVyVrXVIH/MnxVx7UjcRvCH1Pl8TtLg6YxNoKwGI2/JpM00djSl/UWwVn1JdktiidT
         Obb2YLOnMNpd9TRbiVGmcjfjGVWWsD2hi3oD+mVzDKRd4bz7CFIyK+mXA1Z/MLHnb68j
         jBTKRVJ6oWIAiRyBmfj5RDfZbx3W+Sla4lrWxbmnsLCpCfR++S4NGkVc88j3HRXEDYpe
         7YlDeCDlL5SwqJGlewd1LrOoGndIHPhapVfwLOIcZLgHjvatWQtQSdcAaeCDh/Ky/M+S
         h1qg==
X-Gm-Message-State: ABy/qLZDa422HR420g1lA5rvg4m2sNi/mGdo8+ZoqrrgbMssP4YLp13W
        J2RzPz4+WrRtMxjD29ZUYL+B7Q==
X-Google-Smtp-Source: APBJJlEob1ZZkvNTFzVgw2D8/jhkp9PixJEYTl893z0itJYdauFkh3JXtrkZdcBRpHCDkSiKfdEfZA==
X-Received: by 2002:a05:6808:f8b:b0:3a4:f9b:b42e with SMTP id o11-20020a0568080f8b00b003a40f9bb42emr13201718oiw.26.1690837137469;
        Mon, 31 Jul 2023 13:58:57 -0700 (PDT)
Received: from telecaster ([2620:10d:c090:400::5:22da])
        by smtp.gmail.com with ESMTPSA id jd20-20020a170903261400b001b8b0ac2258sm8995533plb.174.2023.07.31.13.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 13:58:57 -0700 (PDT)
Date:   Mon, 31 Jul 2023 13:58:55 -0700
From:   Omar Sandoval <osandov@osandov.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, kernel-team@fb.com,
        Prashant Nema <pnema@fb.com>
Subject: Re: [PATCH 5/6] xfs: don't try redundant allocations in
 xfs_rtallocate_extent_near()
Message-ID: <ZMggj09biT3DcyJc@telecaster>
References: <cover.1687296675.git.osandov@osandov.com>
 <a5bd4ca288dd1456f8c7aa5a1b7f3e1c2d9b511a.1687296675.git.osandov@osandov.com>
 <20230712233403.GY108251@frogsfrogsfrogs>
 <ZLWtXNLcRKpBgt45@telecaster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZLWtXNLcRKpBgt45@telecaster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 17, 2023 at 02:06:36PM -0700, Omar Sandoval wrote:
> On Wed, Jul 12, 2023 at 04:34:03PM -0700, Darrick J. Wong wrote:
> > On Tue, Jun 20, 2023 at 02:32:15PM -0700, Omar Sandoval wrote:
> > > From: Omar Sandoval <osandov@fb.com>
> > > 
> > > xfs_rtallocate_extent_near() tries to find a free extent as close to a
> > > target bitmap block given by bbno as possible, which may be before or
> > > after bbno. Searching backwards has a complication: the realtime summary
> > > accounts for free space _starting_ in a bitmap block, but not straddling
> > > or ending in a bitmap block. So, when the negative search finds a free
> > > extent in the realtime summary, in order to end up closer to the target,
> > > it looks for the end of the free extent. For example, if bbno - 2 has a
> > > free extent, then it will check bbno - 1, then bbno - 2. But then if
> > > bbno - 3 has a free extent, it will check bbno - 1 again, then bbno - 2
> > > again, and then bbno - 3. This results in a quadratic loop, which is
> > > completely pointless since the repeated checks won't find anything new.
> > > 
> > > Fix it by remembering where we last checked up to and continue from
> > > there. This also obviates the need for a check of the realtime summary.
> > > 
> > > Signed-off-by: Omar Sandoval <osandov@fb.com>
> > > ---
> > >  fs/xfs/xfs_rtalloc.c | 46 +++-----------------------------------------
> > >  1 file changed, 3 insertions(+), 43 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> > > index d079dfb77c73..4d9d0be2e616 100644
> > > --- a/fs/xfs/xfs_rtalloc.c
> > > +++ b/fs/xfs/xfs_rtalloc.c
> > > @@ -468,6 +468,7 @@ xfs_rtallocate_extent_near(
> > >  	}
> > >  	bbno = XFS_BITTOBLOCK(mp, bno);
> > >  	i = 0;
> > > +	j = -1;
> > >  	ASSERT(minlen != 0);
> > >  	log2len = xfs_highbit32(minlen);
> > >  	/*
> > > @@ -518,31 +519,11 @@ xfs_rtallocate_extent_near(
> > >  			else {		/* i < 0 */
> > >  				/*
> > >  				 * Loop backwards through the bitmap blocks from
> > > -				 * the starting point-1 up to where we are now.
> > > +				 * where we last checked up to where we are now.
> > 
> > I find this comment a bit unclear -- aren't we looping backwards from
> > where we last checked *downwards*?  I was reading "where we are now" to
> > mean @i, which contains a negative value.
> 
> Yes, "where we last checked down to where we are now" might be better
> wording.
> 
> > "When @i is negative, we try to find a free extent that starts in the
> > bitmap blocks before bbno.  Starting from the last bitmap block that we
> > checked in a negative scan (initially bbno - 1) and walking downwards
> > towards (bbno + i), try to allocate an extent of satisfactory length."
> > 
> > But now having worked my way through that, now I'm wondering what the j
> > loop is even doing.  Doesn't the sequence of blocks that we call
> > xfs_rtallocate_extent_block on alternate backwards and forwards?  e.g.
> > 
> > Try to find a satisfactory free extent that starts in:
> > 
> > bbno
> > bbno + 1
> > bbno - 1
> > bbno + 2
> > bbno - 2
> > ...
> > etc?
> > 
> > Why not avoid the loop entirely by calling xfs_rtallocate_extent_block
> > on bbno + i once before switching back to positive @i?  What am I
> > missing here?
> 
> There are two ways I can think of to remove the j loop, so I'll address
> both.
> 
> If you mean: make the i >= 0 and i < 0 branches the same and call
> xfs_rtallocate_extent_block() if and only if xfs_rtany_summary() returns
> a non-zero maxlog, i.e.:
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 4ab03eafd39f..9d7296c40ddd 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -495,10 +495,6 @@ xfs_rtallocate_extent_near(
>  			xfs_extlen_t maxavail =
>  				min_t(xfs_rtblock_t, maxlen,
>  				      (1ULL << (maxlog + 1)) - 1);
> -			/*
> -			 * On the positive side of the starting location.
> -			 */
> -			if (i >= 0) {
>  			/*
>  			 * Try to allocate an extent starting in
>  			 * this block.
> @@ -517,33 +513,6 @@ xfs_rtallocate_extent_near(
>  				return 0;
>  			}
>  		}
> -			/*
> -			 * On the negative side of the starting location.
> -			 */
> -			else {		/* i < 0 */
> -				/*
> -				 * Loop backwards through the bitmap blocks from
> -				 * where we last checked up to where we are now.
> -				 * There should be an extent which ends in this
> -				 * bitmap block and is long enough.
> -				 */
> -				for (; j >= i; j--) {
> -					error = xfs_rtallocate_extent_block(mp,
> -						tp, bbno + j, minlen, maxavail,
> -						len, &n, rtbufc, prod, &r);
> -					if (error) {
> -						return error;
> -					}
> -					/*
> -					 * If it works, return the extent.
> -					 */
> -					if (r != NULLRTBLOCK) {
> -						*rtblock = r;
> -						return 0;
> -					}
> -				}
> -			}
> -		}
>  		/*
>  		 * Loop control.  If we were on the positive side, and there's
>  		 * still more blocks on the negative side, go there.
> 
> Then when i < 0, this will only find the _beginning_ of a free extent
> before bbno rather than the apparent goal of trying to allocate as close
> as possible to bbno, i.e., the _end_ of the free extent. (This is what I
> tried to explain in the commit message.)
> 
> If instead you mean: unconditionally call xfs_rtallocate_extent_block()
> for bbno + i when i < 0, i.e.:
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 4ab03eafd39f..1cf42910c0e8 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -491,14 +491,10 @@ xfs_rtallocate_extent_near(
>  		 * If there are any useful extents starting here, try
>  		 * allocating one.
>  		 */
> -		if (maxlog >= 0) {
> +		if (maxlog >= 0 || i < 0) {
>  			xfs_extlen_t maxavail =
>  				min_t(xfs_rtblock_t, maxlen,
>  				      (1ULL << (maxlog + 1)) - 1);
> -			/*
> -			 * On the positive side of the starting location.
> -			 */
> -			if (i >= 0) {
>  			/*
>  			 * Try to allocate an extent starting in
>  			 * this block.
> @@ -517,33 +513,6 @@ xfs_rtallocate_extent_near(
>  				return 0;
>  			}
>  		}
> -			/*
> -			 * On the negative side of the starting location.
> -			 */
> -			else {		/* i < 0 */
> -				/*
> -				 * Loop backwards through the bitmap blocks from
> -				 * where we last checked up to where we are now.
> -				 * There should be an extent which ends in this
> -				 * bitmap block and is long enough.
> -				 */
> -				for (; j >= i; j--) {
> -					error = xfs_rtallocate_extent_block(mp,
> -						tp, bbno + j, minlen, maxavail,
> -						len, &n, rtbufc, prod, &r);
> -					if (error) {
> -						return error;
> -					}
> -					/*
> -					 * If it works, return the extent.
> -					 */
> -					if (r != NULLRTBLOCK) {
> -						*rtblock = r;
> -						return 0;
> -					}
> -				}
> -			}
> -		}
>  		/*
>  		 * Loop control.  If we were on the positive side, and there's
>  		 * still more blocks on the negative side, go there.
> 
> 
> Then this will find the end of the extent, but we will waste a lot of
> time searching bitmap blocks that don't have any usable free space. (In
> fact, this is something that patch 6 tries to reduce further.)

Ping, I hope this clarified things.
