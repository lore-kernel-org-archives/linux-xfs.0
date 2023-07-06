Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B94DFEB64D9
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Jul 2023 23:51:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbjGFXvV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Jul 2023 19:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbjGFXvT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Jul 2023 19:51:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F3A10E2
        for <linux-xfs@vger.kernel.org>; Thu,  6 Jul 2023 16:51:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FFC3614B7
        for <linux-xfs@vger.kernel.org>; Thu,  6 Jul 2023 23:51:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9222C433C8;
        Thu,  6 Jul 2023 23:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688687477;
        bh=TBKtrtlwvv7fh+mtpOpSsLF5kYQT7eOwWemWUUq7exc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NX5F/G9QSqL5nQ8tq+7jlHbeYpIe1DOE00UXRrY1Q46zc6lCT52U5PkPyytNlVgJc
         h6TK4anSMrOwKtqy4pUk2z4daYjtKOQOSKqa7H33Z+nyiDxKTHySLEwiOIdHicXNGz
         AXw6bwVXfebsDDl/9gxz7tN6ir05lrVLF4hZRojXi22J1eUrfOwr08peP8S92j+dRo
         4fviyAKupO5fF/7+tvd8twUQHa04dzpC0eH+eLWJnPP4qj9457RtbyIZUR+9+vBt+1
         vFreoSe9kIY+ZDtM0tfV/LqxxWq1XT7z9rnLu3D+X5wxH1Ra8nRDp39azx5Nr188+K
         SPWm+mRjo+iew==
Date:   Thu, 6 Jul 2023 16:51:17 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix uninit warning in xfs_growfs_data
Message-ID: <20230706235117.GA11456@frogsfrogsfrogs>
References: <20230706022630.GA11476@frogsfrogsfrogs>
 <ZKdGEmx7T4fw4S7E@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZKdGEmx7T4fw4S7E@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 07, 2023 at 08:54:10AM +1000, Dave Chinner wrote:
> On Wed, Jul 05, 2023 at 07:26:30PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Quiet down this gcc warning:
> > 
> > fs/xfs/xfs_fsops.c: In function ‘xfs_growfs_data’:
> > fs/xfs/xfs_fsops.c:219:21: error: ‘lastag_extended’ may be used uninitialized in this function [-Werror=maybe-uninitialized]
> >   219 |                 if (lastag_extended) {
> >       |                     ^~~~~~~~~~~~~~~
> > fs/xfs/xfs_fsops.c:100:33: note: ‘lastag_extended’ was declared here
> >   100 |         bool                    lastag_extended;
> >       |                                 ^~~~~~~~~~~~~~~
> > 
> > By setting its value explicitly.  From code analysis I don't think this
> > is a real problem, but I have better things to do than analyse this
> > closely.
> 
> Huh. What compiler is complaining about that?

gcc 11.3, though oddly this only happens when I turn on gcov.  Not sure
what sorcery gets enabled with that, but it got in the way of teaching
the fstests cloud to spit out 60MB(!) of coverage reports for each
fstests run, and the source code fix seemed obvious.

> 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_fsops.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > index 65473bc52c7d..96edc87bf030 100644
> > --- a/fs/xfs/xfs_fsops.c
> > +++ b/fs/xfs/xfs_fsops.c
> > @@ -97,7 +97,7 @@ xfs_growfs_data_private(
> >  	xfs_agnumber_t		nagimax = 0;
> >  	xfs_rfsblock_t		nb, nb_div, nb_mod;
> >  	int64_t			delta;
> > -	bool			lastag_extended;
> > +	bool			lastag_extended = false;
> >  	xfs_agnumber_t		oagcount;
> >  	struct xfs_trans	*tp;
> >  	struct aghdr_init_data	id = {};
> 
> Looks good,
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Thanks!

--D

> Dave Chinner
> david@fromorbit.com
