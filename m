Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4307D7CBE
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 20:12:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0E0318F8049
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 18:12:31 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	TvcX1rt14WCyIVoB for <xfs@oss.sgi.com>;
	Sun, 11 Aug 2013 18:12:30 -0700 (PDT)
Date: Mon, 12 Aug 2013 11:11:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** Re: [PATCH] _test_generic_punch: Extend
	$testfile's size to work with 64k block.
Message-ID: <20130812011155.GL12779@dastard>
References: <3326777.u9YeDIQiYF@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <3326777.u9YeDIQiYF@localhost.localdomain>
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
To: chandan <chandan@linux.vnet.ibm.com>
Cc: sekharan@linux.vnet.ibm.com, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Thu, Aug 08, 2013 at 11:40:04AM +0530, chandan wrote:
> From cf6e1fc3a8d7806a97055b5f483cf50f58c8294f Mon Sep 17 00:00:00 2001
> From: chandan <chandan@linux.vnet.ibm.com>
> Date: Thu, 8 Aug 2013 11:33:10 +0530
> Subject: [PATCH] _test_generic_punch: Extend $testfile's size to work with 64k
>  block.
> 
> The current script does not work with 64k block size. This patch fixes it
> by creating a larger $testfile.

I can see why we might want to support such a configuration, but the
changes being made defeat the purpose of the sizes chosen for this
test.

That is, most people testing are using 4k block size filesystems,
and the sizes are selected such that single blocks are being
manipulated by the test. it's looking for corner/edge case problems,
and changing the code to now use chunks of 64k changes all the edge
cases being tested.

Indeed, even the new bmap output is likely to cause problems in that
small block size filesystems are no guaranteed to allocate
contiguous blocks linearly. This is another reason that 4k was
chosen as the size of the regions.

So, to do this properly, I'd suggest that the code needs to scale
the offset/size of the IO being done by the filesystem block size,
not use a fixed size. Using a filter on the bmap output to handle
the different block ranges will ensure everything works correctly
from a golden output POV, except for one thing - the md5sum.

The md5sum of the file is used for integrity checking and will
change as the block size changes. I haven't thought about a way to
avoid his problem yet but we do need some form of integrity check
to ensure all filesystems are ending up with the correct contents in
the files.

In the interim, if all you want to do is stop a test failure on your
power machines, then either add a "_requires_le_4k_blocksize" check
to avoid running the test on problematic filesystems or specifically
create the fileystem being tested with a 4k block size...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
