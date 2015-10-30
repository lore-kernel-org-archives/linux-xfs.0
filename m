Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A2B257F4E
	for <xfs@oss.sgi.com>; Fri, 30 Oct 2015 13:39:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6EC318F8064
	for <xfs@oss.sgi.com>; Fri, 30 Oct 2015 11:39:42 -0700 (PDT)
Received: from mga14.intel.com ([192.55.52.115]) by cuda.sgi.com with ESMTP id
	O6TevWMNCAyp1tcY for <xfs@oss.sgi.com>;
	Fri, 30 Oct 2015 11:39:40 -0700 (PDT)
Date: Fri, 30 Oct 2015 12:39:38 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [RFC 00/11] DAX fsynx/msync support
Message-ID: <20151030183938.GC24643@linux.intel.com>
References: <1446149535-16200-1-git-send-email-ross.zwisler@linux.intel.com>
	<20151030035533.GU19199@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151030035533.GU19199@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Jeff Layton <jlayton@poochiereds.net>, x86@kernel.org, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, linux-nvdimm@lists.01.org, Jan Kara <jack@suse.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>

On Fri, Oct 30, 2015 at 02:55:33PM +1100, Dave Chinner wrote:
> On Thu, Oct 29, 2015 at 02:12:04PM -0600, Ross Zwisler wrote:
> > This patch series adds support for fsync/msync to DAX.
> > 
> > Patches 1 through 8 add various utilities that the DAX code will eventually
> > need, and the DAX code itself is added by patch 9.  Patches 10 and 11 are
> > filesystem changes that are needed after the DAX code is added, but these
> > patches may change slightly as the filesystem fault handling for DAX is
> > being modified ([1] and [2]).
> > 
> > I've marked this series as RFC because I'm still testing, but I wanted to
> > get this out there so people would see the direction I was going and
> > hopefully comment on any big red flags sooner rather than later.
> > 
> > I realize that we are getting pretty dang close to the v4.4 merge window,
> > but I think that if we can get this reviewed and working it's a much better
> > solution than the "big hammer" approach that blindly flushes entire PMEM
> > namespaces [3].
> 
> We need the "big hammer" regardless of fsync. If REQ_FLUSH and
> REQ_FUA don't do the right thing when it comes to ordering journal
> writes against other IO operations, then the filesystems are not
> crash safe. i.e. we need REQ_FLUSH/REQ_FUA to commit all outstanding
> changes back to stable storage, just like they do for existing
> storage....

I think that what I've got here (when it's fully working) will protect all the
cases that we need.

AFAIK there are three ways that data can be written to a PMEM namespace:

1) Through the PMEM driver via either pmem_make_request(), pmem_rw_page() or
pmem_rw_bytes().  All of these paths sync the newly written data durably to
media before the I/O completes so they shouldn't have any reliance on
REQ_FUA/REQ_FLUSH.

2) Through the DAX I/O path, dax_io().  As with PMEM we flush the newly
written data durably to media before the I/O operation completes, so this path
shouldn't have any reliance on REQ_FUA/REQ_FLUSH.

3) Through mmaps set up by DAX.  This is the path we are trying to protect
with the dirty page tracking and flushing in this patch set, and I think that
this is the only path that has reliance on REQ_FLUSH.

The goal of this set is to have the cache writeback all happen as part of the
fsync/msync handling, and then have the REQ_FLUSH just provide the trailing
wmb_pmem().

My guess is that XFS metadata writes happen via path 1), down through the PMEM
driver.  Am I missing anything, or should we be good to go?

> > [1] http://oss.sgi.com/archives/xfs/2015-10/msg00523.html
> > [2] http://marc.info/?l=linux-ext4&m=144550211312472&w=2
> > [3] https://lists.01.org/pipermail/linux-nvdimm/2015-October/002614.html
> > 
> > Ross Zwisler (11):
> >   pmem: add wb_cache_pmem() to the PMEM API
> >   mm: add pmd_mkclean()
> >   pmem: enable REQ_FLUSH handling
> >   dax: support dirty DAX entries in radix tree
> >   mm: add follow_pte_pmd()
> >   mm: add pgoff_mkclean()
> >   mm: add find_get_entries_tag()
> >   fs: add get_block() to struct inode_operations
> 
> I don't think this is the right thing to do - it propagates the use
> of bufferheads as a mapping structure into places where we do not
> want bufferheads. We've recently added a similar block mapping
> interface to the export operations structure for PNFS and that uses
> a "struct iomap" which is far more suited to being an inode
> operation this.
> 
> We have plans to move this to the inode operations for various
> reasons. e.g: multipage write, adding interfaces that support proper
> mapping of holes, etc:
> 
> https://www.redhat.com/archives/cluster-devel/2014-October/msg00167.html
> 
> So after many years of saying no to moving getblocks to the inode
> operations it seems like the wrong thing to do now considering I
> want to convert all the DAX code to use iomaps while only 2/3
> filesystems are supported...

Okay, I'll take a look at this interface.  I also think that we may need to
flow through the filesystem before going into the DAX code so that we can
serialize our flushing with respect to extent manipulation, as we had to do
with our DAX fault paths.  

> >   dax: add support for fsync/sync
> 
> Why put the dax_flush_mapping() in do_writepages()? Why not call it
> directly from the filesystem ->fsync() implementations where a
> getblocks callback could also be provided?

Because that's where you put it in your example. :)

https://lists.01.org/pipermail/linux-nvdimm/2015-March/000341.html

Moving it into the filesystem where we know about get_block() is probably the
right thing to do - I'll check it out.  Thanks!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
