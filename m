Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p3C06KZb118682 for <xfs@oss.sgi.com>; Mon, 11 Apr 2011 19:06:21 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 022491B6D473
	for <xfs@oss.sgi.com>; Mon, 11 Apr 2011 17:09:40 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id nZBBrJdXl3YHKnsN for
	<xfs@oss.sgi.com>; Mon, 11 Apr 2011 17:09:40 -0700 (PDT)
Date: Mon, 11 Apr 2011 20:09:39 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: reset buffer pointers before freeing them
Message-ID: <20110412000939.GC29358@infradead.org>
References: <1302491405-2290-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1302491405-2290-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

>  			error = xlog_bread_noalign(log, ealign, sectbb, bp);
> -			if (error)
> -				break;
>  
> -			error = XFS_BUF_SET_PTR(bp, offset, bufblks);
> +			/* must reset buffer pointer even on error */
> +			error2 = XFS_BUF_SET_PTR(bp, offset, bufblks);

This seems to be incorrect both in the original and your version.
>From all that I can see XFS_BUF_SET_PTR wants a byte count while bufblks
is a sector count, e.g. this should be:

			error2 = XFS_BUF_SET_PTR(bp, offset, BBTOB(bufblks);

While at I think this mess with the buffer virtual mapping, read into it
and set it back mess needs to go into a single helper instead of beeing
duplicated three times.  By having named arguments with proper types
bugs like the existing one above should also be much more obvious to
spot.

As a follow on patch to that I think we could also get rid of all the
vmap manipultions entirely, and just specify and I/O offset and length
manually.  The only thing required for that is a number of pages
to skip at the beggining of the buffer from the log recovery code to
_xfs_buf_ioapply, either by passing it down procedurally, or by adding
a new filed to struct xfs_buf.  In fact just relaxing the b_offset
semantics to allow offsets larger than a page only in the I/O path would
do it, but I'm not sure that version helps long-term maintenance.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
