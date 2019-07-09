Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:43715 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbfGIPXc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Jul 2019 11:23:32 -0400
Date: Tue, 9 Jul 2019 17:23:30 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 19/24] xfs: use bios directly to read and write the log
 recovery buffers
Message-ID: <20190709152330.GA3945@lst.de>
References: <20190605191511.32695-1-hch@lst.de> <20190605191511.32695-20-hch@lst.de> <20190708073740.GI7689@dread.disaster.area> <20190708161919.GN1404256@magnolia> <20190708213423.GA18177@lst.de> <20190708221508.GJ7689@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708221508.GJ7689@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Tue, Jul 09, 2019 at 08:15:08AM +1000, Dave Chinner wrote:
> That fixes the problem I saw, but I think bio_chain() needs some
> more checks to prevent this happening in future. It's trivially
> easy to chain the bios in the wrong order, very difficult to spot
> in review, and difficult to trigger in testing as it requires
> chain nesting and adverse IO timing to expose....

Not sure how we can better check it.  At best we can set a flag for a
bio that is a chain "child" and complain if someone is calling
submit_bio_wait, but that would only really cover the wait case.

But one thing I planned to do is to lift xfs_chain_bio to the block
layer so that people can use it for any kind of continuation bio
instead of duplicating the logic.
