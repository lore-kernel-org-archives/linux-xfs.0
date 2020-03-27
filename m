Return-Path: <SRS0=eBbo=5M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79CD8C43331
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Mar 2020 17:04:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42276206F2
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Mar 2020 17:04:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Dwr507Ri"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgC0REU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Mar 2020 13:04:20 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36214 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727505AbgC0REU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Mar 2020 13:04:20 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02RGrUNE167836;
        Fri, 27 Mar 2020 17:04:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=GU0Jlruv8D9TKXQVhQKN/vLVPWum+Pp/LOAE2Kug8Jg=;
 b=Dwr507RivKmOljoe4/a/QZWMWLX3/mcaKj1WSjT6ihy6HPKH6frLE78zagNEdSh/ovr1
 Rq9QOjHS9/kfyvRmJIwHqKTJXxfL1zdeyRxtpUKxTqqI++9xsrtk89dqbPvBX9j1uFyu
 a/saC2a+vMOJ+dG5pDE15ZNfo8GYfASNk6O/uyZG8YJmejoksfS5ciQUdG9NM2ds/Zp5
 HUGBZEZ60/Mj2+YrtlqDdk5AauNL9sLhGeQ0j5R5DI9ZkUYh02DxS2RcEdc7qJ4YKFvN
 dRcOgpozlHeADSaw3BaFaY4v1GC2ZQ4RaYHvO8tySOupUXIHa/wn48L4FU4+TnYwf1Sz 6g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 301459c9cr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 17:04:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02RGqFsU139427;
        Fri, 27 Mar 2020 17:04:16 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 3006ramfeq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 17:04:16 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02RH4EDi008329;
        Fri, 27 Mar 2020 17:04:15 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 27 Mar 2020 10:04:14 -0700
