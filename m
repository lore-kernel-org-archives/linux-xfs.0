Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9FFD37F54
	for <xfs@oss.sgi.com>; Thu,  6 Feb 2014 03:07:18 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7BBAF30406B
	for <xfs@oss.sgi.com>; Thu,  6 Feb 2014 01:07:15 -0800 (PST)
Received: from mail-oa0-f43.google.com (mail-oa0-f43.google.com
	[209.85.219.43]) by cuda.sgi.com with ESMTP id 3jdoOkOSxDKEciaz
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 06 Feb 2014 01:07:11 -0800 (PST)
Received: by mail-oa0-f43.google.com with SMTP id h16so1968651oag.16
	for <xfs@oss.sgi.com>; Thu, 06 Feb 2014 01:07:10 -0800 (PST)
Date: Thu, 6 Feb 2014 01:08:32 -0800
From: Kent Overstreet <kmo@daterainc.com>
Subject: Re: [RFC] unifying write variants for filesystems
Message-ID: <20140206090832.GC12440@kmo-pixel>
References: <20140201224301.GS10323@ZenIV.linux.org.uk>
	<52EFC271.3090205@oracle.com>
	<20140204124409.GG10323@ZenIV.linux.org.uk>
	<20140204125220.GB12440@kmo-pixel>
	<20140204151728.GH10323@ZenIV.linux.org.uk>
	<20140204172723.GA11325@lenny.home.zabbo.net>
	<20140204180040.GI10323@ZenIV.linux.org.uk>
	<20140204183356.GB11325@lenny.home.zabbo.net>
	<20140204183609.GK10323@ZenIV.linux.org.uk>
	<20140205195838.GO10323@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140205195838.GO10323@ZenIV.linux.org.uk>
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
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>, Steve French <sfrench@samba.org>, Sage Weil <sage@inktank.com>, Zach Brown <zab@redhat.com>, Mark Fasheh <mfasheh@suse.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Dave Kleikamp <dave.kleikamp@oracle.com>, Joel Becker <jlbec@evilplan.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Anton Altaparmakov <anton@tuxera.com>

On Wed, Feb 05, 2014 at 07:58:38PM +0000, Al Viro wrote:
> 	BTW, why do we still have generic_segment_checks()?
> AFAICS, *all* paths leading to any ->aio_read/->aio_write
> instances are either
> 	1) with KERNEL_DS (and base/len are verifiably sane in those
> cases), or
> 	2) have iovec come from successful {compat,}rw_copy_check_uvector()
> and through rw_verify_area(), or
> 	3) have single-element iovec with access_ok()/rw_verify_area()
> checked directly, or
> 	4) have single-element iovec with base/len unchanged from
> what had been passed to some ->read() or ->write() instance, in which
> case the caller of that ->read() or ->write() has done access_ok/rw_verify_area
> 
> And yes, I can prove that for the current tree, modulo a couple of dumb
> bugs with unchecked values coming via read_code().  Which is called
> a couple of times per a.out execve() and should be using vfs_read() instead
> of blindly calling ->read() - it's *not* a hot path and never had been one.
> With that fixed, we have the following: and call of any instance of
> ->read()/->write()/->aio_read()/->aio_write() (be it direct or via method)
> is guaranteed that
> 	* all segments it's asked to read/write will satisfy access_ok().
> 	* all segments it's asked to read/write will have non-negative
> lengths.
> 	* total size of all segments will be at most MAX_RW_COUNT.
> 	* file offset won't go from negative to zero in the combined area;
> unless the file has FMODE_UNSIGNED_OFFSET in ->f_mode, it won't go from
> positive to negative either.
> 
> So what exactly does generic_segments_check() give us?  Is it just that
> everybody went "well, maybe there's some weird path where we don't do
> validation; let's leave it there"?  Linus?

I came to the same conclusion awhile ago - I'm pretty sure it can be
safely dropped (I think I even have such a patch in one of my
branches...)

Anyways, copy_check_uvector() is the correct place for all that stuff
anyways - it's taking a __user type and producing a type without the
__user attribute, so if there was any validation missing there that's
where it should go.

I vaguelly recall converting some SCSI related code to use
copy_check_uvector() instead of its own (open coded?) thing, if that
patch made it upstream that could've been a place that at one point in
time did need the generic_segment_checks() call.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
