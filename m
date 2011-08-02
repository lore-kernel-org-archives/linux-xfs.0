Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p72ADRuA096291 for <xfs@oss.sgi.com>; Tue, 2 Aug 2011 05:13:27 -0500
Date: Tue, 2 Aug 2011 06:13:25 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] xfsdump: remove conditional OPENMASKED code
Message-ID: <20110802101325.GA16239@infradead.org>
References: <1311972011-1446-1-git-send-email-wkendall@sgi.com>
	<1311972011-1446-2-git-send-email-wkendall@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1311972011-1446-2-git-send-email-wkendall@sgi.com>
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

On Fri, Jul 29, 2011 at 03:40:08PM -0500, Bill Kendall wrote:
> xfsdump contains a couple wrapper functions which block signals
> during an open(2) call. This code is conditionally compiled and has
> not been enabled for a long time. Remove the wrappers rather than
> converting them to use the POSIX signal API.
> 
> Signed-off-by: Bill Kendall <wkendall@sgi.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Any idea what this code was used for?  Driver-specific open quirks on
IRIX?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
