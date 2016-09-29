Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56191 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751287AbcI2Qw7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 12:52:59 -0400
Date: Thu, 29 Sep 2016 09:52:57 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/63] xfs: create refcount update intent log items
Message-ID: <20160929165257.GD4546@infradead.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
 <147503127360.30303.13509008550712587655.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147503127360.30303.13509008550712587655.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

> +int
> +xfs_cui_copy_format(
> +	struct xfs_log_iovec		*buf,
> +	struct xfs_cui_log_format	*dst_cui_fmt)
> +{
> +	struct xfs_cui_log_format	*src_cui_fmt;
> +	uint				len;
> +
> +	src_cui_fmt = buf->i_addr;
> +	len = xfs_cui_log_format_sizeof(src_cui_fmt->cui_nextents);
> +
> +	if (buf->i_len == len) {
> +		memcpy(dst_cui_fmt, src_cui_fmt, len);
> +		return 0;
> +	}
> +	return -EFSCORRUPTED;
> +}

I'd still much prefer this to be inlined in the only caller.

But except for that this looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
