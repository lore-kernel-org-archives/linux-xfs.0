Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 220B1C4167B
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 20:32:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4146221EA
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 20:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbgLCUcV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 15:32:21 -0500
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:44570 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727068AbgLCUcV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 15:32:21 -0500
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id BA1401AC452;
        Fri,  4 Dec 2020 07:31:31 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kkvGE-000B8I-KP; Fri, 04 Dec 2020 07:31:30 +1100
Date:   Fri, 4 Dec 2020 07:31:30 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v2 3/6] xfs: move on-disk inode allocation out of
 xfs_ialloc()
Message-ID: <20201203203130.GB3913616@dread.disaster.area>
References: <20201203161028.1900929-1-hsiangkao@redhat.com>
 <20201203161028.1900929-4-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203161028.1900929-4-hsiangkao@redhat.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=zTNgK-yGK50A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=a-4tz5kq3gthfdlYGaAA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 04, 2020 at 12:10:25AM +0800, Gao Xiang wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> So xfs_ialloc() will only address in-core inode allocation then.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
>  fs/xfs/xfs_inode.c | 200 +++++++++++++++------------------------------
>  1 file changed, 65 insertions(+), 135 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 4ebfb1a18f0f..34eca1624397 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -761,68 +761,25 @@ xfs_inode_inherit_flags2(
>  }
>  
>  /*
> - * Allocate an inode on disk and return a copy of its in-core version.
> - * The in-core inode is locked exclusively.  Set mode, nlink, and rdev
> - * appropriately within the inode.  The uid and gid for the inode are
> - * set according to the contents of the given cred structure.
> - *
> - * Use xfs_dialloc() to allocate the on-disk inode. If xfs_dialloc()
> - * has a free inode available, call xfs_iget() to obtain the in-core
> - * version of the allocated inode.  Finally, fill in the inode and
> - * log its initial contents.  In this case, ialloc_context would be
> - * set to NULL.
> - *
> - * If xfs_dialloc() does not have an available inode, it will replenish
> - * its supply by doing an allocation. Since we can only do one
> - * allocation within a transaction without deadlocks, we must commit
> - * the current transaction before returning the inode itself.
> - * In this case, therefore, we will set ialloc_context and return.
> - * The caller should then commit the current transaction, start a new
> - * transaction, and call xfs_ialloc() again to actually get the inode.
> - *
> - * To ensure that some other process does not grab the inode that
> - * was allocated during the first call to xfs_ialloc(), this routine
> - * also returns the [locked] bp pointing to the head of the freelist
> - * as ialloc_context.  The caller should hold this buffer across
> - * the commit and pass it back into this routine on the second call.
> - *
> - * If we are allocating quota inodes, we do not have a parent inode
> - * to attach to or associate with (i.e. pip == NULL) because they
> - * are not linked into the directory structure - they are attached
> - * directly to the superblock - and so have no parent.
> + * Initialise a newly allocated inode and return the in-core inode to the
> + * caller locked exclusively.
>   */
> -static int
> +static struct xfs_inode *
>  xfs_ialloc(

Can we rename this xfs_dir_ialloc_init()?

That way we keep everything in xfs_inode.c under the same namespace
(xfs_dir_ialloc_*) and don't confuse it with functions in the
xfs_ialloc_* namespace in fs/xfs/libxfs/xfs_ialloc*.c...

Otherwise looks good.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
