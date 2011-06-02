Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p529VCqf186667 for <xfs@oss.sgi.com>; Thu, 2 Jun 2011 04:31:12 -0500
Received: from webhosting01.bon.m2soft.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DD7D44964E4
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2011 02:31:10 -0700 (PDT)
Received: from webhosting01.bon.m2soft.com (webhosting01.bon.m2soft.com
	[195.38.20.32]) by cuda.sgi.com with ESMTP id 2Jv6X7A2eVBNO4i6
	for <xfs@oss.sgi.com>; Thu, 02 Jun 2011 02:31:10 -0700 (PDT)
Date: Thu, 2 Jun 2011 11:30:26 +0200
From: Nicolas Kaiser <nikai@nikai.net>
Subject: Re: [PATCH 11/12] vfs: increase shrinker batch size
Message-ID: <20110602113026.7291b1a7@absol.kitzblitz>
In-Reply-To: <1306998067-27659-12-git-send-email-david@fromorbit.com>
References: <1306998067-27659-1-git-send-email-david@fromorbit.com>
	<1306998067-27659-12-git-send-email-david@fromorbit.com>
Mime-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Just noticed below two typos.

* Dave Chinner <david@fromorbit.com>:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that the per-sb shrinker is responsible for shrinking 2 or more
> caches, increase the batch size to keep econmies of scale for

economies

(..)

>  Documentation/filesystems/vfs.txt |    5 +++++
>  fs/super.c                        |    1 +
>  2 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
> index dc732d2..2e26973 100644
> --- a/Documentation/filesystems/vfs.txt
> +++ b/Documentation/filesystems/vfs.txt
> @@ -317,6 +317,11 @@ or bottom half).
>  	the VM is trying to reclaim under GFP_NOFS conditions, hence this
>  	method does not need to handle that situation itself.
>  
> +	Implementations must include conditional reschedule calls inside any
> +	scanning loop that is done. This allows the VFS to determine
> +	appropriate scan batch sizes without having to worry about whether
> +	implementations will cause holdoff problems due ot large batch sizes.

due to

Best regards,
Nicolas Kaiser

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
