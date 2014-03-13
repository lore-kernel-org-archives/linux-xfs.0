Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 33BE87F7B
	for <xfs@oss.sgi.com>; Thu, 13 Mar 2014 03:49:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 07CC38F8040
	for <xfs@oss.sgi.com>; Thu, 13 Mar 2014 01:49:58 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	mSwKqDOH2kIHtiFH for <xfs@oss.sgi.com>;
	Thu, 13 Mar 2014 01:49:38 -0700 (PDT)
Date: Thu, 13 Mar 2014 19:49:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/6 v2] Introduce FALLOC_FL_ZERO_RANGE flag for fallocate
Message-ID: <20140313084936.GF4263@dastard>
References: <1393355679-11160-1-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1393355679-11160-1-git-send-email-lczerner@redhat.com>
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

On Tue, Feb 25, 2014 at 08:14:33PM +0100, Lukas Czerner wrote:
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
> you'll need patches for util_linux, xfsprogs and xfstests which are going to
> follow soon.
> 
> I tested this mostly with a subset of xfstests using fsx and fsstress and
> even with new generic/290 which is just a copy of xfs/290 using fzero
> command for xfs_io instead of zero (which uses ioctl). I was testing on
> x86_64 and ppc64 with block sizes of 1024, 2048 and 4096.
> 
> ./check generic/076 generic/232 generic/013 generic/070 generic/269 generic/083
> generic/117 generic/068 generic/231 generic/127 generic/091 generic/075
> generic/112 generic/263 generic/091 generic/075 generic/256 generic/255
> generic/316 generic/300 generic/290 ext4/242;
> 
> Note that there is a work in progress on FALLOC_FL_COLLAPSE_RANGE which
> touches the same area as this pach set does, so we should figure out
> which one should go first and modify the other on top of it.
> 
> This has been based on top of xfs-collapse-range so it does not contain ext4
> collapse range changes.

Lukas, I have merged patches 4 and 6 into the xfs-collapse-branch.
That branch should now remain stable, so you can rebase all the ext4
collapse range and zero range bits on top of tha branch and Ted can
pull it into the ext4 tree if he wants to pull it in.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
