Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51A4CC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Dec 2021 17:05:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239630AbhLQRF1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Dec 2021 12:05:27 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47208 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239619AbhLQRFY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Dec 2021 12:05:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E02462313;
        Fri, 17 Dec 2021 17:05:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F7BC36AE1;
        Fri, 17 Dec 2021 17:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639760723;
        bh=HGHIpmA0yzJfm35X6d4VhUpxnuLa9XOigADxb408EUM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rg5afhcXiVCBjBanS4lOzia/BtDVwiBQSBxFHhL3AZQTu8JWfqBPS8yhXEr+2oEkV
         y3Zko+BAQ+P5Cp3pxPfYQmCtCc/U7GT9pfWrLLY8Vz7rAzmFAexzlmh5KRkKYnVle2
         m89IXzdY49Ce2kHGkxnCI0slit00Rm+JDbvuCeMcd6iQJAAbm1SaAVZEvbiROSzM41
         aKTHf4Bq7sNrVkTJiKY6RByeA1lhM6553eeh0jyzp/ZWYIzuTblQsglbq0h4MafOP+
         XD+IygridJZ7205AnvDHI5rbRS0sVZybdzNBlVbjHrwYXkNjsUs0ZrMiOP393imTBB
         iSNBjBCzXhIvA==
Date:   Fri, 17 Dec 2021 09:05:23 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-xfs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] xfs: prevent a WARN_ONCE() in xfs_ioc_attr_list()
Message-ID: <20211217170523.GG27664@magnolia>
References: <20211217065453.GB26548@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211217065453.GB26548@kili>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 17, 2021 at 09:54:53AM +0300, Dan Carpenter wrote:
> The "bufsize" comes from the root user.  If "bufsize" is negative then,
> because of type promotion, neither of the validation checks at the start
> of the function are able to catch it:
> 
> 	if (bufsize < sizeof(struct xfs_attrlist) ||
> 	    bufsize > XFS_XATTR_LIST_MAX)
> 		return -EINVAL;
> 
> This means "bufsize" will trigger (WARN_ON_ONCE(size > INT_MAX)) in
> kvmalloc_node().  Fix this by changing the type from int to size_t.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Makes sense, particularly since the only caller supplies a u32 anyway.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

> ---
> It's sort of hard to figure out which Fixes tag to use...  Maybe:
> 
> Fixes: 7661809d493b ("mm: don't allow oversized kvmalloc() calls")
> 
> so it gets backported to the kernels which have the warning?

But that's just the warning, right?  I think the root problem here is
turning the ioctl's u32 length argument into a signed int for parameter
passing, and then promoting it back to unsigned types for validation and
memory allocation.  I would have suggested:

Fixes: 3e7a779937a2 ("xfs: move the legacy xfs_attr_list to xfs_ioctl.c")

to trigger the autobackport robots, though that's a 2020 commit and
hence not so useful for spelunking.

Looking through the multiple reorganiziations of the git tree I think
the validation error itself dates to before 2013, but patching old
kernels will require the human touch.

--D

> 
>  fs/xfs/xfs_ioctl.c | 2 +-
>  fs/xfs/xfs_ioctl.h | 5 +++--
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 174cd8950cb6..29231a8c8a45 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -372,7 +372,7 @@ int
>  xfs_ioc_attr_list(
>  	struct xfs_inode		*dp,
>  	void __user			*ubuf,
> -	int				bufsize,
> +	size_t				bufsize,
>  	int				flags,
>  	struct xfs_attrlist_cursor __user *ucursor)
>  {
> diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
> index 28453a6d4461..845d3bcab74b 100644
> --- a/fs/xfs/xfs_ioctl.h
> +++ b/fs/xfs/xfs_ioctl.h
> @@ -38,8 +38,9 @@ xfs_readlink_by_handle(
>  int xfs_ioc_attrmulti_one(struct file *parfilp, struct inode *inode,
>  		uint32_t opcode, void __user *uname, void __user *value,
>  		uint32_t *len, uint32_t flags);
> -int xfs_ioc_attr_list(struct xfs_inode *dp, void __user *ubuf, int bufsize,
> -	int flags, struct xfs_attrlist_cursor __user *ucursor);
> +int xfs_ioc_attr_list(struct xfs_inode *dp, void __user *ubuf,
> +		      size_t bufsize, int flags,
> +		      struct xfs_attrlist_cursor __user *ucursor);
>  
>  extern struct dentry *
>  xfs_handle_to_dentry(
> -- 
> 2.20.1
> 
