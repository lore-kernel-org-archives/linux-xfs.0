Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C130C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 20:02:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbiF2UCX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 16:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbiF2UCU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 16:02:20 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 789FC3ED08
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 13:02:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CC920CE28E9
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 20:02:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC9EDC34114;
        Wed, 29 Jun 2022 20:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656532935;
        bh=F2T1h+n29TfanYYikrz6KMF8SEgLXps9aLZMAVCHfjc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kgqbfSRHG2j+O4TLLEzGeg+tkLRLHPpnLUMhr3GuKzFC+04rMRh9B4vpbOwgmpV3j
         5dDkN+FTz1E7R6NXhMT81NTAIy8546rZEmxc8AXG89UfREf7cQkVk4ioP4OnwYDwqb
         gTec5+b7Mlje8QJd0l4qy1AJIqBErmFN/GwmK8pI9dxNGXV2ZTajv3sOxPq7DpHb1u
         YpBCkKi5C7qkZm+spujF9TvAV/3Yk+J2xaJ28XIhjrWi1C1FbV2+iKLPWdjKaNrs/F
         uTr8S3ZzfzQQXhajsBdvylOM2BClaI9GgIOV/fPe3cLRAJwr9o6T6ECQbQf2oottmy
         hJXxzR3PDF3Ow==
Date:   Wed, 29 Jun 2022 13:02:15 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs: double link the unlinked inode list
Message-ID: <Yryvx5v4G8xXqEPy@magnolia>
References: <20220627004336.217366-1-david@fromorbit.com>
 <20220627004336.217366-6-david@fromorbit.com>
 <Yrv9VVaHT8WnHts3@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yrv9VVaHT8WnHts3@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 29, 2022 at 12:20:53AM -0700, Christoph Hellwig wrote:
> > --- a/fs/xfs/xfs_inode.h
> > +++ b/fs/xfs/xfs_inode.h
> > @@ -70,6 +70,7 @@ typedef struct xfs_inode {
> >  
> >  	/* unlinked list pointers */
> >  	xfs_agino_t		i_next_unlinked;
> > +	xfs_agino_t		i_prev_unlinked;
> 
> Ok, this somewhat invalidates my previous comment, unless we find
> another hole in the xfs_inode layout.

I think there's a 4-byte hole after i_df, and there's about to be
another one after i_af once I send my series to make the attr ifork a
permanent part of the inode.

--D
