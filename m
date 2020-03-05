Return-Path: <SRS0=4NJG=4W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDA6AC3F2D1
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 02:47:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A95B32084E
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 02:47:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725852AbgCECrc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Mar 2020 21:47:32 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:40358 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725844AbgCECrc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Mar 2020 21:47:32 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 4D64E7EA13D;
        Thu,  5 Mar 2020 13:47:30 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9gXo-0006Jz-PD; Thu, 05 Mar 2020 13:47:28 +1100
Date:   Thu, 5 Mar 2020 13:47:28 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: introduce new private btree cursor names
Message-ID: <20200305024728.GI10776@dread.disaster.area>
References: <20200305014537.11236-1-david@fromorbit.com>
 <20200305014537.11236-2-david@fromorbit.com>
 <20200305022901.GP8045@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305022901.GP8045@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=7F2GxDxOJKLpF3ijvCEA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 04, 2020 at 06:29:01PM -0800, Darrick J. Wong wrote:
> On Thu, Mar 05, 2020 at 12:45:31PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Just the defines of the new names - the conversion will be in
> > scripted commits after this.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_btree.h | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> > index 3eff7c321d43..bd5a2bfca64e 100644
> > --- a/fs/xfs/libxfs/xfs_btree.h
> > +++ b/fs/xfs/libxfs/xfs_btree.h
> > @@ -224,6 +224,8 @@ typedef struct xfs_btree_cur
> >  #define	XFS_BTCUR_BPRV_INVALID_OWNER	(1<<1)		/* for ext swap */
> >  		} b;
> >  	}		bc_private;	/* per-btree type data */
> > +#define bc_ag	bc_private.a
> > +#define bc_bt	bc_private.b
> 
> Hm. I get that the historical meaning of "b" was for "bmbt", but it's
> not a great descriptor since the fields in bc_private.b are really for
> inode-rooted btrees, of which the bmbt is currently the only user.  If
> we ever get around to adding the realtime rmapbt, then "bc_bt" is going
> to seem a bit anachronistic.
> 
> bc_ino, perhaps?

Sure, makes no difference to me. It's just a case of running sed
over all the patches before I rebase the series...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
