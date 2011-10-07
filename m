Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p97NHL4f004355 for <xfs@oss.sgi.com>; Fri, 7 Oct 2011 18:17:22 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1395F16B9A62
	for <xfs@oss.sgi.com>; Fri,  7 Oct 2011 16:24:16 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	AyHTP5rAsprdDDyo for <xfs@oss.sgi.com>;
	Fri, 07 Oct 2011 16:24:16 -0700 (PDT)
Date: Sat, 8 Oct 2011 10:17:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Premature "No Space left on device" on XFS
Message-ID: <20111007231718.GH3159@dastard>
References: <4E8E079B.4040103@birkenwald.de> <20111007013711.GW3159@dastard>
	<201110071340.25077@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201110071340.25077@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Fri, Oct 07, 2011 at 01:40:24PM +0200, Michael Monnerie wrote:
> On Freitag, 7. Oktober 2011 Dave Chinner wrote:
> > And with 1.7 million inodes in it. That's a lot for a tiny
> > filesystem, and not really a use case that XFS is well suited to.
> > XFS will work, but it won't age gracefully under these conditions...
> 
> But which FS would fit better for that? We have similar usages, so I'm 
> curious.
> 
> > As it is, your problem is most likely fragmented free space (an
> > aging problem). Inodes are allocated in chunks of 64, so require an
> > -aligned- contiguous 16k extent for the default 256 byte inode size.
> > If you have no aligned contiguous 16k extents free then inode
> > allocation will fail.
> 
> Would this be a use case for the "noikeep" mount option?

Possibly, but you still end up with the same problems when you have
to grow the inode count and free space is low.

> When would be the time XFS drops inode clusters that are already empty, 
> when I use noikeep on an aged XFS with lots of such unused inode 
> allocations?

XFS frees inode chunks the when the last inode in the chunk is
freed. IF you have a random create/unlink workload, most of the
inode chunks will be partially populated and so the filesystem will
behave mostly as though it has noikeep sepcified, anyway. (i.e.
allocate inode from partially populated chunks before allocating new
chunks).

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
