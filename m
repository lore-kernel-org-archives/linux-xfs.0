Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p73AuFQ2148725 for <xfs@oss.sgi.com>; Wed, 3 Aug 2011 05:56:15 -0500
Date: Wed, 3 Aug 2011 06:56:13 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] xfsdump: convert to the POSIX signal API
Message-ID: <20110803105613.GA7030@infradead.org>
References: <1311972011-1446-1-git-send-email-wkendall@sgi.com>
	<1311972011-1446-5-git-send-email-wkendall@sgi.com>
	<20110803104813.GA3575@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110803104813.GA3575@infradead.org>
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

On Wed, Aug 03, 2011 at 06:48:13AM -0400, Christoph Hellwig wrote:
> Why yare all these sigaction calls needed?   As far as I can see
> there is no way we'll ever use a different signal handler than
> "sigaction" for any signal, so simply modifying the signal mask
> should be enough.

Sorry, the on eand only signal handler is called "sighandler" of course.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
