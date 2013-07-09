Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 794467F53
	for <xfs@oss.sgi.com>; Mon,  8 Jul 2013 20:26:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0640AAC001
	for <xfs@oss.sgi.com>; Mon,  8 Jul 2013 18:26:19 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	psBxnwEdf1L8ToEV for <xfs@oss.sgi.com>;
	Mon, 08 Jul 2013 18:26:18 -0700 (PDT)
Date: Tue, 9 Jul 2013 11:26:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Some baseline tests on new hardware (was Re: [PATCH] xfs:
	optimise CIL insertion during transaction commit [RFC])
Message-ID: <20130709012614.GH3438@dastard>
References: <1372657476-9241-1-git-send-email-david@fromorbit.com>
	<20130708124453.GC3438@dastard>
	<20130709011533.3855.97802@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130709011533.3855.97802@localhost.localdomain>
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
To: Chris Mason <chris.mason@fusionio.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Jul 08, 2013 at 09:15:33PM -0400, Chris Mason wrote:
> Quoting Dave Chinner (2013-07-08 08:44:53)
> > [cc fsdevel because after all the XFS stuff I did a some testing on
> > mmotm w.r.t per-node LRU lock contention avoidance, and also some
> > scalability tests against ext4 and btrfs for comparison on some new
> > hardware. That bit ain't pretty. ]
> > 
> > And, well, the less said about btrfs unlinks the better:
> > 
> > +  37.14%  [kernel]  [k] _raw_spin_unlock_irqrestore
> > +  33.18%  [kernel]  [k] __write_lock_failed
> > +  17.96%  [kernel]  [k] __read_lock_failed
> > +   1.35%  [kernel]  [k] _raw_spin_unlock_irq
> > +   0.82%  [kernel]  [k] __do_softirq
> > +   0.53%  [kernel]  [k] btrfs_tree_lock
> > +   0.41%  [kernel]  [k] btrfs_tree_read_lock
> > +   0.41%  [kernel]  [k] do_raw_read_lock
> > +   0.39%  [kernel]  [k] do_raw_write_lock
> > +   0.38%  [kernel]  [k] btrfs_clear_lock_blocking_rw
> > +   0.37%  [kernel]  [k] free_extent_buffer
> > +   0.36%  [kernel]  [k] btrfs_tree_read_unlock
> > +   0.32%  [kernel]  [k] do_raw_write_unlock
> > 
> 
> Hi Dave,
> 
> Thanks for doing these runs.  At least on Btrfs the best way to resolve
> the tree locking today is to break things up into more subvolumes.

Sure, but you can't do that most workloads. Only on specialised
workloads (e.g. hashed directory tree based object stores) is this
really a viable option....

> I've
> got another run at the root lock contention in the queue after I get
> the skiplists in place in a few other parts of the Btrfs code.

It will be interesting to see how these new structures play out ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
