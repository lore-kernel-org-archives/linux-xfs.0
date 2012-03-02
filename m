Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q229fCPe023940 for <xfs@oss.sgi.com>; Fri, 2 Mar 2012 03:41:12 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	pYAnKSxQmB3rWxF4 for <xfs@oss.sgi.com>;
	Fri, 02 Mar 2012 01:41:10 -0800 (PST)
Date: Fri, 2 Mar 2012 20:41:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] repair: fix the variable-width nlink array
Message-ID: <20120302094108.GG5091@dastard>
References: <20120228174223.GA6148@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120228174223.GA6148@infradead.org>
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
Cc: xfs@oss.sgi.com

On Tue, Feb 28, 2012 at 12:42:24PM -0500, Christoph Hellwig wrote:
> It looks like we currently never grow the variable-width nlink array
> if only the on-disk nlink size overflows 8 bits.  This leads to a major
> mess in nlink counting, and eventually an assert in phase7.
> 
> Replace the indirect all mess with a union that allows doing proper
> array arithmetics while we're at it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks fairly sane to me. I can't see any obvious problems with the
change, though it might be worth adding an overflow warning to the
code:

> +	switch (irec->nlink_size) {
> +	case sizeof(__uint8_t):
> +		if (irec->ino_un.ex_data->counted_nlinks.un8[ino_offset] < 0xff) {
> +			irec->ino_un.ex_data->counted_nlinks.un8[ino_offset]++;
> +			break;
> +		}
>  		nlink_grow_8_to_16(irec);
> -		disk_nlink_16_set(irec, ino_offset, nlinks);
> -	} else
> -		irec->disk_nlinks[ino_offset] = nlinks;
> +		/*FALLTHRU*/
> +	case sizeof(__uint16_t):
> +		if (irec->ino_un.ex_data->counted_nlinks.un16[ino_offset] < 0xffff) {
> +			irec->ino_un.ex_data->counted_nlinks.un16[ino_offset]++;
> +			break;
> +		}
> +		nlink_grow_16_to_32(irec);
> +		/*FALLTHRU*/
> +	case sizeof(__uint32_t):
> +		irec->ino_un.ex_data->counted_nlinks.un32[ino_offset]++;

To check for UINT_MAX before the increment....

> +	switch (irec->nlink_size) {
> +	case sizeof(__uint8_t):
> +		ASSERT(irec->ino_un.ex_data->counted_nlinks.un8[ino_offset] > 0);
> +		refs = --irec->ino_un.ex_data->counted_nlinks.un8[ino_offset];
> +		break;
> +	case sizeof(__uint16_t):
> +		ASSERT(irec->ino_un.ex_data->counted_nlinks.un16[ino_offset] > 0);
> +		refs = --irec->ino_un.ex_data->counted_nlinks.un16[ino_offset];
> +		break;
> +	case sizeof(__uint32_t):
> +		ASSERT(irec->ino_un.ex_data->counted_nlinks.un32[ino_offset] > 0);
> +		refs = --irec->ino_un.ex_data->counted_nlinks.un32[ino_offset];
> +		break;
> +	default:
> +		ASSERT(0);

Similar to the underflow checks here.

Otherwise:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
