Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:47561 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750723AbdCGFJ6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 7 Mar 2017 00:09:58 -0500
Date: Tue, 7 Mar 2017 06:00:54 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: remove kmem_zalloc_greedy
Message-ID: <20170307050054.GB14000@lst.de>
References: <20170306184109.GC5280@birch.djwong.org> <20170307000754.GA9959@lst.de> <20170307001327.GC5281@birch.djwong.org> <20170307005420.GO17542@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170307005420.GO17542@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>, Michal Hocko <mhocko@kernel.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Xiong Zhou <xzhou@redhat.com>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Michal Hocko <mhocko@suse.com>

On Tue, Mar 07, 2017 at 11:54:20AM +1100, Dave Chinner wrote:
> > Or maybe I've misunderstood, and you're asking if we should try
> > kmem_zalloc(4 pages), then kmem_zalloc(1 page), and only then switch to
> > the __vmalloc calls?
> 
> Just call kmem_zalloc_large() for 4 pages without a fallback on
> failure - that's exactly how we handle allocations for things like
> the 64k xattr buffers....

Yeah, that sounds fine.  I didn't remember that we actually tried
kmalloc before vmalloc for kmem_zalloc_large.
