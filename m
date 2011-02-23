Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1NFQV94067743 for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 09:26:32 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 535CD156F8FA
	for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 07:29:15 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id Clg6chSPtzTgMzZU for
	<xfs@oss.sgi.com>; Wed, 23 Feb 2011 07:29:15 -0800 (PST)
Date: Wed, 23 Feb 2011 10:29:15 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: XFS corruption on 3ware RAID6-volume
In-Reply-To: <AANLkTinsfwr5E7KkffwWOweWJLCmaLnLdtYA4g_m--b0@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1102231022470.15181@p34.internal.lan>
References: <AANLkTinWByYooMnPL7BryPowDexBeiHJdh3aVh+fdm-a@mail.gmail.com>
	<20110223154651.54f0a8dc@harpe.intellique.com>
	<AANLkTinsfwr5E7KkffwWOweWJLCmaLnLdtYA4g_m--b0@mail.gmail.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Erik Gulliksson <erik@gulliksson.org>
Cc: xfs@oss.sgi.com



On Wed, 23 Feb 2011, Erik Gulliksson wrote:

> Hi Emmanuel,
>
> Thanks for your prompt reply.
>
> On Wed, Feb 23, 2011 at 3:46 PM, Emmanuel Florac <eflorac@intellique.com> wrote:
>>
>> What firmware version are you using?
>>
>> ( tw_cli /cX show firmware )
>
> # tw_cli /c0 show firmware
> /c0 Firmware Version = FE9X 4.10.00.007
The latest is:

9.5.1-9650-Upgrade.zip
9.5.2-9650-Upgrade.zip
9.5.3-9650-Upgrade.zip
9650SE_9690SA_firmware_beta_fw4.10.00.016.zip
9650SE_9690SA_firmware_beta_fw_4.10.00.019.zip <- latest

>
>
>>
>> Augh. That sounds pretty bad. What does " tw_cli /cX/uY show all" look
>> like?
>
> Yes, it is bad - a decision has been made to replace these disks with
> "enterprise"-versions (without TLER/ERC problems etc). Tw_cli produces
> this output for the volume:
This would seem to be the problem, you should go with Hiatchi next time.
You can use regular non-enterprise drives (Hiatchi) and they just work.
Seagate is a question
Samsung is a question
WD needs TLER.

>
> # tw_cli /c0/u0 show all
> /c0/u0 status = OK
> /c0/u0 is not rebuilding, its current state is OK
> /c0/u0 is not verifying, its current state is OK
> /c0/u0 is initialized.
> /c0/u0 Write Cache = on
> /c0/u0 Read Cache = Intelligent
> /c0/u0 volume(s) = 1
> /c0/u0 name = xxx
> /c0/u0 serial number = yyy
> /c0/u0 Ignore ECC policy = off
> /c0/u0 Auto Verify Policy = off
> /c0/u0 Storsave Policy = protection
> /c0/u0 Command Queuing Policy = on
> /c0/u0 Rapid RAID Recovery setting = all
> /c0/u0 Parity Number = 2
>
> Unit     UnitType  Status         %RCmpl  %V/I/M  Port  Stripe  Size(GB)
> ------------------------------------------------------------------------
> u0       RAID-6    OK             -       -       -     256K    12572.8
> u0-0     DISK      OK             -       -       p12   -       1396.97
> u0-1     DISK      OK             -       -       p21   -       1396.97
> u0-2     DISK      OK             -       -       p14   -       1396.97
> u0-3     DISK      OK             -       -       p15   -       1396.97
> u0-4     DISK      OK             -       -       p16   -       1396.97
> u0-5     DISK      OK             -       -       p17   -       1396.97
> u0-6     DISK      OK             -       -       p18   -       1396.97
> u0-7     DISK      OK             -       -       p19   -       1396.97
> u0-8     DISK      OK             -       -       p20   -       1396.97
> u0-9     DISK      OK             -       -       p0    -       1396.97
> u0-10    DISK      OK             -       -       p22   -       1396.97
> u0/v0    Volume    -              -       -       -     -       12572.8

As far as the problem at hand, I do not know of a good way to fix it unless
you had ls -lRi /raid_array output so you could map the inodes to their
original locations.  Sorry don't have a better answer..

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
