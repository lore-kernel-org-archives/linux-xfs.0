Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:40355 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752233AbdCGDpZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Mar 2017 22:45:25 -0500
Date: Mon, 6 Mar 2017 16:13:28 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: remove kmem_zalloc_greedy
Message-ID: <20170307001327.GC5281@birch.djwong.org>
References: <20170306184109.GC5280@birch.djwong.org>
 <20170307000754.GA9959@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170307000754.GA9959@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Brian Foster <bfoster@redhat.com>, Michal Hocko <mhocko@kernel.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Xiong Zhou <xzhou@redhat.com>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Michal Hocko <mhocko@suse.com>, Dave Chinner <david@fromorbit.com>

On Tue, Mar 07, 2017 at 01:07:54AM +0100, Christoph Hellwig wrote:
> I like killing it, but shouldn't we just try a normal kmem_zalloc?
> At least for the fallback it's the right thing, and even for an
> order 2 allocation it seems like a useful first try.

I'm confused -- kmem_zalloc_large tries kmem_zalloc with KM_MAYFAIL and
only falls back to __vmalloc if it doesn't get anything.

Or maybe I've misunderstood, and you're asking if we should try
kmem_zalloc(4 pages), then kmem_zalloc(1 page), and only then switch to
the __vmalloc calls?

--D
