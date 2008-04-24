Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Apr 2008 05:48:52 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3OCmWxe020677
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2008 05:48:34 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EB0A8E123B
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2008 05:49:13 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id mZ21GULk1BlVDW3x for <xfs@oss.sgi.com>; Thu, 24 Apr 2008 05:49:13 -0700 (PDT)
Message-ID: <481081CE.1080500@sandeen.net>
Date: Thu, 24 Apr 2008 07:49:18 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS drops create/delete files to 6.6% of EXT3 (software raid)
 and to 0.6% of EXT3 (3ware hardware raid)
References: <c33e4330804231848n72ce683cqd48a8d45937f302@mail.gmail.com>	 <4810062F.50100@sandeen.net> <20080424053358.GW103491721@sgi.com> <c33e4330804232323p1b6d5121oc56b0c43663a4e84@mail.gmail.com>
In-Reply-To: <c33e4330804232323p1b6d5121oc56b0c43663a4e84@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michael Darling <darlingm@gmail.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

Michael Darling wrote:
> Eric, for the numbers you provided, are you using a single drive,
> software raid, or hardware raid?  If a hardware raid, is it a 3ware card?

it's a simple partition on a sata drive.

> I hadn't seen the nobarrier mount option before.  Using that changes
> sequential creates from about 190/second to about 2500/second, and
> changes sequential deletes from about 170/second to about 3700/second.

I wasn't recommending, necessarily, that you use it, but was just
looking for bottlenecks...

> I don't yet have a BBU for the 3ware card, but would certainly get one
> if we go with the 3ware card before we start putting real data on the
> raid.  Am I right that with a BBU unit and a battery backup for the
> server as a whole, that nobarrier would be safe to use?
>  
> Not using nobarrier, but using logbsize 256k changes sequential creates
> from about 190/second to about 270/second.  So, it's an improvement, but
> no where near where a software raid performs (1600/second) or where the
> hardware raid performs with nobarrier.

Default mkfs & mount w/ 256k logbufs:

xfs,256k logbuf:	1353/s

> On Thu, Apr 24, 2008 at 1:33 AM, David Chinner <dgc@sgi.com
> <mailto:dgc@sgi.com>> wrote:
>     > So I played with this a little on 2.6.25, on plain partitions.
>     >
>     > I saw similar numbers; for example, sequential creates:
>     >
>     > ext3:         23698/s
>     > xfs:            319/s
>     > xfs,nobarrier:         4478/s
> 
>     And with logbsize=256k?
> 
>     Cheers,
> 
>     Dave.
