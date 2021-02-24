Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C19AC433E6
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 22:20:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA48664F03
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 22:20:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234669AbhBXWT7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 17:19:59 -0500
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:57538 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233615AbhBXWT5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Feb 2021 17:19:57 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id D81694AC0B6;
        Thu, 25 Feb 2021 09:19:13 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lF2Uz-002mn3-3x; Thu, 25 Feb 2021 09:19:13 +1100
Date:   Thu, 25 Feb 2021 09:19:13 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: xfs_log_force_lsn isn't passed a LSN
Message-ID: <20210224221913.GG4662@dread.disaster.area>
References: <20210223053212.3287398-1-david@fromorbit.com>
 <20210223053212.3287398-2-david@fromorbit.com>
 <20210224214235.GB7272@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224214235.GB7272@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=-aq6U8YYFRYAOWX8eF8A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 24, 2021 at 01:42:35PM -0800, Darrick J. Wong wrote:
> On Tue, Feb 23, 2021 at 04:32:10PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > In doing an investigation into AIL push stalls, I was looking at the
> > log force code to see if an async CIL push could be done instead.
> > This lead me to xfs_log_force_lsn() and looking at how it works.
> > 
> > xfs_log_force_lsn() is only called from inode synchronisation
> > contexts such as fsync(), and it takes the ip->i_itemp->ili_last_lsn
> > value as the LSN to sync the log to. This gets passed to
> > xlog_cil_force_lsn() via xfs_log_force_lsn() to flush the CIL to the
> > journal, and then used by xfs_log_force_lsn() to flush the iclogs to
> > the journal.
> > 
> > The problem with is that ip->i_itemp->ili_last_lsn does not store a
> > log sequence number. What it stores is passed to it from the
> > ->iop_committing method, which is called by xfs_log_commit_cil().
> > The value this passes to the iop_committing method is the CIL
> > context sequence number that the item was committed to.
> > 
> > As it turns out, xlog_cil_force_lsn() converts the sequence to an
> > actual commit LSN for the related context and returns that to
> > xfs_log_force_lsn(). xfs_log_force_lsn() overwrites it's "lsn"
> > variable that contained a sequence with an actual LSN and then uses
> > that to sync the iclogs.
> > 
> > This caused me some confusion for a while, even though I originally
> > wrote all this code a decade ago. ->iop_committing is only used by
> > a couple of log item types, and only inode items use the sequence
> > number it is passed.
> > 
> > Let's clean up the API, CIL structures and inode log item to call it
> > a sequence number, and make it clear that the high level code is
> > using CIL sequence numbers and not on-disk LSNs for integrity
> > synchronisation purposes.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_buf_item.c   |  2 +-
> >  fs/xfs/xfs_dquot_item.c |  2 +-
> >  fs/xfs/xfs_file.c       | 14 +++++++-------
> >  fs/xfs/xfs_inode.c      | 10 +++++-----
> >  fs/xfs/xfs_inode_item.c |  4 ++--
> >  fs/xfs/xfs_inode_item.h |  2 +-
> >  fs/xfs/xfs_log.c        | 27 ++++++++++++++-------------
> >  fs/xfs/xfs_log.h        |  4 +---
> >  fs/xfs/xfs_log_cil.c    | 22 +++++++++-------------
> >  fs/xfs/xfs_log_priv.h   | 15 +++++++--------
> >  fs/xfs/xfs_trans.c      |  6 +++---
> >  fs/xfs/xfs_trans.h      |  4 ++--
> >  12 files changed, 53 insertions(+), 59 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> > index 14d1fefcbf4c..7affe1aa16da 100644
> > --- a/fs/xfs/xfs_buf_item.c
> > +++ b/fs/xfs/xfs_buf_item.c
> > @@ -713,7 +713,7 @@ xfs_buf_item_release(
> >  STATIC void
> >  xfs_buf_item_committing(
> >  	struct xfs_log_item	*lip,
> > -	xfs_lsn_t		commit_lsn)
> > +	uint64_t		seq)
> 
> FWIW I rather wish you'd defined a new type for cil sequence numbers,
> since uint64_t is rather generic.  Even if checkpatch whines about new
> typedefs.

I don't use checkpatch so I don't care about all the idiotic
"crusade of the month" stuff it is always whining about.

> I was kind of hoping that we'd be able to mark xfs_lsn_t and xfs_csn_t
> with __bitwise and so static checkers could catch us if we accidentally
> feed a CIL sequence number into a function that wants an LSN.

Seems reasonable to hide that behind a typedef. No idea how to set
it up and test it, though, and I don't really have time right now.
I'll change it to a typedef to make this easier to do in future,
though.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
