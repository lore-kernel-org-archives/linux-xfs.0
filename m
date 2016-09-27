Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3F45A7CA1
	for <xfs@oss.sgi.com>; Tue, 27 Sep 2016 10:53:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 107D58F8033
	for <xfs@oss.sgi.com>; Tue, 27 Sep 2016 08:53:44 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id rkkE2wunKckih7oS (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 27 Sep 2016 08:53:38 -0700 (PDT)
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: [PATCH 04/11] splice: lift pipe_lock out of splice_to_pipe()
From: Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <20160924172901.GS2356@ZenIV.linux.org.uk>
Date: Tue, 27 Sep 2016 11:53:29 -0400
Message-Id: <08CA45FA-EDE2-4DF9-9459-22BE285F337D@oracle.com>
References: <CA+55aFznQaOWoSMNphgGJJWZ=8-odrc0DAUMzfGPQe+_N4UgNA@mail.gmail.com>
	<20160914042559.GC2356@ZenIV.linux.org.uk>
	<20160917082007.GA6489@ZenIV.linux.org.uk>
	<20160917190023.GA8039@ZenIV.linux.org.uk>
	<20160923190032.GA25771@ZenIV.linux.org.uk>
	<20160923190326.GB2356@ZenIV.linux.org.uk>
	<CA+55aFxzPH2AYvDVWSAomO6bN_sW4+qDv87Xbq8XHMyvBEYe+w@mail.gmail.com>
	<20160923201025.GJ2356@ZenIV.linux.org.uk>
	<CA+55aFyr-X_6FcWkSXBUcxV0p1BUZw8d=46wawv2x+8y7f8YcQ@mail.gmail.com>
	<20160924035908.GM2356@ZenIV.linux.org.uk>
	<20160924172901.GS2356@ZenIV.linux.org.uk>
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
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>, CAI Qian <caiqian@redhat.com>, Nick Piggin <npiggin@gmail.com>, xfs@oss.sgi.com, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>


> On Sep 24, 2016, at 1:29 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> 
> On Sat, Sep 24, 2016 at 04:59:08AM +0100, Al Viro wrote:
> 
>> 	FWIW, updated (with fixes) and force-pushed.  Added piece:
>> default_file_splice_read() converted to iov_iter.  Seems to work, after
>> fixing a braino in __pipe_get_pages().  Changed: #4 (sleep only in the
>> beginning, as described above), #6 (context changes from #4), #10 (missing
>> get_page() added in __pipe_get_pages()), #11 (removed pointless truncation
>> of len - ->read_iter() can bloody well handle that on its own) and added #12.
>> Stands at 28 files changed, 657 insertions(+), 1009 deletions(-) now...
> 
> 	I think I see how to get full zero-copy (including the write side
> of things).  Just add a "from" side for ITER_PIPE iov_iter (advance,
> get_pages, get_pages_alloc, npages and alignment will need to behave
> differently for "to" and "from" ones) and pull the following trick:
> have fault_in_readable return NULL instead of 0, ERR_PTR(-EFAULT) instead
> of -EFAULT *and* return a struct page if it was asked for a full-page
> range on a page that could be successfully stolen (only "from pipe" iov_iter
> would go for the last one, of course).  Then we make generic_perform_write()
> shove the return value of fault-in into 'page'.  ->write_begin() is given
> &page as an argument, to return the resulting page via that.  All instances
> currently just store into that pointer, completely ignoring the prior value.
> And they'll keep working just fine.
> 
> 	Let's make sure that all method call sites outside of
> generic_perform_write() (there's only one such, actually) have NULL
> stored in there prior to the call.  Now we can start switching the
> instances to zero-copy support - all it takes is replacing
> grab_cache_page_write_begin() with "if *page is non-NULL, try to
> shove it (locked, non-uptodate) into pagecache; if that succeeds grab a
> reference to our page and we are done, if it fails - fall back to
> grab_cache_page_write_begin()".  Then do get_block, etc., or whatever that
> ->write_begin() instance would normally do, just remember not to zero anything
> if the page had been passed to us by caller.
> 
> 	Now all we need is to make sure that iov_iter_copy_from_user_atomic()
> for those guys recongnizes the case of full-page copy when source and target
> are the same page and quietly returns PAGE_SIZE.  Voila - we can make
> iter_file_splice_write() pass pipe-backed iov_iter instead of bvec-backed
> one *and* get write-side zero-copy for all filesystems with ->write_begin()
> taught to handle that (see above).  Since the filesystems with unmodified
> ->write_begin() will act correctly (just do the copying), we don't have
> to make that a flagday change; ->write_begin() instances can be switched
> one by one.  Similar treatment of iomap_write_begin()/iomap_write_actor()
> would cover iomap-using ->write_iter() instances.
> 
> 	It's clearly not something I want to touch until -rc1, but it looks
> feasible for the next cycle, and if done right it promises to unify the
> plain and splice sides of fuse_dev_...() stuff, simplifying the hell out
> of them without losing zero-copy there.  And if everything really goes
> right, we might be able to get rid of net/* ->splice_read() and ->sendpage()
> methods as well...

Kernel NFS server already uses splice for its read path, but the
write path appears to require a full data copy of incoming payloads.
Would be awesome to see write-side support for zero-copy.


--
Chuck Lever



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
