Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:48541 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726061AbfCYXsm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Mar 2019 19:48:42 -0400
Date: Tue, 26 Mar 2019 10:48:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [QUESTION] Long read latencies on mixed rw buffered IO
Message-ID: <20190325234838.GC23020@dastard>
References: <CAOQ4uxi0pGczXBX7GRAFs88Uw0n1ERJZno3JSeZR71S1dXg+2w@mail.gmail.com>
 <20190325001044.GA23020@dastard>
 <CAOQ4uxhu=Qtme9RJ7uZXYXt0UE+=xD+OC4gQ9EYkDC1ap8Hizg@mail.gmail.com>
 <20190325154731.GT1183@magnolia>
 <20190325164129.GH10344@bombadil.infradead.org>
 <CAOQ4uximHOCM8Fo_WctXAjpft31OS+VBcjUqteuK6kjn+nVoKA@mail.gmail.com>
 <20190325182239.GI10344@bombadil.infradead.org>
 <CAOQ4uxicH-f4TBx_anwWfTb=z6xDvV=dW3HFwG8+eKkqwKMuPw@mail.gmail.com>
 <20190325194021.GJ10344@bombadil.infradead.org>
 <CAOQ4uxiTRUe2EUYcuN5xi3SCw6C-=DM+yA1rsRKh_fi0YPEf6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiTRUe2EUYcuN5xi3SCw6C-=DM+yA1rsRKh_fi0YPEf6Q@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Mon, Mar 25, 2019 at 09:57:46PM +0200, Amir Goldstein wrote:
> On Mon, Mar 25, 2019 at 9:40 PM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Mon, Mar 25, 2019 at 09:18:51PM +0200, Amir Goldstein wrote:
> > > On Mon, Mar 25, 2019 at 8:22 PM Matthew Wilcox <willy@infradead.org> wrote:
> > > > On Mon, Mar 25, 2019 at 07:30:39PM +0200, Amir Goldstein wrote:
> > > > > On Mon, Mar 25, 2019 at 6:41 PM Matthew Wilcox <willy@infradead.org> wrote:
> > > > > > I think it is a bug that we only wake readers at the front of the queue;
> > > > > > I think we would get better performance if we wake all readers.  ie here:
> > >
> > > So I have no access to the test machine of former tests right now,
> > > but when running the same filebench randomrw workload
> > > (8 writers, 8 readers) on VM with 2 CPUs and SSD drive, results
> > > are not looking good for this patch:
> > >
> > > --- v5.1-rc1 / xfs ---
> > > rand-write1          852404ops    14202ops/s 110.9mb/s      0.6ms/op
> > > [0.01ms - 553.45ms]
> > > rand-read1           26117ops      435ops/s   3.4mb/s     18.4ms/op
> > > [0.04ms - 632.29ms]
> > > 61.088: IO Summary: 878521 ops 14636.774 ops/s 435/14202 rd/wr
> > > 114.3mb/s   1.1ms/op
> > >
> 
> --- v5.1-rc1 / xfs + patch v2 below ---
> rand-write1          852487ops    14175ops/s 110.7mb/s      0.6ms/op
> [0.01ms - 755.24ms]
> rand-read1           23194ops      386ops/s   3.0mb/s     20.7ms/op
> [0.03ms - 755.25ms]
> 61.187: IO Summary: 875681 ops 14560.980 ops/s 386/14175 rd/wr
> 113.8mb/s   1.1ms/op
> 
> Not as bad as v1. Only a little bit worse than master...
> The whole deal with the read/write balance and on SSD, I imagine
> the balance really changes. That's why I was skeptical about
> one-size-fits all read/write balance.

You're not testing your SSD. You're testing writes into cache vs
reads from disk. There is a massive latency difference in the two
operations, so unless you use O_DSYNC for the writes, you are going
to see this cache-vs-uncached performance unbalance. i.e. unless the
rwsem is truly fair, there is always going to be more writer
access to the lock because they spend less time holding it and so
can put much more pressure on it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
