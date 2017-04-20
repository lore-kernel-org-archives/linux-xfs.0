Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24969 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751245AbdDTRXR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Apr 2017 13:23:17 -0400
Date: Thu, 20 Apr 2017 10:23:09 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_io: add missed inode command into man page
Message-ID: <20170420172309.GD23371@birch.djwong.org>
References: <1492708017-14163-1-git-send-email-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1492708017-14163-1-git-send-email-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zorro Lang <zlang@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Apr 21, 2017 at 01:06:57AM +0800, Zorro Lang wrote:
> There's an "inode" command in xfs_io, it's used to query physical
> information about an inode. But there's not any information about
> it in xfs_io and other related man pages. So document this command
> in the xfs_io man page now.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
>  man/man8/xfs_io.8 | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index 19e1ae4..ceb6cf4 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -650,6 +650,23 @@ sec uses UNIX timestamp notation and is the seconds elapsed since
>  nsec is the nanoseconds since the sec. This value needs to be in
>  the range 0-999999999 with UTIME_NOW and UTIME_OMIT being exceptions.
>  Each (sec, nsec) pair constitutes a single timestamp value.
> +.RE
> +.PD
> +.TP
> +.BI " inode [ [ -n ] " number " ] [ -v ]"
> +The inode command querys physical information about an inode, it

"queries"

> +returns 1 if any inode number greater than 32 bits exists in the

Technically, it returns 1 if any inode number would overflow 32 bits,
which is to say that it returns 1 if any inode number is greater than
2^32-1.

> +filesystem, or 0 if none exist by default. The

You could leave out "by default".

> +.I number
> +is used to specify an inode number, then inode command returns this
> +inode number if it's in use, or 0 if not. But if use

"If an inode /number/ is given, this command returns that inode number if
the inode is in use, or zero if not."?

> +.B \-n
> +with
> +.I number
> +, the next used inode number after this number will be returned, or 0
> +if can't find the next one.

"If -n is given with /number/, the next inode number in use will be
returned, or zero if there aren't any more"?

> +.B \-v
> +for verbose mode, the inode number's size in bits will be displayed.

(What a strange command...)

--D

>  
>  .SH MEMORY MAPPED I/O COMMANDS
>  .TP
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
