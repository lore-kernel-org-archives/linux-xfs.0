Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE191C4BA06
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 00:33:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AA1C20732
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 00:33:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbgBZAdO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 19:33:14 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:37057 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728865AbgBZAdO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 19:33:14 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 702FE7E97B0;
        Wed, 26 Feb 2020 11:33:11 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j6kdS-00059x-8t; Wed, 26 Feb 2020 11:33:10 +1100
Date:   Wed, 26 Feb 2020 11:33:10 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 11/30] xfs: pass an initialized xfs_da_args to
 xfs_attr_get
Message-ID: <20200226003310.GT10776@dread.disaster.area>
References: <20200225231012.735245-1-hch@lst.de>
 <20200225231012.735245-12-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225231012.735245-12-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=5apGOLN8fKg9SuImK4QA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 25, 2020 at 03:09:53PM -0800, Christoph Hellwig wrote:
> Instead of converting from one style of arguments to another in
> xfs_attr_set, pass the structure from higher up in the call chain.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 80 ++++++++++++----------------------------
>  fs/xfs/libxfs/xfs_attr.h |  4 +-
>  fs/xfs/xfs_acl.c         | 35 ++++++++----------
>  fs/xfs/xfs_ioctl.c       | 25 ++++++++-----
>  fs/xfs/xfs_xattr.c       | 24 ++++++------
>  5 files changed, 68 insertions(+), 100 deletions(-)

Overall looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index fed4f359ef20..13de4bcb8307 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -359,27 +359,32 @@ xfs_attrmulti_attr_get(
>  	uint32_t		*len,
>  	uint32_t		flags)
>  {
> -	unsigned char		*kbuf;
> -	int			error = -EFAULT;
> -	size_t			namelen;
> +	struct xfs_da_args	args = {
> +		.dp		= XFS_I(inode),
> +		.flags		= flags,
> +		.name		= name,
> +		.namelen	= strlen(name),
> +		.valuelen	= *len,
> +	};
> +	int			error;
>  
>  	if (*len > XFS_XATTR_SIZE_MAX)
>  		return -EINVAL;
> -	kbuf = kmem_zalloc_large(*len, 0);
> -	if (!kbuf)
> +
> +	args.value = kmem_zalloc_large(*len, 0);
> +	if (!args.value)
>  		return -ENOMEM;
>  
> -	namelen = strlen(name);
> -	error = xfs_attr_get(XFS_I(inode), name, namelen, &kbuf, (int *)len,
> -			     flags);
> +	error = xfs_attr_get(&args);
>  	if (error)
>  		goto out_kfree;
>  
> -	if (copy_to_user(ubuf, kbuf, *len))
> +	*len = args.valuelen;
> +	if (copy_to_user(ubuf, args.value, args.valuelen))
>  		error = -EFAULT;
>  
>  out_kfree:
> -	kmem_free(kbuf);
> +	kmem_free(args.value);
>  	return error;

This would seem like a prime candidate for ATTR_ALLOC conversion?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
