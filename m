Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:37060 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750984AbeACAwP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jan 2018 19:52:15 -0500
Date: Tue, 2 Jan 2018 16:52:07 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 18/20] xfs: standardize quota verification function
 outputs
Message-ID: <20180103005207.GJ4857@magnolia>
References: <151399122361.23543.15718507168231759645.stgit@magnolia>
 <151399133641.23543.18383563898958249777.stgit@magnolia>
 <20180103004417.GG5858@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180103004417.GG5858@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jan 03, 2018 at 11:44:17AM +1100, Dave Chinner wrote:
> On Fri, Dec 22, 2017 at 05:08:56PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Rename xfs_dqcheck to xfs_dquot_verify and make it return an
> > xfs_failaddr_t like every other structure verifier function.
> > This enables us to check on-disk quotas in the same way that we check
> > everything else.  Callers are now responsible for logging errors, as
> > XFS_QMOPT_DOWARN goes away.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> One minor nit:
> 
> > @@ -2701,11 +2701,14 @@ xlog_recover_do_reg_buffer(
> >  					item->ri_buf[i].i_len, __func__);
> >  				goto next;
> >  			}
> > -			error = xfs_dqcheck(mp, item->ri_buf[i].i_addr,
> > -					       -1, 0, XFS_QMOPT_DOWARN,
> > -					       "dquot_buf_recover");
> > -			if (error)
> > +			fa = xfs_dquot_verify(mp, item->ri_buf[i].i_addr,
> > +					       -1, 0, 0);
> > +			if (fa) {
> > +				xfs_alert(mp,
> > +					"dquot corrupt at %pS trying to replay into block 0x%llx",
> > +					fa, bp->b_bn);
> >  				goto next;
> > +			}
> 
> Alert message line too long here, just pull the indent back for
> it...

Ok, done.

--D

> Otherwise it looks good.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
