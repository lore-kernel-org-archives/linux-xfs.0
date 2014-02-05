Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 820907F52
	for <xfs@oss.sgi.com>; Wed,  5 Feb 2014 13:59:01 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 19028AC002
	for <xfs@oss.sgi.com>; Wed,  5 Feb 2014 11:59:01 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id 5KzbpOVtF9bCbLqG (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 05 Feb 2014 11:58:56 -0800 (PST)
Date: Wed, 5 Feb 2014 19:58:38 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC] unifying write variants for filesystems
Message-ID: <20140205195838.GO10323@ZenIV.linux.org.uk>
References: <CA+55aFzEA-eM9v2PvsWx4v4ANaKXuRGYyGCkegJg++rhtHvnig@mail.gmail.com>
	<20140201224301.GS10323@ZenIV.linux.org.uk>
	<52EFC271.3090205@oracle.com>
	<20140204124409.GG10323@ZenIV.linux.org.uk>
	<20140204125220.GB12440@kmo-pixel>
	<20140204151728.GH10323@ZenIV.linux.org.uk>
	<20140204172723.GA11325@lenny.home.zabbo.net>
	<20140204180040.GI10323@ZenIV.linux.org.uk>
	<20140204183356.GB11325@lenny.home.zabbo.net>
	<20140204183609.GK10323@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140204183609.GK10323@ZenIV.linux.org.uk>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Zach Brown <zab@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Steve French <sfrench@samba.org>, Sage Weil <sage@inktank.com>, Mark Fasheh <mfasheh@suse.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Kent Overstreet <kmo@daterainc.com>, Dave Kleikamp <dave.kleikamp@oracle.com>, Joel Becker <jlbec@evilplan.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Anton Altaparmakov <anton@tuxera.com>

	BTW, why do we still have generic_segment_checks()?
AFAICS, *all* paths leading to any ->aio_read/->aio_write
instances are either
	1) with KERNEL_DS (and base/len are verifiably sane in those
cases), or
	2) have iovec come from successful {compat,}rw_copy_check_uvector()
and through rw_verify_area(), or
	3) have single-element iovec with access_ok()/rw_verify_area()
checked directly, or
	4) have single-element iovec with base/len unchanged from
what had been passed to some ->read() or ->write() instance, in which
case the caller of that ->read() or ->write() has done access_ok/rw_verify_area

And yes, I can prove that for the current tree, modulo a couple of dumb
bugs with unchecked values coming via read_code().  Which is called
a couple of times per a.out execve() and should be using vfs_read() instead
of blindly calling ->read() - it's *not* a hot path and never had been one.
With that fixed, we have the following: and call of any instance of
->read()/->write()/->aio_read()/->aio_write() (be it direct or via method)
is guaranteed that
	* all segments it's asked to read/write will satisfy access_ok().
	* all segments it's asked to read/write will have non-negative
lengths.
	* total size of all segments will be at most MAX_RW_COUNT.
	* file offset won't go from negative to zero in the combined area;
unless the file has FMODE_UNSIGNED_OFFSET in ->f_mode, it won't go from
positive to negative either.

So what exactly does generic_segments_check() give us?  Is it just that
everybody went "well, maybe there's some weird path where we don't do
validation; let's leave it there"?  Linus?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
