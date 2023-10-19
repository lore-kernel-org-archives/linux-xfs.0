Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9133CDB47E
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Oct 2023 00:00:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjJSAAd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Oct 2023 20:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232099AbjJSAAc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Oct 2023 20:00:32 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04E4126
        for <linux-xfs@vger.kernel.org>; Wed, 18 Oct 2023 17:00:29 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A7DEC433C8;
        Thu, 19 Oct 2023 00:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697673629;
        bh=eF73IBXO4CCD5OUKhYMkfXIEYqpKt3h8jjqPcmlM/r0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bdkLQi7qY48A11e/3Wc8Ykj9No9PnbiIFN0Ch4pgY3/324pgXvkh+xWs2WL1P+0IN
         y4ovu5ValFjqklkg19y+XkC1gtbZN3CdtxcGlkjPdNbxeciwRivlbFICm/MZRZXv+u
         6wb3v+bZwsuzr3Dz7RUjQgQ3Kl2slkxUERM9wu07rzKH/Q/7lrB6TlO/omEBgzRT1K
         ypqaoAVDNT/O9Y8j5Y90t1GD9OWLW/Rfvqrrz+GvOL8vruVtSiSuhhGv2Unf/UxoLe
         scgNBNPvI4ufNOih/3yfCPdYxAqbkPttsHqR0SrhXbZ3pYaZI7nnyQ4zQ1FrNj70dj
         SxbzRaqNpL1bA==
Date:   Wed, 18 Oct 2023 17:00:28 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Omar Sandoval <osandov@fb.com>, osandov@osandov.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs: cache last bitmap block in realtime allocator
Message-ID: <20231019000028.GL3195650@frogsfrogsfrogs>
References: <169755742570.3167911.7092954680401838151.stgit@frogsfrogsfrogs>
 <169755742610.3167911.17327120267300651170.stgit@frogsfrogsfrogs>
 <20231018061911.GB17687@lst.de>
 <20231018163315.GH3195650@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231018163315.GH3195650@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 18, 2023 at 09:33:15AM -0700, Darrick J. Wong wrote:
> On Wed, Oct 18, 2023 at 08:19:11AM +0200, Christoph Hellwig wrote:
> > On Tue, Oct 17, 2023 at 08:54:23AM -0700, Darrick J. Wong wrote:
> > >   * The buffer is returned read and locked.
> > > @@ -59,12 +73,32 @@ xfs_rtbuf_get(
> > >  	struct xfs_buf		**bpp)		/* output: buffer for the block */
> > >  {
> > >  	struct xfs_mount	*mp = args->mount;
> > > +	struct xfs_buf		**cbpp;		/* cached block buffer */
> > > +	xfs_fsblock_t		*cbp;		/* cached block number */
> > >  	struct xfs_buf		*bp;		/* block buffer, result */
> > >  	struct xfs_inode	*ip;		/* bitmap or summary inode */
> > >  	struct xfs_bmbt_irec	map;
> > >  	int			nmap = 1;
> > >  	int			error;		/* error value */
> > >  
> > > +	cbpp = issum ? &args->bbuf : &args->sbuf;
> > > +	cbp = issum ? &args->bblock : &args->sblock;
> > 
> > Now that we have the summary/bitmap buffers in the args structure,
> > it seems like we can also drop the bp argument from xfs_rtbuf_get and
> > just the pointer in the args structue in the callers.
> 
> Yeah, I was wondering about that too -- either we take a second refcount
> on @bp and pass it out via **bpp, or callers can pluck it from @args
> directly and call _cache_relse before @args goes out of scope.
> 
> I'll remove **bpp since it's redundant.

Ok, I'm about to send out a v2.2 of Omar's patches with whitespace
cleanups for Dave's suggestionpatch:

 xfs: consolidate realtime allocation arguments

I also added a couple new patches to do the cleanups we talked about
here:

 xfs: simplify xfs_rtbuf_get calling conventions
 xfs: simplify rt bitmap/summary block accessor functions

--D

> --D
