Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52289 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754163AbcJZKXx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2016 06:23:53 -0400
Date: Wed, 26 Oct 2016 03:23:52 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/39] xfs: add refcount btree operations
Message-ID: <20161026102352.GD29648@infradead.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
 <147743664272.11035.6730520387402463910.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147743664272.11035.6730520387402463910.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Tue, Oct 25, 2016 at 04:04:02PM -0700, Darrick J. Wong wrote:
> Implement the generic btree operations required to manipulate refcount
> btree blocks.  The implementation is similar to the bmapbt, though it
> will only allocate and free blocks from the AG.
> 
> [Add the xfs_refcount.h file to the standard include list.]
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> [hch: fix logging of AGF refcount btree fields]
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Both the commit log and signoff look odd for adding a single include
directive..
