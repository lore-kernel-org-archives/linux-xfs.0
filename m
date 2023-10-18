Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DC1DCDB47E
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Oct 2023 06:16:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbjJRGQz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Oct 2023 02:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjJRGQy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Oct 2023 02:16:54 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5D7AC4
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 23:16:52 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id EE05B67373; Wed, 18 Oct 2023 08:16:48 +0200 (CEST)
Date:   Wed, 18 Oct 2023 08:16:48 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <dchinner@redhat.com>, osandov@fb.com,
        osandov@osandov.com, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/7] xfs: consolidate realtime allocation arguments
Message-ID: <20231018061648.GA17687@lst.de>
References: <169755742570.3167911.7092954680401838151.stgit@frogsfrogsfrogs> <169755742594.3167911.2655847193439153279.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169755742594.3167911.2655847193439153279.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 17, 2023 at 08:54:08AM -0700, Darrick J. Wong wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Consolidate the arguments passed around the rt allocator into a
> struct xfs_rtalloc_arg similar to how the btree allocator arguments
> are consolidated in a struct xfs_alloc_arg....

Overall this looks good to me, but a few cosmetic comments:

> +	struct xfs_rtalloc_args	*args,
> +	xfs_fileoff_t		block,		/* block number in bitmap or summary */
> +	int			issum,		/* is summary not bitmap */
> +	struct xfs_buf		**bpp)		/* output: buffer for the block */

we should either also document the new args argument, or drop all the
other argument comments like we've done in many places.  If we want
to keep them it would be good to do the trivial reformatting so that
they don't extend over the 80 character readability limit.

> +	struct xfs_mount	*mp = args->mount;

mount is a bit of an odd name for the member.  We usuall calls this
mp in most structures like our normal variable name (with tp->t_mountp
as one notable odd exception).

> +	error = xfs_trans_read_buf(mp, args->trans, mp->m_ddev_targp,
>  				   XFS_FSB_TO_DADDR(mp, map.br_startblock),
>  				   mp->m_bsize, 0, &bp, &xfs_rtbuf_ops);

->trans has some precedence in the dir/attr code, but I think tp
would still be more logical.

