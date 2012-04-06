Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q360Dndw092285 for <xfs@oss.sgi.com>; Thu, 5 Apr 2012 19:13:50 -0500
Received: from anakin.london.02.net (anakin.london.02.net [87.194.255.134]) by
	cuda.sgi.com with ESMTP id 4RSVH7hiWusApV2x for
	<xfs@oss.sgi.com>; Thu, 05 Apr 2012 17:13:48 -0700 (PDT)
Received: from ty.sabi.co.UK (87.194.99.40) by anakin.london.02.net (8.5.140)
	id 4EEB63D201F4FCBF for xfs@oss.sgi.com;
	Fri, 6 Apr 2012 01:13:46 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.71 #1) id 1SFwo5-0006p3-1S
	for <xfs@oss.sgi.com>; Fri, 06 Apr 2012 01:13:37 +0100
MIME-Version: 1.0
Message-ID: <20350.13616.901974.523140@tree.ty.sabi.co.UK>
Date: Fri, 6 Apr 2012 01:13:36 +0100
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Linux fs XFS <xfs@oss.sgi.com>

[ ... ]

> Which means that your Linux-level seek graphs may be not so
> useful, because the host adapter may be drastically rearranging
> the seek patterns, and you may need to tweak the P400 elevator,
> rather than or in addition to the Linux elevator.

> Unless possibly barriers are enabled, and even with a BBWC the
> P400 writes through on receiving a barrier request. IIRC XFS is
> rather stricter in issuing barrier requests than 'ext4', and you
> may be seeing more the effect of that than the effect of aiming
> to splitting the access patterns between 4 AGs [ ... ]

As to this, in theory even having split the files among 4 AGs,
the upload from system RAM to host adapter RAM and then to disk
could happen by writing first all the dirty blocks for one AG,
then a long seek to the next AG, and so on, and the additional
cost of 3 long seeks would be negligible. 

That you report a significant slowdown indicates that this is
not happening, and that likely XFS flushing is happening not in
spacewise order but in timewise order.

The seeks graphs you have gathered indeed indicate that with
'ext4' there is a spacewise flush, while with XFS the flush
alternates constantly among the 4 AGs, instead of doing each AG
in turn. Which seems to indicate an elevator issue or a barrier
issue after the delayed allocator has assigned block addresses
to the various pages being flushed.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
