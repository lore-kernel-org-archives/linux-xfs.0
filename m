Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:48038 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390715AbfBNIRB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Feb 2019 03:17:01 -0500
Date: Thu, 14 Feb 2019 00:17:00 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] xfs: reserve blocks for ifree transaction during log
 recovery
Message-ID: <20190214081700.GC5961@infradead.org>
References: <155009104740.32028.193157199378698979.stgit@magnolia>
 <155009105963.32028.10768016263671369410.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155009105963.32028.10768016263671369410.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Feb 13, 2019 at 12:50:59PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Log recovery frees all the inodes stored in the unlinked list, which can
> cause expansion of the free inode btree.  The ifree code skips block
> reservations if it thinks there's a per-AG space reservation, but we
> don't set up the reservation until after log recovery, which means that
> a finobt expansion blows up in xfs_trans_mod_sb when we exceed the
> transaction's block reservation.
> 
> To fix this, we set the "no finobt reservation" flag to true when we
> create the xfs_mount and only set it to false if we confirm that every
> AG had enough free space to put aside for the finobt.
> 
> While we're at it we change the flag name to be clearer about what it
> actually does.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

But throwing in the field rename makes the patch way bigger and
not as obvious to understand.  Any reason it can't be split into
a separate patch?
