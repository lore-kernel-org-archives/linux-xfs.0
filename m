Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 922DB7CA0
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 16:17:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 58902304062
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 14:17:58 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	nJuSHFcOyEFKIQVL for <xfs@oss.sgi.com>;
	Tue, 12 Apr 2016 14:17:56 -0700 (PDT)
Date: Wed, 13 Apr 2016 07:17:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: PAGE_CACHE_* removal in 4.6-rc3
Message-ID: <20160412211753.GL567@dastard>
References: <20160412183105.GA10567@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160412183105.GA10567@infradead.org>
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

On Tue, Apr 12, 2016 at 11:31:05AM -0700, Christoph Hellwig wrote:
> Hi Dave,
> 
> upstream removed the PAGE_CACHE_* macros in 4.6-rc3, which will cause
> all kinds of interesting conflicts for FS work.  Maybe it's a good idea
> to rebase for-next ontop of -rc3 so that we can sort this out early?

Yeah, I was thinking of doing that when I saw that this was merged.

I've got a bit of stuff to sort out today, but I'll see what I can
do about moving the master branch forward and rebasing the for-next
branch on top of it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
