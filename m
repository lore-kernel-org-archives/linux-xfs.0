Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 573D17F4E
	for <xfs@oss.sgi.com>; Fri, 30 Oct 2015 14:43:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 45AD4304066
	for <xfs@oss.sgi.com>; Fri, 30 Oct 2015 12:43:04 -0700 (PDT)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65]) by
	cuda.sgi.com with ESMTP id eQQwBjRqrww73WW4 for
	<xfs@oss.sgi.com>; Fri, 30 Oct 2015 12:43:02 -0700 (PDT)
Date: Fri, 30 Oct 2015 13:43:00 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [RFC 00/11] DAX fsynx/msync support
Message-ID: <20151030194300.GA22670@linux.intel.com>
References: <1446149535-16200-1-git-send-email-ross.zwisler@linux.intel.com>
	<CAPcyv4haGNytokPfgL3m-qOEw=BO4QF5dO3woLSYZDCRmL-YWg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4haGNytokPfgL3m-qOEw=BO4QF5dO3woLSYZDCRmL-YWg@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: X86 ML <x86@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Jan Kara <jack@suse.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Linux MM <linux-mm@kvack.org>, Ingo Molnar <mingo@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, Matthew Wilcox <matthew.r.wilcox@intel.com>

On Fri, Oct 30, 2015 at 11:34:07AM -0700, Dan Williams wrote:
> On Thu, Oct 29, 2015 at 1:12 PM, Ross Zwisler
> <ross.zwisler@linux.intel.com> wrote:
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
> >
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
> >   dax: add support for fsync/sync
> >   xfs, ext2: call dax_pfn_mkwrite() on write fault
> >   ext4: add ext4_dax_pfn_mkwrite()
> 
> This is great to have when the flush-the-world solution ends up
> killing performance.  However, there are a couple mitigating options
> for workloads that dirty small amounts and flush often that we need to
> collect data on:
> 
> 1/ Using cache management and pcommit from userspace to skip calls to
> msync / fsync.  Although, this does not eliminate all calls to
> blkdev_issue_flush as the fs may invoke it for other reasons.  I
> suspect turning on REQ_FUA support eliminates a number of those
> invocations, and pmem already satisfies REQ_FUA semantics by default.

Sure, I'll turn on REQ_FUA in addition to REQ_FLUSH - I agree that PMEM
already handles the requirements of REQ_FUA, but I didn't realize that it
might reduce the number of REQ_FLUSH bios we receive.

> 2/ Turn off DAX and use the page cache.  As Dave mentions [1] we
> should enable this control on a per-inode basis.  I'm folding in this
> capability as a blkdev_ioctl for the next version of the raw block DAX
> support patch.

Umm...I think you just said "the way to avoid this delay is to just not use
DAX".  :)  I don't think this is where we want to go - we are trying to make
DAX better, not abandon it.

> It's entirely possible these mitigations won't eliminate the need for
> a mechanism like this, but I think we have a bit more work to do to
> find out how bad this is in practice as well as the crossover point
> where walking the radix becomes prohibitive.

I'm guessing a single run through xfstests will be enough to convince you that
the "big hammer" approach is untenable.  Tests that used to take a second now
take several minutes, at least in my VM testing environment...  And that's
only using a tiny 4GiB namespace.

Yes, we can distribute the cost over multiple CPUs, but that just distributes
the problem and doesn't reduce the overall work that needs to be done.
Ultimately I think that looping through multiple GiB or even TiB of cache
lines and blindly writing them back individually on every REQ_FLUSH is going
to be a deal breaker.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
