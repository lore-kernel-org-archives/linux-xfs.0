Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BBF4C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jul 2022 01:59:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbiGNB7a (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Jul 2022 21:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiGNB73 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jul 2022 21:59:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAA58186EA
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jul 2022 18:59:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58DE0B8222E
        for <linux-xfs@vger.kernel.org>; Thu, 14 Jul 2022 01:59:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4CDC3411E;
        Thu, 14 Jul 2022 01:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657763964;
        bh=IpmUVJwgdlfKM7pp5qlfQ/H30Be750OzOaJZX9Ag0/U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XftrDuda2KTMBRfHwam3a2jVXSlFTto6/6KCGb0CDVdWZI7bNsOM0I5/6S62quuKg
         lNyXHqy0V3ajTKyXUyYc/n7TsYrChOfNUghn5666P1M5bS/DcBy/FUEYnk5p7n9Ed7
         km9AgeTpH926Qk6/dfes6LkeqdiqHpAj+WEVxyyLbQd3NFrfk4vIDAoyoZ/qS6jSxi
         I8Jw2b5Tjhxd1e2Re+zMDqFjCciy3u/3Rbe+MBxJvmgZ+IArMJ90ugo/okYN6QQVyu
         MvbBsRQLW3nwBN6LEh3hZ35wsn78V4vQRoQyTMLfeYWJvJCqFWrk0cSeBUtiruL05H
         46ArD5kFBGH4w==
Date:   Wed, 13 Jul 2022 18:59:24 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] mkfs: terminate getsubopt arrays properly
Message-ID: <Ys94fFgxLGyGb/W4@magnolia>
References: <165767457703.891854.2108521135190969641.stgit@magnolia>
 <165767459958.891854.15344618102582353193.stgit@magnolia>
 <2a452d57-9e2e-7908-b3f5-0444b6a62761@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a452d57-9e2e-7908-b3f5-0444b6a62761@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 13, 2022 at 08:39:24PM -0500, Eric Sandeen wrote:
> On 7/12/22 8:09 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Having not drank any (or maybe too much) coffee this morning, I typed:
> > 
> > $ mkfs.xfs -d agcount=3 -d nrext64=0
> > Segmentation fault
> > 
> > I traced this down to getsubopt walking off the end of the dopts.subopts
> > array.  The manpage says you're supposed to terminate the suboptions
> 
> (the getsubopt(3) manpage for those following along at home)
> 
> > string array with a NULL entry, but the structure definition uses
> > MAX_SUBOPTS/D_MAX_OPTS directly, which means there is no terminator.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  mkfs/xfs_mkfs.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > 
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index 61ac1a4a..9a58ff8b 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -141,7 +141,7 @@ enum {
> >  };
> >  
> >  /* Just define the max options array size manually right now */
> > -#define MAX_SUBOPTS	D_MAX_OPTS
> > +#define MAX_SUBOPTS	(D_MAX_OPTS + 1)
> 
> Hah, I had not noticed this before. So this relies on there being more
> suboptions for -d than anything else, I guess. What could go wrong?
> 
> OK, so this fixes it because opt_params is a global, and it contains 
> subopt_params[MAX_SUBOPTS];, so the last array entry will be null
> (by virtue of globals being zeroed) and that's all perfectly clear :D

<nod>

> Well, it fixes it for now.  I'd like to add i.e.
> 
> @@ -251,6 +251,7 @@ static struct opt_params bopts = {
>         .ini_section = "block",
>         .subopts = {
>                 [B_SIZE] = "size",
> +               [B_MAX_OPTS] = NULL,
>         },
> 
> etc to each suboption array to be explicit about it, sound ok? I can do
> that on commit if it seems ok.

Oh, that /is/ a good idea, in case B_MAX_OPTS > D_MAX_OPTS ever happens.

--D

> Reviewed-by: Eric Sandeen <sandeen@sandeen.net>
> 
> Thanks,
> -Eric
> 
> >  
> >  #define SUBOPT_NEEDS_VAL	(-1LL)
> >  #define MAX_CONFLICTS	8
> > 
