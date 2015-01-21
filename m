Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7A52D7F4E
	for <xfs@oss.sgi.com>; Wed, 21 Jan 2015 16:26:44 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 580758F8037
	for <xfs@oss.sgi.com>; Wed, 21 Jan 2015 14:26:44 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	U4Z4J7EYVyop9jTW for <xfs@oss.sgi.com>;
	Wed, 21 Jan 2015 14:26:42 -0800 (PST)
Date: Thu, 22 Jan 2015 09:26:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 0/6] xfs: truncate vs page fault IO exclusion
Message-ID: <20150121222639.GJ16552@dastard>
References: <1420669543-8093-1-git-send-email-david@fromorbit.com>
	<20150108122448.GA18034@infradead.org>
	<20150112174258.GN4468@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150112174258.GN4468@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, xfs@oss.sgi.com

On Mon, Jan 12, 2015 at 06:42:58PM +0100, Jan Kara wrote:
> On Thu 08-01-15 04:24:48, Christoph Hellwig wrote:
> > > This patchset passes xfstests and various benchmarks and stress
> > > workloads, so the real question is now:
> > > 
> > > 	What have I missed?
> > > 
> > > Comments, thoughts, flames?
> > 
> > Why is this done in XFS and not in generic code?
>   I was also thinking about this. In the end I decided not to propose this
> since the new rw-lock would grow struct inode and is actually necessary
> only for filesystems implementing hole punching AFAICS. And that isn't
> supported by that many filesystems. So fs private implementation which
> isn't that complicated looked like a reasonable solution to me...

Ok, so it seems that doing this in the filesystem itself as an
initial solution is the way to move forward. Given that, this
patchset has run through regression and stress testing for a couple
of weeks without uncovering problems, so now I'm looking for reviews
so I can commit it. Anyone?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
