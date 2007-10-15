Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 15 Oct 2007 03:05:00 -0700 (PDT)
Received: from nz-out-0506.google.com (nz-out-0506.google.com [64.233.162.225])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9FA4nhO010573
	for <xfs@oss.sgi.com>; Mon, 15 Oct 2007 03:04:51 -0700
Received: by nz-out-0506.google.com with SMTP id x3so788036nzd
        for <xfs@oss.sgi.com>; Mon, 15 Oct 2007 03:04:51 -0700 (PDT)
Message-ID: <cc7060690710150258v327637c3i3c0df4a821d2d056@mail.gmail.com>
Date: Mon, 15 Oct 2007 15:28:34 +0530
From: "Bhagi rathi" <jahnu77@gmail.com>
Subject: Re: XFS regression?
In-Reply-To: <20071014230949.GO23367404@sgi.com>
MIME-Version: 1.0
References: <20071010152742.1b2a7bce@zeus.pccl.info>
	 <20071011010139.GT995458@sgi.com>
	 <20071011151512.69f19419@zeus.pccl.info>
	 <20071011215352.GX995458@sgi.com> <20071012002613.GL23367404@sgi.com>
	 <20071012123601.291fee8a@zeus.pccl.info>
	 <cc7060690710130635u2a85bc28we36b344c0987b691@mail.gmail.com>
	 <20071014230949.GO23367404@sgi.com>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Andrew Clayton <andrew@digital-domain.net>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

Thanks Dave for the response.   Thinking futher, why is that xfs_iunpin has
to mark the inode dirty?
All transactions generally modify one time or other, xfs_ichgtime takes care
of marking inode as
dirty. I am thinking on why we need to mark the inode dirty at all, either
in the context of  unpin or
in the context for formatting the inode.

-Bhagi.

On 10/15/07, David Chinner <dgc@sgi.com> wrote:
>
> On Sat, Oct 13, 2007 at 07:05:17PM +0530, Bhagi rathi wrote:
> > David, Can you let me know the use after free problem? I want to
> understand
> > how the life cycle of linux inode
> > and xfs inode are related to log flush.
>
> Log I/O completion:
>
>   -> xfs_trans_commited
>        -> xfs_iunpin(xfs inode)
>          get linux inode from xfs inode
>           -> mark_inode_dirty_sync(linux inode)
>
> Freeing the linux inode:
>
> clear_inode(linux_inode)
> -> xfs_inactive()
>     -> xfs_trans_commit() (e.g. freeing data associated with unlinked
> inode)
>        -> xfs_ipin()
>     (link between xfs and linux inode broken)
>   linux inode freed
>
> So, in log I/O completion, we can be completing a previous
> transaction at the same time clear_inode() is running, and
> hence in xfs_iunpin() we can race with the freeing of the
> linux inode as xfs_iunpin does not hold any locks.
>
> > Any pointer is also of great help.
>
> /me points at the code.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group
>


[[HTML alternate version deleted]]
