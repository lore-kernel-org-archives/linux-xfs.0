Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A60A37F37
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 07:04:28 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 32777AC008
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 05:04:24 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 4O6NXSZmGmQAtbMF (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 13 Nov 2014 05:04:24 -0800 (PST)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sADD4MAW016525
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 08:04:22 -0500
Received: from hades.localdomain (ovpn-113-116.phx2.redhat.com [10.3.113.116])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with
	ESMTP id sADD4IP1001400
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 08:04:21 -0500
Date: Thu, 13 Nov 2014 11:04:18 -0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 2/2] Add support to RENAME_EXCHANGE flag V3
Message-ID: <20141113130405.GA24180@hades.localdomain>
References: <20141111192922.GC38867@bfoster.bfoster>
	<20141112173245.GA32185@hades.localdomain>
	<20141112220044.GB23575@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141112220044.GB23575@dastard>
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
To: xfs@oss.sgi.com


On Thu, Nov 13, 2014 at 09:00:44AM +1100, Dave Chinner wrote:
> On Wed, Nov 12, 2014 at 03:32:48PM -0200, Carlos Maiolino wrote:
> > > > +   if (new_parent) {
> > > > +           xfs_trans_ichgtime(tp, target_dp, XFS_ICHGTIME_MOD |
> > > > XFS_ICHGTIME_CHG);
> > >
> > > Long line.
> > >
> > I think there is no reason to break this line. We should avoid 80+ columns per
> > line, but it's not a must, break this line will hurt readability of the code in
> > exchange of just a few chars more than 80. I don't think it's worth.
> 
> You're not going to win that argument, Carlos: new code wraps at 80
> columns. This:
> 
> 	if (new_parent) {
> 		xfs_trans_ichgtime(tp, target_dp,
> 				   XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> 		.....
> 	}
> 
> Is no less readable on a wide terminal than a single line, and it
> doesn't end up a mess for people who use 80 column terminals for the
> code editing. Please fix it.
> 
> Cheers,
> 
> Dave.

Ok, I don't mind, just gave my point of view :) I'm going to change this in the
next version.

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
