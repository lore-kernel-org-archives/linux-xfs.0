Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E720129DF8
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 23:02:14 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BA3FF304059
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 21:02:11 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	bCyKxtA5g9ile7va for <xfs@oss.sgi.com>;
	Wed, 26 Feb 2014 21:02:06 -0800 (PST)
Date: Thu, 27 Feb 2014 16:01:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_io: add fzero command for zeroing range via fallocate
Message-ID: <20140227050150.GI29907@dastard>
References: <1393355733-12099-1-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1393355733-12099-1-git-send-email-lczerner@redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Tue, Feb 25, 2014 at 08:15:33PM +0100, Lukas Czerner wrote:
> Add fzero command which zeroes a range of the file using
> fallocate FALLOC_FL_ZERO_RANGE flag.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Looks ok, but...

> @@ -312,7 +342,17 @@ prealloc_init(void)
>  	fcollapse_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
>  	fcollapse_cmd.args = _("off len");
>  	fcollapse_cmd.oneline =
> -	_("de-allocates space and eliminates the hole by shifting extents");
> +		_("de-allocates space and eliminates the hole by shifting extents");
>  	add_command(&fcollapse_cmd);

I'll drop this change because it pushes the line beyond 80
characters....

Otherwise,

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
