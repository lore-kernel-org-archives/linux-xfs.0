Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 467FD7F4E
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2014 23:55:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3362F30404E
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2014 21:55:15 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	FGZ1aFEBMRZMDc2W for <xfs@oss.sgi.com>;
	Mon, 25 Aug 2014 21:55:12 -0700 (PDT)
Date: Tue, 26 Aug 2014 14:55:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/4] xfs: refactor xlog_recover_process_data()
Message-ID: <20140826045509.GI20518@dastard>
References: <1409016101-9511-1-git-send-email-david@fromorbit.com>
	<1409016101-9511-2-git-send-email-david@fromorbit.com>
	<20140826040921.GA9591@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140826040921.GA9591@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Aug 25, 2014 at 09:09:21PM -0700, Christoph Hellwig wrote:
> > @@ -3556,14 +3622,10 @@ xlog_recover_process_data(
> >  	xfs_caddr_t		dp,
> >  	int			pass)
> >  {
> > +	struct xlog_op_header	*ohead;
> >  	xfs_caddr_t		lp;
> >  	int			num_logops;
> >  	int			error;
> >  
> >  	lp = dp + be32_to_cpu(rhead->h_len);
> >  	num_logops = be32_to_cpu(rhead->h_num_logops);
> > @@ -3573,69 +3635,24 @@ xlog_recover_process_data(
> >  		return -EIO;
> >  
> >  	while ((dp < lp) && num_logops) {
> > +		ASSERT(dp + sizeof(struct xlog_op_header) <= lp);
> > +
> > +		ohead = (struct xlog_op_header *)dp;
> > +		dp += sizeof(*ohead);
> 
> Using sizeof type and sizeof variable for the same thing right next
> to each other seems weird.  Also why duplicate the addition instead
> of moving it below the assignment:

Oh, I missed converting the one in the ASSERT.

> 		ohead = (struct xlog_op_header *)dp;
> 		dp += sizeof(*ohead);
> 
> 		ASSERT(dp <= lp);

Yup, that makes sense.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
