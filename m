Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA7KTBYC177438 for <xfs@oss.sgi.com>; Wed, 7 Nov 2012 14:29:11 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	0UM9yE1B0KlyodXo for <xfs@oss.sgi.com>;
	Wed, 07 Nov 2012 12:31:07 -0800 (PST)
Date: Thu, 8 Nov 2012 07:31:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: add CRC infrastructure
Message-ID: <20121107203105.GE6434@dastard>
References: <1352295452-4726-1-git-send-email-david@fromorbit.com>
	<1352295452-4726-2-git-send-email-david@fromorbit.com>
	<m2ehk5qt88.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <m2ehk5qt88.fsf@firstfloor.org>
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
To: Andi Kleen <andi@firstfloor.org>
Cc: xfs@oss.sgi.com

On Wed, Nov 07, 2012 at 08:21:27AM -0800, Andi Kleen wrote:
> Dave Chinner <david@fromorbit.com> writes:
> > + */
> > +static inline __uint32_t
> > +xfs_start_cksum(char *buffer, size_t length, unsigned long cksum_offset)
> > +{
> > +	__uint32_t zero = 0;
> > +	__uint32_t crc;
> > +
> > +	/* Calculate CRC up to the checksum. */
> > +	crc = crc32c(XFS_CRC_SEED, buffer, cksum_offset);
> > +
> > +	/* Skip checksum field */
> > +	crc = crc32c(crc, &zero, sizeof(__u32));
> > +
> > +	/* Calculate the rest of the CRC. */
> > +	return crc32c(crc, &buffer[cksum_offset + sizeof(__be32)],
> > +		      length - (cksum_offset + sizeof(__be32)));
> 
> Don't you need to remap a zero result to some other value, otherwise a
> real zero checksum will never be checked?

Why would that be necessary? We never include the checksum field in
the calculation when setting it or verifiying it, and the
verification uses exactly the same method as the original
calculation to check the CRC, so it doesn't matter if the CRC value
is zero or not - if it matches (zero or otherwise), the validation
passes....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
