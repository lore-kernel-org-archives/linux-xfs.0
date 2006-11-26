Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 25 Nov 2006 20:26:56 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAQ4QmaG010878
	for <xfs@oss.sgi.com>; Sat, 25 Nov 2006 20:26:49 -0800
Message-ID: <45691753.60500@redhat.com>
Date: Sat, 25 Nov 2006 22:25:55 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH/RFC] pass dio_complete proper offset from finished_one_bio
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.org, xfs@oss.sgi.com
Cc: rtc@gmx.de

We saw problems w/ xfs doing AIO+DIO into a sparse file.
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=217098

It seemed that xfs was doing "extent conversion" at the wrong offsets, so
written regions came up as unwritten (zeros) and stale data was exposed
in the region after the write.  Thanks to Peter Backes for the very
nice testcase.

This also broke xen with blktap over xfs.

Here's what I found:
finished_one_bio calls dio_complete calls xfs_end_io_direct with an offset, but:

	offset = dio->iocb->ki_pos;

so this is the -current- post-IO position, not the IO start point that dio_complete 
expects.  So, xfs converts the the wrong region.  Ouch!

XFS seems to be the only filesystem that uses the offset passed to the 
end_io function, so only it is affected by this as near as I can tell.

However, the "short read" case is probably also wrong, as it is checking:

                        if ((dio->rw == READ) &&
                            ((offset + transferred) > dio->i_size))
                                transferred = dio->i_size - offset;

but offset is the ending IO position in this case too.

This patch seems to fix it up.

Comments?

Thanks,
-Eric

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Index: linux-2.6.18/fs/direct-io.c
===================================================================
--- linux-2.6.18.orig/fs/direct-io.c
+++ linux-2.6.18/fs/direct-io.c
@@ -244,12 +244,12 @@ static void finished_one_bio(struct dio 
 			 */
 			spin_unlock_irqrestore(&dio->bio_lock, flags);
 
-			/* Check for short read case */
 			transferred = dio->result;
-			offset = dio->iocb->ki_pos;
+			offset = dio->iocb->ki_pos - transferred;
 
+			/* Check for short read case */
 			if ((dio->rw == READ) &&
-			    ((offset + transferred) > dio->i_size))
+			    (dio->iocb->ki_pos > dio->i_size))
 				transferred = dio->i_size - offset;
 
 			/* check for error in completion path */
