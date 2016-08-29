Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CB7157CA0
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2016 18:40:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 46E02AC004
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2016 16:40:49 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	yrRD1DXplFSsZNyN for <xfs@oss.sgi.com>;
	Mon, 29 Aug 2016 16:40:46 -0700 (PDT)
Date: Tue, 30 Aug 2016 09:40:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprogs: don't populate fs table with foreign fs paths
	unless foreign_allowed
Message-ID: <20160829234044.GS19025@dastard>
References: <1472478012-23627-1-git-send-email-billodo@redhat.com>
	<20160829231205.GO19025@dastard>
	<20160829232615.GA29648@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160829232615.GA29648@redhat.com>
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
To: Bill O'Donnell <billodo@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Aug 29, 2016 at 06:26:15PM -0500, Bill O'Donnell wrote:
> On Tue, Aug 30, 2016 at 09:12:06AM +1000, Dave Chinner wrote:
> > On Mon, Aug 29, 2016 at 08:40:12AM -0500, Bill O'Donnell wrote:
> > > Commits b20b6c2 and 29647c8 modified xfs_quota for use on
> > > non-XFS filesystems. One modification in fs_initialise_mounts
> > > (paths.c) resulted in an xfstest fail (xfs/261), due to foreign
> > > fs paths entering the fs table.
> > 
> > What's the failure? I'm not seeing it here on any of my test
> > machines...
> 
> On my box, there are a few ext4 mounts, and test xfs/261 
> populates the fs table with those paths.

I have ext2 and ext3 mounts on these machines as well, and they
don't throw any errors.

> So when xfs_quota commands
> in 261 are executed, a "foreign filesystem" message is thrown.

What is the output that is causing the failure? When someone
asks you to describe the error that is occurring, please quote the
/exact error/ that is occurring - describing it via paraphrasing
does not tell anything useful about the error as I cannot correlate
that description to the code that is throwing it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
