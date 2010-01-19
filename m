Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0J9H6e2180084 for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 03:17:06 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BD7921C5E0CB
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 01:18:06 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id M3tJDStPxwwCoxyP for
	<xfs@oss.sgi.com>; Tue, 19 Jan 2010 01:18:06 -0800 (PST)
Date: Tue, 19 Jan 2010 04:18:06 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] xfsqa: Fix signal usage in aio-dio test code
Message-ID: <20100119091806.GF29269@infradead.org>
References: <1263891792-30952-1-git-send-email-david@fromorbit.com>
	<1263891792-30952-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1263891792-30952-3-git-send-email-david@fromorbit.com>
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

On Tue, Jan 19, 2010 at 08:03:11PM +1100, Dave Chinner wrote:
> Using signal() to set up signal handlers doesn't always do what you
> want. A recent upgrade made test 208 fail because wait() was not
> getting interrupted by a SIGALRM. Tracing showed that signal() was
> being converted to a sigaction(SA_RESTART) handler, which allows
> syscalls that return ERESTARTSYS to immediately restart without
> returning EINTR to the calling process. The kernel code returns
> ERESTARTSYS to signal interruptions while in wait().
> 
> Replace the use of signal with sigaction() to ensure that the
> SA_RESTART flag is not set and the EINTR is delivered to the process
> sitting in wait().  This makes test 208 terminate at 200s again.

Yeah, signal is deprecated in favour of sigaction for a reason..


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
