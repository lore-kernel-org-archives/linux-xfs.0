Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4DB857FC3
	for <xfs@oss.sgi.com>; Tue, 10 Feb 2015 04:18:00 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CB411AC004
	for <xfs@oss.sgi.com>; Tue, 10 Feb 2015 02:17:56 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	AKlVNeWz7kI7gEy6 for <xfs@oss.sgi.com>;
	Tue, 10 Feb 2015 02:17:54 -0800 (PST)
Date: Tue, 10 Feb 2015 21:17:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/4] xfs: Adding XFS_IOC_FIEMAPFS ioctl for use in
	xfs_spaceman
Message-ID: <20150210101752.GB12722@dastard>
References: <54ca35b7.2786440a.6990.450d@mx.google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54ca35b7.2786440a.6990.450d@mx.google.com>
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
To: Dhruvesh Rathore <adrscube@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, Jan 29, 2015 at 06:59:22PM +0530, Dhruvesh Rathore wrote:
> 
> This patch is concerned with the changes to be done in kernel space code for
> turning FS_IOC_FIEMAPFS present in the earlier version of xfs_spaceman 
> into an XFS specific ioctl called XFS_IOC_FIEMAPFS, which uses all existing
> fiemap insfrastructure.
> By introducing XFS_IOC_FIMEAPFS ioctl, it can be seperated from file based
> fiemap commands and allows us to review it and push it as we need, making the
> process much simpler.
> 
> ----------------------------------------------------------------------------------------
> 
> Signed-off-by: Dhruvesh Rathore <dhruvesh_r@outlook.com>
> Signed-off-by: Amey Ruikar <ameyruikar@yahoo.com>
> Signed-off-by: Somdeep Dey <somdeepdey10@gmail.com>
> ---
> fs/ioctl.c		| 3  ++-
> include/linux/fs.h	| 6  ++++++
> fs/xfs/xfs_ioctl.c	| 55 +++++++++++++
> fs/xfs/xfs_fs.h		| 1  +
> 4 files changed, 64 insertions(+), 1 deletion(-) 

Ok, so this patch doesn't remove any of the now unused
functionality I added to support the VFS based ioctl.

What I'm going to do with this is combine it with the initial
"introduce FS_IOC_FIEMAP" patch I wrote (including all it's
documentation!) as the first patch of the kernel side patch series
to introduced XFS_IOC_FIEMAPFS.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
