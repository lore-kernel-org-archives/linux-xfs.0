Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB21R305243939 for <xfs@oss.sgi.com>; Wed, 1 Dec 2010 19:27:03 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4EA8E160AA63
	for <xfs@oss.sgi.com>; Wed,  1 Dec 2010 17:28:45 -0800 (PST)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	8bkHc1d6Coebwv3m for <xfs@oss.sgi.com>;
	Wed, 01 Dec 2010 17:28:45 -0800 (PST)
Date: Thu, 2 Dec 2010 12:28:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/8] xfs: Pull EFI/EFD handling out from under the AIL lock
Message-ID: <20101202012841.GL16922@dastard>
References: <1290993152-20999-1-git-send-email-david@fromorbit.com>
	<1290993152-20999-2-git-send-email-david@fromorbit.com>
	<20101130201734.GA16079@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101130201734.GA16079@infradead.org>
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

On Tue, Nov 30, 2010 at 03:17:34PM -0500, Christoph Hellwig wrote:
> 
>  - xfs_efi_init needs to initialize efi_next_extent using ATOMIC_INIT

OK.

>  - there is a behaviour change about the xfs_trans_del_item call
>    in xfs_efi_item_unpin - before it was protected by the
>    XFS_EFI_CANCELED which was never set, and now it's not.

XFS_EFI_CANCELED has not been set in the code base since
xfs_efi_cancel() was removed back in 2006 by commit
065d312e15902976d256ddaf396a7950ec0350a8 ("[XFS] Remove unused
iop_abort log item operation), and even then xfs_efi_cancel() was
never called. I haven't tracked it back further than that (beyond
git history), but handling of efis in cancelled transactions has
been broken for a long time.

Basically, when we get an IOP_UNPIN(lip, 1); call from
xfs_trans_uncommit() (i.e. remove == 1), if we don't free the log
item descriptor we leak it. IOWs, the new behaviour introduced in
this patch is actually the correct behaviour.

>  - what happened to XFS_EFI_RECOVERED?  You changed it to be indexed
>    for the atomic bit-ops, but it's still used non-atomic in the log
>    recovery code.

Ah, I forgot to convert it.

>  - Why is XFS_EFI_COMMITTED cleared in xlog_recover_do_efi_trans,
>    where it can't ever be set?

It was just a straight transformation. I'll kill it.

>  - can you please add a shared helper for xfs_efi_item_unpin and
>    xfs_efi_release, ala:

Ok. Will do.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
