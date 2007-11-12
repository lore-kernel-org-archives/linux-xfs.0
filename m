Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 11 Nov 2007 22:31:49 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAC6Vbo4016474
	for <xfs@oss.sgi.com>; Sun, 11 Nov 2007 22:31:40 -0800
Date: Mon, 12 Nov 2007 17:31:36 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [[PATCH, RESEND]] V2 inodes per default, and move DFL bits to XFS_DFL_SB_VERSION_BITS,
Message-ID: <20071112063136.GB66820511@sgi.com>
References: <20071031233516.GB88034736@melbourne.sgi.com> <1194839329-22003-1-git-send-email-xaiki@sgi.com> <1194839329-22003-2-git-send-email-xaiki@sgi.com> <1194839329-22003-3-git-send-email-xaiki@sgi.com> <1194839329-22003-4-git-send-email-xaiki@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1194839329-22003-4-git-send-email-xaiki@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xaiki@sgi.com
Cc: xfs@oss.sgi.com

On Mon, Nov 12, 2007 at 02:48:47PM +1100, xaiki@sgi.com wrote:
> From: Niv Sardi <xaiki@sgi.com>
> 
> Activate XFS_SB_VERSION_NLINKBIT per default, witch will enable V2 INODES.
> refactor bits that we want everytime in XFS_DFL_SB_VERSION_BITS.

Yay! A description ;)

s/witch/which/

> ---
>  xfsprogs/mkfs/xfs_mkfs.h |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/xfsprogs/mkfs/xfs_mkfs.h b/xfsprogs/mkfs/xfs_mkfs.h
> index f19f917..9291e33 100644
> --- a/xfsprogs/mkfs/xfs_mkfs.h
> +++ b/xfsprogs/mkfs/xfs_mkfs.h
> @@ -18,17 +18,19 @@
>  #ifndef __XFS_MKFS_H__
>  #define	__XFS_MKFS_H__
>  
> +#define XFS_DFL_SB_VERSION_BITS XFS_SB_VERSION_NLINKBIT|XFS_SB_VERSION_EXTFLGBIT
> +

I suggest splitting this over multiple lines and calling it
XFS_DEFAULT_SB_VERSION_BITS.

#define XFS_DEFAULT_SB_VERSION_BITS \
		(XFS_SB_VERSION_NLINKBIT | \
		 XFS_SB_VERSION_EXTFLGBIT)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
