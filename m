Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2ODb4ZP027379 for <xfs@oss.sgi.com>; Sat, 24 Mar 2012 08:37:05 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	7xUz9tTDV0q0fiDV (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 24 Mar 2012 06:37:01 -0700 (PDT)
Date: Sat, 24 Mar 2012 09:36:59 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 7/8] xfs: fix fstrim offset calculations
Message-ID: <20120324133659.GA25674@infradead.org>
References: <1332393313-1955-1-git-send-email-david@fromorbit.com>
	<1332393313-1955-8-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1332393313-1955-8-git-send-email-david@fromorbit.com>
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

On Thu, Mar 22, 2012 at 04:15:12PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_ioc_fstrim() doesn't treat the incoming offset and length
> correctly. It treats them as a filesystem block address, rather than
> a disk address. This is wrong because the range passed in is a
> linear representation , while the filesystem block address notiation
> is a sparse representation. Hence we cannot convert the range direct
> to filesystem block units and then use that for calculating the
> range to trim.
> 
> While this sounds dangerous, the problem is limited to calculting
> what AGs need to be trimmed. The code that calcuates the actual
> ranges to trim gets the right result (i.e. only ever discards free
> space), even though it uses the wrong ranges to limit what is
> trimmed. Hence this is not a bug that endangers user data.
> 
> Fix this by treating the range as a disk address range and use the
> appropriate functions to convert the range into the desired formats
> for calculations.
> 
> Further, fix the first free extent lookup (the longest) to actually
> find the largest free extent. Currently this lookup uses a <=
> lookup, which results in finding the extent to the left of the
> largest because we can never get an exact match on the largest
> extent. This is due to the fact that while we know it's size, we
> don't know it's location and so the exact match fails and we move
> one record to the left to get the next largest extent. Instead, use
> a >= search so that the lookup returns the largest extent regardless
> of the fact we don't get an exact match on it.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good with the minor nitpick below.

Reviewed-by: Christoph Hellwig <hch@lst.de>

> -	error = xfs_alloc_lookup_le(cur, 0,
> +	error = xfs_alloc_lookup_ge(cur, 0,
>  			    be32_to_cpu(XFS_BUF_TO_AGF(agbp)->agf_longest), &i);

After this change xfs_alloc_lookup_le can be marked static in
xfs_alloc.c

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
