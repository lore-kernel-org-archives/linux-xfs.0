Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:59014 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728055AbfEUQdF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 May 2019 12:33:05 -0400
Subject: Re: [PATCH 02/12] libxfs: set m_finobt_nores when initializing
 library
References: <155839420081.68606.4573219764134939943.stgit@magnolia>
 <155839421389.68606.12844536360638603273.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <3bfe3296-1c35-f1f3-1a05-6ab81b124f9c@sandeen.net>
Date: Tue, 21 May 2019 11:33:04 -0500
MIME-Version: 1.0
In-Reply-To: <155839421389.68606.12844536360638603273.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 5/20/19 6:16 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> We don't generally set up per-ag reservations in userspace, so set this
> flag to true to force transactions to set up block reservations.  This
> isn't necessary for userspace (since we never touch the finobt) but we
> shouldn't leave a logic bomb.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  libxfs/init.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> 
> diff --git a/libxfs/init.c b/libxfs/init.c
> index 2f6decc8..1baccb31 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -640,6 +640,7 @@ libxfs_mount(
>  
>  	libxfs_buftarg_init(mp, dev, logdev, rtdev);
>  
> +	mp->m_finobt_nores = true;
>  	mp->m_flags = (LIBXFS_MOUNT_32BITINODES|LIBXFS_MOUNT_32BITINOOPT);
>  	mp->m_sb = *sb;
>  	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_KERNEL);
> 
