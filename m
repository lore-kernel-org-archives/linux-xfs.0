Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBFMv2hH246821 for <xfs@oss.sgi.com>; Wed, 15 Dec 2010 16:57:02 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6D0311458CC4
	for <xfs@oss.sgi.com>; Wed, 15 Dec 2010 14:58:53 -0800 (PST)
Received: from mail.internode.on.net (bld-mail20.adl6.internode.on.net
	[150.101.137.105]) by cuda.sgi.com with ESMTP id
	a3mKKyJ6Tq4CbqdE for <xfs@oss.sgi.com>;
	Wed, 15 Dec 2010 14:58:53 -0800 (PST)
Date: Thu, 16 Dec 2010 09:58:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3] xfstests: pwrite hang when writing from mmaped
	buffer of the same page
Message-ID: <20101215225850.GH9925@dastard>
References: <1292304018-10827-1-git-send-email-xin.zhong@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1292304018-10827-1-git-send-email-xin.zhong@intel.com>
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
To: "Zhong, Xin" <xin.zhong@intel.com>
Cc: xfs@oss.sgi.com

On Tue, Dec 14, 2010 at 01:20:18PM +0800, Zhong, Xin wrote:
> The problem is found in meego testing on btrfs:
> http://bugs.meego.com/show_bug.cgi?id=6672
> 
> Reviewed-by: Hellwig, Christoph <hch@infradead.org> and Chinner, Dave <david@fromorbit.com>
> Signed-off-by: Zhong, Xin <xin.zhong@intel.com>
> ---
>  248                       |   57 ++++++++++++++++++++++++++++++++++++
>  248.out                   |    2 +
>  group                     |    1 +
>  src/Makefile              |    2 +-
>  src/pwrite_mmap_blocked.c |   71 +++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 132 insertions(+), 1 deletions(-)
>  create mode 100644 248
>  create mode 100644 248.out
>  create mode 100644 src/pwrite_mmap_blocked.c
> 
> diff --git a/248 b/248
> new file mode 100644
> index 0000000..ea4313f
> --- /dev/null
> +++ b/248
> @@ -0,0 +1,57 @@
> +#! /bin/bash
> +# FS QA Test No. 248
> +#
> +# Test for pwrite hang problem when writing from mmaped buffer of the same page 
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2010 YOUR NAME HERE.  All Rights Reserved.

Still needs the copyright line updated.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
