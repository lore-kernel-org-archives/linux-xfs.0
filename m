Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Apr 2008 21:10:57 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3P4AGQu027268
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2008 21:10:19 -0700
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 21177E424D
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2008 21:10:57 -0700 (PDT)
Received: from postoffice2.aconex.com (prod.aconex.com [203.89.192.138]) by cuda.sgi.com with ESMTP id 2Zp1okWTAxWxO6gy for <xfs@oss.sgi.com>; Thu, 24 Apr 2008 21:10:57 -0700 (PDT)
Message-ID: <34168.192.168.3.1.1209096655.squirrel@mail.aconex.com>
In-Reply-To: <200804250049.34740.arekm@maven.pl>
References: <200804250049.34740.arekm@maven.pl>
Date: Fri, 25 Apr 2008 14:10:55 +1000 (EST)
Subject: Re: xfs_quota report
From: nscott@aconex.com
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: xfs@oss.sgi.com

> Hello,
>
> xfs_quota -x -c "report" by default walks passwd and displays quota only
> for
> users found there.

Yep.  Its quite lame really (all quota implementations I'm aware of do this).

> I wonder if there is a better way to get information about uid/gids that
> have
> any files on xfs filesystem? So report command could be enhanced to
> display
> such "users", too.

There is a better way.  No code exists to do it, but its been a long-standing
RFE that a new quotactl command be implement to do this - it would be a
bit like the XFS bulkstat interface, but instead of passing out the-next-big-
bunch-of-inode-stat-data-in-bulk-from-some-arbitary-inode, it would
pass out the next-big-bunch-of-dquot-data-in-bulk-from-some-id.
The idea being you would call it iteratively from userspace starting from id
zero, until it tells you you've reached the end, and the kernel would pass
out all valid dquots.

> Right now the only option is to use report -L0 -Usome_very_high_number
> with a
> hope that the number will always be high enough.

Heh, yeah, thats pretty ordinary.  Your mission, should you choose to accept
it...

cheers.

--
Nathan
