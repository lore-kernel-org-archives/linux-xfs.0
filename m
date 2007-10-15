Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 15 Oct 2007 04:58:03 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9FBvpWs029081
	for <xfs@oss.sgi.com>; Mon, 15 Oct 2007 04:57:54 -0700
Date: Mon, 15 Oct 2007 21:57:45 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS regression?
Message-ID: <20071015115745.GK995458@sgi.com>
References: <20071010152742.1b2a7bce@zeus.pccl.info> <20071011010139.GT995458@sgi.com> <20071011151512.69f19419@zeus.pccl.info> <20071011215352.GX995458@sgi.com> <20071012002613.GL23367404@sgi.com> <20071012123601.291fee8a@zeus.pccl.info> <cc7060690710130635u2a85bc28we36b344c0987b691@mail.gmail.com> <20071014230949.GO23367404@sgi.com> <cc7060690710150258v327637c3i3c0df4a821d2d056@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc7060690710150258v327637c3i3c0df4a821d2d056@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Bhagi rathi <jahnu77@gmail.com>
Cc: David Chinner <dgc@sgi.com>, Andrew Clayton <andrew@digital-domain.net>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Oct 15, 2007 at 03:28:34PM +0530, Bhagi rathi wrote:
> Thanks Dave for the response.   Thinking futher, why is that xfs_iunpin has
> to mark the inode dirty?

Because the inode has been modified, and instead of sprinkling
mark_inode_dirty_sync() all over the code, we can do it in a single
spot that catches all inode modifications. We don't have to think about
it by doing this - inodes in transactions get marked dirty for free....

> All transactions generally modify one time or other, xfs_ichgtime takes care
> of marking inode as
> dirty.

Sure, but there's plenty of other transactions that don't have such
a convenient hook.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
