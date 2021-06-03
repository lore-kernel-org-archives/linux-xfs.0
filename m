Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 332CEC47080
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 04:34:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 131936124B
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 04:34:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbhFCEge (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Jun 2021 00:36:34 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:54980 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229656AbhFCEgd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jun 2021 00:36:33 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 39C8210439E3;
        Thu,  3 Jun 2021 14:34:48 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lof4A-008M9a-M1; Thu, 03 Jun 2021 14:34:46 +1000
Date:   Thu, 3 Jun 2021 14:34:46 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 2/3] xfs: drop IDONTCACHE on inodes when we mark them sick
Message-ID: <20210603043446.GP664593@dread.disaster.area>
References: <162268995567.2724138.15163777746481739089.stgit@locust>
 <162268996687.2724138.9307511745121153042.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162268996687.2724138.9307511745121153042.stgit@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=CYz6lWv1jFzmRfEIpzUA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 02, 2021 at 08:12:46PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> When we decide to mark an inode sick, clear the DONTCACHE flag so that
> the incore inode will be kept around until memory pressure forces it out
> of memory.  This increases the chances that the sick status will be
> caught by someone compiling a health report later on.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_health.c |    5 +++++
>  fs/xfs/xfs_icache.c |    3 ++-
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
> index 8e0cb05a7142..824e0b781290 100644
> --- a/fs/xfs/xfs_health.c
> +++ b/fs/xfs/xfs_health.c
> @@ -231,6 +231,11 @@ xfs_inode_mark_sick(
>  	ip->i_sick |= mask;
>  	ip->i_checked |= mask;
>  	spin_unlock(&ip->i_flags_lock);
> +
> +	/* Keep this inode around so we don't lose the sickness report. */
> +	spin_lock(&VFS_I(ip)->i_lock);
> +	VFS_I(ip)->i_state &= ~I_DONTCACHE;
> +	spin_unlock(&VFS_I(ip)->i_lock);
>  }

Dentries will still be reclaimed, but the VFS will at least hold on
to the inode in this case.

>  /* Mark parts of an inode healed. */
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index c3f912a9231b..0e2b6c05e604 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -23,6 +23,7 @@
>  #include "xfs_dquot.h"
>  #include "xfs_reflink.h"
>  #include "xfs_ialloc.h"
> +#include "xfs_health.h"
>  
>  #include <linux/iversion.h>
>  
> @@ -648,7 +649,7 @@ xfs_iget_cache_miss(
>  	 * time.
>  	 */
>  	iflags = XFS_INEW;
> -	if (flags & XFS_IGET_DONTCACHE)
> +	if ((flags & XFS_IGET_DONTCACHE) && xfs_inode_is_healthy(ip))

Hmmmm. xfs_inode_is_healthy() is kind of heavyweight for just
checking that ip->i_sick == 0. At this point, nobody else can be
accessing the inode, so we don't need masks nor a spinlock for
checking the sick field.

So why not:

	if ((flags & XFS_IGET_DONTCACHE) && !READ_ONCE(ip->i_sick))

Or maybe still use xfs_inode_is_healthy() but convert it to the
simpler, lockless sick check?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
