Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 427BB29E28
	for <xfs@oss.sgi.com>; Fri,  5 Apr 2013 13:31:06 -0500 (CDT)
Date: Fri, 5 Apr 2013 13:31:05 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: don't free EFIs before the EFDs are committed
Message-ID: <20130405183105.GC22182@sgi.com>
References: <1364958561-12440-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1364958561-12440-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Apr 03, 2013 at 02:09:21PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Filesystems are occasionally being shut down with this error:
> 
> xfs_trans_ail_delete_bulk: attempting to delete a log item that is
> not in the AIL.
> 
> It was diagnosed to be related to the EFI/EFD commit order when the
> EFI and EFD are in different checkpoints and the EFD is committed
> before the EFI here:
> 
> http://oss.sgi.com/archives/xfs/2013-01/msg00082.html
> 
> The real problem is that a single bit cannot fully describe the
> states that the EFI/EFD processing can be in. These completion
> states are:
> 
> EFI			EFI in AIL	EFD		Result
> committed/unpinned	Yes		committed	OK
> committed/pinned	No		committed	Shutdown
> uncommitted		No		committed	Shutdown
> 
> 
> Note that the "result" field is what should happen, not what does
> happen. The current logic is broken and handles the first two cases
> correctly by luck.  That is, the code will free the EFI if the
> XFS_EFI_COMMITTED bit is *not* set, rather than if it is set. The
> inverted logic "works" because if both EFI and EFD are committed,
> then the first __xfs_efi_release() call clears the XFS_EFI_COMMITTED
> bit, and the second frees the EFI item. Hence as long as
> xfs_efi_item_committed() has been called, everything appears to be
> fine.
> 
> It is the third case where the logic fails - where
> xfs_efd_item_committed() is called before xfs_efi_item_committed(),
> and that results in the EFI being freed before it has been
> committed. That is the bug that triggered the shutdown, and hence
> keeping track of whether the EFI has been committed or not is
> insufficient to correctly order the EFI/EFD operations w.r.t. the
> AIL.
> 
> What we really want is this: the EFI is always placed into the
> AIL before the last reference goes away. The only way to guarantee
> that is that the EFI is not freed until after it has been unpinned
> *and* the EFD has been committed. That is, restructure the logic so
> that the only case that can occur is the first case.
> 
> This can be done easily by replacing the XFS_EFI_COMMITTED with an
> EFI reference count. The EFI is initialised with it's own count, and
> that is not released until it is unpinned. However, there is a
> complication to this method - the high level EFI/EFD code in
> xfs_bmap_finish() does not hold direct references to the EFI
> structure, and runs a transaction commit between the EFI and EFD
> processing. Hence the EFI can be freed even before the EFD is
> created using such a method.
> 
> Further, log recovery uses the AIL for tracking EFI/EFDs that need
> to be recovered, but it uses the AIL *differently* to the EFI
> transaction commit. Hence log recovery never pins or unpins EFIs, so
> we can't drop the EFI reference count indirectly to free the EFI.
> 
> However, this doesn't prevent us from using a reference count here.
> There is a 1:1 relationship between EFIs and EFDs, so when we
> initialise the EFI we can take a reference count for the EFD as
> well. This solves the xfs_bmap_finish() issue - the EFI will never
> be freed until the EFD is processed. In terms of log recovery,
> during the committing of the EFD we can look for the
> XFS_EFI_RECOVERED bit being set and drop the EFI reference as well,
> thereby ensuring everything works correctly there as well.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Applied.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
