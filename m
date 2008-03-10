Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Mar 2008 13:37:46 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2AKbPF8017144
	for <xfs@OSS.SGI.com>; Mon, 10 Mar 2008 13:37:29 -0700
Received: from ty.sabi.co.UK (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 87E0167FAF4
	for <xfs@OSS.SGI.com>; Mon, 10 Mar 2008 13:37:55 -0700 (PDT)
Received: from ty.sabi.co.UK ([192.100.78.57]) by cuda.sgi.com with ESMTP id kMzlb3CAHfQt9sDD for <xfs@OSS.SGI.com>; Mon, 10 Mar 2008 13:37:55 -0700 (PDT)
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
	by ty.sabi.co.UK with esmtp(Exim 4.66 #1)
	id 1JYokn-0001Jg-61
	for <xfs@OSS.SGI.com>; Mon, 10 Mar 2008 20:37:49 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18389.39964.468947.464155@tree.ty.sabi.co.uk>
Date: Mon, 10 Mar 2008 20:37:48 +0000
Subject: Re: xfs for free hosting on linux ? performance questions
In-Reply-To: <2db2c6b80803091738o20dc80b2p82c5bf7246a8c560@mail.gmail.com>
References: <47D45926.5070806@gmail.com>
	<18388.31367.314074.624135@tree.ty.sabi.co.uk>
	<2db2c6b80803091738o20dc80b2p82c5bf7246a8c560@mail.gmail.com>
From: pg_xfs2@xfs2.for.to.sabi.co.UK (Peter Grandi)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linux XFS <xfs@oss.sgi.com>


> but reiserfs is slow for me too, maybe i have some other
> problems? i made array like this mdadm --create /dev/md0
> --verbose --level=5 --raid-devices=5 /dev/sd{b,c,d,e,f}1
> --assume-clean

Uhhhhh, '--assume-clean' on a RAID5 is not necessarily a good
idea. Just don't do it, and wait a few hours for the initial
sync to happen.

> [ ... ]
>     26.48 megabytes read (94.47 kilobytes per second)
>     136.18 megabytes written (485.89 kilobytes per second)

> is there something wrong with my system??

The speed above is indeed terrible. Perhaps the array is
rebuilding frantically as it finds all stripes have the wrong
parity because of '--assume-clean'.

> [ ... ] LA is 0.50 right now (i'm testing it at night),

Why is LA relevant? What is running on that system now? Are
those physical disks being used by some applications?

> hdparm is showing that every HD from the array is doing
> 100MB/s at least, so why these numbers?

Perhaps after rebuilding the array without '--assume-clean' you
might try to do such simple tests on the '/dev/md0' device
itself, just to be sure that it performs more or less adequately.

After several reports that is helps, try this before the test:

  blockdev --setra 1024 /dev/md0

but even without it you should be getting at least 40-50MB/s.

And always check the array status with 'mdadm --detail' to see
if it is resyncing or not before testing.

Using 'watch iostat -k sd{b,c,d,e,f} 1 2' (and checking out the
_second_ set of figures) is also nice to see the actual transfer
rates of each drive in the array and verify that if you are
reading there is no writing going on etc.
