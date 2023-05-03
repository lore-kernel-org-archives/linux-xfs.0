Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C7F5C77B75
	for <linux-xfs@archiver.kernel.org>; Wed,  3 May 2023 08:48:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbjECIsn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 May 2023 04:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjECIsm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 May 2023 04:48:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE16E44A3
        for <linux-xfs@vger.kernel.org>; Wed,  3 May 2023 01:48:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79E4F627CC
        for <linux-xfs@vger.kernel.org>; Wed,  3 May 2023 08:48:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CDA8C433EF;
        Wed,  3 May 2023 08:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683103716;
        bh=i3uVo4Q6j/TeKtllJkA5AyUyR9RFnOTVJknzYzT2qnU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S0FN+cfEEFuJie1u8eC6rVcZx39v9b+UGoOMGHvKGN4Yk3sZRh4Q0h3gnhQYNq22q
         kibpAjAyThkZv8Z837t6ewrxjlqw8UyvCAjCYadRcRPvZrCIyRhY+oEAIgtbxRV9uA
         AbdLgI79ZgDs4CgnrLiK5Z1a/gVhqUvT7sALox83tAvigFpBypKKV4Xn950gTS2Muk
         sxURa5jSqaCCI3Stb1+iSRYBnGT0tYIQigY8T8Ae6l12JY7eeRw12wQUQB6S8nXFYE
         Jy/TEFo2cObV3OJGwRzu0lAbgxHpaXw+YHe/Lc/Uz79M3NuLzNEbsdH4JHHygKtR9S
         LfwdrlkvM3jgQ==
Date:   Wed, 3 May 2023 10:48:32 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_repair: estimate per-AG btree slack better
Message-ID: <20230503084832.bjoxa2rbtydapgj7@andromeda>
References: <Hmm9qc69j-CLafwLwR_VDVUXW-MimDNdKcP5ObJjM17LI9tD3CdNoGjfMsJyj--ppTa-5tg4DwbNhhnKZyZ1Eg==@protonmail.internalid>
 <20230427224521.GD59213@frogsfrogsfrogs>
 <20230502104944.6rvddejxufsbzj7h@andromeda>
 <2g_v1BllDEJ95otHQqrnAFoE0bIG2Tdn6wClo-zv3TeyJWg1OlQBMai24BJJodsVirrxnlcs3ZikrlOhhtytcQ==@protonmail.internalid>
 <20230502153816.GA15420@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230502153816.GA15420@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 02, 2023 at 08:38:16AM -0700, Darrick J. Wong wrote:
> On Tue, May 02, 2023 at 12:49:44PM +0200, Carlos Maiolino wrote:
> > Hi.
> >
> > On Thu, Apr 27, 2023 at 03:45:21PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > >
> > > The slack calculation for per-AG btrees is a bit inaccurate because it
> > > only disables slack space in the new btrees when the amount of free
> > > space in the AG (not counting the btrees) is less than 3/32ths of the
> > > AG.  In other words, it assumes that the btrees will fit in less than 9
> > > percent of the space.
> > .
> > .
> > .
> > >
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> >
> > This looks fine, with a small caveat below...
> >
> > .
> > .
> > .
> >
> > > +
> > > +static xfs_extlen_t
> > > +estimate_allocbt_blocks(
> > > +	struct xfs_perag	*pag,
> > > +	unsigned int		nr_extents)
> > > +{
> > > +	return libxfs_allocbt_calc_size(pag->pag_mount, nr_extents) * 2;
> > > +}
> >
> > Forgive my ignorance here, but what's the reason of the magic number? It seems
> > to me by multiplying by 2 here, you are considering a split of every single
> > leaf for the calculated btree size, but I'm not sure if that's the intention,
> > could you please confirm or correct me? :)
> 
> Ah, I should document that better...
> 
> 	/* Account for space consumed by both free space btrees */
> 	return libxfs_allocbt_calc_size(...) * 2;

Thanks, can I update your patch with the above comment, or do you want to send
it again?

> 
> --D
> 
> > Other than that, the patch looks good
> >
> > Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> >
> > --
> > Carlos Maiolino

-- 
Carlos Maiolino
