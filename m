Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:56416 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725867AbfFNDIO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 23:08:14 -0400
Date: Fri, 14 Jun 2019 13:07:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC 00/10] RDMA/FS DAX truncate proposal
Message-ID: <20190614030712.GO14363@dread.disaster.area>
References: <20190607110426.GB12765@quack2.suse.cz>
 <20190607182534.GC14559@iweiny-DESK2.sc.intel.com>
 <20190608001036.GF14308@dread.disaster.area>
 <20190612123751.GD32656@bombadil.infradead.org>
 <20190613002555.GH14363@dread.disaster.area>
 <20190613152755.GI32656@bombadil.infradead.org>
 <20190613211321.GC32404@iweiny-DESK2.sc.intel.com>
 <20190613234530.GK22901@ziepe.ca>
 <20190614020921.GM14363@dread.disaster.area>
 <20190614023107.GK32656@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614023107.GK32656@bombadil.infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>, Dan Williams <dan.j.williams@intel.com>, Theodore Ts'o <tytso@mit.edu>, Jeff Layton <jlayton@kernel.org>, linux-xfs@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, John Hubbard <jhubbard@nvidia.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-rdma@vger.kernel.org

On Thu, Jun 13, 2019 at 07:31:07PM -0700, Matthew Wilcox wrote:
> On Fri, Jun 14, 2019 at 12:09:21PM +1000, Dave Chinner wrote:
> > If the lease holder modifies the mapping in a way that causes it's
> > own internal state to screw up, then that's a bug in the lease
> > holder application.
> 
> Sounds like the lease semantics aren't the right ones for the longterm
> GUP users then.  The point of the longterm GUP is so the pages can be
> written to, and if the filesystem is going to move the pages around when
> they're written to, that just won't work.

And now we go full circle back to the constraints we decided on long
ago because we can't rely on demand paging RDMA hardware any time
soon to do everything we need to transparently support long-term GUP
on file-backed mappings. i.e.:

	RDMA to file backed mappings must first preallocate and
	write zeros to the range of the file they are mapping so
	that the filesystem block mapping is complete and static for
	the life of the RDMA mapping that will pin it.

IOWs, the layout lease will tell the RDMA application that the
static setup it has already done  to work correctly with a file
backed mapping may be about to be broken by a third party.....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
