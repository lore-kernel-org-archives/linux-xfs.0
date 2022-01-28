Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ACA9C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Jan 2022 22:03:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241928AbiA1WD1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Jan 2022 17:03:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiA1WD1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jan 2022 17:03:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B673C061714
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jan 2022 14:03:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE00861EDF
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jan 2022 22:03:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26DFFC340E8;
        Fri, 28 Jan 2022 22:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643407406;
        bh=kJYGbHyqe6ECe9FWfPDPbeV1QXkcaVLW/L3rb8mS5nU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hicoIthw/PtOIGZ4w0asD78I5XPq5VC9tQ01VqdpKKfQkhNkW8K/2bfPgEYjzE7tv
         nqa3Mb44H4P+g1sZkzmlLy48BDZ+gs85h1idh1HnN6uE7bgcIpUajBkNCprrmQ1YnU
         4xnCL/89NOISoyLuHCaXpie5a8K7MrEBsgcgQKiqt8DnLbfli4/FzCOXZKdD4ntGjo
         7T5C99N3MkOARPJzdmg5sh7MDjk2r/9r/9aLxZUwODiuT/wlrs+TKr0TEJTYMtgt88
         Vj2WsKChnjc882QnQ4DGhECGG4MVq2nwbY6wFPIqhW0RNG1NWvaD9YadCOIom+Tcrm
         npiyUO1Aw0gJw==
Date:   Fri, 28 Jan 2022 14:03:25 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 41/45] libxfs: always initialize internal buffer map
Message-ID: <20220128220325.GH13540@magnolia>
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
 <164263806915.860211.11553766371419430734.stgit@magnolia>
 <b9f69740-0671-ab4d-a4c7-4fd158f1cab8@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9f69740-0671-ab4d-a4c7-4fd158f1cab8@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 28, 2022 at 02:31:11PM -0600, Eric Sandeen wrote:
> On 1/19/22 6:21 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > The __initbuf function is responsible for initializing the fields of an
> > xfs_buf.  Buffers are always required to have a mapping, though in the
> > typical case there's only one mapping, so we can use the internal one.
> > 
> > The single-mapping b_maps init code at the end of the function doesn't
> > quite get this right though -- if a single-mapping buffer in the cache
> > was allowed to expire and now is being repurposed, it'll come out with
> > b_maps == &__b_map, in which case we incorrectly skip initializing the
> > map.
> 
> In this case b_nmaps must already be 1, right. And it's the bn and
> length in b_maps[0] that fail to be initialized?
> 
> I wonder, then, if it's any more clear to reorganize it just a little bit,
> like:
> 
>         if (!bp->b_maps) {
>                 bp->b_maps = &bp->__b_map;
>                 bp->b_nmaps = 1;
>         }
> 
>         if (bp->b_maps == &bp->__b_map) {
>                 bp->b_maps[0].bm_bn = bp->b_bn;
>                 bp->b_maps[0].bm_len = bp->b_length;
>         }
> 
> because AFAICT b_nmaps only needs to be reset to 1 if we didn't already
> get here with b_maps == &__b_map?

That would also work, though it's less obvious (to me anyway) that
b_nmaps is always 1 when bp->b_maps == &bp->__b_map.

--D

> If this is just navel-gazing I can leave it as is. If you think it's
> any clearer, I'll make the change. (or if I've gotten it completely wrong,
> sorry!)
> 
> Thanks,
> -Eric
> 
> > This has gone unnoticed until now because (AFAICT) the code paths
> > that use b_maps are the same ones that are called with multi-mapping
> > buffers, which are initialized correctly.
> > 
> > Anyway, the improperly initialized single-mappings will cause problems
> > in upcoming patches where we turn b_bn into the cache key and require
> > the use of b_maps[0].bm_bn for the buffer LBA.  Fix this.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >   libxfs/rdwr.c |    6 ++++--
> >   1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> > index 5086bdbc..a55e3a79 100644
> > --- a/libxfs/rdwr.c
> > +++ b/libxfs/rdwr.c
> > @@ -251,9 +251,11 @@ __initbuf(struct xfs_buf *bp, struct xfs_buftarg *btp, xfs_daddr_t bno,
> >   	bp->b_ops = NULL;
> >   	INIT_LIST_HEAD(&bp->b_li_list);
> > -	if (!bp->b_maps) {
> > -		bp->b_nmaps = 1;
> > +	if (!bp->b_maps)
> >   		bp->b_maps = &bp->__b_map;
> > +
> > +	if (bp->b_maps == &bp->__b_map) {
> > +		bp->b_nmaps = 1;
> >   		bp->b_maps[0].bm_bn = bp->b_bn;
> >   		bp->b_maps[0].bm_len = bp->b_length;
> >   	}
> > 
