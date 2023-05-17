Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BEF4C77B7A
	for <linux-xfs@archiver.kernel.org>; Wed, 17 May 2023 12:59:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbjEQM7E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 May 2023 08:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbjEQM7E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 May 2023 08:59:04 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C4A7280
        for <linux-xfs@vger.kernel.org>; Wed, 17 May 2023 05:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9fKuJu69e0JXq4VRuNgNX74djt/8bS3g72lzBS2F4k0=; b=JhZvK3OzxptRFufTWLFBsPLP3/
        XvgMVrQfEVx+fwLPoO4NNljDKS0xrVOQ+hREU4xc0+1HVSAmvHEj8KJCObAkSJuWKVbcD3fLfgNrh
        DsVIN9IILsXycoO1BGVr4LdLyrbxJipzX5J8tL2n+fXsQKcSDy5an3EaoheV36Iuc4mClh5FusdPA
        nu+MMMxCYDGojpOu6nvJHaror5IFcgT1PtnHoAXy270o8XFYNyT/mkcnJEmqMo/AGu8W1kmb4rG7v
        iYWkjv04aAys5D3puOOkC0ULKQ7TOb/y7hqo1sZeuNYyPXcv4HFRjrLBppeBYClmgxTqULBYzI/t6
        Dmg8BJHA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pzGk3-009sV6-29;
        Wed, 17 May 2023 12:58:55 +0000
Date:   Wed, 17 May 2023 05:58:55 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: buffer pins need to hold a buffer reference
Message-ID: <ZGTPj0ov+95jjpuH@infradead.org>
References: <20230517000449.3997582-1-david@fromorbit.com>
 <20230517000449.3997582-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517000449.3997582-2-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 17, 2023 at 10:04:46AM +1000, Dave Chinner wrote:
> To fix this, we need to ensure that buffer existence extends beyond
> the BLI reference count checks and until the unpin processing is
> complete. This implies that a buffer pin operation must also take a
> buffer reference to ensure that the buffer cannot be freed until the
> buffer unpin processing is complete.

Yeah.  I wonder why we haven't done this from the very beginning..

> +	 /*
> +	  * Nothing to do but drop the buffer pin reference if the BLI is
> +	  * still active
> +	  */

Nit: this block comment is indentented by an extra space.

> +	if (!freed) {
> +		xfs_buf_rele(bp);
>  		return;
> +	}
>  
>  	if (stale) {

Nit: this is the only use of the stale variable now, so we might
as well just drop it.

>  		ASSERT(bip->bli_flags & XFS_BLI_STALE);

.. which then also clearly shows this ASSERT is pointless now.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
