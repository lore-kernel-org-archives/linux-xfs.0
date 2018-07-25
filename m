Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56754 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727939AbeGYGRj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jul 2018 02:17:39 -0400
Date: Tue, 24 Jul 2018 22:07:44 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 13/15] xfs: remove unnecessary dfops init calls in
 xattr code
Message-ID: <20180725050744.GF5802@infradead.org>
References: <20180723130414.47980-1-bfoster@redhat.com>
 <20180723130414.47980-14-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180723130414.47980-14-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 23, 2018 at 09:04:12AM -0400, Brian Foster wrote:
> Each xfs_defer_init() call in the xattr code uses the internal dfops
> reference. In addition, a successful xfs_defer_finish() always
> returns with a reset xfs_defer_ops structure.
> 
> Given that along with the fact that every xfs_defer_init() call in
> the xattr code is followed up by an xfs_defer_finish(), the former
> calls are no longer necessary and can be removed.
> 
> Note that the xfs_defer_init() call in the remote value copy loop of
> xfs_attr_rmtval_set() is not followed by a finish, but the dfops is
> unused in this instance.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
