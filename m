Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1NEwQ12066325 for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 08:58:26 -0600
Received: from mail-gy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F31AB12DA6AD
	for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 07:01:10 -0800 (PST)
Received: from mail-gy0-f181.google.com (mail-gy0-f181.google.com
	[209.85.160.181]) by cuda.sgi.com with ESMTP id
	r88NsLH9h5CTByyQ for <xfs@oss.sgi.com>;
	Wed, 23 Feb 2011 07:01:10 -0800 (PST)
Received: by gyd10 with SMTP id 10so1850436gyd.26
	for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 07:01:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110223154651.54f0a8dc@harpe.intellique.com>
References: <AANLkTinWByYooMnPL7BryPowDexBeiHJdh3aVh+fdm-a@mail.gmail.com>
	<20110223154651.54f0a8dc@harpe.intellique.com>
Date: Wed, 23 Feb 2011 16:01:09 +0100
Message-ID: <AANLkTinsfwr5E7KkffwWOweWJLCmaLnLdtYA4g_m--b0@mail.gmail.com>
Subject: Re: XFS corruption on 3ware RAID6-volume
From: Erik Gulliksson <erik@gulliksson.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

Hi Emmanuel,

Thanks for your prompt reply.

On Wed, Feb 23, 2011 at 3:46 PM, Emmanuel Florac <eflorac@intellique.com> wrote:
>
> What firmware version are you using?
>
> ( tw_cli /cX show firmware )

# tw_cli /c0 show firmware
/c0 Firmware Version = FE9X 4.10.00.007


>
> Augh. That sounds pretty bad. What does " tw_cli /cX/uY show all" look
> like?

Yes, it is bad - a decision has been made to replace these disks with
"enterprise"-versions (without TLER/ERC problems etc). Tw_cli produces
this output for the volume:

# tw_cli /c0/u0 show all
/c0/u0 status = OK
/c0/u0 is not rebuilding, its current state is OK
/c0/u0 is not verifying, its current state is OK
/c0/u0 is initialized.
/c0/u0 Write Cache = on
/c0/u0 Read Cache = Intelligent
/c0/u0 volume(s) = 1
/c0/u0 name = xxx
/c0/u0 serial number = yyy
/c0/u0 Ignore ECC policy = off
/c0/u0 Auto Verify Policy = off
/c0/u0 Storsave Policy = protection
/c0/u0 Command Queuing Policy = on
/c0/u0 Rapid RAID Recovery setting = all
/c0/u0 Parity Number = 2

Unit     UnitType  Status         %RCmpl  %V/I/M  Port  Stripe  Size(GB)
------------------------------------------------------------------------
u0       RAID-6    OK             -       -       -     256K    12572.8
u0-0     DISK      OK             -       -       p12   -       1396.97
u0-1     DISK      OK             -       -       p21   -       1396.97
u0-2     DISK      OK             -       -       p14   -       1396.97
u0-3     DISK      OK             -       -       p15   -       1396.97
u0-4     DISK      OK             -       -       p16   -       1396.97
u0-5     DISK      OK             -       -       p17   -       1396.97
u0-6     DISK      OK             -       -       p18   -       1396.97
u0-7     DISK      OK             -       -       p19   -       1396.97
u0-8     DISK      OK             -       -       p20   -       1396.97
u0-9     DISK      OK             -       -       p0    -       1396.97
u0-10    DISK      OK             -       -       p22   -       1396.97
u0/v0    Volume    -              -       -       -     -       12572.8

Best regards
Erik Gulliksson

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
