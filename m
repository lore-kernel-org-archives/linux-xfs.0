Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E7B0E7F50
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 19:07:43 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D836E8F8037
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 17:07:43 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	oivEc7Epzp0UTPk6 for <xfs@oss.sgi.com>;
	Sun, 23 Feb 2014 17:07:38 -0800 (PST)
Date: Mon, 24 Feb 2014 12:07:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/6][RFC] Introduce FALLOC_FL_ZERO_RANGE flag for fallocate
Message-ID: <20140224010714.GI4317@dastard>
References: <1392649703-10772-1-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1392649703-10772-1-git-send-email-lczerner@redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, tytso@mit.edu, xfs@oss.sgi.com

On Mon, Feb 17, 2014 at 04:08:17PM +0100, Lukas Czerner wrote:
> Introduce new FALLOC_FL_ZERO_RANGE flag for fallocate. This has the same
> functionality as xfs ioctl XFS_IOC_ZERO_RANGE.
> 
> It can be used to convert a range of file to zeros preferably without
> issuing data IO. Blocks should be preallocated for the regions that span
> holes in the file, and the entire range is preferable converted to
> unwritten extents - even though file system may choose to zero out the
> extent or do whatever which will result in reading zeros from the range
> while the range remains allocated for the file.
> 
> This can be also used to preallocate blocks past EOF in the same way as
> with fallocate. Flag FALLOC_FL_KEEP_SIZE which should cause the inode
> size to remain the same.
> 
> You can test this feature yourself using xfstests, of fallocate(1) however
> you'll need patches for util_linux, xfsprogs and xfstests which you
> can find here:
> 
> http://people.redhat.com/lczerner/zero_range/
> 
> I'll post the patches after we agree and merge the kernel functionality.

Lukas, can you post the xfstests and xfs_io changes so that they can
be reviewed? Once I can verify the behaviour is the same as
XFS_IOC_ZERO_RANGE, I'm ahppy to commit the VFS and XFS kernel
changes along with the xfsprogs and xfstests changes like I've just
done for the FALLOC_FL_COLLAPSE_RANGE changes.

I'd like to get all the changes to the VFS into the XFS tree so that
you can handle the ext4 integration of the two pieces of
functionilty as you and Ted see fit....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
