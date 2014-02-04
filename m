Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 12AFD7F4E
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 06:50:44 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CA1F48F8054
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 04:50:43 -0800 (PST)
Received: from mail-ea0-f175.google.com (mail-ea0-f175.google.com
	[209.85.215.175]) by cuda.sgi.com with ESMTP id
	0wqUIfGfsIHPO75l (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Feb 2014 04:50:41 -0800 (PST)
Received: by mail-ea0-f175.google.com with SMTP id z10so4376587ead.34
	for <xfs@oss.sgi.com>; Tue, 04 Feb 2014 04:50:40 -0800 (PST)
Date: Tue, 4 Feb 2014 04:52:20 -0800
From: Kent Overstreet <kmo@daterainc.com>
Subject: Re: [RFC] unifying write variants for filesystems
Message-ID: <20140204125220.GB12440@kmo-pixel>
References: <CA+55aFw4LgyYEkygxHUnpKZg3jMACGzsyENc9a9rWFmLcaRefQ@mail.gmail.com>
	<20140118074649.GF10323@ZenIV.linux.org.uk>
	<CA+55aFzM0N7WjqnLNnuqTkbj3iws9f3bYxei=ZBCM8hvps4zYg@mail.gmail.com>
	<20140118201031.GI10323@ZenIV.linux.org.uk>
	<20140119051335.GN10323@ZenIV.linux.org.uk>
	<20140120135514.GA21567@infradead.org>
	<CA+55aFzEA-eM9v2PvsWx4v4ANaKXuRGYyGCkegJg++rhtHvnig@mail.gmail.com>
	<20140201224301.GS10323@ZenIV.linux.org.uk>
	<52EFC271.3090205@oracle.com>
	<20140204124409.GG10323@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140204124409.GG10323@ZenIV.linux.org.uk>
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
Cc: Jens Axboe <axboe@kernel.dk>, Steve French <sfrench@samba.org>, Sage Weil <sage@inktank.com>, Mark Fasheh <mfasheh@suse.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Dave Kleikamp <dave.kleikamp@oracle.com>, Joel Becker <jlbec@evilplan.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Zach Brown <zab@zabbo.net>, Linus Torvalds <torvalds@linux-foundation.org>, Anton Altaparmakov <anton@tuxera.com>

On Tue, Feb 04, 2014 at 12:44:09PM +0000, Al Viro wrote:
> On Mon, Feb 03, 2014 at 10:23:13AM -0600, Dave Kleikamp wrote:
> 
> > Thanks for the feedback. I'd been asking for feedback on this patchset
> > for some time now, and have not received very much.
> > 
> > This is all based on some years-old work by Zach Brown that he probably
> > wishes would have disappeared by now. I pretty much left what I could
> > alone since 1) it was working, and 2) I didn't hear any objections
> > (until now).
> > 
> > It's clear now that the patchset isn't close to mergable, so treat it
> > like a proof-of-concept and we can come up with a better container and
> > read/write interface. I won't respond individually to your comments, but
> > will take them all into consideration going forward.
> 
> FWIW, I suspect that the right way to deal with dio side of things would
> be a primitive along the lines of "get first N <page,start,len> for the
> iov_iter".  With get_user_pages_fast() for iovec-backed ones and "just
> grab references" for array-of-page-subranges ones.

I'm on vacation in Switzerland, didn't bring my adderall, and
direct-io.c makes my head hurt at the best of times, but - have a look
at my in-progress dio rewrite:

http://evilpiepirate.org/git/linux-bcache.git/commit/?h=block_stuff&id=ca09c20f08efd640f255fabd778de0dbf43ed1da

Where I'm headed with things is to just start out by allocating bios and
pinning pages into them, and _then_ doing all the fun "ask the
filesystem where it goes and what to do with it" dance. The goal is to
push the bios as far up the stack as possible.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
