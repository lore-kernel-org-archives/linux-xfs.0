Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Sep 2007 12:43:02 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8JJgtuw029040
	for <xfs@oss.sgi.com>; Wed, 19 Sep 2007 12:42:57 -0700
Message-ID: <46F17BBE.7060304@sandeen.net>
Date: Wed, 19 Sep 2007 14:42:54 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Cant find sunit and swidth on luks encrypted raid6 device
References: <728b8e3b0709191129j27b7c319h2efd51ffc9cb64f3@mail.gmail.com>
In-Reply-To: <728b8e3b0709191129j27b7c319h2efd51ffc9cb64f3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Jochen K." <jochen.f.k@googlemail.com>
Cc: xfs@oss.sgi.com

Jochen K. wrote:

> [output with encryption]
> 
> mkfs.xfs -f /dev/mapper/raid6
> 
> meta-data=/dev/mapper/raid6      isize=256    agcount=32, agsize=53412581
> blks
>          =                       sectsz=512   attr=0
> data     =                       bsize=4096   blocks=1709202592, imaxpct=25
>          =                       sunit=0      swidth=0 blks, unwritten=1
> naming   =version 2              bsize=4096
> log      =internal log           bsize=4096   blocks=32768, version=1
>          =                       sectsz=512   sunit=0 blks, lazy-count=0
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> b7f57ad0: Badness in key lookup (length)
> bp=(bno 13673620728, len 131072 bytes) key=(bno 13673620728, len 4096 bytes)

What generates the last two lines in the above message, and do you know
what it indicates?

For one thing, I notice your filesystem comes out as different sizes,
1709202880 without encryption, 1709202592 with encryption (i.e.,
smaller)  (these are 4k block units)

I assume the error message is trying to read or write 131072 bytes from
the offset 13673620728 * 512, or:

   7000893812736 -> 7000893943807

The filesystem claims to end at:

   1709202592 * 4096 = 7000893816832

which appears to be in the middle of the above range.

131072 is the amount that mkfs.xfs tries to zero at the end of a block
device.  (you could confirm that it's this write by stracing mkfs,
perhaps?)  It looks like somebody has the size wrong...

What does "blockdev --getsize64" and "blockdev --getsize" and/or
/proc/partitions say about how big /dev/mapper/raid6 is?

Can you use dd to write to the last 128k of the device, as reported by
blockdev --getsize64?

-Eric
