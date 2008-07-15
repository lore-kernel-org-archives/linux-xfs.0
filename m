Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 15 Jul 2008 08:26:37 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6FFQXbC018968
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2008 08:26:34 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AD01312E52E3
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2008 08:27:41 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id 4j4OssHfxlbOrVOR for <xfs@oss.sgi.com>; Tue, 15 Jul 2008 08:27:41 -0700 (PDT)
Message-ID: <487CC1EB.6030100@sandeen.net>
Date: Tue, 15 Jul 2008 10:27:39 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Is it possible the check an frozen XFS filesytem to avoid downtime
References: <200807141542.51613.ms@teamix.de> <487C1BAF.2030404@sgi.com> <200807150944.13277.ms@teamix.de>
In-Reply-To: <200807150944.13277.ms@teamix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Martin Steigerwald <ms@teamix.de>
Cc: Timothy Shimmin <tes@sgi.com>, xfs@oss.sgi.com

Martin Steigerwald wrote:

> Okay... we recommended the customer to do it the safe way unmounting the 
> filesystem completely. He did and the filesystem appear to be intact *phew*. 
> XFS appeared to detect the in memory corruption early enough.
> 
> Its a bit strange however, cause we now know that the server sports ECC RAM. 
> Well we will see what memtest86+ has to say about it.

in-memory corruption could mean, but certainly does not absolutely mean,
problematic memory.  It could be, and usually is, a plain ol' bug (in
xfs or elsewhere).

-Eric
