Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:55238 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727337AbeLEWfc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Dec 2018 17:35:32 -0500
Date: Wed, 5 Dec 2018 14:35:23 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: use a dedicated SLAB cache for sector sized buffer
 data
Message-ID: <20181205223523.GM24487@magnolia>
References: <20181205172023.5061-1-hch@lst.de>
 <20181205215000.GU6311@dastard>
 <20181205215651.GA4033@lst.de>
 <20181205223139.GV6311@dastard>
 <20181205223346.GA5145@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181205223346.GA5145@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, tom.leiming@gmail.com, vkuznets@redhat.com

On Wed, Dec 05, 2018 at 11:33:46PM +0100, Christoph Hellwig wrote:
> On Thu, Dec 06, 2018 at 09:31:39AM +1100, Dave Chinner wrote:
> > > 
> > > That's fine because log recovery is one I/O at a time, and we always
> > > free the current buffer before allocating the next one, so we'd waste
> > > the memory one way or another.
> > 
> > True. Can you mention this in the commit message so it gets recorded
> > with the change and doesn't get lost in the mists of time?
> 
> How about a comment instead of the commit message?  Either way I can
> document this decision for v2.

A comment would be very welcome.

--D
