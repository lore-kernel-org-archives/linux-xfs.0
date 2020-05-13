Return-Path: <SRS0=Dhh5=63=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9301C2D0F8
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 00:38:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9002A20769
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 00:38:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729215AbgEMAid (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 20:38:33 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:33841 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728131AbgEMAic (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 20:38:32 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id DE61B8212FB;
        Wed, 13 May 2020 10:38:28 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jYfPl-0001GK-87; Wed, 13 May 2020 10:38:25 +1000
Date:   Wed, 13 May 2020 10:38:25 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: use ordered buffers to initialize dquot buffers
 during quotacheck
Message-ID: <20200513003825.GZ2040@dread.disaster.area>
References: <20200512210033.GL6714@magnolia>
 <20200513000628.GY2040@dread.disaster.area>
 <20200513002548.GB1984748@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513002548.GB1984748@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=7-415B0cAAAA:8
        a=VCvzmZQYKo8OmiEhw0EA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 12, 2020 at 05:25:48PM -0700, Darrick J. Wong wrote:
> On Wed, May 13, 2020 at 10:06:28AM +1000, Dave Chinner wrote:
> > On Tue, May 12, 2020 at 02:00:33PM -0700, Darrick J. Wong wrote:
> > > @@ -277,11 +279,34 @@ xfs_qm_init_dquot_blk(
> > >  		}
> > >  	}
> > >  
> > > -	xfs_trans_dquot_buf(tp, bp,
> > > -			    (type & XFS_DQ_USER ? XFS_BLF_UDQUOT_BUF :
> > > -			    ((type & XFS_DQ_PROJ) ? XFS_BLF_PDQUOT_BUF :
> > > -			     XFS_BLF_GDQUOT_BUF)));
> > > -	xfs_trans_log_buf(tp, bp, 0, BBTOB(q->qi_dqchunklen) - 1);
> > > +	if (type & XFS_DQ_USER) {
> > > +		qflag = XFS_UQUOTA_CHKD;
> > > +		blftype = XFS_BLF_UDQUOT_BUF;
> > > +	} else if (type & XFS_DQ_PROJ) {
> > > +		qflag = XFS_PQUOTA_CHKD;
> > > +		blftype = XFS_BLF_PDQUOT_BUF;
> > > +	} else {
> > > +		qflag = XFS_GQUOTA_CHKD;
> > > +		blftype = XFS_BLF_GDQUOT_BUF;
> > > +	}
> > > +
> > > +	xfs_trans_dquot_buf(tp, bp, blftype);
> > > +
> > > +	/*
> > > +	 * If the CHKD flag isn't set, we're running quotacheck and need to use
> > > +	 * ordered buffers so that the logged initialization buffer does not
> > > +	 * get replayed over the delwritten quotacheck buffer.  If we crash
> > > +	 * before the end of quotacheck, the CHKD flags will not be set in the
> > > +	 * superblock and we'll re-run quotacheck at next mount.
> > > +	 *
> > > +	 * Outside of quotacheck, dquot updates are logged via dquot items and
> > > +	 * we must use the regular buffer logging mechanisms to ensure that the
> > > +	 * initial buffer state is recovered before dquot items.
> > > +	 */
> > > +	if (mp->m_qflags & qflag)
> > > +		xfs_trans_log_buf(tp, bp, 0, BBTOB(q->qi_dqchunklen) - 1);
> > > +	else
> > > +		xfs_trans_ordered_buf(tp, bp);
> > >  }
> > 
> > That comment is ... difficult to understand. It conflates what we
> > are currently doing with what might happen in future if we did
> > something differently at the current time. IIUC, what you actually
> > mean is this:
> > 
> > 	/*
> > 	 * When quotacheck runs, we use delayed writes to update all the dquots
> > 	 * on disk in an efficient manner instead of logging the individual
> > 	 * dquot changes as they are made.
> > 	 *
> > 	 * Hence if we log the buffer that we allocate here, then crash
> > 	 * post-quotacheck while the logged initialisation is still in the
> > 	 * active region of the log, we can lose the information quotacheck
> > 	 * wrote directly to the buffer. That is, log recovery will replay the
> > 	 * dquot buffer initialisation over the top of whatever information
> > 	 * quotacheck had written to the buffer.
> > 	 *
> > 	 * To avoid this problem, dquot allocation during quotacheck needs to
> > 	 * avoid logging the initialised buffer, but we still need to have
> > 	 * writeback of the buffer pin the tail of the log so that it is
> > 	 * initialised on disk before we remove the allocation transaction from
> > 	 * the active region of the log. Marking the buffer as ordered instead
> > 	 * of logging it provides this behaviour.
> > 	 */
> 
> That's certainly a /lot/ clearer. :)
> 
> > Also, does this mean quotacheck completion should force the log and push the AIL
> > to ensure that all the allocations are completed and removed from the log before
> > marking the quota as CHKD?
> 
> I need to think about this more, but I think the answer is that we don't
> need to force/push the log because the delwri means we've persisted the
> new dquot contents before we set CHKD, and if we crash before we set
> CHKD, on the next mount attempt we'll re-run quotacheck, which can
> reallocate or reinitialize the ondisk dquots.

*nod*

That was pretty much my thinking, but I haven't looked at the code
to determine if there was...

> But I dunno, maybe there's some other subtlety I haven't thought of...

.... some other subtlety I hadn't thought of... :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
