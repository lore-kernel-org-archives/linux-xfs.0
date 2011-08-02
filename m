Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p72AFWtu096513 for <xfs@oss.sgi.com>; Tue, 2 Aug 2011 05:15:33 -0500
Date: Tue, 2 Aug 2011 06:15:30 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4] xfsdump: process EPIPE instead of catching SIGPIPE
Message-ID: <20110802101530.GB16239@infradead.org>
References: <1311972011-1446-1-git-send-email-wkendall@sgi.com>
	<1311972011-1446-3-git-send-email-wkendall@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1311972011-1446-3-git-send-email-wkendall@sgi.com>
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
To: Bill Kendall <wkendall@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Jul 29, 2011 at 03:40:09PM -0500, Bill Kendall wrote:
> Looking forward towards a multi-threaded xfsdump, it's simpler to
> handle pipe failures as a system call failure (EPIPE) rather than
> through a signal handler which may run in a separate thread. The
> existing error handling code handles EPIPE just fine, so the only
> required change is to ignore SIGPIPE. Some sections of code already
> temporarily ignore SIGPIPE -- they no longer need to do so since it
> will already be ignored.

Looks good, and the less we do with signals, the better.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
