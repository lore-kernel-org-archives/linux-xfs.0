Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:53874 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752059AbdJYGfQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Oct 2017 02:35:16 -0400
Date: Wed, 25 Oct 2017 08:35:12 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v4 6/7] workqueue: Remove unnecessary acquisitions wrt
 workqueue flush
Message-ID: <20171025063512.qvdwo4q7hakeiwqf@gmail.com>
References: <1508908272-15757-1-git-send-email-byungchul.park@lge.com>
 <1508908272-15757-7-git-send-email-byungchul.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1508908272-15757-7-git-send-email-byungchul.park@lge.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Byungchul Park <byungchul.park@lge.com>
Cc: peterz@infradead.org, axboe@kernel.dk, johan@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org, linux-mm@kvack.org, tj@kernel.org, johannes.berg@intel.com, oleg@redhat.com, amir73il@gmail.com, david@fromorbit.com, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, hch@infradead.org, idryomov@gmail.com, kernel-team@lge.com


* Byungchul Park <byungchul.park@lge.com> wrote:

> The workqueue added manual acquisitions to catch deadlock cases.
> Now crossrelease was introduced, some of those are redundant, since
> wait_for_completion() already includes the acquisition for itself.
> Removed it.
> 
> Signed-off-by: Byungchul Park <byungchul.park@lge.com>
> ---
>  include/linux/workqueue.h |  4 ++--
>  kernel/workqueue.c        | 19 +++----------------
>  2 files changed, 5 insertions(+), 18 deletions(-)
> 
> diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
> index f3c47a0..1455b5e 100644
> --- a/include/linux/workqueue.h
> +++ b/include/linux/workqueue.h
> @@ -218,7 +218,7 @@ static inline void destroy_delayed_work_on_stack(struct delayed_work *work) { }
>  									\
>  		__init_work((_work), _onstack);				\
>  		(_work)->data = (atomic_long_t) WORK_DATA_INIT();	\
> -		lockdep_init_map(&(_work)->lockdep_map, #_work, &__key, 0); \
> +		lockdep_init_map(&(_work)->lockdep_map, "(complete)"#_work, &__key, 0); \

This has a similar naming problem as the block bits: should be "wq_completion" or 
such.

Thanks,

	Ingo
