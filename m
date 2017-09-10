Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:50388 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751601AbdIJTub (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Sep 2017 15:50:31 -0400
Date: Sun, 10 Sep 2017 21:50:27 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: Support for data CRC
Message-ID: <20170910195026.7ftxcgmwyri5a5fz@breakpoint.cc>
References: <20170821190414.long2535xppcxvvd@breakpoint.cc>
 <20170821230232.GS10621@dastard>
 <20170822055136.GA2697@infradead.org>
 <20170822111322.jt66qlzvalsiju6n@breakpoint.cc>
 <20170823061931.GA30488@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20170823061931.GA30488@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On 2017-08-22 23:19:31 [-0700], Christoph Hellwig wrote:
> as part of the reflink feature.  These out of place writes are
> a requirement to implement data checksums, as otherwise your data
> and checksum can not be updated atomically.  Everything else is
> beyond that at this point is vapourware.  We'd have to decided
So using the journal for atomic updates doesn't work then. Which means
fragmentation unavoidable.

Sebastian
