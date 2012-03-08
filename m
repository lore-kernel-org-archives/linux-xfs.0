Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q281YJXV192709 for <xfs@oss.sgi.com>; Wed, 7 Mar 2012 19:34:20 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	aNBGFM8skRgAY31Y for <xfs@oss.sgi.com>;
	Wed, 07 Mar 2012 17:34:17 -0800 (PST)
Date: Thu, 8 Mar 2012 12:34:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] default to 64 bit inodes & add feature flag
Message-ID: <20120308013413.GL3592@dastard>
References: <4F5798F9.2050809@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F5798F9.2050809@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>, Dave Chinner <dchinner@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Mar 07, 2012 at 11:20:57AM -0600, Eric Sandeen wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Default to allowing 64-bit inodes on the filesystem.
> 
> Add a feature bit to the the superblock to record whether 64 bit inodes have
> been allocated on the filesystem or not. This allows us to reject mounting the
> filesytem with inode32 if 64 bit inodes are present.
> 
> Once a 64 bitinode is allocated, the inode64 superblock feature bit will be set.
> Once the superblock feature bit is set, the filesystem will default to 64 bit
> inodes regardless of whether inode64 is specified as a mount option.
> 
> To ensure only 32 bit inodes are created, the inode32 mount option must be
> used. If there are already 64 bit inodes as flagged by the superblock feature
> bit, then the inode32 mount will be refused.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
> 
> Passing this along to revive the old discussion ... 

I have no objections to do this. However, the kernel patch is just
the tip of the iceberg when it comes to implementing this.

Were there patches for userspace support of the feature bit? I don't
recall if there were. I'm thinking that xfs_info needs to output
whether this is set, which means the flag needs to be added to the
xfs geometry ioctls in the kernel.

I'd also think that this should also be made a mkfs option (it will
have to default to "not enabled" for a couple of years until distro
kernels catch up) along with outputting the current value. This
will then require xfstests mkfs filter changes, too.

We'll also need xfs_check, xfs_db (e.g. the version command) and
xfs_repair knowledge of the new feature bit so they don't think the
superblock is corrupted when this new bit gets set....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
