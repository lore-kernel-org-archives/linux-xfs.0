Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1919CDB47E
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Oct 2023 06:22:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235137AbjJRGWT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Oct 2023 02:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235142AbjJRGWH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Oct 2023 02:22:07 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E33EB324D
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 23:19:15 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id CA09F68AFE; Wed, 18 Oct 2023 08:19:11 +0200 (CEST)
Date:   Wed, 18 Oct 2023 08:19:11 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Omar Sandoval <osandov@fb.com>, Christoph Hellwig <hch@lst.de>,
        osandov@osandov.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs: cache last bitmap block in realtime allocator
Message-ID: <20231018061911.GB17687@lst.de>
References: <169755742570.3167911.7092954680401838151.stgit@frogsfrogsfrogs> <169755742610.3167911.17327120267300651170.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169755742610.3167911.17327120267300651170.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 17, 2023 at 08:54:23AM -0700, Darrick J. Wong wrote:
>   * The buffer is returned read and locked.
> @@ -59,12 +73,32 @@ xfs_rtbuf_get(
>  	struct xfs_buf		**bpp)		/* output: buffer for the block */
>  {
>  	struct xfs_mount	*mp = args->mount;
> +	struct xfs_buf		**cbpp;		/* cached block buffer */
> +	xfs_fsblock_t		*cbp;		/* cached block number */
>  	struct xfs_buf		*bp;		/* block buffer, result */
>  	struct xfs_inode	*ip;		/* bitmap or summary inode */
>  	struct xfs_bmbt_irec	map;
>  	int			nmap = 1;
>  	int			error;		/* error value */
>  
> +	cbpp = issum ? &args->bbuf : &args->sbuf;
> +	cbp = issum ? &args->bblock : &args->sblock;

Now that we have the summary/bitmap buffers in the args structure,
it seems like we can also drop the bp argument from xfs_rtbuf_get and
just the pointer in the args structue in the callers.

