Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8922A7F3F
	for <xfs@oss.sgi.com>; Wed, 17 Jul 2013 22:42:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 685708F8039
	for <xfs@oss.sgi.com>; Wed, 17 Jul 2013 20:42:31 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	D9cztvvPGqrGjGN2 for <xfs@oss.sgi.com>;
	Wed, 17 Jul 2013 20:42:29 -0700 (PDT)
Date: Thu, 18 Jul 2013 13:42:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: splice vs execve lockdep trace.
Message-ID: <20130718034203.GO11674@dastard>
References: <20130716193332.GB3572@sgi.com>
	<CA+55aFzTBUKStdZu1GhKoiYc2knybhiaUFr2By98QYew_STE=A@mail.gmail.com>
	<20130716204335.GH11674@dastard>
	<CA+55aFwHMQd-VDeTDh-gm3jyj+5+FSoAHOeU47mwU-mKtEj9RQ@mail.gmail.com>
	<20130717040616.GI11674@dastard>
	<CA+55aFz5xw9Qi9Q6mwoCSud5eQh5u-QZ-xrY+TqgZPoKOgn6ew@mail.gmail.com>
	<20130717055103.GK11674@dastard>
	<CA+55aFxdqzMY5VJoYaLmL=+=f2s1cbHHV-TjC3=taXpF-xov1w@mail.gmail.com>
	<20130717234049.GC3572@sgi.com>
	<CA+55aFy-8QH4bTW7hU=381tuEWgHC=PUM6WP3qn-ooge=7M0QQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+55aFy-8QH4bTW7hU=381tuEWgHC=PUM6WP3qn-ooge=7M0QQ@mail.gmail.com>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, Ben Myers <bpm@sgi.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Dave Jones <davej@redhat.com>, xfs@oss.sgi.com

On Wed, Jul 17, 2013 at 05:17:36PM -0700, Linus Torvalds wrote:
> On Wed, Jul 17, 2013 at 4:40 PM, Ben Myers <bpm@sgi.com> wrote:
> >>
> >> We're still talking at cross purposes then.
> >>
> >> How the hell do you handle mmap() and page faulting?
> >
> > __xfs_get_blocks serializes access to the block map with the i_lock on the
> > xfs_inode.  This appears to be racy with respect to hole punching.
> 
> Would it be possible to just make __xfs_get_blocks get the i_iolock
> (non-exclusively)?

No. __xfs_get_blocks() operates on metadata (e.g. extent lists), and
as such is protected by the i_ilock (note: not the i_iolock).  i.e.
XFS has a multi-level locking strategy:

	i_iolock is provided for *data IO serialisation*,
	i_ilock is for *inode metadata serialisation*.

Truncate and hole punching require IO level serialisation rather
than metadata or page cache level serialisation as they have to be
safe against direct IO as well as page cache based IO.

> Or, alternatively, do it in the readpage() function?
> 
> That was what I thought you did anyway. Exactly because of the whole
> page faulting issue.

We protect the inode itself with the i_ilock in the page fault path,
but we have no IO level serialisation. Racing faults serialise
access to inode metadata via on the i_ilock, but this doesn't
serialise against IO in progress....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
