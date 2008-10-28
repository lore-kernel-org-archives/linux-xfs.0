Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Oct 2008 01:36:17 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9S8a7eR006636
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 01:36:08 -0700
Received: from rproxy.teamix.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6A2551496475
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 01:36:06 -0700 (PDT)
Received: from rproxy.teamix.net (postman.teamix.net [194.150.191.120]) by cuda.sgi.com with ESMTP id 2m1BqAB5YZOXy6NE for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 01:36:06 -0700 (PDT)
From: Martin Steigerwald <ms@teamix.de>
Subject: Re: Is it possible the check an frozen XFS filesytem to avoid downtime
Date: Tue, 28 Oct 2008 09:36:04 +0100
References: <200807141542.51613.ms@teamix.de> <200810271757.09915.ms@teamix.de> <4905F727.8030005@sandeen.net>
In-Reply-To: <4905F727.8030005@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810280936.05409.ms@teamix.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Timothy Shimmin <tes@sgi.com>, xfs@oss.sgi.com

Am Monday 27 October 2008 18:15:19 schrieb Eric Sandeen:
> Martin Steigerwald wrote:
> > A colleague did a kernel update on the inactive backend 1 server from
> > 2.6.21 to 2.6.26 kernel from backports.org, tommorow backend 2 will
> > follow. Let's see whether that solves the issue.
> >
> > Anyway it seems to be a hard to trigger bug and before bugging you with
> > something in kernel 2.6.21, we at least update to the latest
> > backports.org kernel.
>
> Honestly, I'd try a 2.6.27 kernel if you can, a few more problems were
> fixed there.

Thanks for the hint. backports.org doesn't contain a 2.6.26 and AFAIK lenny 
will ship with 2.6.26 as well, thus I'd like to try that one before doing a 
backport of 2.6.27 from sid myself. Thus I hope the issue that is triggered 
on those servers is fixed with 2.6.26 or some prior kernel since 2.6.21 
already. If not, we will consider backporting 2.6.27.

At least on my notebook I didn't have any issues so far with any kernel since 
2.6.17.7. But even with TuxOnIce it doesn't have uptimes of 100 days or more, 
since I compile a new kernel for it once in a while.

-- 
Martin Steigerwald - team(ix) GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90
