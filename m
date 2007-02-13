Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 13 Feb 2007 04:49:30 -0800 (PST)
Received: from zeus.office.navi.pl (ip-83-238-212-180.netia.com.pl [83.238.212.180])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l1DCnLm7027729
	for <linux-xfs@oss.sgi.com>; Tue, 13 Feb 2007 04:49:23 -0800
Subject: RE: mkfs and mount tips?
From: Olaf =?iso-8859-2?Q?Fr=B1czyk?= <olaf@cbk.poznan.pl>
In-Reply-To: <20070213103533.C89F519311@mail.edu.haifa.ac.il>
References: <20070213103533.C89F519311@mail.edu.haifa.ac.il>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 13 Feb 2007 12:14:28 +0100
Message-Id: <1171365268.20354.31.camel@venus.local.navi.pl>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Leon Kolchinsky <leonk@construct.haifa.ac.il>
Cc: 'Justin Piszcz' <jpiszcz@lucidpixels.com>, linux-xfs@oss.sgi.com

On Tue, 2007-02-13 at 12:33 +0200, Leon Kolchinsky wrote:
> 
> > -----Original Message-----
> > From: Justin Piszcz [mailto:jpiszcz@lucidpixels.com]
> > Sent: Tuesday, February 13, 2007 11:30 AM
> > To: Leon Kolchinsky
> > Cc: linux-xfs@oss.sgi.com
> > Subject: Re: mkfs and mount tips?
(...)
> > When I was trying out different optimizations (and what I currently use on
> > a couple volumes is):
> > 
> > logbufs=8,logbsize=262144,biosize=16,noatime,nodiratime,nobarrier
> > 
> 
> I think that "nobarrier" option is bad, cause power failure would corrupt
> your FS in this case.
It depends on hardware. If you use SCSI with write cache turned off I
see no reason to loss data. You might use RAID with write cache (battery
powered) safely too.
I'm not sure but even (S)ATA with write cache disabled should be fine.

Regards,

Olaf
-- 
Olaf Frączyk <olaf@cbk.poznan.pl>
