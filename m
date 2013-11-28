Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 562F57F51
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 10:26:27 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E6812AC003
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 08:26:23 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id wVSA8CgQXdCLJRZN (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 28 Nov 2013 08:26:21 -0800 (PST)
Date: Thu, 28 Nov 2013 16:26:18 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: inode_permission NULL pointer dereference in 3.13-rc1
Message-ID: <20131128162618.GO10323@ZenIV.linux.org.uk>
References: <20131124140413.GA19271@infradead.org>
	<20131124152758.GL10323@ZenIV.linux.org.uk>
	<20131125160648.GA4933@infradead.org>
	<20131126131134.GM10323@ZenIV.linux.org.uk>
	<20131126141253.GA28062@infradead.org>
	<20131127064351.GN10323@ZenIV.linux.org.uk>
	<20131127100906.GA19740@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131127100906.GA19740@infradead.org>
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
Cc: linux-fsdevel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, xfs@oss.sgi.com

On Wed, Nov 27, 2013 at 02:09:06AM -0800, Christoph Hellwig wrote:

> Also if you want to look me into something else feel free - it's very
> reproducable here.  Wish I could be more help here, but with all the
> RCU and micro optimizations in the path lookup code I can't claim to
> really understand it anymore.

OK, I've been able to reproduce it and I see at least a part of what's
going on, but...

What happens is that we get path_init() race with something and leave
us with nd->path pointing to what used to be pwd but has become a
negative dentry in process.

AFAICS, it *was* borderline possible to hit before now:

process A and B are CLONE_FS threads and are chdired to /tmp/foo
A asks for e.g. readlink() on bar
	in path_init() we'd got nd->path (at /tmp/foo) and nd->seq; we are
	in LOOKUP_RCU mode, so nd->path isn't pinned.
B chdirs them both to /tmp, leaving /tmp/foo not busy
C rmdirs /tmp/foo
A sets nd->inode to nd->path.dentry->d_inode, but this sucker has gone
negative now.  Sure, nd->seq doesn't match anymore, but that doesn't
do us any good - the first thing we'll do in link_path_walk() is
may_lookup(nd) and it'll blow on attempt to call inode_permission() for
nd->inode.

What I still do not understand is how the devil is similar race actually
triggered during shutdown.  Digging through that right now...

Anyway, verifying that this is what's going on for particular reproducer
is easy - add WARN_ON(!nd->inode) in the very end of path_init() and
see if it triggers.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
