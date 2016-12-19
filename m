Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35531 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754708AbcLSKYl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Dec 2016 05:24:41 -0500
Date: Mon, 19 Dec 2016 02:24:41 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_repair: don't indicate dirtiness if FSGEOMETRY fails
Message-ID: <20161219102441.GA25661@infradead.org>
References: <fceea296-989c-a71d-a6e7-23560fd6db8b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fceea296-989c-a71d-a6e7-23560fd6db8b@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Dec 16, 2016 at 09:56:19AM -0600, Eric Sandeen wrote:
> Today, pointing repair at an image hosted on a non-xfs
> filesystem will result in a XFS_IOC_FSGEOMETRY_V1 failure,
> but repair generally proceeds without further problems.
> 
> However, calling do_warn() sets fs_is_dirty to 1, so
> xfs_repair -n exits with non-zero status, indicating
> corruption.  This is incorrect.
> 
> Change the message to use do_log so that it does not
> incorrectly indicate corruption.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
