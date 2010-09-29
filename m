Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8T43UOf017369 for <xfs@oss.sgi.com>; Tue, 28 Sep 2010 23:03:33 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E810118841AE
	for <xfs@oss.sgi.com>; Tue, 28 Sep 2010 21:04:29 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id jkKUncinu9Xkmgfs for
	<xfs@oss.sgi.com>; Tue, 28 Sep 2010 21:04:29 -0700 (PDT)
Date: Wed, 29 Sep 2010 00:04:25 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: reduce lock traffic on incore sb lock
Message-ID: <20100929040425.GA29691@infradead.org>
References: <1285721500-5671-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1285721500-5671-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Sep 29, 2010 at 10:51:40AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Under heavy parallel unlink workloads, the incore superblock lock is
> heavily trafficed in xfs_mod_incore_sb_batch(). This is despite the
> fact that the counters being modified are typically the counters
> that are per-cpu and do not require the lock. IOWs, we are locking
> and unlocking the superblock lock needlessly, and the result is that
> it is third most heavily contended lock in the system under these
> workloads.
> 
> Fix this by only locking the superblock lock when we are modifying a
> counter protected by it. This completely removes the m_sb_lock from
> lock_stat traces during create/remove workloads.

God spot of the idiocy there, but I really don't like the patch.
I've started writing a small patches series solving the issue slightly
better by cleaning up this area a bit.

After this we will never use xfs_mod_incore_sb/xfs_mod_incore_sb_batch
for the percpu counters but rather make those always go through
xfs_icsb_modify_counters.  I'll need to quickly finish it up and will
send it out soon.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
