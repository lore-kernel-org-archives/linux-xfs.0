Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:37045 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751019AbdJTGfK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Oct 2017 02:35:10 -0400
Date: Fri, 20 Oct 2017 08:34:36 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RESEND PATCH 1/3] completion: Add support for initializing
 completion with lockdep_map
In-Reply-To: <1508455438.4542.4.camel@wdc.com>
Message-ID: <alpine.DEB.2.20.1710200829340.3083@nanos>
References: <1508319532-24655-1-git-send-email-byungchul.park@lge.com>  <1508319532-24655-2-git-send-email-byungchul.park@lge.com> <1508455438.4542.4.camel@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "mingo@kernel.org" <mingo@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, "byungchul.park@lge.com" <byungchul.park@lge.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "amir73il@gmail.com" <amir73il@gmail.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "oleg@redhat.com" <oleg@redhat.com>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>, "johannes.berg@intel.com" <johannes.berg@intel.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "idryomov@gmail.com" <idryomov@gmail.com>, "tj@kernel.org" <tj@kernel.org>, "kernel-team@lge.com" <kernel-team@lge.com>, "david@fromorbit.com" <david@fromorbit.com>

On Thu, 19 Oct 2017, Bart Van Assche wrote:
> On Wed, 2017-10-18 at 18:38 +0900, Byungchul Park wrote:
> > Sometimes, we want to initialize completions with sparate lockdep maps
> > to assign lock classes under control. For example, the workqueue code
> > manages lockdep maps, as it can classify lockdep maps properly.
> > Provided a function for that purpose.
> > 
> > Signed-off-by: Byungchul Park <byungchul.park@lge.com>
> > ---
> >  include/linux/completion.h | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/include/linux/completion.h b/include/linux/completion.h
> > index cae5400..182d56e 100644
> > --- a/include/linux/completion.h
> > +++ b/include/linux/completion.h
> > @@ -49,6 +49,13 @@ static inline void complete_release_commit(struct completion *x)
> >  	lock_commit_crosslock((struct lockdep_map *)&x->map);
> >  }
> >  
> > +#define init_completion_with_map(x, m)					\
> > +do {									\
> > +	lockdep_init_map_crosslock((struct lockdep_map *)&(x)->map,	\
> > +			(m)->name, (m)->key, 0);				\
> > +	__init_completion(x);						\
> > +} while (0)
> 
> Are there any completion objects for which the cross-release checking is
> useful?

All of them by definition.

> Are there any wait_for_completion() callers that hold a mutex or
> other locking object?

Yes, there are also cross completion dependencies. There have been such
bugs and I expect more to be unearthed.

I really have to ask what your motiviation is to fight the lockdep coverage
of synchronization objects tooth and nail?

Thanks,

	tglx
