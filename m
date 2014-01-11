Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 47EFB7F3F
	for <xfs@oss.sgi.com>; Sat, 11 Jan 2014 04:32:44 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CE6D3AC002
	for <xfs@oss.sgi.com>; Sat, 11 Jan 2014 02:32:40 -0800 (PST)
Date: Sat, 11 Jan 2014 02:32:35 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] vfs: Fix possible NULL pointer dereference in
	inode_permission()
Message-ID: <20140111103234.GC22098@infradead.org>
References: <20140109165012.391db81e@gandalf.local.home>
	<20140109223127.GM10323@ZenIV.linux.org.uk>
	<CA+55aFzCTPYEQCPnLBi1CwmMTocVqCFiCuJ391HkVx1CMw61ug@mail.gmail.com>
	<20140109182523.5b50131f@gandalf.local.home>
	<20140109182756.17abaaa8@gandalf.local.home>
	<1389310626.15209.92.camel@localhost>
	<CA+55aFzd2nw=JU4s0u=PJbATK0bwhm0kot3zRH=anLLT6THRFQ@mail.gmail.com>
	<20140110000642.GN10323@ZenIV.linux.org.uk>
	<20140110093148.GA26159@infradead.org>
	<20140110181434.GH1935@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140110181434.GH1935@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Paul Moore <paul@paul-moore.com>, Matthew Wilcox <matthew@wil.cx>, Linus Torvalds <torvalds@linux-foundation.org>, Eric Paris <eparis@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Al Viro <viro@ZenIV.linux.org.uk>, James Morris <james.l.morris@oracle.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, stable <stable@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Stephen Smalley <sds@tycho.nsa.gov>

On Fri, Jan 10, 2014 at 12:14:34PM -0600, Ben Myers wrote:
> > What's really needed there to make XFS behave more similar to everyone
> > else is a way for the filesystem to say: "I can't actually free this
> > inode right now, but I'll come back to you later".
> 
> This test might read something like:  "If my link count has gone to zero, and I
> am the last inode in my cluster to be freed, and there are other inodes from my
> cluster incore, I cannot be freed."

It's more complicated than that.  In theory we would free the inode
easily as soon as the VFS wants it, but performance would be horrible
as we would have to synchronously write back the inode.  Note that it
really matters for the interface, that just needs to be an:  I won't
free this right now, but I'll call you back later when I can.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
