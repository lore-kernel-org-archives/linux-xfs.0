Return-Path: <SRS0=V0Y3=4A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C966C35242
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Feb 2020 00:49:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64C7120724
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Feb 2020 00:49:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbgBLAtH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Feb 2020 19:49:07 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:49692 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728098AbgBLAtG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Feb 2020 19:49:06 -0500
Received: from dread.disaster.area (pa49-179-138-28.pa.nsw.optusnet.com.au [49.179.138.28])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 8797C7EAABE;
        Wed, 12 Feb 2020 11:49:03 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j1gD8-0004M0-Oo; Wed, 12 Feb 2020 11:49:02 +1100
Date:   Wed, 12 Feb 2020 11:49:02 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 4/4] xfs: Replace mrlock_t by rw_semaphore
Message-ID: <20200212004902.GR10776@dread.disaster.area>
References: <20200211221018.709125-1-preichl@redhat.com>
 <20200211221018.709125-4-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200211221018.709125-4-preichl@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=zAxSp4fFY/GQY8/esVNjqw==:117 a=zAxSp4fFY/GQY8/esVNjqw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=PzM9fsMbPxSaN7tMo4cA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 11, 2020 at 11:10:18PM +0100, Pavel Reichl wrote:
> Remove mrlock_t as it does not provide any extra value over rw_semaphores.
> Make i_lock and i_mmaplock native rw_semaphores and replace mr*() functions
> with native rwsem calls.

wrapping at 68-72 columns.

> Signed-off-by: Pavel Reichl <preichl@redhat.com>

Subject "xfs: replace mrlock_t with rw_semaphores" or "xfs: remove
mrlock_t wrappers"

> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 3d7ce355407d..8b30f82b9dc0 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -9,6 +9,8 @@
>  #include "xfs_inode_buf.h"
>  #include "xfs_inode_fork.h"
>  
> +#include <linux/rwsem.h>
> +

Linux specific includes belong in fs/xfs/xfs_linux.h, not random XFS
header files.

Hmmm....

> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index 8738bb03f253..921a3eb093ed 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -22,7 +22,6 @@ typedef __u32			xfs_nlink_t;
>  #include "xfs_types.h"
>  
>  #include "kmem.h"
> -#include "mrlock.h"

.... that's where rwsem.h currently gets included (via mrlock.h)
into the XFS codebase.

IOWs, the "#include <linux/rwsem.h>" should replace this include,
not get moved to xfs_inode.h.

Otherwise the patch looks fine.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
