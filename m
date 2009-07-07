Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n67Dvv2L147740 for <xfs@oss.sgi.com>; Tue, 7 Jul 2009 08:57:57 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7CCD13490EC
	for <xfs@oss.sgi.com>; Tue,  7 Jul 2009 06:58:31 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id CrQC7KEuvJnF5xis for
	<xfs@oss.sgi.com>; Tue, 07 Jul 2009 06:58:31 -0700 (PDT)
Message-ID: <4A535485.8050901@sandeen.net>
Date: Tue, 07 Jul 2009 08:58:29 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: don't print scratch mkfs and mount options
	without scratch device
References: <20090620173554.GA26470@infradead.org>
In-Reply-To: <20090620173554.GA26470@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> Also clean up the way the test configuration is printed.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> Index: xfstests-dev/check
> ===================================================================
> --- xfstests-dev.orig/check	2009-06-20 17:31:00.000000000 +0000
> +++ xfstests-dev/check	2009-06-20 17:33:46.000000000 +0000
> @@ -161,18 +161,15 @@
>  
>  [ -f check.time ] || touch check.time
>  
> -FULL_FSTYP_DETAILS=`_full_fstyp_details`
> -FULL_HOST_DETAILS=`_full_platform_details`
> -FULL_MKFS_OPTIONS=`_scratch_mkfs_options`
> -FULL_MOUNT_OPTIONS=`_scratch_mount_options`
> -
> -cat <<EOF
> -FSTYP         -- $FULL_FSTYP_DETAILS
> -PLATFORM      -- $FULL_HOST_DETAILS
> -MKFS_OPTIONS  -- $FULL_MKFS_OPTIONS
> -MOUNT_OPTIONS -- $FULL_MOUNT_OPTIONS
> +# print out our test configuration
> +echo "FSTYP         -- `_full_fstyp_details`"
> +echo "PLATFORM      -- `_full_platform_details`"
> +if [ ! -z "$SCRATCH_DEV" ]; then
> +  echo "MKFS_OPTIONS  -- `_scratch_mkfs_options`"
> +  echo "MOUNT_OPTIONS -- `_scratch_mount_options`"
> +fi
> +echo
>  
> -EOF
>  
>  if [ ! -z "$SCRATCH_DEV" ]; then
>    umount $SCRATCH_DEV 2>/dev/null
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
