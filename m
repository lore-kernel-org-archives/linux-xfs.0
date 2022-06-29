Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C028C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 22:06:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbiF2WGe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 18:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiF2WGe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 18:06:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C9E275DD
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 15:06:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7B56618BC
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 22:06:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1528DC34114;
        Wed, 29 Jun 2022 22:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656540392;
        bh=IHgKJtVoBGTacKhArs7uw4RI9yONDNVu4Y/vETDl/Rg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aq/dMkNKODrpEZ3ZcvgTcI+9NTAhSIYe7XcsU5O9t8MAV8B5S4FbwMv6c/FWmqh4m
         ntIXCsaihts5BWGCU6qEI/5Yvg6vJIw8BTET9TA9OODmfv9GCVm0m0b6iTPKL+05fm
         W7b1qSDTzs5OHlZQUtRCf0JSTA5mf96qBg/xdNMiGxq2JXKmyXQoFJovgCivuv21cY
         yLL7w0tflkVfJLb3zUDKXEdROdcUUnMUTGgY8fhwRk9n0NbBngGLcjZeZsstyPKOzM
         p0e07BcXz+NexOdjGJYx4pPqp9BJon4DzKo3emdb3qJBXH7VYZ3p6rQKYOli43zbrf
         BAQOBowbhA38w==
Date:   Wed, 29 Jun 2022 15:06:31 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: merge xfs_buf_find() and xfs_buf_get_map()
Message-ID: <YrzM57Xg2LU4pEha@magnolia>
References: <20220627060841.244226-1-david@fromorbit.com>
 <20220627060841.244226-4-david@fromorbit.com>
 <YrwB2JS9oVRh6l0L@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrwB2JS9oVRh6l0L@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 29, 2022 at 12:40:08AM -0700, Christoph Hellwig wrote:
> >  
> > -static inline struct xfs_buf *
> > -xfs_buf_find_fast(
> > -	struct xfs_perag	*pag,
> > -	struct xfs_buf_map	*map)
> > -{
> > -	struct xfs_buf          *bp;
> > -
> > -	bp = rhashtable_lookup(&pag->pag_buf_hash, map, xfs_buf_hash_params);
> > -	if (!bp)
> > -		return NULL;
> > -	atomic_inc(&bp->b_hold);
> > -	return bp;
> > -}
> 
> > -static int
> > -xfs_buf_find_insert(
> > -	struct xfs_buftarg	*btp,
> > -	struct xfs_perag	*pag,
> 
> Adding the function just in the last patch and moving them around
> here and slighty changing seems a little counter productive.
> I think just merging the two might actually end up with a result
> that is easier to review.

I read the second patch and it makes sense, but I'm also curious if
hch's suggestion here would make this change easier to read?

--D
