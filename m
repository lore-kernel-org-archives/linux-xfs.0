Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EAE427F3F
	for <xfs@oss.sgi.com>; Fri, 10 Jan 2014 03:32:14 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DDBB730406B
	for <xfs@oss.sgi.com>; Fri, 10 Jan 2014 01:32:11 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id d5usdHy3AlpAYXhZ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Jan 2014 01:32:11 -0800 (PST)
Date: Fri, 10 Jan 2014 01:31:48 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] vfs: Fix possible NULL pointer dereference in
	inode_permission()
Message-ID: <20140110093148.GA26159@infradead.org>
References: <20140109162731.12500986@gandalf.local.home>
	<20140109214239.GD29910@parisc-linux.org>
	<20140109165012.391db81e@gandalf.local.home>
	<20140109223127.GM10323@ZenIV.linux.org.uk>
	<CA+55aFzCTPYEQCPnLBi1CwmMTocVqCFiCuJ391HkVx1CMw61ug@mail.gmail.com>
	<20140109182523.5b50131f@gandalf.local.home>
	<20140109182756.17abaaa8@gandalf.local.home>
	<1389310626.15209.92.camel@localhost>
	<CA+55aFzd2nw=JU4s0u=PJbATK0bwhm0kot3zRH=anLLT6THRFQ@mail.gmail.com>
	<20140110000642.GN10323@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140110000642.GN10323@ZenIV.linux.org.uk>
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
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Theodore Ts'o <tytso@mit.edu>, Paul Moore <paul@paul-moore.com>, Matthew Wilcox <matthew@wil.cx>, Stephen Smalley <sds@tycho.nsa.gov>, LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>, xfs@oss.sgi.com, Eric Paris <eparis@redhat.com>, James Morris <james.l.morris@oracle.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, stable <stable@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Linus Torvalds <torvalds@linux-foundation.org>

On Fri, Jan 10, 2014 at 12:06:42AM +0000, Al Viro wrote:
> Check what XFS is doing ;-/  That's where those call_rcu() have come from.
> Sure, we can separate the simple "just do call_rcu(...->free_inode)" case
> and hit it whenever full ->free_inode is there and ->destroy_inode isn't.
> Not too pretty, but removal of tons of boilerplate might be worth doing
> that anyway.  But ->destroy_inode() is still needed for cases where fs
> has its own idea of inode lifetime rules.  Again, check what XFS is doing
> in that area...

Btw, I'd really love to get rid of the XFS ->destroy_inode abuse, it's
been a long time thorn in the flesh.

What's really needed there to make XFS behave more similar to everyone
else is a way for the filesystem to say: "I can't actually free this
inode right now, but I'll come back to you later".  That's what we
actually do right now, except we pretend that the VFS inode gets freed,
while its memory lives on (punt intended).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
