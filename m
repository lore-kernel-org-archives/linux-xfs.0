Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C8A447CBE
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 16:48:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B1D36304053
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 14:48:03 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	M0Gdc7ywMVJBAWkK for <xfs@oss.sgi.com>;
	Thu, 15 Aug 2013 14:48:01 -0700 (PDT)
Date: Fri, 16 Aug 2013 07:47:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprogs: fix inode crash in xfs_repair
Message-ID: <20130815214759.GV6023@dastard>
References: <20130813221739.031858865@sgi.com> <20130814064013.GC12779@dastard>
	<520B870F.8040808@sgi.com> <20130815003313.GJ6023@dastard>
	<520CE0AD.7060306@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <520CE0AD.7060306@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Aug 15, 2013 at 09:07:41AM -0500, Mark Tinguely wrote:
> On 08/14/13 19:33, Dave Chinner wrote:
> >On Wed, Aug 14, 2013 at 08:33:03AM -0500, Mark Tinguely wrote:
> >>>I don't understand this check.
> >>>
> >>>We've already dereferenced ip several lines above to increment the
> >>>link count and get the inode number stored in ino, so the ip != NULL
> >>>is unnecessary.
> >>>
> >>>We've just allocated the inode, so why would the magic number be
> >>>wrong? And why would the inode number lie in a non-existent
> >>>allocation group?
> >>>
> >>
> >>just being being paranoid.
> >
> >It's the same code as in the kernel - if is that broken that it
> >can't tell it didn't allocate a real inode, then we've got bigger
> >problems. We design the code to return an error when it fails so we
> >don't have to robustly check every possible error condition at every
> >call site. So really the only check needed is "if (!irec) {...}"
> 
> The inode number check came from find_inode_rec(ag, agino)
> (repair/incore.h). A bad inode number will also return a NULL irec.

Yes, it will. But we just allocated the inode, so it's guaranteed to
have a valid inode number. We've got an inode *from a trusted
source* so we don't need to validate it the same way we need to
validate an inode number that we've pulled of disk that might be
corrupted.

Paranoia is great when using data from an untrusted source. But when
the data is from a trusted source, extreme paranoia is not necessary
and just makes the code hard to read...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
