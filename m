Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C2A0A7F52
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 11:28:23 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B6D1D8F8039
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 09:28:20 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id cUCtqbGs4tKzigy7 for
	<xfs@oss.sgi.com>; Tue, 04 Feb 2014 09:28:19 -0800 (PST)
Date: Tue, 4 Feb 2014 09:27:23 -0800
From: Zach Brown <zab@redhat.com>
Subject: Re: [RFC] unifying write variants for filesystems
Message-ID: <20140204172723.GA11325@lenny.home.zabbo.net>
References: <CA+55aFzM0N7WjqnLNnuqTkbj3iws9f3bYxei=ZBCM8hvps4zYg@mail.gmail.com>
	<20140118201031.GI10323@ZenIV.linux.org.uk>
	<20140119051335.GN10323@ZenIV.linux.org.uk>
	<20140120135514.GA21567@infradead.org>
	<CA+55aFzEA-eM9v2PvsWx4v4ANaKXuRGYyGCkegJg++rhtHvnig@mail.gmail.com>
	<20140201224301.GS10323@ZenIV.linux.org.uk>
	<52EFC271.3090205@oracle.com>
	<20140204124409.GG10323@ZenIV.linux.org.uk>
	<20140204125220.GB12440@kmo-pixel>
	<20140204151728.GH10323@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140204151728.GH10323@ZenIV.linux.org.uk>
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
Cc: Jens Axboe <axboe@kernel.dk>, Steve French <sfrench@samba.org>, Sage Weil <sage@inktank.com>, Mark Fasheh <mfasheh@suse.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Kent Overstreet <kmo@daterainc.com>, Dave Kleikamp <dave.kleikamp@oracle.com>, Joel Becker <jlbec@evilplan.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Anton Altaparmakov <anton@tuxera.com>

> I definitely don't buy "bio is a natural object for carrying an array
> of pieces of pages"; not sure if that's what you implied in earlier
> thread, but it has too much baggage from block subsystem *and* it lacks
> the things we may want to associate with individual elements of such
> array (starting with "how can I steal that page?" method).

I think Kent is talking about what happens after the user addresses are
consumed.  Turning dio into more of a bio mapping and redirection engine
would use more of the bio machinery instead of the bits that dio has
implemented itself with state in struct dio that hangs off the bios.  I
imagine it'd still make sense to clean up the addresses/pages arguments
that feed that engine.  (And give another entry point that already has
bios for callers like loop, etc.)

> BTW, folks, any suggestions about the name of that "memory stream" thing?
> struct iov_iter really implies iterator for iovec and more generic name
> would probably be better...  struct mem_stream would probably do if nobody
> comes up with better variant, but it's long and somewhat clumsy...

I don't like 'stream'.  To me that sounds more strictly advancing than I
think this'd be capable of.  Maybe something dirt simple like 'mem_vec'?
With 'mvec_' call prefixes?

Or kiobuf!  *runs*

- z

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
