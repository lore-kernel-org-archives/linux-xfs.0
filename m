Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DBF757F3F
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 18:13:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A83C2304053
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 16:13:45 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	5UfGEEHO0k8264xM for <xfs@oss.sgi.com>;
	Mon, 21 Apr 2014 16:13:43 -0700 (PDT)
Date: Tue, 22 Apr 2014 09:13:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/9] db: don't claim unchecked CRCs are correct
Message-ID: <20140421231308.GB18672@dastard>
References: <1397550301-31883-1-git-send-email-david@fromorbit.com>
	<1397550301-31883-2-git-send-email-david@fromorbit.com>
	<20140421070009.GC20384@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140421070009.GC20384@infradead.org>
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

On Mon, Apr 21, 2014 at 12:00:09AM -0700, Christoph Hellwig wrote:
> > +	switch (iocur_crc_valid()) {
> > +	case -1:
> > +		ok = "unchecked";
> > +		break;
> > +	case 0:
> > +		ok = "bad";
> > +		break;
> > +	case 1:
> > +		ok = "correct";
> > +		break;
> > +	default:
> > +		ok = "unknown state";
> > +		break;
> > +	}
> 
> We should have symbolic constants for these return values.  But then
> again iocur_crc_valid only has a single caller currently, is it even
> worth the effort, or should we simply inline it?

If we grow another user, I'll add an enum for it...

> Otherwise looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
