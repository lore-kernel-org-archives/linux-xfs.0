Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 19 Apr 2008 20:21:53 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3K3LZYh009694
	for <xfs@oss.sgi.com>; Sat, 19 Apr 2008 20:21:36 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F0200107EF81
	for <xfs@oss.sgi.com>; Sat, 19 Apr 2008 20:22:15 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id vBccuK7J6YwNpHKF for <xfs@oss.sgi.com>; Sat, 19 Apr 2008 20:22:15 -0700 (PDT)
Message-ID: <480AB6E5.7030003@sandeen.net>
Date: Sat, 19 Apr 2008 22:22:13 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: review: add a splice command to xfs_io
References: <20060901165450.T3186664@wobbly.melbourne.sgi.com>
In-Reply-To: <20060901165450.T3186664@wobbly.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nscott@aconex.com>
Cc: dgc@melbourne.sgi.com, xfs@oss.sgi.com

Nathan Scott wrote:
> Yo Dave,
> 
> Here's some code which should help exercising the splice functionality
> from a QA test.  Needs a /usr/include/sys/splice.h (attached also, but
> glibc will get this at some point I guess).  No QA test yet though - I
> will hack something up there on Monday (its beer o'clock).
> 
> cheers.
> 
> 

hm, any reason this never went in?

It still applies, though "sys/splice.h" doesn't exist; you just need
fcntl.h (see the splice(2) man page...)

-Eric
