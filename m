Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:20497 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751640AbeEQWkL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 May 2018 18:40:11 -0400
Date: Fri, 18 May 2018 08:40:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 2/5] mkfs: move shared structs and cli params into
 their own headers
Message-ID: <20180517224008.GC23861@dastard>
References: <20180517192700.23457-1-mcgrof@kernel.org>
 <20180517192700.23457-3-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180517192700.23457-3-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: sandeen@sandeen.net, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com

On Thu, May 17, 2018 at 12:26:57PM -0700, Luis R. Rodriguez wrote:
> Both struct sb_feat_args and struct mkfs_default_params will be shared
> between CLI processing and the configuration file processing added later,
> so move these to their own header. The struct cli_params are CLI specific
> so move them to its own CLI header as well.

I'd separate out the CLI details when the CLI parsing is split into
it's own file - it's not necssary to do that here.

> 
> This will help ensure we split things neatly later and also will help
> ensure the configuration file processing code from the CLI code are kept
> separate and cannot touch each other's data structures. This also makes
> it clear what is actually shared between both.
> 
> There are no introduced functional changes in this commit and no
> documentation changes, this is just code shuffling.
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> ---
>  mkfs/xfs_mkfs.c        | 115 +------------------------------------------------
>  mkfs/xfs_mkfs_cli.h    |  65 ++++++++++++++++++++++++++++
>  mkfs/xfs_mkfs_common.h |  64 +++++++++++++++++++++++++++

File names.

xfs_mkfs.c is named that way by an old convention - it's the same as
xfs_repair.c, xfs_db.c, etc. Every other file in the directory does
not need a "xfs_mkfs_" prefix.

I'd also prefer we don't have "common" as a dumping ground header.
The CLI, config files, etc are all part of config processing, so
config.h would be more appropriate here. Or perhaps "input.h"
because they are both processing external inputs....

>  3 files changed, 131 insertions(+), 113 deletions(-)
>  create mode 100644 mkfs/xfs_mkfs_cli.h
>  create mode 100644 mkfs/xfs_mkfs_common.h
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 95cd6ced13f0..ac97039abc34 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -20,6 +20,8 @@
>  #include <ctype.h>
>  #include "xfs_multidisk.h"
>  #include "libxcmd.h"
> +#include "xfs_mkfs_common.h"
> +#include "xfs_mkfs_cli.h"

#include "config.h"

> diff --git a/mkfs/xfs_mkfs_cli.h b/mkfs/xfs_mkfs_cli.h
> new file mode 100644
> index 000000000000..2050814aec02
> --- /dev/null
> +++ b/mkfs/xfs_mkfs_cli.h
> @@ -0,0 +1,65 @@
> +#ifndef _XFS_MKFS_CLI_H
> +#define _XFS_MKFS_CLI_H

Missing license and copyright. It'll be the same license as the main
xfs_mkfs.c file. Copyright will be Red Hat, Inc (because it's new
code I wrote as dchinner@redhat.com) and you'll need to pull the
date from the commit message.

(Yeah, I know it's weird putting someone elses copyright on code
you're moving about, but that's how it goes :P)

> +
> +#include "xfs_mkfs_common.h"

No includes in header files if we can avoid them.

[...]

> diff --git a/mkfs/xfs_mkfs_common.h b/mkfs/xfs_mkfs_common.h
> new file mode 100644
> index 000000000000..9b0f67b70cf1
> --- /dev/null
> +++ b/mkfs/xfs_mkfs_common.h
> @@ -0,0 +1,64 @@
> +#ifndef _XFS_MKFS_COMMON_H
> +#define _XFS_MKFS_COMMON_H
> +
> +#include "libxfs.h"
> +
> +#include <ctype.h>

Same as above for license, copyright and includes, except the
copyright will also need to include the SGI copyright line from
xfs_mkfs.c...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
