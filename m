Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8T5usH5025389 for <xfs@oss.sgi.com>; Wed, 29 Sep 2010 00:56:54 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CC546E8F00E
	for <xfs@oss.sgi.com>; Tue, 28 Sep 2010 23:10:56 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	jt4Ds38NCMEsN4WU for <xfs@oss.sgi.com>;
	Tue, 28 Sep 2010 23:10:56 -0700 (PDT)
Date: Wed, 29 Sep 2010 15:57:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: reduce lock traffic on incore sb lock
Message-ID: <20100929055748.GK5665@dastard>
References: <1285721500-5671-1-git-send-email-david@fromorbit.com>
	<20100929040425.GA29691@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100929040425.GA29691@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Sep 29, 2010 at 12:04:25AM -0400, Christoph Hellwig wrote:
> On Wed, Sep 29, 2010 at 10:51:40AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Under heavy parallel unlink workloads, the incore superblock lock is
> > heavily trafficed in xfs_mod_incore_sb_batch(). This is despite the
> > fact that the counters being modified are typically the counters
> > that are per-cpu and do not require the lock. IOWs, we are locking
> > and unlocking the superblock lock needlessly, and the result is that
> > it is third most heavily contended lock in the system under these
> > workloads.
> > 
> > Fix this by only locking the superblock lock when we are modifying a
> > counter protected by it. This completely removes the m_sb_lock from
> > lock_stat traces during create/remove workloads.
> 
> God spot of the idiocy there, but I really don't like the patch.

Fair enough - it is a rather quick hack. ;)

> I've started writing a small patches series solving the issue slightly
> better by cleaning up this area a bit.

Oh, cool. That code is quite a tangle.

> After this we will never use xfs_mod_incore_sb/xfs_mod_incore_sb_batch
> for the percpu counters but rather make those always go through
> xfs_icsb_modify_counters.  I'll need to quickly finish it up and will
> send it out soon.

FWIW, I've got a prototype that converts the per-cpu counters to the
generic per-cpu counter infrastructure. It chops out almost all the
xfs_icsb_* stuff (including xfs_icsb_modify_counters()) and has a
diffstat of:

6 files changed, 317 insertions(+), 709 deletions(-)

It needs a significant cleanup of xfs_mod_incore_sb() before/after
the conversion which I haven't done yet because I haven't quite got
my new percpu_counter_test_and_add_delta() function working
correctly yet. I spotted this locking problem when testing the
patch...

That said, there's no reason why my percpu counter code needs to run
through xfs_mod_incore_sb() at all. If we have a separate path for
per-cpu counters then I can rework my code on top of that....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
