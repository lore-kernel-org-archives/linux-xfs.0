Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D41CA7CBF
	for <xfs@oss.sgi.com>; Wed,  3 Apr 2013 20:14:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C0838304064
	for <xfs@oss.sgi.com>; Wed,  3 Apr 2013 18:14:27 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	JxTVFt8aQwGAFd3A for <xfs@oss.sgi.com>;
	Wed, 03 Apr 2013 18:14:25 -0700 (PDT)
Date: Thu, 4 Apr 2013 12:14:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: don't free EFIs before the EFDs are committed
Message-ID: <20130404011422.GV17758@dastard>
References: <1364958561-12440-1-git-send-email-david@fromorbit.com>
	<515C7F09.2080201@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <515C7F09.2080201@sgi.com>
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

On Wed, Apr 03, 2013 at 02:12:09PM -0500, Mark Tinguely wrote:
> On 04/02/13 22:09, Dave Chinner wrote:
> >From: Dave Chinner<dchinner@redhat.com>
> >
> >Filesystems are occasionally being shut down with this error:
> >
> >xfs_trans_ail_delete_bulk: attempting to delete a log item that is
> >not in the AIL.
> >
> >It was diagnosed to be related to the EFI/EFD commit order when the
> >EFI and EFD are in different checkpoints and the EFD is committed
> >before the EFI here:
> >
> >http://oss.sgi.com/archives/xfs/2013-01/msg00082.html
> >
> >The real problem is that a single bit cannot fully describe the
> >states that the EFI/EFD processing can be in. These completion
> >states are:
> >
> >EFI			EFI in AIL	EFD		Result
> >committed/unpinned	Yes		committed	OK
> >committed/pinned	No		committed	Shutdown
> >uncommitted		No		committed	Shutdown
> >
> >
> >Note that the "result" field is what should happen, not what does
> >happen. The current logic is broken and handles the first two cases
> >correctly by luck.  That is, the code will free the EFI if the
> >XFS_EFI_COMMITTED bit is*not*  set, rather than if it is set. The
> >inverted logic "works" because if both EFI and EFD are committed,
> >then the first __xfs_efi_release() call clears the XFS_EFI_COMMITTED
> >bit, and the second frees the EFI item. Hence as long as
> >xfs_efi_item_committed() has been called, everything appears to be
> >fine.
> >
> >It is the third case where the logic fails - where
> >xfs_efd_item_committed() is called before xfs_efi_item_committed(),
> >and that results in the EFI being freed before it has been
> >committed. That is the bug that triggered the shutdown, d hence
> >keeping track of whether the EFI has been committed or not is
> >insufficient to correctly order the EFI/EFD operations w.r.t. the
> >AIL.
> >
> 
> I think the exist xfs_efi routines are working correctly.

Speaking as the person whose designed and wrote the current EFI/EFD
code in question here, I think it is broken and only working by
chance.

Hint: there is no comment anywhere (code or commit message) that is
works by a tricky piece of logic that first clears the committed bit
and then frees the object when it is not set the second time
through.

I *always* write comments about tricky logic like this when it is
intentional, so that when I look at it a couple of years later I
know exactly why the logic is correct even though it appears wrong.
No comments therefore means this logic was not the intended
behaviour and therefore only working by chance.

> the xfs_trans_committed_bulk() for the efi does the IOP_COMMITTED
> (sets the XFS_EFI_COMMITTED bit), add the entry to the AIL and then
> an IOP_UNPIN() which clears the XFS_EFI_COMMITTED since it is set,
> it should not release the efi and remove the entry from the AIL. It
> also correctly detects if the EFD is committed before the EFI by
> shutting down the filesystem.

But that behaviour is wrong - seeing the EFD before the EFI is not a
bug, just an indication that we have interleaved checkpoints being
committed concurrently. The fact that we've seen the EFD means when
we can simply free the EFI once it has been committed. The AIL is
where the ordering of journalled objects matter; the order in
which iclog commit callbacks are run does not affect that.

> This patch seems to paper over why the EFD will come before the EFI.
> 
> The CIL commits are in the correct order - protected by the
> xlog_wait() but the callbacks are out of order.

The design is such that what is physically on disk is correctly
ordered, but we don't care about the callback order as the
AIL is where the *in-memory object order* is correctly established.

> My previous patch fixed the callback from happening out of sequence.

It may have, but it serialised all CIL checkpoints, not just the
commit record order. That approach to fixing the bug is simply a
non-starter.  Why are you raising this now when you were silent
about it 3 months ago when this bug was first being discussed and
the EFI/EFD handling bug was initially raised?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
