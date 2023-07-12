Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B927EB64DA
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Jul 2023 23:34:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233322AbjGLXeP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Jul 2023 19:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233271AbjGLXeM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jul 2023 19:34:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A47881FDE
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 16:34:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 436BA6199B
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 23:34:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F58C433CA;
        Wed, 12 Jul 2023 23:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689204844;
        bh=BFmZsJ7VHqqNnNDo54hCtKj/CxrEyisRjTpqnykBn/Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SPXaYeMzpvWOfJ0ZR3UXcsvG3Lopb0s+vnsfKNdgkMBVaC/OkRMAoQPIQZ0bHlDQ2
         YBLoX93iLm4oq9C5hm6LxvU+f6c6FAdYsLQaMtzemWJWVs77NWITBz1W1nkS1okni8
         v31f6FY8iKef7TEuzzjbhCJG3EuUHnduWM1xx2wVKIDpst+RVhbUWp3NYub3PUTlzZ
         zsoRvDWYpY2Q+IshcMn2NoffK+m+jf7daB7zMsNZFZHugJv/oxqjQngPQB69WNj8Ap
         Lx+6ZehvPArUkvLiJDy1aGE+swjpsspHYg3cog2krKFeu9zPclfUFapSyLYApV2rHw
         TRQxdEb0JDlcg==
Date:   Wed, 12 Jul 2023 16:34:03 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-xfs@vger.kernel.org, kernel-team@fb.com,
        Prashant Nema <pnema@fb.com>
Subject: Re: [PATCH 5/6] xfs: don't try redundant allocations in
 xfs_rtallocate_extent_near()
Message-ID: <20230712233403.GY108251@frogsfrogsfrogs>
References: <cover.1687296675.git.osandov@osandov.com>
 <a5bd4ca288dd1456f8c7aa5a1b7f3e1c2d9b511a.1687296675.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5bd4ca288dd1456f8c7aa5a1b7f3e1c2d9b511a.1687296675.git.osandov@osandov.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 20, 2023 at 02:32:15PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> xfs_rtallocate_extent_near() tries to find a free extent as close to a
> target bitmap block given by bbno as possible, which may be before or
> after bbno. Searching backwards has a complication: the realtime summary
> accounts for free space _starting_ in a bitmap block, but not straddling
> or ending in a bitmap block. So, when the negative search finds a free
> extent in the realtime summary, in order to end up closer to the target,
> it looks for the end of the free extent. For example, if bbno - 2 has a
> free extent, then it will check bbno - 1, then bbno - 2. But then if
> bbno - 3 has a free extent, it will check bbno - 1 again, then bbno - 2
> again, and then bbno - 3. This results in a quadratic loop, which is
> completely pointless since the repeated checks won't find anything new.
> 
> Fix it by remembering where we last checked up to and continue from
> there. This also obviates the need for a check of the realtime summary.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
>  fs/xfs/xfs_rtalloc.c | 46 +++-----------------------------------------
>  1 file changed, 3 insertions(+), 43 deletions(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index d079dfb77c73..4d9d0be2e616 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -468,6 +468,7 @@ xfs_rtallocate_extent_near(
>  	}
>  	bbno = XFS_BITTOBLOCK(mp, bno);
>  	i = 0;
> +	j = -1;
>  	ASSERT(minlen != 0);
>  	log2len = xfs_highbit32(minlen);
>  	/*
> @@ -518,31 +519,11 @@ xfs_rtallocate_extent_near(
>  			else {		/* i < 0 */
>  				/*
>  				 * Loop backwards through the bitmap blocks from
> -				 * the starting point-1 up to where we are now.
> +				 * where we last checked up to where we are now.

I find this comment a bit unclear -- aren't we looping backwards from
where we last checked *downwards*?  I was reading "where we are now" to
mean @i, which contains a negative value.

"When @i is negative, we try to find a free extent that starts in the
bitmap blocks before bbno.  Starting from the last bitmap block that we
checked in a negative scan (initially bbno - 1) and walking downwards
towards (bbno + i), try to allocate an extent of satisfactory length."

But now having worked my way through that, now I'm wondering what the j
loop is even doing.  Doesn't the sequence of blocks that we call
xfs_rtallocate_extent_block on alternate backwards and forwards?  e.g.

Try to find a satisfactory free extent that starts in:

bbno
bbno + 1
bbno - 1
bbno + 2
bbno - 2
...
etc?

Why not avoid the loop entirely by calling xfs_rtallocate_extent_block
on bbno + i once before switching back to positive @i?  What am I
missing here?

>  				 * There should be an extent which ends in this
>  				 * bitmap block and is long enough.
>  				 */
> -				for (j = -1; j > i; j--) {
> -					/*
> -					 * Grab the summary information for
> -					 * this bitmap block.
> -					 */
> -					error = xfs_rtany_summary(mp, tp,
> -						log2len, mp->m_rsumlevels - 1,
> -						bbno + j, rtbufc, &maxlog);
> -					if (error) {
> -						return error;
> -					}
> -					/*
> -					 * If there's no extent given in the
> -					 * summary that means the extent we
> -					 * found must carry over from an
> -					 * earlier block.  If there is an
> -					 * extent given, we've already tried
> -					 * that allocation, don't do it again.
> -					 */
> -					if (maxlog >= 0)
> -						continue;
> +				for (; j >= i; j--) {

Changing the j > i to j >= i is what obviates the extra call to
xfs_rtallocate_extent_block below, correct?

--D

>  					error = xfs_rtallocate_extent_block(mp,
>  						tp, bbno + j, minlen, maxavail,
>  						len, &n, rtbufc, prod, &r);
> @@ -557,27 +538,6 @@ xfs_rtallocate_extent_near(
>  						return 0;
>  					}
>  				}
> -				/*
> -				 * There weren't intervening bitmap blocks
> -				 * with a long enough extent, or the
> -				 * allocation didn't work for some reason
> -				 * (i.e. it's a little * too short).
> -				 * Try to allocate from the summary block
> -				 * that we found.
> -				 */
> -				error = xfs_rtallocate_extent_block(mp, tp,
> -					bbno + i, minlen, maxavail, len, &n,
> -					rtbufc, prod, &r);
> -				if (error) {
> -					return error;
> -				}
> -				/*
> -				 * If it works, return the extent.
> -				 */
> -				if (r != NULLRTBLOCK) {
> -					*rtblock = r;
> -					return 0;
> -				}
>  			}
>  		}
>  		/*
> -- 
> 2.41.0
> 
