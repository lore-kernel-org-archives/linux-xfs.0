Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 001DBC4BA06
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 00:21:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEEF424656
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 00:21:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729170AbgBZAVQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 19:21:16 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:38020 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728989AbgBZAVQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 19:21:16 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id E844D7EA4FC;
        Wed, 26 Feb 2020 11:21:10 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j6kRp-0004zG-O2; Wed, 26 Feb 2020 11:21:09 +1100
Date:   Wed, 26 Feb 2020 11:21:09 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 10/30] xfs: pass an initialized xfs_da_args structure to
 xfs_attr_set
Message-ID: <20200226002109.GS10776@dread.disaster.area>
References: <20200225231012.735245-1-hch@lst.de>
 <20200225231012.735245-11-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225231012.735245-11-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=Qo2LG7ZrGtr3xNe1JsAA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 25, 2020 at 03:09:52PM -0800, Christoph Hellwig wrote:
> Instead of converting from one style of arguments to another in
> xfs_attr_set, pass the structure from higher up in the call chain.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 69 ++++++++++++++++++----------------------
>  fs/xfs/libxfs/xfs_attr.h |  3 +-
>  fs/xfs/xfs_acl.c         | 33 ++++++++++---------
>  fs/xfs/xfs_ioctl.c       | 22 ++++++++-----
>  fs/xfs/xfs_iops.c        | 13 +++++---
>  fs/xfs/xfs_xattr.c       | 21 ++++++++----
>  6 files changed, 87 insertions(+), 74 deletions(-)

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

One question, not directly related to the patch:

>  __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>  {
> -	struct xfs_inode *ip = XFS_I(inode);
> -	unsigned char *ea_name;
> -	struct xfs_acl *xfs_acl = NULL;
> -	int len = 0;
> -	int error;
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	struct xfs_da_args	args = {
> +		.dp		= ip,
> +		.flags		= ATTR_ROOT,
> +	};
> +	int			error;
>  
>  	switch (type) {
>  	case ACL_TYPE_ACCESS:
> -		ea_name = SGI_ACL_FILE;
> +		args.name = SGI_ACL_FILE;
>  		break;
>  	case ACL_TYPE_DEFAULT:
>  		if (!S_ISDIR(inode->i_mode))
>  			return acl ? -EACCES : 0;
> -		ea_name = SGI_ACL_DEFAULT;
> +		args.name = SGI_ACL_DEFAULT;
>  		break;
>  	default:
>  		return -EINVAL;
>  	}
> +	args.namelen = strlen(args.name);
>  
>  	if (acl) {
> -		len = XFS_ACL_MAX_SIZE(ip->i_mount);
> -		xfs_acl = kmem_zalloc_large(len, 0);
> -		if (!xfs_acl)
> +		args.valuelen = XFS_ACL_MAX_SIZE(ip->i_mount);
> +		args.value = kmem_zalloc_large(args.valuelen, 0);
> +		if (!args.value)
>  			return -ENOMEM;
>  
> -		xfs_acl_to_disk(xfs_acl, acl);
> +		xfs_acl_to_disk(args.value, acl);
>  
>  		/* subtract away the unused acl entries */
> -		len -= sizeof(struct xfs_acl_entry) *
> +		args.valuelen -= sizeof(struct xfs_acl_entry) *
>  			 (XFS_ACL_MAX_ENTRIES(ip->i_mount) - acl->a_count);

why do we allocate a maximally sized buffer for the attribute data
(64kB for v5 filesystems) when we already know the size of the
data we are about to format into it? Why isn't this just:

	if (acl) {
		args.valuelen = sizeof(struct xfs_acl_entry) * acl->a_count;
		args.value = kmem_zalloc_large(args.valuelen, 0);
		if (!args.value)
			return -ENOMEM;

		xfs_acl_to_disk(args.value, acl); 
	}

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
