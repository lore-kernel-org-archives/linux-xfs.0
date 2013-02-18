Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 51F367F4E
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2013 17:43:21 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D3D3CAC004
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2013 15:43:20 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	ZOfdrMJUoYhFHlfU for <xfs@oss.sgi.com>;
	Mon, 18 Feb 2013 15:43:18 -0800 (PST)
Date: Tue, 19 Feb 2013 10:43:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/8] xfstests: add fallocate/truncate vs AIO/DIO stress
	test
Message-ID: <20130218234316.GE26694@dastard>
References: <1360745403-6373-1-git-send-email-dmonakhov@openvz.org>
	<1360745403-6373-7-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1360745403-6373-7-git-send-email-dmonakhov@openvz.org>
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
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, dchinner@redhat.com, xfs@oss.sgi.com

On Wed, Feb 13, 2013 at 12:50:01PM +0400, Dmitry Monakhov wrote:
> Run  DIO, fallocate and truncate threads on a common file in parallel.
> If race exist old dio request may rewrite blocks after it was allocated
> to another file, we will catch that by verifying blocks content.
> 
> this patch known to catch deadlock for ext4
> http://lists.openwall.net/linux-ext4/2012/09/06/3
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  286     |  157 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  286.out |    5 ++
>  group   |    1 +
>  3 files changed, 163 insertions(+), 0 deletions(-)
>  create mode 100755 286
>  create mode 100644 286.out
> 
> diff --git a/286 b/286
> new file mode 100755
> index 0000000..588387c
> --- /dev/null
> +++ b/286
> @@ -0,0 +1,157 @@
> +#! /bin/bash
> +# FSQA Test No. 286
> +#
> +# AIO/DIO stress test
> +# Run random AIO/DIO activity and fallocate/truncate simultaneously
> +# Test will operate on huge sparsed files so ENOSPC is expected.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2006 Silicon Graphics, Inc.  All Rights Reserved.

I think you need to put the correct copyright statements in these
new tests ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
