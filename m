Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56556 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfDWGYs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Apr 2019 02:24:48 -0400
Date: Mon, 22 Apr 2019 23:24:47 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: make tr_growdata a permanent transaction
Message-ID: <20190423062447.GE28518@infradead.org>
References: <20190417093608.17146-1-bfoster@redhat.com>
 <20190417143759.GG114154@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190417143759.GG114154@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Wed, Apr 17, 2019 at 07:37:59AM -0700, Darrick J. Wong wrote:
> 
> /me wonders if we ought to have a comment here about why we're asserting
> on this? i.e.
> /*
>  * This function can shrink the AGFL, which uses a deferred op to avoid
>  * exceeding transaction reservation (or whatever the original reason
>  * was).  Deferred ops require a transaction with a permanent
>  * reservation, so check that here.
>  */
> ASSERT(...);

Yes, I think we should.  Also I think adding this assert should be
a separate commit from the original fix to even more clearly document
the intention.
