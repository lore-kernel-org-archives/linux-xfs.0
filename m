Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D05F27F4E
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 09:17:42 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8F0E88F8050
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 07:17:42 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id lqwxkyd5P6AHQ45C (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Feb 2014 07:17:40 -0800 (PST)
Date: Tue, 4 Feb 2014 15:17:28 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC] unifying write variants for filesystems
Message-ID: <20140204151728.GH10323@ZenIV.linux.org.uk>
References: <20140118074649.GF10323@ZenIV.linux.org.uk>
	<CA+55aFzM0N7WjqnLNnuqTkbj3iws9f3bYxei=ZBCM8hvps4zYg@mail.gmail.com>
	<20140118201031.GI10323@ZenIV.linux.org.uk>
	<20140119051335.GN10323@ZenIV.linux.org.uk>
	<20140120135514.GA21567@infradead.org>
	<CA+55aFzEA-eM9v2PvsWx4v4ANaKXuRGYyGCkegJg++rhtHvnig@mail.gmail.com>
	<20140201224301.GS10323@ZenIV.linux.org.uk>
	<52EFC271.3090205@oracle.com>
	<20140204124409.GG10323@ZenIV.linux.org.uk>
	<20140204125220.GB12440@kmo-pixel>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140204125220.GB12440@kmo-pixel>
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
To: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>, Steve French <sfrench@samba.org>, Sage Weil <sage@inktank.com>, Mark Fasheh <mfasheh@suse.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Dave Kleikamp <dave.kleikamp@oracle.com>, Joel Becker <jlbec@evilplan.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Zach Brown <zab@zabbo.net>, Linus Torvalds <torvalds@linux-foundation.org>, Anton Altaparmakov <anton@tuxera.com>

On Tue, Feb 04, 2014 at 04:52:20AM -0800, Kent Overstreet wrote:

> I'm on vacation in Switzerland, didn't bring my adderall, and
> direct-io.c makes my head hurt at the best of times, but - have a look
> at my in-progress dio rewrite:
> 
> http://evilpiepirate.org/git/linux-bcache.git/commit/?h=block_stuff&id=ca09c20f08efd640f255fabd778de0dbf43ed1da
> 
> Where I'm headed with things is to just start out by allocating bios and
> pinning pages into them, and _then_ doing all the fun "ask the
> filesystem where it goes and what to do with it" dance. The goal is to
> push the bios as far up the stack as possible.

How far would that be?  E.g. for something like NFS it would be
completely wrong.  AFAICS, what you are doing there isn't incompatible
with what I described; bio_get_user_pages() would just use that
primitive (in fact, the loop in it is a damn good starting point for
implementation of that primitive for iovec-based instances of iov_iter).

I'm not too fond of the names, TBH - it might make sense to rename
iov_iter to something like mem_stream; maybe even leave iov_iter as-is
for whatever users might remain, but for now I don't see any that
would fundamentally depend on the thing being iovev-backed...
And bio_vec is a bad misnomer - it's not related to block subsystem at
all.  Sure, it had originated there, but...  Hell knows; by now it's
probably too much PITA to rename (we have about half a thousand instances
in the tree).  Pity, that...

I definitely don't buy "bio is a natural object for carrying an array
of pieces of pages"; not sure if that's what you implied in earlier
thread, but it has too much baggage from block subsystem *and* it lacks
the things we may want to associate with individual elements of such
array (starting with "how can I steal that page?" method).

I'm not sure if you'd been reading that thread back when it started;
my interest in that thing is mostly because I want to get rid of
duplication (and inconsistencies) between ->aio_write() and ->splice_write().
I hadn't been watching the threads around iov_iter last year; hch has
pointed to those when I proposed to use an object that could carry
both iovec and (possibly extended) analog of bio_vec and make
generic_file_aio_write() et.al. agnostic wrt what's behind that object.
Then we could use the same method to implement both ->aio_write() and
->splice_write() in a lot of cases.  iov_iter is a good starting point
for such object, and for now I'm mostly doing stuff that encapsulates
the knowledge of its guts (including "there's an iovec behind it").
Those cleanups aside (and they make sense on their own, regardless of
where the rest goes), it might make sense to add a copy of struct iov_iter
that would have a tagged union in it (originally just for iovec, with
IOVEC_READ/IOVEC_WRITE as possible tags) and switch a bunch of places that
do not look into the guts of iov_iter to that thing.  I'm not sure if
there will be any other places left (so far it looks like we'll be able
to get away with a reasonable set of primitives), but... we'll see.
For now the whole thing is fairly experimental and it will almost certainly
be reordered, etc. quite a few times.  I'm trying to keep the part of
queue in vfs.git#iov_iter more or less stable (with a lot of stuff in
flux sitting in the local one), but it's not at the state where I'd
recommend merges from it; there will be rebases, etc.

BTW, folks, any suggestions about the name of that "memory stream" thing?
struct iov_iter really implies iterator for iovec and more generic name
would probably be better...  struct mem_stream would probably do if nobody
comes up with better variant, but it's long and somewhat clumsy...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
