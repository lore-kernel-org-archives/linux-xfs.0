Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9G5wnlT070044 for <xfs@oss.sgi.com>; Fri, 16 Oct 2009 00:58:51 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 693CBF0B7
	for <xfs@oss.sgi.com>; Thu, 15 Oct 2009 23:00:20 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 3Gut9GyO5mIbDslp for
	<xfs@oss.sgi.com>; Thu, 15 Oct 2009 23:00:20 -0700 (PDT)
Date: Fri, 16 Oct 2009 02:00:17 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Wrapped journal record corruption on read at recovery - patch
	attached (was Re: XFS corruption with failover)
Message-ID: <20091016060017.GA19051@infradead.org>
References: <mailman.0.1255458988.141519.xfs@oss.sgi.com>
	<alpine.DEB.2.00.0910131342440.11546@andydesk>
	<20091013233324.GA28942@infradead.org>
	<alpine.DEB.2.00.0910131853200.11546@andydesk>
	<20091014132030.GB15001@infradead.org>
	<alpine.DEB.2.00.0910141053150.5504@andydesk>
	<alpine.DEB.2.00.0910151858340.5504@andydesk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0910151858340.5504@andydesk>
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
To: Andy Poling <andy@realbig.com>
Cc: Christoph Hellwig <hch@infradead.org>, John Quigley <jquigley@cleversafe.com>, xfs@oss.sgi.com

On Thu, Oct 15, 2009 at 07:36:33PM -0500, Andy Poling wrote:
> Looking at the improved code since 2.6.29, and assuming that the beginning of
> the log will always be aligned, I have come up with the attached patch against
> 2.6.31.4.  I think it's cleaner, and it passes my tests.
>
> The bufaddr variable is no longer needed.  I removed the xlog_align() after
> the second read for both headers and data since the second read will always be
> aligned (even if there was no first read) since it is always at the beginning
> of the log.
>
> It sets offset to the beginning of the buffer with XFS_BUF_PTR() before the
> first read, and then your improved xlog_bread() will update the offset if the
> first read had to be re-aligned.
>
> What do you think?

The patch looks good to me from a quick glance.  I still need to read
through the code in that area a bit more, and I really want to write a QA
testcase to reproduce it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
