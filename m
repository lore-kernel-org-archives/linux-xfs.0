Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48503C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 01:28:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13D5264DAE
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 01:28:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbhBKB1l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Feb 2021 20:27:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:43272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229972AbhBKB1j (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Feb 2021 20:27:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EF7A64DAE;
        Thu, 11 Feb 2021 01:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613006819;
        bh=2eT3H6OVGscwuquZl5yDwZ/tUjtTKYUVyK4/eXbYJIg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RXs7lYUNJypVlKSdvf/xDIRtizLI7tFPzuiWu+RzOJqPNN66sQeElYKsP9vr8lFSv
         ALyTGDW+EVa4p/gcfJFJDNGm8VwWDFoohpBZ3sjCtdB+RnsSBik766KJDKzwDjxdK+
         WJrkRP3/mgLeBWTlvgrifpvgzKWy6f5DBS/JjoZ3cU+TWwi7C6XFDfv7WfJLXcIM2l
         ZQvM+r88pMSPoFvdmiFgy/5rpFyhLrjPXsvmKDKgDxL2ASV9t65U8jaeHEOu/uoxbh
         V4m1zkQf5Yg2XR0xa0jJR6cAPLkZVvDgeG3FHS8sl5Dq3vWnI/uSkl4PB7nCFVs3NW
         1dUWjhXReXMbg==
Date:   Wed, 10 Feb 2021 17:27:00 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: restore shutdown check in mapped write fault path
Message-ID: <20210211012700.GA7193@magnolia>
References: <20210210170112.172734-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210210170112.172734-1-bfoster@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 10, 2021 at 12:01:12PM -0500, Brian Foster wrote:
> XFS triggers an iomap warning in the write fault path due to a
> !PageUptodate() page if a write fault happens to occur on a page
> that recently failed writeback. The iomap writeback error handling
> code can clear the Uptodate flag if no portion of the page is
> submitted for I/O. This is reproduced by fstest generic/019, which
> combines various forms of I/O with simulated disk failures that
> inevitably lead to filesystem shutdown (which then unconditionally
> fails page writeback).
> 
> This is a regression introduced by commit f150b4234397 ("xfs: split
> the iomap ops for buffered vs direct writes") due to the removal of
> a shutdown check and explicit error return in the ->iomap_begin()
> path used by the write fault path. The explicit error return
> historically translated to a SIGBUS, but now carries on with iomap
> processing where it complains about the unexpected state. Restore
> the shutdown check to xfs_buffered_write_iomap_begin() to restore
> historical behavior.
> 
> Fixes: f150b4234397 ("xfs: split the iomap ops for buffered vs direct writes")
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks fine,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_iomap.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 70c341658c01..6594f572096e 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -860,6 +860,9 @@ xfs_buffered_write_iomap_begin(
>  	int			allocfork = XFS_DATA_FORK;
>  	int			error = 0;
>  
> +	if (XFS_FORCED_SHUTDOWN(mp))
> +		return -EIO;
> +
>  	/* we can't use delayed allocations when using extent size hints */
>  	if (xfs_get_extsz_hint(ip))
>  		return xfs_direct_write_iomap_begin(inode, offset, count,
> -- 
> 2.26.2
> 
