Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p35J6rEC254478 for <xfs@oss.sgi.com>; Tue, 5 Apr 2011 14:06:55 -0500
Date: Tue, 5 Apr 2011 15:10:06 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix variable set but not used warnings
Message-ID: <20110405191006.GA7080@infradead.org>
References: <20110404125544.GA726@infradead.org>
	<1301941280.2630.61.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1301941280.2630.61.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Apr 04, 2011 at 01:21:20PM -0500, Alex Elder wrote:
> >  	__int64_t	sbflags;
> >  
> >  	flags &= (XFS_ALL_QUOTA_ACCT | XFS_ALL_QUOTA_ENFD);
> >  	/*
> >  	 * Switching on quota accounting must be done at mount time.
> >  	 */
> > -	accflags = flags & XFS_ALL_QUOTA_ACCT;
> >  	flags &= ~(XFS_ALL_QUOTA_ACCT);
> 
> Unrelated, but isn't the effect of this line plus the one a few
> lines up the same as this?
> 
> 	flags &= XFS_ALL_QUOTA_ENFD;

Yes, it is.  I have a patch in my queue to clean this and a few others
bits around it up, but unlike the warnings fixes it's really 2.6.40
material.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
