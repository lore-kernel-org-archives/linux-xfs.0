Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Feb 2008 06:26:03 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m14EPrWK030777
	for <xfs@oss.sgi.com>; Mon, 4 Feb 2008 06:25:54 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B5DD2D816A6
	for <xfs@oss.sgi.com>; Mon,  4 Feb 2008 06:26:12 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id to2W1dZ7BVrDaSZk for <xfs@oss.sgi.com>; Mon, 04 Feb 2008 06:26:12 -0800 (PST)
Message-ID: <47A72061.3010800@sandeen.net>
Date: Mon, 04 Feb 2008 08:25:37 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: RAID needs more to survive a power hit, different /boot layout
 for example (was Re: draft howto on making raids for surviving a disk crash)
References: <47A612BE.5050707@pobox.com> <47A623EE.4050305@msgid.tls.msk.ru> <47A62A17.70101@pobox.com> <47A6DA81.3030008@msgid.tls.msk.ru> <47A6EFCF.9080906@pobox.com> <47A7188A.4070005@msgid.tls.msk.ru> <alpine.DEB.1.00.0802040909010.2415@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.00.0802040909010.2415@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Moshe Yudkowsky <moshe@pobox.com>, linux-raid@vger.kernel.org, xfs@oss.sgi.com

Justin Piszcz wrote:

> Why avoid XFS entirely?
> 
> esandeen, any comments here?

Heh; well, it's the meme.

see:

http://oss.sgi.com/projects/xfs/faq.html#nulls

and note that recent fixes have been made in this area (also noted in
the faq)

Also - the above all assumes that when a drive says it's written/flushed
data, that it truly has.  Modern write-caching drives can wreak havoc
with any journaling filesystem, so that's one good reason for a UPS.  If
the drive claims to have metadata safe on disk but actually does not,
and you lose power, the data claimed safe will evaporate, there's not
much the fs can do.  IO write barriers address this by forcing the drive
to flush order-critical data before continuing; xfs has them on by
default, although they are tested at mount time and if you have
something in between xfs and the disks which does not support barriers
(i.e. lvm...) then they are disabled again, with a notice in the logs.

Note also that ext3 has the barrier option as well, but it is not
enabled by default due to performance concerns.  Barriers also affect
xfs performance, but enabling them in the non-battery-backed-write-cache
scenario is the right thing to do for filesystem integrity.

-Eric

> Justin.
> 
