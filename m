Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C27B47F37
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 03:04:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 913848F806F
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 01:04:02 -0700 (PDT)
Received: from chinook.cae-engineering.hu (chinook.cae-engineering.hu
	[213.165.74.136]) by cuda.sgi.com with ESMTP id
	MFIKtrioqBy1ocNd for <xfs@oss.sgi.com>;
	Wed, 15 May 2013 01:03:57 -0700 (PDT)
Date: Wed, 15 May 2013 10:03:55 +0200
From: Andras Korn <korn-xfs@elan.rulez.org>
Subject: Re: wishlist: xfs_repair should detect files with too small sizes
Message-ID: <20130515080355.GL17260@hellgate>
References: <20130514215550.GK17260@hellgate> <20130515004736.GM29466@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130515004736.GM29466@dastard>
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
To: xfs@oss.sgi.com

On Wed, May 15, 2013 at 10:47:36AM +1000, Dave Chinner wrote:

> > I have thousands of files on xfs whose inode claims their size is zero, but
> > they have blocks allocated to them; du(1) reports a nonzero size. xfs_repair
> > 3.1.9 ignores this. xfs_db can be used to recover the contents of the files
> > (using commands like inode 1234; write core.size 4567).
> > 
> > David Chinner explained to me that xfs_repair ignores these files because
> > it's legitimate to have blocks beyond eof (e.g. due to fallocate()), and
> 
> Actually due to speculative preallocation done by delayed
> allocation.

But if the space is preallocated speculatively and then remains unused,
shouldn't it get freed up somehow, eventually?

> > that unwritten extent flagging doesn't help because such extents don't need
> > to be flagged as it's impossible to read them.
> 
> fallocate will leave unwritten extents beyond EOF, in which case we
> can detect it, but we know there's nothing to be done as there's no
> data....

OK, so we have the following cases:

1. fallocate. The file has more space allocated to it than the size field in
its inode says, and the extra extents are flagged as unwritten.

2. speculative preallocation. Same as above, but the extents are not flagged
as unwritten.

3. corruption. The file's inode reports an incorrect size for whatever
reason. If it's too much, that's easy to detect; the problem is telling if
it's too little.

Distinguishing between #1 and #2 is possible based on the unwritten flags.
In case #2, I think the extra space should be possible to free up (perhaps
by xfs_repair?). Of course, I suppose you could just run truncate(1) on all
files...

The problem is recognising #3.

Do I have that right?

> > I think it would be useful to have the ability to distinguish between files
> > that legitimately have extents beyond EOF and files whose inode incorrectly
> > reports a too-small size.
> 
> How? Add a transaction to track the data that has been written?
> 
> Well, we already do that - with the inode size.

Ah, yes, that's true.

OK, thinking about it I realise there doesn't appear to be a good way of
preventing the problem, but I'm still not sure some heuristic couldn't be
invented to detect and partially remedy it after the fact.

-- 
                     Andras Korn <korn at elan.rulez.org>
  C++ is like an onion. It's got so many layers that you can't help but cry.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