Date:   Fri, 27 Mar 2020 10:04:13 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: trylock underlying buffer on dquot flush
Message-ID: <20200327170413.GL29339@magnolia>
References: <20200326131703.23246-1-bfoster@redhat.com>
 <20200326131703.23246-2-bfoster@redhat.com>
 <20200327154527.GJ29339@magnolia>
 <20200327164440.GB29156@bfoster>
 <20200327164644.GC29156@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200327164644.GC29156@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9573 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 phishscore=0 spamscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003270146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9573 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 mlxlogscore=999
 adultscore=0 suspectscore=0 impostorscore=0 mlxscore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003270146
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 27, 2020 at 12:46:44PM -0400, Brian Foster wrote:
> On Fri, Mar 27, 2020 at 12:44:40PM -0400, Brian Foster wrote:
> > On Fri, Mar 27, 2020 at 08:45:28AM -0700, Darrick J. Wong wrote:
> > > On Thu, Mar 26, 2020 at 09:17:02AM -0400, Brian Foster wrote:
> > > > A dquot flush currently blocks on the buffer lock for the underlying
> > > > dquot buffer. In turn, this causes xfsaild to block rather than
> > > > continue processing other items in the meantime. Update
> > > > xfs_qm_dqflush() to trylock the buffer, similar to how inode buffers
> > > > are handled, and return -EAGAIN if the lock fails. Fix up any
> > > > callers that don't currently handle the error properly.
> > > > 
> > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > 
> > > Is xfs_qm_dquot_isolate returning LRU_RETRY an acceptable resolution (as
> > > opposed to, say, LRU_SKIP) for xfs_qm_dqflush returning -EAGAIN?
> > > 
> > 
> > Hmm.. this is reclaim so I suppose LRU_SKIP would be more appropriate
> > than retry (along with more consistent with the other trylock failures
> > in that function). Ok with something like the following?
> > 
> > @@ -461,7 +461,11 @@ xfs_qm_dquot_isolate(
> >  		spin_unlock(lru_lock);
> >  
> >  		error = xfs_qm_dqflush(dqp, &bp);
> > -		if (error)
> > +		if (error == -EAGAIN) {
> > +			xfs_dqunlock(dqp);
> > +			spin_lock(lru_lock);
> > +			goto out_miss_busy;
> > +		} else if (error)
> >  			goto out_unlock_dirty;
> 
> Then again, is it safe to skip from here once we've cycled the lru_lock?

DOH.  Yeah, I missed that we cycled the lru lock and therefore have to
LRU_RETRY.  So I guess the original patch was fine:

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> Brian
> 
> >  
> >  		xfs_buf_delwri_queue(bp, &isol->buffers);
> > 
> > Brian
> > 
> > > --D
> > > 
> > > > ---
> > > >  fs/xfs/xfs_dquot.c      |  6 +++---
> > > >  fs/xfs/xfs_dquot_item.c |  3 ++-
> > > >  fs/xfs/xfs_qm.c         | 14 +++++++++-----
> > > >  3 files changed, 14 insertions(+), 9 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> > > > index 711376ca269f..af2c8e5ceea0 100644
> > > > --- a/fs/xfs/xfs_dquot.c
> > > > +++ b/fs/xfs/xfs_dquot.c
> > > > @@ -1105,8 +1105,8 @@ xfs_qm_dqflush(
> > > >  	 * Get the buffer containing the on-disk dquot
> > > >  	 */
> > > >  	error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp, dqp->q_blkno,
> > > > -				   mp->m_quotainfo->qi_dqchunklen, 0, &bp,
> > > > -				   &xfs_dquot_buf_ops);
> > > > +				   mp->m_quotainfo->qi_dqchunklen, XBF_TRYLOCK,
> > > > +				   &bp, &xfs_dquot_buf_ops);
> > > >  	if (error)
> > > >  		goto out_unlock;
> > > >  
> > > > @@ -1177,7 +1177,7 @@ xfs_qm_dqflush(
> > > >  
> > > >  out_unlock:
> > > >  	xfs_dqfunlock(dqp);
> > > > -	return -EIO;
> > > > +	return error;
> > > >  }
> > > >  
> > > >  /*
> > > > diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> > > > index cf65e2e43c6e..baad1748d0d1 100644
> > > > --- a/fs/xfs/xfs_dquot_item.c
> > > > +++ b/fs/xfs/xfs_dquot_item.c
> > > > @@ -189,7 +189,8 @@ xfs_qm_dquot_logitem_push(
> > > >  		if (!xfs_buf_delwri_queue(bp, buffer_list))
> > > >  			rval = XFS_ITEM_FLUSHING;
> > > >  		xfs_buf_relse(bp);
> > > > -	}
> > > > +	} else if (error == -EAGAIN)
> > > > +		rval = XFS_ITEM_LOCKED;
> > > >  
> > > >  	spin_lock(&lip->li_ailp->ail_lock);
> > > >  out_unlock:
> > > > diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> > > > index de1d2c606c14..68c778d25c48 100644
> > > > --- a/fs/xfs/xfs_qm.c
> > > > +++ b/fs/xfs/xfs_qm.c
> > > > @@ -121,12 +121,11 @@ xfs_qm_dqpurge(
> > > >  {
> > > >  	struct xfs_mount	*mp = dqp->q_mount;
> > > >  	struct xfs_quotainfo	*qi = mp->m_quotainfo;
> > > > +	int			error = -EAGAIN;
> > > >  
> > > >  	xfs_dqlock(dqp);
> > > > -	if ((dqp->dq_flags & XFS_DQ_FREEING) || dqp->q_nrefs != 0) {
> > > > -		xfs_dqunlock(dqp);
> > > > -		return -EAGAIN;
> > > > -	}
> > > > +	if ((dqp->dq_flags & XFS_DQ_FREEING) || dqp->q_nrefs != 0)
> > > > +		goto out_unlock;
> > > >  
> > > >  	dqp->dq_flags |= XFS_DQ_FREEING;
> > > >  
> > > > @@ -139,7 +138,6 @@ xfs_qm_dqpurge(
> > > >  	 */
> > > >  	if (XFS_DQ_IS_DIRTY(dqp)) {
> > > >  		struct xfs_buf	*bp = NULL;
> > > > -		int		error;
> > > >  
> > > >  		/*
> > > >  		 * We don't care about getting disk errors here. We need
> > > > @@ -149,6 +147,8 @@ xfs_qm_dqpurge(
> > > >  		if (!error) {
> > > >  			error = xfs_bwrite(bp);
> > > >  			xfs_buf_relse(bp);
> > > > +		} else if (error == -EAGAIN) {
> > > > +			goto out_unlock;
> > > >  		}
> > > >  		xfs_dqflock(dqp);
> > > >  	}
> > > > @@ -174,6 +174,10 @@ xfs_qm_dqpurge(
> > > >  
> > > >  	xfs_qm_dqdestroy(dqp);
> > > >  	return 0;
> > > > +
> > > > +out_unlock:
> > > > +	xfs_dqunlock(dqp);
> > > > +	return error;
> > > >  }
> > > >  
> > > >  /*
> > > > -- 
> > > > 2.21.1
> > > > 
> > > 
> > 
> 
