Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB35N6WR063608 for <xfs@oss.sgi.com>; Thu, 2 Dec 2010 23:23:06 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6328F1BF58E
	for <xfs@oss.sgi.com>; Thu,  2 Dec 2010 21:24:48 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	8cf0E186evYVNFKT for <xfs@oss.sgi.com>;
	Thu, 02 Dec 2010 21:24:48 -0800 (PST)
Date: Fri, 3 Dec 2010 16:24:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/8] xfs: Pull EFI/EFD handling out from under the AIL lock
Message-ID: <20101203052445.GC23339@dastard>
References: <1290993152-20999-1-git-send-email-david@fromorbit.com>
	<1290993152-20999-2-git-send-email-david@fromorbit.com>
	<20101130201734.GA16079@infradead.org>
	<20101202012841.GL16922@dastard>
	<20101202113849.GA21365@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101202113849.GA21365@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Dec 02, 2010 at 06:38:49AM -0500, Christoph Hellwig wrote:
> On Thu, Dec 02, 2010 at 12:28:41PM +1100, Dave Chinner wrote:
> > >  - there is a behaviour change about the xfs_trans_del_item call
> > >    in xfs_efi_item_unpin - before it was protected by the
> > >    XFS_EFI_CANCELED which was never set, and now it's not.
> > 
> > XFS_EFI_CANCELED has not been set in the code base since
> > xfs_efi_cancel() was removed back in 2006 by commit
> > 065d312e15902976d256ddaf396a7950ec0350a8 ("[XFS] Remove unused
> > iop_abort log item operation), and even then xfs_efi_cancel() was
> > never called. I haven't tracked it back further than that (beyond
> > git history), but handling of efis in cancelled transactions has
> > been broken for a long time.
> > 
> > Basically, when we get an IOP_UNPIN(lip, 1); call from
> > xfs_trans_uncommit() (i.e. remove == 1), if we don't free the log
> > item descriptor we leak it. IOWs, the new behaviour introduced in
> > this patch is actually the correct behaviour.
> 
> Maybe fix this issue first in a separate patch, instead of hiding it
> in a bigger one.

Ok, I'll split it out.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
