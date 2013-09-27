Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 33F9A29DFB
	for <linux-xfs@oss.sgi.com>; Thu, 26 Sep 2013 20:09:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EDF598F8040
	for <linux-xfs@oss.sgi.com>; Thu, 26 Sep 2013 18:09:22 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	ogqe7vDHfPucgn0T for <linux-xfs@oss.sgi.com>;
	Thu, 26 Sep 2013 18:09:20 -0700 (PDT)
Date: Fri, 27 Sep 2013 11:08:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: free inodes remaining in 1tb
Message-ID: <20130927010847.GW26872@dastard>
References: <44qehaxod8.ln2@goaway.wombat.san-francisco.ca.us>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <44qehaxod8.ln2@goaway.wombat.san-francisco.ca.us>
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
To: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Cc: linux-xfs@oss.sgi.com

On Thu, Sep 26, 2013 at 03:47:00PM -0700, Keith Keller wrote:
> Hi all,
> 
> I "recently" (a few months ago) came across the inode64 entries in the
> XFS FAQ.  Unfortunately, I have a filesystem not mounted with inode64,
> and I would like to know how many more inodes I can create in the
> first 1TB before I run out,

Depends on how much other data is allocated in the first TB
(occurs when you fill the space above 1TB completely), the
size of the allocation groups (how much of the first TB canbe used
for inodes), how many inodes and other metadata you've already
allocated, etc.

> so that I can plan for a migration to
> inode64 (if it's very few, I would make it a high priority; if not, it
> can be done in a few weeks instead, for example).  Is there an easy
> way (or even a hard way) to query the filesystem for this information?

Only a hard way - using xfs_db to look at on-disk structures and
inferring the state from there...

> I also wanted to ask about the FAQ that says you can switch back from
> inode64 to inode32.  How does that work if an inode is created past the
> 1TB mark?

Depends on how old your kernel is. Access to 64 bit inodes when
mounting with inode32 only came along in 2010:

commit fb3b504adeee942e55393396fea8fdf406acf037
Author: Christoph Hellwig <hch@infradead.org>
Date:   Fri May 28 19:03:10 2010 +0000

    xfs: fix access to upper inodes without inode64
    
    If a filesystem is mounted without the inode64 mount option we
    should still be able to access inodes not fitting into 32 bits, just
    not created new ones.  For this to work we need to make sure the
    inode cache radix tree is initialized for all allocation groups, not
    just those we plan to allocate inodes from.  This patch makes sure
    we initialize the inode cache radix tree for all allocation groups,
    and also cleans xfs_initialize_perag up a bit to separate the
    inode32 logical from the general perag structure setup.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Alex Elder <aelder@sgi.com>

So if you have an old kernel (older than 2.6.35), you won't be able
to access 64 bit inodes at all if you mount with inode32. Anything
more recent than that will work just fine.

> How would the kernel know how to find an inode64 inode that
> was created beyond the 1TB mark if the filesystem is subsequentely
> mounted without inode64?

The inode number is an encoding of the physical location of the inod
inthe filesystem. Hence the kernel code can always find the inode
location - it just may not be able to do anything with it because
the caches on old kernels can't index them...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
