Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 627DDC3A59F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 07:29:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AA0E208C2
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 07:29:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VchlnaJi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbfH2H35 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 03:29:57 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:41572 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbfH2H35 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 03:29:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=/o0S+flrUCxLJfmLzMcxld2gIePSg5sUlxDPtzJofbA=; b=VchlnaJi0t+uLr3FfQwZKKVnH
        J0i3YSv7/PRoQCblAKzvsf0njdAH7WEYjm5wMKcN7snedSegt92DvMAolyPhdL5u96a1R4u3Drark
        LqOXKV+2ZYAhxihtSZRms2fp2P+cNglAca+D/erXz1tyi88dXIMdQmsAfdVzvSrwHEDJgrnxjeJtX
        psLJJIG+YwnlC+XW2+AI13O/ZBsYK9pYn8EsMmTnZaDGQfiOBcVEwjskr3F9PPjK46NAt5FVeAg1S
        MKHOtKVe+WMuKfY34pN35qBfOveAdZRWJW4LBD+pdtGkcLhqNLhbKpjsj3riLsh0oUvq2Gibbf0Xl
        6jU2cOJfw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i3EsX-0002vM-88; Thu, 29 Aug 2019 07:29:57 +0000
Date:   Thu, 29 Aug 2019 00:29:57 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: reinitialize rm_flags when unpacking an offset
 into an rmap irec
Message-ID: <20190829072957.GF18102@infradead.org>
References: <156685615360.2853674.5160169873645196259.stgit@magnolia>
 <156685618619.2853674.16603505107055424362.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156685618619.2853674.16603505107055424362.stgit@magnolia>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 26, 2019 at 02:49:46PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In xfs_rmap_irec_offset_unpack, we should always clear the contents of
> rm_flags before we begin unpacking the encoded (ondisk) offset into the
> incore rm_offset and incore rm_flags fields.  Remove the open-coded
> field zeroing as this encourages api misuse.

This one doesn't fit the series' theme, does it? :)

> +++ b/fs/xfs/libxfs/xfs_rmap.c
> @@ -168,7 +168,6 @@ xfs_rmap_btrec_to_irec(
>  	union xfs_btree_rec	*rec,
>  	struct xfs_rmap_irec	*irec)
>  {
> -	irec->rm_flags = 0;
>  	irec->rm_startblock = be32_to_cpu(rec->rmap.rm_startblock);
>  	irec->rm_blockcount = be32_to_cpu(rec->rmap.rm_blockcount);
>  	irec->rm_owner = be64_to_cpu(rec->rmap.rm_owner);
> diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
> index 0c2c3cb73429..abe633403fd1 100644
> --- a/fs/xfs/libxfs/xfs_rmap.h
> +++ b/fs/xfs/libxfs/xfs_rmap.h
> @@ -68,6 +68,7 @@ xfs_rmap_irec_offset_unpack(
>  	if (offset & ~(XFS_RMAP_OFF_MASK | XFS_RMAP_OFF_FLAGS))
>  		return -EFSCORRUPTED;
>  	irec->rm_offset = XFS_RMAP_OFF(offset);
> +	irec->rm_flags = 0;

The change looks sensible-ish.  But why do we even have a separate
xfs_rmap_irec_offset_unpack with a single caller nd out of the
way in a header?  Wouldn't it make sense to just merge the two
functions?
