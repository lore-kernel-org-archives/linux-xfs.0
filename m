Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:57882 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbfFUQGr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jun 2019 12:06:47 -0400
Date: Fri, 21 Jun 2019 09:06:10 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_repair: don't search for libxfs.h in system headers
Message-ID: <20190621160610.GY5387@magnolia>
References: <b1265852-70ea-5402-191d-b3843996fc89@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1265852-70ea-5402-191d-b3843996fc89@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Jun 21, 2019 at 10:28:03AM -0500, Eric Sandeen wrote:
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> And now for something completely different: a noncontroversial,
> trivially reviewable #include change!
> 
> (right?)
> 
> diff --git a/repair/rmap.c b/repair/rmap.c
> index 47828a06..019df71c 100644
> --- a/repair/rmap.c
> +++ b/repair/rmap.c
> @@ -3,7 +3,7 @@
>   * Copyright (C) 2016 Oracle.  All Rights Reserved.
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
>   */
> -#include <libxfs.h>
> +#include "libxfs.h"
>  #include "btree.h"
>  #include "err_protos.h"
>  #include "libxlog.h"
> diff --git a/repair/slab.c b/repair/slab.c
> index ba5c2327..d5947a5a 100644
> --- a/repair/slab.c
> +++ b/repair/slab.c
> @@ -3,7 +3,7 @@
>   * Copyright (C) 2016 Oracle.  All Rights Reserved.
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
>   */
> -#include <libxfs.h>
> +#include "libxfs.h"
>  #include "slab.h"
>  
>  #undef SLAB_DEBUG
> 
