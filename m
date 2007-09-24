Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Sep 2007 14:52:48 -0700 (PDT)
Received: from stlx01.stz-softwaretechnik.com (stz-softwaretechnik.de [217.160.223.211])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8OLqeQ3027191
	for <linux-xfs@oss.sgi.com>; Mon, 24 Sep 2007 14:52:43 -0700
Received: from rg by stlx01.stz-softwaretechnik.com with local (Exim 3.36 #1 (Debian))
	id 1IZvqz-0004Yy-00
	for <linux-xfs@oss.sgi.com>; Mon, 24 Sep 2007 23:52:33 +0200
Date: Mon, 24 Sep 2007 23:52:23 +0200
From: Ralf Gross <Ralf-Lists@ralfgross.de>
Subject: Re: mkfs options for a 16x hw raid5 and xfs (mostly large files)
Message-ID: <20070924215223.GC4082@p15145560.pureserver.info>
References: <20070923093841.GH19983@p15145560.pureserver.info> <20070924173155.GI19983@p15145560.pureserver.info> <Pine.LNX.4.64.0709241400370.12025@p34.internal.lan> <20070924203958.GA4082@p15145560.pureserver.info> <Pine.LNX.4.64.0709241642110.19847@p34.internal.lan> <20070924213358.GB4082@p15145560.pureserver.info> <Pine.LNX.4.64.0709241736370.19847@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0709241736370.19847@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Justin Piszcz schrieb:
> >>I find that to be the case with SW RAID (defaults are best)
> >>
> >>Although with 16 drives(?) that is awfully slow.
> >>
> >>I have 6 SATA's I get 160-180 MiB/s raid5 and 250-280 MiB/s raid 0 (sw
> >>raid).
> >>
> >>With 10 raptors I get ~450 MiB/s write and ~550-600 MiB/s read, again
> >>XFS+SW raid.
> >
> >Hm, with the different HW-RAIDs I've used so far (easyRAID,
> >Infortrend, internal Areca controller), I always got 160-200 MiB/s
> >read/write with 7-15 disks. That's one reason why I asked if there are
> >some xfs options I could use for better performance. But I guess fs
> >options won't boost performance that much.
> 
> What do you get when (reading) from the raw device?
> 
> dd if=/dev/sda bs=1M count=10240

The server has 16 GB RAM, so I tried it with 20 GB of data.

dd if=/dev/sdd of=/dev/null bs=1M count=20480
20480+0 Datensätze ein
20480+0 Datensätze aus
21474836480 Bytes (21 GB) kopiert, 95,3738 Sekunden, 225 MB/s

and a second try:

dd if=/dev/sdd of=/dev/null bs=1M count=20480
20480+0 Datensätze ein
20480+0 Datensätze aus
21474836480 Bytes (21 GB) kopiert, 123,78 Sekunden, 173 MB/s

I'm taoo tired to interprete these numbers at the moment, I'll do some
more testing tomorrow.

Good night,
Ralf
