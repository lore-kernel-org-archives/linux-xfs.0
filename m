Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6K86KBb008815 for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 03:06:20 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1337945AB89
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 01:09:20 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id m19c4BSAgcuVF7dM for
	<xfs@oss.sgi.com>; Tue, 20 Jul 2010 01:09:20 -0700 (PDT)
Date: Tue, 20 Jul 2010 04:09:19 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/6] xfs: remove obsolete osyncisosync mount option
Message-ID: <20100720080919.GA15470@infradead.org>
References: <20100718203848.927859114@bombadil.infradead.org>
	<20100718203926.229290039@bombadil.infradead.org>
	<20100720073832.GH32635@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100720073832.GH32635@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Jul 20, 2010 at 05:38:32PM +1000, Dave Chinner wrote:
> >  	"XFS: ihashsize no longer used, option is deprecated.");
> >  		} else if (!strcmp(this_char, "osyncisdsync")) {
> > -			/* no-op, this is now the default */
> >  			cmn_err(CE_WARN,
> > -	"XFS: osyncisdsync is now the default, option is deprecated.");
> > +	"XFS: the osyncisdsync option is deprecated as has no effect.");
> > +		} else if (!strcmp(this_char, "osyncisosync")) {
> > +			cmn_err(CE_WARN,
> > +	"XFS: the osyncisosync option is deprecated as has no effect.");
> >  		} else if (!strcmp(this_char, "irixsgid")) {
> >  			cmn_err(CE_WARN,
> >  	"XFS: irixsgid is now a sysctl(2) variable, option is deprecated.");
> 
> Look better as:
> 
> 	"XFS: osyncisdsync has no effect, option is deprecated."
> 	"XFS: osyncisosync has no effect, option is deprecated."
> 
> so they are consistent with the other deprecated option output.
> I've made this change to the patch i have in my tree....

Sure, fine with me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
