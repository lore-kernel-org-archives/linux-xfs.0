Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5E2237CA3
	for <xfs@oss.sgi.com>; Tue, 26 Jan 2016 08:47:57 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DD34CAC007
	for <xfs@oss.sgi.com>; Tue, 26 Jan 2016 06:47:56 -0800 (PST)
Received: from mga14.intel.com ([192.55.52.115]) by cuda.sgi.com with ESMTP id
	W1FLtQjuMC7ktrgl for <xfs@oss.sgi.com>;
	Tue, 26 Jan 2016 06:47:49 -0800 (PST)
Date: Tue, 26 Jan 2016 09:47:46 -0500
From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [RFC PATCH] dax, ext2, ext4, XFS: fix data corruption race
Message-ID: <20160126144746.GL2948@linux.intel.com>
References: <1453503971-5319-1-git-send-email-ross.zwisler@linux.intel.com>
	<20160124220107.GI20456@dastard>
	<20160125135921.GE24938@quack.suse.cz>
	<20160126124812.GJ2948@linux.intel.com>
	<20160126130521.GB23820@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160126130521.GB23820@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>

On Tue, Jan 26, 2016 at 02:05:21PM +0100, Jan Kara wrote:
> On Tue 26-01-16 07:48:12, Matthew Wilcox wrote:
> > I *think* that what Dave's proposing (and if he isn't, I'm proposing it
> > for him) is that the filesystem takes its allocation lock shared during
> > the ->fault handler, then in the ->page_mkwrite handler, it knows that an
> > allocation is coming, so it takes its allocation lock in exclusive mode.
> > 
> > So read vs write faults won't be able to race because the allocation lock
> > will prevent it.
> 
> So this is correct and clean design but we will take the lock in exclusive
> mode (and thus hurt scalability) for every write fault, not just for the
> ones allocating blocks. And at the moment we take exclusive lock for write
> faults, there's no more need for having the hole page instantiated - we can
> still do it for simplicity but it's no longer necessary to avoid data
> corruption.

In my mind we take it only for allocating writes, because we also include
the patch to insert PFNs with the writable bit set in the dax_fault
handler if the page fault was for writes.

Although that only works when the *first* fault is a write ... if we
read and page then write the same page, we will indeed take the lock
in exclusive mode.  I think that's fixable too -- in the page_mkwrite
handler, take the lock in exclusive mode only if there's a page in the
radix tree.  I'll take a look at that optimisation after doing the first
couple of steps.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
