Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:48709 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751236AbdH3HDe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2017 03:03:34 -0400
Date: Wed, 30 Aug 2017 00:03:29 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS reflinks
Message-ID: <20170830070329.GA7835@infradead.org>
References: <04eacb90-aac9-7c47-f074-fa91eb253822@bytemark.co.uk>
 <20170829130046.GA28896@infradead.org>
 <20170829160308.GR4757@magnolia>
 <20170829162310.GA22552@infradead.org>
 <20170829220316.GD10621@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170829220316.GD10621@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Chris Cottam <chris.cottam@bytemark.co.uk>, linux-xfs@vger.kernel.org

On Wed, Aug 30, 2017 at 08:03:16AM +1000, Dave Chinner wrote:
> Christoph, ignoring the CoW consideration, this is top of my list of
> "things we've been ignoring for too long that need to be fixed
> ASAP". I've got the time to work on this right now, so if you don't
> have time to get it done in the next merge cycle I can probably make
> that happen....

I've been working on it for a while, and it's not just spare time
but customer work.  I've finally found a data structure that fits,
and I've already posted various cleanups to isolate the extent list.

I'll have something ready to post in the next few weeks.
