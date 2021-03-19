Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE824C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 05:55:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B77A64F6A
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 05:55:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233942AbhCSFyp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Mar 2021 01:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233966AbhCSFyS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Mar 2021 01:54:18 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A115AC06174A
        for <linux-xfs@vger.kernel.org>; Thu, 18 Mar 2021 22:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=KZoMmT29RiYsvWYpWde7xwa0Marf/Hi7K9CVEo3V5z4=; b=l+Aq2a2EpUhfDEcI+jdjVMfHez
        7NsdCb7wbDhwOC3Fk6IrvaKr4YrmflUpeT3ZOj58mbX7P6QQmWcx8oIqosvVJLfmVA8gnHJSxuS7e
        hzSLzjSLZ9QooVo0Z8NrcRFdueI+9zV7ZsHjQBK1EAQMHvrGdc4Sh25CpPj2MxT4X8t/iKnF01wLv
        OIP6j4hFszFHs6elv101AH3zX7Wy9BFapC6rcgK2WA8abxNjgPZV2IxCVg0hv7DH56KB0+/6B7P7s
        TFZimS9wEn1o5mKsAaNn5QHv1EtM0+uG/pYyCxOwtu4sBOhPVcB0J81ugq9OwhPLbl5TIUdNi+YnG
        LW/0zYpw==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lN84q-0040nJ-OF; Fri, 19 Mar 2021 05:53:48 +0000
Date:   Fri, 19 Mar 2021 05:53:40 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 1/2] xfs: move the xfs_can_free_eofblocks call under the
 IOLOCK
Message-ID: <20210319055340.GA955126@infradead.org>
References: <161610680641.1887542.10509468263256161712.stgit@magnolia>
 <161610681213.1887542.5172499515393116902.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161610681213.1887542.5172499515393116902.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 18, 2021 at 03:33:32PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In xfs_inode_free_eofblocks, move the xfs_can_free_eofblocks call
> further down in the function to the point where we have taken the
> IOLOCK.  This is preparation for the next patch, where we will need that
> lock (or equivalent) so that we can check if there are any post-eof
> blocks to clean out.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_icache.c |   12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index e6a62f765422..7353c9fe05db 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1294,13 +1294,6 @@ xfs_inode_free_eofblocks(
>  	if (!xfs_iflags_test(ip, XFS_IEOFBLOCKS))
>  		return 0;
>  
> -	if (!xfs_can_free_eofblocks(ip, false)) {
> -		/* inode could be preallocated or append-only */
> -		trace_xfs_inode_free_eofblocks_invalid(ip);
> -		xfs_inode_clear_eofblocks_tag(ip);
> -		return 0;
> -	}
> -
>  	/*
>  	 * If the mapping is dirty the operation can block and wait for some
>  	 * time. Unless we are waiting, skip it.
> @@ -1322,7 +1315,10 @@ xfs_inode_free_eofblocks(
>  	}
>  	*lockflags |= XFS_IOLOCK_EXCL;
>  
> -	return xfs_free_eofblocks(ip);
> +	if (xfs_can_free_eofblocks(ip, false))
> +		return xfs_free_eofblocks(ip);

Don't we still need to clear the radix tree tag here?

Also the fs_inode_free_eofblocks_inval tracepoint is unused now.
