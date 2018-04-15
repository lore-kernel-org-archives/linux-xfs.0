Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:46642 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751145AbeDOLLF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Apr 2018 07:11:05 -0400
Date: Sun, 15 Apr 2018 04:11:04 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] fs: xfs: Change return type to vm_fault_t
Message-ID: <20180415111104.GB25513@bombadil.infradead.org>
References: <20180414200530.GA20184@jordon-HP-15-Notebook-PC>
 <20180414215937.GH5572@dastard>
 <20180414222407.GA15294@bombadil.infradead.org>
 <20180415072121.GA13601@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180415072121.GA13601@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, Souptick Joarder <jrdr.linux@gmail.com>, darrick.wong@oracle.com, linux-xfs@vger.kernel.org

On Sun, Apr 15, 2018 at 12:21:21AM -0700, Christoph Hellwig wrote:
> On Sat, Apr 14, 2018 at 03:24:07PM -0700, Matthew Wilcox wrote:
> > On Sun, Apr 15, 2018 at 07:59:37AM +1000, Dave Chinner wrote:
> > > On Sun, Apr 15, 2018 at 01:35:30AM +0530, Souptick Joarder wrote:
> > > > Use new return type vm_fault_t for fault handlers.
> > > > 
> > > > Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
> > > > Reviewed-by: Matthew Wilcox <mawilcox@microsoft.com>
> > > 
> > > Ummm. Why are we adding typedefs to hide basic types?
> > > 
> > > typedef int vm_fault_t;
> > 
> > That's the intermediate step.  It's going to become a sparse typedef
> > like gfp_t once everything's converted.  And the "why" is that people
> > are still returning -EFOO when they should be returning VM_FAULT_FOO.
> 
> Please just send one damn patch adding the typedef and the sparse
> annotation and converting everyone over.  Splitting this into five
> gazillion patches that do nothing doesn't help anyone.

The XFS one is trivial.  Many of the others are not.
