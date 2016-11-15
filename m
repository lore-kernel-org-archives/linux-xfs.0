Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60957 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966694AbcKOKWd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Nov 2016 05:22:33 -0500
Date: Tue, 15 Nov 2016 02:22:27 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 16/16] xfs: check minimum block size for CRC filesystems
Message-ID: <20161115102227.GP1607@infradead.org>
References: <147830447710.26713.9536263528122988931.stgit@birch.djwong.org>
 <147830457847.26713.15949781885999402794.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147830457847.26713.15949781885999402794.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

> +	if (xfs_sb_version_hascrc(&mp->m_sb) &&
> +	    unlikely(
> +	    sbp->sb_blocksize < XFS_MIN_CRC_BLOCKSIZE)) {
> +		xfs_notice(mp, "v5 SB sanity check failed");
> +		return -EFSCORRUPTED;
> +	}

No need to uglify mount, which is a slow path with unlikely annotations.

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
