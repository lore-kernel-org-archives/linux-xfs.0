Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD797C47247
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 15:09:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A00A620757
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 15:09:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LiHm1529"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729359AbgEEPJE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 May 2020 11:09:04 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41918 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729320AbgEEPJD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 May 2020 11:09:03 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045F7a8A126513;
        Tue, 5 May 2020 15:09:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=lCS4FB6psIbIkKZc4qfjQoE+hxoS1WbYwBXZVEiouvk=;
 b=LiHm1529lP83EZcSLOZ1L15jZiR1CF6xngFMvUCFdODOIQMQ730E2056MQLW5dtb+WAr
 RbnxlYgK0CKMS1UGd3RQTyASmlmOZKVK320cUkTJv6H5AZ4RSz3rwud74oh8X+CZeMED
 P+fJQPyBpvWLc+AjyJ4GQ0iYvvuCBaDDxn8+YQO/1SyXkm6CG++0ABXdgy5sfjNQxdNe
 VznXG9byngixappzPhHgftSW5g24uALFskRM1RjD8Y8KA73Xj/eBwnoGMhHyt9qq4yPU
 5focbkdhO/UVtf6tTDGYKs8HaTGISrl2qxMhJS+sXmhGjCiaowOdm2/5qs0O/KFftVFN bQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 30s09r5bt9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 15:09:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045F6qf2007252;
        Tue, 5 May 2020 15:08:58 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 30sjdt77ub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 15:08:58 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 045F8uH0028003;
        Tue, 5 May 2020 15:08:56 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 May 2020 08:08:56 -0700
Date:   Tue, 5 May 2020 08:08:55 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: proper replay of deferred ops queued during log
 recovery
Message-ID: <20200505150855.GQ5703@magnolia>
References: <158864121286.184729.5959003885146573075.stgit@magnolia>
 <158864121900.184729.15751838615488460497.stgit@magnolia>
 <20200505023305.GM2040@dread.disaster.area>
 <20200505030651.GE5716@magnolia>
 <20200505051029.GN2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505051029.GN2040@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=5 mlxscore=0
 bulkscore=0 adultscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 suspectscore=5
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050122
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 05, 2020 at 03:10:29PM +1000, Dave Chinner wrote:
> On Mon, May 04, 2020 at 08:06:51PM -0700, Darrick J. Wong wrote:
> > On Tue, May 05, 2020 at 12:33:05PM +1000, Dave Chinner wrote:
> > > On Mon, May 04, 2020 at 06:13:39PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > When we replay unfinished intent items that have been recovered from the
> > > > log, it's possible that the replay will cause the creation of more
> > > > deferred work items.  As outlined in commit 509955823cc9c ("xfs: log
> > > > recovery should replay deferred ops in order"), later work items have an
> > > > implicit ordering dependency on earlier work items.  Therefore, recovery
> > > > must replay the items (both recovered and created) in the same order
> > > > that they would have been during normal operation.
> > > > 
> > > > For log recovery, we enforce this ordering by using an empty transaction
> > > > to collect deferred ops that get created in the process of recovering a
> > > > log intent item to prevent them from being committed before the rest of
> > > > the recovered intent items.  After we finish committing all the
> > > > recovered log items, we allocate a transaction with an enormous block
> > > > reservation, splice our huge list of created deferred ops into that
> > > > transaction, and commit it, thereby finishing all those ops.
> > > > 
> > > > This is /really/ hokey -- it's the one place in XFS where we allow
> > > > nested transactions; the splicing of the defer ops list is is inelegant
> > > > and has to be done twice per recovery function; and the broken way we
> > > > handle inode pointers and block reservations cause subtle use-after-free
> > > > and allocator problems that will be fixed by this patch and the two
> > > > patches after it.
> > > > 
> > > > Therefore, replace the hokey empty transaction with a structure designed
> > > > to capture each chain of deferred ops that are created as part of
> > > > recovering a single unfinished log intent.  Finally, refactor the loop
> > > > that replays those chains to do so using one transaction per chain.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > FWIW, I don't like the "freezer" based naming here. It's too easily
> > > confused with freezing and thawing the filesystem....
> > > 
> > > I know, "delayed deferred ops" isn't much better, but at least it
> > > won't get confused with existing unrelated functionality.
> > 
> > xfs_defer_{freeze,thaw} -> xfs_defer_{capture,relink} ?
> 
> Yeah, capture seems appropriate, maybe relink -> continue? i.e.
> capture the remaining defer_ops to be run, then continue running
> them?

I think I like capture/continue.

> /me shrugs and thinks "naming is hard"....

:)

> > > I've barely looked at the code, so no real comments on that yet,
> > > but I did notice this:
> > > 
> > > > @@ -2495,35 +2515,59 @@ xlog_recover_process_data(
> > > >  /* Take all the collected deferred ops and finish them in order. */
> > > >  static int
> > > >  xlog_finish_defer_ops(
> > > > -	struct xfs_trans	*parent_tp)
> > > > +	struct xfs_mount	*mp,
> > > > +	struct list_head	*dfops_freezers)
> > > >  {
> > > > -	struct xfs_mount	*mp = parent_tp->t_mountp;
> > > > +	struct xfs_defer_freezer *dff, *next;
> > > >  	struct xfs_trans	*tp;
> > > >  	int64_t			freeblks;
> > > >  	uint			resblks;
> > > ....
> > > > +		resblks = min_t(int64_t, UINT_MAX, freeblks);
> > > > +		resblks = (resblks * 15) >> 4;
> > > 
> > > Can overflow when freeblks > (UINT_MAX / 15).
> > 
> > D'oh.  Ugh, I hate this whole fugly hack.
> > 
> > TBH I've been thinking that perhaps the freezer function should be
> > capturing the unused transaction block reservation when we capture the
> > dfops chain from the transaction.
> 
> Exactly what problem is this hack supposed to avoid? having the
> filesystem ENOSPC before all the deferops have been completed?
>
> if so, can that even happen? Because the fact that the intents are
> in the log means that when they were started there was enough space
> in the fs for them to run, so ENOSPC should not be an issue, right?

We're probably not going to run out of space, seeing as we had enough
space to run the first time.  However, there's various parts of the
filesystem that either behave differently or ENOSPC early if the
transaction has no block reservation, so we need to avoid them.

The outcome of the recovery work ought to be as close as possible to
what would have happened if the fs hadn't gone down.

> > When we set up the second transaction, we then set t_blk_res to the
> > captured block reservation.  So long as the recovery function is smart
> > enough to set up sufficient reservation we should avoid hitting ENOSPC,
> > right?
> 
> I'm not sure ENOSPC is really a problem for recovery of deferred ops
> given the above...

<nod>

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
