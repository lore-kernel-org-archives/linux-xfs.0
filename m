Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D5D2C433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Mar 2022 02:21:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbiCACWH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Feb 2022 21:22:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiCACWG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Feb 2022 21:22:06 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D70CFD38
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 18:21:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id ADDF4CE19B5
        for <linux-xfs@vger.kernel.org>; Tue,  1 Mar 2022 02:21:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6959C340EE;
        Tue,  1 Mar 2022 02:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646101275;
        bh=hN4jDd46Wn5FO5ZRYedTi0mnShjVtOAw6mXVcJrsZsk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R1pq0qtPnqVlwucN54HyW0qkzcxEFBm4zDWEWEk0qdov0GPMtnYgIAj1hiTsro43J
         9bwcjxvCs0WIRzZRqqykKHeUExd7c6w/CZGTOABCyFkRAuqMfgHmT/tL4XDwhjKKt/
         22PWoFDE16Jw03tUpFvrIbKBFFdfkdwSoJWia9bZIvr09A8wBxc7h18OFz07Fjrq4n
         iAY0Kix/WtFsREsTSqNkSOZUuJUjG/TOT+Ww8vs9Xj4Zkwlrvl+K2ItDpVaQpVZS/n
         DKhBfWR9M8e2iPNhN7HBIHM4uMskL0AXZ9e7Uys7vq4Hn53JcbmKZahAEFYRVf4pfV
         xg1UikhyYfG4g==
Date:   Mon, 28 Feb 2022 18:21:15 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
        Theodore Ts'o <tytso@mit.edu>, linux-xfs@vger.kernel.org,
        allison.henderson@oracle.com
Subject: Re: [PATCH 19/17] mkfs: increase default log size for new (aka
 bigtime) filesystems
Message-ID: <20220301022115.GB117732@magnolia>
References: <164263809453.863810.8908193461297738491.stgit@magnolia>
 <20220226025450.GY8313@magnolia>
 <2476cebf-b383-9788-4222-be918aa7a077@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2476cebf-b383-9788-4222-be918aa7a077@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 28, 2022 at 03:44:29PM -0600, Eric Sandeen wrote:
> On 2/25/22 8:54 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> 
> ...
> 
> > Hence we increase the ratio by 16x because there doesn't seem to be much
> > improvement beyond that, and we don't want the log to grow /too/ large.
> > This change does not affect filesystems larger than 4TB, nor does it
> > affect formatting to older formats.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  mkfs/xfs_mkfs.c |   12 +++++++++++-
> >  1 file changed, 11 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index 96682f9a..7178d798 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -3308,7 +3308,17 @@ _("external log device size %lld blocks too small, must be at least %lld blocks\
> >  
> >  	/* internal log - if no size specified, calculate automatically */
> >  	if (!cfg->logblocks) {
> > -		if (cfg->dblocks < GIGABYTES(1, cfg->blocklog)) {
> > +		if (cfg->sb_feat.bigtime) {
> 
> I'm not very keen on conditioning this on bigtime; it seems very ad-hoc and
> unexpected. Future maintainers will look at this and wonder why bigtime is
> in any way related to log size...
> 
> If we make this change, why not just make it regardless of other features?
> Is there some other risk to doing so?

I wrote it this way to leave the formatting behavior unchanged on older
filesystems, figuring that you'd be wary of anything that could generate
bug reports about old fs formats, e.g. "Why does my cloud deployment
image generator report that the minified filesystem size went up when I
went from X to X+1?"

So now that I've guessed incorrectly, I guess I'll go change this to do
it unconditionally.  Or drop the whole thing entirely.  I don't know.
I'm too burned out to be able to think reasonably anymore.

Frankly, I don't have the time to prove beyond a reasonable doubt that
this the problem is exactly as stated, that the code change is exactly
the correct fix, that no other fix is more appropriate, and that there
are no other possible explanations for the slowness being complained
aobut.  I really just wanted to do this one little thing that we've all
basically agreed is the right thing.

Instead I'll just leave things as they are, and consider whether there
even is a future for me working on XFS.

--D

> Thanks,
> -Eric
> 
> > +			/*
> > +			 * Starting with bigtime, everybody gets a 256:1 ratio
> > +			 * of fs size to log size unless they say otherwise.
> > +			 * Larger logs reduce contention for log grant space,
> > +			 * which is now a problem with the advent of small
> > +			 * non-rotational storage devices.
> > +			 */
> > +			cfg->logblocks = (cfg->dblocks << cfg->blocklog) / 256;
> > +			cfg->logblocks = cfg->logblocks >> cfg->blocklog;
> > +		} else if (cfg->dblocks < GIGABYTES(1, cfg->blocklog)) {
> >  			/* tiny filesystems get minimum sized logs. */
> >  			cfg->logblocks = min_logblocks;
> >  		} else if (cfg->dblocks < GIGABYTES(16, cfg->blocklog)) {
> > 
