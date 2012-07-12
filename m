Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6CH6Ofq064249 for <xfs@oss.sgi.com>; Thu, 12 Jul 2012 12:06:24 -0500
Received: from mail-yx0-f181.google.com (mail-yx0-f181.google.com
	[209.85.213.181]) by cuda.sgi.com with ESMTP id
	3Z2zPNEv64j6KlrE (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 12 Jul 2012 10:06:23 -0700 (PDT)
Received: by yenl3 with SMTP id l3so3271459yen.26
	for <xfs@oss.sgi.com>; Thu, 12 Jul 2012 10:06:23 -0700 (PDT)
Date: Thu, 12 Jul 2012 10:06:18 -0700
From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/6] workqueue: use @pool instead of @gcwq or @cpu
	where applicable
Message-ID: <20120712170618.GB20167@google.com>
References: <1341859315-17759-1-git-send-email-tj@kernel.org>
	<1341859315-17759-4-git-send-email-tj@kernel.org>
	<CA+8MBbKtCODJxv0zQ2uL_wRE9U6F6tdOVwYSMv9=OQNLGzcVXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+8MBbKtCODJxv0zQ2uL_wRE9U6F6tdOVwYSMv9=OQNLGzcVXQ@mail.gmail.com>
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
To: Tony Luck <tony.luck@intel.com>
Cc: axboe@kernel.dk, elder@kernel.org, rni@google.com, martin.petersen@oracle.com, linux-bluetooth@vger.kernel.org, torvalds@linux-foundation.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, vwadekar@nvidia.com, swhiteho@redhat.com, herbert@gondor.hengli.com.au, bpm@sgi.com, linux-crypto@vger.kernel.org, gustavo@padovan.org, xfs@oss.sgi.com, joshhunt00@gmail.com, davem@davemloft.net, vgoyal@redhat.com, johan.hedberg@gmail.com

Hello, Tony.

On Tue, Jul 10, 2012 at 04:30:36PM -0700, Tony Luck wrote:
> On Mon, Jul 9, 2012 at 11:41 AM, Tejun Heo <tj@kernel.org> wrote:
> > @@ -1234,7 +1235,7 @@ static void worker_enter_idle(struct worker *worker)
> >          */
> >         WARN_ON_ONCE(gcwq->trustee_state == TRUSTEE_DONE &&
> >                      pool->nr_workers == pool->nr_idle &&
> > -                    atomic_read(get_gcwq_nr_running(gcwq->cpu)));
> > +                    atomic_read(get_pool_nr_running(pool)));
> >  }
> 
> Just had this WARN_ON_ONCE trigger on ia64 booting next-20120710. I
> haven't bisected ... just noticed  that two patches in this series tinker
> with lines in this check. next-20120706 didn't generate the WARN.

Sorry about the delay.  The warning is spurious.  As now there are
multiple pools, nr_running check should be done before
pool->nr_workers check.  Will post fix soon.

Thank you.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
