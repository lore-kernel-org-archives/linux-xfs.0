Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:3568 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751821AbdEDAiA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 May 2017 20:38:00 -0400
Date: Thu, 4 May 2017 10:37:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xlog_write: reservation ran out
Message-ID: <20170504003755.GD17542@dastard>
References: <CAF1ivSZeYhnzh6CPZViYUNFXdm33hhTA_CzP7V745QociEEnKg@mail.gmail.com>
 <CAF1ivSbjdixqDo663wvAEkzRk-ctOX+y5UYxq4UdPA-=JVufyw@mail.gmail.com>
 <CAF1ivSbEfhTYxcBx1dafK9TD3VdeXbJrNMzWJmXY8kyU0ibkUw@mail.gmail.com>
 <8accf9d5-b2e4-c82e-fa47-3c5bc2ea35b1@kernel.org>
 <20170501131222.GA2109@bfoster.bfoster>
 <70def595-91a9-970a-d227-547055da5bb5@kernel.org>
 <20170502235152.GN12369@dastard>
 <20170503141030.GA11549@bfoster.bfoster>
 <20170503155335.GF5973@birch.djwong.org>
 <20170503161508.GA12343@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170503161508.GA12343@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Ming Lin <mlin@kernel.org>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Ceph Development <ceph-devel@vger.kernel.org>, "LIU, Fei" <james.liu@alibaba-inc.com>, xiongwei.jiang@alibaba-inc.com, boqian.zy@alibaba-inc.com, sheng.qiu@alibaba-inc.com, Sage Weil <sweil@redhat.com>

On Wed, May 03, 2017 at 12:15:10PM -0400, Brian Foster wrote:
> On Wed, May 03, 2017 at 08:53:35AM -0700, Darrick J. Wong wrote:
> > On Wed, May 03, 2017 at 10:10:32AM -0400, Brian Foster wrote:
> > > the caller. Hmm, thinking more about it, I suppose we could just add
> > > another similar helper since we'd presumably want to process the list of
> > > items again if the reservation is overrun. Thoughts?
> > 
> > Process them again how?  I think I'm missing something here; are you
> > saying that we could (try to) get more reservation if allocating the
> > shadow buffer shows that we've run over?
> > 
> 
> No, poor choice of words.. s/process/iterate/.
> 
> I just mean that we may want another helper since we'd have to iterate
> the list of tp items potentially twice: first to calculate the total
> size, again to dump whatever info we want if the total overruns the
> reservation.

xlog_cil_insert_format_items() already calculates the total size
when doing the formatting of the log items into log vectors (i.e.
the returned len value) - we use it later in xlog_cil_insert_items()
to do the ticket reservation accounting.

So there's no additional overhead for detecting an overrun earlier
than we already do, and we don't care about the overhead of dumping
the transaction info if an overrun is detected...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
