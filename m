Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 55DAD8009
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 23:26:06 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 43564304039
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 21:26:03 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id yElUXPtNuK76QG8R for <xfs@oss.sgi.com>;
	Thu, 05 Feb 2015 21:26:01 -0800 (PST)
Message-ID: <54D45068.2030209@sandeen.net>
Date: Thu, 05 Feb 2015 23:26:00 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprog: xfsio: update xfs_io manpage for
	FALLOC_FL_INSERT_RANGE
References: <001f01d041cb$39fbbc70$adf33550$@samsung.com>
In-Reply-To: <001f01d041cb$39fbbc70$adf33550$@samsung.com>
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
To: Namjae Jeon <namjae.jeon@samsung.com>, Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, Ashish Sangwan <a.sangwan@samsung.com>, xfs@oss.sgi.com

On 2/5/15 11:10 PM, Namjae Jeon wrote:
> Update xfs_io manpage for FALLOC_FL_INSERT_RANGE.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> ---
>  man/man8/xfs_io.8 | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index cf27b99..416206f 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -404,6 +404,11 @@ Call fallocate with FALLOC_FL_COLLAPSE_RANGE flag as described in the
>  manual page to de-allocates blocks and eliminates the hole created in this process
>  by shifting data blocks into the hole.
>  .TP
> +.BI finsert " offset length"
> +Call fallocate with FALLOC_FL_INSERT_RANGE flag as described in the
> +.BR fallocate (2)
> +manual page 

So, it looks like the fallocate(2) manpage will need an update as well.  :)
(linux-man@vger.kernel.org I believe)

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
