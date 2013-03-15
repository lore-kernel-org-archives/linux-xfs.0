Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9C22F7FD1
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 03:32:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 32EE4AC005
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 01:32:02 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	tZYwtQ7cHYaOg1FJ for <xfs@oss.sgi.com>;
	Fri, 15 Mar 2013 01:32:00 -0700 (PDT)
Date: Fri, 15 Mar 2013 19:31:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 11/18] xfstests: add tests into tests/xfs/group
Message-ID: <20130315083157.GD2559@dastard>
References: <20130314130611.935D953DEAF8@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130314130611.935D953DEAF8@polaris-admin.engr.sgi.com>
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
To: Philip White <pwhite@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Mar 14, 2013 at 06:06:11AM -0700, Philip White wrote:
> From: Phil White <pwhite@sgi.com>
> 
> 
> This is a rebasing & resubmit of a dchinner patch.  His comments on the
> original:
> -----------------
> And into tests/xfs. Tests found and moved via:
> 
> $ grep "supported_fs xfs$" [0-2]* | cut -d : -f 1 > xfs.tests
> $ for i in `cat xfs.tests`; do
> > git mv $i* tests/xfs/
> > grep ^$i group >> tests/xfs/group
> > sed -i -e "/^$i/d" group
> > done
> 
> Output now looks like:
> 
>  sudo ./check -g quick -r
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 test-1 3.5.0-rc5-dgc+
> MKFS_OPTIONS  -- -f -bsize=4096 /dev/vdb
> MOUNT_OPTIONS -- /dev/vdb /mnt/scratch
> 
> xfs/170  4s
> generic/120      16s
> generic/248      0s
> generic/213      0s
> generic/256      39s
> xfs/121  6s
> xfs/026  11s
> generic/131      1s
> xfs/187  1s
> generic/135      0s
> ....
> -----------------
> For ease of reviewing, I put all the actual test movements into a separate
> patch.

Where is that patch - I don't see it in the series.

As it is, moving the files in a different patch to the group file
changes breaks xfstests. One of the things I made sure of was that
after each patch, the entire set of tests still ran properly with
something like "./check -g auto", and this separation looks lik eit
breaks that.

As it is, nobody is going to review a patch that has a diffstat of
+/-80,000 lines, which means it's irrelevant if it is in another
patch or not. As such, you don't need to send such patches as traditional diffs -
the git aware diff format is far better for this and easy to review
even whenteh file movement in is the same patch. See

http://oss.sgi.com/archives/xfs/2012-07/msg00389.html

To see how i sent this previously.

You are using git (though a very old version), so you should be bale
to get patches output in the correct manner...

-Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
