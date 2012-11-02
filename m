Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA2D593x130177 for <xfs@oss.sgi.com>; Fri, 2 Nov 2012 08:05:09 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	RK218JF9Oiwo00bQ (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 02 Nov 2012 06:07:01 -0700 (PDT)
Date: Fri, 2 Nov 2012 09:07:00 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/6] xfs: fix reading of wrapped log data
Message-ID: <20121102130700.GE12578@infradead.org>
References: <1351816724-3000-1-git-send-email-david@fromorbit.com>
	<1351816724-3000-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1351816724-3000-7-git-send-email-david@fromorbit.com>
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

On Fri, Nov 02, 2012 at 11:38:44AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Commit 4439647 ("xfs: reset buffer pointers before freeing them") in
> 3.0-rc1 introduced a regression when recovering log buffers that
> wrapped around the end of log. The second part of the log buffer at
> the start of the physical log was being read into the header buffer
> rather than the data buffer, and hence recovery was seeing garbage
> in the data buffer when it got to the region of the log buffer that
> was incorrectly read.

I think you mentioned earlier you found a reproducer for this, any
chance it could be added to xfstests?

>  				error = xlog_bread_offset(log, 0,
> -						bblks - split_bblks, hbp,
> +						bblks - split_bblks, dbp,

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
