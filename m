Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1NFKYo0067441 for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 09:20:34 -0600
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DBACC156F513
	for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 07:23:16 -0800 (PST)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id 2KAUunZTlsHKxniJ for
	<xfs@oss.sgi.com>; Wed, 23 Feb 2011 07:23:16 -0800 (PST)
Date: Wed, 23 Feb 2011 16:23:16 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS corruption on 3ware RAID6-volume
Message-ID: <20110223162316.45a49880@harpe.intellique.com>
In-Reply-To: <AANLkTinsfwr5E7KkffwWOweWJLCmaLnLdtYA4g_m--b0@mail.gmail.com>
References: <AANLkTinWByYooMnPL7BryPowDexBeiHJdh3aVh+fdm-a@mail.gmail.com>
	<20110223154651.54f0a8dc@harpe.intellique.com>
	<AANLkTinsfwr5E7KkffwWOweWJLCmaLnLdtYA4g_m--b0@mail.gmail.com>
Mime-Version: 1.0
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
To: Erik Gulliksson <erik@gulliksson.org>
Cc: xfs@oss.sgi.com

Le Wed, 23 Feb 2011 16:01:09 +0100
Erik Gulliksson <erik@gulliksson.org> =E9crivait:

> Hi Emmanuel,
> =

> Thanks for your prompt reply.
> =

> On Wed, Feb 23, 2011 at 3:46 PM, Emmanuel Florac
> <eflorac@intellique.com> wrote:
> >
> > What firmware version are you using?
> >
> > ( tw_cli /cX show firmware )
> =

> # tw_cli /c0 show firmware
> /c0 Firmware Version =3D FE9X 4.10.00.007
> =


OK so this is the latest, or close.

> =

> >
> > Augh. That sounds pretty bad. What does " tw_cli /cX/uY show all"
> > look like?
> =

> Yes, it is bad - a decision has been made to replace these disks with
> "enterprise"-versions (without TLER/ERC problems etc).

Typical error, alas. Save a couple hundred euros with cheap drives, to
store terabytes of data worth a lot.

> Tw_cli produces
> this output for the volume:
> =

> # tw_cli /c0/u0 show all
> /c0/u0 status =3D OK
> /c0/u0 is not rebuilding, its current state is OK
> /c0/u0 is not verifying, its current state is OK
> /c0/u0 is initialized.
> /c0/u0 Write Cache =3D on
> /c0/u0 Read Cache =3D Intelligent
> /c0/u0 volume(s) =3D 1
> /c0/u0 name =3D xxx
> /c0/u0 serial number =3D yyy
> /c0/u0 Ignore ECC policy =3D off
> /c0/u0 Auto Verify Policy =3D off
> /c0/u0 Storsave Policy =3D protection
> /c0/u0 Command Queuing Policy =3D on
> /c0/u0 Rapid RAID Recovery setting =3D all
> /c0/u0 Parity Number =3D 2
> =

> Unit     UnitType  Status         %RCmpl  %V/I/M  Port  Stripe
> Size(GB)
> ------------------------------------------------------------------------
> u0       RAID-6    OK             -       -       -     256K
> 12572.8 =


So the RAID array looks OK, the RAID controller doesn't report any
particular problem. You said it was reported as 0 K. Where did you see
0 K reported?

What gives "dmesg | grep 3w-9xxx" ? and "tw_cli alarms" ? Was the
filesystem under heavy write when the problem occured ?

I'd start with launching a RAID verify, to detect and correct possible
on-disk coherency problems (it can't hurt anyway):

tw_cli /c0/u0 start verify

Then "tail -f /var/log/messages | grep 3w-9xxx" ...

I suppose that there are no problems to be discovered. Most probably
IOs to the array were lost because of the bus reset.

-- =

------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
