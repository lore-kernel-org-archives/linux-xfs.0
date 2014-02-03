Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DF71A7FD7
	for <xfs@oss.sgi.com>; Mon,  3 Feb 2014 10:24:53 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 727E0AC001
	for <xfs@oss.sgi.com>; Mon,  3 Feb 2014 08:24:53 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id PEDsZb8ZX4A4awVg (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 03 Feb 2014 08:24:51 -0800 (PST)
Date: Mon, 3 Feb 2014 16:24:33 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC] unifying write variants for filesystems
Message-ID: <20140203162433.GX10323@ZenIV.linux.org.uk>
References: <20140118064040.GE10323@ZenIV.linux.org.uk>
	<CA+55aFw4LgyYEkygxHUnpKZg3jMACGzsyENc9a9rWFmLcaRefQ@mail.gmail.com>
	<20140118074649.GF10323@ZenIV.linux.org.uk>
	<CA+55aFzM0N7WjqnLNnuqTkbj3iws9f3bYxei=ZBCM8hvps4zYg@mail.gmail.com>
	<20140118201031.GI10323@ZenIV.linux.org.uk>
	<20140119051335.GN10323@ZenIV.linux.org.uk>
	<20140120135514.GA21567@infradead.org>
	<CA+55aFzEA-eM9v2PvsWx4v4ANaKXuRGYyGCkegJg++rhtHvnig@mail.gmail.com>
	<20140201224301.GS10323@ZenIV.linux.org.uk>
	<20140203151242.GA6868@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140203151242.GA6868@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Dave Kleikamp <shaggy@kernel.org>, Sage Weil <sage@inktank.com>, Mark Fasheh <mfasheh@suse.com>, xfs@oss.sgi.com, Steve French <sfrench@samba.org>, Joel Becker <jlbec@evilplan.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Anton Altaparmakov <anton@tuxera.com>

On Mon, Feb 03, 2014 at 07:12:42AM -0800, Christoph Hellwig wrote:
> > we end up calling it is allowed to try and steal pages).   Possibly more
> > variants on the read side of things...  FWIW, I'm not sure that bio_vec
> > makes a lot of sense here.
> 
> bio_vec just is one of the many page+offset+len containers we have, I
> guess Dave took it because loop uses it.  We could either invent a new
> one here or finally have a common one for the different uses all over
> the kernel.

*blink*

Good luck unifying all such uses.  That would have to include the things
needed by pipe_buffer, DMA-related bits for scatterlist, etc.  I don't
believe that it's feasible, or would've been a good idea in the first
place...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
