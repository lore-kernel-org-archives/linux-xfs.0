Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Feb 2008 08:38:59 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m14GcqLa008533
	for <xfs@oss.sgi.com>; Mon, 4 Feb 2008 08:38:54 -0800
Received: from hobbit.corpit.ru (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0836359AA58
	for <xfs@oss.sgi.com>; Mon,  4 Feb 2008 08:39:14 -0800 (PST)
Received: from hobbit.corpit.ru (hobbit.corpit.ru [81.13.94.6]) by cuda.sgi.com with ESMTP id Gbjdztgjb76NNLL7 for <xfs@oss.sgi.com>; Mon, 04 Feb 2008 08:39:14 -0800 (PST)
Message-ID: <47A73F90.3020307@msgid.tls.msk.ru>
Date: Mon, 04 Feb 2008 19:38:40 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
MIME-Version: 1.0
Subject: Re: RAID needs more to survive a power hit, different /boot layout
 for example (was Re: draft howto on making raids for surviving a disk crash)
References: <47A612BE.5050707@pobox.com> <47A623EE.4050305@msgid.tls.msk.ru> <47A62A17.70101@pobox.com> <47A6DA81.3030008@msgid.tls.msk.ru> <47A6EFCF.9080906@pobox.com> <47A7188A.4070005@msgid.tls.msk.ru> <alpine.DEB.1.00.0802040909010.2415@p34.internal.lan> <47A72061.3010800@sandeen.net>
In-Reply-To: <47A72061.3010800@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Moshe Yudkowsky <moshe@pobox.com>, linux-raid@vger.kernel.org, xfs@oss.sgi.com

Eric Sandeen wrote:
[]
> http://oss.sgi.com/projects/xfs/faq.html#nulls
> 
> and note that recent fixes have been made in this area (also noted in
> the faq)
> 
> Also - the above all assumes that when a drive says it's written/flushed
> data, that it truly has.  Modern write-caching drives can wreak havoc
> with any journaling filesystem, so that's one good reason for a UPS.  If

Unfortunately an UPS does not *really* help here.  Because unless
it has control program which properly shuts system down on the loss
of input power, and the battery really has the capacity to power the
system while it's shutting down (anyone tested this?  With new UPS?
and after an year of use, when the battery is not new?), -- unless
the UPS actually has the capacity to shutdown system, it will cut
the power at an unexpected time, while the disk(s) still has dirty
caches...

> the drive claims to have metadata safe on disk but actually does not,
> and you lose power, the data claimed safe will evaporate, there's not
> much the fs can do.  IO write barriers address this by forcing the drive
> to flush order-critical data before continuing; xfs has them on by
> default, although they are tested at mount time and if you have
> something in between xfs and the disks which does not support barriers
> (i.e. lvm...) then they are disabled again, with a notice in the logs.

Note also that with linux software raid barriers are NOT supported.

/mjt
