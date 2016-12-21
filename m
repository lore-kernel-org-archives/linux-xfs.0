Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58862 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753995AbcLUE0S (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Dec 2016 23:26:18 -0500
Subject: Re: [PATCH 4/3] xfs_io: fix some documentation problems
References: <148182550558.24784.5628335536185073955.stgit@birch.djwong.org>
 <20161216005251.GE5357@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <523b454c-10ff-b73f-07cb-eaf8f5e67102@sandeen.net>
Date: Tue, 20 Dec 2016 22:26:17 -0600
MIME-Version: 1.0
In-Reply-To: <20161216005251.GE5357@birch.djwong.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 12/15/16 6:52 PM, Darrick J. Wong wrote:
> Describe the numberless (i.e. "reflink the whole file") behavior
> in the xfs_io help system and since the clone/dedupe ioctls were
> promoted to the VFS before XFS reflink landed, mention those in
> the manpage.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  io/reflink.c      |    4 ++--
>  man/man8/xfs_io.8 |    4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/io/reflink.c b/io/reflink.c
> index 7b15e89..d4c745c 100644
> --- a/io/reflink.c
> +++ b/io/reflink.c
> @@ -307,9 +307,9 @@ reflink_init(void)
>  	reflink_cmd.argmax = -1;
>  	reflink_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
>  	reflink_cmd.args =
> -_("infile src_off dst_off len");
> +_("infile [src_off dst_off len]");
>  	reflink_cmd.oneline =
> -		_("reflinks a number of bytes at a specified offset");
> +		_("reflinks an entire file, or a number of bytes at a specified offset");
>  	reflink_cmd.help = reflink_help;
>  
>  	add_command(&reflink_cmd);
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index f5e89ab..5cea992 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -577,7 +577,7 @@ both data and holes are displayed together or performing a recusively display.
>  .TP
>  .BI "reflink  [ \-C ] [ \-q ] src_file [src_offset dst_offset length]"
>  On filesystems that support the
> -.B XFS_IOC_CLONE_RANGE
> +.B FICLONERANGE
>  or
>  .B BTRFS_IOC_CLONE_RANGE
>  ioctls, map
> @@ -607,7 +607,7 @@ Do not print timing statistics at all.
>  .TP
>  .BI "dedupe  [ \-C ] [ \-q ] src_file src_offset dst_offset length"
>  On filesystems that support the
> -.B XFS_IOC_FILE_EXTENT_SAME
> +.B FIDEDUPERANGE
>  or
>  .B BTRFS_IOC_FILE_EXTENT_SAME
>  ioctls, map
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
