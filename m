Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qBA0h1iM148804 for <xfs@oss.sgi.com>; Sun, 9 Dec 2012 18:43:01 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Aamw7MhygCmec0v6 for <xfs@oss.sgi.com>;
	Sun, 09 Dec 2012 16:45:28 -0800 (PST)
Date: Mon, 10 Dec 2012 11:45:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS write cache flush policy
Message-ID: <20121210004514.GF15784@dastard>
References: <CAA_rkDfFUmZzT_kMznsTSNVxdfqfmz=bmJ400wdBOzocgP32eA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAA_rkDfFUmZzT_kMznsTSNVxdfqfmz=bmJ400wdBOzocgP32eA@mail.gmail.com>
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
To: Lin Li <sdeber@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, Dec 06, 2012 at 09:51:15AM +0100, Lin Li wrote:
> Hi, Guys. I recently suffered a huge data loss on power cut on an XFS
> partition. The problem was that I copied a lot of files (roughly 20Gb) to
> an XFS partition, then 10 hours later, I got an unexpected power cut. As a
> result, all these newly copied files disappeared as if they had never been
> copied. I tried to check and repair the partition, but xfs_check reports no
> error at all. So I guess the problem is that the meta data for these files
> were all kept in the cache (64Mb) and were never committed to the hard
> disk.

This will have absolutely nothing to do with disk cache flush
policy.

It sounds very much like a journal recovery issue where a set of
changes is not recovered by to a problem with the transaction in the
journal.  Indeed, I recently fixed a 19 year old bug in the journal
write code that could cause exactly this sort of symptom:

commit d35e88faa3b0fc2cea35c3b2dca358b5cd09b45f
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Oct 8 21:56:12 2012 +1100

    xfs: only update the last_sync_lsn when a transaction completes
    
    The log write code stamps each iclog with the current tail LSN in
    the iclog header so that recovery knows where to find the tail of
    thelog once it has found the head. Normally this is taken from the
    first item on the AIL - the log item that corresponds to the oldest
    active item in the log.
    
    The problem is that when the AIL is empty, the tail lsn is dervied
    from the the l_last_sync_lsn, which is the LSN of the last iclog to
    be written to the log. In most cases this doesn't happen, because
    the AIL is rarely empty on an active filesystem. However, when it
    does, it opens up an interesting case when the transaction being
    committed to the iclog spans multiple iclogs.
    
    That is, the first iclog is stamped with the l_last_sync_lsn, and IO
    is issued. Then the next iclog is setup, the changes copied into the
    iclog (takes some time), and then the l_last_sync_lsn is stamped
    into the header and IO is issued. This is still the same
    transaction, so the tail lsn of both iclogs must be the same for log
    recovery to find the entire transaction to be able to replay it.
    
    The problem arises in that the iclog buffer IO completion updates
    the l_last_sync_lsn with it's own LSN. Therefore, If the first iclog
    completes it's IO before the second iclog is filled and has the tail
    lsn stamped in it, it will stamp the LSN of the first iclog into
    it's tail lsn field. If the system fails at this point, log recovery
    will not see a complete transaction, so the transaction will no be
    replayed.
    
    The fix is simple - the l_last_sync_lsn is updated when a iclog
    buffer IO completes, and this is incorrect. The l_last_sync_lsn
    shoul dbe updated when a transaction is completed by a iclog buffer
    IO. That is, only iclog buffers that have transaction commit
    callbacks attached to them should update the l_last_sync_lsn. This
    means that the last_sync_lsn will only move forward when a commit
    record it written, not in the middle of a large transaction that is
    rolling through multiple iclog buffers.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Ben Myers <bpm@sgi.com>

This commit only hit 3.7-rc5, but has not been sent to -stable
kernels because I thought it was only exposed by the 3.7 changes.
However, looking at it we've been changing the code that exposed it
since about 3.4, so it's entirely possible that we did expose it
earlier than 3.7-rc1.

Looks like a stable kernel candidate....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
