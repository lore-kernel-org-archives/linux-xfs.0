Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55510 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750759AbeEPSWY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 May 2018 14:22:24 -0400
Date: Wed, 16 May 2018 11:22:22 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 1/2] iomap: provide more useful errors for invalid
 swap files
Message-ID: <20180516182222.GA21917@infradead.org>
References: <cover.1526488995.git.osandov@fb.com>
 <9faf09627cfa469437b76edb73ac7cc822dc33c8.1526488995.git.osandov@fb.com>
 <20180516172531.GA13464@infradead.org>
 <20180516173251.GA29231@vader>
 <20180516174645.GA8815@infradead.org>
 <20180516181142.GK23858@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180516181142.GK23858@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Omar Sandoval <osandov@osandov.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, Aleksei Besogonov <cyberax@amazon.com>, kernel-team@fb.com

On Wed, May 16, 2018 at 11:11:42AM -0700, Darrick J. Wong wrote:
> That's what I thought -- we only see NULL_ADDR for holes and delalloc
> extents, and we already check for both of those.  But I didn't see
> anything in iomap.h expressly saying that, so I decided to be defensive
> and check it anyway.
> 
> IOWs it would be helpful to have a little more documentation about which
> flags go together,

patches welcome :)

> particularly for things like IOMAP_F_BOUNDARY that
> don't have any meaning in xfs.

Yikes, how did that even end in the tree?  That whole boundary
thing already made little sene on buffer heads, and even less
so in the generic iomap code.  I think we just need to allocate
a few flags for fs specific uses and move it into gfs2.

