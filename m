Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:33350 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbfEHUM6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 May 2019 16:12:58 -0400
Date: Wed, 8 May 2019 13:10:33 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: short circuit xfs_get_acl() if no acl is possible
Message-ID: <20190508201033.GW5207@magnolia>
References: <35128e32-d69b-316e-c8d6-8f109646390d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35128e32-d69b-316e-c8d6-8f109646390d@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, David Valin <dvalin@redhat.com>

On Wed, May 08, 2019 at 02:28:09PM -0500, Eric Sandeen wrote:
> If there are no attributes on the inode, don't go through the
> cost of memory allocation and callling xfs_attr_get when we
> already know we'll just get -ENOATTR.
> 
> Reported-by: David Valin <dvalin@redhat.com>
> Suggested-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> index 8039e35147dd..b469b44e9e71 100644
> --- a/fs/xfs/xfs_acl.c
> +++ b/fs/xfs/xfs_acl.c
> @@ -132,6 +132,9 @@ xfs_get_acl(struct inode *inode, int type)
>  		BUG();
>  	}
>  
> +	if (!xfs_inode_hasattr(ip))
> +		return NULL;

This isn't going to cause problems if someone's adding an ACL to the
inode at the same time, right?

I'm assuming that's the case since we only would load inodes when
setting up a vfs inode but before any userspace can get its sticky
fingers all over the inode, but it sure would be nice to know that
for sure. :)

--D

> +
>  	/*
>  	 * If we have a cached ACLs value just return it, not need to
>  	 * go out to the disk.
> 
