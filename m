Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:47302 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751430AbeEPQYR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 May 2018 12:24:17 -0400
Date: Wed, 16 May 2018 09:24:15 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] iomap: don't allow holes in swapfiles
Message-ID: <20180516162415.GB21071@infradead.org>
References: <e722c29f7291b9c31533fd8b2e84d7f469c3ac88.1526452889.git.osandov@fb.com>
 <20180516155000.GC23858@magnolia>
 <20180516155146.GA8294@infradead.org>
 <20180516155638.GD23858@magnolia>
 <20180516161955.GA14174@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180516161955.GA14174@vader>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Omar Sandoval <osandov@osandov.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, Aleksei Besogonov <cyberax@amazon.com>

On Wed, May 16, 2018 at 09:19:55AM -0700, Omar Sandoval wrote:
> > > Wasn't the desire to support holes the rationale for the Aleksei
> > > version of the iomap swapfile patch?
> > 
> > Ah, so it was.  FWIW I'm not sure why you'd /want/ a holey swapfile?
> 
> >From reading the old thread, it looks like Aleksei just wanted
> fallocated swap files to work: "I've traced the problem to bmap(), used
> in generic_swapfile_activate call, which returns 0 for blocks inside
> holes created by fallocate".

Oh, that makes more sense.

> Are holes in that sense are different from
> actual holes in the iomap sense?

Unwritten extents aren't actually holes in any sense, so they are
very different and should work with the iomap swapfile code.
