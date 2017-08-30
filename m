Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:50047 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751317AbdH3OVg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 Aug 2017 10:21:36 -0400
Date: Wed, 30 Aug 2017 16:21:34 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: fix incorrect log_flushed on fsync
Message-ID: <20170830142134.GA650@lst.de>
References: <1504100302-3297-1-git-send-email-amir73il@gmail.com> <20170830134629.GA32355@lst.de> <CAOQ4uxhqjwZv+H=6RXai2_ap_1OktNje+DtHFR3ZoXoDtxuC0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhqjwZv+H=6RXai2_ap_1OktNje+DtHFR3ZoXoDtxuC0g@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J . Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Josef Bacik <jbacik@fb.com>, stable <stable@vger.kernel.org>

On Wed, Aug 30, 2017 at 05:12:10PM +0300, Amir Goldstein wrote:
> On Wed, Aug 30, 2017 at 4:46 PM, Christoph Hellwig <hch@lst.de> wrote:
> > Oops.
> >
> > Yes, except for the case of calling xlog_state_release_iclog
> > ourselves we can't claim that the cache has been flushed.  In
> > fact I'm not even sure that is save, if ic_refcnt makes
> > xlog_state_release_iclog exit early, so we might have to
> > pass additional information around there.
> 
> With this change, for the multiple fsyncing tasks workload, the majority won't
> be optimized, so the remaining code is only really optimizing the single
> process doing seldom fsync case.
> 
> I wonder if it's worth keeping the optimization around at all?

I think it is.  And we should get back to optimizing the multi-threaded
cases soon using something like a sequence counter that checks if we
issued a log sync after finishing the data writeback.
