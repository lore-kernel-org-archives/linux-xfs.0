Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Feb 2008 17:44:04 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m161hsE1010926
	for <xfs@oss.sgi.com>; Tue, 5 Feb 2008 17:43:57 -0800
Received: from ishtar.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BFE4FD9F488
	for <xfs@oss.sgi.com>; Tue,  5 Feb 2008 17:44:11 -0800 (PST)
Received: from ishtar.tlinx.org (ishtar.tlinx.org [64.81.245.74]) by cuda.sgi.com with ESMTP id GrCB02FSll45KvOM for <xfs@oss.sgi.com>; Tue, 05 Feb 2008 17:44:11 -0800 (PST)
Message-ID: <47A9098F.4020801@tlinx.org>
Date: Tue, 05 Feb 2008 17:12:47 -0800
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: RAID needs more to survive a power hit, different /boot layout
 for example (was Re: draft howto on making raids for surviving a disk crash)
References: <47A612BE.5050707@pobox.com> <47A623EE.4050305@msgid.tls.msk.ru> <47A62A17.70101@pobox.com> <47A6DA81.3030008@msgid.tls.msk.ru> <47A6EFCF.9080906@pobox.com> <47A7188A.4070005@msgid.tls.msk.ru> <alpine.DEB.1.00.0802040909010.2415@p34.internal.lan> <47A72061.3010800@sandeen.net> <47A73F90.3020307@msgid.tls.msk.ru>
In-Reply-To: <47A73F90.3020307@msgid.tls.msk.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Eric Sandeen <sandeen@sandeen.net>, Justin Piszcz <jpiszcz@lucidpixels.com>, Moshe Yudkowsky <moshe@pobox.com>, linux-raid@vger.kernel.org, xfs@oss.sgi.com


Michael Tokarev wrote:
> Unfortunately an UPS does not *really* help here.  Because unless
> it has control program which properly shuts system down on the loss
> of input power, and the battery really has the capacity to power the
> system while it's shutting down (anyone tested this? 
----
	Yes.  I must say, I am not connected or paid by APC.

> With new UPS?
> and after an year of use, when the battery is not new?), -- unless
> the UPS actually has the capacity to shutdown system, it will cut
> the power at an unexpected time, while the disk(s) still has dirty
> caches...
--------
If you have a "SmartUPS" by "APC", their is a freeware demon that monitors
it's status.  The UPS has USB and serial connections.
  It's included in some distributions (SuSE).  The config
file is pretty straight forward.

I recommend the "1000XL" (1000 peak Volt-Amp load -- usually at startup;
note, this is not the same as watts as some of us were taught in basic
electronics class since the unit isn't a simple resistor (like a light
bulb). over the 1500XL because with the 1000XL, you can buy several
"add-on batteries" that plug into the back.

One minor (but not fatal) design flaw: the add-on batteries give no indication
that they are "live" (I knocked a cord on one, and only got 7 minutes
of uptime before things shut-down instead of my expected 20.
I have 3-cells total (controller & 1 extra pack).  So why is my run time
so short?  I am being lazy in buying more extension packs.
The UPS is running 3 computers, the house-phone, (answering and wireless
handsets).  a digital clock, 1 LCD (usually off),  The real killer is a
new workstation with 2x2-Core-II chips and other comparable equipment.

The "1500XL" doesn't allow for adding more power packs.
The "2200XL" does allow extra packs but comes in a rack-mount format.

It's not just a battery backup -- it conditions the power -- to filter out
spikes and emit a pure sine wave.  It will kick in during over or under
voltage conditions (you can set the sensitivity).  Adjustable alarm
when on battery, setting of output volts (115, 230, 120, 240).  It
selftests at least every 2 weeks or shorter (to your fancy).

It also has a network feature (that I haven't gotten to work yet -- they just
changed the format), that allows other computers on the same net to also be
notified and take action.

You specify what scripts to run at what times (power off, power on, getting
critically low, etc).

Hasn't failed me 'yet' -- cept when a charger died and was replaced free of
cost (within warantee).  I have a separate setup another room for another
computer.

The upspowerd runs on linux or windows (under cygwin, I think).


You can specify when to shut down -- like "5 minutes of battery life left.

The controller unit has 1 battery.  But the add-ons have 2 batteries
each, so the first add-on adds 3x to the run-time.  When my system
did shut down "prematurely", it went through the full "halt" sequence,
which I'd presume flushes disk caches.

> 
>> the drive claims to have metadata safe on disk but actually does not,
>> and you lose power, the data claimed safe will evaporate, there's not
>> much the fs can do.  IO write barriers address this by forcing the drive
>> to flush order-critical data before continuing; xfs has them on by
>> default, although they are tested at mount time and if you have
>> something in between xfs and the disks which does not support barriers
>> (i.e. lvm...) then they are disabled again, with a notice in the logs.

> Note also that with linux software raid barriers are NOT supported.
------
	Are you sure about this?  When my system boots, I used to have
3 new IDE's, and one older one.  XFS checked each drive for barriers
and turned off barriers for a disk that didn't support it.  ... or
are you referring specifically to linux-raid setups?

	Would it be possible on boot to have xfs probe the Raid array,
physically, to see if barriers are really supported (or not), and disable
them if they are not (and optionally disabling write caching, but that's
a major performance hit in my experience.

Linda
