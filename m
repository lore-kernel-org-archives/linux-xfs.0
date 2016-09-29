Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58356 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933707AbcI2Q4C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 12:56:02 -0400
Date: Thu, 29 Sep 2016 09:56:01 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 11/63] xfs: log refcount intent items
Message-ID: <20160929165601.GE4546@infradead.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
 <147503128015.30303.2237183364098745952.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147503128015.30303.2237183364098745952.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

> +/* The XFS_REFCOUNT_EXTENT_* in xfs_log_format.h must match these. */
> +enum xfs_refcount_intent_type {
> +	XFS_REFCOUNT_INCREASE = 1,
> +	XFS_REFCOUNT_DECREASE,
> +	XFS_REFCOUNT_ALLOC_COW,
> +	XFS_REFCOUNT_FREE_COW,
> +};

That's a nightmare for maintability!  Either we use
XFS_REFCOUNT_EXTENT_* directly, or we need a helper to convert
between them.

