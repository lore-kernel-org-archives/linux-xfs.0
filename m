Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 751627F50
	for <xfs@oss.sgi.com>; Mon,  8 Jul 2013 20:15:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 561F8304066
	for <xfs@oss.sgi.com>; Mon,  8 Jul 2013 18:15:37 -0700 (PDT)
Received: from dkim2.fusionio.com (dkim2.fusionio.com [66.114.96.54]) by
	cuda.sgi.com with ESMTP id buMTt2iSSct3AUTZ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 08 Jul 2013 18:15:36 -0700 (PDT)
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 91ECF9A069A
	for <xfs@oss.sgi.com>; Mon,  8 Jul 2013 19:15:35 -0600 (MDT)
MIME-Version: 1.0
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <20130708124453.GC3438@dastard>
References: <1372657476-9241-1-git-send-email-david@fromorbit.com>
	<20130708124453.GC3438@dastard>
Message-ID: <20130709011533.3855.97802@localhost.localdomain>
Subject: Re: Some baseline tests on new hardware (was Re: [PATCH] xfs:
	optimise CIL insertion during transaction commit [RFC])
Date: Mon, 8 Jul 2013 21:15:33 -0400
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org

Quoting Dave Chinner (2013-07-08 08:44:53)
> [cc fsdevel because after all the XFS stuff I did a some testing on
> mmotm w.r.t per-node LRU lock contention avoidance, and also some
> scalability tests against ext4 and btrfs for comparison on some new
> hardware. That bit ain't pretty. ]
> 
> And, well, the less said about btrfs unlinks the better:
> 
> +  37.14%  [kernel]  [k] _raw_spin_unlock_irqrestore
> +  33.18%  [kernel]  [k] __write_lock_failed
> +  17.96%  [kernel]  [k] __read_lock_failed
> +   1.35%  [kernel]  [k] _raw_spin_unlock_irq
> +   0.82%  [kernel]  [k] __do_softirq
> +   0.53%  [kernel]  [k] btrfs_tree_lock
> +   0.41%  [kernel]  [k] btrfs_tree_read_lock
> +   0.41%  [kernel]  [k] do_raw_read_lock
> +   0.39%  [kernel]  [k] do_raw_write_lock
> +   0.38%  [kernel]  [k] btrfs_clear_lock_blocking_rw
> +   0.37%  [kernel]  [k] free_extent_buffer
> +   0.36%  [kernel]  [k] btrfs_tree_read_unlock
> +   0.32%  [kernel]  [k] do_raw_write_unlock
> 

Hi Dave,

Thanks for doing these runs.  At least on Btrfs the best way to resolve
the tree locking today is to break things up into more subvolumes.  I've
got another run at the root lock contention in the queue after I get
the skiplists in place in a few other parts of the Btrfs code.

-chris

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
