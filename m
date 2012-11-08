Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA8Ef67E260930 for <xfs@oss.sgi.com>; Thu, 8 Nov 2012 08:41:06 -0600
Message-ID: <509BC4F0.1040304@sgi.com>
Date: Thu, 08 Nov 2012 08:42:56 -0600
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
> +
> +	/* Calculate the rest of the CRC. */
> +	return crc32c(crc,&buffer[cksum_offset + sizeof(__be32)],
> +		      length - (cksum_offset + sizeof(__be32)));
> +}

Why not zero the cksum field and then calculate the crc on the whole buffer?

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
