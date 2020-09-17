Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 762FDC43461
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 07:18:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E86B2083B
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 07:18:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="a1thqk1Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbgIQHSe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 03:18:34 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35134 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbgIQHSd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 03:18:33 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H6xew4168031;
        Thu, 17 Sep 2020 07:18:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=nvI5efLoCkcpAmHDkEusTQmfzLVaFyg3UcfbCs/Jfyk=;
 b=a1thqk1QUA+2O5Ra/4/ah3bJFILc9+lGSZUVIfu8IYevuyCXj9gZ37Mz/dvl/XzGoOMR
 3oYBnO9XHcwqAFg0RAnWbPHhCzCTYIHo70XPKXa3r+834yLenHK4D4nStMGqJcpsR8de
 F55/5xmVvWldai7aeAXBsE3Nq5Ga6jPh+WrmLLv7nBf0fs0EnmVDP/9QwF5TpYP3zBEu
 XSR65KDKLN7Z21vIcwwftbo/aBWoghs3XEF6q+EKp5DkAw3jLP7VnMkbbNecHbmAdCLL
 HbyY+b+FBKnDuusWKvZRa/Bh3EsR64IsRnBY6wwGm7io3CrIb8TfwoebnWE1t5jkKNu2 0A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 33gnrr7c31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Sep 2020 07:18:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H73eUW108307;
        Thu, 17 Sep 2020 07:18:26 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 33h88agy24-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 07:18:26 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08H7IPuS030206;
        Thu, 17 Sep 2020 07:18:25 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Sep 2020 07:18:22 +0000
Date:   Thu, 17 Sep 2020 00:18:21 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 2/3] xfs: periodically relog deferred intent items
Message-ID: <20200917071821.GX7955@magnolia>
References: <160031338724.3624707.1335084348340671147.stgit@magnolia>
 <160031340007.3624707.16729315375941677948.stgit@magnolia>
 <20200917061148.GH12131@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917061148.GH12131@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=1 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170051
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 bulkscore=0 suspectscore=1
 clxscore=1015 mlxlogscore=999 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170051
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 17, 2020 at 04:11:48PM +1000, Dave Chinner wrote:
> On Wed, Sep 16, 2020 at 08:30:00PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > There's a subtle design flaw in the deferred log item code that can lead
> > to pinning the log tail.  Taking up the defer ops chain examples from
> > the previous commit, we can get trapped in sequences like this:
> > 
> > Caller hands us a transaction t0 with D0-D3 attached.  The defer ops
> > chain will look like the following if the transaction rolls succeed:
> > 
> > t1: D0(t0), D1(t0), D2(t0), D3(t0)
> > t2: d4(t1), d5(t1), D1(t0), D2(t0), D3(t0)
> > t3: d5(t1), D1(t0), D2(t0), D3(t0)
> > ...
> > t9: d9(t7), D3(t0)
> > t10: D3(t0)
> > t11: d10(t10), d11(t10)
> > t12: d11(t10)
> > 
> > In transaction 9, we finish d9 and try to roll to t10 while holding onto
> > an intent item for D3 that we logged in t0.
> > 
> > The previous commit changed the order in which we place new defer ops in
> > the defer ops processing chain to reduce the maximum chain length.  Now
> > make xfs_defer_finish_noroll capable of relogging the entire chain
> > periodically so that we can always move the log tail forward.  We do
> > this every seven loops, having observed that while most chains never
> > exceed seven items in length, the rest go far over that and seem to
> > be involved in most of the stall problems.
> > 
> > Callers are now required to ensure that the transaction reservation is
> > large enough to handle logging done items and new intent items for the
> > maximum possible chain length.  Most callers are careful to keep the
> > chain lengths low, so the overhead should be minimal.
> > 
> > (Note that in the next patch we'll make it so that we only relog on
> > demand, since 7 is an arbitrary number that I used here to get the basic
> > mechanics working.)
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_defer.c  |   30 ++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_bmap_item.c     |   25 +++++++++++++++++++++++++
> >  fs/xfs/xfs_extfree_item.c  |   29 +++++++++++++++++++++++++++++
> >  fs/xfs/xfs_refcount_item.c |   27 +++++++++++++++++++++++++++
> >  fs/xfs/xfs_rmap_item.c     |   27 +++++++++++++++++++++++++++
> >  fs/xfs/xfs_trace.h         |    1 +
> >  fs/xfs/xfs_trans.h         |   10 ++++++++++
> >  7 files changed, 149 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> > index 84a70edd0da1..7938e4d3af90 100644
> > --- a/fs/xfs/libxfs/xfs_defer.c
> > +++ b/fs/xfs/libxfs/xfs_defer.c
> > @@ -361,6 +361,28 @@ xfs_defer_cancel_list(
> >  	}
> >  }
> >  
> > +/*
> > + * Prevent a log intent item from pinning the tail of the log by logging a
> > + * done item to release the intent item; and then log a new intent item.
> > + * The caller should provide a fresh transaction and roll it after we're done.
> > + */
> > +static int
> > +xfs_defer_relog(
> > +	struct xfs_trans		**tpp,
> > +	struct list_head		*dfops)
> > +{
> > +	struct xfs_defer_pending	*dfp;
> > +
> > +	ASSERT((*tpp)->t_flags & XFS_TRANS_PERM_LOG_RES);
> > +
> > +	list_for_each_entry(dfp, dfops, dfp_list) {
> > +		trace_xfs_defer_relog_intent((*tpp)->t_mountp, dfp);
> > +		dfp->dfp_intent = xfs_trans_item_relog(dfp->dfp_intent, *tpp);
> 
> Any reason for xfs_trans_item_relog() when it's a one liner?

There aren't log intent items in userspace, so xfs_trans_item_relog
becomes a NOP macro in the xfsprogs port.

> > +	}
> > +
> > +	return xfs_defer_trans_roll(tpp);
> > +}
> > +
> >  /*
> >   * Log an intent-done item for the first pending intent, and finish the work
> >   * items.
> > @@ -422,6 +444,7 @@ xfs_defer_finish_noroll(
> >  	struct xfs_trans		**tp)
> >  {
> >  	struct xfs_defer_pending	*dfp;
> > +	unsigned int			nr_rolls = 0;
> >  	int				error = 0;
> >  	LIST_HEAD(dop_pending);
> >  
> > @@ -447,6 +470,13 @@ xfs_defer_finish_noroll(
> >  		if (error)
> >  			goto out_shutdown;
> >  
> > +		/* Every few rolls we relog all the intent items. */
> > +		if (!(++nr_rolls % 7)) {
> > +			error = xfs_defer_relog(tp, &dop_pending);
> > +			if (error)
> > +				goto out_shutdown;
> > +		}
> 
> Urk.
> 
> I think I've got a better idea: rather than a counter, use something
> meaningful as to whether the intent has been committed or not. e.g.
> use something like xfs_log_item_in_current_chkpt() to determine if
> we need to relog the intent.

I'll take a look at that in the morning.

> i.e. If the intent is active in the CIL, then we don't need to relog
> it. If the intent has been committed to the journal and is no longer
> in the CIL list, relog it so the next CIL push will move it forward
> in the journal.
> 
> The intent relogging functions look fine, though.

Thanks for digging through some of these. :)

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
