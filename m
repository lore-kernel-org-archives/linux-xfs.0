Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 449C77F3F
	for <xfs@oss.sgi.com>; Sun, 20 Dec 2015 17:48:37 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 316FE8F8033
	for <xfs@oss.sgi.com>; Sun, 20 Dec 2015 15:48:37 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	j2fHavVPaOjD1oTh for <xfs@oss.sgi.com>;
	Sun, 20 Dec 2015 15:48:34 -0800 (PST)
Date: Mon, 21 Dec 2015 10:48:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 1/4] xfsprogs: xfs_io: fix a memory leak in imap_f
Message-ID: <20151220234830.GV26718@dastard>
References: <1449832143-26356-1-git-send-email-t.vivek@samsung.com>
	<1449832143-26356-2-git-send-email-t.vivek@samsung.com>
	<20151220153357.GC20135@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151220153357.GC20135@infradead.org>
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
Cc: a.sahrawat@samsung.com, xfs@oss.sgi.com, Vivek Trivedi <t.vivek@samsung.com>, pankaj.m@samsung.com

On Sun, Dec 20, 2015 at 07:33:57AM -0800, Christoph Hellwig wrote:
> > @@ -39,6 +39,8 @@ imap_f(int argc, char **argv)
> > -		if (count == 0)
> > +		if (count == 0) {
> > +			free(t);
> >  			return 0;
> > +		}
> 
> please use a goto out_free; here
> 
> >
> >  		for (i = 0; i < count; i++) {
> >  			printf(_("ino %10llu count %2d mask %016llx\n"),
> >  				(unsigned long long)t[i].xi_startino,
> > @@ -55,6 +59,7 @@ imap_f(int argc, char **argv)
> >  				(unsigned long long)t[i].xi_allocmask);
> >  		}
> >  	}
> > +	free(t);
> >  	perror("xfsctl(XFS_IOC_FSINUMBERS)");
> >  	exitcode = 1;
> >  	return 0;
> 
> and place the free just before the return here so that we have a single
> uwinding exit.

<sigh>

I'll just make the change locally, given I *was* only 15 minutes
away from pushing this into the public repository.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
