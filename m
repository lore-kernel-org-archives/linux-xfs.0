Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57AC7C77B73
	for <linux-xfs@archiver.kernel.org>; Tue,  2 May 2023 15:38:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbjEBPiU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 May 2023 11:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234389AbjEBPiT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 May 2023 11:38:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8EA7F1
        for <linux-xfs@vger.kernel.org>; Tue,  2 May 2023 08:38:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 742AE6196E
        for <linux-xfs@vger.kernel.org>; Tue,  2 May 2023 15:38:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F21C4339C;
        Tue,  2 May 2023 15:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683041896;
        bh=J3WUa0YjORDaBPzoYx5DY73+Oy/E14bVdRBYIJ55OKE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vIjPezhEZ3d5wHyxtSv5AstEOfODjvXlR4W/2g1UhmEyXZ+8tNGYnJKG8ppBWmZmo
         BSHk7x4xW5zZkw9fAuFd32vYyVNMb3w5EYPfJxjQ+GB50z+xo3IlCij7d+264XiuUC
         ljfs4Zk1k9EPsGZy4ugpgo9c0t9A4B67se8Ao5V+y33TBoMJRmE9ON22NITnlWJuAn
         /N54OWoMX6FbsxW3ti2BZkIDmD5t4x3VxFwxP5MvHHriaCRMOswTAj8RFK8+HV4Ms8
         bI+/WLNW41OsV1xV07GZ/0gSiXi9kUXR1/aRePGqaSshAucmJe8s4gZT5KKCQRDIyr
         Smy1tT7XPg6/w==
Date:   Tue, 2 May 2023 08:38:16 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Carlos Maiolino <cem@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_repair: estimate per-AG btree slack better
Message-ID: <20230502153816.GA15420@frogsfrogsfrogs>
References: <Hmm9qc69j-CLafwLwR_VDVUXW-MimDNdKcP5ObJjM17LI9tD3CdNoGjfMsJyj--ppTa-5tg4DwbNhhnKZyZ1Eg==@protonmail.internalid>
 <20230427224521.GD59213@frogsfrogsfrogs>
 <20230502104944.6rvddejxufsbzj7h@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230502104944.6rvddejxufsbzj7h@andromeda>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 02, 2023 at 12:49:44PM +0200, Carlos Maiolino wrote:
> Hi.
> 
> On Thu, Apr 27, 2023 at 03:45:21PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > The slack calculation for per-AG btrees is a bit inaccurate because it
> > only disables slack space in the new btrees when the amount of free
> > space in the AG (not counting the btrees) is less than 3/32ths of the
> > AG.  In other words, it assumes that the btrees will fit in less than 9
> > percent of the space.
> .
> .
> .
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> 
> This looks fine, with a small caveat below...
> 
> .
> .
> .
> 
> > +
> > +static xfs_extlen_t
> > +estimate_allocbt_blocks(
> > +	struct xfs_perag	*pag,
> > +	unsigned int		nr_extents)
> > +{
> > +	return libxfs_allocbt_calc_size(pag->pag_mount, nr_extents) * 2;
> > +}
> 
> Forgive my ignorance here, but what's the reason of the magic number? It seems
> to me by multiplying by 2 here, you are considering a split of every single
> leaf for the calculated btree size, but I'm not sure if that's the intention,
> could you please confirm or correct me? :)

Ah, I should document that better...

	/* Account for space consumed by both free space btrees */
	return libxfs_allocbt_calc_size(...) * 2;

--D

> Other than that, the patch looks good
> 
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> 
> -- 
> Carlos Maiolino
