Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4C39CA0EF1
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Sep 2023 16:23:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbjILQXU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Sep 2023 12:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbjILQXU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Sep 2023 12:23:20 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D544310E5;
        Tue, 12 Sep 2023 09:23:16 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 791E3C433C7;
        Tue, 12 Sep 2023 16:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694535796;
        bh=I5dNEeI6bRHV6GsDxON6Fz8Pg5i4Lyeep+UZ568o5F0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cRtdkrJEf5cqfrpOzj5wgy4/1vxsRBkDll5XJ7lPGE10aQfybVHGp0EzaAR1iHcN+
         hFFWz6roGfyI5dtKbYCQ0I3VCY2hjPY8+l+giguI/uAcaopBw3vpXTLwfMpGYqrfop
         qA/Jg4mZOXBqvj737nk4yLioBsW+QQTLAjossZonretc7ZQTBOVBYW6vlX/9TKAaDm
         /WxrsgTF2fmZCaDR+FofMR0eDh+/fTw9ZObnd38gdLajjhaO31vzdJ1wg+tAksiPON
         XbBAL3QosjxEKltsccNPv46lBuKdrwDAt+LRp7ItFi0dJ8my8GcHeM7AXyVejuFcnt
         L+DHXwH5ndK2Q==
Date:   Tue, 12 Sep 2023 09:23:15 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Alex Elder <elder@ieee.org>
Cc:     Dan Carpenter <dan.carpenter@linaro.org>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Kent Overstreet <kent.overstreet@linux.dev>,
        linux-xfs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] xfs: delete some dead code in xfile_create()
Message-ID: <20230912162315.GC28186@frogsfrogsfrogs>
References: <1429a5db-874d-45f4-8571-7854d15da58d@moroto.mountain>
 <20230912153824.GB28186@frogsfrogsfrogs>
 <e575bbf3-f0ba-ec39-03c5-9165678d1fc7@ieee.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e575bbf3-f0ba-ec39-03c5-9165678d1fc7@ieee.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 12, 2023 at 10:41:53AM -0500, Alex Elder wrote:
> On 9/12/23 10:38 AM, Darrick J. Wong wrote:
> > On Tue, Sep 12, 2023 at 06:18:45PM +0300, Dan Carpenter wrote:
> > > The shmem_file_setup() function can't return NULL so there is no need
> > > to check and doing so is a bit confusing.
> > > 
> > > Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> > > ---
> > > No fixes tag because this is not a bug, just some confusing code.
> > 
> > Please don't re-send patches that have already been presented here.
> > https://lore.kernel.org/linux-xfs/20230824161428.GO11263@frogsfrogsfrogs/
> 
> FWIW, I side with Dan's argument.  shmem_file_setup() *does not*
> return NULL.  If it ever *did* return NULL, it would be up to the
> person who makes that happen to change all callers to check for NULL.

And as I asked three weeks ago, what's the harm in checking for a NULL
pointer here?  The kerneldoc for shmem_file_setup doesn't explicitly
exclude a null return.  True, it doesn't mention the possibility of
ERR_PTR returns either, but that's an accepted practice for pointer
returns.

For a call outside of the xfs subsystem, I think it's prudent to have
stronger return value checking.  Yes, someone changing the interface
would have to add a null check to all the callsites, but (a) it's benign
to guard against a behavior change in another module and (b) people miss
things all the time.

> The current code *suggests* that it could return NULL, which
> is not correct.

Huh?

Are you talking about this stupid behavior of bots where they decide
what a function returns based on the callsites in lieu of analyzing the
actual implementation code?

I don't feel like getting harassed by bots when someone /does/
accidentally change the implementation to return NULL, and now one of
the other build/test/syz bots starts crashing in xfile_create.

Of course all that has bought me is ... more f*** bot harassment.

I'm BURNED OUT, give me a fucking break!

--D

> 					-Alex
> 
> > 
> > --D
> > 
> > >   fs/xfs/scrub/xfile.c | 2 --
> > >   1 file changed, 2 deletions(-)
> > > 
> > > diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
> > > index d98e8e77c684..71779d81cad7 100644
> > > --- a/fs/xfs/scrub/xfile.c
> > > +++ b/fs/xfs/scrub/xfile.c
> > > @@ -70,8 +70,6 @@ xfile_create(
> > >   		return -ENOMEM;
> > >   	xf->file = shmem_file_setup(description, isize, 0);
> > > -	if (!xf->file)
> > > -		goto out_xfile;
> > >   	if (IS_ERR(xf->file)) {
> > >   		error = PTR_ERR(xf->file);
> > >   		goto out_xfile;
> > > -- 
> > > 2.39.2
> > > 
> 
