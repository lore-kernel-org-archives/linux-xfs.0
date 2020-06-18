Return-Path: <SRS0=OEwr=77=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01CAFC433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 01:37:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1BCB2192A
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 01:37:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="r2fNIwyD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731976AbgFRBhP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 Jun 2020 21:37:15 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45666 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732922AbgFRBhD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Jun 2020 21:37:03 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05I1VwwD020779;
        Thu, 18 Jun 2020 01:36:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=NjO9T+ItUssJ7a0CFcdru+/uu2SQQSgoZuGDk/82NMM=;
 b=r2fNIwyDn5uoXDgXjExVguYuEbEMerprYiys7ZMPD+7osHM1ln5t2f7dicDoFNGe9IKd
 rDhDLKJqpONP5xAMuKnK0fqxmvihg9iJ6nFjE3aLnvOSLTExkQdTn7FgjgikSesNep6O
 pswIQP9kgVtDRoQpXFchm2F6Fw48ahQHLfXFJaYER2F4dbA5nGHNzXOyoesPk/olLgk2
 5UL+i49w+U9sDH8slraHP7xquGfRQqHrraUTF1ANJLL8i6CIr9/a6QMTWPcd0NavwOTs
 3Jtqck99LpSg0y+4g2YGb3aENcGu1E/Lx3ilmitYLpE2+9pDDgStPzE/zb1SLNUJtQJo dg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31qg354d3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 18 Jun 2020 01:36:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05I1TCex141282;
        Thu, 18 Jun 2020 01:36:32 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 31q66qprqe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Jun 2020 01:36:31 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05I1aSXr014206;
        Thu, 18 Jun 2020 01:36:29 GMT
Received: from localhost (/10.159.233.73)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 17 Jun 2020 18:36:28 -0700
Date:   Wed, 17 Jun 2020 18:36:27 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Waiman Long <longman@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qian Cai <cai@lca.pw>, Eric Sandeen <sandeen@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 2/2] xfs: Fix false positive lockdep warning with
 sb_internal & fs_reclaim
Message-ID: <20200618013627.GQ11245@magnolia>
References: <20200617175310.20912-1-longman@redhat.com>
 <20200617175310.20912-3-longman@redhat.com>
 <20200618004505.GG2005@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200618004505.GG2005@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9655 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 adultscore=0 phishscore=0 suspectscore=1 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006180008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9655 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 clxscore=1015 malwarescore=0 impostorscore=0 adultscore=0
 cotscore=-2147483648 lowpriorityscore=0 mlxlogscore=999 spamscore=0
 suspectscore=1 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006180008
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 18, 2020 at 10:45:05AM +1000, Dave Chinner wrote:
> On Wed, Jun 17, 2020 at 01:53:10PM -0400, Waiman Long wrote:
> >  fs/xfs/xfs_log.c   |  9 +++++++++
> >  fs/xfs/xfs_trans.c | 31 +++++++++++++++++++++++++++----
> >  2 files changed, 36 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index 00fda2e8e738..33244680d0d4 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -830,8 +830,17 @@ xlog_unmount_write(
> >  	xfs_lsn_t		lsn;
> >  	uint			flags = XLOG_UNMOUNT_TRANS;
> >  	int			error;
> > +	unsigned long		pflags;
> >  
> > +	/*
> > +	 * xfs_log_reserve() allocates memory. This can lead to fs reclaim
> > +	 * which may conflicts with the unmount process. To avoid that,
> > +	 * disable fs reclaim for this allocation.
> > +	 */
> > +	current_set_flags_nested(&pflags, PF_MEMALLOC_NOFS);
> >  	error = xfs_log_reserve(mp, 600, 1, &tic, XFS_LOG, 0);
> > +	current_restore_flags_nested(&pflags, PF_MEMALLOC_NOFS);
> > +
> >  	if (error)
> >  		goto out_err;
> 
> The more I look at this, the more I think Darrick is right and I
> somewhat misinterpretted what he meant by "the top of the freeze
> path".
> 
> i.e. setting PF_MEMALLOC_NOFS here is out of place - only one caller
> of xlog_unmount_write requires PF_MEMALLOC_NOFS
> context. That context should be set in the caller that requires this
> context, and in this case it is xfs_fs_freeze(). This is top of the
> final freeze state processing (what I think Darrick meant), not the
> top of the freeze syscall call chain (what I thought he meant).

Aha!  Yes, that's exactly what I meant.  Sorry we all kinda muddled
around for a few days. :/

--D

> So if set PF_MEMALLOC_NOFS setting in xfs_fs_freeze(), it covers all
> the allocations in this problematic path, and it should obliviates
> the need for the first patch in the series altogether.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
