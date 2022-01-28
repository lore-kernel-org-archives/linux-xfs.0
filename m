Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67A1FC43217
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Jan 2022 23:04:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235135AbiA1XEH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Jan 2022 18:04:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbiA1XEH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jan 2022 18:04:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72637C061714
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jan 2022 15:04:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CCCD61F12
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jan 2022 23:04:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6382FC340E7;
        Fri, 28 Jan 2022 23:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643411046;
        bh=vsaVzazO36vEpHpFwGysh+ikyUXX4ohOrGzf2DlnnCc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vPFi9CH4Cs04jQKbryIHeQqGgtG3JW4WkGWViKnng4hqiQer4Oegzlhq/CBuoLEja
         ZEsv0ycOkmxAvnQxq6oGmVfobkC6LR4v2hsgQcxdjZwZ1WwZ1ioTFRdZUbA0T3Yy2X
         T3HClTxNKzvMSMHsJcsVNRLnU9/LUR1Y7FzWCz2tMH+GWcuDFMEM8+8VPi/zWXep+e
         RKstkV3HqOm99PKYSvdmvKZbSd0P+Q3E0PD6n4LN0wUbUsqHCUmBwk7dGJuyoqjzhU
         Xhmf8hsXya+zSlb7b4cF9K4yPwCXBKS2PgM+p1PlyAqxeGuMA21qiVn19PV6UpVriL
         EPoIlC3nuvMOQ==
Date:   Fri, 28 Jan 2022 15:04:05 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 42/45] libxfs: replace XFS_BUF_SET_ADDR with a function
Message-ID: <20220128230405.GM13540@magnolia>
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
 <164263807467.860211.13040036268013928337.stgit@magnolia>
 <217c0998-4795-c85c-54cb-45b47ba99ac8@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <217c0998-4795-c85c-54cb-45b47ba99ac8@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 28, 2022 at 02:53:02PM -0600, Eric Sandeen wrote:
> On 1/19/22 6:21 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Replace XFS_BUF_SET_ADDR with a new function that will set the buffer
> > block number correctly, then port the two users to it.
> 
> Ok, this is in preparation for later adding more to the
> function (saying "set it correctly" confused me a little, because
> the function looks equivalent to the macro....)
> 
> ...
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index 63895f28..057b3b09 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -3505,8 +3505,8 @@ alloc_write_buf(
> >   				error);
> >   		exit(1);
> >   	}
> > -	bp->b_bn = daddr;
> > -	bp->b_maps[0].bm_bn = daddr;
> > +
> > +	xfs_buf_set_daddr(bp, daddr);
> 
> This *looks* a little like a functional change, since you dropped
> setting of the bp->b_maps[0].bm_bn. But since we get here with a
> single buffer, not a map of buffers, I ... think that at this point,
> nobody will be looking at b_maps[0].bm_bn anyway?
> 
> But I'm not quite sure. I also notice xfs_get_aghdr_buf() in the kernel
> setting both b_bn and b_maps[0].bm_bn upstream, for similar purposes.
> 
> Can you sanity-check me a little here?

This whole thing is as twisty as a pretzel driving into the mountains.

The end game is that b_bn is actually the cache key for the xfs_buf
structure, so ultimately we don't want anyone accessing it other than
the cache management functions.  Hence we spend the next two patches
kicking everybody off of b_bn and then rename it to b_cache_key.  Anyone
who wants the daddr address of an xfs_buf (cached or uncached) is
supposed to use bp->b_maps[0].bm_bn (or xfs_buf_daddr/xfs_buf_set_daddr)
after that point.

xfs_get_aghdr_buf (in xfs_ag.c) encodes that rather than setting up a
one-liner helper because that's the only place in the kernel where we
call xfs_buf_get_uncached.  By contrast, userspace needs to set a
buffer's daddr(ess) from mkfs and libxlog, so (I guess) that's why the
helper is still useful.

*However* at this point in the game, most people still use b_bn
(incorrectly) so that's probably why alloc_write_buf sets both.

I guess this patch should have replaced only the "b_bn = daddr" part,
and in the next patch removed the "bp->b_maps[0].bm_bn = daddr" line.

After all that, b_bn of the uncached buffer will be NULLDADDR, like it's
supposed to be.

--D

> Thanks,
> -Eric
> 
> >   	return bp;
> >   }
> > 
