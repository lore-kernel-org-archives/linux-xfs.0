Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E3A1EB64DC
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Jul 2023 21:06:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbjGQVGz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Jul 2023 17:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbjGQVGp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Jul 2023 17:06:45 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CBA81703
        for <linux-xfs@vger.kernel.org>; Mon, 17 Jul 2023 14:06:39 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1b890e2b9b7so27994045ad.3
        for <linux-xfs@vger.kernel.org>; Mon, 17 Jul 2023 14:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20221208.gappssmtp.com; s=20221208; t=1689627998; x=1692219998;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xYLfk/ezEG3eoKGHYBdO3nbOuMt1DJo0XW1xZaU+H/4=;
        b=fU/9WefaoF7BeYXKcSeGBRfgSMr9nCmOp7EhcEvnj2q7m7x91QnQoU5tquqiz2T1LU
         F3iS4Jfcrc73EBBT7Z5swoNHV9lznLq0mV1fI9TTBtKQM0XFUG42OPeqgS9E9py4FC0x
         ygHsA/+wxQKXFH1HwsQEEy6NmM+QRqxLRK0MRXsjAzpUA1LrXDmMPo5OdKCKvIOEXkel
         gKrMQNHszfMz3MbEI0QdU8Z6fsybFJr7RhjO05YIz4+xLWdNanfTK+7nggRIAuv2GvBV
         gzcUWJE4BVGsiJl1hSC/mvsZ0WU23iKrqmw5j4pHNaVYVGd9cu7RpxHoCe6NOVukdjXY
         0cNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689627998; x=1692219998;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xYLfk/ezEG3eoKGHYBdO3nbOuMt1DJo0XW1xZaU+H/4=;
        b=kwSXs/hK7EJvjURhbfw3/9TdYVx1/pmroQs3TX7bEFkth/unDEGUAW7N6l2nJeGy9q
         aQTZbudBFue1SO3BySrBuPkrV5IrvP3r1P4QqVtcb2iO5P2v12st/i+6+R+kelotW6zF
         fCsVq0qAb5WSWixblmuzOe2N+4EqVUjdBjWq3vv8cpSS1AQ5ax7qJlhxfVRmAbcH6HsD
         sT8NZBmTvnCgUnX5EauJuQy0Xu1J+KFew5YQfl4kGPX93gBs4O5ZMJ9LRG7myU0stbNQ
         yyVbb9HPV9duNEC/hj7uRGVkXmWbsjOmNj/n7eePXwRjOvchNP3em9zg49MfB9+kgcTF
         TK9Q==
X-Gm-Message-State: ABy/qLa/fx3ih/NN/Y86F9rqjt5MNg4ROsXzvZpLfjWetzsSqJDxHHnw
        0kwEPcLDZ7ppWjMOfYaKyi4vpA==
X-Google-Smtp-Source: APBJJlGve5nvfBPxUrdF8cqnFuerb7G6mOOM4C7qGoJIwzXOMBWpATVIo5dMGVxCwb6qNHdhWoxZbQ==
X-Received: by 2002:a17:902:d2cd:b0:1b5:49fc:e336 with SMTP id n13-20020a170902d2cd00b001b549fce336mr13118020plc.42.1689627998456;
        Mon, 17 Jul 2023 14:06:38 -0700 (PDT)
Received: from telecaster ([2620:10d:c090:400::5:7a5c])
        by smtp.gmail.com with ESMTPSA id y17-20020a170902b49100b001b9d95945afsm304925plr.155.2023.07.17.14.06.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jul 2023 14:06:37 -0700 (PDT)
Date:   Mon, 17 Jul 2023 14:06:36 -0700
From:   Omar Sandoval <osandov@osandov.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, kernel-team@fb.com,
        Prashant Nema <pnema@fb.com>
Subject: Re: [PATCH 5/6] xfs: don't try redundant allocations in
 xfs_rtallocate_extent_near()
Message-ID: <ZLWtXNLcRKpBgt45@telecaster>
References: <cover.1687296675.git.osandov@osandov.com>
 <a5bd4ca288dd1456f8c7aa5a1b7f3e1c2d9b511a.1687296675.git.osandov@osandov.com>
 <20230712233403.GY108251@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230712233403.GY108251@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 12, 2023 at 04:34:03PM -0700, Darrick J. Wong wrote:
