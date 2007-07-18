Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 17 Jul 2007 19:01:47 -0700 (PDT)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6I21ebm006679
	for <xfs@oss.sgi.com>; Tue, 17 Jul 2007 19:01:42 -0700
Subject: Re: Allocating inodes from a single block
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <469D7035.2020507@sandeen.net>
References: <469D0666.6040908@agami.com>
	 <20070717201921.GA26309@tuatara.stupidest.org>
	 <469D7035.2020507@sandeen.net>
Content-Type: text/plain
Date: Wed, 18 Jul 2007 12:01:30 +1000
Message-Id: <1184724090.15488.553.camel@edge.yarra.acx>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Chris Wedgwood <cw@f00f.org>, Michael Nishimoto <miken@agami.com>, xfs@oss.sgi.com

On Tue, 2007-07-17 at 20:43 -0500, Eric Sandeen wrote:
> Chris Wedgwood wrote:
> > On Tue, Jul 17, 2007 at 11:11:50AM -0700, Michael Nishimoto wrote:
> > 
> >> Filesystem free space becomes fragmented over time.  It's possible
> >> for total free space to be a decent size and still not have a chunk
> >> large enough to allocate new inodes.
> > 
> > by default there is a restriction that indoes shouldn't consume more
> > that 25% of the total space
> > 
> > see the mkfs.xfs man-page for details, search for 'maxpct'
> > 
> > for existing filesystems you can use xfs_db to rewrite this value

FWIW, xfs_growfs can be used to change this online.

> The problem is that inodes are allocated in "clusters" of blocks.
> 
> If your free blocks aren't such that they can form a cluster, I think
> you're out of luck when trying to allocate new inodes if your existing
> clusters are full.

Have you looked into this much Mike?  I've not recently, but from a
quick peek it looks like the cluster size is set in xfs_mount.c as
mp->m_inode_cluster_size and a different value is used depending on
the machines memory size ... so, perhaps this can be made a mount
option?  (XFS_INODE_SMALL_CLUSTER_SIZE is 1FSB AFAICT).  But, maybe
I'm missing something or not remembering some details here that'd
make that infeasible.

Even better than a mount option would be to degrade to smaller size
dynamically... not sure how hard that'd be either ... probably lots
of corner cases lurking there.

cheers.

--
Nathan
