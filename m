Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p079JUKW022183 for <xfs@oss.sgi.com>; Fri, 7 Jan 2011 03:19:30 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 061C023FEB8
	for <xfs@oss.sgi.com>; Fri,  7 Jan 2011 01:21:38 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	mCjeSjKoMK9fGgcC for <xfs@oss.sgi.com>;
	Fri, 07 Jan 2011 01:21:38 -0800 (PST)
Date: Fri, 7 Jan 2011 20:21:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/8] xfs: split direct IO write path from
	xfs_file_aio_write
Message-ID: <20110107092136.GM8322@dastard>
References: <1294116518-14908-1-git-send-email-david@fromorbit.com>
	<1294116518-14908-6-git-send-email-david@fromorbit.com>
	<20110107085830.GC10829@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110107085830.GC10829@infradead.org>
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

On Fri, Jan 07, 2011 at 03:58:30AM -0500, Christoph Hellwig wrote:
> > +This also clearly indicates that XFS
> > + * does not fall back to buffered IO in the direct IO write path.
> 
> I don't think this comment belongs into the function header.  It's
> already present in the right place anyway, so it can just be removed.

OK.

> > +	xfs_buftarg_t		*target = XFS_IS_REALTIME_INODE(ip) ?
> > +					mp->m_rtdev_targp : mp->m_ddev_targp;
> 
> struct xfs_buftarg, please.

Was copy-n-paste. Will fix.

> > +	trace_xfs_file_direct_write(ip, count, iocb->ki_pos, 0);
> > +	ret = generic_file_direct_write(iocb, iovp,
> > +			&nr_segs, pos, &iocb->ki_pos, count, ocount);
> > +
> > +	/* No fallback to buffered IO on errors for XFS. */
> > +	return ret;
> 
> I'd add an
> 
> 	ASSERT(ret < 0 || ret == count);
> 
> here to make sure we don't get problems due to changes in the core
> direct I/O code.

Yup, good idea.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
