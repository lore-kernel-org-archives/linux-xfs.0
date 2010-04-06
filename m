Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o36NHITI143195 for <xfs@oss.sgi.com>; Tue, 6 Apr 2010 18:17:18 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 339181D3D920
	for <xfs@oss.sgi.com>; Tue,  6 Apr 2010 16:19:07 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	8NOIoNrTzojU04Iz for <xfs@oss.sgi.com>;
	Tue, 06 Apr 2010 16:19:07 -0700 (PDT)
Date: Wed, 7 Apr 2010 09:19:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsqa: new fsr defragmentation test
Message-ID: <20100406231904.GG11036@dastard>
References: <1270543927-17129-1-git-send-email-david@fromorbit.com>
	<4BBB535B.90209@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4BBB535B.90209@sandeen.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Tue, Apr 06, 2010 at 10:29:31AM -0500, Eric Sandeen wrote:
> On 04/06/2010 03:52 AM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > This test aims to recreate the conditions that caused xfs_fsr to
> > corrupt inode forks. The problem was that the data forks between the
> > two inodes were in different formats due to different inode fork
> > offsets, so when they swapped the data forks the formats were
> > invalid.
> > 
> > This test generates a filesystem with a known fragmented freespace pattern and
> > then abuses known "behaviours" of the allocator to generate files
> > with a known number of extents. It creates attributes to generate a
> > known inode fork offset, then uses a debug feature of xfs_fsr to
> > attempt to defrag the inode to a known number of extents.
> > 
> > By using these features, we can pretty much cover the entire matrix of inode
> > fork configurations, hence reproducing the conditions that lead to corruptions.
> > This test has already uncovered one bug in the current kernel code, and the
> > current fsr (with it's naive attribute fork handling) is aborted on a couple of
> > hundred of the files created by this test.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  226     |  192 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  226.out |    2 +
> >  group   |    3 +-
> >  3 files changed, 196 insertions(+), 1 deletions(-)
> >  create mode 100644 226
> >  create mode 100644 226.out
> > 
> > diff --git a/226 b/226
> > new file mode 100644
> > index 0000000..b92292a
> > --- /dev/null
> > +++ b/226
> > @@ -0,0 +1,192 @@
> > +#! /bin/bash
> > +# FS QA Test No. 222
> 
> s/b 226

Ah, yeah, will fix.

> Looks like a good test but how fragile will it be in the face of changes
> to the known allocator behaviors?  :)

It should be OK because the freespace is pretty robustly fragmented.
The allocator will always give fragemented files regardless of the
write patterns - it's just a question of how big the fragments will
be.

The only allocator behaviour being relied on is that it tries to
make the reverse sequential write block adjacent to the previous
block, but it can't find one because the previous block is always
carved from the first block of the free extent chosen by the
allocator. It'll take a pretty major shakeup of the allocator to
change that behaviour, and if we change it that much, tests all over
the place break....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
