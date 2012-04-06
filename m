Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q360x3KY097646 for <xfs@oss.sgi.com>; Thu, 5 Apr 2012 19:59:03 -0500
Received: from honeysuckle.london.02.net (honeysuckle.london.02.net
	[87.194.255.144]) by cuda.sgi.com with ESMTP id
	Cetx7uu7QLrxSpQX for <xfs@oss.sgi.com>;
	Thu, 05 Apr 2012 17:59:01 -0700 (PDT)
Received: from ty.sabi.co.UK (87.194.99.40) by honeysuckle.london.02.net
	(8.5.140)
	id 4F58EC1A00C9D93C for xfs@oss.sgi.com; Fri, 6 Apr 2012 01:59:00 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.71 #1) id 1SFxR4-0006pz-Eq
	for <xfs@oss.sgi.com>; Fri, 06 Apr 2012 01:53:54 +0100
MIME-Version: 1.0
Message-ID: <20350.16033.766746.102885@tree.ty.sabi.co.UK>
Date: Fri, 6 Apr 2012 01:53:53 +0100
Subject: Re: XFS: Abysmal write performance because of excessive seeking
	(allocation groups to blame?)
In-Reply-To: <20350.9643.379841.771496@tree.ty.sabi.co.UK>
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
	<20350.9643.379841.771496@tree.ty.sabi.co.UK>
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

> [ ... ] Which brings another subject: usually hw RAID host
> adapter have cache, and have firmware that cleverly rearranges
> writes. Looking at the specs of the P400: [ ... ] it seems to
> me that it has standard 256MB of cache, and only supports
> RAID6 with a battery backed write cache (wise!). [ ... ]

Uhm, looking further into the P400 an interesting detail:

http://hardforum.com/showpost.php?s=3Dc19964285e760bee47b8558ae82899d5&p=3D=
1033958051&postcount=3D4
 =ABOne is a stick of memory with a battery attached to it and one
  without. The one without is what the basic models ship with
  and usually has either 256 or 512Mb of memory, it supports
  caching for read operations only. [ ... ] You need the battery
  backed write cache module if you want to be able to use/turn
  on write caching on the array controller which makes a huge
  difference for write performance in general and is pretty much
  critical for raid 5 performance on writes.=BB

It may be worthwhile to check if there is an enabled BBWC
because if there is the BBWC the host adapter should be
buffering writes up to 256MiB/512MiB and sorting them thus long
inter-AG seeks should be happening only 10 or 5 times or not
much more (4 times) that. Instead it may be happening that the
P400 is doing write-through, which would reflect the unsorted
seek pattern at the Linux->host adapter level into the host
adapter->disk drive level.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
