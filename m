Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:33156 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbfGYRCf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jul 2019 13:02:35 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6PGtgqe088184
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jul 2019 17:02:33 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2tx61c5a40-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jul 2019 17:02:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6PFwGI5078818
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jul 2019 17:02:32 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2tx60yedbm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jul 2019 17:02:32 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6PH2VJ9013592
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jul 2019 17:02:32 GMT
Date: Thu, 25 Jul 2019 10:02:30 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: fix stack contents leakage in the v1
 bulkstat/inumbers ioctls
Message-ID: <20190725170230.GD1561054@magnolia>
References: <20190724153545.GC1561054@magnolia>
 <20190725065216.GI3089@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190725065216.GI3089@kadam>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jul 25, 2019 at 09:52:17AM +0300, Dan Carpenter wrote:
> On Wed, Jul 24, 2019 at 08:35:45AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Explicitly initialize the onstack structures to zero so we don't leak
> > kernel memory into userspace when converting the in-core structure to
> > the v1 ioctl structure.
> > 
> > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_ioctl.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index f193f7b288ca..44e1a290f053 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -719,7 +719,7 @@ xfs_fsbulkstat_one_fmt(
> >  	struct xfs_ibulk		*breq,
> >  	const struct xfs_bulkstat	*bstat)
> >  {
> > -	struct xfs_bstat		bs1;
> > +	struct xfs_bstat		bs1 = { 0 };
> 
> This sort of initialization is potentially problematic because some
> versions of GCC will change it as a series of assignments (which doesn't
> clear the struct hole).  It's not clear to me the rules where GCC does
> this and also I wish there were an option to disable that feature.

And poor maintainers like me didn't even /know/ that.... ok, I'll go
with an explicit memset like Eric suggested in the patch review.

--D

> [ I am still out of office until the end of the month ]
> 
> regards,
> dan carpenter
> 
