Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB9K4uMj013026 for <xfs@oss.sgi.com>; Tue, 9 Dec 2008 14:04:56 -0600
Received: from slurp.thebarn.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 21DDC1703E59
	for <xfs@oss.sgi.com>; Tue,  9 Dec 2008 12:04:54 -0800 (PST)
Received: from slurp.thebarn.com (cattelan-host202.dsl.visi.com
	[208.42.117.202]) by cuda.sgi.com with ESMTP id
	HaexrBiqjrxOTlm8 for <xfs@oss.sgi.com>;
	Tue, 09 Dec 2008 12:04:54 -0800 (PST)
Received: from funky.thebarn.com (slurp.thebarn.com [208.42.117.201])
	(authenticated bits=0)
	by slurp.thebarn.com (8.14.0/8.14.0) with ESMTP id mB9K4qE7070152
	for <xfs@oss.sgi.com>; Tue, 9 Dec 2008 14:04:53 -0600 (CST)
	(envelope-from cattelan@thebarn.com)
Message-ID: <493ECF64.7060800@thebarn.com>
Date: Tue, 09 Dec 2008 14:04:52 -0600
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: [patch 1/5] replace b_fspriv with b_mount
References: <20081209094729.939583000@bombadil.infradead.org>
	<20081209094801.116064000@bombadil.infradead.org>
In-Reply-To: <20081209094801.116064000@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:

 >  Replace the b_fspriv pointer and it's ugly accessors with a properly 
 > types
 > xfs_mount pointer.  Also switch log reocvery over to it instead of using
 > b_fspriv for the mount pointer.


Not that I object to cleaning this stuff up, (it's messy and hard to follow)

But currently the code maps well on freebsd since it has a
b_fsprivate1-3 buf field and
the macros handle the setting reading currently.

Granted I could simply un-apply this change for freebsd  but I would
prefer we
keep un-needed differences to a minimum.

I would prefer if we came up with a structure that could be attached to
an opaque  b_data field
that would be able to hold all current private info.

Currently it looks like b_strat is used for wrapper functions that
either check the mp for shutdown or
iclog->ic_state & XLOG_STATE_IOERROR.
Maybe we can collapse b_strat,  fspriv2/3 into one structure that would
have something like a
can_io function that would either allow or disallow io.

We could clean up more of the buf macros then.

-Russell



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
