Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 58D147F6A
	for <xfs@oss.sgi.com>; Mon,  3 Feb 2014 09:09:11 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 41B198F8035
	for <xfs@oss.sgi.com>; Mon,  3 Feb 2014 07:09:08 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id GUCSb7e58ivuuvNp (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 03 Feb 2014 07:09:07 -0800 (PST)
Date: Mon, 3 Feb 2014 07:09:07 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/5] metadump: separate single block objects from
	multiblock objects
Message-ID: <20140203150907.GB6335@infradead.org>
References: <1390472635-17225-1-git-send-email-david@fromorbit.com>
	<1390472635-17225-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1390472635-17225-4-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Jan 23, 2014 at 09:23:53PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When trying to dump objects, we have to treat multi-block objects
> differently to single block objects. Separate out the code paths for
> single block vs multi-block objects so we can add a separate path
> for multi-block objects.

Looks good, but two minor style nitpicks below.

Reviewed-by: Christoph Hellwig <hch@lst.de>

>  static int
> +process_multi_fsb_objects(
> +	xfs_dfiloff_t	o,
> +	xfs_dfsbno_t	s,
> +	xfs_dfilblks_t	c,
> +	typnm_t		btype,
> +	xfs_dfiloff_t	last)
> +{
> +	if (btype != TYP_DIR2) {
> +		print_warning("bad type for multi-fsb object %d", btype);
> +		return -EINVAL;
> +	}
> +
> +	return process_single_fsb_objects(o, s, c, btype, last);

I'd prefer a switch with a default statement for the unknown type here,
as that leads to nicer extensibility.

> +		/* single filesystem block objects are trivial to handle */
> +		if (btype != TYP_DIR2 || mp->m_dirblkfsbs == 1) {
> +			error = process_single_fsb_objects(o, s, c, btype, last);
> +			if (error)
>  				return 0;
> +			continue;
>  		}
> +
> +		/* multi-extent directory blocks */
> +		error = process_multi_fsb_objects(o, s, c, btype, last);
> +		if (error)
> +			return 0;

An if / else would look a little more obvious here, not that it really
matters all that much.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
