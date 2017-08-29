Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:3983 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751218AbdH2Mba (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 08:31:30 -0400
Date: Tue, 29 Aug 2017 22:31:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 15/30] xfs: Define usercopy region in xfs_inode slab
 cache
Message-ID: <20170829123126.GB10621@dastard>
References: <1503956111-36652-1-git-send-email-keescook@chromium.org>
 <1503956111-36652-16-git-send-email-keescook@chromium.org>
 <20170829081453.GA10196@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170829081453.GA10196@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, David Windsor <dave@nullcore.net>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com

On Tue, Aug 29, 2017 at 01:14:53AM -0700, Christoph Hellwig wrote:
> One thing I've been wondering is wether we should actually just
> get rid of the online area.  Compared to reading an inode from
> disk a single additional kmalloc is negligible, and not having the
> inline data / extent list would allow us to reduce the inode size
> significantly.

Probably should.  I've already been looking at killing the inline
extents array to simplify the management of the extent list (much
simpler to index by rbtree when we don't have direct/indirect
structures), so killing the inline data would get rid of the other
part of the union the inline data sits in.

OTOH, if we're going to have to dynamically allocate the memory for
the extent/inline data for the data fork, it may just be easier to
make the entire data fork a dynamic allocation (like the attr fork).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
