Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA93TN3O132159 for <xfs@oss.sgi.com>; Mon, 8 Nov 2010 21:29:23 -0600
Received: from thunker.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 64513164ADE
	for <xfs@oss.sgi.com>; Mon,  8 Nov 2010 19:30:50 -0800 (PST)
Received: from thunker.thunk.org (thunk.org [69.25.196.29]) by cuda.sgi.com
	with ESMTP id o3VJw0PNfXHMeKCv for <xfs@oss.sgi.com>;
	Mon, 08 Nov 2010 19:30:50 -0800 (PST)
Date: Mon, 8 Nov 2010 22:30:38 -0500
From: "Ted Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 1/6] fs: add hole punching to fallocate
Message-ID: <20101109033038.GF3099@thunk.org>
References: <1289248327-16308-1-git-send-email-josef@redhat.com>
	<20101109011222.GD2715@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101109011222.GD2715@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, cmm@us.ibm.com, Josef Bacik <josef@redhat.com>, joel.becker@oracle.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

On Tue, Nov 09, 2010 at 12:12:22PM +1100, Dave Chinner wrote:
> Hole punching was not included originally in fallocate() for a
> variety of reasons. IIRC, they were along the lines of:
> 
> 	1 de-allocating of blocks in an allocation syscall is wrong.
> 	  People wanted a new syscall for this functionality.
> 	2 no glibc interface needs it
> 	3 at the time, only XFS supported punching holes, so there
> 	  is not need to support it in a generic interface
> 	4 the use cases presented were not considered compelling
> 	  enough to justify the additional complexity (!)
> 
> In the end, I gave up arguing for it to be included because just
> getting the FALLOC_FL_KEEP_SIZE functionality was a hard enough
> battle.
> 
> Anyway, #3 isn't the case any more, #4 was just an excuse not to
> support anything ext4 couldn't do and lots of apps are calling
> fallocate directly (because glibc can't use FALLOC_FL_KEEP_SIZE) so
> #2 isn't an issue, either.

I don't recall anyone arguing #4 because of ext4, but I get very tired
of the linux-fsdevel bike-shed painting parties, so I often will
concede whatever is necessary just to get the !@#! interface in,
assuming we could add more flags later....

glibc does support fallocate(), BTW; it's just posix_fallocate() that
doesn't use FALLOC_FL_KEEP_SIZE.

> I guess that leaves #1 to be debated;
> I don't think there is any problem with doing what you propose.

I don't have a problem either.

As a completely separate proposal, what do people think about an
FALLOCATE_FL_ZEROIZE after which time the blocks are allocated, but
reading from them returns zero.  This could be done either by (a)
sending a discard in the case of devices where discard_zeros_data is
true and discard_granularty is less than the fs block size, or (b) by
setting the uninitialized flag in the extent tree.

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
