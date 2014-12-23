Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 879FD7F3F
	for <xfs@oss.sgi.com>; Tue, 23 Dec 2014 14:36:46 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 67DD78F8035
	for <xfs@oss.sgi.com>; Tue, 23 Dec 2014 12:36:43 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	XY4KTVuiB5vZnxX1 for <xfs@oss.sgi.com>;
	Tue, 23 Dec 2014 12:36:41 -0800 (PST)
Date: Wed, 24 Dec 2014 07:36:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS corruption
Message-ID: <20141223203639.GE4521@dastard>
References: <B97466D39E354AFB808620584A4ABE5C@alyakaslap>
	<54970DD9.6080707@sandeen.net> <20141221230818.GH24183@dastard>
	<20141222144212.GA21897@laptop.bfoster>
	<20141223003924.GB4521@dastard>
	<CAOcd+r3Y3ZcnzcdXtk58oSKq7okN0V8fRHfd-phqJ+OwuGZ-sQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAOcd+r3Y3ZcnzcdXtk58oSKq7okN0V8fRHfd-phqJ+OwuGZ-sQ@mail.gmail.com>
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
To: Alex Lyakas <alex@zadarastorage.com>
Cc: Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Tue, Dec 23, 2014 at 11:57:13AM +0200, Alex Lyakas wrote:
> Hi Dave,
> 
> On Tue, Dec 23, 2014 at 2:39 AM, Dave Chinner <david@fromorbit.com> wrote:
> > commit 40194ecc6d78327d98e66de3213db96ca0a31e6f
> > Author: Ben Myers <bpm@sgi.com>
> > Date:   Fri Dec 6 12:30:11 2013 -0800
> >
> >     xfs: reinstate the ilock in xfs_readdir
> >
> >     Although it was removed in commit 051e7cd44ab8, ilock needs to be taken in
> >     xfs_readdir because we might have to read the extent list in from disk.  This
> >     keeps other threads from reading from or writing to the extent list while it i
> >     being read in and is still in a transitional state.
> >
> >     This has been associated with "Access to block zero" messages on directories
> >     with large numbers of extents resulting from excessive filesytem fragmentation
> >     as well as extent list corruption.  Unfortunately no test case at this point.
> >
> >     Signed-off-by: Ben Myers <bpm@sgi.com>
> >     Reviewed-by: Dave Chinner <dchinner@redhat.com>
> >
> > Seems to match the behaviour being seen.
> >
> > Alex, what type of inode is the one that is reporting the "access to
> > block zero" errors?
> I have just searched the relevant file system for this inode, but such
> inode was not found:(
> # find /export/XXX -mount -inum 1946454529
> did not find anything. Perhaps it got deleted since the incident.

It probably got cleared by xfs_repair because it was corrupt....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
