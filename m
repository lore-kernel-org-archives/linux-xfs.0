Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:50409 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753057AbdHWGTd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Aug 2017 02:19:33 -0400
Date: Tue, 22 Aug 2017 23:19:31 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Support for data CRC
Message-ID: <20170823061931.GA30488@infradead.org>
References: <20170821190414.long2535xppcxvvd@breakpoint.cc>
 <20170821230232.GS10621@dastard>
 <20170822055136.GA2697@infradead.org>
 <20170822111322.jt66qlzvalsiju6n@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170822111322.jt66qlzvalsiju6n@breakpoint.cc>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On Tue, Aug 22, 2017 at 01:13:22PM +0200, Sebastian Andrzej Siewior wrote:
> copy on write. So the data crc is dead / not possible / not wanted or
> part of copy on write?

We support copy on write (or redirect on write to be correct) now
as part of the reflink feature.  These out of place writes are
a requirement to implement data checksums, as otherwise your data
and checksum can not be updated atomically.  Everything else is
beyond that at this point is vapourware.  We'd have to decided
first if we really want the feature, and then where to place the
checksum (extent structure, rmap, ?).
