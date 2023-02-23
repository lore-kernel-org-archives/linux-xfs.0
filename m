Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AF45C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Feb 2023 08:48:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbjBWIsr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Feb 2023 03:48:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbjBWIsq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Feb 2023 03:48:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B56C37F1C
        for <linux-xfs@vger.kernel.org>; Thu, 23 Feb 2023 00:48:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DEC516160B
        for <linux-xfs@vger.kernel.org>; Thu, 23 Feb 2023 08:48:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756DBC433EF;
        Thu, 23 Feb 2023 08:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677142124;
        bh=aP1KbMcT9H4CVuWONM1GmXTQ1SbKJlACVAGRY26GjFk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h3XZ0hslagABixci2LLKpDIlahffgneTAC0zqP9DohKXKCh0rB31RTf4y3QiKbs+a
         qFYbKKdUv48jBU9yhuKBGLjTEihV4qUy5JlA70WSnhOmeF8PV4gL61ZS+nql3oFAcq
         6qbe4vMLntlZm81l1fnsV1RrFOZVaeLeygpzcZDScLCobC5cyx1FI/CIOvXzfjq6uT
         qIsCnSuaM1wOigrbMox4NfVVfUdjBBaitELRwNrDiFSwjRD2fzFtNhL/cR2MPdSlG/
         knlK+nzP8dsmo5aqEByyBHzqTVxjPDXvKo4f3As6OdUnhAOrUWu910eWcUWTj2TDWR
         KbAHXLi8u7KmQ==
Date:   Thu, 23 Feb 2023 09:48:39 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, daan.j.demeyer@gmail.com
Subject: Re: [PATCH 5/5] mkfs: substitute slashes with spaces in protofiles
Message-ID: <20230223084839.4en5f5qmufr2stqd@andromeda>
References: <167658436759.3590000.3700844510708970684.stgit@magnolia>
 <qZxM14CxXi0qImx6yvZqGUGk9ONznMyOXDa_zw1hzM3z5HY0Mlo-VdP5KLv2NxaKEvAe9qQn5RO-qFRMUKciAQ==@protonmail.internalid>
 <167658439591.3590000.1501103007888420501.stgit@magnolia>
 <20230222090303.h6tujm7y32gjhgal@andromeda>
 <xT4Q3iGa3wPZq1leXZhx9MvrhOi2AMmVRTY4p7esqyh1kpvl_q7al8GaS4gzwBiV0iAOiGCNoxA5pyYb1G8ojQ==@protonmail.internalid>
 <Y/ZEr72HCRLhiZzk@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/ZEr72HCRLhiZzk@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 22, 2023 at 08:37:03AM -0800, Darrick J. Wong wrote:
> On Wed, Feb 22, 2023 at 10:03:03AM +0100, Carlos Maiolino wrote:
> > On Thu, Feb 16, 2023 at 01:53:15PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > >
> > > A user requested the ability to specify directory entry names in a
> > > protofile that have spaces in them.  The protofile format itself does
> > > not allow spaces (yay 1973-era protofiles!) but it does allow slashes.
> > > Slashes aren't allowed in directory entry names, so we'll permit this
> > > one gross hack.
> > >
> > > /
> > > 0 0
> > > d--775 1000 1000
> > > : Descending path /code/t/fstests
> > >  get/isk.sh   ---775 1000 1000 /code/t/fstests/getdisk.sh
> > > $
> > >
> > > Will produce "get isk.h" in the root directory.
> > >
> >
> > While I don't really mind this patch, it seems strange to me to simply replace a
> > slash with a space in lieu of failing the prototype with an 'invalid character'
> > error message, or something like that.
> > With this patch, an user could be mistakenly assuming the get/isk.sh path will
> > be created, and instead, what's gonna be created is a file with a space.
> > I don't really mind it, but I think we could be misleading users.
> 
> Hmm.  I agree that it /does/ look weird.  I guess we could invent
> suboptions for mkfs -p:

Sorry, I don't mean to give you more trouble, but silently replacing a character
by another one does indeed looks weird to me.

> 
>    mkfs.xfs -p slashes_are_spaces=1,/tmp/protofile


> 
> Which would turn on this odd looking functionalty?  How does that sound?

this sounds better to me :)

> 
> Sidebar:
> 
> As it is now, the slash gets passed to _addname, with the result that
> mkfs will error out.
> 
> Another thing I (just) remembered is that the proto.c will also pick up
> nulls and pass them to addname, so:
> 
>    get\000isk.sh ---775 1000 1000 /code/t/fstests/getdisk.sh
> 
> will also cause mkfs to fail the format.  I suppose that will also
> require patching...

Interesting.
/me never played much with protofiles

I'll pickup the first 4 patches of this series tomorrow and skip this one for
now. I plan to release a 6.2 soon, as we already have linux 6.2 release, but I
want to do a libxfs sync first, hopefully I'll have the bandwidth tomorrow and
next week release 6.2. will see :)


> 
> >
> > > Requested-by: Daan De Meyer <daan.j.demeyer@gmail.com>
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  mkfs/proto.c |   23 ++++++++++++++++++++++-
> > >  1 file changed, 22 insertions(+), 1 deletion(-)
> > >
> > >
> > > diff --git a/mkfs/proto.c b/mkfs/proto.c
> > > index 68ecdbf3632..bf8de0189db 100644
> > > --- a/mkfs/proto.c
> > > +++ b/mkfs/proto.c
> > > @@ -171,6 +171,27 @@ getstr(
> > >  	return NULL;
> > >  }
> > >
> > > +/* Extract directory entry name from a protofile. */
> > > +static char *
> > > +getdirentname(
> > > +	char	**pp)
> > > +{
> > > +	char	*p = getstr(pp);
> > > +	char	*c = p;
> > > +
> > > +	if (!p)
> > > +		return NULL;
> > > +
> > > +	/* Replace slash with space because slashes aren't allowed. */
> > > +	while (*c) {
> > > +		if (*c == '/')
> > > +			*c = ' ';
> > > +		c++;
> > > +	}
> > > +
> > > +	return p;
> > > +}
> > > +
> > >  static void
> > >  rsvfile(
> > >  	xfs_mount_t	*mp,
> > > @@ -580,7 +601,7 @@ parseproto(
> > >  			rtinit(mp);
> > >  		tp = NULL;
> > >  		for (;;) {
> > > -			name = getstr(pp);
> > > +			name = getdirentname(pp);
> > >  			if (!name)
> > >  				break;
> > >  			if (strcmp(name, "$") == 0)
> > >
> >
> > --
> > Carlos Maiolino

-- 
Carlos Maiolino
