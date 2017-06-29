Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:60240 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751696AbdF2WeQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Jun 2017 18:34:16 -0400
Subject: Re: [PATCH] xfs: clear di_forkoff on ialloc
References: <bb3e00eb-7334-1ac5-509f-89804583e9ff@suse.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <8f8f3970-e087-7d85-001f-d5ed55846c77@sandeen.net>
Date: Thu, 29 Jun 2017 17:34:14 -0500
MIME-Version: 1.0
In-Reply-To: <bb3e00eb-7334-1ac5-509f-89804583e9ff@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Mahoney <jeffm@suse.com>, linux-xfs@vger.kernel.org

On 10/5/16 12:04 PM, Jeff Mahoney wrote:
> Commit 6dfe5a049f2 (xfs: xfs_attr_inactive leaves inconsistent
> attr fork state behind) fixed an issue where an inconsistent
> attr fork count persisted on disk if there was concurrent inode
> writeback happening after the inode was evicted from the VFS layer.
> 
> If one of those inodes landed on disk and was reused, it may have
> an invalid di_forkoff, which can cause problems when trying to add
> new extended attributes.  Since we clear the rest of the attribute
> fork values on ialloc, let's clear di_forkoff as well and ensure the
> invalid value won't be encountered.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

This makes sense to me, but seems to have gotten lost.

It'd need to go to libxfs_ialloc as well if it makes the kernel.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/xfs/xfs_inode.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -835,6 +835,7 @@ xfs_ialloc(
>  	 */
>  	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
>  	ip->i_d.di_anextents = 0;
> +	ip->i_d.di_forkoff = 0;
>  
>  	/*
>  	 * Log the new values stuffed into the inode.
> 
