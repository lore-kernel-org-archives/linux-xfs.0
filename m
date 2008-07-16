Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 16 Jul 2008 00:53:01 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6G7qrFh012166
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2008 00:52:53 -0700
Received: from rproxy.teamix.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 08BF018DB303
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2008 00:53:58 -0700 (PDT)
Received: from rproxy.teamix.net (postman.teamix.net [194.150.191.120]) by cuda.sgi.com with ESMTP id yKp7LQsAbbZ4rtzj for <xfs@oss.sgi.com>; Wed, 16 Jul 2008 00:53:58 -0700 (PDT)
From: Martin Steigerwald <ms@teamix.de>
Subject: Re: Is it possible the check an frozen XFS filesytem to avoid downtime
Date: Wed, 16 Jul 2008 09:53:56 +0200
References: <200807141542.51613.ms@teamix.de> <200807150944.13277.ms@teamix.de> <487CC1EB.6030100@sandeen.net>
In-Reply-To: <487CC1EB.6030100@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807160953.56503.ms@teamix.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Timothy Shimmin <tes@sgi.com>, xfs@oss.sgi.com

Am Dienstag, 15. Juli 2008 17:27:39 schrieb Eric Sandeen:
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

Thanks. 

Yes, I thought about this, too. But then the machine ran over one year without 
any visible issues. And it happened only on one server, not on the other. It 
happened on the server that does NFS tough... could be an NFS related issue 
then. The other one does MySQL with the database stored on a XFS volume, too. 
But there haven't been any visible issues.

Well we will see whether it happens again on the server that has taken over 
and is now doing both MySQL and NFS. If it does, I think we will update to 
one of the lastest Debian Etch backport kernels (2.6.24 or even 2.6.25) on 
one of the servers and see whether that helps.

-- 
Martin Steigerwald - team(ix) GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90
