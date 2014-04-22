Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 125B57F3F
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 16:07:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EFFC630404E
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 14:07:05 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	PaBKfLto74ngTvHL for <xfs@oss.sgi.com>;
	Tue, 22 Apr 2014 14:07:00 -0700 (PDT)
Date: Wed, 23 Apr 2014 07:06:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: filestream allocator rewrite
Message-ID: <20140422210655.GK18672@dastard>
References: <1397289723-26243-1-git-send-email-hch@lst.de>
	<20140414022347.GI27694@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140414022347.GI27694@dastard>
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
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Mon, Apr 14, 2014 at 12:23:47PM +1000, Dave Chinner wrote:
> On Sat, Apr 12, 2014 at 10:01:54AM +0200, Christoph Hellwig wrote:
> > This series is a major overhaul of the filestream allocator.  The main point
> > is to use the dcache to get the parent and avoiding to maintain a fstrm_item
> > for each inode that the filestream is applied to in favor of just tracking
> > the parent, but there's various more or less related fallout from this as well.
> 
> OVerall it looks good. I'll need to do some testing on it and 
> have a deeper look at the main use-the-dentry-cache patch, but it
> removes a heap of complexity and code and gets rid of the use of
> inode IO locks, so there's a loot to like here...

So I've looked over this in more detail and done some testing on it,
and apart from the comment I made about a function name, I can't
spot any problems with the code. In terms of testing, this passes
all of the filestreams group tests except of xfs/172, which still
randomly fails.  That makes it at least as reliable as the current
code.

However, the failure of xfs/172 is interesting. It is expecting
buffered IO to *fail* due to a short filestreams timeout that is
set. However, when it fails, it's actually separating the streams
correctly:

$ cat results//xfs/172.full
stream 1 AGs: 0 0 0 0 0 4 4 4
stream 2 AGs: 1 1 1 1 1 5 5 5
stream 3 AGs: 2 2 2 2 2 6 6 6
stream 4 AGs: 3 3 3 3 3 7 7 7
- streams are in separate AGs, expected _matching_
$

And that's because it's able to create an association with it's
parent at allocation time rather than create time. So, the test
failure is actually a case of "this works better than the old code"
and not a negative at all. And you can see where the AGs filled up
in this test, and so new associations for the streams had to be
made, and that worked just fine, too.

I've done some other, higher bandwidth testing similar to realtime
file-per-frame video ingest for 2k resolution video (12.8MB files,
writing as fast as possible using direct IO with a directory per
"video") and that works just fine at the limits of my local hardware
(about 850MB/s to disk).

So I'm going to modify the function name I disliked, and commit this
to a topic branch and push it into the for-next branch for wider
testing. If we need further modifications, we can fix them up
later....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
