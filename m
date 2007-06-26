Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Jun 2007 10:38:29 -0700 (PDT)
Received: from stlx01.stz-softwaretechnik.com (stz-softwaretechnik.de [217.160.223.211])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5QHcLtL013607
	for <xfs@oss.sgi.com>; Tue, 26 Jun 2007 10:38:24 -0700
Received: from rg by stlx01.stz-softwaretechnik.com with local (Exim 3.36 #1 (Debian))
	id 1I3EfR-0004HN-00
	for <xfs@oss.sgi.com>; Tue, 26 Jun 2007 19:17:29 +0200
Date: Tue, 26 Jun 2007 19:17:19 +0200
From: Ralf Gross <Ralf-Lists@ralfgross.de>
Subject: reasonable xfs fs size for 30-100 TB?
Message-ID: <20070626171719.GD32546@p15145560.pureserver.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Hi,

we are about to buy some large (at least for us) RAID arrays
(Overland/Xyratex 48x S-SATA). We'll start with ~30 TB and end with
~100 TB. The data will mainly be video data, each file with a size of
2 GB + some meta data. The RAID will be attached by Fibre Channel to
an Debian Etch server with kernel 2.6.18-amd64 and 6 GB RAM (xfsprogs
2.8.11-1).

My main concern is the amount of RAM I need for a fsck of the xfs fs.
Last time I search for the xfs requirements, I found the rule of
thumb: 2 GB RAM for 1 TB of disk storage + some RAM per x inodes.

Last year I deployed one server with a 4 TB xfs fs which is running
absolutely stable since then.

I don't want to creat _one_ big xfs fs, but I also don't want to end
up with 20-30 fs each with 4 TB of size. The question is, what is a
reasonable fs size with 4-6 GB of RAM? Will it be sufficient to add 15
GB of swap for a 10 TB fs? This will slow things certainly down, but
will it work?

Only few clients will access the data on this server. There will be 3
streams of data with ~17MB/s which the server should be able to
provide over GbE. Performance is not the primary goal. There will also
be a backup to tape (ok, _many_ tapes...).

Any thoughts or hints?

Ralf
