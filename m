Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:37282 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729489AbfCYSWr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Mar 2019 14:22:47 -0400
Date: Mon, 25 Mar 2019 11:22:39 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [QUESTION] Long read latencies on mixed rw buffered IO
Message-ID: <20190325182239.GI10344@bombadil.infradead.org>
References: <CAOQ4uxi0pGczXBX7GRAFs88Uw0n1ERJZno3JSeZR71S1dXg+2w@mail.gmail.com>
 <20190325001044.GA23020@dastard>
 <CAOQ4uxhu=Qtme9RJ7uZXYXt0UE+=xD+OC4gQ9EYkDC1ap8Hizg@mail.gmail.com>
 <20190325154731.GT1183@magnolia>
 <20190325164129.GH10344@bombadil.infradead.org>
 <CAOQ4uximHOCM8Fo_WctXAjpft31OS+VBcjUqteuK6kjn+nVoKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uximHOCM8Fo_WctXAjpft31OS+VBcjUqteuK6kjn+nVoKA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Mon, Mar 25, 2019 at 07:30:39PM +0200, Amir Goldstein wrote:
> On Mon, Mar 25, 2019 at 6:41 PM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Mon, Mar 25, 2019 at 08:47:31AM -0700, Darrick J. Wong wrote:
> > > Hmmm.... so it looks like the rw_semaphore behavior has shifted over
> > > time, then?
> >
> > Yes.
> >
> > > I thought rwsem was supposed to queue read and write waiters in order,
> > > at least on x86?  Though I suppose that might not matter much since we
> > > can only run one writer at a time vs. waking up all the readers at once.
> > > Now I'm wondering if there ever was a time when the readers all got
> > > batched to the front and starved the writers, but eh I haven't drank
> > > enough coffee to remember things like that. :P
> > >
> > > (I wonder what would happen if rw_semaphore decided to wake up some
> > > number of the readers in the rwsem wait_list, not just the ones at the
> > > front...)
> >
> > rwsems currently allow a limited amount of queue-jumping; if a semaphore
> > is currently not acquired (it's in transition between two owners), a
> > running process can acquire it.
> >
> > I think it is a bug that we only wake readers at the front of the queue;
> > I think we would get better performance if we wake all readers.  ie here:
> >
> >         /*
> > -        * Grant an infinite number of read locks to the readers at the front
> > -        * of the queue. We know that woken will be at least 1 as we accounted
> > +        * Grant an infinite number of read locks.  We know that woken will
> > +        * be at least 1 as we accounted
> >          * for above. Note we increment the 'active part' of the count by the
> >          * number of readers before waking any processes up.
> >          */
> >         list_for_each_entry_safe(waiter, tmp, &sem->wait_list, list) {
> >                 struct task_struct *tsk;
> >
> > -               if (waiter->type == RWSEM_WAITING_FOR_WRITE)
> > -                       break;
> >
> > Amir, it seems like you have a good test-case for trying this out ...
> 
> Sure, but please explain. Why are you waking up the writers?

Oh ... duh.  I didn't mean to wake up the writers.  I meant ...

               if (waiter->type == RWSEM_WAITING_FOR_WRITE)
-			break;
+			continue;
