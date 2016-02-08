Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F28E37CA2
	for <xfs@oss.sgi.com>; Sun,  7 Feb 2016 19:00:47 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D1F55304032
	for <xfs@oss.sgi.com>; Sun,  7 Feb 2016 17:00:44 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	FMrD4L6E4OJdlC88 for <xfs@oss.sgi.com>;
	Sun, 07 Feb 2016 17:00:28 -0800 (PST)
Date: Mon, 8 Feb 2016 12:00:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] xfs: don't use ioends for direct write completions
Message-ID: <20160208010026.GL31407@dastard>
References: <1454524816-11392-1-git-send-email-hch@lst.de>
	<1454524816-11392-3-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1454524816-11392-3-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com

On Wed, Feb 03, 2016 at 07:40:15PM +0100, Christoph Hellwig wrote:
> We only need to communicate two bits of information to the direct I/O
> completion handler:
> 
>  (1) do we need to convert any unwritten extents in the range
>  (2) do we need to check if we need to update the inode size based
>      on the range passed to the completion handler
> 
> We can use the private data passed to the get_block handler and the
> completion handler as a simple bitmask to communicate this information
> instead of the current complicated infrastructure reusing the ioends
> from the buffer I/O path, and thus avoiding a memory allocation and
> a context switch for any non-trivial direct write.  As a nice side
> effect we also decouple the direct I/O path implementation from that
> of the buffered I/O path.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

This change is now dependent on the preceeding direct IO API
changes. Do I a) take the DIO API change through the XFS tree, or
b) use the older version of the patch that didn't have this
dependency and let somebody else deal with the API change and merge
issues?

I'm happy to take the DIO API change through the XFS tree, if that's
the fastest/easiest way to get the necessary DIO subsystem fixes
into the mainline tree for XFS. As such, the for-next tree that I'm
building right now will include the DIO API change patch....

-Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
