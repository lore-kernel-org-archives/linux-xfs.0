Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:54237 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754684AbdCGA5v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Mar 2017 19:57:51 -0500
Date: Tue, 7 Mar 2017 11:54:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: remove kmem_zalloc_greedy
Message-ID: <20170307005420.GO17542@dastard>
References: <20170306184109.GC5280@birch.djwong.org>
 <20170307000754.GA9959@lst.de>
 <20170307001327.GC5281@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170307001327.GC5281@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>, Michal Hocko <mhocko@kernel.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Xiong Zhou <xzhou@redhat.com>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Michal Hocko <mhocko@suse.com>

On Mon, Mar 06, 2017 at 04:13:28PM -0800, Darrick J. Wong wrote:
> On Tue, Mar 07, 2017 at 01:07:54AM +0100, Christoph Hellwig wrote:
> > I like killing it, but shouldn't we just try a normal kmem_zalloc?
> > At least for the fallback it's the right thing, and even for an
> > order 2 allocation it seems like a useful first try.
> 
> I'm confused -- kmem_zalloc_large tries kmem_zalloc with KM_MAYFAIL and
> only falls back to __vmalloc if it doesn't get anything.

Yup, that's right.

> Or maybe I've misunderstood, and you're asking if we should try
> kmem_zalloc(4 pages), then kmem_zalloc(1 page), and only then switch to
> the __vmalloc calls?

Just call kmem_zalloc_large() for 4 pages without a fallback on
failure - that's exactly how we handle allocations for things like
the 64k xattr buffers....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