> On Tue, Jun 20, 2023 at 02:32:15PM -0700, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > 
> > xfs_rtallocate_extent_near() tries to find a free extent as close to a
> > target bitmap block given by bbno as possible, which may be before or
> > after bbno. Searching backwards has a complication: the realtime summary
> > accounts for free space _starting_ in a bitmap block, but not straddling
> > or ending in a bitmap block. So, when the negative search finds a free
> > extent in the realtime summary, in order to end up closer to the target,
> > it looks for the end of the free extent. For example, if bbno - 2 has a
> > free extent, then it will check bbno - 1, then bbno - 2. But then if
> > bbno - 3 has a free extent, it will check bbno - 1 again, then bbno - 2
> > again, and then bbno - 3. This results in a quadratic loop, which is
> > completely pointless since the repeated checks won't find anything new.
> > 
> > Fix it by remembering where we last checked up to and continue from
> > there. This also obviates the need for a check of the realtime summary.
> > 
> > Signed-off-by: Omar Sandoval <osandov@fb.com>
> > ---
> >  fs/xfs/xfs_rtalloc.c | 46 +++-----------------------------------------
> >  1 file changed, 3 insertions(+), 43 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> > index d079dfb77c73..4d9d0be2e616 100644
> > --- a/fs/xfs/xfs_rtalloc.c
> > +++ b/fs/xfs/xfs_rtalloc.c
> > @@ -468,6 +468,7 @@ xfs_rtallocate_extent_near(
> >  	}
> >  	bbno = XFS_BITTOBLOCK(mp, bno);
> >  	i = 0;
> > +	j = -1;
> >  	ASSERT(minlen != 0);
> >  	log2len = xfs_highbit32(minlen);
> >  	/*
> > @@ -518,31 +519,11 @@ xfs_rtallocate_extent_near(
> >  			else {		/* i < 0 */
> >  				/*
> >  				 * Loop backwards through the bitmap blocks from
> > -				 * the starting point-1 up to where we are now.
> > +				 * where we last checked up to where we are now.
> 
> I find this comment a bit unclear -- aren't we looping backwards from
> where we last checked *downwards*?  I was reading "where we are now" to
> mean @i, which contains a negative value.

Yes, "where we last checked down to where we are now" might be better
wording.

> "When @i is negative, we try to find a free extent that starts in the
> bitmap blocks before bbno.  Starting from the last bitmap block that we
> checked in a negative scan (initially bbno - 1) and walking downwards
> towards (bbno + i), try to allocate an extent of satisfactory length."
> 
> But now having worked my way through that, now I'm wondering what the j
> loop is even doing.  Doesn't the sequence of blocks that we call
> xfs_rtallocate_extent_block on alternate backwards and forwards?  e.g.
> 
> Try to find a satisfactory free extent that starts in:
> 
> bbno
> bbno + 1
> bbno - 1
> bbno + 2
> bbno - 2
> ...
> etc?
> 
> Why not avoid the loop entirely by calling xfs_rtallocate_extent_block
> on bbno + i once before switching back to positive @i?  What am I
> missing here?

There are two ways I can think of to remove the j loop, so I'll address
both.

If you mean: make the i >= 0 and i < 0 branches the same and call
xfs_rtallocate_extent_block() if and only if xfs_rtany_summary() returns
a non-zero maxlog, i.e.:

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 4ab03eafd39f..9d7296c40ddd 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -495,10 +495,6 @@ xfs_rtallocate_extent_near(
 			xfs_extlen_t maxavail =
 				min_t(xfs_rtblock_t, maxlen,
 				      (1ULL << (maxlog + 1)) - 1);
-			/*
-			 * On the positive side of the starting location.
-			 */
-			if (i >= 0) {
 			/*
 			 * Try to allocate an extent starting in
 			 * this block.
@@ -517,33 +513,6 @@ xfs_rtallocate_extent_near(
 				return 0;
 			}
 		}
-			/*
-			 * On the negative side of the starting location.
-			 */
-			else {		/* i < 0 */
-				/*
-				 * Loop backwards through the bitmap blocks from
-				 * where we last checked up to where we are now.
-				 * There should be an extent which ends in this
-				 * bitmap block and is long enough.
-				 */
-				for (; j >= i; j--) {
-					error = xfs_rtallocate_extent_block(mp,
-						tp, bbno + j, minlen, maxavail,
-						len, &n, rtbufc, prod, &r);
-					if (error) {
-						return error;
-					}
-					/*
-					 * If it works, return the extent.
-					 */
-					if (r != NULLRTBLOCK) {
-						*rtblock = r;
-						return 0;
-					}
-				}
-			}
-		}
 		/*
 		 * Loop control.  If we were on the positive side, and there's
 		 * still more blocks on the negative side, go there.

Then when i < 0, this will only find the _beginning_ of a free extent
before bbno rather than the apparent goal of trying to allocate as close
as possible to bbno, i.e., the _end_ of the free extent. (This is what I
tried to explain in the commit message.)

If instead you mean: unconditionally call xfs_rtallocate_extent_block()
for bbno + i when i < 0, i.e.:

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 4ab03eafd39f..1cf42910c0e8 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -491,14 +491,10 @@ xfs_rtallocate_extent_near(
 		 * If there are any useful extents starting here, try
 		 * allocating one.
 		 */
