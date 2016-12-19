Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35943 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758772AbcLSK0M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Dec 2016 05:26:12 -0500
Date: Mon, 19 Dec 2016 02:26:11 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: don't wrap ID in xfs_dq_get_next_id
Message-ID: <20161219102611.GB25661@infradead.org>
References: <f52de68d-abe6-1960-c0ef-1d199346f689@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f52de68d-abe6-1960-c0ef-1d199346f689@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Dec 16, 2016 at 06:05:20PM -0600, Eric Sandeen wrote:
> The GETNEXTQOTA ioctl takes whatever ID is sent in,
> and looks for the next active quota for an user
> equal or higher to that ID.
> 
> But if we are at the maximum ID and then ask for the "next"
> one, we may wrap back to zero.  In this case, userspace
> may loop forever, because it will start querying again
> at zero.
> 
> We'll fix this in userspace as well, but for the kernel,
> return -ENOENT if we ask for the next quota ID
> past UINT_MAX so the caller knows to stop.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
