Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A27A07F50
	for <xfs@oss.sgi.com>; Sun, 26 Jan 2014 19:56:24 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 949558F8033
	for <xfs@oss.sgi.com>; Sun, 26 Jan 2014 17:56:24 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	18bDAnQdVAFzsBRa for <xfs@oss.sgi.com>;
	Sun, 26 Jan 2014 17:56:20 -0800 (PST)
Date: Mon, 27 Jan 2014 12:56:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [NOISE] merge window blues, XFS broken
Message-ID: <20140127015614.GD2212@dastard>
References: <52E56386.5040802@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52E56386.5040802@gmail.com>
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
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Sun, Jan 26, 2014 at 02:35:34PM -0500, Michael L. Semon wrote:
> Hi!  This is more an observation than a bug report, me trying to figure 
> out what happened on what is now a 3-day-old kernel on 32-bit x86 
> (Pentium 4).  The report is marked as [NOISE] because I can do this...
> 
> git pull origin master
> git remote update # updates xfs-oss
> git reset --hard v3.13
> git merge xfs-oss/master
> 
> ...and the resulting kernel and XFS will be as smooth as silk.  
> However, if I do this...
> 
> git pull origin master
> git remote update # at time of pull, "Already up-to-date."
> git merge xfs-oss/master
> 
> ...the resulting XFS will not pass this, for either v4- or v5-
> superblock XFS:
> 
> mkfs.xfs -f $TEST_DEV      # always OK
> mount $TEST_DEV $TEST_DIR  # may succeed, may fail
> ls $TEST_DIR/              # may succeed, may fail
> umount $TEST_DEV           # always fails
> 
> The assertion is this (from notes taken by hand):
> 
> Assertion failed: IS_ALIGNED((unsigned long)vec->i_addr, sizeof(uint64_t)), file: fs/xfs/xfs_log.h, line: 49

Hmmmm - that would point to struct xfs_log_iovec being 12 bytes on
ia32, similarly the struct xfs_log_vec may not be 8 byte aligned
when allocated because pointers only require 4 byte alignement.

Hence the initial data buffer may be 4 byte aligned and so that will
break the alignment requirement.

As a test, can you add pad both structures to be a multiple of 8
bytes in size, and add to them __aligned(8) so that they are
correctly aligned in memory? i.e.

struct xfs_log_vec {
	......
	int pad;
} __aligned(8);

struct xfs_log_iovec {
	......
	int pad;
} __aligned(8);

And see if that makes the problem go away?

> I work with pahole maybe once every three months, and my fuzzy memory, it 
> seems like there are more holes total on 32-bit x86 than there used to be, 
> don't know why.

Check the structs with pahole before and after you make the above
padding change to see if there is a difference in size and alignment
as a result.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
