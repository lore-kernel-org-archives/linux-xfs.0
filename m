Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 337FF7F37
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 18:22:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 128AC8F8052
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 16:22:27 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	kbrmAeQoo9wVFsDD for <xfs@oss.sgi.com>;
	Tue, 06 Oct 2015 16:22:25 -0700 (PDT)
Date: Wed, 7 Oct 2015 10:22:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: two failing xfstests using xfs (no DAX)
Message-ID: <20151006232223.GQ27164@dastard>
References: <20151002174941.GA25082@linux.intel.com>
	<20151002223402.GM27164@dastard>
	<20151006143854.GA63205@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151006143854.GA63205@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, xfs@oss.sgi.com

On Tue, Oct 06, 2015 at 10:38:54AM -0400, Brian Foster wrote:
> On Sat, Oct 03, 2015 at 08:34:02AM +1000, Dave Chinner wrote:
> > On Fri, Oct 02, 2015 at 11:49:41AM -0600, Ross Zwisler wrote:
> > > Recently I've been trying to get a stable baseline for my DAX testing using
> > > various filesystems, and in doing so I noticed a pair of tests that were
> > > behaving badly when run on XFS without DAX.  These test failures happen in
> > > both v4.2 and v4.3-rc3, though the signatures may vary a bit.
> > > 
> > > My testing setup is a kvm virtual machine with 8 GiB of its 16GiB of memory
> > > reserved for PMEM using the mmap parameter (memmap=8G!8G) and with the
> > > CONFIG_X86_PMEM_LEGACY config option enabled.  I've attached my full kernel
> > > config to this mail.
> > > 
> > > The first test failure is generic/299, which consistently deadlocks in the XFS
> > > code in both v4.2 and v4.3-rc3.  The stack traces presented in dmesg via "echo
> > > w > /proc/sysrq-trigger" are consistent between these two kernel versions, and
> > > can be found in the "generic_299.deadlock" attachment.
> > 
> > Yes, we've recently identified a AGF locking order problem on an
> > older kernel that this looks like. We haven't found the root cause
> > of it yet, but it's good to know that generic/299 seems to reproduce
> > it. I'll run that in a loop to see if I can get it to fail here...
> > 
> 
> First off, a quick rundown of where we're at so far:
> 
> - The deadlock occurs because a dio/aio write attempts a reverse ordered
>   agf lock (e.g., lock agf3 -> lock agf0, assuming agcount == 4) and
>   races with a truncate (doing something likelock agf0 -> agf3).
> - The reverse ordered agf lock occurs in xfs_alloc_vextent() because
>   xfs_alloc_space_available() (via xfs_alloc_fix_freelist()) indicates
>   an AG can support an allocation, but subsequently fails to allocate
>   later on in xfs_alloc_fix_minleft(). This causes the higher level code
>   in xfs_alloc_vextent to wrap around to ag 0 when it should have either
>   not locked ag3 or successfully allocated.
> 
> I pointed out that xfs_alloc_space_available() appears to incorporate
> agf_flcount whereas xfs_alloc_fix_minleft() does not. Dave subsequently
> pointed out that the flcount is factored out of the former via the
> 'min_free' parameter, so this calculation is actually consistent with
> respect to the free list count.

[snip]

> On the contrary, the call from xfs_alloc_file_space() passes a 0 similar
> to the iomap_write_direct() case. Furthermore, the xfs_bmap_btalloc()
> code can set (or reset) args.total to minlen internally based on a free
> list flag. Given the documentation for xbf_low, perhaps this code
> assumes args.total > args.minlen and is effectively "resetting" it to
> the minimum length? If so, that suggests that the 1/0 callers are the
> incorrect callers and should be fixed to incorporate the extent
> length..?

That's what it looks like. As discussed on #xfs, these hardcoded
values have been there since the initial direct IO commit back in
1994, though it's changed from 0 to 1 and back to zero over the
course of the linux port from Irix. Basically it looks like these
0/1 magic numbers have been cargo culted since their undocumented
introduction back in 1994...

I think the correct thing to do right now is to fix all of these
xfs_bmapi_write() call sites to pass in the block count expected to
be allocated during the operation as it appears the lower layers
expect it to be set appropriately for the allocation being done...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
