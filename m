Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3Q2hSUP051360 for <xfs@oss.sgi.com>; Sun, 25 Apr 2010 21:43:28 -0500
Received: from thunker.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 306D22EE10B
	for <xfs@oss.sgi.com>; Sun, 25 Apr 2010 19:45:30 -0700 (PDT)
Received: from thunker.thunk.org (thunk.org [69.25.196.29]) by cuda.sgi.com
	with ESMTP id 6EDxUItbM9VBE7Bt for <xfs@oss.sgi.com>;
	Sun, 25 Apr 2010 19:45:30 -0700 (PDT)
Date: Sun, 25 Apr 2010 22:45:27 -0400
From: tytso@mit.edu
Subject: Re: [PATCH 3/4] writeback: pay attention to wbc->nr_to_write in
	write_cache_pages
Message-ID: <20100426024527.GD13043@thunk.org>
References: <1271731314-5893-1-git-send-email-david@fromorbit.com>
	<1271731314-5893-4-git-send-email-david@fromorbit.com>
	<20100425033315.GC667@thunk.org> <20100426014908.GD11437@dastard>
	<20100426024302.GC13043@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100426024302.GC13043@thunk.org>
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
To: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Sun, Apr 25, 2010 at 10:43:02PM -0400, tytso@MIT.EDU wrote:
> Have you tested with multiple files that are subject to writeout at
> the same time?  After all, if your I/O allocator does a great job of
> keeping the files contiguous in chunks larger tham 4MB, then if you
> have two or more files that need to be written out, the page allocator
> will round robin between the two files in 4MB chunks, and that might
> not be considered an ideal I/O pattern.

Argh.  Sorry for not proof reading better before hitting the send
key....

s/tham/than/
s/page allocator/writeback code/

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
