Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36454 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727010AbfAQOld (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jan 2019 09:41:33 -0500
Date: Thu, 17 Jan 2019 06:41:32 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4] xfs: update fork seq counter on data fork changes
Message-ID: <20190117144132.GA21906@infradead.org>
References: <20190111123032.31538-1-bfoster@redhat.com>
 <20190111123032.31538-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190111123032.31538-3-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jan 11, 2019 at 07:30:30AM -0500, Brian Foster wrote:
> The sequence counter in the xfs_ifork structure is only updated on
> COW forks. This is because the counter is currently only used to
> optimize out repetitive COW fork checks at writeback time.
> 
> Tweak the extent code to update the seq counter regardless of the
> fork type in preparation for using this counter on data forks as
> well.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
