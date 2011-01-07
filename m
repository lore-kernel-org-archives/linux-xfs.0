Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0795O4o020095 for <xfs@oss.sgi.com>; Fri, 7 Jan 2011 03:05:24 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1618C4F6687
	for <xfs@oss.sgi.com>; Fri,  7 Jan 2011 01:07:32 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	Rb7CoYyn02gr1Ytq for <xfs@oss.sgi.com>;
	Fri, 07 Jan 2011 01:07:32 -0800 (PST)
Date: Fri, 7 Jan 2011 20:07:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/8] xfs: ensure sync write errors are returned
Message-ID: <20110107090729.GK8322@dastard>
References: <1294116518-14908-1-git-send-email-david@fromorbit.com>
	<1294116518-14908-2-git-send-email-david@fromorbit.com>
	<20110107084518.GA10829@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110107084518.GA10829@infradead.org>
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

On Fri, Jan 07, 2011 at 03:45:18AM -0500, Christoph Hellwig wrote:
> > +		if (ret == -ENOSPC && !enospc) {
> > +			ssize_t ret2 = xfs_flush_pages(ip, 0, -1, 0, FI_NONE);
> > +			if (ret2) {
> > +				ret = ret2;
> >  				goto out_unlock_internal;
> > +			}
> >  			enospc = 1;
> >  			goto write_retry;
> >  		}
> 
> I don't think there is any reason for the ret2 variale here.  If it's
> non-zero we assign it to ret, and if it's zero we overwrite it again
> after jumping to the write_retry label.

True, I'll fix it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
