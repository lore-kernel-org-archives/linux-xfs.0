Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:59790 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750951AbdFTGhY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Jun 2017 02:37:24 -0400
Date: Mon, 19 Jun 2017 23:37:23 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: don't allow bmap/swap on rt files
Message-ID: <20170620063723.GA2250@infradead.org>
References: <20170619202314.GB4733@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170619202314.GB4733@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Mon, Jun 19, 2017 at 01:23:14PM -0700, Darrick J. Wong wrote:
> bmap returns a dumb LBA address but not the block device that goes with
> that LBA.  Swapfiles don't care about this and will blindly assume that
> the data volume is the correct blockdev, which is totally bogus for
> files on the rt subvolume.  This results in the swap code doing IOs to
> arbitrary locations on the data device(!) if the passed in mapping is a
> realtime file, so just turn off bmap for rt files.

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
