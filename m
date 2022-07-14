Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FE3AC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jul 2022 02:03:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbiGNCDX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Jul 2022 22:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbiGNCDW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jul 2022 22:03:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48CA237C0
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jul 2022 19:03:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4660761D65
        for <linux-xfs@vger.kernel.org>; Thu, 14 Jul 2022 02:03:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B2BEC34114;
        Thu, 14 Jul 2022 02:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657764200;
        bh=E0mU8ppXxUyCGGCMirwAMWd6ejeq+WHWNNRmkTOcQZQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=djMhDX8s4o6ceNp0fZZQVVFCZYx4+Bs9/LTcqGyDMKB0EcvsP7uCRtIo1hgeMThDq
         yryILhm1lQNuqJhpwWQ9YAU/ZIRClv/ENmFtG7SOHR5VfAJ+57Cy8rn3Ckgzw3XryR
         S/qydPfqcO9L14blPAuRkm9TToqzDCXYmKf7Ih6HVDqVksiEWfuep95l5mvkkT85aQ
         1k5vDSAfd3QoR4sGx5q2T2VuXmWHMAvgTmvvpe9aMhIuf5i2SDh7qy3PZX9mwtL/FE
         t4QOVjjZZ3mlfAT0f90IyuwJxrjboUOnjtCud+ZyM1fgNO0gKrMdYrhKYpabRdwH8A
         ByrICZm84EEpw==
Date:   Wed, 13 Jul 2022 19:03:20 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] mkfs: complain about impossible log size constraints
Message-ID: <Ys95aIUPgQpryAeL@magnolia>
References: <165767457703.891854.2108521135190969641.stgit@magnolia>
 <165767459394.891854.2338822152912053034.stgit@magnolia>
 <ce55b1b4-53a2-a620-a2f8-d601fd48bfa9@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce55b1b4-53a2-a620-a2f8-d601fd48bfa9@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 13, 2022 at 08:17:22PM -0500, Eric Sandeen wrote:
> On 7/12/22 8:09 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > xfs/042 trips over an impossible fs geometry when nrext64 is enabled.
> > The minimum log size calculation comes out to 4287 blocks, but the mkfs
> > parameters specify an AG size of 4096 blocks.  This eventually causes
> > mkfs to complain that the autoselected log size doesn't meet the minimum
> > size, but we could be a little more explicit in pointing out that the
> > two size constraints make for an impossible geometry.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  mkfs/xfs_mkfs.c |    7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > 
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index db322b3a..61ac1a4a 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -3401,6 +3401,13 @@ _("external log device size %lld blocks too small, must be at least %lld blocks\
> >  	 * an AG.
> >  	 */
> >  	max_logblocks = libxfs_alloc_ag_max_usable(mp) - 1;
> > +	if (max_logblocks < min_logblocks) {
> > +		fprintf(stderr,
> > +_("max log size %d smaller than min log size %d\n"),
> 
> And when the user sees this, they will know that they should ___________ ?

I dunno, ask for creating a bigger filesystem?

It's better than "log size 4083 blocks too small, minimum size is 4287
blocks", which hides the part where we autoselected 4083 blocks because
that's max_logblocks.

/me would suggest pulling in the no tiny fs patch, which will at least
fail the cases where the user wants tiny AGs but the featureset wants a
big log with "your fs is too small".

I haven't gotten around to playing with raid stripe size variations yet
though, so I don't know if this problem will come back with (say) a 301M
filesystem and a giant RAID stripe.

--D

> > +				max_logblocks,
> > +				min_logblocks);
> > +		usage();
> > +	}
> >  
> >  	/* internal log - if no size specified, calculate automatically */
> >  	if (!cfg->logblocks) {
> > 
