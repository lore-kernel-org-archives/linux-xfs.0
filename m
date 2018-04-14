Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:52760 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752053AbeDNWYI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 14 Apr 2018 18:24:08 -0400
Date: Sat, 14 Apr 2018 15:24:07 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] fs: xfs: Change return type to vm_fault_t
Message-ID: <20180414222407.GA15294@bombadil.infradead.org>
References: <20180414200530.GA20184@jordon-HP-15-Notebook-PC>
 <20180414215937.GH5572@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180414215937.GH5572@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Souptick Joarder <jrdr.linux@gmail.com>, darrick.wong@oracle.com, linux-xfs@vger.kernel.org

On Sun, Apr 15, 2018 at 07:59:37AM +1000, Dave Chinner wrote:
> On Sun, Apr 15, 2018 at 01:35:30AM +0530, Souptick Joarder wrote:
> > Use new return type vm_fault_t for fault handlers.
> > 
> > Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
> > Reviewed-by: Matthew Wilcox <mawilcox@microsoft.com>
> 
> Ummm. Why are we adding typedefs to hide basic types?
> 
> typedef int vm_fault_t;

That's the intermediate step.  It's going to become a sparse typedef
like gfp_t once everything's converted.  And the "why" is that people
are still returning -EFOO when they should be returning VM_FAULT_FOO.
