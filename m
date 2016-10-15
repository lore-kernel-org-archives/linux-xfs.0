Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33604 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751105AbcJOQ5h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 15 Oct 2016 12:57:37 -0400
Date: Sat, 15 Oct 2016 09:57:35 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] xfs: set the refcount btree cowflag when setting up
 cow
Message-ID: <20161015165735.GA11829@infradead.org>
References: <147646876990.19627.5046740854955682441.stgit@birch.djwong.org>
 <147646877615.19627.12845265308407861169.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147646877615.19627.12845265308407861169.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, eguan@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Fri, Oct 14, 2016 at 11:12:56AM -0700, Darrick J. Wong wrote:
> When we're setting up a fake cow extent in the refcountbt to test
> cleanup of fake cow extents, set the cowflag in the record field
> to reflect our new disk format of storing the staging extents in
> the right side of the tree.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
