Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA8LKUVl023721 for <xfs@oss.sgi.com>; Thu, 8 Nov 2012 15:20:30 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	pNK34SrKxUrHFnKI for <xfs@oss.sgi.com>;
	Thu, 08 Nov 2012 13:22:28 -0800 (PST)
Date: Fri, 9 Nov 2012 08:22:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: add CRC infrastructure
Message-ID: <20121108212226.GQ6434@dastard>
References: <1352295452-4726-1-git-send-email-david@fromorbit.com>
	<1352295452-4726-2-git-send-email-david@fromorbit.com>
	<509BC4F0.1040304@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <509BC4F0.1040304@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Nov 08, 2012 at 08:42:56AM -0600, Mark Tinguely wrote:
> On 11/07/12 07:37, Dave Chinner wrote:
> >+/*
> >+ * Calculate the intermediate checksum for a buffer that has the CRC field
> >+ * inside it.  The offset of the 32bit crc fields is passed as the
> >+ * cksum_offset parameter.
> >+ */
> >+static inline __uint32_t
> >+xfs_start_cksum(char *buffer, size_t length, unsigned long cksum_offset)
> >+{
> >+	__uint32_t zero = 0;
> >+	__uint32_t crc;
> >+
> >+	/* Calculate CRC up to the checksum. */
> >+	crc = crc32c(XFS_CRC_SEED, buffer, cksum_offset);
> >+
> >+	/* Skip checksum field */
> >+	crc = crc32c(crc,&zero, sizeof(__u32));
> >+
> >+	/* Calculate the rest of the CRC. */
> >+	return crc32c(crc,&buffer[cksum_offset + sizeof(__be32)],
> >+		      length - (cksum_offset + sizeof(__be32)));
> >+}
> 
> Why not zero the cksum field and then calculate the crc on the whole buffer?

Because we use the same calculation function for verification of the
CRC and we do not want to zero the CRC field when verifying it. It
would make subsequent verification calls on an unmodified buffer
fail.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
