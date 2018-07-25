Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56642 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727883AbeGYGOy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jul 2018 02:14:54 -0400
Date: Tue, 24 Jul 2018 22:04:59 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 10/15] xfs: use internal dfops in attr code
Message-ID: <20180725050459.GC5802@infradead.org>
References: <20180723130414.47980-1-bfoster@redhat.com>
 <20180723130414.47980-11-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180723130414.47980-11-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 23, 2018 at 09:04:09AM -0400, Brian Foster wrote:
> Remove the unnecessary on-stack dfops structure and use the internal
> transaction dfops instead. The lower level xattr code already
> appropriately accesses ->t_dfops throughout.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
