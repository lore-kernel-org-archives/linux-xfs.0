Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:35134 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389910AbfA1QmX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Jan 2019 11:42:23 -0500
Date: Mon, 28 Jan 2019 08:42:09 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] iomap: fix a use after free in iomap_dio_rw
Message-ID: <20190128164209.GG4368@magnolia>
References: <20190117075707.8640-1-hch@lst.de>
 <20190117212658.GD6173@dastard>
 <20190128162233.GF4368@magnolia>
 <20190128162801.GA12264@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190128162801.GA12264@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Chandan Rajendra <chandan@linux.ibm.com>

On Mon, Jan 28, 2019 at 05:28:01PM +0100, Christoph Hellwig wrote:
> On Mon, Jan 28, 2019 at 08:22:33AM -0800, Darrick J. Wong wrote:
> > Fixed.
> > 
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Are you going to pick this one (and the migrate page fix) up for
> 5.0-rc?

Yes.  I've been mostly offline for a week or so now because last year's
health problems came back, though I'm now patched up enough to push out
the branch that was running endlessly (yay more fsx) while I was gone.

--D
