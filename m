Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA7GJWtT161723 for <xfs@oss.sgi.com>; Wed, 7 Nov 2012 10:19:32 -0600
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93]) by
	cuda.sgi.com with ESMTP id iEGMNiqzYyNb42es for
	<xfs@oss.sgi.com>; Wed, 07 Nov 2012 08:21:27 -0800 (PST)
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/2] xfs: add CRC infrastructure
References: <1352295452-4726-1-git-send-email-david@fromorbit.com>
	<1352295452-4726-2-git-send-email-david@fromorbit.com>
Date: Wed, 07 Nov 2012 08:21:27 -0800
In-Reply-To: <1352295452-4726-2-git-send-email-david@fromorbit.com> (Dave
	Chinner's message of "Thu, 8 Nov 2012 00:37:31 +1100")
Message-ID: <m2ehk5qt88.fsf@firstfloor.org>
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Dave Chinner <david@fromorbit.com> writes:
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
> +	crc = crc32c(crc, &zero, sizeof(__u32));
> +
> +	/* Calculate the rest of the CRC. */
> +	return crc32c(crc, &buffer[cksum_offset + sizeof(__be32)],
> +		      length - (cksum_offset + sizeof(__be32)));

Don't you need to remap a zero result to some other value, otherwise a
real zero checksum will never be checked?

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
