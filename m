Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3QFvKLk095982 for <xfs@oss.sgi.com>; Mon, 26 Apr 2010 10:57:20 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BA43C154B4AF
	for <xfs@oss.sgi.com>; Mon, 26 Apr 2010 08:59:22 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id i1Ta0T3b27HFkk9V for
	<xfs@oss.sgi.com>; Mon, 26 Apr 2010 08:59:22 -0700 (PDT)
Message-ID: <4BD5B851.2090807@sandeen.net>
Date: Mon, 26 Apr 2010 10:59:13 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: mkfs manpage -nsize/log
References: <201004261155.o3QBFk83032745@rcsinet15.oracle.com>
In-Reply-To: <201004261155.o3QBFk83032745@rcsinet15.oracle.com>
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
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: greg.marsden@oracle.com, joe.jin@oracle.com, xfs@oss.sgi.com

On 04/26/2010 06:53 AM, Wengang Wang wrote:
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>

Looks good, thank you!   I'll merge this along with your updated commit
message.

-Eric

> ---
>  man/man8/mkfs.xfs.8 |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
> index 4b147e9..bdaa153 100644
> --- a/man/man8/mkfs.xfs.8
> +++ b/man/man8/mkfs.xfs.8
> @@ -478,6 +478,8 @@ in bytes with
>  or as a base two logarithm
>  .I value
>  .RB "with " log= .
> +The block size must be a power of 2 size and cannot be made less than the
> +filesystem block size.
>  The default size
>  .I value
>  for version 2 directories is 4096 bytes (4 KiB),

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
