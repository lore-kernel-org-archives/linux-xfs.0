Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3791CC4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 23:13:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09EA160EB2
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 23:13:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbhGVWdM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Jul 2021 18:33:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:33654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232462AbhGVWdM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Jul 2021 18:33:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95AAE60E8F;
        Thu, 22 Jul 2021 23:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626995626;
        bh=H5NcHQQ4NlL49KKSLbslzNSmpoIaRqI60so1Oc/26QY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OQ1NLM6JC5dtm5KTFddBgvYhoGig6UfNMSr9AF6QdYqqScLRH6wxuD/dq4MpoE+3B
         gd/QRqT63W+fAXVIsqOeiTiMdiIoodynDsOHvFXb2bai2ODQVz+JKRqezKFnnK1+MU
         EQwn8tg2FfcTaeCMPKsCuFYFWiP2t3sA6Gem/9/RXj6HwLMhv87HNLcs5mvununrLJ
         El2srzsNBJHgwfED1EJixOZH50SSK2dE0V+u5XC2GoANhLnITy205DQhqW5+auE36R
         M24Abkn4SZVdZamqb7YI6LCbXdDCFa4JzyymxAK/o35u47apar9qgeWDcK+NaDxUSc
         Stc4pu5M1XXcg==
Date:   Thu, 22 Jul 2021 16:13:46 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: log forces imply data device cache flushes
Message-ID: <20210722231346.GP559212@magnolia>
References: <20210722015335.3063274-1-david@fromorbit.com>
 <20210722015335.3063274-5-david@fromorbit.com>
 <20210722193018.GL559212@magnolia>
 <20210722221258.GQ664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722221258.GQ664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 23, 2021 at 08:12:58AM +1000, Dave Chinner wrote:
> On Thu, Jul 22, 2021 at 12:30:18PM -0700, Darrick J. Wong wrote:
> > On Thu, Jul 22, 2021 at 11:53:34AM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > After fixing the tail_lsn vs cache flush race, generic/482 continued
> > > to fail in a similar way where cache flushes were missing before
> > > iclog FUA writes. Tracing of iclog state changes during the fsstress
> > 
> > Heh. ;)
> ....
> > > +		 * xlog_cil_force_seq() call, but there are other writers still
> > > +		 * accessing it so it hasn't been pushed to disk yet. Like the
> > > +		 * ACTIVE case above, we need to make sure caches are flushed
> > > +		 * when this iclog is written.
> > > +		 */
> > > +		iclog->ic_flags |= XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA;
> > > +		if (log_flushed)
> > > +			*log_flushed = 1;
> > > +		break;
> > > +	default:
> > > +		/*
> > > +		 * The entire checkpoint was written by the CIL force and is on
> > > +		 * it's way to disk already. It will be stable when it
> > 
> > s/it's/its/
> > 
> > So now that we're at the end of this series, what are the rules for when
> > when issue cache flushes and FUA writes?
> > 
> > - Writing the unmount record always flushes the data and log devices.
> >   Does it need to flush the rt device too?  I guess xfs_free_buftarg
> >   does that.
> 
> Correct. RT device behaviour is unchanged as it only contains data
> and data is already guaranteed to be on stable storage before we
> write the unmount record.
> 
> > - Start an async flush of the data device when doing CIL push work so
> >   that anything the AIL wrote to disk (and pushed the tail) is persisted
> >   before we assign a tail to the log record that we write at the end?
> > 
> > - If any other AIL work completes (and pushes the tail ahead) by the
> >   time we actually write the log record, flush the data device a second
> >   time?
> 
> Yes.
> 
> > - If a log checkpoint spans multiple iclogs, flush the *log* device
> >   before writing the iclog with the commit record in it.
> 
> Yes. And for internal logs we have the natural optimisation that
> these two cases are handled by same cache flush and so for large
> checkpoints on internal logs we don't see lot tail update races.
> 
> > - Any time we write an iclog that commits a checkpoint, write that
> >   record with FUA to ensure it's persisted.
> 
> *nod*
> 
> > - If we're forcing the log to disk as part of an integrity operation
> >   (fsync, syncfs, etc.) then issue cache flushes for ... each? iclog
> >   written to disk?  And use FUA for that write too?
> 
> This is where it gets messy, because log forces are not based around
> checkpoint completions. Hence we have no idea what is actually in
> the iclog we are flushing and so must treat them all as if they
> contain a commit record, close off a multi-iclog checkpoint, and
> might have raced with a log tail update. We don't know - and can't
> know from the iclog state - which conditions exist and so we have to
> assume that at least one of the above states exist for any ACTIVE or
> WANT_SYNC iclog we end flushing or up waiting on.
> 
> If the iclog is already on it's way to disk, and it contains a
> commit record, then the cache flush requirements for
> metadata/journal ordering have already been met and we don't need to
> do anything other than wait. But if we have to flush the iclog or
> wait for a flush by a third party, we need to ensure that cache
> flushes occur so that the log force semantics are upheld.
> 
> If the iclog doesn't contain a commit record (i.e. a log force in
> the middle of a new, racing checkpoint write) we don't actually care
> if the iclog contains flushes or not, because a crash immediately
> after the log force won't actually recover the checkpoint contained
> in that iclog. From the log force perspective, the iclog contains
> future changes, so we don't care about whether it can be recovered.
> But we don't know this, so we have to issue cache flushes on every
> iclog we flush from the log force code.
> 
> This is why I mentioned that the log force code needs to be turned
> inside out to guarantee CIL checkpoints are flushed and stable
> rather than iclogs. We care about whole checkpoints being
> recoverable, not whether some random iclog in the middle of a
> checkpoint write is stable....

<nod> Ok, that's kinda what I thought -- the first few "where do we
flush?" cases were pretty straightforward, and the last one is murky.

With all the random little changes applied,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
