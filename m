Return-Path: <SRS0=WYbU=5O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6878C43331
	for <linux-xfs@archiver.kernel.org>; Sun, 29 Mar 2020 23:01:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FED82074A
	for <linux-xfs@archiver.kernel.org>; Sun, 29 Mar 2020 23:01:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728672AbgC2XBh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 29 Mar 2020 19:01:37 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:45861 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728493AbgC2XBg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 29 Mar 2020 19:01:36 -0400
Received: from dread.disaster.area (pa49-179-23-206.pa.nsw.optusnet.com.au [49.179.23.206])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 3EF323A3094;
        Mon, 30 Mar 2020 10:01:33 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jIgvs-0005bJ-7S; Mon, 30 Mar 2020 10:01:32 +1100
Date:   Mon, 30 Mar 2020 10:01:32 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: trylock underlying buffer on dquot flush
Message-ID: <20200329230132.GU10776@dread.disaster.area>
References: <20200326131703.23246-1-bfoster@redhat.com>
 <20200326131703.23246-2-bfoster@redhat.com>
 <20200329224602.GT10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200329224602.GT10776@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=n/Z79dAqQwRlp4tcgfhWYA==:117 a=n/Z79dAqQwRlp4tcgfhWYA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=Q1lUTXWbESbXQH_L7QYA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 30, 2020 at 09:46:02AM +1100, Dave Chinner wrote:
> On Thu, Mar 26, 2020 at 09:17:02AM -0400, Brian Foster wrote:
> > A dquot flush currently blocks on the buffer lock for the underlying
> > dquot buffer. In turn, this causes xfsaild to block rather than
> > continue processing other items in the meantime. Update
> > xfs_qm_dqflush() to trylock the buffer, similar to how inode buffers
> > are handled, and return -EAGAIN if the lock fails. Fix up any
> > callers that don't currently handle the error properly.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_dquot.c      |  6 +++---
> >  fs/xfs/xfs_dquot_item.c |  3 ++-
> >  fs/xfs/xfs_qm.c         | 14 +++++++++-----
> >  3 files changed, 14 insertions(+), 9 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> > index 711376ca269f..af2c8e5ceea0 100644
> > --- a/fs/xfs/xfs_dquot.c
> > +++ b/fs/xfs/xfs_dquot.c
> > @@ -1105,8 +1105,8 @@ xfs_qm_dqflush(
> >  	 * Get the buffer containing the on-disk dquot
> >  	 */
> >  	error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp, dqp->q_blkno,
> > -				   mp->m_quotainfo->qi_dqchunklen, 0, &bp,
> > -				   &xfs_dquot_buf_ops);
> > +				   mp->m_quotainfo->qi_dqchunklen, XBF_TRYLOCK,
> > +				   &bp, &xfs_dquot_buf_ops);
> >  	if (error)
> >  		goto out_unlock;
> >  
> > @@ -1177,7 +1177,7 @@ xfs_qm_dqflush(
> >  
> >  out_unlock:
> >  	xfs_dqfunlock(dqp);
> > -	return -EIO;
> > +	return error;
> >  }
> >  
> >  /*
> > diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> > index cf65e2e43c6e..baad1748d0d1 100644
> > --- a/fs/xfs/xfs_dquot_item.c
> > +++ b/fs/xfs/xfs_dquot_item.c
> > @@ -189,7 +189,8 @@ xfs_qm_dquot_logitem_push(
> >  		if (!xfs_buf_delwri_queue(bp, buffer_list))
> >  			rval = XFS_ITEM_FLUSHING;
> >  		xfs_buf_relse(bp);
> > -	}
> > +	} else if (error == -EAGAIN)
> > +		rval = XFS_ITEM_LOCKED;
> 
> Doesn't xfs_inode_item_push() also have this problem in that it
> doesn't handle -EAGAIN properly?

... and now I see this is the second patch in the series...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
