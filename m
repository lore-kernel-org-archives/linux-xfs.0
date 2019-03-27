Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:31330 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727500AbfC0B3H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Mar 2019 21:29:07 -0400
Date: Wed, 27 Mar 2019 12:29:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [QUESTION] Long read latencies on mixed rw buffered IO
Message-ID: <20190327012903.GH23020@dastard>
References: <CAOQ4uxhu=Qtme9RJ7uZXYXt0UE+=xD+OC4gQ9EYkDC1ap8Hizg@mail.gmail.com>
 <20190325154731.GT1183@magnolia>
 <20190325164129.GH10344@bombadil.infradead.org>
 <CAOQ4uximHOCM8Fo_WctXAjpft31OS+VBcjUqteuK6kjn+nVoKA@mail.gmail.com>
 <20190325182239.GI10344@bombadil.infradead.org>
 <CAOQ4uxicH-f4TBx_anwWfTb=z6xDvV=dW3HFwG8+eKkqwKMuPw@mail.gmail.com>
 <20190325194021.GJ10344@bombadil.infradead.org>
 <CAOQ4uxiTRUe2EUYcuN5xi3SCw6C-=DM+yA1rsRKh_fi0YPEf6Q@mail.gmail.com>
 <20190325234838.GC23020@dastard>
 <CAOQ4uxh9gArhXZdSgOJgT12Ov9JYyPNoMf9H=h-Q-2vwcd8k=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxh9gArhXZdSgOJgT12Ov9JYyPNoMf9H=h-Q-2vwcd8k=Q@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, Mar 26, 2019 at 05:44:34AM +0200, Amir Goldstein wrote:
> On Tue, Mar 26, 2019 at 1:48 AM Dave Chinner <david@fromorbit.com> wrote:
> > On Mon, Mar 25, 2019 at 09:57:46PM +0200, Amir Goldstein wrote:
> > > Not as bad as v1. Only a little bit worse than master...
> > > The whole deal with the read/write balance and on SSD, I imagine
> > > the balance really changes. That's why I was skeptical about
> > > one-size-fits all read/write balance.
> >
> > You're not testing your SSD. You're testing writes into cache vs
> > reads from disk. There is a massive latency difference in the two
> > operations, so unless you use O_DSYNC for the writes, you are going
> > to see this cache-vs-uncached performance unbalance. i.e. unless the
> > rwsem is truly fair, there is always going to be more writer
> > access to the lock because they spend less time holding it and so
> > can put much more pressure on it.
> >
> 
> Yeh, I know. SSD makes the balance better because of faster reads
> from disk. Was pointing out that the worse case I am interested in is
> on spindles. That said, O_DSYNC certainly does improve the balance
> and gives shorter worse case latencies. However, it does not make the
> problem go away. i_rwsem taken (even for 4K reads) takes its toll
> on write latencies (compared to ext4).

Sure, that's because it's serialising access across the entire file,
not just the page that is being read/written to.

The solution here is to move to concurrent buffered writes
similar to how we do direct IO. We need to track IO ranges for that,
though, so we can serialise unaligned and/or overlapping IOs. We
need fast, efficient range locks for this, though.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
