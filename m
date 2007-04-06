Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 06 Apr 2007 11:57:38 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk [82.69.39.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l36IvRfB017453
	for <linux-xfs@OSS.SGI.com>; Fri, 6 Apr 2007 11:57:29 -0700
Received: from from [127.0.0.1] (helo=base.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.62 #1)
	id 1HZtVR-0004j5-QX
	for <linux-xfs@OSS.SGI.com>; Fri, 06 Apr 2007 19:49:54 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17942.38470.367699.402354@base.ty.sabi.co.UK>
Date: Fri, 6 Apr 2007 19:49:42 +0100
Subject: Re: XFS Resiliency to the disk errors.
In-Reply-To: <A63C579E7F04E74588517328EF5A385E02076A9A@ILEX5.IL.NDS.COM>
References: <A63C579E7F04E74588517328EF5A385E02076A9A@ILEX5.IL.NDS.COM>
From: pg_xfs@xfs.for.sabi.co.UK (Peter Grandi)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linux XFS <linux-xfs@oss.sgi.com>

>>> On Thu, 5 Apr 2007 11:08:07 +0300, "Zak, Semion"
>>> <SZak@nds.com> said:

SZak> Hi, We are studying possibility to use XFS with cheap (not
SZak> too reliable) discs, so we have some questions:

Astute move :-). I hope that you are also thinking of using
16-wide RAID5 too :-).
 
SZak> What in XFS is done to survive the disk errors (bad
SZak> sectors)? [ ... ]

My impression is that the XFS design is really meant for highly
scalable performance on enterprise level hardware, where the
block device layer abstracts aways all drive error issues,
including having UPSes.

Sure you can use it otherwise, but it has a very different
optimal usage envelope from 'ext3' or ReiserFS/Reiser4 (which
have been designed with stronger resiliency and recoverability
features, as they are more oriented to desktop and cheap server
usage).

Anyhow, a highly reliable block device layer can surely be built
out of cheap disks, if one does it right, and people like EMC2
do it regularly with their midrange products.

I may be interesting for your to have a look at the disk
reliability statistics in some recent papers by some Google and
CMU researchers, discussed here:

http://swik.net/User:dolander/All+Things+Distributed/On+the+Reliability+of+Hard+Disks/
