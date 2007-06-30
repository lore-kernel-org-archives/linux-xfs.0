Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 30 Jun 2007 02:49:58 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5U9nstL025773
	for <xfs@oss.sgi.com>; Sat, 30 Jun 2007 02:49:55 -0700
Date: Sat, 30 Jun 2007 10:34:13 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [-mm PATCH] ocfs2: ->fallocate() support
Message-ID: <20070630093413.GE22354@infradead.org>
References: <20070621190143.GC17713@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070621190143.GC17713@ca-server1.us.oracle.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Amit Arora <aarora@in.ibm.com>, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com

On Thu, Jun 21, 2007 at 12:01:43PM -0700, Mark Fasheh wrote:
> Plug ocfs2 into the ->fallocate() callback. We only support FA_ALLOCATE for
> now - FA_DEALLOCATE will come later.

Btw, it seems like ocfs implements the xfs preallocation ioctls.  What
would people thing about moving those up to work over ->fallocate so they
can be used on all filesystems that support preallocation?  While the
ABI is quite ugly it has a huge userbase because it's the only existing
preallocation mechanism on Linux.
