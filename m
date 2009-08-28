Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7SLcsXf177455 for <xfs@oss.sgi.com>; Fri, 28 Aug 2009 16:39:05 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH] xfsprogs: fix unaligned access in libxfs
Date: Fri, 28 Aug 2009 16:39:49 -0500
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE83ABEF@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20090828153718.GA26409@infradead.org>
From: "Alex Elder" <aelder@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Gabriel Vlasiu <gabrielvlasiu@gmail.com>, xfs@oss.sgi.com

Christoph Hellwig wrote:
> The get/put unaligned handlers we use to access the extent descriptor
> are not good enough for architectures like Sparc that do not tolerate
> dereferencing unaligned pointers.  Replace the implementation with the
> one the kernel uses on these architectures.  It might be a tad
> slower on architectures like x86, but I don't want to have multiple
> implementations around to not let the testing matrix explode.
> Also remove the unaligned.h header which includes another implementation
> for unaligned access we don't actually use anymore.
> 
> Note that the little change to xfs_inode.c needs to go into the kernel
> aswell, I will send a patch for that shortly.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reported-by: Gabriel Vlasiu <gabrielvlasiu@gmail.com>
> Tested-by: Gabriel Vlasiu <gabrielvlasiu@gmail.com>

Looks good.  Note comment about interface below.

Reviewed-by: Alex Elder <aelder@sgi.com>


> Index: xfsprogs-dev/libxfs/xfs.h
> ===================================================================
> --- xfsprogs-dev.orig/libxfs/xfs.h	2009-08-27 10:06:13.377855006 -0300
> +++ xfsprogs-dev/libxfs/xfs.h	2009-08-27 10:06:26.537884492 -0300
> @@ -127,19 +127,37 @@ static inline int __do_div(unsigned long
>  #define max_t(type,x,y) \
>  	({ type __x = (x); type __y = (y); __x > __y ? __x: __y; })
> 
> -/* only 64 bit accesses used in xfs kernel code */
> -static inline __u64 get_unaligned_be64(void *ptr)
> +
> +static inline __uint32_t __get_unaligned_be32(const __uint8_t *p)


It would be nice for this interface (and others) to take a (void *)
argument, but that would also mean immediately casting it to do
pointer arithmetic portably.  Not a big deal.

> +{
> +        return p[0] << 24 | p[1] << 16 | p[2] << 8 | p[3];
> +}
> +
> +static inline __uint64_t get_unaligned_be64(void *p)
>  {

. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
