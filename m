Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:1643 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751063AbcKFXVH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Nov 2016 18:21:07 -0500
Date: Mon, 7 Nov 2016 10:21:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: discard improvements
Message-ID: <20161106232102.GQ14023@dastard>
References: <1476735753-5861-1-git-send-email-hch@lst.de>
 <64a1c5dc-4a36-1ef6-606e-b382d36161ef@scylladb.com>
 <20161031151412.GA14804@lst.de>
 <5a50a07c-369d-1a41-2111-f9ee91ac7425@scylladb.com>
 <20161106163642.GB15675@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161106163642.GB15675@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Avi Kivity <avi@scylladb.com>, linux-xfs@vger.kernel.org, michaelcallahan@fb.com

On Sun, Nov 06, 2016 at 05:36:42PM +0100, Christoph Hellwig wrote:
> On Sat, Nov 05, 2016 at 08:18:05PM +0200, Avi Kivity wrote:
> > The big problem with "it depends" is that usually the information it 
> > depends on is not available, so the application has to rely on a human to 
> > guess correctly.  With the trend for machines to be managed by machines, 
> > it's really hard to get optimal performance.  So exposure of any 
> > information that can help to make a decision, including that the kernel can 
> > make good use of TRIM, will be very helpful.
> 
> I agree with you, but until devices tell us that their discard
> implementation sucks on their own there is not much I can help
> you there.

The problem is that we keep seeing cases where devices fail discards
because of firmware issues. These problems are not going away, and
it's just not the cheap SSDs that are the problem here.

e.g an 800GB Intel p3700 NVMe drive that was reported to the ext4
list last week that failed discard for all LBAs over 700GB. Whatever
the problem was, it was quietly fixed in a firmware update...

https://bugzilla.kernel.org/show_bug.cgi?id=186551

If we can't trust the high end enterprise SSDs to have a reliable
discard implementation, then discard will continue to be a "use at
your own risk" kind of feature...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
