Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:37918 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726577AbeHMKEN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Aug 2018 06:04:13 -0400
Date: Mon, 13 Aug 2018 00:23:13 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/6] xfs: don't crash the vfs on a garbage inline symlink
Message-ID: <20180813072313.GA26027@infradead.org>
References: <153400169747.27471.4044680761841034489.stgit@magnolia>
 <153400173428.27471.504421086760762828.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153400173428.27471.504421086760762828.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, wen.xu@gatech.edu

>  	struct delayed_call	*done)
>  {
> +	char			*ptr;
> +
>  	ASSERT(XFS_I(inode)->i_df.if_flags & XFS_IFINLINE);
> -	return XFS_I(inode)->i_df.if_u1.if_data;
> +
> +	/*
> +	 * The VFS crashes on a NULL pointer, so return -EFSCORRUPTED if
> +	 * if_data is junk.
> +	 */
> +	ptr = XFS_I(inode)->i_df.if_u1.if_data;
> +	return ptr ? ptr : ERR_PTR(-EFSCORRUPTED);
>  }
>  
>  STATIC int

Please simplify this to:

>  	struct delayed_call	*done)
>  {
	char			*link = XFS_I(inode)->i_df.if_u1.if_data;

  	ASSERT(XFS_I(inode)->i_df.if_flags & XFS_IFINLINE);
> +	ptr = XFS_I(inode)->i_df.if_u1.if_data;

	if (!link)
		return ERR_PTR(-EFSCORRUPTED);
	return link;

But be honest I'd much rather fix this in the caller than every fs.
Can you send a patch to Al to do that instead?
