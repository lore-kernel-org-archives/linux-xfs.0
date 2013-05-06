Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 464EE29DF8
	for <xfs@oss.sgi.com>; Sun,  5 May 2013 19:04:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C79ECAC001
	for <xfs@oss.sgi.com>; Sun,  5 May 2013 17:04:32 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	QIcaJfyMDIa4smEA for <xfs@oss.sgi.com>;
	Sun, 05 May 2013 17:04:30 -0700 (PDT)
Date: Mon, 6 May 2013 10:04:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: automatically add -F to xfs_io on non-xfs
Message-ID: <20130506000425.GI19978@dastard>
References: <51850BED.6050109@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51850BED.6050109@redhat.com>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On Sat, May 04, 2013 at 08:23:57AM -0500, Eric Sandeen wrote:
> The -F flag to xfs_io originally enabled it to operate on non-xfs
> filesystems.  This restriction was removed upstream in favor of
> gracefully failing on the handful of operations that actually
> required xfs, and the option was deprecated.
> 
> However, xfstests is still used on distros with older xfsprogs, and
> so "xfs_io -F" was necessary throughout xfstests.
> 
> Simplify this by appending -F to XFS_IO_PROG when it's exported,
> if we're not running on an xfs filesystem.
> 
> This will eliminate errors when new tests leave out the -F, and
> if and when -F is finally removed, there will be one central location
> in xfstests to update.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

All looks good, but....

> ---
> 
> diff --git a/common/config b/common/config
> index 67c1498..554a2c2 100644
> --- a/common/config
> +++ b/common/config
> @@ -157,6 +157,8 @@ export XFS_REPAIR_PROG="`set_prog_path xfs_repair`"
>  export XFS_DB_PROG="`set_prog_path xfs_db`"
>  export XFS_GROWFS_PROG=`set_prog_path xfs_growfs`
>  export XFS_IO_PROG="`set_prog_path xfs_io`"
> +# Older xfs_io refuses to run w/o -F on non-xfs
> +[ "$FSTYP" != "xfs" ] && export XFS_IO_PROG="$XFS_IO_PROG -F"

I wonder if we can be smarter about this, and not set it on versions
of xfs_io that don't need it so we don't have to care about future
versions of xfs_io that might remove the option completely rather
than silently ignore it?

For example, after we've validated the $TEST_DEV in common/rc, run
an xfs_io command on the TEST_DIR and determine if the -F flag is
required? We do all sorts of additional checks in common/rc after
including common/config, so perhaps fixing this is better done in
common/rc rather than common/config....

Other than that, the change looks good. 

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
