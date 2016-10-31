Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:47346 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S943918AbcJaPQi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 31 Oct 2016 11:16:38 -0400
Date: Mon, 31 Oct 2016 16:16:36 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] xfs: don't block the log commit handler for
        discards
Message-ID: <20161031151636.GA14981@lst.de>
References: <1476735753-5861-1-git-send-email-hch@lst.de> <1476735753-5861-3-git-send-email-hch@lst.de> <20161017232908.GY23194@dastard> <20161019105825.GA2279@lst.de> <D438D4D4.2CD0%michaelcallahan@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D438D4D4.2CD0%michaelcallahan@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Michael Callahan <michaelcallahan@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

On Fri, Oct 28, 2016 at 04:16:01PM +0000, Michael Callahan wrote:
> Doesn't the block layer already do a reasonable job of merging adjacent
> discards?

It certainly didn't with my fast NVMe device.  But even if it did
we have all the information available here, so it's still cheaper to
do it in the submitter.  One thing we should try is to move it into
__blkdev_issue_discard in the future, though.

Note that I've also started to look into merging disjoint discard
range into a single request for ranged trim/unmap/deallocate and that
also seems to work nicely, but it will need some large tree-wide
changes.
