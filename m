Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA9M7fhW163469 for <xfs@oss.sgi.com>; Fri, 9 Nov 2012 16:07:41 -0600
Message-ID: <509D7F1A.3090201@sgi.com>
Date: Fri, 09 Nov 2012 16:09:30 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] xfs: add CRC infrastructure
References: <1352295452-4726-1-git-send-email-david@fromorbit.com>
	<1352295452-4726-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1352295452-4726-2-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 11/07/12 07:37, Dave Chinner wrote:
> From: Christoph Hellwig<hch@lst.de>
>
>   - add a mount feature bit for CRC enabled filesystems
>   - add some helpers for generating and verifying the CRCs
>   - add a copy_uuid helper
>
> The checksumming helpers are losely based on similar ones in sctp,
> all other bits come from Dave Chinner.
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---
> +/*
> + * Calculate the intermediate checksum for a buffer that has the CRC field
> + * inside it.  The offset of the 32bit crc fields is passed as the
> + * cksum_offset parameter.
> + */
> +static inline __uint32_t
> +xfs_start_cksum(char *buffer, size_t length, unsigned long cksum_offset)
> +{
> +	__uint32_t zero = 0;
> +	__uint32_t crc;
> +
> +	/* Calculate CRC up to the checksum. */
> +	crc = crc32c(XFS_CRC_SEED, buffer, cksum_offset);
> +
> +	/* Skip checksum field */
> +	crc = crc32c(crc,&zero, sizeof(__u32));

I know this came from sctp and I know I can't convince you to copy/null
the *cksum_offset to make one block for those with hardware crc32c devices.

Since the *cksum_offset value is never used in creating and verifying
the checksum, the 4 bytes of zeros does not add any new information,
why not just drop it from the cksum calculation?

> +
> +	/* Calculate the rest of the CRC. */
> +	return crc32c(crc,&buffer[cksum_offset + sizeof(__be32)],
> +		      length - (cksum_offset + sizeof(__be32)));
> +}
> +
> +/*
> + * Convert the intermediate checksum to the final ondisk format.
> + *
> + * Note that crc32c is already endianess agnostic, so no additional
> + * byte swap is needed.
> + */
> +static inline __be32
> +xfs_end_cksum(__uint32_t crc)
> +{
> +	return (__force __be32)~crc;
> +}
> +

Wouldn't you have to cpu_to_le32() for big endian machines?

commit 9c5ff5f75d0d0a1c7928ecfae3f38418b51a88e3
Author: Vlad Yasevich <vladislav.yasevich@hp.com>
Date:   Thu Jan 22 14:52:23 2009 -0800

     sctp: Fix crc32c calculations on big-endian arhes.

     crc32c algorithm provides a byteswaped result.  On little-endian
     arches, the result ends up in big-endian/network byte order.
     On big-endinan arches, the result ends up in little-endian
     order and needs to be byte swapped again.  Thus calling cpu_to_le32
     gives the right output.

     Tested-by: Jukka Taimisto <jukka.taimisto@mail.suomi.net>
     Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
     Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/include/net/sctp/checksum.h b/include/net/sctp/checksum.h
index b799fb2..2fec3c3 100644
--- a/include/net/sctp/checksum.h
+++ b/include/net/sctp/checksum.h
@@ -79,5 +79,5 @@ static inline __be32 sctp_update_cksum(__u8 *buffer, 
__u16 length, __be32 crc32)

  static inline __be32 sctp_end_cksum(__be32 crc32)
  {
-       return ~crc32;
+       return (__force __be32)~cpu_to_le32((__force u32)crc32);
  }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
