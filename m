Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25463 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750967AbdEBXNK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 May 2017 19:13:10 -0400
Date: Tue, 2 May 2017 16:13:02 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 1/2] xfs_io: add missed inode command into man page\
Message-ID: <20170502231302.GD5973@birch.djwong.org>
References: <1493010128-8153-1-git-send-email-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1493010128-8153-1-git-send-email-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zorro Lang <zlang@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Apr 24, 2017 at 01:02:07PM +0800, Zorro Lang wrote:
> There's an "inode" command in xfs_io, it's used to query physical
> information about an inode. But there's not any information about
> it in xfs_io and other related man pages. So document this command
> in the xfs_io man page now.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
> 
> Hi,
> 
> This V2 follow Eric's suggestion, changed some description, and moved
> the inode command from "FILE I/O" section to "OTHER COMMANDS" section.
> 
> Thanks,
> Zorro
> 
>  man/man8/xfs_io.8 | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index 19e1ae4..a7c2a1e 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -923,6 +923,30 @@ verbose output will be printed.
>  .RE
>  .IP
>  .B [NOTE: Not currently operational on Linux.]
> +.RE
> +.PD
> +.TP
> +.BI "inode  [ [ -n ] " number " ] [ -v ]"
> +The inode command queries physical information about an inode. With
> +no arguments, it will return 1 or 0, indicating whether or not if any

"...whether or not any..."

> +inode numbers greater than 32 bits are currently in use in the filesystem.
> +If given an inode
> +.I number
> +as an argument, then inode command will return this inode

"..as an argument, the command will return the same inode number..."

> +.I number
> +if it's in use, or 0 if not. With

"..if it is in use..."

> +.BI \-n " number"
> +, the next used inode number after this
> +.I number
> +will be returned, or 0 if can't find the next one. With

"...or zero if the supplied inode number is the highest one in use."

> +.B \-v
> +the command will also report the number of bits (32 or 64) used by the
> +inode
> +.I number
> +printed in the result; if no inode
> +.I number
> +was specified on the commandline, the maximum possible inode number in

"..command line..."

> +the system will be printed along with its size.

/me also grumbles about not starting each sentence on a separate line.
Not enough to go fix all the manpages, though. :P

Otherwise,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

(FWIW if Eric wants to massage the patch on the way in rather than
waiting for another send-review cycle that's fine with me.)

--D

>  .PD
>  .TP
>  .BI "set_encpolicy [ \-c " mode " ] [ \-n " mode " ] [ \-f " flags " ] [ \-v " version " ] [ " keydesc " ]
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
