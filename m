Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F22A229DF5
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 13:55:07 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6ECC4AC006
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 11:55:07 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	4eE1Ka0WECkVuZsa for <xfs@oss.sgi.com>;
	Tue, 09 Feb 2016 11:55:04 -0800 (PST)
Date: Wed, 10 Feb 2016 06:55:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprogs: guard fsxattr definition for newer kernels
Message-ID: <20160209195502.GR27429@dastard>
References: <56BA24A9.4090403@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56BA24A9.4090403@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Feb 09, 2016 at 11:40:57AM -0600, Eric Sandeen wrote:
> After 334e580,
> fs: XFS_IOC_FS[SG]SETXATTR to FS_IOC_FS[SG]ETXATTR promotion
> 
> the file include/linux/fs.h now defines struct fsxattr.
> 
> It defines FS_IOC_FSGETXATTR as well, so use that to wrap
> our local definition, and skip it if the kernel is providing
> it so that we don't get multiple definitions.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> Should the kernel also #define HAVE_FSXATTR to help existing
> xfsprogs-devel installations?
> 
> (And what if headers are included in the other order?  Should
> we try to guard on the kernel side or no?)

I've already sent a patch to fix this - it was with the foreign
filesystem xfs_quota patch....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
