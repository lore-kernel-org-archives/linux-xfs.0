Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Feb 2008 18:12:26 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m162CLp4012392
	for <xfs@oss.sgi.com>; Tue, 5 Feb 2008 18:12:23 -0800
Received: from hobbit.corpit.ru (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 53DD7D9F77F
	for <xfs@oss.sgi.com>; Tue,  5 Feb 2008 18:12:43 -0800 (PST)
Received: from hobbit.corpit.ru (hobbit.corpit.ru [81.13.94.6]) by cuda.sgi.com with ESMTP id hAPFNhEA0rny5gew for <xfs@oss.sgi.com>; Tue, 05 Feb 2008 18:12:43 -0800 (PST)
Message-ID: <47A91798.4090703@msgid.tls.msk.ru>
Date: Wed, 06 Feb 2008 05:12:40 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
MIME-Version: 1.0
Subject: Re: RAID needs more to survive a power hit, different /boot layout
 for example (was Re: draft howto on making raids for surviving a disk crash)
References: <47A612BE.5050707@pobox.com> <47A623EE.4050305@msgid.tls.msk.ru> <47A62A17.70101@pobox.com> <47A6DA81.3030008@msgid.tls.msk.ru> <47A6EFCF.9080906@pobox.com> <47A7188A.4070005@msgid.tls.msk.ru> <alpine.DEB.1.00.0802040909010.2415@p34.internal.lan> <47A72061.3010800@sandeen.net> <47A73F90.3020307@msgid.tls.msk.ru> <47A9098F.4020801@tlinx.org>
In-Reply-To: <47A9098F.4020801@tlinx.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linda Walsh <xfs@tlinx.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, Justin Piszcz <jpiszcz@lucidpixels.com>, Moshe Yudkowsky <moshe@pobox.com>, linux-raid@vger.kernel.org, xfs@oss.sgi.com

Linda Walsh wrote:
> 
> Michael Tokarev wrote:
>> Unfortunately an UPS does not *really* help here.  Because unless
>> it has control program which properly shuts system down on the loss
>> of input power, and the battery really has the capacity to power the
>> system while it's shutting down (anyone tested this? 
> ----
>     Yes.  I must say, I am not connected or paid by APC.
> 
>> With new UPS?
>> and after an year of use, when the battery is not new?), -- unless
>> the UPS actually has the capacity to shutdown system, it will cut
>> the power at an unexpected time, while the disk(s) still has dirty
>> caches...
> --------
> If you have a "SmartUPS" by "APC", their is a freeware demon that monitors
[...]

Good stuff.  I knew at least SOME UPSes are good... ;)
Too bad I rarely see such stuff in use by regular
home users...
[]
>> Note also that with linux software raid barriers are NOT supported.
> ------
>     Are you sure about this?  When my system boots, I used to have
> 3 new IDE's, and one older one.  XFS checked each drive for barriers
> and turned off barriers for a disk that didn't support it.  ... or
> are you referring specifically to linux-raid setups?

I'm referring especially to linux-raid setups (software raid).
md devices don't support barriers, because of a very simple
reasons: once more than one disk drive is involved, md layer
can't guarantee ordering ACROSS drives too.  The problem is
that in case of power loss during writes, when an array needs
recovery/resync (at least the parts which were being written,
if bitmaps are in use), md layer will choose arbitrary drive
as a "master" and will copy data to another drive (speaking
of simplest case of 2-drive raid1 array).  But the thing
is that one drive may have two last barriers written (I mean
the data that was "assotiated" with the barriers), and
another neither of the two - in two different places.  And
hence we may see quite.. some inconsistency here.

This is regardless of whether underlying component devices
supports barriers or not.

>     Would it be possible on boot to have xfs probe the Raid array,
> physically, to see if barriers are really supported (or not), and disable
> them if they are not (and optionally disabling write caching, but that's
> a major performance hit in my experience.

Xfs already probes the devices as you describe, exactly the
same way as you've seen with your ide disks, and disables
barriers.

The question and confusing was about what happens when the
barriers are disabled (provided, again, that we don't rely
on UPS and other external things).  As far as I understand,
when barriers are working properly, xfs should be safe wrt
power losses (still a bit unsure about this).  Now, when
barriers are turned off (for whatever reason), is it still
as safe?  I don't know.  Does it use regular cache flushes
in place of barriers in that case (which ARE supported by
md layer)?

Generally, it has been said numerous times that XFS is not
"powercut-friendly", and it has to be used when everything
is stable, including power.  Hence I'm afraid to deploy it
where I know the power is not stable (we've about 70 such
places here, with servers in each, where they don't always
replace UPS batteries in time - ext3fs never crashed so
far, while ext2 did).

Thanks.

/mjt
