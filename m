Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3S61p46207734 for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 01:01:52 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AEDEE126FC7B
	for <xfs@oss.sgi.com>; Tue, 27 Apr 2010 23:03:53 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	WiDog4Akb42tW9Df for <xfs@oss.sgi.com>;
	Tue, 27 Apr 2010 23:03:53 -0700 (PDT)
Date: Wed, 28 Apr 2010 16:03:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: cleanup log reservation calculactions
Message-ID: <20100428060350.GF9783@dastard>
References: <20100427141909.GA6597@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100427141909.GA6597@infradead.org>
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

On Tue, Apr 27, 2010 at 10:19:09AM -0400, Christoph Hellwig wrote:
> Instead of having small helper functions calling big macros do the
> calculations for the log reservations directly in the functions.  These
> are mostly 1:1 from the macros execept that the macros kept the quota
> calculations in their callers.

I like the idea, just a coupl eof small(ish) comments.

Firstly:

> -	return XFS_CALC_WRITE_LOG_RES(mp) + XFS_DQUOT_LOGRES(mp);
> +	return MAX(

	<some large expression>

> +		) + XFS_DQUOT_LOGRES(mp);

It's not very obvious that the dquot logres is separate to the large
calculation.  The single space indents as perenthesis are nested
just doesn't make this stand out like I think it should.  Can you
put the XFS_DQUOT_LOGRES(mp) first in all these calculations so that
it is more obvious that it is both present and separate to the main
reservation?i

That would also address the second issue that the way you terminate
the major expression and add the dquot logres is different in a
couple of functions.

I'm also wondering if we should be converting some of the magic
numbers like:

> +xfs_calc_ichange_reservation(
> +	struct xfs_mount	*mp)
>  {
> -	return XFS_CALC_ICHANGE_LOG_RES(mp) + XFS_DQUOT_LOGRES(mp);
> +	return mp->m_sb.sb_inodesize +
> +		mp->m_sb.sb_sectsize +
> +		512 +
> +		XFS_DQUOT_LOGRES(mp);
> +
>  }

to be correct. i.e.

	return mp->m_sb.sb_inodesize +
		mp->m_sb.sb_sectsize +
		sizeof(struct xfs_inode_log_format) +
		sizeof(struct xfs_buf_log_format) +
		XFS_DQUOT_LOGRES(mp);

instead of the magic 512 bytes that are added? I guess that's more
of a followup correctness patch than a cleanup patch....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
