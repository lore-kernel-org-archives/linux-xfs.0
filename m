Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:60508 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727455AbeGaJvK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jul 2018 05:51:10 -0400
Date: Tue, 31 Jul 2018 01:12:00 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/15] xfs: use transaction for intent recovery instead
 of raw dfops
Message-ID: <20180731081200.GC16028@infradead.org>
References: <20180730164520.36882-1-bfoster@redhat.com>
 <20180730164520.36882-3-bfoster@redhat.com>
 <20180730200909.GC30972@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180730200909.GC30972@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Mon, Jul 30, 2018 at 01:09:09PM -0700, Darrick J. Wong wrote:
> > -	struct xfs_mount		*mp,
> > -	struct xfs_bui_log_item		*buip,
> > -	struct xfs_defer_ops		*dfops)
> > +	struct xfs_trans		*itp,
> 
> "itp"?
> 
> Oh, the intent-holder transaction...

Maybe we should just call it parent_tp which would be a little
less confusing?
