Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5808rBM178560 for <xfs@oss.sgi.com>; Mon, 7 Jun 2010 19:08:53 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 095D13A0417
	for <xfs@oss.sgi.com>; Mon,  7 Jun 2010 17:11:23 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	WcSzrfBEs5ZovLtV for <xfs@oss.sgi.com>;
	Mon, 07 Jun 2010 17:11:23 -0700 (PDT)
Date: Tue, 8 Jun 2010 10:11:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/6] writeback: tracing and fixes V3.
Message-ID: <20100608001115.GB6965@dastard>
References: <1275609328-12514-1-git-send-email-david@fromorbit.com>
	<20100604074938.GB4448@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100604074938.GB4448@infradead.org>
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
Cc: linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Fri, Jun 04, 2010 at 03:49:38AM -0400, Christoph Hellwig wrote:
> 
> Not sure what the rules for new tracepoints are, but in addition to the
> fixes I'd really love to see the tracepoints in 2.6.35.

Personally I think they are just as important (or even more
important) than the bug fixes because we seem to break this code
regularly because nobody can clearly see what the internals are
doing to verify their change is working correctly.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
