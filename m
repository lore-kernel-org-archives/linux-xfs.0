Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3982A7F3F
	for <xfs@oss.sgi.com>; Fri, 10 Jan 2014 12:14:39 -0600 (CST)
Date: Fri, 10 Jan 2014 12:14:34 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] vfs: Fix possible NULL pointer dereference in
	inode_permission()
Message-ID: <20140110181434.GH1935@sgi.com>
References: <20140109214239.GD29910@parisc-linux.org>
	<20140109165012.391db81e@gandalf.local.home>
	<20140109223127.GM10323@ZenIV.linux.org.uk>
	<CA+55aFzCTPYEQCPnLBi1CwmMTocVqCFiCuJ391HkVx1CMw61ug@mail.gmail.com>
	<20140109182523.5b50131f@gandalf.local.home>
	<20140109182756.17abaaa8@gandalf.local.home>
	<1389310626.15209.92.camel@localhost>
	<CA+55aFzd2nw=JU4s0u=PJbATK0bwhm0kot3zRH=anLLT6THRFQ@mail.gmail.com>
	<20140110000642.GN10323@ZenIV.linux.org.uk>
	<20140110093148.GA26159@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140110093148.GA26159@infradead.org>
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
Cc: Theodore Ts'o <tytso@mit.edu>, Paul Moore <paul@paul-moore.com>, Matthew Wilcox <matthew@wil.cx>, Linus Torvalds <torvalds@linux-foundation.org>, Eric Paris <eparis@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>, xfs@oss.sgi.com, Al Viro <viro@ZenIV.linux.org.uk>, James Morris <james.l.morris@oracle.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, stable <stable@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Stephen Smalley <sds@tycho.nsa.gov>

Christoph,

On Fri, Jan 10, 2014 at 01:31:48AM -0800, Christoph Hellwig wrote:
> On Fri, Jan 10, 2014 at 12:06:42AM +0000, Al Viro wrote:
> > Check what XFS is doing ;-/  That's where those call_rcu() have come from.
> > Sure, we can separate the simple "just do call_rcu(...->free_inode)" case
> > and hit it whenever full ->free_inode is there and ->destroy_inode isn't.
> > Not too pretty, but removal of tons of boilerplate might be worth doing
> > that anyway.  But ->destroy_inode() is still needed for cases where fs
> > has its own idea of inode lifetime rules.  Again, check what XFS is doing
> > in that area...
> 
> Btw, I'd really love to get rid of the XFS ->destroy_inode abuse, it's
> been a long time thorn in the flesh.

I believe this behavior is related to freeing of an inode cluster.

> What's really needed there to make XFS behave more similar to everyone
> else is a way for the filesystem to say: "I can't actually free this
> inode right now, but I'll come back to you later".

This test might read something like:  "If my link count has gone to zero, and I
am the last inode in my cluster to be freed, and there are other inodes from my
cluster incore, I cannot be freed."

Should be doable.  Maybe there are other reasons.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
