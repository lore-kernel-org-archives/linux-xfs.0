Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:60810 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751364AbdGSHgp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 Jul 2017 03:36:45 -0400
Date: Wed, 19 Jul 2017 09:36:43 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH, RFC] xfs: fix multi-AG deadlock in xfs_bunmapi
Message-ID: <20170719073643.GA21259@lst.de>
References: <20170718172545.18065-1-hch@lst.de> <20170718181535.GJ4224@magnolia> <f53783a8-3b92-4b07-2d94-e60eb7d878bc@gmail.com> <20170718183351.GK4224@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170718183351.GK4224@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Nikolay Borisov <n.borisov.lkml@gmail.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Tue, Jul 18, 2017 at 11:33:51AM -0700, Darrick J. Wong wrote:
> On Tue, Jul 18, 2017 at 09:27:43PM +0300, Nikolay Borisov wrote:
> > 
> > 
> > On 18.07.2017 21:15, Darrick J. Wong wrote:
> > > On Tue, Jul 18, 2017 at 07:25:45PM +0200, Christoph Hellwig wrote:
> > >> Just like in the allocator we must avoid touching multiple AGs out of
> > >> order when freeing blocks, as freeing still locks the AGF and can cause
> > >> the same AB-BA deadlocks as in the allocation path.
> > >>
> > >> Signed-off-by: Christoph Hellwig <hch@lst.de>
> > >> Reported-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
> > > 
> > > Looks ok, though I wonder what the bug report looked like. :)
> > 
> > https://www.spinics.net/lists/linux-xfs/msg05918.html
> 
> Ah, ok.  That's what I suspected, so I'm glad to have confirmation.

Btw, I found a little bug when rebasing additional bunmapi work on
top of the patch - we need to add a !isrt to the conditional for
the AG check.  But I'll wait for test results from Nikolay before
resending it, as it should not affect normal non-RT setups.
