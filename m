Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAPKPtfP005330 for <xfs@oss.sgi.com>; Wed, 25 Nov 2009 14:25:55 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F18B9C9B0CE
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2009 12:26:21 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Ke3vTC2WwTuovFQ5 for
	<xfs@oss.sgi.com>; Wed, 25 Nov 2009 12:26:21 -0800 (PST)
Message-ID: <4B0D92EB.8030501@sandeen.net>
Date: Wed, 25 Nov 2009 14:26:19 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] Prevent lookup from finding bad buffers
References: <4990EAF9.9010607@sgi.com>
In-Reply-To: <4990EAF9.9010607@sgi.com>
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

Lachlan McIlroy wrote:
> There's a bug in _xfs_buf_find() that will cause it to return buffers
> that failed to be initialised.
> 
> If a thread has a buffer locked and is waiting for I/O to initialise
> it and another thread wants the same buffer the second thread will
> wait on the buffer lock in _xfs_buf_find().  If the initial thread
> gets an I/O error it marks the buffer in error and releases the
> buffer lock.  The second thread gets the buffer lock, assumes the
> buffer has been successfully initialised, and then tries to use it.
> 
> Some callers of xfs_buf_get_flags() will check for B_DONE, and if
> it's not set then re-issue the I/O, bust most callers assume the
> buffer and it's contents are good and then use the uninitialised
> data.
> 
> The solution I've come up with is if we lookup a buffer and find
> it's got b_error set or has been marked stale then unhash it from
> the buffer hashtable and retry the lookup.  Also if we fail to setup
> the buffer correctly in xfs_buf_get_flags() then mark the buffer in
> error and unhash it.  If the buffer is marked stale then in
> xfs_buf_free() inform the page cache that the contents of the pages
> are no longer valid.

I managed to come up with a sorta-kinda testcase for this.

Fragmented freespace, many files in a dir, on raid5; simply doing
drop caches / ls in a loop triggered it.

I guess raid5 is bad in this respect; in it's make_request() we have:

                } else {
                        /* cannot get stripe for read-ahead, just give-up */
                        clear_bit(BIO_UPTODATE, &bi->bi_flags);
                        finish_wait(&conf->wait_for_overlap, &w);
                        break;
                }

and this happens fairly often.  This probably explains a large
percentage of our xfs_da_do_buf(2) errors we've seen on the list.

>From my testing, I think this suffices - and interestingly, Lachlan's
original patch doesn't seem to help...

Comments?

Maybe could clean up the logic a bit... should this only be
tested for XBF_READ buffers as well ... or maybe an assert that
if !uptodate, error should be set ...

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 965df12..cbc0541 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -1142,6 +1165,8 @@ xfs_buf_bio_end_io(
 		if (unlikely(bp->b_error)) {
 			if (bp->b_flags & XBF_READ)
 				ClearPageUptodate(page);
+		} else if (!test_bit(BIO_UPTODATE, &bio->bi_flags)) {
+			ClearPageUptodate(bp);
 		} else if (blocksize >= PAGE_CACHE_SIZE) {
 			SetPageUptodate(page);
 		} else if (!PagePrivate(page) &&

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