-		if (maxlog >= 0) {
+		if (maxlog >= 0 || i < 0) {
 			xfs_extlen_t maxavail =
 				min_t(xfs_rtblock_t, maxlen,
 				      (1ULL << (maxlog + 1)) - 1);
-			/*
-			 * On the positive side of the starting location.
-			 */
-			if (i >= 0) {
 			/*
 			 * Try to allocate an extent starting in
 			 * this block.
@@ -517,33 +513,6 @@ xfs_rtallocate_extent_near(
 				return 0;
 			}
 		}
-			/*
-			 * On the negative side of the starting location.
-			 */
-			else {		/* i < 0 */
-				/*
-				 * Loop backwards through the bitmap blocks from
-				 * where we last checked up to where we are now.
-				 * There should be an extent which ends in this
-				 * bitmap block and is long enough.
-				 */
-				for (; j >= i; j--) {
-					error = xfs_rtallocate_extent_block(mp,
-						tp, bbno + j, minlen, maxavail,
-						len, &n, rtbufc, prod, &r);
-					if (error) {
-						return error;
-					}
-					/*
-					 * If it works, return the extent.
-					 */
-					if (r != NULLRTBLOCK) {
-						*rtblock = r;
-						return 0;
-					}
-				}
-			}
-		}
 		/*
 		 * Loop control.  If we were on the positive side, and there's
 		 * still more blocks on the negative side, go there.


Then this will find the end of the extent, but we will waste a lot of
time searching bitmap blocks that don't have any usable free space. (In
fact, this is something that patch 6 tries to reduce further.)

> >  				 * There should be an extent which ends in this
> >  				 * bitmap block and is long enough.
> >  				 */
> > -				for (j = -1; j > i; j--) {
> > -					/*
> > -					 * Grab the summary information for
> > -					 * this bitmap block.
> > -					 */
> > -					error = xfs_rtany_summary(mp, tp,
> > -						log2len, mp->m_rsumlevels - 1,
> > -						bbno + j, rtbufc, &maxlog);
> > -					if (error) {
> > -						return error;
> > -					}
> > -					/*
> > -					 * If there's no extent given in the
> > -					 * summary that means the extent we
> > -					 * found must carry over from an
> > -					 * earlier block.  If there is an
> > -					 * extent given, we've already tried
> > -					 * that allocation, don't do it again.
> > -					 */
> > -					if (maxlog >= 0)
> > -						continue;
> > +				for (; j >= i; j--) {
> 
> Changing the j > i to j >= i is what obviates the extra call to
> xfs_rtallocate_extent_block below, correct?

Correct. Before, the loop body was different because it contained a call
to xfs_rtany_summary(). But now there's no check, so the extra call can
be included in the loop.
