Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6CH7wDj064412 for <xfs@oss.sgi.com>; Thu, 12 Jul 2012 12:07:58 -0500
Received: from mail-gh0-f181.google.com (mail-gh0-f181.google.com
	[209.85.160.181]) by cuda.sgi.com with ESMTP id
	gl5nS1ImHbNxsFYg (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 12 Jul 2012 10:07:57 -0700 (PDT)
Received: by ghbz13 with SMTP id z13so3256005ghb.26
	for <xfs@oss.sgi.com>; Thu, 12 Jul 2012 10:07:57 -0700 (PDT)
Date: Thu, 12 Jul 2012 10:07:52 -0700
From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/6] workqueue: factor out worker_pool from global_cwq
Message-ID: <20120712170752.GC20167@google.com>
References: <1341859315-17759-1-git-send-email-tj@kernel.org>
	<1341859315-17759-3-git-send-email-tj@kernel.org>
	<87ehok8bmb.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87ehok8bmb.fsf@sejong.aot.lge.com>
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
To: Namhyung Kim <namhyung@kernel.org>
Cc: axboe@kernel.dk, elder@kernel.org, rni@google.com, martin.petersen@oracle.com, linux-bluetooth@vger.kernel.org, torvalds@linux-foundation.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, vwadekar@nvidia.com, swhiteho@redhat.com, herbert@gondor.hengli.com.au, bpm@sgi.com, linux-crypto@vger.kernel.org, gustavo@padovan.org, xfs@oss.sgi.com, joshhunt00@gmail.com, davem@davemloft.net, vgoyal@redhat.com, johan.hedberg@gmail.com

Hello, Namhyung.

Sorry about the delay.

On Tue, Jul 10, 2012 at 01:48:44PM +0900, Namhyung Kim wrote:
> > +	struct list_head	idle_list;	/* X: list of idle workers */
> > +	struct timer_list	idle_timer;	/* L: worker idle timeout */
> > +	struct timer_list	mayday_timer;	/* L: SOS timer for dworkers */
> 
> What is 'dworkers'?

My stupid finger pressing 'd' when I never meant to. :)

> > -	/* workers are chained either in the idle_list or busy_hash */
> > -	struct list_head	idle_list;	/* X: list of idle workers */
> > +	/* workers are chained either in busy_head or pool idle_list */
> 
> s/busy_head/busy_hash/ ?

Will fix.

Thanks.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
