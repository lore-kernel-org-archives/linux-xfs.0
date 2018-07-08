Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:59004 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751422AbeGHP6T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Jul 2018 11:58:19 -0400
Date: Sun, 8 Jul 2018 08:58:17 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RFC 0/8] xfs: introduce inode data inline feature
Message-ID: <20180708155817.GF8625@infradead.org>
References: <1530846750-6686-1-git-send-email-shan.hai@oracle.com>
 <20180706054250.GU2234@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180706054250.GU2234@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Shan Hai <shan.hai@oracle.com>, linux-xfs@vger.kernel.org

On Fri, Jul 06, 2018 at 03:42:50PM +1000, Dave Chinner wrote:
> This mechanism solves the above problem by storing the newly
> allocated block in the in-memory COW fork and doesn't modify the
> data fork until after the data write IO completes. IOWs, we do
> allocation before the write IO, and do the data fork and BMBT
> manipulation after the IO completes. i.e. we do the local->extent
> data fork modification at IO completion using the extent that was
> stored in the in memory COW fork.
> 
> Hence I think the inline data write path needs to piggy back on the
> iomap COW path that we use for writing to shared extents if the
> write would cause a data fork format change.

I'm not even sure we need the cow infrastructure for that, but yes,
we need the format conversion to be driven from the I/O completion
handler for buffer I/O writeback, and for direct I/O (including AIO)
as well.
