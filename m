Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:42408 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727204AbfARHRJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Jan 2019 02:17:09 -0500
Date: Thu, 17 Jan 2019 23:17:08 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/22] xfs: refactor kernel-specific parts of xfs_ialloc
Message-ID: <20190118071708.GB4288@infradead.org>
References: <154630914104.18437.15354380637179830566.stgit@magnolia>
 <154630917828.18437.11659667761358440410.stgit@magnolia>
 <20190117142221.GD16270@infradead.org>
 <20190117232808.GJ4424@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190117232808.GJ4424@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Thu, Jan 17, 2019 at 03:28:08PM -0800, Darrick J. Wong wrote:
> > This is just too ugly and pointless.  Can you explain (or even better
> > show code) why we really need this for xfsprogs?
> 
> To avoid having a useless lock_flags argument to xfs_iget in userspace?
> It wasn't so long ago that Eric removed it, but I don't mind adding it
> back to avoid this kind of ugliness.

I'd rather have prototypes match in userspace then working around
mismatches in the kernel.

> The mkfs protofile platform_init also has some code to set other
> attributes from a struct fsxattr, but I think I can just set them once
> the inode allocation function returns to the protofile code.

And we are killing that anyway, right?
