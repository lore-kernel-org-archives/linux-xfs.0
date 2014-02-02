Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C4F417F9F
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 17:17:02 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A1CFC304039
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 15:16:59 -0800 (PST)
Received: from ppsw-52.csi.cam.ac.uk (ppsw-52.csi.cam.ac.uk [131.111.8.152])
	by cuda.sgi.com with ESMTP id T1TKoQ4U60SVBEIl (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 02 Feb 2014 15:16:58 -0800 (PST)
Subject: Re: [RFC] unifying write variants for filesystems
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
From: Anton Altaparmakov <anton@tuxera.com>
In-Reply-To: <20140201224301.GS10323@ZenIV.linux.org.uk>
Date: Sun, 2 Feb 2014 23:16:10 +0000
Message-Id: <26FB2577-B1A9-47BF-B1BC-47350DC37D3A@tuxera.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, Steve French <sfrench@samba.org>, Sage Weil <sage@inktank.com>, Dave Kleikamp <shaggy@kernel.org>, Mark Fasheh <mfasheh@suse.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Joel Becker <jlbec@evilplan.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>

Hi Al,

On 1 Feb 2014, at 22:43, Al Viro <viro@zeniv.linux.org.uk> wrote:
> * ntfs_file_buffered_write() should switch to iov_iter as well.  It's
> open-coding a lot of iov_iter stuff.

The NTFS code predates iov_iter by more than 10 years so it simply wasn't there to use when I wrote NTFS...  But yes, NTFS should be updated to use it, I agree completely.

> It's not entirely trivial and
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

That would deadlock.  You are (of course) quite right.  But the generic file write code used to suffer from the same deadlock problem and no-one ever complained much about it IIRC...

In the current kernel the problem does not exist any more (due to the do the atomic copy with pagefaults disabled and then retrying with just the first segment and keeping retrying till it works) so indeed updating NTFS to use iov_iter would be a good opportunity to get that fixed in NTFS as well.

It does not matter if for NTFS it turns out to be quite inefficient (due to locking/unlocking several pages at once) as it is such a crazy corner case that will hardly ever be triggered in real life especially so as the only time NTFS operates on more than one page at once in ntfs_file_buffered_write() is when a write happens into a sparse logical block (NTFS "cluster") and only on volumes with a logical block size > PAGE_CACHE_SIZE which with a minimum PAGE_CACHE_SIZE of 4096 bytes on Linux and the fact that Windows only ever creates volumes with a logical block size of 4096 (unless the user specifically forces a different block size when creating the volume) it means that it basically hardly ever happens.  Also, the NTFS kernel driver never creates sparse files, i.e. the sparse file would have had to come from Windows or another NTFS implementation...

I will have a look at moving NTFS to iov_iter and fixing the potential deadlock at the same time.

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge
J.J. Thomson Avenue, Cambridge, CB3 0RB, UK

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
