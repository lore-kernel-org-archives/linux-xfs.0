Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:36566 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727673AbfDWPFh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Apr 2019 11:05:37 -0400
Date: Tue, 23 Apr 2019 08:04:55 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: make tr_growdata a permanent transaction
Message-ID: <20190423150455.GF4676@magnolia>
References: <20190417093608.17146-1-bfoster@redhat.com>
 <20190417143759.GG114154@magnolia>
 <20190423062447.GE28518@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190423062447.GE28518@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Mon, Apr 22, 2019 at 11:24:47PM -0700, Christoph Hellwig wrote:
> On Wed, Apr 17, 2019 at 07:37:59AM -0700, Darrick J. Wong wrote:
> > 
> > /me wonders if we ought to have a comment here about why we're asserting
> > on this? i.e.
> > /*
> >  * This function can shrink the AGFL, which uses a deferred op to avoid
> >  * exceeding transaction reservation (or whatever the original reason
> >  * was).  Deferred ops require a transaction with a permanent
> >  * reservation, so check that here.
> >  */
> > ASSERT(...);
> 
> Yes, I think we should.  Also I think adding this assert should be
> a separate commit from the original fix to even more clearly document
> the intention.

<shrug> OK.  I chatted with Brian and we'll just split the assert into a
new patch...  eh, this patch has changed enough I'm going to send both
of them to the list for everyone's perusal.  (I'd already added them to
my tree, but having not pushed to for-next it isn't too late to make
more changes.)

--D
