Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36D85C07545
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Oct 2023 11:43:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbjJXLnL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Oct 2023 07:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjJXLnK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Oct 2023 07:43:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE02D68;
        Tue, 24 Oct 2023 04:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=z5InAU3dhYmLQJgjZgQwPjcxPbv7IHwMP+7wG4gigZ0=; b=UgQerN9XarNuuQe0jfv3B7kfni
        wI9Sgck27dnIA2Rg6K3xZYaN+65+8jLyJHMgBLDO6MVVDg7G+RlyMBfa3qMpJ3qsG3M55636UjZEV
        SRIPjMAoDFqnUMP67j/Se4Y2bg/jneFgeLDLUH6LtfYPfpqVRQJxys0ME8tQKT57mmicl3ZTxdVZP
        nT5VUk0w+lAO4wQptKQ+l1WMx19DFYdVOT5Rtp/mFME0eq4C3/0jOpYjBh36bLV/idaREcAslZGGH
        WrHR98V8UbzCcvRYUK6/ywpAqrklMz0TUTnGSX2whIMdCRgBN8KXm+6KWFTUqK0tHi45D+k7qbpF5
        jE8u81Bg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qvFoN-002Ga9-W3; Tue, 24 Oct 2023 11:43:04 +0000
Date:   Tue, 24 Oct 2023 12:43:03 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Ilya Dryomov <idryomov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] filemap: add a per-mapping stable writes flag
Message-ID: <ZTetxytPcOyZTr1A@casper.infradead.org>
References: <20231024064416.897956-1-hch@lst.de>
 <20231024064416.897956-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231024064416.897956-2-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 24, 2023 at 08:44:14AM +0200, Christoph Hellwig wrote:
> folio_wait_stable waits for writeback to finish before modifying the
> contents of a folio again, e.g. to support check summing of the data
> in the block integrity code.
> 
> Currently this behavior is controlled by the SB_I_STABLE_WRITES flag
> on the super_block, which means it is uniform for the entire file system.
> This is wrong for the block device pseudofs which is shared by all
> block devices, or file systems that can use multiple devices like XFS
> witht the RT subvolume or btrfs (although btrfs currently reimplements
> folio_wait_stable anyway).
> 
> Add a per-address_space AS_STABLE_WRITES flag to control the behavior
> in a more fine grained way.  The existing SB_I_STABLE_WRITES is kept
> to initialize AS_STABLE_WRITES to the existing default which covers
> most cases.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

> +++ b/mm/page-writeback.c
> @@ -3110,7 +3110,7 @@ EXPORT_SYMBOL_GPL(folio_wait_writeback_killable);
>   */
>  void folio_wait_stable(struct folio *folio)
>  {
> -	if (folio_inode(folio)->i_sb->s_iflags & SB_I_STABLE_WRITES)
> +	if (mapping_stable_writes(folio_mapping(folio)))
>  		folio_wait_writeback(folio);

What I really like about this is that we've gone from

	folio->mapping->host->i_sb->s_iflags
to
	folio->mapping->flags

which saves us two pointer dereferences.  Sure, probably cached, but
maybe not, and cache misses are expensive.
