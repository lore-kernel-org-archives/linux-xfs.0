Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 13 Feb 2007 04:36:28 -0800 (PST)
Received: from mail.edu.haifa.ac.il (mail.edu.haifa.ac.il [132.74.40.10])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l1DCaKm7025812
	for <linux-xfs@oss.sgi.com>; Tue, 13 Feb 2007 04:36:21 -0800
From: "Leon Kolchinsky" <leonk@construct.haifa.ac.il>
Subject: RE: mkfs and mount tips?
Date: Tue, 13 Feb 2007 14:38:18 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	charset="windows-1255"
In-Reply-To: <1171365268.20354.31.camel@venus.local.navi.pl>
Message-Id: <20070213124040.9987D1F909@mail.edu.haifa.ac.il>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'Olaf Fr?czyk' <olaf@cbk.poznan.pl>
Cc: 'Justin Piszcz' <jpiszcz@lucidpixels.com>, linux-xfs@oss.sgi.com

> (...)
> > > When I was trying out different optimizations (and what I currently
> use on
> > > a couple volumes is):
> > >
> > > logbufs=8,logbsize=262144,biosize=16,noatime,nodiratime,nobarrier
> > >
> >
> > I think that "nobarrier" option is bad, cause power failure would
> corrupt
> > your FS in this case.
> It depends on hardware. If you use SCSI with write cache turned off I
> see no reason to loss data. You might use RAID with write cache (battery
> powered) safely too.
> I'm not sure but even (S)ATA with write cache disabled should be fine.
> 

Thanks for the tips.

1) Is "–d unwritten=0" option is pretty safe?

2) What's the recommended value of "-d agcount=" for?:

10GB disk for web/mail/streaming server accordingly
50GB disk for web/mail/streaming server accordingly
300GB disk for web/mail/streaming server accordingly

Or how can I calculate these recommended values?

> Regards,
> 
> Olaf
> --
> Olaf Fr?czyk <olaf@cbk.poznan.pl>


Regards,
Leon Kolchinsky
