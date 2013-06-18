Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F0FFA7CBF
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 16:12:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D46058F8037
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 14:12:04 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	AZqtRJvjDYeQZ4Ur for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 14:12:03 -0700 (PDT)
Date: Wed, 19 Jun 2013 06:55:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 19/27] xfs: consolidate xfs_vnodeops.c into xfs_inode_ops.c
Message-ID: <20130618205523.GV29338@dastard>
References: <1371032567-21772-1-git-send-email-david@fromorbit.com>
	<1371032567-21772-20-git-send-email-david@fromorbit.com>
	<20130612135916.GA28988@infradead.org>
	<20130613013907.GC29338@dastard>
	<20130617160228.GB26043@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130617160228.GB26043@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Jun 17, 2013 at 09:02:28AM -0700, Christoph Hellwig wrote:
> On Thu, Jun 13, 2013 at 11:39:07AM +1000, Dave Chinner wrote:
> > i.e:
> > 
> > 	kernel only -> kernel only -> shared with libxfs
> > 
> > Once there's a clear boundary in the kernel code,
> > merging/simplifying stuff on either side of the boundary is easy to
> > do, but it's a secondary step. I'd consider this something for the
> > 3.12 cycle, not the upcoming 3.11 cycle.
> 
> Much better.
> 
> Btw, especially in inode land we should probably share even less code
> with userspace.  Besides my old patches to kill the struct xfs_inode
> abuse in repair phase 7 there isn't too much use of it left.

Yup - we only need to shared the format defintions, the buffer
operations and the inode fork macros. That's explicity all that is
shared after my current patchset.

FWIW, my current patchset does this to the xfsprogs/include
directory:

43 files changed, 1541 insertions(+), 3527 deletions(-)

So that will give you an idea of how much __KERNEL__ crap there
is...

> The db code uses inodes as temporary objects in the attrset code which
> looks everything but efficient, and the mkfs and repair code use it to
> create new files/directories.  Not quite sure bringing in all the kernel
> code there makes so much sense given that we have other infrastructure
> for a lot of these in userspace anyway.

There's plenty that can be done there, but I think the direction we
need to take db in is to be closer to libxfs than it's own special
little snowflake. We need to do this for the IO subsystem to add CRC
validation/calculation support, so re-using anything that libxfs
already provides seems sane to me...

> > FWIW, now that I have the shared files in almost perfect sync, it
> > makes it much easier to make the change in the kernel tree, take the
> > patch, apply a couple of sed filters to it and then apply it
> > directly to the xfsprogs tree. I only have to do the work once now,
> > and so it's much faster to restructure the code now.
> 
> I'm very happy to see this as I'd been aiming at it for a while.
> 
> Any chance you can add a script to pull in kernel changes automatically
> while you're at it?

It's not quite there yet, but getting close. I'm not sure we can get
to automating it without having the same libxfs/ structure in the
kernel code - it's not straight forward to identify which hunks of a
patch are relevant to userspace...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
