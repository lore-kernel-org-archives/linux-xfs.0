Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41867 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753753AbcJZK57 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2016 06:57:59 -0400
Date: Wed, 26 Oct 2016 03:57:58 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 28/39] xfs_repair: handle multiple owners of data blocks
Message-ID: <20161026105758.GC8254@infradead.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
 <147743679506.11035.9193078348507369875.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147743679506.11035.9193078348507369875.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -722,6 +722,9 @@ _("Fatal error: inode %" PRIu64 " - blkmap_set_ext(): %s\n"
>  			 * checking each entry without setting the
>  			 * block bitmap
>  			 */
> +			if (type == XR_INO_DATA &&
> +			    xfs_sb_version_hasreflink(&mp->m_sb))
> +				goto skip_dup;
>  			if (search_dup_extent(agno, agbno, ebno)) {
>  				do_warn(
>  _("%s fork in ino %" PRIu64 " claims dup extent, "
> @@ -731,6 +734,7 @@ _("%s fork in ino %" PRIu64 " claims dup extent, "
>  					irec.br_blockcount);
>  				goto done;
>  			}
> +skip_dup:

For some weird reason this goto makes me sad.  I'm getting into
major nitpick terretory here, but can we avoid it?  Either duplicate
the *tot increment or find some funky condition?

Otherwise this looks fine.
