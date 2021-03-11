Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7B82C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 00:27:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F99F64F60
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 00:27:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhCKA07 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 19:26:59 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:58888 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229469AbhCKA0x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Mar 2021 19:26:53 -0500
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id AE7161041501;
        Thu, 11 Mar 2021 11:26:51 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lK9AA-0015TI-Od; Thu, 11 Mar 2021 11:26:50 +1100
Date:   Thu, 11 Mar 2021 11:26:50 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/45] xfs: xfs_log_force_lsn isn't passed a LSN
Message-ID: <20210311002650.GI74031@dread.disaster.area>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-14-david@fromorbit.com>
 <20210308225323.GC3419940@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210308225323.GC3419940@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=8sW1GVqKNP7xTGBV9vAA:9 a=O1UWmIow-zpmdros:21 a=717Eqq53xCl6LaaL:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 08, 2021 at 02:53:23PM -0800, Darrick J. Wong wrote:
> On Fri, Mar 05, 2021 at 04:11:11PM +1100, Dave Chinner wrote:
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
> >  fs/xfs/libxfs/xfs_types.h |  1 +
> >  fs/xfs/xfs_buf_item.c     |  2 +-
> >  fs/xfs/xfs_dquot_item.c   |  2 +-
> >  fs/xfs/xfs_file.c         | 14 +++++++-------
> >  fs/xfs/xfs_inode.c        | 10 +++++-----
> >  fs/xfs/xfs_inode_item.c   |  4 ++--
> >  fs/xfs/xfs_inode_item.h   |  2 +-
> >  fs/xfs/xfs_log.c          | 27 ++++++++++++++-------------
> >  fs/xfs/xfs_log.h          |  4 +---
> >  fs/xfs/xfs_log_cil.c      | 22 +++++++++-------------
> >  fs/xfs/xfs_log_priv.h     | 15 +++++++--------
> >  fs/xfs/xfs_trans.c        |  6 +++---
> >  fs/xfs/xfs_trans.h        |  4 ++--
> >  13 files changed, 54 insertions(+), 59 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> > index 064bd6e8c922..0870ef6f933d 100644
> > --- a/fs/xfs/libxfs/xfs_types.h
> > +++ b/fs/xfs/libxfs/xfs_types.h
> > @@ -21,6 +21,7 @@ typedef int32_t		xfs_suminfo_t;	/* type of bitmap summary info */
> >  typedef uint32_t	xfs_rtword_t;	/* word type for bitmap manipulations */
> >  
> >  typedef int64_t		xfs_lsn_t;	/* log sequence number */
> > +typedef int64_t		xfs_csn_t;	/* CIL sequence number */
> 
> I'm unfamiliar with the internal format of CIL sequence numbers.  Do
> they have the same cycle:offset segmented structure as LSNs do?  Or are
> they a simple linear integer that increases as we checkpoint committed
> items?

Monotonic increasing integer, only ever used in memory and never
written to disk.

> 
> Looking through the current code, I see a couple of places where we
> initialize them to 1, and I also see that when we create a new cil
> context we set its sequence to one more than the context that it will
> replace.
> 
> I also see a bunch of comparisons of cil context sequence numbers that
> use standard integer operators, but then I also see one instance of:
> 
> 	if (XFS_LSN_CMP(lip->li_seq, ctx->sequence) != 0)
> 		return false;
> 	return true
> 
> in xfs_log_item_in_current_chkpt.  AFAICT this could be replaced with a
> simple:
> 
> 	return lip->li_seq == ctx->sequence;

Yup, missed that, will fix.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
