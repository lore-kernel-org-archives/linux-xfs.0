Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7DCC77F6F
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 18:42:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 50032304051
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 16:42:54 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	T5bXgLImFiaR0fEa for <xfs@oss.sgi.com>;
	Fri, 03 Jul 2015 16:42:52 -0700 (PDT)
Date: Sat, 4 Jul 2015 09:42:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 10/13] xfsprogs: include libxfs.h in libxfs_priv.h
Message-ID: <20150703234248.GO7943@dastard>
References: <1435918341-10128-1-git-send-email-hch@lst.de>
	<1435918341-10128-11-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1435918341-10128-11-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Fri, Jul 03, 2015 at 12:12:18PM +0200, Christoph Hellwig wrote:
> libxfs_priv.h duplicates large parts of libxfs.h.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  include/libxfs.h     |  4 ----
>  libxfs/libxfs_priv.h | 37 +------------------------------------
>  2 files changed, 1 insertion(+), 40 deletions(-)

This is the opposite of what I've been trying to get to, which is to
make libxfs compilation not be reliant on the external definitions
used by the rest of xfsprogs. i.e. libxfs_priv.h contains all the
bits that are need to compile the kernel code, libxfs_api_defs.h
contain all the swizzling needed to namespace all the externally
used libxfs code correctly, and libxfs_io.h contains all the buffer
IO interfaces.

In the end, there should be no duplication between the two files,
except for infrastructure includes like platform defs, lists, trees,
etc.  This isnt quite complete yet, which is why there is some
duplication in the code right now.

> diff --git a/include/libxfs.h b/include/libxfs.h
> index 1fb2d6d..62553f0 100644
> --- a/include/libxfs.h
> +++ b/include/libxfs.h
> @@ -163,12 +163,8 @@ extern int	libxfs_bmap_finish(xfs_trans_t **, xfs_bmap_free_t *, int *);
>  extern void 	libxfs_fs_repair_cmn_err(int, struct xfs_mount *, char *, ...);
>  extern void	libxfs_fs_cmn_err(int, struct xfs_mount *, char *, ...);
>  
> -/* XXX: this is messy and needs fixing */
> -#ifndef __LIBXFS_INTERNAL_XFS_H__
>  extern void cmn_err(int, char *, ...);
>  enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
> -#endif
> -

cmn_err needs to be removed from all the external utilities.  This is
only a small amount of work, cmn_err is only used in the repair AVL
code and a single call in the logprint code. Both libxfs_fs_cmn_err
and xfs_fs_repair_cmn_err are completely unused, so cmn_err() should
become a libxfs internal function, and eventually be rewritten to
have native xfs_alert() style interfaces...

> -
> -/* CRC stuff, buffer API dependent on it */
> -extern uint32_t crc32_le(uint32_t crc, unsigned char const *p, size_t len);
> -extern uint32_t crc32c_le(uint32_t crc, unsigned char const *p, size_t len);
> -
> -#define crc32(c,p,l)	crc32_le((c),(unsigned char const *)(p),(l))
> -#define crc32c(c,p,l)	crc32c_le((c),(unsigned char const *)(p),(l))

I was planning to move this to libxfs_api_defs.h, as it's swizlling
needed to allow xfs_cksum.h be included in external code.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
