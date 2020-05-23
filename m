Return-Path: <SRS0=aNSJ=7F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9898C433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 21:43:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C21A820823
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 21:43:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388015AbgEWVnj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 May 2020 17:43:39 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:49623 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388001AbgEWVnj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 May 2020 17:43:39 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 9E409D78B04;
        Sun, 24 May 2020 07:43:35 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jcbva-0000WJ-BY; Sun, 24 May 2020 07:43:34 +1000
Date:   Sun, 24 May 2020 07:43:34 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/24] xfs: pin inode backing buffer to the inode log item
Message-ID: <20200523214334.GG2040@dread.disaster.area>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-13-david@fromorbit.com>
 <20200523093451.GA7083@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200523093451.GA7083@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=7-415B0cAAAA:8
        a=I7dTYAOBs5FUbbAV9jkA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 23, 2020 at 02:34:51AM -0700, Christoph Hellwig wrote:
> > --- a/fs/xfs/xfs_trans_priv.h
> > +++ b/fs/xfs/xfs_trans_priv.h
> > @@ -143,15 +143,10 @@ static inline void
> >  xfs_clear_li_failed(
> >  	struct xfs_log_item	*lip)
> >  {
> > -	struct xfs_buf	*bp = lip->li_buf;
> > -
> >  	ASSERT(test_bit(XFS_LI_IN_AIL, &lip->li_flags));
> >  	lockdep_assert_held(&lip->li_ailp->ail_lock);
> >  
> > -	if (test_and_clear_bit(XFS_LI_FAILED, &lip->li_flags)) {
> > -		lip->li_buf = NULL;
> > -		xfs_buf_rele(bp);
> > -	}
> > +	clear_bit(XFS_LI_FAILED, &lip->li_flags);
> >  }
> >  
> >  static inline void
> > @@ -161,10 +156,7 @@ xfs_set_li_failed(
> >  {
> >  	lockdep_assert_held(&lip->li_ailp->ail_lock);
> >  
> > -	if (!test_and_set_bit(XFS_LI_FAILED, &lip->li_flags)) {
> > -		xfs_buf_hold(bp);
> > -		lip->li_buf = bp;
> > -	}
> > +	set_bit(XFS_LI_FAILED, &lip->li_flags);
> >  }
> 
> Isn't this going to break quotas, which don't always have li_buf set?

Yup, that'll be the assert fail that Darrick reported. Well spotted,
Christoph!

I've got to rework the error handling code anyway, so I might end up
getting rid of ->li_error and hard coding these like I've done the
iodone functions. That way the different objects can use different
failure mechanisms until the dquot code is converted to the same
"hold at dirty time" flushing mechanism...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
