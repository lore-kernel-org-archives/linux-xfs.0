Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49164 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932359AbcK2UM3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2016 15:12:29 -0500
Date: Tue, 29 Nov 2016 12:12:28 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH ] xfs: always succeed when deduping zero bytes
Message-ID: <20161129201228.GC31951@infradead.org>
References: <147986712771.27265.15625188791039802671.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147986712771.27265.15625188791039802671.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Tue, Nov 22, 2016 at 06:12:07PM -0800, Darrick J. Wong wrote:
> It turns out that btrfs and xfs had differing interpretations of what
> to do when the dedupe length is zero.  Change xfs to follow btrfs'
> semantics so that the userland interface is consistent.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
