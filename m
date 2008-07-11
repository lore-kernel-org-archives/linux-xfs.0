Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 11 Jul 2008 12:01:18 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6BJ1C0T002541
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2008 12:01:13 -0700
Received: from Chamillionaire.breakpoint.cc (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 238D711E5F8F
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2008 12:02:18 -0700 (PDT)
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [85.10.199.196]) by cuda.sgi.com with ESMTP id ptaPOBNXL7a4M7UY for <xfs@oss.sgi.com>; Fri, 11 Jul 2008 12:02:18 -0700 (PDT)
Date: Fri, 11 Jul 2008 21:02:09 +0200
From: Sebastian Siewior <lkml@ml.breakpoint.cc>
Subject: Re: xfs bug in 2.6.26-rc9
Message-ID: <20080711190209.GA7401@Chamillionaire.breakpoint.cc>
References: <alpine.DEB.1.10.0807110939520.30192@uplift.swm.pp.se> <20080711084248.GU29319@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080711084248.GU29319@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

* Dave Chinner | 2008-07-11 18:42:49 [+1000]:

>Oh - you must be running a debug XFS.  CONFIG_XFS_DEBUG was only
>introduced in 2.6.26-rc1 and defaults to 'N', so you must have
>selected the non-default option when prompted. This will cause your
>machine to oops at the slightest inconsistency that is found,
>regardless of whether it is fatal or not. Like the help text says,
>don't set this unless you are an XFS developer....
Could you please add this to the Kconfig entry. Debug mode is usually
noisy, little slower and mostly usefull just to the developers but *I*
would not expect to BUG() in the non-fatal case.
Not sure but if this is just for hch and you than a define in xfs.h
might be safer :)

>Dave.
Sebastian
