Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 23F7A7F3F
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 16:00:59 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AD812AC00F
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 14:00:58 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	xyd6Bsq4iikeXTeq for <xfs@oss.sgi.com>;
	Wed, 12 Nov 2014 14:00:56 -0800 (PST)
Date: Thu, 13 Nov 2014 09:00:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] Add support to RENAME_EXCHANGE flag V3
Message-ID: <20141112220044.GB23575@dastard>
References: <20141111192922.GC38867@bfoster.bfoster>
	<20141112173245.GA32185@hades.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141112173245.GA32185@hades.localdomain>
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
To: xfs@oss.sgi.com, Brian Foster <bfoster@redhat.com>

On Wed, Nov 12, 2014 at 03:32:48PM -0200, Carlos Maiolino wrote:
> > > +   if (new_parent) {
> > > +           xfs_trans_ichgtime(tp, target_dp, XFS_ICHGTIME_MOD |
> > > XFS_ICHGTIME_CHG);
> >
> > Long line.
> >
> I think there is no reason to break this line. We should avoid 80+ columns per
> line, but it's not a must, break this line will hurt readability of the code in
> exchange of just a few chars more than 80. I don't think it's worth.

You're not going to win that argument, Carlos: new code wraps at 80
columns. This:

	if (new_parent) {
		xfs_trans_ichgtime(tp, target_dp,
				   XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
		.....
	}

Is no less readable on a wide terminal than a single line, and it
doesn't end up a mess for people who use 80 column terminals for the
code editing. Please fix it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
