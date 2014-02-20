Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6F8FA7F88
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 17:14:06 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DC801AC001
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 15:14:02 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	17beiseFtADk2oha for <xfs@oss.sgi.com>;
	Thu, 20 Feb 2014 15:14:00 -0800 (PST)
Date: Fri, 21 Feb 2014 10:13:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 04/11] xfs: update inode allocation/free transaction
	reservations for finobt
Message-ID: <20140220231320.GS4916@dastard>
References: <1391536182-9048-1-git-send-email-bfoster@redhat.com>
	<1391536182-9048-5-git-send-email-bfoster@redhat.com>
	<20140211064609.GE13647@dastard> <530393F8.4070106@redhat.com>
	<20140220020101.GL4916@dastard> <53064E26.2050607@redhat.com>
	<20140220211457.GA8476@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140220211457.GA8476@infradead.org>
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
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Thu, Feb 20, 2014 at 01:14:57PM -0800, Christoph Hellwig wrote:
> On Thu, Feb 20, 2014 at 01:49:10PM -0500, Brian Foster wrote:
> > > Right, that can happen. But my question is this: how realistic is it
> > > that we have someone who has ENOSPC because of enough zero length
> > > files to trigger this? I've never seen an application or user try to
> > > store any significant number of zero length files, so I suspect this
> > > is a theoretical problem, not a practical one.
> > > 
> > 
> > Probably not very realistic. ;) The only thing I know that does rely on
> > some zero-length files is gluster distribution to represent "link files"
> > when one a file that hashes to one server ends up stored on another.
> > Even then, I don't see how we would ever have a situation where those
> > link files exist in such massive numbers and are removed in bulk. So
> > it's likely a pathological scenario.
> 
> Zero data blocks are the only case for device nodes or fifos, very
> common for symlinks that can be stored inline, and not unusual for
> directories.

Sure, symlinks and directories are a common case, but they don't
generally make up millions of inodes in a filesystem. In the case of
directories, you've got to remove other filesystem before that
directory inode can be freed, and as such most cases are going to
end up freeing blocks from files before we get to freeing the
shortform directory inode.

Symlink farms could be a problem, but again if you have a large
symlink farm you're going to have blocks in directories and other
files that the symlinks point to that get removed. As it is, these
are the sorts of workloads that are going to gain massively from the
finobt modifications (e.g. backup programs that use link farms and
sparsify the inode btree when a backup is removed), so we'll find
out pretty quickly if the default reserve pool is not large enough
for these workloads.

As it is, I see this as a similar issue to the way we changed
speculative preallocation - we knew that there were significant
benefits to changing the behaviour, but we also knew that there
would be corner cases where problems would arise. However, we had no
real idea of exactly which workloads ior users would be affected by
ENOSPC issues. Users reported problems, we had mitigation
strategiesthey could apply (e.g. allocsize) while we fixed the
problems they reported. And now we get very few complaints about
that functionality - it just works for almost everyone out of the
box.

I mention this because I think that we are in exactly the same
situation of trying to work out just how widespread this corner
case issue will have an affect. Similar to specualtive prealloc,
we have:

	a) mitigation strategies already in place (increase
	reserve pool size); and

	b) a short- to medium-term plan of development that solves
	the issue completely.

As such, I don't think we should spend too much more time worrying
about this issue and just move onwards. Like the specualtive
preallocation, there may be some short term pain for corner case
workloads, but we end up in a much better place in the medium to
long term because we don't stall development trying to solve all the
problems at once and/or solving problems we don't need to solve....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
