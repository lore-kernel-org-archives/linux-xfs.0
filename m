Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:47827 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751068AbdICIi6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Sep 2017 04:38:58 -0400
Date: Sun, 3 Sep 2017 01:38:57 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] mkfs: pass a custom cowextsize into the created
 filesystem
Message-ID: <20170903083857.GB32385@infradead.org>
References: <20170901164035.GF3775@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170901164035.GF3775@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Fri, Sep 01, 2017 at 09:40:35AM -0700, Darrick J. Wong wrote:
> Create a -d option to mkfs.xfs that enables administrators to set
> the CoW extent size hint on the created files.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  libxfs/util.c       |   26 ++++++++++++++++++++++++--
>  man/man8/mkfs.xfs.8 |    7 +++++++
>  mkfs/xfs_mkfs.c     |   20 ++++++++++++++++++++
>  3 files changed, 51 insertions(+), 2 deletions(-)
> 
> diff --git a/libxfs/util.c b/libxfs/util.c
> index 0e2f29e..4f82d7f 100644
> --- a/libxfs/util.c
> +++ b/libxfs/util.c
> @@ -175,6 +175,26 @@ libxfs_trans_ichgtime(
>  	}
>  }
>  
> +static inline uint16_t
> +xflags_to_diflags(
> +	__u32		xflags)
> +{
> +	/* bottom 15 xflag bits correspond to diflag bits */
> +	return xflags & 0x7FFF;

Do we really want to rely on that fact?

> +}
> +
> +static inline uint64_t
> +xflags_to_diflags2(
> +	__u32		xflags)
> +{
> +	uint64_t	ret = 0;
> +
> +	if (xflags & FS_XFLAG_COWEXTSIZE)
> +		ret |= XFS_DIFLAG2_COWEXTSIZE;
> +
> +	return ret;
> +}

It seems like we should just lift the kernels xfs_flags2diflags and
xfs_flags2diflags2 to libxfs and use them here?

