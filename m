Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6E3fUmq224288 for <xfs@oss.sgi.com>; Fri, 13 Jul 2012 22:41:30 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id qcznst9JnzDujQWY
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 13 Jul 2012 20:41:28 -0700 (PDT)
Received: by pbbrr13 with SMTP id rr13so8088449pbb.26
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2012 20:41:28 -0700 (PDT)
Date: Fri, 13 Jul 2012 20:41:22 -0700
From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 6/6] workqueue: reimplement WQ_HIGHPRI using a separate
	worker_pool
Message-ID: <20120714034122.GA5638@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1341859315-17759-7-git-send-email-tj@kernel.org>
	<20120712130648.GA19214@localhost>
	<20120712170519.GA20167@google.com>
	<20120712214514.GD20167@google.com>
	<20120713020800.GA14026@localhost>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120713020800.GA14026@localhost>
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
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: axboe@kernel.dk, elder@kernel.org, rni@google.com, martin.petersen@oracle.com, linux-bluetooth@vger.kernel.org, torvalds@linux-foundation.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, vwadekar@nvidia.com, swhiteho@redhat.com, herbert@gondor.hengli.com.au, bpm@sgi.com, Tony Luck <tony.luck@intel.com>, linux-crypto@vger.kernel.org, gustavo@padovan.org, xfs@oss.sgi.com, joshhunt00@gmail.com, davem@davemloft.net, vgoyal@redhat.com, johan.hedberg@gmail.com

Hello,

On Fri, Jul 13, 2012 at 10:08:00AM +0800, Fengguang Wu wrote:
> [    0.165669] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
> [    0.167001] XXX cpu=0 gcwq=ffff88000dc0cfc0 base=ffff88000dc11e80
> [    0.167989] XXX cpu=0 nr_running=0 @ ffff88000dc11e80
> [    0.168988] XXX cpu=0 nr_running=0 @ ffff88000dc11e88
> [    0.169988] XXX cpu=1 gcwq=ffff88000dd0cfc0 base=ffff88000dd11e80
> [    0.170988] XXX cpu=1 nr_running=0 @ ffff88000dd11e80
> [    0.171987] XXX cpu=1 nr_running=0 @ ffff88000dd11e88
> [    0.172988] XXX cpu=8 nr_running=0 @ ffffffff81d7c430
> [    0.173987] XXX cpu=8 nr_running=12 @ ffffffff81d7c438

Heh, I found it.  get_pool_nr_running() stores the nr_running array to
use in a local pointer to array and then returns pointer to the
specific element from there depending on the priority.

	atomic_t (*nr_running)[NR_WORKER_POOLS];

	/* set @nr_running to the array to use */
	return nr_running[worker_pool_pri(pool)];

The [] operator in the return statement is indexing to the arrays
instead of the array elements, so if the index is 1, the above
statement offsets nr_running by sizeof(atomic_t [NR_WORKER_POOLS])
instead of sizeof(atomic_t).  This should have been
&(*nr_running)[worker_pool_pri(pool)] instead.

So, highpri ends up dereferencing out-of-bounds and depending on
variable layout, it may see garbage value from the beginning (what you
were seeing) or get interfered afterwards (what Tony was seeing).
This also explains why I didn't see it and Tony can no longer
reproduce it after debug patch.

Will post updated patches.

Thank you.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
