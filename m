Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:57480 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbeDQHKR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 03:10:17 -0400
Date: Tue, 17 Apr 2018 00:10:17 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: set format back to extents if
 xfs_bmap_extents_to_btree fails
Message-ID: <20180417071017.GB18079@infradead.org>
References: <0add6e45-4382-c16b-3bb1-1d4eaee1adc3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0add6e45-4382-c16b-3bb1-1d4eaee1adc3@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, wen.xu@gatech.edu

On Mon, Apr 16, 2018 at 11:26:12PM -0500, Eric Sandeen wrote:
> If xfs_bmap_extents_to_btree fails in a mode where we call
> xfs_iroot_realloc(-1) to de-allocate the root, set the
> format back to extents.
> 
> Otherwise we can assume we can dereference ifp->if_broot
> based on the XFS_DINODE_FMT_BTREE format, and crash.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=199423
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
