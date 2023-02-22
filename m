Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C2C0C636D6
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Feb 2023 16:37:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbjBVQhJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Feb 2023 11:37:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbjBVQhJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Feb 2023 11:37:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DFF532CF5
        for <linux-xfs@vger.kernel.org>; Wed, 22 Feb 2023 08:37:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1FF87B81233
        for <linux-xfs@vger.kernel.org>; Wed, 22 Feb 2023 16:37:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B85C433D2;
        Wed, 22 Feb 2023 16:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677083824;
        bh=9wx9+GXlB5FsTUD1iIxj0flH/BI4QMp58KDs6xY5+Bk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cMSAlWP0OftoQHy58mi+HVpFtXCNE+j2Ol/PGyJXGkEwZfo/8ksNd3mAcXxgfTinH
         QtcM2ww8LdLeAcn8gN1PhpIrv5NOXPmoFKrxSDD/+h2R9TqR9YGYhh+USbYxb9wMwr
         7KRz+KWe9xY/dSKjJwtlJHgvR5Hdl5+aALPIDQZDEBY90LIsL9+Ru182mGulQXRrEA
         Ub5Omnbu+K5RhJlkjkzptLk6QA4Qz196aBXulwx9B96huszq4Rb+jHV6CSHcM5zOz0
         wqAEufCkbMCOgWVcCLoRMYQHLlYrOrIaDo6iFuiLgdH/+NjOqGx6GEpwu7uJ3+LpSm
         UURahKKZuTduQ==
Date:   Wed, 22 Feb 2023 08:37:03 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Carlos Maiolino <cem@kernel.org>
Cc:     linux-xfs@vger.kernel.org, daan.j.demeyer@gmail.com
Subject: Re: [PATCH 5/5] mkfs: substitute slashes with spaces in protofiles
Message-ID: <Y/ZEr72HCRLhiZzk@magnolia>
References: <167658436759.3590000.3700844510708970684.stgit@magnolia>
 <qZxM14CxXi0qImx6yvZqGUGk9ONznMyOXDa_zw1hzM3z5HY0Mlo-VdP5KLv2NxaKEvAe9qQn5RO-qFRMUKciAQ==@protonmail.internalid>
 <167658439591.3590000.1501103007888420501.stgit@magnolia>
 <20230222090303.h6tujm7y32gjhgal@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230222090303.h6tujm7y32gjhgal@andromeda>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 22, 2023 at 10:03:03AM +0100, Carlos Maiolino wrote:
> On Thu, Feb 16, 2023 at 01:53:15PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > A user requested the ability to specify directory entry names in a
> > protofile that have spaces in them.  The protofile format itself does
> > not allow spaces (yay 1973-era protofiles!) but it does allow slashes.
> > Slashes aren't allowed in directory entry names, so we'll permit this
> > one gross hack.
> > 
> > /
> > 0 0
> > d--775 1000 1000
> > : Descending path /code/t/fstests
> >  get/isk.sh   ---775 1000 1000 /code/t/fstests/getdisk.sh
> > $
> > 
> > Will produce "get isk.h" in the root directory.
> > 
> 
> While I don't really mind this patch, it seems strange to me to simply replace a
> slash with a space in lieu of failing the prototype with an 'invalid character'
> error message, or something like that.
> With this patch, an user could be mistakenly assuming the get/isk.sh path will
> be created, and instead, what's gonna be created is a file with a space.
> I don't really mind it, but I think we could be misleading users.

Hmm.  I agree that it /does/ look weird.  I guess we could invent
suboptions for mkfs -p:

   mkfs.xfs -p slashes_are_spaces=1,/tmp/protofile

Which would turn on this odd looking functionalty?  How does that sound?

Sidebar:

As it is now, the slash gets passed to _addname, with the result that
mkfs will error out.

Another thing I (just) remembered is that the proto.c will also pick up
nulls and pass them to addname, so:

   get\000isk.sh ---775 1000 1000 /code/t/fstests/getdisk.sh

will also cause mkfs to fail the format.  I suppose that will also
require patching...

--D

> 
> > Requested-by: Daan De Meyer <daan.j.demeyer@gmail.com>
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  mkfs/proto.c |   23 ++++++++++++++++++++++-
> >  1 file changed, 22 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/mkfs/proto.c b/mkfs/proto.c
> > index 68ecdbf3632..bf8de0189db 100644
> > --- a/mkfs/proto.c
> > +++ b/mkfs/proto.c
> > @@ -171,6 +171,27 @@ getstr(
> >  	return NULL;
> >  }
> > 
> > +/* Extract directory entry name from a protofile. */
> > +static char *
> > +getdirentname(
> > +	char	**pp)
> > +{
> > +	char	*p = getstr(pp);
> > +	char	*c = p;
> > +
> > +	if (!p)
> > +		return NULL;
> > +
> > +	/* Replace slash with space because slashes aren't allowed. */
> > +	while (*c) {
> > +		if (*c == '/')
> > +			*c = ' ';
> > +		c++;
> > +	}
> > +
> > +	return p;
> > +}
> > +
> >  static void
> >  rsvfile(
> >  	xfs_mount_t	*mp,
> > @@ -580,7 +601,7 @@ parseproto(
> >  			rtinit(mp);
> >  		tp = NULL;
> >  		for (;;) {
> > -			name = getstr(pp);
> > +			name = getdirentname(pp);
> >  			if (!name)
> >  				break;
> >  			if (strcmp(name, "$") == 0)
> > 
> 
> -- 
> Carlos Maiolino
