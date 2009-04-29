Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3TDCku2162963 for <xfs@oss.sgi.com>; Wed, 29 Apr 2009 08:12:46 -0500
Received: from v007470.home.net.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id A21C71CF7DF7
	for <xfs@oss.sgi.com>; Wed, 29 Apr 2009 06:12:45 -0700 (PDT)
Received: from v007470.home.net.pl (v007470.home.net.pl [212.85.125.104]) by
	cuda.sgi.com with SMTP id 4xpbSrPnCYTgzUCK for
	<xfs@oss.sgi.com>; Wed, 29 Apr 2009 06:12:45 -0700 (PDT)
From: Krzysztof =?utf-8?q?B=C5=82aszkowski?= <kb@sysmikro.com.pl>
Subject: Re: generating uevents by xfs
Date: Wed, 29 Apr 2009 15:12:33 +0200
References: <200904281818.32127.kb@sysmikro.com.pl>
	<87r5zbpqsh.fsf@basil.nowhere.org>
In-Reply-To: <87r5zbpqsh.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904291512.33875.kb@sysmikro.com.pl>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Andi Kleen <andi@firstfloor.org>
Cc: xfs@oss.sgi.com

On Wednesday 29 April 2009 14:50, Andi Kleen wrote:
> Krzysztof B=E2aszkowski <kb@sysmikro.com.pl> writes:
> > Hello,
> >
> > once upon i was asked to think about such facility for notifying
> > userspace when some mount point is nearly full at some level let's say
> > e.g. 90% (threshold should be configurable).
> >
> > here is a solution designed by me and i would like to see comments on
> > this idea and solution.
>
> It doesn't seem to be very useful to poll in kernel for this. When you're
> in kernel you could just hook into the respective functions that handle
> disk allocation directly.

i reckon yes and no both. "no" because i wanted a solution which will have =

almost no impact on performance. if the speed wasn't an important concern =

then why would one take care about per cpu counters like fdblocks ?


> Polling can be as well done in user space only, =

> so it doesn't make too much sense to put polling code into the kernel.

yes i think too, that's maybe a bit too huge thing looking at benefits it =

brings but consider bash instance consuming 1.5M (at least) and other thing=
s =

spawned periodically, =

do they have more sense ? i don't think so and this is the solution which =

voids all hassle with userspace polling because it uses unified notificatio=
n =

system and this can be good starting point for notification system for othe=
r =

purposes i haven't think of yet but maybe someone has a new idea regarding =

this.

are these reasons good to (complete and) merge this stuff ?

I found that the xfs-sysfs-2 requires small rework around event_alloc() and =

event_release() because of very rare (but possible) race with timer functio=
n =

which drops lock (i decided to drop lock because i think kobject_uevent may =

be synchronous in the case of deprecated /sbin/hotplug and i'm not sure als=
o =

how long it takes for udevd)

i think that there is no point to update patch as long as we will not sort =
out =

if the whole idea is really worth to implement.

Thanks for reply.

Krzysztof Blaszkowski

>
> -Andi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
