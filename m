Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail02.adl2.internode.on.net ([150.101.137.139]:37776 "EHLO
        ipmail02.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728227AbeGaJp4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jul 2018 05:45:56 -0400
Date: Tue, 31 Jul 2018 18:06:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] misc: remove COPYING from doc/ Makefile
Message-ID: <20180731080646.GF2234@dastard>
References: <e4d64c9b-5a1a-54b5-8b69-463738c95307@redhat.com>
 <20180731074313.GA19990@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180731074313.GA19990@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Jul 31, 2018 at 12:43:13AM -0700, Christoph Hellwig wrote:
> On Mon, Jul 30, 2018 at 10:41:54PM -0500, Eric Sandeen wrote:
> > COPYING is gone now, so make doc-install breaks.
> > 
> > Fixes: 959ef98 ("xfsprogs: convert to SPDX license tags")
> > 
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> The patch itself looks good, but I think we have a deeper problem,
> in that there is no actual license information anywhere in xfsprogs now.
> 
> We need to fix that up similar to the LICENSES/ directory in the kernel.
> SPDX tags are good and nice, but without an explanation what they mean
> in the same source tree they are useless.

Sorry, what? I added that as part of my spdx conversion patch. That
patch also removed the COPYING file.

How did these changes get merged? I sent a pull request to convert
everything in xfsprogs and that had all the correct conversions and
documentation in it. here's the pull request:

https://marc.info/?l=linux-xfs&m=152948738523911&w=2

and you can see from the diffstat it did all this stuff...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
