Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6Q9Wn0n111256 for <xfs@OSS.SGI.com>; Mon, 26 Jul 2010 04:32:50 -0500
Received: from smarthost03.mail.zen.net.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C8CBE156BF84
	for <xfs@OSS.SGI.com>; Mon, 26 Jul 2010 02:35:53 -0700 (PDT)
Received: from smarthost03.mail.zen.net.uk (smarthost03.mail.zen.net.uk
	[212.23.3.142]) by cuda.sgi.com with ESMTP id jAJUHhAAD7PDaoE6
	for <xfs@OSS.SGI.com>; Mon, 26 Jul 2010 02:35:53 -0700 (PDT)
Received: from [82.69.39.138] (helo=ty.sabi.co.UK)
	by smarthost03.mail.zen.net.uk with esmtps
	(TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32) (Exim 4.63)
	(envelope-from <pg_mh@mh.to.sabi.co.UK>) id 1OdK6C-0006M7-Lz
	for xfs@OSS.SGI.com; Mon, 26 Jul 2010 09:35:52 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
	by ty.sabi.co.UK with esmtp(Exim 4.63 #1) id 1OdK63-0005q0-No
	for <xfs@OSS.SGI.com>; Mon, 26 Jul 2010 10:35:43 +0100
MIME-Version: 1.0
Message-ID: <19533.22251.225560.835077@tree.ty.sabi.co.uk>
Date: Mon, 26 Jul 2010 10:35:39 +0100
Subject: Re: 4k drives: benefits and models?
In-Reply-To: <20100726082141.GA8239@apartia.fr>
References: <20100726082141.GA8239@apartia.fr>
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
To: Linux XFS <xfs@oss.sgi.com>


> - what are the benefits of these new drives? Speed, temperature,
>   reliability?

It is purely higher density. A longer physical sector means less
percentage of the disk is "wasted" on metadata. This benefits
the manufacturer mostly, so they can claim more capacity with
less cost (but more credibly than the far more slimy trick of
LCD manufacturers who are going to ever more extreme landscape
ratios to claim a longer diagonal with less pixels).

>From the user/filesystem point iof view it is not a positive
thing, but since the 4BSD FFS introduced 4KiB blocks (a very bad
idea) and intel and others followed throught with alrge 4KiB
pages that has been largely irrelevant.

Also it seems that few people are aware that other device types
have large sectors, as CDs have 2KiB sectors, DVDs have 32KiB,
BDRs have 64KiB sectors (and both simulate 2KiB sectors), and
SSDs can have 256KiB sectors (or rather "erase blocks", I think
that they can read in smaller units than that).

> - what specific HD models are truely 4k for purchase right
>   now? I'm on the market for a bunch of 2Tb drives, what is a
>   good choice?

These are two completely unrelated questions, and the second is
sort of irrelevant because there are so few manufacturers and
thus models that one has to buy all of them. Except of course
for those who fill their arrays with disks from the same brand,
model and even shipping carton, as they know better.

As to the first, there have been a few discussions in the past
on vsarious Linux mailing lists etc, but the list of models
changes as manufacturers change firmware and "truely" is thus a
somewhat elastic concept dependent on revision not just model.

> - what options do I need when creating my raid6 array and xfs
>   filesystem to fully take advantage of 4k sectors?

Some recent posts to this mailing list give those. I would add
also large inodes (2Kib), to alleviate the big downside of 4KiB
sectors for small files.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
