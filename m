Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAPMSjkq012372 for <xfs@oss.sgi.com>; Wed, 25 Nov 2009 16:28:45 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2D7B0B601F
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2009 14:29:11 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id mxqQScDmEUcgCv34 for
	<xfs@oss.sgi.com>; Wed, 25 Nov 2009 14:29:11 -0800 (PST)
Message-ID: <4B0DAFB5.3050003@sandeen.net>
Date: Wed, 25 Nov 2009 16:29:09 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] Prevent lookup from finding bad buffers
References: <4990EAF9.9010607@sgi.com> <4B0D92EB.8030501@sandeen.net>
In-Reply-To: <4B0D92EB.8030501@sandeen.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: lachlan@sgi.com
Cc: xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:
> Lachlan McIlroy wrote:
>> There's a bug in _xfs_buf_find() that will cause it to return buffers
>> that failed to be initialised.
>>
>> If a thread has a buffer locked and is waiting for I/O to initialise
>> it and another thread wants the same buffer the second thread will
>> wait on the buffer lock in _xfs_buf_find().  If the initial thread
>> gets an I/O error it marks the buffer in error and releases the
>> buffer lock.  The second thread gets the buffer lock, assumes the
>> buffer has been successfully initialised, and then tries to use it.
>>
>> Some callers of xfs_buf_get_flags() will check for B_DONE, and if
>> it's not set then re-issue the I/O, bust most callers assume the
>> buffer and it's contents are good and then use the uninitialised
>> data.
>>
>> The solution I've come up with is if we lookup a buffer and find
>> it's got b_error set or has been marked stale then unhash it from
>> the buffer hashtable and retry the lookup.  Also if we fail to setup
>> the buffer correctly in xfs_buf_get_flags() then mark the buffer in
>> error and unhash it.  If the buffer is marked stale then in
>> xfs_buf_free() inform the page cache that the contents of the pages
>> are no longer valid.
> 
> I managed to come up with a sorta-kinda testcase for this.
> 
> Fragmented freespace, many files in a dir, on raid5; simply doing
> drop caches / ls in a loop triggered it.
> 
> I guess raid5 is bad in this respect; in it's make_request() we have:
> 
>                 } else {
>                         /* cannot get stripe for read-ahead, just give-up */
>                         clear_bit(BIO_UPTODATE, &bi->bi_flags);
>                         finish_wait(&conf->wait_for_overlap, &w);
>                         break;
>                 }
> 
> and this happens fairly often.  This probably explains a large
> percentage of our xfs_da_do_buf(2) errors we've seen on the list.
> 
> From my testing, I think this suffices - and interestingly, Lachlan's
> original patch doesn't seem to help...
> 
> Comments?
> 
> Maybe could clean up the logic a bit... should this only be
> tested for XBF_READ buffers as well ... or maybe an assert that
> if !uptodate, error should be set ...
> 
> diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
> index 965df12..cbc0541 100644
> --- a/fs/xfs/linux-2.6/xfs_buf.c
> +++ b/fs/xfs/linux-2.6/xfs_buf.c
> @@ -1142,6 +1165,8 @@ xfs_buf_bio_end_io(
>  		if (unlikely(bp->b_error)) {
>  			if (bp->b_flags & XBF_READ)
>  				ClearPageUptodate(page);
> +		} else if (!test_bit(BIO_UPTODATE, &bio->bi_flags)) {
> +			ClearPageUptodate(bp);
>  		} else if (blocksize >= PAGE_CACHE_SIZE) {
>  			SetPageUptodate(page);
>  		} else if (!PagePrivate(page) &&

Ok, so that was shoot-from-the-hip, and actually it was tested on an
older kernel; upstream didn't demonstrate the problem, thanks to:

commit c2b00852fbae4f8c45c2651530ded3bd01bde814
Author: NeilBrown <neilb@suse.de>
Date:   Sun Dec 10 02:20:51 2006 -0800

[PATCH] md: return a non-zero error to bi_end_io as appropriate in raid5

Currently raid5 depends on clearing the BIO_UPTODATE flag to signal an
error
to higher levels.  While this should be sufficient, it is safer to
explicitly
set the error code as well - less room for confusion.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: Linus Torvalds <torvalds@osdl.org>

As Neil says, xfs should probably cope too by checking uptodate itself
as well, though...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
