Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:33789 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753073AbeE3QLT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 May 2018 12:11:19 -0400
Date: Wed, 30 May 2018 18:17:40 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: iomap SEEK_HOLE / SEEK_DATA cleanups and generalization
Message-ID: <20180530161740.GA8385@lst.de>
References: <20180530100208.31490-1-hch@lst.de> <20180530160721.GB837@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180530160721.GB837@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Wed, May 30, 2018 at 09:07:21AM -0700, Darrick J. Wong wrote:
> On Wed, May 30, 2018 at 12:02:05PM +0200, Christoph Hellwig wrote:
> > Refactor the seek pagecache helpers to work independent of buffer_heads,
> > and clean up a few lose bits.
> > 
> > This is needed for the small blocksize buffered I/O support in iomap.
> 
> I added RVB tags to the previous version of this, but I guess they fell
> off?  Have these three patches changed considerably since v3?

They haven't changed at all.  So with the review from Andreas this might
be a good time to pull them in and get these patches off the backlog :)
