Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:43253 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727258AbfFZNiB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Jun 2019 09:38:01 -0400
Date: Wed, 26 Jun 2019 15:37:29 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 3/3] iomap: fix page_done callback for short writes
Message-ID: <20190626133729.GA5849@lst.de>
References: <20190626132335.14809-1-agruenba@redhat.com> <20190626132335.14809-3-agruenba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190626132335.14809-3-agruenba@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, linux-xfs@vger.kernel.org

On Wed, Jun 26, 2019 at 03:23:35PM +0200, Andreas Gruenbacher wrote:
> When we truncate a short write to have it retried, pass the truncated
> length to the page_done callback instead of the full length.
> 
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
