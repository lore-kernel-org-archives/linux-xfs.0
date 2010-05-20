Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4KDEfhr206473 for <xfs@oss.sgi.com>; Thu, 20 May 2010 08:14:41 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2B8791DF4AEB
	for <xfs@oss.sgi.com>; Thu, 20 May 2010 06:16:59 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	KYDgCTPvCpBZAzwm for <xfs@oss.sgi.com>;
	Thu, 20 May 2010 06:16:59 -0700 (PDT)
Date: Thu, 20 May 2010 23:16:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/7] Add quota test with fsstress
Message-ID: <20100520131642.GT8120@dastard>
References: <1274276289-8839-1-git-send-email-jack@suse.cz>
	<1274276289-8839-6-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1274276289-8839-6-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: hch@infradead.org, xfs@oss.sgi.com

On Wed, May 19, 2010 at 03:38:07PM +0200, Jan Kara wrote:
> Run fsstress and verify that quota accounting is correct after it finishes.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  232     |  118 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  232.out |    6 +++
>  group   |    1 +
>  3 files changed, 125 insertions(+), 0 deletions(-)
>  create mode 100755 232
>  create mode 100644 232.out
> 
> diff --git a/232 b/232
> new file mode 100755
> index 0000000..ef8ce8a
> --- /dev/null
> +++ b/232
> @@ -0,0 +1,118 @@
> +#! /bin/bash
> +# FSQA Test No. 232
> +#
> +# Run fsstress with quotas enabled and verify accounted quotas in the end
> +#
> +# Derived from test 231
....
> +FSX_FILE_SIZE=64000000
> +FSX_ARGS="-q -l $FSX_FILE_SIZE -o 65536 -S 191110531 -N 100000"

These look like left overs from a copy-n-paste ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
