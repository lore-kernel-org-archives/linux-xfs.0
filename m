Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0HBxE9U010184 for <xfs@oss.sgi.com>; Sun, 17 Jan 2010 05:59:14 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3607A16DEAB
	for <xfs@oss.sgi.com>; Sun, 17 Jan 2010 04:00:13 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id GvjvI26BGzOualZc for
	<xfs@oss.sgi.com>; Sun, 17 Jan 2010 04:00:13 -0800 (PST)
Date: Sun, 17 Jan 2010 07:00:12 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsdump: Clean up build output
Message-ID: <20100117120012.GC16856@infradead.org>
References: <1263429589-12896-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1263429589-12896-1-git-send-email-david@fromorbit.com>
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

On Thu, Jan 14, 2010 at 11:39:49AM +1100, Dave Chinner wrote:
> We don't need to see every compiler command line for every file that
> is compiled. This makes it hard to see warnings and errors during
> compile. For progress notification, we really only need to see the
> directory/file being operated on.
> 
> Turn down the verbosity of output by suppressing various make output
> and provide better overall visibility of which directory is being
> operated on, what the operation is and what is being done to the
> files by the build/clean process. Also fix the top level clean rule
> so that we don't run configure scripts after a make clean, only
> after a make distclean.
> 
> The old style verbose builds can still be run via "make V=1 ..."


Looks good except that the make clean changes really should be separate
as in xfsprogs.


Reviewed-by: Christoph Hellwig <hch@lst.de>

For the both bits, although they should be separate.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
