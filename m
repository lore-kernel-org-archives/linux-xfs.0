Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 20CAB7FD7
	for <xfs@oss.sgi.com>; Mon,  3 Feb 2014 10:24:20 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1463F8F8040
	for <xfs@oss.sgi.com>; Mon,  3 Feb 2014 08:24:17 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id yOQBw7bzRTYKTftP (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 03 Feb 2014 08:24:15 -0800 (PST)
Message-ID: <52EFC271.3090205@oracle.com>
Date: Mon, 03 Feb 2014 10:23:13 -0600
From: Dave Kleikamp <dave.kleikamp@oracle.com>
MIME-Version: 1.0
Subject: Re: [RFC] unifying write variants for filesystems
References: <20140114132207.GA25170@infradead.org>
	<20140114172033.GU10323@ZenIV.linux.org.uk>
	<20140118064040.GE10323@ZenIV.linux.org.uk>
	<CA+55aFw4LgyYEkygxHUnpKZg3jMACGzsyENc9a9rWFmLcaRefQ@mail.gmail.com>
	<20140118074649.GF10323@ZenIV.linux.org.uk>
	<CA+55aFzM0N7WjqnLNnuqTkbj3iws9f3bYxei=ZBCM8hvps4zYg@mail.gmail.com>
	<20140118201031.GI10323@ZenIV.linux.org.uk>
	<20140119051335.GN10323@ZenIV.linux.org.uk>
	<20140120135514.GA21567@infradead.org>
	<CA+55aFzEA-eM9v2PvsWx4v4ANaKXuRGYyGCkegJg++rhtHvnig@mail.gmail.com>
	<20140201224301.GS10323@ZenIV.linux.org.uk>
In-Reply-To: <20140201224301.GS10323@ZenIV.linux.org.uk>
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
To: Al Viro <viro@ZenIV.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, Steve French <sfrench@samba.org>, Sage Weil <sage@inktank.com>, Mark Fasheh <mfasheh@suse.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Joel Becker <jlbec@evilplan.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Zach Brown <zab@zabbo.net>, Anton Altaparmakov <anton@tuxera.com>

On 02/01/2014 04:43 PM, Al Viro wrote:
> On Mon, Jan 20, 2014 at 12:32:01PM -0800, Linus Torvalds wrote:
>> On Mon, Jan 20, 2014 at 5:55 AM, Christoph Hellwig <hch@infradead.org> wrote:
>>> On Sun, Jan 19, 2014 at 05:13:35AM +0000, Al Viro wrote:
>>>> Folks, what do you think about the following:
>>>
>>> That's very much what Shaggy did in the aio-direct tree, except that
>>> it kept using a single set of methods.  Linus really didn't like it
>>> unfortunately.
>>
>> Umm. That wasn't what I objected to.
>>
>> I objected to the incredibly ugly implementation, the crazy new flags
>> arguments for core helper functions, ugly naming etc etc. I even
>> outlined what might fix it.
>>
>> In other words, I thought the code was shit and ugly. Not that
>> iterators per se would be wrong. Just doing them badly is wrong.
> 
> Gyahhh...  OK, I should've known better than go looking into that thing
> after such warning.  Some relatively printable notes (i.e. about 10%
> of the comments I really had about that) follow:

Thanks for the feedback. I'd been asking for feedback on this patchset
for some time now, and have not received very much.

This is all based on some years-old work by Zach Brown that he probably
wishes would have disappeared by now. I pretty much left what I could
alone since 1) it was working, and 2) I didn't hear any objections
(until now).

It's clear now that the patchset isn't close to mergable, so treat it
like a proof-of-concept and we can come up with a better container and
read/write interface. I won't respond individually to your comments, but
will take them all into consideration going forward.

Thanks,
Shaggy

