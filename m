Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58627 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752026AbcJJKSO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Oct 2016 06:18:14 -0400
Date: Mon, 10 Oct 2016 03:18:12 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/7] xfs: check inode reflink flag before calling reflink
 functions
Message-ID: <20161010101812.GB18359@infradead.org>
References: <147588163396.12127.8356851783027062457.stgit@birch.djwong.org>
 <147588165195.12127.15898847119499370449.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147588165195.12127.15898847119499370449.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

I would prefer to add the xfs_is_reflink_inode check to
xfs_reflink_cancel_cow_range instead dealing with it in the caller.

Otherwise this looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
