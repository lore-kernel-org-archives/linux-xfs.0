Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:51278 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725783AbeLTHHn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Dec 2018 02:07:43 -0500
Date: Thu, 20 Dec 2018 08:07:41 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 11/11] xfs: introduce an always_cow mode
Message-ID: <20181220070741.GA9803@lst.de>
References: <20181203222503.30649-1-hch@lst.de> <20181203222503.30649-12-hch@lst.de> <20181218232437.GS27208@magnolia> <20181219224335.GB4205@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181219224335.GB4205@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Thu, Dec 20, 2018 at 09:43:35AM +1100, Dave Chinner wrote:
> On Tue, Dec 18, 2018 at 03:24:37PM -0800, Darrick J. Wong wrote:
> > On Mon, Dec 03, 2018 at 05:25:03PM -0500, Christoph Hellwig wrote:
> > Granted, I'm still rather fuzzy on what exactly is supposed to happen
> > with preallocating fallocate when all writes require an allocation to
> > succeed? 
> 
> For always_cow mode, perhaps we could consider preallocating into
> the COW fork rather than the data fork? That way when we go to write
> the data, we've already got the space allocated regardless of
> whether it is over a hole or existing data?

For a speculative preallocation that is what we already do.  But for
persistent preallocation that doesn't help as the COW fork is not
persistent.
