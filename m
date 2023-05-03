Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 064BAC7EE22
	for <linux-xfs@archiver.kernel.org>; Wed,  3 May 2023 15:07:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbjECPHJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 May 2023 11:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbjECPHG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 May 2023 11:07:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 441164C15
        for <linux-xfs@vger.kernel.org>; Wed,  3 May 2023 08:07:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D36D762DB6
        for <linux-xfs@vger.kernel.org>; Wed,  3 May 2023 15:07:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36DEDC4339B;
        Wed,  3 May 2023 15:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683126424;
        bh=mWXp+D/iPnFtUx8I4E4MXl588HG0Yy8Uq1GMI91egXc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EtS5qhg0uUr6FbTKMQwM6cwCULtPZ7HZHJO1+BAVPtMpGZQmn1a2sPOjT7p+t7Dco
         X5FCrsFOdcgi7xIiJmrCq1i8gEIDmQ2qVMouKOZGN8iATSvnrokvZI7W9nGSDNYaa7
         dqQZQII6/IiSY5QtcdmX3T8uDuAUjV9pHAcyTW+xpZjsGZJ+NFjat0LNyXCsmJCc++
         Epc6NxZU3GFrZac19IhOH4C0nh9PNN0HZXQji8bVP8/E1Z8BhCMZLo0jx+QEuHkRMr
         EHvdW4VdJw5byik2ib9pUab8x2QLxbxa/gZ9yZZovpFkldBP9zXErQ1pyHPLyZrBNa
         WJo379kVEz/gw==
Date:   Wed, 3 May 2023 08:07:03 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Carlos Maiolino <cem@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_repair: estimate per-AG btree slack better
Message-ID: <20230503150703.GH15420@frogsfrogsfrogs>
References: <Hmm9qc69j-CLafwLwR_VDVUXW-MimDNdKcP5ObJjM17LI9tD3CdNoGjfMsJyj--ppTa-5tg4DwbNhhnKZyZ1Eg==@protonmail.internalid>
 <20230427224521.GD59213@frogsfrogsfrogs>
 <20230502104944.6rvddejxufsbzj7h@andromeda>
 <2g_v1BllDEJ95otHQqrnAFoE0bIG2Tdn6wClo-zv3TeyJWg1OlQBMai24BJJodsVirrxnlcs3ZikrlOhhtytcQ==@protonmail.internalid>
 <20230502153816.GA15420@frogsfrogsfrogs>
 <20230503084832.bjoxa2rbtydapgj7@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230503084832.bjoxa2rbtydapgj7@andromeda>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 03, 2023 at 10:48:32AM +0200, Carlos Maiolino wrote:
> On Tue, May 02, 2023 at 08:38:16AM -0700, Darrick J. Wong wrote:
> > On Tue, May 02, 2023 at 12:49:44PM +0200, Carlos Maiolino wrote:
> > > Hi.
> > >
> > > On Thu, Apr 27, 2023 at 03:45:21PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > >
> > > > The slack calculation for per-AG btrees is a bit inaccurate because it
> > > > only disables slack space in the new btrees when the amount of free
> > > > space in the AG (not counting the btrees) is less than 3/32ths of the
> > > > AG.  In other words, it assumes that the btrees will fit in less than 9
> > > > percent of the space.
> > > .
> > > .
> > > .
> > > >
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > >
> > > This looks fine, with a small caveat below...
> > >
> > > .
> > > .
> > > .
> > >
> > > > +
> > > > +static xfs_extlen_t
> > > > +estimate_allocbt_blocks(
> > > > +	struct xfs_perag	*pag,
> > > > +	unsigned int		nr_extents)
> > > > +{
> > > > +	return libxfs_allocbt_calc_size(pag->pag_mount, nr_extents) * 2;
> > > > +}
> > >
> > > Forgive my ignorance here, but what's the reason of the magic number? It seems
> > > to me by multiplying by 2 here, you are considering a split of every single
> > > leaf for the calculated btree size, but I'm not sure if that's the intention,
> > > could you please confirm or correct me? :)
> > 
> > Ah, I should document that better...
> > 
> > 	/* Account for space consumed by both free space btrees */
> > 	return libxfs_allocbt_calc_size(...) * 2;
> 
> Thanks, can I update your patch with the above comment, or do you want to send
> it again?

You can add it, if that'll save time.  I don't have any other changes
pending for that patch.

--D

> > 
> > --D
> > 
> > > Other than that, the patch looks good
> > >
> > > Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> > >
> > > --
> > > Carlos Maiolino
> 
> -- 
> Carlos Maiolino
