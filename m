Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38676 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751312AbdARKaT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2017 05:30:19 -0500
Date: Wed, 18 Jan 2017 01:03:43 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH (TRIVIAL)] xfs: remove unused struct declarations
Message-ID: <20170118090343.GA3714@infradead.org>
References: <e0a94cb5-3283-eaba-346d-eff3a3e9c047@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0a94cb5-3283-eaba-346d-eff3a3e9c047@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Jan 17, 2017 at 04:44:36PM -0600, Eric Sandeen wrote:
> After scratching my head looking for "xfs_busy_extent" I realized
> it's not used; it's xfs_extent_busy, and the declaration for the
> other name is bogus.  Remove that and a few others as well.
> 
> (struct xfs_log_callback is used, but the 2nd declaration is
> unnecessary).
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
