Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49458 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751923AbdHBQKe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Aug 2017 12:10:34 -0400
Date: Wed, 2 Aug 2017 09:10:15 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_io: allow lsattr & lsproj on foreign filesystems
Message-ID: <20170802161015.GP4477@magnolia>
References: <20170731225833.11104-1-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170731225833.11104-1-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>

On Mon, Jul 31, 2017 at 04:58:33PM -0600, Ross Zwisler wrote:
> The following commit:
> 
> commit 73b54bb6a2fb ("xfs_io: allow chattr & chproj on foreign filesystems")
> 
> allowed chattr and chproj to be run on non-xfs filesystems now that
> FS_IOC_FSSETXATTR is a generic vfs call.  It failed to enable the
> corresponding lsattr and lsproj commands for those filesystems, though.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Fixes: 73b54bb6a2fb ("xfs_io: allow chattr & chproj on foreign filesystems")
> Cc: Eric Sandeen <sandeen@redhat.com>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Jan Kara <jack@suse.cz>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  io/attr.c | 2 +-
>  io/open.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/io/attr.c b/io/attr.c
> index b8eec1b..728560e 100644
> --- a/io/attr.c
> +++ b/io/attr.c
> @@ -353,7 +353,7 @@ attr_init(void)
>  	lsattr_cmd.args = _("[-R|-D|-a|-v]");
>  	lsattr_cmd.argmin = 0;
>  	lsattr_cmd.argmax = 1;
> -	lsattr_cmd.flags = CMD_NOMAP_OK;
> +	lsattr_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
>  	lsattr_cmd.oneline =
>  		_("list extended inode flags set on the currently open file");
>  	lsattr_cmd.help = lsattr_help;
> diff --git a/io/open.c b/io/open.c
> index b50f068..f2ea7c3 100644
> --- a/io/open.c
> +++ b/io/open.c
> @@ -812,7 +812,7 @@ open_init(void)
>  	lsproj_cmd.args = _("[-D | -R]");
>  	lsproj_cmd.argmin = 0;
>  	lsproj_cmd.argmax = -1;
> -	lsproj_cmd.flags = CMD_NOMAP_OK;
> +	lsproj_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
>  	lsproj_cmd.oneline =
>  		_("list project identifier set on the currently open file");
>  	lsproj_cmd.help = lsproj_help;
> -- 
> 2.9.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
