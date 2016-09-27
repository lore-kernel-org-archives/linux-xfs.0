Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48978 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751939AbcI0O13 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Sep 2016 10:27:29 -0400
Date: Tue, 27 Sep 2016 07:27:26 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS reflink and development tip git trees updated
Message-ID: <20160927142726.GA5675@infradead.org>
References: <20160905053317.GA15302@birch.djwong.org>
 <20160919161100.GA19849@infradead.org>
 <20160920043942.GE10172@birch.djwong.org>
 <20160927052344.GD3059@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160927052344.GD3059@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org, xfs@oss.sgi.com, amir73il@gmail.com

On Mon, Sep 26, 2016 at 10:23:44PM -0700, Darrick J. Wong wrote:
> Ok, here's this week's for-4.9 branch:
> 
> https://github.com/djwong/linux/tree/for-dave-for-4.9-5
> https://github.com/djwong/xfsprogs/tree/for-dave-for-4.9-5
> 
> The kernel tree includes Christoph's fixes for copy-on-write,
> refactoring of a refcount btree function to use _btree_query_range (and
> inclusion of the required diff_two_keys/init_high_key helpers), and
> removal of the (totally broken) always_cow debug switch.  It also
> contains a new error injection point to make reflink fail with ENOSPC.

Are you going to send out the patches to the list?  Also it seems like
the writeback updates weren't folded in but just added to the end,
was that intentional?
