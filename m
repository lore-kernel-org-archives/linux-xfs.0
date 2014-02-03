Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 496797FD0
	for <xfs@oss.sgi.com>; Mon,  3 Feb 2014 10:50:58 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 37FC730407A
	for <xfs@oss.sgi.com>; Mon,  3 Feb 2014 08:50:58 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id bZ8Iu7KXnzbASPcF (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 03 Feb 2014 08:50:57 -0800 (PST)
Message-ID: <52EFC8BA.3010906@oracle.com>
Date: Mon, 03 Feb 2014 10:50:02 -0600
From: Dave Kleikamp <dave.kleikamp@oracle.com>
MIME-Version: 1.0
Subject: Re: [RFC] unifying write variants for filesystems
References: <20140114172033.GU10323@ZenIV.linux.org.uk>
	<20140118064040.GE10323@ZenIV.linux.org.uk>
	<CA+55aFw4LgyYEkygxHUnpKZg3jMACGzsyENc9a9rWFmLcaRefQ@mail.gmail.com>
	<20140118074649.GF10323@ZenIV.linux.org.uk>
	<CA+55aFzM0N7WjqnLNnuqTkbj3iws9f3bYxei=ZBCM8hvps4zYg@mail.gmail.com>
	<20140118201031.GI10323@ZenIV.linux.org.uk>
	<20140119051335.GN10323@ZenIV.linux.org.uk>
	<20140120135514.GA21567@infradead.org>
	<CA+55aFzEA-eM9v2PvsWx4v4ANaKXuRGYyGCkegJg++rhtHvnig@mail.gmail.com>
	<20140201224301.GS10323@ZenIV.linux.org.uk>
	<20140203151242.GA6868@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>, Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>, Sage Weil <sage@inktank.com>, Mark Fasheh <mfasheh@suse.com>, xfs@oss.sgi.com, Steve French <sfrench@samba.org>, Kent Overstreet <kmo@daterainc.com>, Joel Becker <jlbec@evilplan.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Anton Altaparmakov <anton@tuxera.com>

On 02/03/2014 09:12 AM, Christoph Hellwig wrote:
> On Sat, Feb 01, 2014 at 10:43:01PM +0000, Al Viro wrote:
>> * WTF bother passing 'pos' separately?  It's the same mistake that was
>> made with ->aio_read/->aio_write and just as with those, *all* callers
>> provably have pos == iocb->ki_pos.
> 
> I think this landed with the initial aio support, which planned for
> allowing AIO retries for a workqueue with a partially incremented
> pos.  None of this ever got merged, probably because it was too ugly
> to live.

Yeah, when these patches were first written, AIO looked a lot different.

>> * We *definitely* want a variant structure with tag - unsigned long thing
>> was just plain insane.  I see at least two variants - array of iovecs
>> and array of (at least) triples <page, offset, length>.  Quite possibly -
>> quadruples, with "here's how to try to steal this page" thrown in, if
>> we want that as replacement for ->splice_write() as well (it looks like
>> the few instances that do steal on pipe-to-file splices could be dealt
>> with the same way as the dumb ones, provided that ->write_iter or whatever
>> we end up calling it is allowed to try and steal pages).   Possibly more
>> variants on the read side of things...  FWIW, I'm not sure that bio_vec
>> makes a lot of sense here.
> 
> bio_vec just is one of the many page+offset+len containers we have, I
> guess Dave took it because loop uses it.  We could either invent a new
> one here or finally have a common one for the different uses all over
> the kernel.

With Kent's immutable bio_vec changes, peeking inside the bio to get to
the bio_vec is uglier than it was before, so there's no need to stick
with that.

Shaggy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
