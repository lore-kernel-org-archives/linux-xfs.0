Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 257D9C001B0
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Aug 2023 01:09:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbjHHBI7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Aug 2023 21:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbjHHBI6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Aug 2023 21:08:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42DAA198C
        for <linux-xfs@vger.kernel.org>; Mon,  7 Aug 2023 18:08:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC03F6234D
        for <linux-xfs@vger.kernel.org>; Tue,  8 Aug 2023 01:08:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EF14C433C8;
        Tue,  8 Aug 2023 01:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691456936;
        bh=MKlzaTtaBxJMwn7zRxBRGLq9D4aiP6GWTgpmA2gYvrY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=htfxkDIXpx8y5E6rou3uH8GAA/2dyNLlnN7TnqAOjhVEL25AAMLbGs9PAYhA6Xxjn
         S7u8rvfbQdDs5v8GX3LTjGq6cZGQ3nKK0DHI/9R6+hE2YOpQ6eKGKBw/kvYiueSSnm
         SVrd/26B8emsXOaINh3KH6vY+fJ8lo5o0aBPq8NWcVv2bUu3jZMb0oBMjf12mWVlXj
         7+AUwnSrmPgUksaZBblvAOkleS1DiWm7T/j/Q9BgUKZ3/Q1cKGn3bM5lpuHw6kTzdA
         uV3b1zPD2MUn5doKo80GdzYKXy3YzCJ/8w3cEODfHMGGdawLx8YqYx1yxkydff4d1l
         djx00qNg70JZA==
Date:   Mon, 7 Aug 2023 18:08:55 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: implement block reservation accounting for
 btrees we're staging
Message-ID: <20230808010855.GO11352@frogsfrogsfrogs>
References: <169049623167.921279.16448199708156630380.stgit@frogsfrogsfrogs>
 <169049623203.921279.8246035009618084259.stgit@frogsfrogsfrogs>
 <ZNCWKoOnYc++JFTW@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZNCWKoOnYc++JFTW@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 07, 2023 at 04:58:50PM +1000, Dave Chinner wrote:
> On Thu, Jul 27, 2023 at 03:24:16PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Create a new xrep_newbt structure to encapsulate a fake root for
> > creating a staged btree cursor as well as to track all the blocks that
> > we need to reserve in order to build that btree.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> .....
> > +/* Allocate disk space for our new file-based btree. */
> > +STATIC int
> > +xrep_newbt_alloc_file_blocks(
> > +	struct xrep_newbt	*xnr,
> > +	uint64_t		nr_blocks)
> > +{
> > +	struct xfs_scrub	*sc = xnr->sc;
> > +	int			error = 0;
> > +
> > +	while (nr_blocks > 0) {
> > +		struct xfs_alloc_arg	args = {
> > +			.tp		= sc->tp,
> > +			.mp		= sc->mp,
> > +			.oinfo		= xnr->oinfo,
> > +			.minlen		= 1,
> > +			.maxlen		= nr_blocks,
> > +			.prod		= 1,
> > +			.resv		= xnr->resv,
> > +		};
> > +		struct xfs_perag	*pag;
> > +
> > +		xrep_newbt_validate_file_alloc_hint(xnr);
> > +
> > +		error = xfs_alloc_vextent_start_ag(&args, xnr->alloc_hint);
> > +		if (error)
> > +			return error;
> > +		if (args.fsbno == NULLFSBLOCK)
> > +			return -ENOSPC;
> > +
> > +		trace_xrep_newbt_alloc_file_blocks(sc->mp, args.agno,
> > +				args.agbno, args.len, xnr->oinfo.oi_owner);
> > +
> > +		pag = xfs_perag_get(sc->mp, args.agno);
> 
> I don't think we should allow callers to trust args.agno and
> args.agbno after the allocation has completed. The result of the
> allocation is returned in args.fsbno, and there is no guarantee that
> args.agno and args.agbno will be valid at the completion of the
> allocation.
> 
> i.e. we set args.agno and args.agbno internally based on the target
> that is passed to xfs_alloc_vextent_start_ag(), and they change
> internally depending on the iterations being done during allocation.
> IOWs, those two fields are internal allocation state and not
> actually return values that the caller can rely on.
> 
> Hence I think this needs to do:
> 
> 	agno = XFS_FSB_TO_AGNO(mp, args.fsbno);
> 	agbno = XFS_FSB_TO_AGBNO(mp, args.fsbno);
> 
> before using those values.

Ok, fixed.  At some point we ought to double-underscore all the
private(ish) fields in xfs_alloc_args.  I'll also fix
xrep_newbt_alloc_ag_blocks.

> > +
> > +/*
> > + * How many extent freeing items can we attach to a transaction before we want
> > + * to finish the chain so that unreserving new btree blocks doesn't overrun
> > + * the transaction reservation?
> > + */
> > +#define XREP_REAP_MAX_NEWBT_EFIS	(128)
> 
> Should there be a common define for this for repair operations?

I had left them separate, but I don't think there's much of a point
anymore, since the newbt(ree) and reaping code both use tr_itruncate.

/*
 * This is the maximum number of deferred extent freeing item extents
 * (EFIs) that we'll attach to a transaction without rolling the
 * transaction to avoid overrunning a tr_itruncate reservation.
 */
#define XREP_MAX_ITRUNCATE_EFIS	(128)


--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
