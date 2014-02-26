Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 511177F37
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 00:02:35 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 34ED3304089
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 22:02:32 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	l1iJbL0BSfnFhfxG for <xfs@oss.sgi.com>;
	Tue, 25 Feb 2014 22:02:30 -0800 (PST)
Date: Wed, 26 Feb 2014 17:02:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_copy: accept XFS_ABTB_CRC_MAGIC
Message-ID: <20140226060226.GS13647@dastard>
References: <530D4B68.9090905@redhat.com>
	<20140226020737.GA21877@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140226020737.GA21877@infradead.org>
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
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Feb 25, 2014 at 06:07:37PM -0800, Christoph Hellwig wrote:
> On Tue, Feb 25, 2014 at 08:03:20PM -0600, Eric Sandeen wrote:
> > xfs_copy needs a fair bit of work for CRCs because it rewrites
> > UUIDs by default, but this change will get it working properly
> > with the "-d" (duplicate) option which keeps the same UUID.
> 
> I don't think ASSERTs for user supplied data are a good idea, this
> should be some real error handling.
> 
> > However, I wonder if we should fail CRC filesystems outright
> > for now if -d isn't specified, because it will invalidate every
> > CRC and generally make a mess of things...
> 
> Yeah, for now it probably should be rejected.
> 
> It would also be useful to have a list of such issues in an README.v5
> or TODO.v5 file in the xfsprogs tree.

Well, I thought we had just about got everything except for the
remaining repair cleanups and the logprint failure in xfs/295 up
until Eric mentioned UUIDs and xfs_copy/xfs_admin yesterday on IIRC.
I can't think of anything else that is needs to be finished for a
userspace release - I think that covers all the remaining xfstests
failures I'm seeing on crc enabled filesystems....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
