Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:47878 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750853AbcI3Hxx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 03:53:53 -0400
Date: Fri, 30 Sep 2016 00:53:52 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 44/63] xfs: teach get_bmapx about shared extents and the
 CoW fork
Message-ID: <20160930075352.GE17618@infradead.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520502705.29434.17995892650908807221.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147520502705.29434.17995892650908807221.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, Sep 29, 2016 at 08:10:27PM -0700, Darrick J. Wong wrote:
> Teach xfs_getbmapx how to report shared extents and CoW fork contents
> accurately in the bmap output by querying the refcount btree
> appropriately.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
