Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B13497CA0
	for <xfs@oss.sgi.com>; Wed, 24 Aug 2016 19:48:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 80879304051
	for <xfs@oss.sgi.com>; Wed, 24 Aug 2016 17:48:32 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 8g28MEaXDfVHAmTO (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 24 Aug 2016 17:48:29 -0700 (PDT)
Date: Wed, 24 Aug 2016 17:48:22 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: "Bad page state" errors when calling BULKSTAT under memory
	pressure?
Message-ID: <20160825004631.GC20705@birch.djwong.org>
References: <20160824234237.GA22760@birch.djwong.org>
	<20160825003548.GD19025@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160825003548.GD19025@dastard>
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
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Thu, Aug 25, 2016 at 10:35:48AM +1000, Dave Chinner wrote:
> On Wed, Aug 24, 2016 at 04:42:37PM -0700, Darrick J. Wong wrote:
> > Hi everyone,
> > 
> > [cc'ing Brian because he was the last one to touch xfs_buf.c]
> > 
> > I've been stress-testing xfs_scrub against a 900GB filesystem with 2M inodes
> > using a VM with 512M of RAM.  I've noticed that I get BUG messages about
> > pages with negative refcount, but only if the system is under memory pressure.
> > No errors are seen if the VM memory is increased to, say, 20GB.
> > 
> > : BUG: Bad page state in process xfs_scrub  pfn:00426
> > : page:ffffea0000010980 count:-1 mapcount:0 mapping:          (null) index:0x0
> > : flags: 0x0()
> > : page dumped because: nonzero _count
> 
> Unless we are double-freeing a buffer, that's not an XFS problem.
> Have you tried with memory posioning and allocation debug turned on?

Yes.  The BUG did not reproduce, though it did take nearly 35min to run
scrub (which usually takes ~2min).

> > : Modules linked in: xfs libcrc32c sch_fq_codel af_packet
> > : CPU: 1 PID: 2058 Comm: xfs_scrub Not tainted 4.8.0-rc3-mcsum #18
> 
> the mm architecture was significantly modified in 4.8.0-rc1 - it
> went from per-zone to per-node infrastructure, so it's entirely
> possible this is a memory reclaim regression. can you reproduce it
> on an older kernel (e.g. 4.7.0)?

I'll try.  I noticed that it's easier to make it happen when scrub is
using getfsmap and/or the new in-kernel scrubbers, but that's no big
surprise since that means we're pounding harder on the metadata. :)

> > Obviously, a page refcount of -1 is not a good sign.  I had a hunch that
> > the page in question was (hopefully) a page backing an xfs_buf, so I
> > applied the following debug patch:
> > 
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index 607cc29..144b976 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -317,7 +317,7 @@ xfs_buf_free(
> >  
> >                 for (i = 0; i < bp->b_page_count; i++) {
> >                         struct page     *page = bp->b_pages[i];
> > -
> > +if (page_ref_count(page) != 1) {xfs_err(NULL, "%s: OHNO! daddr=%llu page=%p ref=%d", __func__, bp->b_bn, page, page_ref_count(page)); dump_stack();}
> >                         __free_page(page);
> >                 }
> >         } else if (bp->b_flags & _XBF_KMEM)
> > 
> > I then saw this:
> > 
> > : SGI XFS with ACLs, security attributes, realtime, debug enabled
> > : XFS (sda): Mounting V4 Filesystem
> > : XFS (sda): Ending clean mount
> > : XFS: xfs_buf_free: OHNO! daddr=113849120 page=ffffea0000010980 ref=0
> 
> Which implies something else has dropped the page reference count on
> us while we hold a reference to it. What you might like to check
> what the page reference counts are on /allocation/ to see if we're
> being handed a page from the freelist with a bad ref count....

Zero on allocation, except when we hit the BUG case.

> If the ref counts are good at allocation, but bad on free, then I
> very much doubt it's an XFS problem. We don't actually touch the
> page reference count anywhere, so let's make sure that it's not a
> double free or something like that in XFS first.

I couldn't find any smoking gun inside XFS, which is why I went to
the list -- I figured something must be doing something I don't know
about. :)

Anyway, I was going to push out the reflink patches for review, but
the scrubber crashing held me up.  Tomorrow, probably. :/

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
