Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:64493 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751350AbcKGEqw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Nov 2016 23:46:52 -0500
Date: Mon, 7 Nov 2016 15:46:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] fstests: make xfs_io mandatory
Message-ID: <20161107044648.GI28177@dastard>
References: <1478456601-7085-1-git-send-email-eguan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1478456601-7085-1-git-send-email-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Mon, Nov 07, 2016 at 02:23:21AM +0800, Eryu Guan wrote:
> _test_inode_flag() and _test_inode_extsz() use "which $XFS_IO_PROG"
> to check if xfs_io command is available. And "-i" option was added
> to XFS_IO_PROG varibable by commit 54659ecdb575 ("fstests: run
> xfs_io with -i option if supported"). So the command becomes "which
> /usr/sbin/xfs_io -i", and it stops and waits for input from stdin,
> because "-i" option of "which" means "Read aliases from stdin".

Funnily enough, I looked at those functions a couple of days ago and
thought "wow, they must have been written a long time ago if they
are trying to work if xfs_io is installed"...

> I've seen xfs/008 hang when testing with latest xfsprogs, where
> xfs_io has "-i" support.
> 
> Fix it by removing the xfs_io command detections, and making xfs_io
> mandatory in common/config.
> 
> Also fix the indentions in these functions, use tab instead of
> spaces, while we're at it.

Yeah, I noticed that too :P

> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
>  common/config |  4 +++-
>  common/rc     | 24 ++++++++++--------------
>  tests/xfs/094 |  1 -
>  tests/xfs/103 |  1 -
>  4 files changed, 13 insertions(+), 17 deletions(-)
> 
> diff --git a/common/config b/common/config
> index 168f46c..0b6cf01 100644
> --- a/common/config
> +++ b/common/config
> @@ -158,11 +158,13 @@ export DF_PROG="`set_prog_path df`"
>  [ "$DF_PROG" = "" ] && _fatal "df not found"
>  [ "$HOSTOS" = "Linux" ] && export DF_PROG="$DF_PROG -T -P"
>  
> +export XFS_IO_PROG="`set_prog_path xfs_io`"
> +[ "$XFS_IO_PROG" = "" ] && _fatal "xfs_io not found"
> +

Yup, seems like a reasonable thing to do at this point.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
