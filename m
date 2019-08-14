Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:55107 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725905AbfHNIG5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Aug 2019 04:06:57 -0400
Date: Wed, 14 Aug 2019 18:05:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH v2 01/19] fs/locks: Export F_LAYOUT lease to user
 space
Message-ID: <20190814080547.GJ6129@dread.disaster.area>
References: <20190809225833.6657-1-ira.weiny@intel.com>
 <20190809225833.6657-2-ira.weiny@intel.com>
 <20190809235231.GC7777@dread.disaster.area>
 <20190812173626.GB19746@iweiny-DESK2.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190812173626.GB19746@iweiny-DESK2.sc.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ira Weiny <ira.weiny@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>, John Hubbard <jhubbard@nvidia.com>, Michal Hocko <mhocko@suse.com>, linux-xfs@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-ext4@vger.kernel.org, linux-mm@kvack.org

On Mon, Aug 12, 2019 at 10:36:26AM -0700, Ira Weiny wrote:
> On Sat, Aug 10, 2019 at 09:52:31AM +1000, Dave Chinner wrote:
> > On Fri, Aug 09, 2019 at 03:58:15PM -0700, ira.weiny@intel.com wrote:
> > > +	/*
> > > +	 * NOTE on F_LAYOUT lease
> > > +	 *
> > > +	 * LAYOUT lease types are taken on files which the user knows that
> > > +	 * they will be pinning in memory for some indeterminate amount of
> > > +	 * time.
> > 
> > Indeed, layout leases have nothing to do with pinning of memory.
> 
> Yep, Fair enough.  I'll rework the comment.
> 
> > That's something an application taht uses layout leases might do,
> > but it largely irrelevant to the functionality layout leases
> > provide. What needs to be done here is explain what the layout lease
> > API actually guarantees w.r.t. the physical file layout, not what
> > some application is going to do with a lease. e.g.
> > 
> > 	The layout lease F_RDLCK guarantees that the holder will be
> > 	notified that the physical file layout is about to be
> > 	changed, and that it needs to release any resources it has
> > 	over the range of this lease, drop the lease and then
> > 	request it again to wait for the kernel to finish whatever
> > 	it is doing on that range.
> > 
> > 	The layout lease F_RDLCK also allows the holder to modify
> > 	the physical layout of the file. If an operation from the
> > 	lease holder occurs that would modify the layout, that lease
> > 	holder does not get notification that a change will occur,
> > 	but it will block until all other F_RDLCK leases have been
> > 	released by their holders before going ahead.
> > 
> > 	If there is a F_WRLCK lease held on the file, then a F_RDLCK
> > 	holder will fail any operation that may modify the physical
> > 	layout of the file. F_WRLCK provides exclusive physical
> > 	modification access to the holder, guaranteeing nothing else
> > 	will change the layout of the file while it holds the lease.
> > 
> > 	The F_WRLCK holder can change the physical layout of the
> > 	file if it so desires, this will block while F_RDLCK holders
> > 	are notified and release their leases before the
> > 	modification will take place.
> > 
> > We need to define the semantics we expose to userspace first.....
> 
> Agreed.  I believe I have implemented the semantics you describe above.  Do I
> have your permission to use your verbiage as part of reworking the comment and
> commit message?

Of course. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
