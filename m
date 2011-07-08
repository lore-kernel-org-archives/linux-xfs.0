Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p683NvBr209140 for <xfs@oss.sgi.com>; Thu, 7 Jul 2011 22:23:57 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E315517A2DBB
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2011 20:23:54 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	MCdBsAbk0sfjDbeB for <xfs@oss.sgi.com>;
	Thu, 07 Jul 2011 20:23:54 -0700 (PDT)
Date: Fri, 8 Jul 2011 13:23:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_quota: bug: traverses bind mountpoints
Message-ID: <20110708032351.GF1026@dastard>
References: <4E161B1D.90301@uvic.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E161B1D.90301@uvic.ca>
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
To: Paul Nienaber <phox@uvic.ca>
Cc: xfs@oss.sgi.com

On Thu, Jul 07, 2011 at 01:46:21PM -0700, Paul Nienaber wrote:
> So, much like coreutils' du (which also shouldn't), xfs_quota
> traverses bind mountpoints both when doing 'project -s' and 'project
> -C', and probably also 'project -c' although I haven't tested it.
> Testcase and output follows.

How is a userspace traversal supposed to detect the fact it crosses
a bind mount when it enters a directory?  If you bind a directory
from the same filesystem, stat(2) on the file returns -identical-
information regardless of whether you are inside or outside the bind
mount. So the normal mechanisms (e.g. st_dev changes) for detecting
such a mount point traversal simply don't work.

So the first question is whether we should be trying to detect bind
mounts within the same filesystem and handling them for project
quotas? I don't know the answer to that.

Indeed:

$ find .
.
./projects
./projects/foo
./projects/foo/chroot
find: File system loop detected; `./projects/foo/chroot/scratch' is
part of the same file system loop as `.'.
./projects/bar
./projects/bar/foo
./baz

find has some way of detecting such cases, but it doesn't do it via
any special syscalls, nor does the newfstatat(AT_SYMLINK_NOFOLLOW)
call it does return an error. And it does it regardless of whether
the -xdev option is specified or not. So it must have some form of
internal logic for detecting such loopy filesystem constructs.

However, operations such as "chmod -R" do *not* detect this
situation:

$ sudo chown -R -v dave:dave *
ownership of `baz' retained as dave:dave
changed ownership of `projects/foo/chroot/scratch/projects/foo/chroot/scratch' to dave:dave
changed ownership of `projects/foo/chroot/scratch/projects/foo/chroot' to dave:dave
changed ownership of `projects/foo/chroot/scratch/projects/foo' to dave:dave
changed ownership of `projects/foo/chroot/scratch/projects/bar/foo' to dave:dave
changed ownership of `projects/foo/chroot/scratch/projects/bar' to dave:dave
changed ownership of `projects/foo/chroot/scratch/projects' to dave:dave
ownership of `projects/foo/chroot/scratch/baz' retained as dave:dave
changed ownership of `projects/foo/chroot/scratch' to dave:dave
changed ownership of `projects/foo/chroot' to dave:dave
changed ownership of `projects/foo' to dave:dave
ownership of `projects/bar/foo' retained as dave:dave
ownership of `projects/bar' retained as dave:dave
changed ownership of `projects' to dave:dave

It's totally unclear what the behaviour of xfs_quota should be,
because operations that change user and group quotas are completely
ignorant of bind mounts.

So if we decide bind mounts are important to detect, the second
question is how do we detect bind mount point traversals in a
reliable manner that doesn't involve adding significant overhead to
the directory traversal code?  I don't know the answer to that,
either, and if you care about this enough I guess you'll go and look
up what find does and tell us about it ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
