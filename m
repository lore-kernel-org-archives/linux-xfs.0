Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9B2DCDB46E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 17:31:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344133AbjJLRbu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 13:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344075AbjJLRbt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 13:31:49 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 070E2ED
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2023 10:31:48 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52829C433C8;
        Thu, 12 Oct 2023 17:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697131907;
        bh=t/AyZHhJm4iq2GhRiX36agNXNAYj/WBaEjEJ0y008gQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UUpQQ47SvF5oiFHxyrcQ4cyST5CleZLY0wamiAu96tpnLuNDbKmZZniLahP+/RhhO
         p9aRlw3VFbz8ODog5JiK+l6okLw5KIZQVp++030FZU6veXGrgYdq8ooKbvxT9Qm8Xm
         +32BDFJfhsds/N243g90JbU/q5pGV5h1CFwGHh6VAmlrHOAqkOF5EFQFMHjRrOWqaz
         CeLtkhlzXOcINI5fIRIXTLQVKfM/xD/fQwnkZwPZNE/Sd8fQ1QD775bfzSYPinFThg
         IoSbnnzUaMSe14zg5sLIo1wlPlSxSJcOG+QwmMJF+kb8BB+nB5Y0PDtY9O7K1Kauow
         P4MmhZbecFp1w==
Date:   Thu, 12 Oct 2023 10:31:46 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com
Subject: Re: [PATCH 1/7] xfs: make sure maxlen is still congruent with prod
 when rounding down
Message-ID: <20231012173146.GD214073@frogsfrogsfrogs>
References: <169704720721.1773388.10798471315209727198.stgit@frogsfrogsfrogs>
 <169704720745.1773388.12417746971476890450.stgit@frogsfrogsfrogs>
 <20231012045954.GD1637@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231012045954.GD1637@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 12, 2023 at 06:59:54AM +0200, Christoph Hellwig wrote:
> On Wed, Oct 11, 2023 at 11:02:50AM -0700, Darrick J. Wong wrote:
> > Fix the problem by reducing maxlen by any misalignment with prod.  While
> > we're at it, split the assertions into two so that we can tell which
> > value had the bad alignment.
> 
> Yay, I always hate it when I trigger these compund asserts..
> 
> >  		maxlen = min(mp->m_sb.sb_rextents, i + maxlen) - i;
> > +		maxlen -= maxlen % prod;
> 
> >  	maxlen = min(mp->m_sb.sb_rextents, bno + maxlen) - bno;
> > +	maxlen -= maxlen % prod;
> 
> Not sure if that's bikeshedding, but this almost asks for a little
> helper with a comment.

How about:

/*
 * Make sure we don't run off the end of the rt volume.  Be careful that
 * adjusting maxlen downwards doesn't cause us to fail the alignment checks.
 */
static inline xfs_extlen_t
xfs_rtallocate_clamp_len(
	struct xfs_mount	*mp,
	xfs_rtblock_t		startrtx,
	xfs_extlen_t		rtxlen,
	xfs_extlen_t		prod)
{
	xfs_extlen_t		ret;

	ret = min(mp->m_sb.sb_rextents, startrtx + rtxlen) - startrtx;
	return rounddown(ret, prod);
}

	minlen = xfs_rtallocate_clamp_len(mp, i, maxlen, prod);

and

	minlen = xfs_rtalloc_clamp_len(mp, bno, maxlen, prod);

--D

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
