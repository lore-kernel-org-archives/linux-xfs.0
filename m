Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BB40C433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Apr 2021 02:05:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1ED7E611B0
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Apr 2021 02:05:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbhDOCFt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Apr 2021 22:05:49 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:48290 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229449AbhDOCFr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Apr 2021 22:05:47 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 4C0FC1043F1E;
        Thu, 15 Apr 2021 12:05:21 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lWrNg-008UKw-J2; Thu, 15 Apr 2021 12:05:20 +1000
Date:   Thu, 15 Apr 2021 12:05:20 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        Ted Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
        Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 2/7] mm: Protect operations adding pages to page cache
 with i_mapping_lock
Message-ID: <20210415020520.GI63242@dread.disaster.area>
References: <20210413105205.3093-1-jack@suse.cz>
 <20210413112859.32249-2-jack@suse.cz>
 <20210414000113.GG63242@dread.disaster.area>
 <20210414222531.GZ2531743@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210414222531.GZ2531743@casper.infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_f
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=3YhXtTcJ-WEA:10 a=7-415B0cAAAA:8
        a=8hQybC9s4a2M7SgXXjwA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 14, 2021 at 11:25:31PM +0100, Matthew Wilcox wrote:
> On Wed, Apr 14, 2021 at 10:01:13AM +1000, Dave Chinner wrote:
> > > +	if (iocb->ki_flags & IOCB_NOWAIT) {
> > > +		if (!down_read_trylock(&mapping->host->i_mapping_sem))
> > > +			return -EAGAIN;
> > > +	} else {
> > > +		down_read(&mapping->host->i_mapping_sem);
> > > +	}
> > 
> > We really need a lock primitive for this. The number of times this
> > exact lock pattern is being replicated all through the IO path is
> > getting out of hand.
> > 
> > static inline bool
> > down_read_try_or_lock(struct rwsem *sem, bool try)
> > {
> > 	if (try) {
> > 		if (!down_read_trylock(sem))
> > 			return false;
> > 	} else {
> > 		down_read(&mapping->host->i_mapping_sem);
> > 	}
> > 	return true;
> > }
> > 
> > and the callers become:
> > 
> > 	if (!down_read_try_or_lock(sem, (iocb->ki_flags & IOCB_NOWAIT)))
> > 		return -EAGAIN;
> 
> I think that should be written:
> 
> 	if (!iocb_read_lock(iocb, &rwsem))
> 		return -EAGAIN;
> 
> and implemented as:
> 
> static inline int iocb_read_lock(struct kiocb *iocb, struct rwsem *sem)
> {
> 	if (iocb->ki_flags & IOCB_NOWAIT)
> 		return down_read_trylock(sem) ? 0 : -EAGAIN;
> 	return down_read_killable(sem);
> }

Yup, we already have done that with xfs_ilock_iocb(), but my point
is that this "non blocking try lock or lock" pattern is slowly being
used in more places than just IOCB_NOWAIT situations.  e.g. We use
if for IOMAP_NOWAIT locking in XFS, too, and ISTR other places where
optimisitic locking is used are replicating it, too.

Hence my suggestion that is moved up into the locking primitives,
not merely have context specific wrappers added...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
