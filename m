Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 23 Sep 2007 02:54:29 -0700 (PDT)
Received: from stlx01.stz-softwaretechnik.com (stz-softwaretechnik.de [217.160.223.211])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8N9sNQ3003526
	for <linux-xfs@oss.sgi.com>; Sun, 23 Sep 2007 02:54:26 -0700
Received: from rg by stlx01.stz-softwaretechnik.com with local (Exim 3.36 #1 (Debian))
	id 1IZNvP-0001e5-00
	for <linux-xfs@oss.sgi.com>; Sun, 23 Sep 2007 11:38:51 +0200
Date: Sun, 23 Sep 2007 11:38:41 +0200
From: Ralf Gross <Ralf-Lists@ralfgross.de>
Subject: mkfs options for a 16x hw raid5 and xfs (mostly large files)
Message-ID: <20070923093841.GH19983@p15145560.pureserver.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Hi,

we have a new large raid array, the shelf has 48 disks, the max.
amount of disks in a single raid 5 set is 16. There will be one global
spare disk, thus we have two raid 5 with 15 data disks and one with 14
data disk.

The data on these raid sets will be video data + some meta data.
Typically each set of data consist of a 2 GB + 500 MB + 100 MB + 20 KB
+2 KB file. There will be some dozen of these sets in a single
directory - but not many hundred or thousend.

Often the data will be transfernd from the windows clients to the
server in some parallel copy jobs at night (eg. 5-10, for each new
data directory). The clients will access the data later (mostly) read
only, the data will not be changed after it was stored on the file
server. Each client then needs a data stream of about 17 MB/s (max. 5
clients are expected to acces the data in parallel). I expect the fs,
each will have a size of 10-11 TB, to be filled > 90%. I know this
is not ideal, but we need every GB we can get.  

I already played with different mkfs.xfs options (sw, su) but didn't
see much of a difference.

The volume sets of the hw raid have the following parameters:

11,xx TB (15 data disks):
Chunk Size : 64 KB
(values of 64/128/256 KB are possible, I'll try 256 KB next week)
Stripe Size : 960 KB (15 x 64 KM)

or 10,xx TB (14 data disks):

Chunk Size :  64 KB
Stripe Size : 896 KB (14 x 64 KB)

The created logical volumes have a block size of 512 bytes (the only
possible value).

Any ideas what options I should use for mkfs.xfs? At the moment I get
about 150 MB/s in seq. writing (tiobench) and 160 MB/s in seq.
reading. This is ok, but I'm curious what I could get with tuned xfs
parameters. The system is running debian etch (amd64) with 16 GB of
RAM. The raid array is connect to the server by fibre channel.

Ralf
