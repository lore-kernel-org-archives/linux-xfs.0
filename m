Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:50059 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754823AbdIHHQb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Sep 2017 03:16:31 -0400
Date: Fri, 8 Sep 2017 00:16:30 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS mounted with 'discard' option - deleting fio test files slow
Message-ID: <20170908071630.GB9869@infradead.org>
References: <42228B9C-D2D3-4B9C-BFCF-BC9AED4A9678@amazon.com>
 <20170907233401.GC17782@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170907233401.GC17782@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Lu, Qian" <luqia@amazon.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Fri, Sep 08, 2017 at 09:34:02AM +1000, Dave Chinner wrote:
> 4k random write with direct IO. 5GB file. Probably got a million 4k
> extents in it. Which means XFS has sent a million tiny 4k discards
> to the device. Run 'xfs_bmap -vvp fio_test_file.*' to confirm.
> 
> Don't use "-o discard" if you care about performance.

And your device sucks :)

Some numbers here:

https://events.linuxfoundation.org/sites/events/files/slides/discard_0.pdf

Discard will cause extra work, and for worst case sceanarios lots of
it.  But some device handle that extra load very well.
