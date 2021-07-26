Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2752C4338F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 21:44:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B13A60F94
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 21:44:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbhGZVEZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 17:04:25 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:44993 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229489AbhGZVEZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jul 2021 17:04:25 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 4A3B780C68B;
        Tue, 27 Jul 2021 07:44:51 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m88P3-00B8pv-V7; Tue, 27 Jul 2021 07:44:49 +1000
Date:   Tue, 27 Jul 2021 07:44:49 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/10] xfs: fix ordering violation between cache flushes
 and tail updates
Message-ID: <20210726214449.GR664593@dread.disaster.area>
References: <20210726060716.3295008-1-david@fromorbit.com>
 <20210726060716.3295008-5-david@fromorbit.com>
 <20210726173521.GB559142@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726173521.GB559142@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=kj9zAlcOel0A:10 a=e_q4qTt1xDgA:10 a=7-415B0cAAAA:8
        a=NMtYZnGg6YAXmKFUr7oA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 26, 2021 at 10:35:21AM -0700, Darrick J. Wong wrote:
> On Mon, Jul 26, 2021 at 04:07:10PM +1000, Dave Chinner wrote:
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -489,12 +489,20 @@ xfs_log_reserve(
> >  
> >  /*
> >   * Flush iclog to disk if this is the last reference to the given iclog and the
> > - * it is in the WANT_SYNC state.
> > + * it is in the WANT_SYNC state. If the caller passes in a non-zero
> 
> I've noticed that the log code isn't always consistent about special
> looking LSNs -- some places use NULLCOMMITLSN, some places opencode
> (xfs_lsn_t)-1, and other code uses zero.  Is there some historical
> reason for having these distinct values?  Or do they actually mean
> separate things?

If depends on the use case. I resisted converting the (xfs_lsn_t)-1s
in and around this patchset to NULLCOMMITLSN just to keep the noise
down. Where-ever we use -1 as a LSN, we should really use
NULLCOMMITLSN.

As for comparing to zero, that works because we the LSN is largely
unlikely to have 64 bit overflow in the lifetime of the journal. And
if it does overflow, it's unlikely that we'll overflow exactly to
(0,0) as a meaningful LSN.

However, I think we've probably got bigger problems around xfs_lsn_t
overflowing, such as it being defined as signed rather than
unsigned and I suspect that XFS_LSN_CMP() fails if we overflow LSNs
back to zero and compare high cycle (old) with low cycle (new) LSNs.

So, really, right now I've ostriched this issue because I'm still
trying to work throw g/482 failures and I suspect we need to change
the definition of a LSN to fix these issues...

> > + * @old_tail_lsn, then we need to check if the log tail is different to the
> > + * caller's value. If it is different, this indicates that the log tail has
> > + * moved since the caller sampled the log tail and issued a cache flush and so
> > + * there may be metadata on disk that we need to flush before this iclog is
> 
> "If the caller passes in a non-zero @old_tail_lsn and the current log
> tail does not match, there may be metadata on disk that must be
> persisted before this iclog is written.  To satisfy that requirement,
> set the XLOG_ICL_NEED_FLUSH flag as a condition for writing this iclog
> with the new log tail value." ?

Ok.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
