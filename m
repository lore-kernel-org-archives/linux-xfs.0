Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8BC5C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Apr 2022 13:46:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241647AbiDZNtw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 09:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240946AbiDZNtv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 09:49:51 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF511CB05
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 06:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=hdHlDliaIIdT6flw2vX/1glpJkAkFhMZjW64TXJLT2U=; b=WZAcNSiGUXx7ZWYYkq3ALl+UqM
        B2bGslGcbWsN4bOJAxQlkf4Zrxtpp3BQsAkMoDTwMRVKHP6nxh6UfBBLn66aAYim0LpOjkbk1b1io
        +XMPGj9WZQXtXSCvTOYIXf7S0yWsFKxZTrsZOnXsETtDIQMdzh4hDBuYWnluCaLSvYR47q2ZOm5ND
        hQPR9VcxCXmj1KM5Zqk5Ua/3CPoCjGh3HUYCYl+/d3753jA68vEb2pul/3KHRXKIwcGlB77jwzesr
        RbFcTI0ieefZ9YrqqoEASBmvj4STN4Bo6dHpvHBkip2Tq16QgrDJvEwQHxL0FX7rERhn3dIwRzH9i
        6OYNbE5Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1njLWc-00Ej4f-NL; Tue, 26 Apr 2022 13:46:42 +0000
Date:   Tue, 26 Apr 2022 06:46:42 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: stop artificially limiting the length of bunmap
 calls
Message-ID: <Ymf3wqypgyjXDLN2@infradead.org>
References: <164997686569.383881.8935566398533700022.stgit@magnolia>
 <164997687142.383881.7160925177236303538.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164997687142.383881.7160925177236303538.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 14, 2022 at 03:54:31PM -0700, Darrick J. Wong wrote:
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index 327ba25e9e17..a07ebaecba73 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -960,6 +960,7 @@ xfs_refcount_adjust_extents(
>  			 * Either cover the hole (increment) or
>  			 * delete the range (decrement).
>  			 */
> +			cur->bc_ag.refc.nr_ops++;
>  			if (tmp.rc_refcount) {
>  				error = xfs_refcount_insert(cur, &tmp,
>  						&found_tmp);
> @@ -970,7 +971,6 @@ xfs_refcount_adjust_extents(
>  					error = -EFSCORRUPTED;
>  					goto out_error;
>  				}
> -				cur->bc_ag.refc.nr_ops++;

How do these changes fit into the rest of the patch?
