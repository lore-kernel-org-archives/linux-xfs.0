Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 128227CB2
	for <xfs@oss.sgi.com>; Sun, 10 Jul 2016 04:45:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B7EEC304032
	for <xfs@oss.sgi.com>; Sun, 10 Jul 2016 02:45:44 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id SNCtkWIfasMWKPyW (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 10 Jul 2016 02:45:42 -0700 (PDT)
Date: Sun, 10 Jul 2016 11:45:40 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] xfs: abstract block export operations from nfsd layouts
Message-ID: <20160710094540.GA19392@lst.de>
References: <6c1549ee874431c8293cad72c5f7382095277822.1467985684.git.bcodding@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <6c1549ee874431c8293cad72c5f7382095277822.1467985684.git.bcodding@redhat.com>
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

On Fri, Jul 08, 2016 at 09:53:20AM -0400, Benjamin Coddington wrote:
> Instead of creeping pnfs layout configuration into filesystems, move the
> definition of block-based export operations under a more abstract
> configuration.
> 
> Changes from v1:
> 	- dropped the first patch in the first posting
> 	- renamed the config to EXPORTFS_BLOCK_OPS from BLOCK_EXPORT_OPS
> 	- add an explicit default to no for EXPORTFS_BLOCK_OPS
> 	- add some help and menu text
> 
> Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
> ---
>  fs/Kconfig          | 7 +++++++
>  fs/nfsd/Kconfig     | 2 ++
>  fs/xfs/Makefile     | 3 +--
>  fs/xfs/xfs_export.c | 2 +-
>  fs/xfs/xfs_pnfs.h   | 4 ++--
>  5 files changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/Kconfig b/fs/Kconfig
> index 6725f59c18e6..ac6d3b36600c 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -66,6 +66,13 @@ config FS_POSIX_ACL
>  config EXPORTFS
>  	tristate
>  
> +config EXPORTFS_BLOCK_OPS
> +	bool "Enable filesystem export operations for block IO"
> +	default n

default n is the default, no need to add it.

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
