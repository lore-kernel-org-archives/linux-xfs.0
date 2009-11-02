Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nA2IkNep082790 for <xfs@oss.sgi.com>; Mon, 2 Nov 2009 12:46:23 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH] xfstests: add another quotaoff testcase to 220
Date: Mon, 2 Nov 2009 12:46:33 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE83AE56@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20091030093155.GA9329@infradead.org>
From: "Alex Elder" <aelder@sgi.com>
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
> Add the quotafile space remove regression test from Ryota Yamauchi to
> testcase 220.

Looks good.  This tests the actual problem reported by Ryota Yamauchi.

> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Alex Elder <aelder@sgi.com>

> Index: xfstests-dev/220
> ===================================================================
> --- xfstests-dev.orig/220	2009-10-30 09:16:52.000000000 +0000
> +++ xfstests-dev/220	2009-10-30 09:29:19.000000000 +0000
> @@ -1,10 +1,10 @@
>  #! /bin/sh
>  # FS QA Test No. 220
>  #
> -# Test that turning quotas off on a mounted filesystem doesn't crash
> -# the system.
> +# Test quota off handling.
>  #
> -# Based on a bug report from Utako Kusaka <u-kusaka@wm.jp.nec.com>.
> +# Based on bug reports from Utako Kusaka <u-kusaka@wm.jp.nec.com> and
> +# Ryota Yamauchi <r-yamauchi@vf.jp.nec.com>.
>  #
>  #-----------------------------------------------------------------------
>  # Copyright (c) 2009 Christoph Hellwig.  All Rights Reserved.
> @@ -67,5 +67,19 @@ xfs_quota -x -c off $SCRATCH_DEV
>  # and unmount (this used to crash)
>  umount $SCRATCH_DEV
> 
> +
> +# create scratch filesystem
> +_scratch_mkfs_xfs >/dev/null 2>&1
> +
> +# mount  with quotas enabled
> +_scratch_mount -o uquota
> +
> +# turn off quota and remove space allocated to the quota files
> +# (this used to give wrong ENOSYS returns in 2.6.31)
> +xfs_quota -x -c off -c remove $SCRATCH_DEV
> +
> +# and unmount again
> +umount $SCRATCH_DEV
> +
>  status=0
>  exit $status
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
