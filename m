Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2GAkWsI085645 for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 05:46:50 -0500
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8F3731C46032
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 03:46:10 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	23CSu3qnjVYvJ56F for <xfs@oss.sgi.com>;
	Mon, 16 Mar 2009 03:46:10 -0700 (PDT)
Date: Mon, 16 Mar 2009 21:46:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/5] [XFS] Make inode flush at ENOSPC synchronous
Message-ID: <20090316104606.GI26138@disturbed>
References: <1237116707-25793-1-git-send-email-david@fromorbit.com>
	<1237116707-25793-3-git-send-email-david@fromorbit.com>
	<20090316091235.GB2636@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090316091235.GB2636@infradead.org>
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
Cc: mpatocka@redhat.com, xfs@oss.sgi.com

On Mon, Mar 16, 2009 at 05:12:35AM -0400, Christoph Hellwig wrote:
> On Sun, Mar 15, 2009 at 10:31:44PM +1100, Dave Chinner wrote:
> >  	} else {
> > +		int enospc = 0;
> > +		ssize_t ret2 = 0;
> > +
> > +write_retry:
> >  		xfs_rw_enter_trace(XFS_WRITE_ENTER, xip, (void *)iovp, segs,
> >  				*offset, ioflags);
> > -		ret = generic_file_buffered_write(iocb, iovp, segs,
> > +		ret2 = generic_file_buffered_write(iocb, iovp, segs,
> >  				pos, offset, count, ret);
> > +		/*
> > +		 * if we just got an ENOSPC, flush the inode now we
> > +		 * aren't holding any page locks and retry *once*
> > +		 */
> > +		if (ret2 == -ENOSPC && !enospc) {
> > +			error = xfs_flush_pages(xip, 0, -1, 0, FI_NONE);
> > +			if (error)
> > +				goto out_unlock_internal;
> > +			enospc = 1;
> > +			goto write_retry;
> > +		}
> > +		ret = ret2;
> 
> Just use filemap_fdatawrite here directly..

OK. will fix.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
