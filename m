Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E07777F52
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 05:47:47 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CCD7E8F8052
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 03:47:38 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	7cg6JBH5yCwG6F8o for <xfs@oss.sgi.com>;
	Fri, 13 Dec 2013 03:47:28 -0800 (PST)
Date: Fri, 13 Dec 2013 22:47:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] Handling of reviewed patch series
Message-ID: <20131213114723.GM31386@dastard>
References: <20131213053611.GQ10988@dastard>
	<20131213111959.GF23546@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131213111959.GF23546@infradead.org>
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

On Fri, Dec 13, 2013 at 03:19:59AM -0800, Christoph Hellwig wrote:
> 
> I'm a big fan of the for-next vs for-linux split for next release work
> vs bugfixes which we've not applied yet.  The whole topic branches
> scheme makes sense for large changes like the crc work, but seems
> utterly confusing if applied to every little change, as now the amount
> of branches you can conflict againt multiplies.  I'm defintively in
> favour of a model that has less active branches.

I certainly wouldn't want to create topic branches for every
standalone patch - that doesn't make any sense from a management
overhead point of view. I'd keep a "miscellaneous" topic branch
specifically for aggregating standalone and small fixes, and that
keeps the number of topic branches under control.

The way I see it from a developer POV is that after the topic branch
is created you can check that it matches your local changes, then
just ignore it. You continue to work from the for-next branch (which
now includes your work from the topic branch), or continue to target
the unchanging master branch or the for-next merge target branch,
which would be the same as what you work from now.

In the case that you have work that is dependent on a specific topic
branch, we can add the work to the end of that topic branch rather
than create a new one. Or if you have dependencies across
everything, then you develop against for-next and we simply make
that the last topic branch to be merged into for-next.

i.e. as a developer, you really don't need to care that much about
individual topic branches and how they are managed....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
