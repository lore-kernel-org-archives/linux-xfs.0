Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:63531 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750718AbdIEGob (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Sep 2017 02:44:31 -0400
Date: Tue, 5 Sep 2017 16:44:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mkfs: Remove messages printed when blocksize < physical
 sectorsize
Message-ID: <20170905064412.GK17782@dastard>
References: <20170905054442.28615-1-chandan@linux.vnet.ibm.com>
 <20170905063139.GA679@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170905063139.GA679@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, sandeen@sandeen.net, Omar Sandoval <osandov@fb.com>, linux-block@vger.kernel.org

On Mon, Sep 04, 2017 at 11:31:39PM -0700, Christoph Hellwig wrote:
> On Tue, Sep 05, 2017 at 11:14:42AM +0530, Chandan Rajendra wrote:
> > Linux kernel commit 6c6b6f28b3335fd85ec833ee0005d9c9dca6c003 (loop: set
> > physical block size to PAGE_SIZE) now sets PAGE_SIZE as the default
> > physical sector size of loop devices. On ppc64, this causes loop devices
> > to have 64k as the physical sector size.
> 
> Eek.  We'll need to revert the loop change ASAP!

And, FWIW, making the warning go away if probably a bad idea,
because XFS only supports devices with sector sizes up
to 32k:

#define XFS_MIN_SECTORSIZE_LOG  9       /* i.e. 512 bytes */
#define XFS_MAX_SECTORSIZE_LOG  15      /* i.e. 32768 bytes */

And so it should be warning about devices trying to tell it to use
something larger....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
