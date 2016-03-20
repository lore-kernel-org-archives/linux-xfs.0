Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9A1EC7CA1
	for <xfs@oss.sgi.com>; Sun, 20 Mar 2016 18:18:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2DAA3AC001
	for <xfs@oss.sgi.com>; Sun, 20 Mar 2016 16:18:34 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Y4Mno4bKqFxrRHgo for <xfs@oss.sgi.com>;
	Sun, 20 Mar 2016 16:18:32 -0700 (PDT)
Date: Mon, 21 Mar 2016 10:16:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: splice vs truncate lockdep splat
Message-ID: <20160320231638.GP30721@dastard>
References: <alpine.DEB.2.11.1603200938010.17552@cpach.fuggernut.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1603200938010.17552@cpach.fuggernut.com>
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
To: Sage Weil <sweil@redhat.com>
Cc: xfs@oss.sgi.com

On Sun, Mar 20, 2016 at 09:43:01AM -0400, Sage Weil wrote:
> Hi all,
> 
> For the last few kernel releases we've been seeing this pretty regularly:
> 

[snip]

Yup, splice still has locking problems. Always has, and the
write_iter rework a few releases ago just moved the warnings
elsewhere.

>  #012-> #2 (&pipe->mutex/1){+.+.+.}:

xfs_file_splice_read
  xfs_iolock(XFS_IOLOCK_SHARED)
    ....
    pipe_lock(pipe)

XFS takes the XFS_IOLOCK_SHARED here to serialise splice read
against truncate.

>  #012-> #1 (&(&ip->i_iolock)->mr_lock){++++++}:

mutex_lock(inode->i_mutex)
....
  xfs_vn_setattr
    xfs_iolock(XFS_IOLOCK_EXCL)

Truncate lock order for IO serialisation (no pipe lock).

>  #012-> #0 (&sb->s_type->i_mutex_key#19){+.+.+.}:

iter_file_splice_write
  pipe_lock(pipe)
    xfs_file_buffered_aio_write
      mutex_lock(inode->i_mutex)
        xfs_iolock(XFS_IOLOCK_EXCL)

XFS takes i_mutex (required for buffered IO path) and
XFS_IOLOCK_EXCL (for atomic write semantics and truncate exclusion),
but the splice write path has put this under the pipe lock....

i.e. because the read/write path take the IOLOCK different ways,
lockdep seems to think it's OK. Hence IO testing doesn't report
issues, but the moment you throw in another operation that takes
both the i_mutex and XFS_IOLOCK_EXCL, lockdep will through a lock
order violation report.

> We're not actually doing racing truncate and splice (or any racing 
> operations for that matter) to the same files, so we don't actually hit 
> this, but the lockdep warning is enough to make our test runs fail, and 
> we'd rather not whitelist this if it's something that should get fixed 
> anyway.

We can't fix it in XFS - the high level splice infrastructure which
that read IO serialisation is done entirely based on page cache page
locking and so can hold the pipe lock across ->splice_read callouts.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
