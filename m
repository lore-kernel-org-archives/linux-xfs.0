Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Sep 2007 05:35:24 -0700 (PDT)
Received: from stlx01.stz-softwaretechnik.com (stz-softwaretechnik.de [217.160.223.211])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8PCZIQ3012241
	for <linux-xfs@oss.sgi.com>; Tue, 25 Sep 2007 05:35:20 -0700
Received: from rg by stlx01.stz-softwaretechnik.com with local (Exim 3.36 #1 (Debian))
	id 1Ia9d9-0001gb-00
	for <linux-xfs@oss.sgi.com>; Tue, 25 Sep 2007 14:35:11 +0200
Date: Tue, 25 Sep 2007 14:35:01 +0200
From: Ralf Gross <Ralf-Lists@ralfgross.de>
Subject: Re: mkfs options for a 16x hw raid5 and xfs (mostly large files)
Message-ID: <20070925123501.GA20499@p15145560.pureserver.info>
References: <20070923093841.GH19983@p15145560.pureserver.info> <20070924173155.GI19983@p15145560.pureserver.info> <Pine.LNX.4.64.0709241400370.12025@p34.internal.lan> <20070924203958.GA4082@p15145560.pureserver.info> <Pine.LNX.4.64.0709241642110.19847@p34.internal.lan> <20070924213358.GB4082@p15145560.pureserver.info> <Pine.LNX.4.64.0709241736370.19847@p34.internal.lan> <20070924215223.GC4082@p15145560.pureserver.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070924215223.GC4082@p15145560.pureserver.info>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Ralf Gross schrieb:
> > What do you get when (reading) from the raw device?
> > 
> > dd if=/dev/sda bs=1M count=10240
> 
> The server has 16 GB RAM, so I tried it with 20 GB of data.
> 
> dd if=/dev/sdd of=/dev/null bs=1M count=20480
> 20480+0 Datensätze ein
> 20480+0 Datensätze aus
> 21474836480 Bytes (21 GB) kopiert, 95,3738 Sekunden, 225 MB/s
> 
> and a second try:
> 
> dd if=/dev/sdd of=/dev/null bs=1M count=20480
> 20480+0 Datensätze ein
> 20480+0 Datensätze aus
> 21474836480 Bytes (21 GB) kopiert, 123,78 Sekunden, 173 MB/s
> 
> I'm taoo tired to interprete these numbers at the moment, I'll do some
> more testing tomorrow.

There is a second RAID device attached to the server (24x RAID5). The
numbers I get from this device are a bit worse than the 16x RAID 5
numbers (150MB/s read with dd).

I'm really wondering how people can achieve transfer rates of
400MB/s and more. I know that I'm limited by the FC controller, but
I don't even get >200MB/s.

Ralf
