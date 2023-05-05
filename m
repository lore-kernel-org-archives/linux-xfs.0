Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16170C77B75
	for <linux-xfs@archiver.kernel.org>; Fri,  5 May 2023 14:02:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232553AbjEEOCi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 May 2023 10:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232052AbjEEOCh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 May 2023 10:02:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B493C11B4A
        for <linux-xfs@vger.kernel.org>; Fri,  5 May 2023 07:02:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 462E463E03
        for <linux-xfs@vger.kernel.org>; Fri,  5 May 2023 14:02:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA15BC433D2;
        Fri,  5 May 2023 14:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683295355;
        bh=ceByraTWcz6thfGXj1vAhB7evvvHDvcEzsWqNtzXKh0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RXocKcDvBkXsELgFEu/sqMTF86eBqsnOZQ2Igs6Jz62nSeYZyHZz6L/sToq6TGzMC
         Q3HlwbJBsrEqfczW/FIUB1Lm4kz+Ar+sfFGagJ7ix+otrcH4AdgJ6joesk7MvGvyFq
         5VKKaW+53sAzGGncvi4AjeDBY9bLDj+baqtn9qEpSVdq1k80eU7ot4EcHfY2LQWKND
         V/bYWnh+2gkS/ork6A/5Ibgf8s6Zyb7yq6DsFzR2TE7TegQkRVVa0F3eJt2OuTwFQT
         tKKfvmRqapn0S/na+XDXnW7hNqjMVfF+zM2J6/+2abOtZdlHuhCdTxjvy5F/fLWn7R
         eJKp4BE7bhWHA==
Date:   Fri, 5 May 2023 16:02:31 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_repair: estimate per-AG btree slack better
Message-ID: <20230505140231.v37vpbsvbbs6ootv@andromeda>
References: <Hmm9qc69j-CLafwLwR_VDVUXW-MimDNdKcP5ObJjM17LI9tD3CdNoGjfMsJyj--ppTa-5tg4DwbNhhnKZyZ1Eg==@protonmail.internalid>
 <20230427224521.GD59213@frogsfrogsfrogs>
 <20230502104944.6rvddejxufsbzj7h@andromeda>
 <2g_v1BllDEJ95otHQqrnAFoE0bIG2Tdn6wClo-zv3TeyJWg1OlQBMai24BJJodsVirrxnlcs3ZikrlOhhtytcQ==@protonmail.internalid>
 <20230502153816.GA15420@frogsfrogsfrogs>
 <20230503084832.bjoxa2rbtydapgj7@andromeda>
 <4mb3kI_n1PqQfNqE1ugk1NKVRFGi9JvDotbJ81JZW-bw58cSjd-xIGjEOvMq07dBRkXrui0-Y_Wl4nCmGisbYw==@protonmail.internalid>
 <20230503150703.GH15420@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230503150703.GH15420@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 03, 2023 at 08:07:03AM -0700, Darrick J. Wong wrote:
> On Wed, May 03, 2023 at 10:48:32AM +0200, Carlos Maiolino wrote:
> > On Tue, May 02, 2023 at 08:38:16AM -0700, Darrick J. Wong wrote:
> > > On Tue, May 02, 2023 at 12:49:44PM +0200, Carlos Maiolino wrote:
> > > > Hi.
> > > >
> > > > On Thu, Apr 27, 2023 at 03:45:21PM -0700, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > >
> > > > > The slack calculation for per-AG btrees is a bit inaccurate because it
> > > > > only disables slack space in the new btrees when the amount of free
> > > > > space in the AG (not counting the btrees) is less than 3/32ths of the
> > > > > AG.  In other words, it assumes that the btrees will fit in less than 9
> > > > > percent of the space.
> > > > .
> > > > .
> > > > .
> > > > >
> > > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > >
> > > > This looks fine, with a small caveat below...
> > > >
> > > > .
> > > > .
> > > > .
> > > >
> > > > > +
> > > > > +static xfs_extlen_t
> > > > > +estimate_allocbt_blocks(
> > > > > +	struct xfs_perag	*pag,
> > > > > +	unsigned int		nr_extents)
> > > > > +{
> > > > > +	return libxfs_allocbt_calc_size(pag->pag_mount, nr_extents) * 2;
> > > > > +}
> > > >
> > > > Forgive my ignorance here, but what's the reason of the magic number? It seems
> > > > to me by multiplying by 2 here, you are considering a split of every single
> > > > leaf for the calculated btree size, but I'm not sure if that's the intention,
> > > > could you please confirm or correct me? :)
> > >
> > > Ah, I should document that better...
> > >
> > > 	/* Account for space consumed by both free space btrees */
> > > 	return libxfs_allocbt_calc_size(...) * 2;
> >
> > Thanks, can I update your patch with the above comment, or do you want to send
> > it again?
> 
> You can add it, if that'll save time.  I don't have any other changes
> pending for that patch.

Ok, won't take much of my time and will prevent you to need to send it again.

> 
> --D
> 
> > >
> > > --D
> > >
> > > > Other than that, the patch looks good
> > > >
> > > > Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> > > >
> > > > --
> > > > Carlos Maiolino
> >
> > --
> > Carlos Maiolino

-- 
Carlos Maiolino
