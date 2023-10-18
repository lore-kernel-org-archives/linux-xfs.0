Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE04ACDB47E
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Oct 2023 16:33:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbjJRQdS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Oct 2023 12:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjJRQdR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Oct 2023 12:33:17 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7738F98
        for <linux-xfs@vger.kernel.org>; Wed, 18 Oct 2023 09:33:16 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A579C433C7;
        Wed, 18 Oct 2023 16:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697646796;
        bh=Cz23l4YTvmSg0nLNgxqn8N5iUGdlSF76+keFu8JhoIg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OIBzPIEbegpDvYI+kO86QG/w5xOPW6W36bsvVrlODyRmmlHCVAnTxi/svCjPRNUHY
         FlXJnT0bzm++9LQyMBzbXBaqKTMrxG+aatJOhXJI1T4UAOpIxhrbveEI7j4hC7IYeG
         ZBVgB1uPBiqyFNxg0/4Qj/bg5OUSRhtq+5y0DsFI2a3UGoINatLgxmwImWHOjrfX1v
         8EhrYuIrRPN9ChScnecJKEviCIytscFaYeUxlzu04HRwGTi0647B1/wR/51UYyCx5P
         tBedV5w5Tvvygkk302Tk2CXl5SgGPqQxcHP/yYKNL/E7Dw2P7+rLVlfaGawp7FG6z7
         xaEbYPuNb70iQ==
Date:   Wed, 18 Oct 2023 09:33:15 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Omar Sandoval <osandov@fb.com>, osandov@osandov.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs: cache last bitmap block in realtime allocator
Message-ID: <20231018163315.GH3195650@frogsfrogsfrogs>
References: <169755742570.3167911.7092954680401838151.stgit@frogsfrogsfrogs>
 <169755742610.3167911.17327120267300651170.stgit@frogsfrogsfrogs>
 <20231018061911.GB17687@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231018061911.GB17687@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 18, 2023 at 08:19:11AM +0200, Christoph Hellwig wrote:
> On Tue, Oct 17, 2023 at 08:54:23AM -0700, Darrick J. Wong wrote:
> >   * The buffer is returned read and locked.
> > @@ -59,12 +73,32 @@ xfs_rtbuf_get(
> >  	struct xfs_buf		**bpp)		/* output: buffer for the block */
> >  {
> >  	struct xfs_mount	*mp = args->mount;
> > +	struct xfs_buf		**cbpp;		/* cached block buffer */
> > +	xfs_fsblock_t		*cbp;		/* cached block number */
> >  	struct xfs_buf		*bp;		/* block buffer, result */
> >  	struct xfs_inode	*ip;		/* bitmap or summary inode */
> >  	struct xfs_bmbt_irec	map;
> >  	int			nmap = 1;
> >  	int			error;		/* error value */
> >  
> > +	cbpp = issum ? &args->bbuf : &args->sbuf;
> > +	cbp = issum ? &args->bblock : &args->sblock;
> 
> Now that we have the summary/bitmap buffers in the args structure,
> it seems like we can also drop the bp argument from xfs_rtbuf_get and
> just the pointer in the args structue in the callers.

Yeah, I was wondering about that too -- either we take a second refcount
on @bp and pass it out via **bpp, or callers can pluck it from @args
directly and call _cache_relse before @args goes out of scope.

I'll remove **bpp since it's redundant.

--D
