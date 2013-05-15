Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1E4217F37
	for <xfs@oss.sgi.com>; Tue, 14 May 2013 19:47:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0D7488F8049
	for <xfs@oss.sgi.com>; Tue, 14 May 2013 17:47:49 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	9C16plw8JcsnUSPr for <xfs@oss.sgi.com>;
	Tue, 14 May 2013 17:47:48 -0700 (PDT)
Date: Wed, 15 May 2013 10:47:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: wishlist: xfs_repair should detect files with too small sizes
Message-ID: <20130515004736.GM29466@dastard>
References: <20130514215550.GK17260@hellgate>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130514215550.GK17260@hellgate>
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
To: Andras Korn <korn-xfs@elan.rulez.org>
Cc: xfs@oss.sgi.com

On Tue, May 14, 2013 at 11:55:50PM +0200, Andras Korn wrote:
> Hi,
> 
> I have thousands of files on xfs whose inode claims their size is zero, but
> they have blocks allocated to them; du(1) reports a nonzero size. xfs_repair
> 3.1.9 ignores this. xfs_db can be used to recover the contents of the files
> (using commands like inode 1234; write core.size 4567).
> 
> David Chinner explained to me that xfs_repair ignores these files because
> it's legitimate to have blocks beyond eof (e.g. due to fallocate()), and

Actually due to speculative preallocation done by delayed
allocation.

> that unwritten extent flagging doesn't help because such extents don't need
> to be flagged as it's impossible to read them.

fallocate will leave unwritten extents beyond EOF, in which case we
can detect it, but we know there's nothing to be done as there's no
data....

> My zero-sized files were likely effected by a crash (certainly not
> fallocate()).
> 
> I think it would be useful to have the ability to distinguish between files
> that legitimately have extents beyond EOF and files whose inode incorrectly
> reports a too-small size.

How? Add a transaction to track the data that has been written?

Well, we already do that - with the inode size.

How do we prevent that from going missing when the application
doesn't use fsync()? By making all inode size update transactions
synchronous.  i.e. really, really slow.

Really, the problem you see is that the applicaiton is not using
fsync, and so there's no guarantee what part of the change has got
to disk when a crash occurs.

> Maybe an allocated-size field could be added to the inode,

That's in the extent map.

> or extents
> assigned to files via fallocate() could be flagged somehow?

They are flagged as unwritten, even beyond EOF.

> And if files
> with incorrect sizes (i.e. where allocated-size div blocksize < number_of_blocks
> OR allocated-size < core.size OR where a file contains extents beyond EOF
> that are not fallocate-flagged) are found, xfs_repair could at least report
> them?

Like I said - how do you reliably determine that there's data in the
blocks if you can lose the update that indicates that there's data
in the blocks?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
