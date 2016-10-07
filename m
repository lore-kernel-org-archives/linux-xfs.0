Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:60574 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756805AbcJGVDM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Oct 2016 17:03:12 -0400
Subject: Re: [PATCH] xfs: Remove unused xfs_evict_inode tracepoint
References: <1475788713-3415-1-git-send-email-agruenba@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5e43fb1f-0c9f-5ad2-fa60-611cdfae126a@sandeen.net>
Date: Fri, 7 Oct 2016 16:03:10 -0500
MIME-Version: 1.0
In-Reply-To: <1475788713-3415-1-git-send-email-agruenba@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org

On 10/6/16 4:18 PM, Andreas Gruenbacher wrote:
> Commit 8179c036 removed the ->evict_inode super operation but left the
> xfs_evict_inode tracepoint in place, with the effect that that
> tracepoint is now unused.  Remove the tracepoint as well now.
> 
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>

I can review this one ;)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/xfs/xfs_trace.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index d303a66..fdd9d53 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -677,7 +677,6 @@ DEFINE_INODE_EVENT(xfs_ioctl_setattr);
>  DEFINE_INODE_EVENT(xfs_dir_fsync);
>  DEFINE_INODE_EVENT(xfs_file_fsync);
>  DEFINE_INODE_EVENT(xfs_destroy_inode);
> -DEFINE_INODE_EVENT(xfs_evict_inode);
>  DEFINE_INODE_EVENT(xfs_update_time);
>  
>  DEFINE_INODE_EVENT(xfs_dquot_dqalloc);
> 
