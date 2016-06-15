Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D5EA87CA0
	for <xfs@oss.sgi.com>; Wed, 15 Jun 2016 02:14:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A6DD5304032
	for <xfs@oss.sgi.com>; Wed, 15 Jun 2016 00:14:47 -0700 (PDT)
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60]) by cuda.sgi.com
	with ESMTP id aes6DpLmkVTSlz4k for <xfs@oss.sgi.com>;
	Wed, 15 Jun 2016 00:14:44 -0700 (PDT)
Date: Wed, 15 Jun 2016 09:14:38 +0200
From: Willy Tarreau <w@1wt.eu>
Subject: Re: Something badly broken with the latest XFS changeset in all
	stable kernels?
Message-ID: <20160615071438.GA5294@1wt.eu>
References: <75808782-835f-4bc9-5243-b25cab00d6f3@whissi.de>
	<20160615000241.GC26977@dastard> <20160615013056.GA23074@kroah.com>
	<20160615052831.GA3452@1wt.eu> <20160615065121.GE26977@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160615065121.GE26977@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Greg KH <greg@kroah.com>, xfs@oss.sgi.com, spender@grsecurity.net, stable@vger.kernel.org, "Thomas D." <whissi@whissi.de>

On Wed, Jun 15, 2016 at 04:51:21PM +1000, Dave Chinner wrote:
> > Overall the regression lived only 8 days in a single branch, I
> > guess it shows that our process works rather well and limits the exposure
> > to regressions.
> 
> That it got as far as release and it took so long to get to the
> upstream maintainers shows the process could do with being improved.

Yep but users relying on oldest LTS usually run on servers that cannot
reboot without prior planning, so in practice we know that users tend
to be late by 1 week or more and often one or two versions. I'm pretty
sure this is the reason why a single user reported the issue. I'm not
saying this to dismiss the importance of a regression, just the fact
that the zero-risk never exists and that if an issue can only be
discovered in field (since the commit was backported according to the
tags and that the need to adapt it was not detected during the review
process), it will need one first victim to save all other users. In the
end the quick enough report ensured that most 3.14 users will not have
the time to upgrade to the broken version and 3.10/3.12 users will not
even have the opportunity to see the issue at all. That's what I'm
saying is not that bad.

We could imagine some automated tests depending on the affected files
and/or subsystems but it's not even certain that an automated test
would have detected this one :-/  We need to thank the initial reporter
here, and to encourage Brad to pass the information back ASAP next time
this happens via his channel.

Willy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
