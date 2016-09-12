Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34972 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932232AbcILOD1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Sep 2016 10:03:27 -0400
Subject: Re: [PATCH] xfs_repair: fix exit code documentation in manpage
References: <62881d1e-8980-00c6-1d04-642a49b3b252@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <e31a51d9-c8f6-dc69-1507-9f6c7dad13da@sandeen.net>
Date: Mon, 12 Sep 2016 09:03:25 -0500
MIME-Version: 1.0
In-Reply-To: <62881d1e-8980-00c6-1d04-642a49b3b252@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>, linux-xfs@vger.kernel.org

On 9/12/16 7:35 AM, Eric Sandeen wrote:
> xfs_repair cannot proceed with a dirty log, and exits with
> a status code of 2 in that case; fix the manpage to
> reflect this.
> 
> (This has been the case for years, but was never documented).
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Sorry, I missed Zorro's earlier patch,

xfs_repair: update the manual content about xfs_repair exit status

So drop this one, i'll go review Zorro's patch.

-Eric


> ---
> 
> diff --git a/man/man8/xfs_repair.8 b/man/man8/xfs_repair.8
> index 1b4d9e3..57c970a 100644
> --- a/man/man8/xfs_repair.8
> +++ b/man/man8/xfs_repair.8
> @@ -509,7 +509,9 @@ If the directory were small, the message would read "junking entry ...".
>  will return a status of 1 if filesystem corruption was detected and
>  0 if no filesystem corruption was detected.
>  .B xfs_repair
> -run without the \-n option will always return a status code of 0.
> +run without the \-n option will return a status code of 2 if the log is
> +dirty and needs to be replayed, otherwise it will always return a status
> +code of 0.
>  .SH BUGS
>  The filesystem to be checked and repaired must have been
>  unmounted cleanly using normal system administration procedures
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
