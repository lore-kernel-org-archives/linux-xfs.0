Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n67AWv0j138961 for <xfs@oss.sgi.com>; Tue, 7 Jul 2009 05:32:58 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 37A961AFE2D7
	for <xfs@oss.sgi.com>; Tue,  7 Jul 2009 03:33:33 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id IHYX4DHX8W5Y8dkQ for
	<xfs@oss.sgi.com>; Tue, 07 Jul 2009 03:33:33 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1MO7zQ-0005aB-UQ
	for xfs@oss.sgi.com; Tue, 07 Jul 2009 10:33:32 +0000
Date: Tue, 7 Jul 2009 06:33:32 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: don't print scratch mkfs and mount options
	without scratch device
Message-ID: <20090707103332.GB20410@infradead.org>
References: <20090620173554.GA26470@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

ping?

On Sat, Jun 20, 2009 at 01:35:54PM -0400, Christoph Hellwig wrote:
> Also clean up the way the test configuration is printed.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
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
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
