Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B04467F4E
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 19:24:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A44F08F8049
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 17:24:06 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	DJiPIwr2OxAnGuSG for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 17:24:04 -0700 (PDT)
Date: Wed, 16 Apr 2014 10:23:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: btrfs, test send's ability to punch holes and
	prealloc extents
Message-ID: <20140416002349.GV15995@dastard>
References: <1397580201-27475-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397580201-27475-1-git-send-email-fdmanana@gmail.com>
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
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: jbacik@fb.com, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, Apr 15, 2014 at 05:43:21PM +0100, Filipe David Borba Manana wrote:
> This test verifies that after an incremental btrfs send the replicated file has
> the same exact hole and data structure as in the origin filesystem. This didn't
> use to be the case before the send stream version 2 - holes were sent as write
> operations of 0 valued bytes instead of punching holes with the fallocate system
> call, and pre-allocated extents were sent as well as write operations of 0 valued
> bytes instead of intructions for the receiver to use the fallocate system call.
> Also checks that prealloc extents that lie beyond the file's size are replicated
> by an incremental send.

Can you wrap commit messages at 68 columns?

....
> +md5sum $SCRATCH_MNT/mysnap2/foo | _filter_scratch
> +# List all hole and data segments.
> +$XFS_IO_PROG -r -c "seek -r -a 0" $SCRATCH_MNT/mysnap2/foo
> +# List all extents, we're interested here in prealloc extents that lie beyond
> +# the file's size.
> +$XFS_IO_PROG -r -c "fiemap -l" $SCRATCH_MNT/mysnap2/foo | _filter_scratch

That dumps raw block numbers into the golden output. _filter_fiemap
is probably needed here.

> +md5sum $SCRATCH_MNT/mysnap2/foo | _filter_scratch
> +# List all hole and data segments.
> +$XFS_IO_PROG -r -c "seek -r -a 0" $SCRATCH_MNT/mysnap2/foo
> +# List all extents, we're interested here in prealloc extents that lie beyond
> +# the file's size.
> +$XFS_IO_PROG -r -c "fiemap -l" $SCRATCH_MNT/mysnap2/foo | _filter_scratch

Same here.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
