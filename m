Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:63933 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751355AbdKYXk4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Nov 2017 18:40:56 -0500
Date: Sun, 26 Nov 2017 10:34:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: handle register_shrinker error
Message-ID: <20171125233453.GX5858@dastard>
References: <20171123134128.mzxv6234hypokg4k@dhcp22.suse.cz>
 <201711240101.CJF18223.FJtHOLOSQFOMVF@I-love.SAKURA.ne.jp>
 <20171123161137.ncjqskbvdm6dgb3z@dhcp22.suse.cz>
 <20171123220045.GV5858@dastard>
 <20171124073957.3z4hjwg5exqw277h@dhcp22.suse.cz>
 <201711242103.FIH57396.FOFVJtQFLSMOHO@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201711242103.FIH57396.FOFVJtQFLSMOHO@I-love.SAKURA.ne.jp>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: mhocko@kernel.org, hch@infradead.org, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Nov 24, 2017 at 09:03:28PM +0900, Tetsuo Handa wrote:
> Michal Hocko wrote:
> > Thanks. Updated patch below
> > ---
> > From 1009db61988c48c9a9e327a9d076945b29b02eee Mon Sep 17 00:00:00 2001
> > From: Michal Hocko <mhocko@suse.com>
> > Date: Thu, 23 Nov 2017 17:13:40 +0100
> > Subject: [PATCH] xfs: fortify xfs_alloc_buftarg error handling
> 
> Do we need below patch on top of Michal's patch?
> KM_NOFS was added by commit b17cb364dbbbf65a ("xfs: fix missing KM_NOFS
> tags to keep lockdep happy"). If not needed, some comment is expected.

Quite frankly, if the fix is "sprinkle magic undocumented
memalloc_nofs_save() calls around", then you need to think a little
more about the things you just read and the context we're operating
on here.

IOWs:

> ---
>  fs/xfs/xfs_buf.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 4c6e86d..b73fc76 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1806,6 +1806,7 @@ struct xfs_buf *
>  	struct dax_device	*dax_dev)
>  {
>  	xfs_buftarg_t		*btp;
> +	unsigned int nofs_flag = memalloc_nofs_save();
>  
>  	btp = kmem_zalloc(sizeof(*btp), KM_SLEEP | KM_NOFS);

xfs_alloc_buftarg() isn't called from transaction context, so this
KM_NOFS flag wasn't added to prevent reclaim deadlocks - it was
added to avoid stupid lockdep false positives (as was stated in the
commit you quoted).

IOWs, GFP_KERNEL allocations in this function used to trigger
lockdep false positives.

So - think for a minute rather than bashing on the keyboard. Why
aren't the other GFP_KERNEL allocations from this function causing
lockdep to trigger warnings?

Yeah - lockdep is a lot smarter these days and the false positive
trigger has clearly been fixed. i.e. there's no false positive
detection occurring here any more under GFP_KERNEL allocations,
so we don't need the KM_NOFS flag anymore.

IOWs, we don't actually need to touch this code, but if you really
must, just remove the KM_NOFS tag.

-Dave.


-- 
Dave Chinner
david@fromorbit.com
