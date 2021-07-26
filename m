Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69A0FC4338F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 22:16:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45C5560527
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 22:16:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233333AbhGZVfk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 17:35:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:54104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232875AbhGZVfh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Jul 2021 17:35:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCE8E6044F;
        Mon, 26 Jul 2021 22:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627337765;
        bh=TYqT0zZ1rTVdL7hjWVKy690jA7WQwmtfDCOAq/bW4no=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LTaLs8T+qffO7NeA/Ub0OGr2yI34CWSs3ubnsVBD1g81gsO9/XJmaIf1/RIUrof6z
         VGcKLRL6z0ON+JFV01vh5plikR+952EmBvAxT+duPC8cA49zlQGTsED57q3Oe+DUNY
         aP0S3RQPLfqZyUilkyc7UFVtrAPSoW3HSuXWVyYDz9Qpd2xK5mDmcxcSiUsPry+rAm
         xOiGb4iCDL0Tn8S82HfoYHZqahgcSCOOzt7LZNomszc9wU9uzmfzXigCfpxIDzhpgq
         C//UrvFiZyk2fb9L04pe5b3YE3byN6/fElAopjB9h67y4MD4kxJe3t4kf67wSl4z7i
         WETEU2Jc8YtLQ==
Date:   Mon, 26 Jul 2021 15:16:05 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/10] xfs: fix ordering violation between cache flushes
 and tail updates
Message-ID: <20210726221605.GC559212@magnolia>
References: <20210726060716.3295008-1-david@fromorbit.com>
 <20210726060716.3295008-5-david@fromorbit.com>
 <20210726173521.GB559142@magnolia>
 <20210726214449.GR664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726214449.GR664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 27, 2021 at 07:44:49AM +1000, Dave Chinner wrote:
> On Mon, Jul 26, 2021 at 10:35:21AM -0700, Darrick J. Wong wrote:
> > On Mon, Jul 26, 2021 at 04:07:10PM +1000, Dave Chinner wrote:
> > > --- a/fs/xfs/xfs_log.c
> > > +++ b/fs/xfs/xfs_log.c
> > > @@ -489,12 +489,20 @@ xfs_log_reserve(
> > >  
> > >  /*
> > >   * Flush iclog to disk if this is the last reference to the given iclog and the
> > > - * it is in the WANT_SYNC state.
> > > + * it is in the WANT_SYNC state. If the caller passes in a non-zero
> > 
> > I've noticed that the log code isn't always consistent about special
> > looking LSNs -- some places use NULLCOMMITLSN, some places opencode
> > (xfs_lsn_t)-1, and other code uses zero.  Is there some historical
> > reason for having these distinct values?  Or do they actually mean
> > separate things?
> 
> If depends on the use case. I resisted converting the (xfs_lsn_t)-1s
> in and around this patchset to NULLCOMMITLSN just to keep the noise
> down. Where-ever we use -1 as a LSN, we should really use
> NULLCOMMITLSN.

<nod> The -1 conversion is a pretty trivial cleanup that can go on the
end...

> As for comparing to zero, that works because we the LSN is largely
> unlikely to have 64 bit overflow in the lifetime of the journal. And
> if it does overflow, it's unlikely that we'll overflow exactly to
> (0,0) as a meaningful LSN.
> 
> However, I think we've probably got bigger problems around xfs_lsn_t
> overflowing, such as it being defined as signed rather than
> unsigned and I suspect that XFS_LSN_CMP() fails if we overflow LSNs
> back to zero and compare high cycle (old) with low cycle (new) LSNs.

Yes, I think so.

> So, really, right now I've ostriched this issue because I'm still
> trying to work throw g/482 failures and I suspect we need to change
> the definition of a LSN to fix these issues...

<nod> Ok.  I figured that this 0 vs. -1 stuff was most likely just
inconsistent usage, but thought I should ask just in case there was
some real functional reason that I wasn't aware of.

--D

> > > + * @old_tail_lsn, then we need to check if the log tail is different to the
> > > + * caller's value. If it is different, this indicates that the log tail has
> > > + * moved since the caller sampled the log tail and issued a cache flush and so
> > > + * there may be metadata on disk that we need to flush before this iclog is
> > 
> > "If the caller passes in a non-zero @old_tail_lsn and the current log
> > tail does not match, there may be metadata on disk that must be
> > persisted before this iclog is written.  To satisfy that requirement,
> > set the XLOG_ICL_NEED_FLUSH flag as a condition for writing this iclog
> > with the new log tail value." ?
> 
> Ok.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
