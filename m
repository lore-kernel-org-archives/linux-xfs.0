Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A016EEE6452
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Sep 2023 10:31:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231671AbjIOKbs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Sep 2023 06:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232582AbjIOKbr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Sep 2023 06:31:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73EC558C5
        for <linux-xfs@vger.kernel.org>; Fri, 15 Sep 2023 03:29:13 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4FDC433C7;
        Fri, 15 Sep 2023 10:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694773711;
        bh=H6+52H8antvpYr0c8QUvyinPizOkdGcjXUVGWoRo4FU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DYyt9c3KfemJXjw5BLiodiLCm/tSUPC6hkA7rog9c+cJ7aD2dt5i8vbekU4xVMgW6
         u2oiYTwJB/F+2Lbn6ZjkFgCKBOJQQg4jaTeZDhHYE/9tvdff8Vo7/iMPS5oTUtdful
         tv9WK0hgfPGtEjHmrsrNUwC9hZ1Q2AX9jcMV1My1wKnqcEyMnd5KQv/5OZlkk07f1V
         q+qxNpHw/ZmMu3Hs1pVdIAb9X5rQezf+LIDDj34ilYxiluGd6yEaI9YfeJN+zYvDIY
         HRWwgqUVYMQ6Et8C+6hN3vh2pC1WJwJnU76q4jpLmBB9A7VO0TAZNIqfc8GhfQR75i
         5C+EEU2GAVOnw==
Date:   Fri, 15 Sep 2023 12:28:27 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] mkfs: Improve warning when AG size is a multiple of
 stripe width
Message-ID: <20230915102827.y33r7ddgojmms3u5@andromeda>
References: <20230914123640.79682-1-cem@kernel.org>
 <9aQSH3GUWUySra6DmlHXD11f1Zwy3U3Wx9hLcSqUIvvBbAMmJistOfF-robOKFurJBoEK9mEbiJqydr7TwAvLw==@protonmail.internalid>
 <ZQN+5/2Ajc+/UtjW@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZQN+5/2Ajc+/UtjW@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 15, 2023 at 07:45:11AM +1000, Dave Chinner wrote:
> On Thu, Sep 14, 2023 at 02:36:40PM +0200, cem@kernel.org wrote:
> > From: Carlos Maiolino <cmaiolino@redhat.com>
> >
> > The current output message prints out a suggestion of an AG size to be
> > used in lieu of the user-defined one.
> > The problem is this suggestion is printed in filesystem blocks, while
> > agsize= option receives a size in bytes (or m, g).
> 
> Hmmm. The actual definition of the parameter in mkfs.xfs has
> ".convert = true", which means it will take a value in filesystem
> blocks by appending "b" to the number.
> 
> i.e. anything that is defined as a "value" with that supports a
> suffix like "m" or "g" requires conversion via cvtnum() to turn it
> into a byte-based units will also support suffixes for block and
> sector size units.
> 
> Hence "-d agsize=10000b" will make an AG of 10000 filesystem blocks
> in size, or 40000kB in size if the block size 4kB....

Hah, I actually didn't realize the b suffix, knowing that now, I believe
we can just replace the message by:

"for example: agsize=%llub\n")".

I'd rather have it printed in FSblocks other than bytes anyway, giving the size
of the final number. I just opted for bytes originally, to avoid adding more
code just for calculating the representation on a bigger unit.

I'll send a V2.

Carlos

> 
> # mkfs.xfs -f -dagsize=100000b /dev/vdb
> meta-data=/dev/vdb               isize=512    agcount=42, agsize=100000 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>          =                       reflink=1    bigtime=1 inobtcount=1 nrext64=0
> data     =                       bsize=4096   blocks=4194304, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=16384, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> Discarding blocks...Done.
> #
> 
> > This patch tries to make user's life easier by outputing the suggesting
> > in bytes directly.
> >
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> >  mkfs/xfs_mkfs.c | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> >
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index d3a15cf44..827d5b656 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -3179,9 +3179,11 @@ _("agsize rounded to %lld, sunit = %d\n"),
> >  		if (cli_opt_set(&dopts, D_AGCOUNT) ||
> >  		    cli_opt_set(&dopts, D_AGSIZE)) {
> >  			printf(_(
> > -"Warning: AG size is a multiple of stripe width.  This can cause performance\n\
> > -problems by aligning all AGs on the same disk.  To avoid this, run mkfs with\n\
> > -an AG size that is one stripe unit smaller or larger, for example %llu.\n"),
> > +"Warning: AG size is a multiple of stripe width. This can cause performance\n\
> > +problems by aligning all AGs on the same disk. To avoid this, run mkfs with\n\
> > +an AG size that is one stripe unit smaller or larger,\n\
> > +for example: agsize=%llu (%llu blks).\n"),
> > +				(unsigned long long)((cfg->agsize - dsunit) * cfg->blocksize),
> >  				(unsigned long long)cfg->agsize - dsunit);
> >  			fflush(stdout);
> >  			goto validate;
> 
> I have no problem with the change, though I think the man page needs
> updating to remove the "takes a value in bytes" because it has taken
> a value that supports all the suffix types the man page defines
> for quite a long time....
> 
> Cheers,
> 
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
