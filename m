Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 09:57:21 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9RGvEZB016774
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 09:57:15 -0700
Received: from rproxy.teamix.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A7C31AE2AFE
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 09:57:12 -0700 (PDT)
Received: from rproxy.teamix.net (postman.teamix.net [194.150.191.120]) by cuda.sgi.com with ESMTP id n6mOazH144DechcV for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 09:57:12 -0700 (PDT)
From: Martin Steigerwald <ms@teamix.de>
Subject: Re: Is it possible the check an frozen XFS filesytem to avoid downtime
Date: Mon, 27 Oct 2008 17:57:09 +0100
References: <200807141542.51613.ms@teamix.de> <200807150944.13277.ms@teamix.de> <487CC1EB.6030100@sandeen.net>
In-Reply-To: <487CC1EB.6030100@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810271757.09915.ms@teamix.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Timothy Shimmin <tes@sgi.com>, xfs@oss.sgi.com

Am Dienstag, 15. Juli 2008 schrieb Eric Sandeen:
> Martin Steigerwald wrote:
> > Okay... we recommended the customer to do it the safe way unmounting the
> > filesystem completely. He did and the filesystem appear to be intact
> > *phew*. XFS appeared to detect the in memory corruption early enough.
> >
> > Its a bit strange however, cause we now know that the server sports ECC
> > RAM. Well we will see what memtest86+ has to say about it.
>
> in-memory corruption could mean, but certainly does not absolutely mean,
> problematic memory.  It could be, and usually is, a plain ol' bug (in
> xfs or elsewhere).

Ok, just as a follow up:

Now we got similar XFS errors on the second backend server, this time on a 
local hardware RAID1 while on the first backend server it was on logical 
volumes on a soft RAID spread over two dislocated external hardware RAID 
boxes.

So this appears to be an XFS bug to me. Maybe when running for long time it 
corrupts its in-memory structures. Fortunately we did not see errors in 
on-disk structures.

A colleague did a kernel update on the inactive backend 1 server from 2.6.21 
to 2.6.26 kernel from backports.org, tommorow backend 2 will follow. Let's 
see whether that solves the issue.

Anyway it seems to be a hard to trigger bug and before bugging you with 
something in kernel 2.6.21, we at least update to the latest backports.org 
kernel.

-- 
Martin Steigerwald - team(ix) GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90
