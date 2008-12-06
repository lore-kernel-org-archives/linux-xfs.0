Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB6NRkgx019682 for <xfs@oss.sgi.com>; Sat, 6 Dec 2008 17:27:47 -0600
Received: from hobbit.corpit.ru (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8B9F016CB3E5
	for <xfs@oss.sgi.com>; Sat,  6 Dec 2008 15:27:43 -0800 (PST)
Received: from hobbit.corpit.ru (hobbit.corpit.ru [81.13.33.150]) by
	cuda.sgi.com with ESMTP id ASxFKEmp376HrVTX for
	<xfs@oss.sgi.com>; Sat, 06 Dec 2008 15:27:43 -0800 (PST)
Message-ID: <493B0922.2080606@msgid.tls.msk.ru>
Date: Sun, 07 Dec 2008 02:22:10 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
MIME-Version: 1.0
Subject: Re: Have the velociraptors in a test system now, checkout the errors.
References: <alpine.DEB.1.10.0812060426280.3494@p34.internal.lan>
	<493A5E62.1020508@msgid.tls.msk.ru>
	<alpine.DEB.1.10.0812060709280.8516@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0812060709280.8516@p34.internal.lan>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, smartmontools-support@lists.sourceforge.net, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Justin Piszcz wrote:

[big skip..]
> Very interesting story there, what OS(') were you using at the time?
> Windows? Linux? UNIX?

It is linux.  Since 2.2 or 2.0, I don't remember for sure.
With software raid since the day one (was an external patch
in a few first years).

> As far the PSU, just btw/FYI, Velociraptors consume ~4-5 watts a piece,
> my entire system used ~100-120watts with all 12 velociraptors on a 650
> watt PSU (now moved into a test system).

Well.  Others already commented on this, -- different rail can draw
different max power.  But it's a bit more complex still.  Those 4..5
watts is a sustained power consumption, not peak.  When moving heads,
starting/stopping the motor etc, the drive briefly consumes much more
power.  From my choice of cheap PSUs, not all of them can do the work
even when theoretical load is below the capacity.  I.e., the voltage
becomes.. unstable (insufficient filtering/capacitors, bad output
cirquits, too thin wires etc yadda).  And some parts of the system
may "translate" those instabilities into ones and zeros..

It's more: when the drives are in some RAID configuration (esp. raid1
and the like), usually more than one drive works in parallel, at exactly
the same moment (think writes to a raid1).  So it is more possible to
have bad results in raid config than without...

But again: I'm not at all suggesting your problem is in PSU.  It
*might* be here, but I hope your PSU can do the work fine.  And
in my case there were other failures too, more "mysterious".

And by the way, some modern PSUs, especially more powerful ones,
has more than one separate rails for 12v and sometimes 5v.  I.e.
two or more independent (to some extent anyway) 12v circuits.
With obvious advantages.

/mjt

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
