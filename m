Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BE1137CE0
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2016 17:38:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 80EE18F8156
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2016 15:38:44 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	52ugyNrQQjA4mUSi for <xfs@oss.sgi.com>;
	Thu, 07 Jul 2016 15:38:41 -0700 (PDT)
Date: Fri, 8 Jul 2016 08:38:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: abstract block export operations from nfsd
	layouts
Message-ID: <20160707223809.GH12670@dastard>
References: <5ff05b585226b689866f4604adddffc94910f63f.1467889001.git.bcodding@redhat.com>
	<073be10a55e5e952adbfd320abcce075fb3958ae.1467889001.git.bcodding@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <073be10a55e5e952adbfd320abcce075fb3958ae.1467889001.git.bcodding@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Benjamin Coddington <bcodding@redhat.com>
Cc: linux-nfs@vger.kernel.org, xfs@oss.sgi.com, bfields@fieldses.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Thu, Jul 07, 2016 at 07:02:32AM -0400, Benjamin Coddington wrote:
> Instead of creeping pnfs layout configuration into filesystems, move the
> definition of block-based export operations under a more abstract
> configuration.
> 
> Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
> ---
>  fs/Kconfig          | 3 +++
>  fs/nfsd/Kconfig     | 2 ++
>  fs/xfs/Makefile     | 3 +--
>  fs/xfs/xfs_export.c | 2 +-
>  fs/xfs/xfs_pnfs.h   | 4 ++--
>  5 files changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/Kconfig b/fs/Kconfig
> index 6725f59c18e6..6e57b4237d72 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -66,6 +66,9 @@ config FS_POSIX_ACL
>  config EXPORTFS
>  	tristate
>  
> +config BLOCK_EXPORT_OPS
> +	bool
> +

default n, help text?

Also, BLOCK_* prefix config options are for block layer
functionality, hence I suspect this will confuse people because it's
a filesystem config option. EXPORTFS_BLOCK_OPS seems more obvious
and correct to me, as the block mapping ops are part of the exportfs
operations interface....

>  xfs-$(CONFIG_SYSCTL)		+= xfs_sysctl.o
>  xfs-$(CONFIG_COMPAT)		+= xfs_ioctl32.o
> -xfs-$(CONFIG_NFSD_BLOCKLAYOUT)	+= xfs_pnfs.o
> -xfs-$(CONFIG_NFSD_SCSILAYOUT)	+= xfs_pnfs.o
> +xfs-$(CONFIG_BLOCK_EXPORT_OPS)	+= xfs_pnfs.o

Why do we need the first patch to XFS anymore? Just convert it
straight to using CONFIG_EXPORTFS_BLOCK_OPS....


Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
