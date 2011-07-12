Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6C0tdgo001187 for <xfs@oss.sgi.com>; Mon, 11 Jul 2011 19:55:39 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B091017B706B
	for <xfs@oss.sgi.com>; Mon, 11 Jul 2011 17:55:37 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	GIr1TI43WQ8TbpTO for <xfs@oss.sgi.com>;
	Mon, 11 Jul 2011 17:55:37 -0700 (PDT)
Date: Tue, 12 Jul 2011 10:55:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/11] xfs: factor out xfs_da_grow_inode_int
Message-ID: <20110712005535.GJ23038@dastard>
References: <20110710204916.856267100@bombadil.infradead.org>
	<20110710205017.485558926@bombadil.infradead.org>
	<20110711003743.GC23038@dastard>
	<20110711052406.GA13266@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110711052406.GA13266@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Jul 11, 2011 at 01:24:06AM -0400, Christoph Hellwig wrote:
> On Mon, Jul 11, 2011 at 10:37:43AM +1000, Dave Chinner wrote:
> > On Sun, Jul 10, 2011 at 04:49:20PM -0400, Christoph Hellwig wrote:
> > > xfs_da_grow_inode and xfs_dir2_grow_inode are mostly duplicate code.  Factor
> > > the meat of those two functions into a new common helper.
> > 
> > Hmmmm. I'm in the process of splitting xfs_dir2_grow_inode() into
> > data space vs free space variants so I can play speculative
> > preallocation tricks in the directory data space to reduce dataspace
> > fragmentation for large directories. Combined with a rework of the
> > readir readahead code, it significantly reduces IO count and seeks
> > for readdir calls...
> > 
> > I'll probably just rebase on top of this patch, though, because I did
> > notice that the two functions were very similar to begin with. ;)
> 
> Are you two variants still sharing the core code?

Sort of - there's an extra allocation failure case added (multiple
directory block size allocation failure), but otherwise is the same.

> If yes rebasing sounds
> like the better idea.  If the two dir2 variants are different enough
> from the da variant I'm fine with postponing this one for now.

I'll rebase anyway - the code won't be ready for 3.1 because I
haven't yet started on the readahead optimisations that better
allocation allows. I also need to add dataspace truncation during
inactivation so that we don't leave blocks in the data space "beyond
EOF" that repair complains about on clean unmounts.

And FWIW, I think I now know enough about how this all works to be
able to implement online directory data space defragmentation now...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
