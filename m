Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B57DC001DF
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Oct 2023 15:20:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377620AbjJTPUd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Oct 2023 11:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377669AbjJTPUd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Oct 2023 11:20:33 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C65118F
        for <linux-xfs@vger.kernel.org>; Fri, 20 Oct 2023 08:20:31 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED6EC433C8;
        Fri, 20 Oct 2023 15:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697815230;
        bh=DLRFOAq1cxx+0dHT5abo/KnXohBRQwq7/NSWrniUsEc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l5jHgKRdRcjtyRv2BUlaJW4YhXhC5Z+b1+d/3h7PrPRAGvjqmQZ9ogpeJvv0wxF+Y
         T+cfEJ3w6Biow9zNdlqq7dgXkDUbJg7PZQ1lBlNRmdFVIqqVx5pD0rBg7K7rR9oYL/
         3IVq1wsJfPpL5hXER/EX4PTVYh5LF7ad5rl/weBDlBhECrR4UI7xGtfPwIB/EiPwrj
         Bj65D2WWsFKoNM9qHsD3nqsehkaIu8rfQ//97vBiOJYy21e3ejWaCeTUEMuaoxpDTK
         jGt9JE+QSIxbt3I+IdeKyOSXurhoyorGDqDWAZE1oxt0X4np21+u6tCjBUeHknW1Bu
         zFZDctA21fEVA==
Date:   Fri, 20 Oct 2023 08:20:30 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, osandov@fb.com
Subject: Re: [PATCH 1/4] xfs: create a helper to handle logging parts of rt
 bitmap/summary blocks
Message-ID: <20231020152030.GP3195650@frogsfrogsfrogs>
References: <169773211338.225711.17480890063747608115.stgit@frogsfrogsfrogs>
 <169773211358.225711.13859802342332594222.stgit@frogsfrogsfrogs>
 <20231020062023.GA13551@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231020062023.GA13551@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 20, 2023 at 08:20:23AM +0200, Christoph Hellwig wrote:
> On Thu, Oct 19, 2023 at 09:27:48AM -0700, Darrick J. Wong wrote:
> > +	size_t			first, last;
> > +
> > +	first = (void *)xfs_rsumblock_infoptr(bp, infoword) - bp->b_addr;
> > +	last = first + sizeof(xfs_suminfo_t) - 1;
> 
> > +	size_t			first, last;
> > +
> > +	first = (void *)xfs_rbmblock_wordptr(bp, from) - bp->b_addr;
> > +	last = ((void *)xfs_rbmblock_wordptr(bp, next) - 1) - bp->b_addr;
> > +
> > +	xfs_trans_log_buf(tp, bp, first, last);
> 
> Going to pointers and back looks a bit confusing and rather inefficient
> to me.  But given how late we are in the cycle I don't want to derail
> your series, so let's keep this as-is for now, and I'll add a TODO
> list item to my ever growing list to eventually lean this up.

<nod> I think this function ultimately becomes:

/* Log rtbitmap block from the word @from to the byte before @next. */
static inline void
xfs_trans_log_rtbitmap(
	struct xfs_rtalloc_args	*args,
	unsigned int		from,
	unsigned int		next)
{
	struct xfs_buf		*bp = args->rbmbp;
	size_t			first = from * sizeof(xfs_rtword_t);
	size_t			last = next * sizeof(xfs_rtword_t) - 1;

	if (xfs_has_rtgroup(args->mp)) {
		first += sizeof(struct xfs_rtbuf_blkinfo);
		last += sizeof(struct xfs_rtbuf_blkinfo);
	}

	xfs_trans_log_buf(args->tp, bp, first, last);
}

I'll go play with the compiler to see what asm it generates.

--D
