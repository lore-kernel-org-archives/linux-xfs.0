Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:49188 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752924AbeDTWZp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Apr 2018 18:25:45 -0400
Date: Fri, 20 Apr 2018 15:25:41 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 0/2] RFC: iomap-based swap file activation
Message-ID: <20180420222541.GC24738@magnolia>
References: <20180420220815.44160-1-cyberax@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180420220815.44160-1-cyberax@amazon.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Aleksei Besogonov <cyberax@amazon.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Fri, Apr 20, 2018 at 10:08:13PM +0000, Aleksei Besogonov wrote:
> This patch set adds iomap-based swap file initialization, this allows
> it to use files with holes on XFS for swap.

Um... there's already a patch[1] implementing this out for review on the
mailing list.  Could you please take a look at that instead?

--D

[1] https://marc.info/?l=linux-xfs&m=152401984810062&w=2

> 
> Aleksei Besogonov (2):
>   fs: Add iomap_swap_activate
>   xfs: add support for iomap-based swapfile activation
> 
>  fs/iomap.c            | 87 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_aops.c     |  7 +++++
>  include/linux/iomap.h |  5 +++
>  mm/swapfile.c         |  1 +
>  4 files changed, 100 insertions(+)
> 
> -- 
> 2.14.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
