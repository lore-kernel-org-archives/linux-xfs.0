Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727056AbfAaSTG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 Jan 2019 13:19:06 -0500
Date: Thu, 31 Jan 2019 19:19:03 +0100
From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 01/10] xfs: Fix xqmstats offsets in /proc/fs/xfs/xqmstat
Message-ID: <20190131181903.GB4989@kroah.com>
References: <20190131180919.2500-1-mcgrof@kernel.org>
 <20190131180919.2500-2-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190131180919.2500-2-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: linux-xfs@vger.kernel.org, Alexander.Levin@microsoft.com, amir73il@gmail.com, hch@infradead.org, Carlos Maiolino <cmaiolino@redhat.com>, Dave Chinner <david@fromorbit.com>

On Thu, Jan 31, 2019 at 10:09:10AM -0800, Luis Chamberlain wrote:
> From: Carlos Maiolino <cmaiolino@redhat.com>
> 
> The addition of FIBT, RMAP and REFCOUNT changed the offsets into
> __xfssats structure.
> 
> This caused xqmstat_proc_show() to display garbage data via
> /proc/fs/xfs/xqmstat, once it relies on the offsets marked via macros.
> 
> Fix it.
> 
> Fixes: 00f4e4f9 xfs: add rmap btree stats infrastructure
> Fixes: aafc3c24 xfs: support the XFS_BTNUM_FINOBT free inode btree type
> Fixes: 46eeb521 xfs: introduce refcount btree definitions
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  fs/xfs/xfs_stats.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

You do not list what the upstream git commit ids are on any of these
patches :(

That's a requirement, sorry, can you respin these and add that to the
first line of the commit, as is normally done in the stable patches?

thanks,

greg k-h
