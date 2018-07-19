Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36500 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727508AbeGSUew (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Jul 2018 16:34:52 -0400
Date: Thu, 19 Jul 2018 12:50:14 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/14] xfs: pull up dfops from xfs_itruncate_extents()
Message-ID: <20180719195014.GB6558@infradead.org>
References: <20180719134919.29939-1-bfoster@redhat.com>
 <20180719134919.29939-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180719134919.29939-2-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jul 19, 2018 at 09:49:06AM -0400, Brian Foster wrote:
> xfs_itruncate_extents[_flags]() uses a local dfops with a
> transaction provided by the caller. It uses hacky ->t_dfops
> replacement logic to avoid stomping over an already populated
> ->t_dfops.
> 
> The latter never occurs for current callers and the logic itself is
> not really appropriate. Clean this up by updating all callers to
> initialize a dfops and to use that down in xfs_itruncate_extents().
> This more closely resembles the upcoming logic where dfops will be
> embedded within the transaction. We can also replace the
> xfs_defer_init() in the xfs_itruncate_extents_flags() loop with an
> assert. Both dfops and firstblock should be in a valid state
> after xfs_defer_finish() and the inode joined to the dfops is fixed
> throughout the loop.

Yes, this looks pretty sensible:

Reviewed-by: Christoph Hellwig <hch@lst.de>
