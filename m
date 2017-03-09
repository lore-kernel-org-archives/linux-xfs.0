Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54246 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750726AbdCIUkB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 Mar 2017 15:40:01 -0500
Subject: Re: [PATCH 2/2] xfs: remove readonly checks from xfs_release &
 xfs_inactive
References: <bbb0243d-e491-02e0-1802-e95cba4e8486@redhat.com>
 <36942625-073a-56ba-4d31-cd9511f3bfb8@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <0d11326f-ebfc-913a-ed1a-b88421982753@sandeen.net>
Date: Thu, 9 Mar 2017 14:39:59 -0600
MIME-Version: 1.0
In-Reply-To: <36942625-073a-56ba-4d31-cd9511f3bfb8@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On 3/9/17 2:24 PM, Eric Sandeen wrote:
> xfs_release & xfs_inactive both had early returns for readonly
> mounts.
> 
> Ultimately, this means that when we do log recovery on a
> read-only mount, we do not process unlinked inodes, because
> of this misguided effort to not do /any/ IO, ever, on a readonly
> mount.  IO at mount time is fine, and expected - after all we
> just got done doing log recovery!  Even ro mounts, without the
> norecovery flag, can do enough IO to put the filesystem in a
> consistent state.
> 
> We should not get here after mount is complete;

sorry, above is wrong.

> at that point
> the vfs will not allow anything from userspace to make
> modifications which would get us here with any IO to do - 

but I think this part is right.  :)  I guess we might lose
a little effiency doing pointless checks in i.e. xfs_release
if it's a readonly mount and we know there is no work to do.

I won't resend until it's had a couple eyeballs...

> we can't unlink files, or create blocks past eof, etc.
> So it's safe to just remove these checks.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index edfa6a5..bf74165 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1658,10 +1658,6 @@
>  	if (!S_ISREG(VFS_I(ip)->i_mode) || (VFS_I(ip)->i_mode == 0))
>  		return 0;
>  
> -	/* If this is a read-only mount, don't do this (would generate I/O) */
> -	if (mp->m_flags & XFS_MOUNT_RDONLY)
> -		return 0;
> -
>  	if (!XFS_FORCED_SHUTDOWN(mp)) {
>  		int truncated;
>  
> @@ -1896,10 +1892,6 @@
>  	mp = ip->i_mount;
>  	ASSERT(!xfs_iflags_test(ip, XFS_IRECOVERY));
>  
> -	/* If this is a read-only mount, don't do this (would generate I/O) */
> -	if (mp->m_flags & XFS_MOUNT_RDONLY)
> -		return;
> -
>  	if (VFS_I(ip)->i_nlink != 0) {
>  		/*
>  		 * force is true because we are evicting an inode from the
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
