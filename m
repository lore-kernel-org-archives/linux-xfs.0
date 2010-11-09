Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA94fkAJ135051 for <xfs@oss.sgi.com>; Mon, 8 Nov 2010 22:41:46 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8D7E1139CEA6
	for <xfs@oss.sgi.com>; Mon,  8 Nov 2010 20:43:11 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	ElpxbcIdJofThPYn for <xfs@oss.sgi.com>;
	Mon, 08 Nov 2010 20:43:11 -0800 (PST)
Date: Tue, 9 Nov 2010 15:42:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/6] fs: add hole punching to fallocate
Message-ID: <20101109044242.GH2715@dastard>
References: <1289248327-16308-1-git-send-email-josef@redhat.com>
	<20101109011222.GD2715@dastard> <20101109033038.GF3099@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101109033038.GF3099@thunk.org>
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
To: Ted Ts'o <tytso@mit.edu>, Josef Bacik <josef@redhat.com>, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, joel.becker@oracle.com, cmm@us.ibm.com, cluster-devel@redhat.com

On Mon, Nov 08, 2010 at 10:30:38PM -0500, Ted Ts'o wrote:
> On Tue, Nov 09, 2010 at 12:12:22PM +1100, Dave Chinner wrote:
> > Hole punching was not included originally in fallocate() for a
> > variety of reasons. IIRC, they were along the lines of:
> > 
> > 	1 de-allocating of blocks in an allocation syscall is wrong.
> > 	  People wanted a new syscall for this functionality.
....
> > I guess that leaves #1 to be debated;
> > I don't think there is any problem with doing what you propose.
> 
> I don't have a problem either.
> 
> As a completely separate proposal, what do people think about an
> FALLOCATE_FL_ZEROIZE after which time the blocks are allocated, but
> reading from them returns zero.

That's exactly the new XFS_IOC_ZERO_RANGE ioctl in 2.6.36 does
(commit 447223520520b17d3b6d0631aa4838fbaf8eddb4 "xfs: Introduce
XFS_IOC_ZERO_RANGE") The git commit I pointed to in the last email
is the rudimentary fallocate() interface support I have for that
code which goes along with an xfs_io patch I have. Given that there
seems to be interest for this operation, I'll flesh it out into a
proper patch....

> This could be done either by (a)
> sending a discard in the case of devices where discard_zeros_data is
> true and discard_granularty is less than the fs block size, or (b) by
> setting the uninitialized flag in the extent tree.

Implementation is up to the filesystem. However, XFS does (b)
because:

	1) it was extremely simple to implement (one of the
	   advantages of having an exceedingly complex allocation
	   interface to begin with :P)
	2) conversion is atomic, fast and reliable
	3) it is independent of the underlying storage; and
	4) reads of unwritten extents operate at memory speed,
	   not disk speed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
