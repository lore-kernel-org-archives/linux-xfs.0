Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F694C43334
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 22:58:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbiF1W6j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 18:58:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232036AbiF1W6i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 18:58:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3E01B797
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 15:58:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BE6561AE3
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 22:58:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2450C341C8;
        Tue, 28 Jun 2022 22:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656457115;
        bh=5xUEwSM6umaJzP4/Sgvupu4ayOswq7oJ3F8wGi+vLTs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J1rIL+abqD5SQ4IT1DJIv4WjAcPePuVvQaKa84DD58LEJDfYdhj48Jhn2z8JI6STI
         VAi/zKrtMbo5WeygVef9fUJlOLAOFd8PmMZHRDSEb/qOy4SChA4vPFcZ9vjmrK5JdH
         lfjH9HyiK2UGChrgdejsCj0osXEUPXORIuT6tlFhGI4FibUiEfYMagACq0H9JTeZfG
         7QgJWReeIYmCsGIbAIsjFGdMkYyVAkrvFSKHlMFwgZzQ0oJyI3MHd212W6duyWB/aP
         N1fcm+PUX/wKaTKvrq5KyaEGuKSjxeU+RTrFThp/GJlXfWDF3TF6mzQg2NhHshR2gD
         DT5hhla1tHZnw==
Date:   Tue, 28 Jun 2022 15:58:35 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>,
        Anthony Iliopoulos <ailiop@suse.com>
Subject: Re: [PATCH] xfs_restore: remove DMAPI support
Message-ID: <YruHmxNhAwX/p7H5@magnolia>
References: <20220203174540.GT8313@magnolia>
 <8eafb32b-10ab-b5eb-d80a-571bf803c832@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8eafb32b-10ab-b5eb-d80a-571bf803c832@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 10, 2022 at 04:46:13PM -0600, Eric Sandeen wrote:
> On 2/3/22 11:45 AM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > The last of the DMAPI stubs were removed from Linux 5.17, so drop this
> > functionality altogether.
> 
> Why is this better than letting it EINVAL/ENOTTY/ENOWHATEVER when the
> ioctl gets called?

5.17 removed the ioctl definitions, so xfsdump won't build anymore.

> Though I don't really care, so I will go ahead and
> review it. :)
> 
> At this point I suppose finally pulling in Anthony's
> 	xfsdump: remove BMV_IF_NO_DMAPI_READ flag
> would make sense as well.

Yes.

> 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  doc/xfsdump.html  |    1 -
> >  po/de.po          |    5 ---
> >  po/pl.po          |    5 ---
> >  restore/content.c |   99 +++--------------------------------------------------
> >  restore/tree.c    |   33 ------------------
> >  restore/tree.h    |    1 -
> >  6 files changed, 6 insertions(+), 138 deletions(-)
> > 
> 
> ...
> 
> > diff --git a/restore/content.c b/restore/content.c
> > index 6b22965..e9b0a07 100644
> > --- a/restore/content.c
> > +++ b/restore/content.c
> > @@ -477,9 +477,6 @@ struct pers {
> >  			/* how many pages following the header page are reserved
> >  			 * for the subtree descriptors
> >  			 */
> > -		bool_t restoredmpr;
> > -			/* restore DMAPI event settings
> > -			 */
> >  		bool_t restoreextattrpr;
> >  			/* restore extended attributes
> >  			 */
> > @@ -858,7 +855,6 @@ static void partial_reg(ix_t d_index, xfs_ino_t ino, off64_t fsize,
> >                          off64_t offset, off64_t sz);
> >  static bool_t partial_check (xfs_ino_t ino, off64_t fsize);
> >  static bool_t partial_check2 (partial_rest_t *isptr, off64_t fsize);
> > -static int do_fssetdm_by_handle(char *path, fsdmidata_t *fdmp);
> 
> with fsdmidata_t completely gone I think its typedef can go too?
MProbably.


> ...
> 
> > @@ -8796,19 +8748,6 @@ restore_extattr(drive_t *drivep,
> >  			}
> >  		} else if (isfilerestored && path[0] != '\0') {
> >  			setextattr(path, ahdrp);
> 
> Pretty sure there's a hunk in setextattr that could go too, right?
> 
> @@ -8840,20 +8779,16 @@ restore_dir_extattr_cb_cb(extattrhdr_t *ahdrp, void *ctxp)
>  static void
>  setextattr(char *path, extattrhdr_t *ahdrp)
>  {
> -       static  char dmiattr[] = "SGI_DMI_";
>         bool_t isrootpr = ahdrp->ah_flags & EXTATTRHDR_FLAGS_ROOT;
>         bool_t issecurepr = ahdrp->ah_flags & EXTATTRHDR_FLAGS_SECURE;
> -       bool_t isdmpr;
>         int attr_namespace;
>         int rval;
>  
> -       isdmpr = (isrootpr &&
> -                  !strncmp((char *)(&ahdrp[1]), dmiattr, sizeof(dmiattr)-1));
>  
>         /* If restoreextattrpr not set, then we are here because -D was
>          * specified. So return unless it looks like a root DMAPI attribute.
>          */
> -       if (!persp->a.restoreextattrpr && !isdmpr)
> +       if (!persp->a.restoreextattrpr)
>                 return;

Er... yes?  Looks right, but xfsdump is enough of a mess... :/

> 
> > -
> > -			if (persp->a.dstdirisxfspr && persp->a.restoredmpr) {
> > -				int flag = 0;
> > -				char *attrname = (char *)&ahdrp[1];
> > -				if (ahdrp->ah_flags & EXTATTRHDR_FLAGS_ROOT)
> > -					flag = ATTR_ROOT;
> > -				else if (ahdrp->ah_flags & EXTATTRHDR_FLAGS_SECURE)
> > -					flag = ATTR_SECURE;
> > -
> > -				HsmRestoreAttribute(flag,
> > -						     attrname,
> > -						     &strctxp->sc_hsmflags);
> 
> And with the only user of strctxp gone it's now an unused local var, I think.

I don't do words that lack  ^^^^^^^ vowels.

> Anyway....
> 
> I wonder if there's still more that could be ripped out:
> 
>         uint32_t        bs_dmevmask;    /* DMI event mask        4    6c */
>         uint16_t        bs_dmstate;     /* DMI state info        2    6e */
> 
> Those can't go, I guess, because they are part of the header in the on-disk format.
> 
> But why are we still fiddling with them? For that matter, why does hsmapi.c still
> exist at all?

It probably can go too.

> I have the sense that if we really want to remove all dmapi support there's further
> to go, but as with all things xfsdump, it scares me a bit ...

<nod>

--D

> -Eric
> 
