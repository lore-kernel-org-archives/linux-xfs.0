Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4000A7F4E
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 06:44:31 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2347A8F8065
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 04:44:26 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id uikX07DqWYogwfjB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Feb 2014 04:44:25 -0800 (PST)
Date: Tue, 4 Feb 2014 12:44:09 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC] unifying write variants for filesystems
Message-ID: <20140204124409.GG10323@ZenIV.linux.org.uk>
References: <20140118064040.GE10323@ZenIV.linux.org.uk>
	<CA+55aFw4LgyYEkygxHUnpKZg3jMACGzsyENc9a9rWFmLcaRefQ@mail.gmail.com>
	<20140118074649.GF10323@ZenIV.linux.org.uk>
	<CA+55aFzM0N7WjqnLNnuqTkbj3iws9f3bYxei=ZBCM8hvps4zYg@mail.gmail.com>
	<20140118201031.GI10323@ZenIV.linux.org.uk>
	<20140119051335.GN10323@ZenIV.linux.org.uk>
	<20140120135514.GA21567@infradead.org>
	<CA+55aFzEA-eM9v2PvsWx4v4ANaKXuRGYyGCkegJg++rhtHvnig@mail.gmail.com>
	<20140201224301.GS10323@ZenIV.linux.org.uk>
	<52EFC271.3090205@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52EFC271.3090205@oracle.com>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, Steve French <sfrench@samba.org>, Sage Weil <sage@inktank.com>, Mark Fasheh <mfasheh@suse.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Kent Overstreet <kmo@daterainc.com>, Dave Kleikamp <dave.kleikamp@oracle.com>, Joel Becker <jlbec@evilplan.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Zach Brown <zab@zabbo.net>, Anton Altaparmakov <anton@tuxera.com>

On Mon, Feb 03, 2014 at 10:23:13AM -0600, Dave Kleikamp wrote:

> Thanks for the feedback. I'd been asking for feedback on this patchset
> for some time now, and have not received very much.
> 
> This is all based on some years-old work by Zach Brown that he probably
> wishes would have disappeared by now. I pretty much left what I could
> alone since 1) it was working, and 2) I didn't hear any objections
> (until now).
> 
> It's clear now that the patchset isn't close to mergable, so treat it
> like a proof-of-concept and we can come up with a better container and
> read/write interface. I won't respond individually to your comments, but
> will take them all into consideration going forward.

FWIW, I suspect that the right way to deal with dio side of things would
be a primitive along the lines of "get first N <page,start,len> for the
iov_iter".  With get_user_pages_fast() for iovec-backed ones and "just
grab references" for array-of-page-subranges ones.

_IF_ direct-io.c can be massaged to use that (and it looks like it should
be able to - AFAICS, we don't really care if pages are mapped in userland or
kernel space there), we get something really neat out of that: not only can
we get rid of generic_file_splice_write(), but we get full zero-copy
sendfile() - just have the target opened with O_DIRECT and everything will
work; ->splice_read() will trigger reads to source pagecache and with that
massage done, ->splice_write() will issue writes directly from those
pages, with no memory-to-memory copying in sight...  We can also get rid of
that kmap() in __swap_writepage(), while we are at it.

I'm going through direct-io.c guts right now and so far that looks feasible,
but I'd really appreciate comments from the folks more familiar with the
damn thing.

The queue so far is in vfs.git#iov_iter; I've gone after the low-hanging
fruits in the review I've posted upthread and I more or less like the
results so far...

Comments?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
