Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89B61C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 21:08:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241843AbiEXVIR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 17:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241787AbiEXVIR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 17:08:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A140A3DDF9
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 14:08:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B6D46171F
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 21:08:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99AB2C34100;
        Tue, 24 May 2022 21:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653426494;
        bh=5Krle13STsVzd5lTCrKgFes0SxyVYArenN12j6Y850w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tdgGpSM/XW0kMv4cmHTRB43xi65RNqcxCWitqIvc6XaMGmihjitPpWnipVUhaC8MT
         OIgQn02rYtVOorSbNp/ng4Cy6GGmcmAJtkLWQPcZNYRN9ofJ0DdjXhIBFb7ETfeGP3
         sFzceuE2oiy2xJ1Ddo3iY80m22x7aB9I/jKxO/xfcbvw2joq0XpNUZlBIvn2BhuT83
         leIbi4qDstgBvly7IsPMtzGCJaE0C1OAFTzQpDt3wPrfRH2aXLgOIwUi6sr5Bb+QRg
         HOkxv24ngai3/SxIjjq5GOhDTvPgSoxxLO3r9EN7XBk1g8Z6yVvXaGw2VMyfDlI8ZV
         RDynXq6lX9JwQ==
Date:   Tue, 24 May 2022 14:08:14 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] mkfs: Fix memory leak
Message-ID: <Yo1JPr6yvQGzUNBB@magnolia>
References: <20220524204040.954138-1-preichl@redhat.com>
 <Yo1I5N1IMXdHKUcw@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yo1I5N1IMXdHKUcw@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 24, 2022 at 02:06:44PM -0700, Darrick J. Wong wrote:
> On Tue, May 24, 2022 at 10:40:40PM +0200, Pavel Reichl wrote:
> > 'value' is allocated by strup() in getstr(). It
> 
> Nit: strdup, not strup.
> 
> > needs to be freed as we do not keep any permanent
> > reference to it.
> > 
> > Signed-off-by: Pavel Reichl <preichl@redhat.com>
> 
> With that fixed,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> --D
> 
> > ---
> >  mkfs/xfs_mkfs.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index 01d2e8ca..a37d6848 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -1714,6 +1714,7 @@ naming_opts_parser(
> >  		} else {
> >  			cli->sb_feat.dir_version = getnum(value, opts, subopt);
> >  		}
> > +		free((char *)value);

...well, that, and the ^^^^ cast here isn't necessary.

--D

> >  		break;
> >  	case N_FTYPE:
> >  		cli->sb_feat.dirftype = getnum(value, opts, subopt);
> > -- 
> > 2.36.1
> > 
