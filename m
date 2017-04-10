Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49181 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751547AbdDJHgR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Apr 2017 03:36:17 -0400
Date: Mon, 10 Apr 2017 09:36:16 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: split the reflink remap from the block allocation path
Message-ID: <20170410073616.GA6132@lst.de>
References: <20170403121833.7825-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170403121833.7825-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Any chance to get some reviews on this series?

On Mon, Apr 03, 2017 at 02:18:27PM +0200, Christoph Hellwig wrote:
> We've run into various problems due to the fact that the reflink remap
> code reuses the xfs_bmapi_write codepath for setting up the extent list
> entries and abuses the firstblock field for that purpose.
> 
> This series fixes this by creating an entirely separate xfs_bmapi_remap
> path that is much simpler than xfs_bmapi_write and does not need to
> overload the firstblock field.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
