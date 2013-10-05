Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 111937F4E
	for <xfs@oss.sgi.com>; Fri,  4 Oct 2013 22:55:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id ECA97304059
	for <xfs@oss.sgi.com>; Fri,  4 Oct 2013 20:55:03 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	jS3HNFwKR5LIH2Oq for <xfs@oss.sgi.com>;
	Fri, 04 Oct 2013 20:55:02 -0700 (PDT)
Date: Sat, 5 Oct 2013 13:54:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprogs: fix crc32 build on big endian
Message-ID: <20131005035459.GN4446@dastard>
References: <524F7753.8050801@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <524F7753.8050801@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Fri, Oct 04, 2013 at 09:20:03PM -0500, Eric Sandeen wrote:
> While kernelspace can test #ifdef __LITTLE_ENDIAN, this
> doesn't work in userspace.  __LITTLE_ENDIAN is defined -
> as is __BIG_ENDIAN.
> 
> So we build on all boxes as __LITTLE_ENDIAN, and the
> self-test (thankfully!) fails on big endian boxes.

I'm glad I put that self test into the build now. :)

> Fix this by testing __BYTE_ORDER values.
> 
> And add an else which should never be hit, but just in case...
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/libxfs/crc32.c b/libxfs/crc32.c
> index 1c0d958..0f847d2 100644
> --- a/libxfs/crc32.c
> +++ b/libxfs/crc32.c
> @@ -63,18 +63,20 @@ typedef __u32	u64;
>  static inline u32
>  crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 (*tab)[256])
>  {
> -# ifdef __LITTLE_ENDIAN
> +#if __BYTE_ORDER == __LITTLE_ENDIAN
>  #  define DO_CRC(x) crc = t0[(crc ^ (x)) & 255] ^ (crc >> 8)
>  #  define DO_CRC4 (t3[(q) & 255] ^ t2[(q >> 8) & 255] ^ \
>  		   t1[(q >> 16) & 255] ^ t0[(q >> 24) & 255])
>  #  define DO_CRC8 (t7[(q) & 255] ^ t6[(q >> 8) & 255] ^ \
>  		   t5[(q >> 16) & 255] ^ t4[(q >> 24) & 255])
> -# else
> +# elif __BYTE_ORDER == __BIG_ENDIAN
>  #  define DO_CRC(x) crc = t0[((crc >> 24) ^ (x)) & 255] ^ (crc << 8)
>  #  define DO_CRC4 (t0[(q) & 255] ^ t1[(q >> 8) & 255] ^ \
>  		   t2[(q >> 16) & 255] ^ t3[(q >> 24) & 255])
>  #  define DO_CRC8 (t4[(q) & 255] ^ t5[(q >> 8) & 255] ^ \
>  		   t6[(q >> 16) & 255] ^ t7[(q >> 24) & 255])
> +# else
> +#  error What endian are you?
>  # endif
>  	const u32 *b;
>  	size_t    rem_len;

Looks good - it matches the other endian checks in the code.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
