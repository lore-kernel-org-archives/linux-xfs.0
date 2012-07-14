Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6E8IH1q249695 for <xfs@oss.sgi.com>; Sat, 14 Jul 2012 03:18:17 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88]) by
	cuda.sgi.com with ESMTP id Fu7w206X5HGiUvG4 for
	<xfs@oss.sgi.com>; Sat, 14 Jul 2012 01:18:16 -0700 (PDT)
Date: Sat, 14 Jul 2012 16:18:02 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH UPDATED 6/6] workqueue: reimplement WQ_HIGHPRI using a
	separate worker_pool
Message-ID: <20120714081802.GA30812@localhost>
References: <1341859315-17759-1-git-send-email-tj@kernel.org>
	<1341859315-17759-7-git-send-email-tj@kernel.org>
	<20120714035650.GC5638@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120714035650.GC5638@dhcp-172-17-108-109.mtv.corp.google.com>
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
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, elder@kernel.org, rni@google.com, martin.petersen@oracle.com, linux-bluetooth@vger.kernel.org, torvalds@linux-foundation.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, vwadekar@nvidia.com, swhiteho@redhat.com, herbert@gondor.hengli.com.au, bpm@sgi.com, Tony Luck <tony.luck@intel.com>, linux-crypto@vger.kernel.org, gustavo@padovan.org, xfs@oss.sgi.com, joshhunt00@gmail.com, davem@davemloft.net, vgoyal@redhat.com, johan.hedberg@gmail.com

> v2: nr_running indexing bug in get_pool_nr_running() fixed.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Josh Hunt <joshhunt00@gmail.com>
> LKML-Reference: <CAKA=qzaHqwZ8eqpLNFjxnO2fX-tgAOjmpvxgBFjv6dJeQaOW1w@mail.gmail.com>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Fengguang Wu <fengguang.wu@intel.com>
> ---
> git branch updated accordingly.  Thanks.

It works now, thank you very much!

Tested-by: Fengguang Wu <fengguang.wu@intel.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
