Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 24 Aug 2008 09:58:53 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7OGwGAH014408
	for <xfs@oss.sgi.com>; Sun, 24 Aug 2008 09:58:16 -0700
Received: from mail.screens.ru (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9DBB6FAE441
	for <xfs@oss.sgi.com>; Sun, 24 Aug 2008 09:59:37 -0700 (PDT)
Received: from mail.screens.ru (x346.tv-sign.ru [89.108.83.215]) by cuda.sgi.com with ESMTP id nKCoONIdWMSxqgr0 for <xfs@oss.sgi.com>; Sun, 24 Aug 2008 09:59:37 -0700 (PDT)
Date: Sun, 24 Aug 2008 21:03:57 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH 3/3] Add timeout feature
Message-ID: <20080824170357.GC3792@tv-sign.ru>
References: <20080818212856t-sato@mail.jp.nec.com> <20080821132006.9949101c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080821132006.9949101c.akpm@linux-foundation.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Takashi Sato <t-sato@yk.jp.nec.com>, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, axboe@kernel.dk, mtk.manpages@googlemail.com, linux-kernel@vger.kernel.org

On 08/21, Andrew Morton wrote:
>
> On Mon, 18 Aug 2008 21:28:56 +0900
> Takashi Sato <t-sato@yk.jp.nec.com> wrote:
>
> > +void del_freeze_timeout(struct block_device *bdev)
> > +{
> > +	/*
> > +	 * It's possible that the delayed work task (freeze_timeout()) calls
> > +	 * del_freeze_timeout().  If the delayed work task calls
> > +	 * cancel_delayed_work_sync((), the deadlock will occur.
> > +	 * So we need this check (delayed_work_pending()).
> > +	 */
> > +	if (delayed_work_pending(&bdev->bd_freeze_timeout))
> > +		cancel_delayed_work_sync(&bdev->bd_freeze_timeout);
> > +}

I don't understand this patch, but the code above looks strange to me...

Let's suppose del_freeze_timeout() is called by ioctl_thaw()->thaw_bdev().
Now,

	IF delayed_work_pending() == T

		we can deadlock if the timer expires before
		cancel_delayed_work_sync() cancels it?
		in that case we are going to wait for this work,
		but freeze_timeout()->thaw_bdev() will block
		on ->bd_freeze_sem, no?

	ELSE

		we don't really flush the work, it is possible
		the timer has already expired and the work
		is pending. It will run later.

Perhaps this all is correct, but in that case, why can't we just do

	void del_freeze_timeout(struct block_device *bdev)
	{
		cancel_delayed_work(&bdev->bd_freeze_timeout);
	}

?

> Perhaps cancel_delayed_work_sync() shouldn't hang up if called from the
> work handler?

This is trivial,

	--- kernel/workqueue.c
	+++ kernel/workqueue.c
	@@ -516,6 +516,9 @@ static void wait_on_cpu_work(struct cpu_
		struct wq_barrier barr;
		int running = 0;
	 
	+	if (cwq->thread == current)
	+		return;
	+
		spin_lock_irq(&cwq->lock);
		if (unlikely(cwq->current_work == work)) {
			insert_wq_barrier(cwq, &barr, cwq->worklist.next);

but do we really need this?

We have a similar hack in flush_cpu_workqueue(), and we are going
to kill it once we fix the callers.

I dunno.

Oleg.
