Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C1F3C77B7E
	for <linux-xfs@archiver.kernel.org>; Tue,  2 May 2023 10:49:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbjEBKtv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 May 2023 06:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232598AbjEBKtu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 May 2023 06:49:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBDB02D63
        for <linux-xfs@vger.kernel.org>; Tue,  2 May 2023 03:49:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A28660D27
        for <linux-xfs@vger.kernel.org>; Tue,  2 May 2023 10:49:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F8EC433D2;
        Tue,  2 May 2023 10:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683024588;
        bh=vAAC46JDmEm4/AHuh5GLnOe1fiCZiZdtHPjlFYDdCEU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pvuKVOgDfPqEVfFht8EJbseSeyGDb4O1mxlWj78LuTSKs+OEam/cqJCD1uaSxXjN/
         bTpixJP+7zH8fEtugflK/55V4G/t1B/ElKGH/jvaar0mUcl8sngPqv9Ec2/u45mf+4
         uRds68ahyLLo4g+BQKU5bmmDj8QcysHpMCu8Z4VWPwPiSNW32eoFjFUs8dbHNiPE1u
         qOmE7erw+xFN8CAuJmploUqIk2pU/mu54ggZ5x5JeCr5nrSFkrw9J65PyTvt8tLegY
         c153gNfF5IleS5mu7+XNbm3VgHl6AdADb/3UYocQrqHm8TzFbBpseAOdTSiDxb+PE1
         hT6AwuOpLsQ4g==
Date:   Tue, 2 May 2023 12:49:44 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_repair: estimate per-AG btree slack better
Message-ID: <20230502104944.6rvddejxufsbzj7h@andromeda>
References: <Hmm9qc69j-CLafwLwR_VDVUXW-MimDNdKcP5ObJjM17LI9tD3CdNoGjfMsJyj--ppTa-5tg4DwbNhhnKZyZ1Eg==@protonmail.internalid>
 <20230427224521.GD59213@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230427224521.GD59213@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi.

On Thu, Apr 27, 2023 at 03:45:21PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The slack calculation for per-AG btrees is a bit inaccurate because it
> only disables slack space in the new btrees when the amount of free
> space in the AG (not counting the btrees) is less than 3/32ths of the
> AG.  In other words, it assumes that the btrees will fit in less than 9
> percent of the space.
.
.
.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

This looks fine, with a small caveat below...

.
.
.

> +
> +static xfs_extlen_t
> +estimate_allocbt_blocks(
> +	struct xfs_perag	*pag,
> +	unsigned int		nr_extents)
> +{
> +	return libxfs_allocbt_calc_size(pag->pag_mount, nr_extents) * 2;
> +}

Forgive my ignorance here, but what's the reason of the magic number? It seems
to me by multiplying by 2 here, you are considering a split of every single
leaf for the calculated btree size, but I'm not sure if that's the intention,
could you please confirm or correct me? :)

Other than that, the patch looks good

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

-- 
Carlos Maiolino
