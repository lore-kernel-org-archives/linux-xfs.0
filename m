Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48679 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932221AbcKRMyK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Nov 2016 07:54:10 -0500
Date: Fri, 18 Nov 2016 04:54:10 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_db: add alignment filter to freesp command
Message-ID: <20161118125410.GA26641@infradead.org>
References: <1ed1ffd4-75e0-fa14-f812-b6ac4fd12987@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ed1ffd4-75e0-fa14-f812-b6ac4fd12987@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Nov 17, 2016 at 05:19:15PM -0600, Eric Sandeen wrote:
> This adds an alignment filter to the xfs_db freesp command, i.e.
> 
> xfs_db> freesp -A 4
> 
> will show only 4-block aligned free extents.
> 
> This can be useful for finding freespace suitable for allocations
> with specific alignment requirements, such as inode allocation.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
