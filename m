Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 06D7129DFA
	for <xfs@oss.sgi.com>; Tue, 23 Apr 2013 15:50:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7B5B7AC002
	for <xfs@oss.sgi.com>; Tue, 23 Apr 2013 13:50:01 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	i200KTQySBxl6HfZ for <xfs@oss.sgi.com>;
	Tue, 23 Apr 2013 13:49:59 -0700 (PDT)
Date: Wed, 24 Apr 2013 06:49:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: shutdown filesystem if xfs_perag_get fails
Message-ID: <20130423204956.GM10481@dastard>
References: <20130419204102.736961610@sgi.com>
	<20130421174107.007313126@sgi.com> <5174603A.8030208@sandeen.net>
	<51753EDE.6000301@sgi.com> <51754A13.5000808@sandeen.net>
	<5175532B.3050509@sgi.com> <20130422233033.GK30622@dastard>
	<51769111.3050103@sgi.com>
	<1366732475.3762.32402.camel@chandra-dt.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1366732475.3762.32402.camel@chandra-dt.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Tue, Apr 23, 2013 at 10:54:35AM -0500, Chandra Seetharaman wrote:
> On Tue, 2013-04-23 at 08:48 -0500, Mark Tinguely wrote:
> > On 04/22/13 18:30, Dave Chinner wrote:
> > > On Mon, Apr 22, 2013 at 10:11:39AM -0500, Mark Tinguely wrote:
> > >>   #6 [ffff880135603980] _xfs_buf_find at ffffffffa01a7fef [xfs]
> > >>   #7 [ffff8801356039f0] xfs_buf_get at ffffffffa01a824a [xfs]
> > >>   #8 [ffff880135603a30] xfs_buf_read at ffffffffa01a83a4 [xfs]
> > >>   #9 [ffff880135603a60] xlog_recover_inode_pass2 at ffffffffa0193629 [xfs]
> > >
> > > So it's the same problem as this bug fix addresses:
> > >
> > > commit 10616b806d1d7835b1d23b8d75ef638f92cb98b6
> > > Author: Dave Chinner<dchinner@redhat.com>
> > > Date:   Mon Jan 21 23:53:52 2013 +1100
> > >
> > >      xfs: fix _xfs_buf_find oops on blocks beyond the filesystem end
> > >
> > >      When _xfs_buf_find is passed an out of range address, it will fail
> > >      to find a relevant struct xfs_perag and oops with a null
> > >      dereference. This can happen when trying to walk a filesystem with a
> > >      metadata inode that has a partially corrupted extent map (i.e. the
> > >      block number returned is corrupt, but is otherwise intact) and we
> > >      try to read from the corrupted block address.
> > >
> > >      In this case, just fail the lookup. If it is readahead being issued,
> > >      it will simply not be done, but if it is real read that fails we
> > >      will get an error being reported.  Ideally this case should result
> > >      in an EFSCORRUPTED error being reported, but we cannot return an
> > >      error through xfs_buf_read() or xfs_buf_get() so this lookup failure
> > >      may result in ENOMEM or EIO errors being reported instead.
> > >
> > >      Signed-off-by: Dave Chinner<dchinner@redhat.com>
> > >      Reviewed-by: Brian Foster<bfoster@redhat.com>
> > >      Reviewed-by: Ben Myers<bpm@sgi.com>
> > >      Signed-off-by: Ben Myers<bpm@sgi.com>
> > >
> > >> The recovery value is bad and is a problem on its own, but XFS does
> > >> not verify the validity of ag number when doing a xfs_perag_get().

I'd be interested to know why the inode in recovery is bad - is this
on a kernel that CRCs the log records? Or a result of some other bug
or hardware corruption? i.e. xfs_perag_get is not the problem here,
it's a corruption of a trusted inode number and we failed to detect
that corruption....

> > > Right, that's what the above fix does, but it can't be done on older
> > > kernels because grwofs relies on being able to get buffers beyond
> > > the existing filesystem limits...
> > 
> > Thank-you, that make sense.
> > 
> > I still do not like assuming xfs_perag_get() will always return a valid 
> > perag pointer.
> 
> I second that.
> 
> Is there any reason we should _not_ check the return value from
> xfs_perag_get() for NULL ?

Yes. The input AG should already be bounds checked before the perag
is looked up. If we are asking for an invalid AG, then the bug is not
in xfs_perag_get(), it is in the code that is calling it. i.e. error
checking the xfs_perag_get() function is a band-aid for improper
object validation, not a solution to the problem.

That is, this function was designed to be extremely low overhead and
only to be handed validated data. If it is only handed validated
data, then it is guaranteed to return a valid per-ag structure,
and therefore error checking the return value is not necessary.

Because xfs_perag_get is not designed to handle untrusted data it is
up to the calling code to first validate the AGNO that is passed to
xfs_perag_get(). If we aren't first validating the object that the
AGNO is derived from, then the calling code has failed to validate
it's inputs sufficiently, and lots of other things can go wrong (not
just the xfs_perag_get() call).

For example, the above commit is a catchall for bad block numbers
being looked up in extent records. It was a quick fix, not a
targeted fix for the reported problems. For bad block numbers in
extents, we should be doing is validating block numbers when they
are looked up are within the filesystem bounds (eg. inside
xfs_bmapi_read/xfs_bmapi_write) so that a bad block number is caught
at lookup time, not at IO time. We only do that for extents that
point to block 0.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
