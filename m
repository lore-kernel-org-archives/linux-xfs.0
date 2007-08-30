Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 29 Aug 2007 23:41:34 -0700 (PDT)
Received: from h001.gghcwest.com (adsl-71-128-90-173.dsl.pltn13.pacbell.net [71.128.90.173])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7U6fT4p025083
	for <xfs@oss.sgi.com>; Wed, 29 Aug 2007 23:41:31 -0700
Subject: ZFS, XFS, and EXT4 compared
From: "Jeffrey W. Baker" <jwbaker@acm.org>
Content-Type: text/plain
Date: Wed, 29 Aug 2007 23:16:51 -0700
Message-Id: <1188454611.23311.13.camel@toonses.gghcwest.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: zfs-discuss@opensolaris.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org

I have a lot of people whispering "zfs" in my virtual ear these days,
and at the same time I have an irrational attachment to xfs based
entirely on its lack of the 32000 subdirectory limit.  I'm not afraid of
ext4's newness, since really a lot of that stuff has been in Lustre for
years.  So a-benchmarking I went.  Results at the bottom:

http://tastic.brillig.org/~jwb/zfs-xfs-ext4.html

Short version: ext4 is awesome.  zfs has absurdly fast metadata
operations but falls apart on sequential transfer.  xfs has great
sequential transfer but really bad metadata ops, like 3 minutes to tar
up the kernel.

It would be nice if mke2fs would copy xfs's code for optimal layout on a
software raid.  The mkfs defaults and the mdadm defaults interact badly.

Postmark is somewhat bogus benchmark with some obvious quantization
problems.

Regards,
jwb
