Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q36EafIV249805 for <xfs@oss.sgi.com>; Fri, 6 Apr 2012 09:36:41 -0500
Received: from anakin.london.02.net (anakin.london.02.net [87.194.255.134]) by
	cuda.sgi.com with ESMTP id iGSg08Jo21LXl4vH for
	<xfs@oss.sgi.com>; Fri, 06 Apr 2012 07:36:39 -0700 (PDT)
Received: from ty.sabi.co.UK (87.194.99.40) by anakin.london.02.net (8.5.140)
	id 4EEB63D201F6C712 for xfs@oss.sgi.com;
	Fri, 6 Apr 2012 15:36:37 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.71 #1) id 1SGAH9-00086a-A2
	for <xfs@oss.sgi.com>; Fri, 06 Apr 2012 15:36:31 +0100
MIME-Version: 1.0
Message-ID: <20350.65390.662663.682964@tree.ty.sabi.co.UK>
Date: Fri, 6 Apr 2012 15:36:30 +0100
Subject: Re: XFS: Abysmal write performance because of excessive seeking
	(allocation groups to blame?)
In-Reply-To: <20349.63706.913104.777446@tree.ty.sabi.co.UK>
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
	<20349.63706.913104.777446@tree.ty.sabi.co.UK>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Linux fs XFS <xfs@oss.sgi.com>

[ ... ]

> [ ... ]  general purpose filesystems cannot handle well large
> groups of small files,
[ ... ]

>> As can be seen from the time scale in the bottom part, the
>> ext4 version performed about 5 times as fast because of a much
>> more disk-friendly write pattern.

As to 'ext4' and doing (euphemism) insipid tests involving
peculiar setups, there is an interesting story in this post:

  http://oss.sgi.com/archives/xfs/2012-03/msg00465.html

on the perils of using 'tar x' as a "test" of something
meaningful (illustrated using a much smaller "test" than
yours).

The telling details was that there was a ratio of 227 times (6
seconds versus 23 minutes) between running 'tar x' without any
safety and with most safeties.

A ratio of 227 times indicates that there is something big going
on, which is that contemporary disk drives have 2 orders of
magnitude between bulk sequential and small random "speed" (which
is the major reason why =ABgeneral purpose filesystems cannot
handle well large groups of small files=BB), and that in between
one can choose a vast number of different safety/speed tradeoffs
(or introduce performance problems :->).

Does that means that 'ext4' has "Abysmal write performance" in
the 23 minutes case? No, just a different tradeoff.

Similarly XFS has had for a long time a mostly undeserved
reputation for being "slow" on small-IO/metadata intensive
workloads, in large part because traditionally it has been
designed to deliver a higher level of (implicit, metadata) safety
than other filesystems; for good reasons.

Therefore as I argued in other comments the =ABexcessive seeking=BB
you report seems due to me more to storage layer issues and
perhaps stricter interpretation of safety by XFS, than to
something really wrong with XFS, which is a tool that has to be
deployed with consideration.

As to that a comparison that does point a finger at the
underlying storage system:

  * In your graphs 'ext4' writes out 2.5GB of small files at
    around 100MB/s (and with relatively few long seeks on that
    workload) on an "enterprise" storage system that has 4+2
    disks each capable of 130MB/s.

  * In the 6s "test" I did reported above in a similar situation
    'ext4' wrote out 370MB also at not much less than 100MB/s,
    but on a single "consumer" disk on a much slower destktop.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
