Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E19DD7F3F
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 15:00:44 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BE27A304066
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 13:00:44 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	JCCSMU0tjgT8XjV9 for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 13:00:43 -0800 (PST)
Date: Fri, 13 Dec 2013 08:00:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/5] repair: limit auto-striding concurrency apprpriately
Message-ID: <20131212210040.GB10988@dastard>
References: <1386832945-19763-1-git-send-email-david@fromorbit.com>
	<1386832945-19763-6-git-send-email-david@fromorbit.com>
	<20131212182908.GD10092@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131212182908.GD10092@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Dec 12, 2013 at 10:29:08AM -0800, Christoph Hellwig wrote:
> Looks reasonable, but it might be worth to add a blurb on how you
> arrived at the magic 8 threads per cpu.

OK - that was simply that processing with 8 threads is more than
enough to saturate a single CPU on fast devices so we don't need any
more parallelism in this case. And when you have large slow devices,
8 threads is more than enough to saturate the IO subsystem....

I'll add a comment mentioning that.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
