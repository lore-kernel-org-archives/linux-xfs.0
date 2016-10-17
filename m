Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32255 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965204AbcJQVfx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Oct 2016 17:35:53 -0400
Date: Mon, 17 Oct 2016 14:35:50 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: fix locking for the reflink operation
Message-ID: <20161017213550.GA7786@birch.djwong.org>
References: <1476705920-32493-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476705920-32493-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 17, 2016 at 02:05:16PM +0200, Christoph Hellwig wrote:
> When creating a reflink we need to take the iolock much earlier, as
> various early checks done in xfs_file_share_range currently are racy
> without it.  Patches 1-3 sort that out in a minimal invasive way,
> but I think we should just merge xfs_file_share_range and
> xfs_reflink_remap_range, which is what patch 4 does.
> 
> Patches 1-3 are something I'd like to see in 4.9, patch 4 might not
> fully qualify, but just getting it in might make everyones life easier.

This series (+ the CoW optimization series before it) seem to run ok here.
I'm ok with (more soak testing and) sending it in for 4.9.

--D

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
