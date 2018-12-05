Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:53210 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727339AbeLEWds (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Dec 2018 17:33:48 -0500
Date: Wed, 5 Dec 2018 23:33:46 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: use a dedicated SLAB cache for sector sized
 buffer data
Message-ID: <20181205223346.GA5145@lst.de>
References: <20181205172023.5061-1-hch@lst.de> <20181205215000.GU6311@dastard> <20181205215651.GA4033@lst.de> <20181205223139.GV6311@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181205223139.GV6311@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, tom.leiming@gmail.com, vkuznets@redhat.com

On Thu, Dec 06, 2018 at 09:31:39AM +1100, Dave Chinner wrote:
> > 
> > That's fine because log recovery is one I/O at a time, and we always
> > free the current buffer before allocating the next one, so we'd waste
> > the memory one way or another.
> 
> True. Can you mention this in the commit message so it gets recorded
> with the change and doesn't get lost in the mists of time?

How about a comment instead of the commit message?  Either way I can
document this decision for v2.
