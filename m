Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7A2FC433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Jul 2022 00:08:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbiGAAIi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Jun 2022 20:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiGAAIi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Jun 2022 20:08:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C1614D16D
        for <linux-xfs@vger.kernel.org>; Thu, 30 Jun 2022 17:08:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21D2161CD0
        for <linux-xfs@vger.kernel.org>; Fri,  1 Jul 2022 00:08:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C47C34115;
        Fri,  1 Jul 2022 00:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656634115;
        bh=tMAI4UvhzZRnkFCIFs7n0p8Be71885ibVVkTVWeY7QY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IDMyCkknX37JCmbBARvENvzw16ZtVbLBph5aavQfHBjCsPkSZkp3gc2Ji9R2sVlpk
         0AuNfU7Oo1R3czAPsDr4VqlqzbhV4/NKCnkos1LSi/7qPVZIz1lEGlfCQM74E5AGbb
         ShXbN2QOBuQ4jvXn9g8iACjT+QGXx/HQe69FF1LdVdGI9QfiRlsegO+6dTbUQGB5w3
         qvzTCpYyKaUR9nWx927ZGaW50V4pcFCaKvC5wx5xSgkEr2rZbHbjf8eEt5mofUTJ8z
         l128VuyGPaC5vvUMuQgAL+tlHuJmSf+dNTiqHIxp4EYMFoOgHWEvyeEIfUprXHG8kX
         iVl0JV9+nELnQ==
Date:   Thu, 30 Jun 2022 17:08:34 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs_repair: clear DIFLAG2_NREXT64 when filesystem
 doesn't support nrext64
Message-ID: <Yr47An/hakkTSeDc@magnolia>
References: <165644935451.1089996.13716062701488693755.stgit@magnolia>
 <165644936573.1089996.11135224585697421312.stgit@magnolia>
 <20220628225857.GO227878@dread.disaster.area>
 <Yrzb9xFYKzvfQ/tP@magnolia>
 <20220630225145.GB227878@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630225145.GB227878@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 01, 2022 at 08:51:45AM +1000, Dave Chinner wrote:
> On Wed, Jun 29, 2022 at 04:10:47PM -0700, Darrick J. Wong wrote:
> > On Wed, Jun 29, 2022 at 08:58:57AM +1000, Dave Chinner wrote:
> > > On Tue, Jun 28, 2022 at 01:49:25PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Clear the nrext64 inode flag if the filesystem doesn't have the nrext64
> > > > feature enabled in the superblock.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > >  repair/dinode.c |   19 +++++++++++++++++++
> > > >  1 file changed, 19 insertions(+)
> > > > 
> > > > 
> > > > diff --git a/repair/dinode.c b/repair/dinode.c
> > > > index 00de31fb..547c5833 100644
> > > > --- a/repair/dinode.c
> > > > +++ b/repair/dinode.c
> > > > @@ -2690,6 +2690,25 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
> > > >  			}
> > > >  		}
> > > >  
> > > > +		if (xfs_dinode_has_large_extent_counts(dino) &&
> > > > +		    !xfs_has_large_extent_counts(mp)) {
> > > > +			if (!uncertain) {
> > > > +				do_warn(
> > > > +	_("inode %" PRIu64 " is marked large extent counts but file system does not support large extent counts\n"),
> > > > +					lino);
> > > > +			}
> > > > +			flags2 &= ~XFS_DIFLAG2_NREXT64;
> > > > +
> > > > +			if (no_modify) {
> > > > +				do_warn(_("would zero extent counts.\n"));
> > > > +			} else {
> > > > +				do_warn(_("zeroing extent counts.\n"));
> > > > +				dino->di_nextents = 0;
> > > > +				dino->di_anextents = 0;
> > > > +				*dirty = 1;
> > > 
> > > Is that necessary? If the existing extent counts are within the
> > > bounds of the old extent fields, then shouldn't we just rewrite the
> > > current values into the old format rather than trashing all the
> > > data/xattrs on the inode?
> > 
> > It's hard to know what to do here -- we haven't actually checked the
> > forks yet, so we don't know if the dinode flag was set but the !nrext64
> > extent count fields are ok so all we have to do is clear the dinode
> > flag; or if the dinode flag was set, the nrext64 extent count fields are
> > correct and must be moved to the !nrext64 fields; or what?
> > 
> > I guess I could just leave the extent count fields as-is and let the
> > process_*_fork functions deal with it.
> 
> Can we check it -after- the inode has otherwise been validated
> and do the conversion then?

process_inode_{data,attr}_fork compute the correct extent counts and
process_inode_blocks_and_extents writes them into the appropriate fields
in the xfs_dinode structure, so there's no need to convert anything.

This chunk comes before all that, so all we have to do here is set the
DIFLAG2 state as desired.  Zeroing the extent fields was unnecessary.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