> * WTF bother passing 'pos' separately?  It's the same mistake that was
> made with ->aio_read/->aio_write and just as with those, *all* callers
> provably have pos == iocb->ki_pos.
> 
> * I'm not sure that iov_iter is a good fit here.  OTOH, it probably could
> be reused (it has damn few users right now and they are on the codepaths
> involved into that thing).
> 
> * We *definitely* want a variant structure with tag - unsigned long thing
> was just plain insane.  I see at least two variants - array of iovecs
> and array of (at least) triples <page, offset, length>.  Quite possibly -
> quadruples, with "here's how to try to steal this page" thrown in, if
> we want that as replacement for ->splice_write() as well (it looks like
> the few instances that do steal on pipe-to-file splices could be dealt
> with the same way as the dumb ones, provided that ->write_iter or whatever
> we end up calling it is allowed to try and steal pages).   Possibly more
> variants on the read side of things...  FWIW, I'm not sure that bio_vec
> makes a lot of sense here.
> 
> * direction (i.e. source vs. destination) also should be a part of that
> tag.  Which, BTW, turns ->direct_IO() into iocb x iov_iter -> int;
> the situation with pos is identical to aio_read/aio_write.  While we
> are at it, KERNEL_WRITE thing (used only for __swap_writepage()) looks
> very much like a special case of "array of <page,offset,size>" we want
> for splice_write...
> 
> * having looked through the ->read and ->write instances in drivers,
> I'd say that surprisingly few helpers would go a _long_ way towards
> converting those guys to the same methods.  And we need such helpers
> anyway - there's a whole lot of (badly) open-coded "copy the whole
> user buffer into kmalloc'ed array and NUL-terminate the sucker" logics
> in ->write() instances, for example.  Even more "copy up to that much
> into given array and NUL-terminate it", with rather amusing bugs in
> there - e.g. NUL going into the end of array, regardless of the actual
> amount of data to copy; junk is left in the middle, complete with
> printk of the entire thing if it doesn't make sense.  IOW, spewing
> random piece of kernel stack into dmesg.  Off-by-ones galore, too...
> 
> BTW, speaking of bogosities - grep for generic_write_checks().  Exactly
> one caller (in __generic_file_aio_write()) has any business looking
> at S_ISBLK(inode->i_mode) - it can be called by blkdev_aio_write().
> All other callers have copied that, even though it makes absolutely
> no sense for them...
> 
> * file_readable/file_writable looks really wrong; if nothing else, I would
> rather check that after open() and set a couple of FMODE bits, then check
> those.  Possibly even "knock FMODE_READ/FMODE_WRITE out if there's no
> method"...
>
> * pipe_buffer_operations ->map()/->unmap() should die; let the caller do
> k{,un}map{,_atomic}().  All instances have the same method there and
> there's no point to make it different.  PIPE_BUF_FLAG_ATOMIC should also
> go.
> 
> * WTF do iov_iter_copy_from_user_atomic() callers keep doing pagefault_disable
> and pagefault_enable around it?  The sucker starts with kmap_atomic() and
> ends with kunmap_atomic(); all instances of those guys have pagefaul
> disabling/enabling (and I suspect that it might make sense to lift it
> out of arch-specific variants - rename them to e.g. __kmap_atomic(),
> rip pagefault_disable() out of those and put kmap_atomic() into highmem.h
> outside of ifdef, with !HIGHMEM side of ifdef having #define __kmap_atomic
> page_address; move pagefault_enable() from __kunmap_atomic() to
> kunmap_atomic() while we are at it).
> 
> Note that e.g. pipe.c relies on kmap_atomic() disabling pagefaults - we
> have __copy_from_user_inatomic() done there under kmap_atomic(), and we
> really don't want to block in such conditions.
> 
> * pipe_iov_copy_from_user() ought to return how much has it managed to
> bring in, not 0 or -EFAULT as it does now.  Then it won't need the
> non-atomic side, AFAICS.  Moreover, we'll just be able to use
> iov_iter_copy_from_user_atomic() (which badly needs a more palatable
> name, BTW).
> 
> * sure, we want to call do_generic_file_read() once, passing the entire
> iovec to file_read_actor().  But what the hell does that have to do with
> introduction of new methods?  It's a change that makes sense on its
> own.  Moreover, it's a damn good preparation to adding those - we
> get generic_file_aio_read() into "set iov_iter up, then do <this>",
> with <this> using iov_iter instead of iovec.  Once we get to introducing
> those methods, it's just a matter of taking the rest of generic_file_aio_read()
> into a separate function and making that function an instance of new
> method...
> 
> * Unrelated to this patchset, but... may I politely inquire about the reasons
> why ->is_partially_uptodate() gets read_descriptor_t?  The whole point
> of read_descriptor_t (if it has any) is that its interpretation is up to
> whoever's doing the reading, _not_ what they are reading from.  So desc->arg
> is off-limits for any instance of ->is_partially_uptodate().  desc->written is
> obviously pointless for them; the need (or lack thereof) to do something
> to the page doesn't depend on how much have we already read from the
> file.  Moreover, reporting an error is rather dubious in such method;
> if there's something fishy with the page, we'll just return "no" and let
> ->readpage() complain.  Which leaves only desc->count, which, unsurprisingly,
> is the only thing looked at by (the only) instance of that method.  And
> "tell me if the part of this page that long starting from that offset is
> up to date" is much more natural that "is what this read_descriptor_t would
> have had us read from this offset in this page up to date?"...
> 
> * do we really need separate non-atomic variant of iov_iter_copy_from_user()?
> We have only two users right now (cifs and ceph) and both can use the
> fault-in / atomic copy loop without much pain...
> 
> * in addition to having too many methods, I'm not convinced that we want
> them to be methods.  Let's start with explicit checks in the primitives and
> see where it goes from there; if we start to grow too many variants,
> we can always introduce some methods, but then we'll be in better position
> to decide what is and what is not a good method...
> 
> * on the read side, I really don't believe that exposing atomic and
> non-atomic variants is a good idea.  Look at the existing users of
> __copy_to_user_inatomic(); leaving aside the i915_gem weirdness,
> all of them are used to implement the exact same thing: given a page,
> offset and length, feed its contents to iovec/buffer/whatnot.  Unlike
> the write side of things, there's nothing between prefaulting pages
> and actual attempts to copy.  So let's make _that_ an exposed primitive
> and let it deal with kmap/kmap_atomic/etc.  Variants that don't have
> to worry about blocking (vector of <page,offset,length>, etc.) would
> simply not bother with non-atomic kmap, etc.  Sure, it should take
> iov_iter as destination.  And deal with mapping the damn thing internally...
> 
> * ntfs_file_buffered_write() should switch to iov_iter as well.  It's
> open-coding a lot of iov_iter stuff.  It's not entirely trivial and
> I'd really like to hear from ntfs folks on that, though, and the current
> code looks deadlock-prone.  We prefault everything, then lock the pages
> to which we'll be copying, then attempt to do __copy_from_user_inatomic(),
> falling back to __copy_from_user() if that fails.  Fine, but what happens
> if the source of write() is mmaped from the same file and we lose CPU while
> prefaulting the last page, have memory pressure evict the first one, then
> have __ntfs_grab_cache_pages() allocate and lock (nonuptodate) pages
> we'll be copying to and have __copy_from_user() try to copy *from* those
> same pages?  We are doing it while holding these pages locked, so pagefault
> will have really fun time with them...  Anton?
> 
> BTW, Linus, when did you comment on that patchset?  I've found an iteration
> of that patchset circa last October (v9, apparently the latest posted),
> but it looks like your comments had either got lost or had been on the
> earlier iteration of that thing...
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
