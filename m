Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B95FFC4724C
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 03:06:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F23F206CC
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 03:06:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="M6+z3xxV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbgEEDG6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 23:06:58 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36194 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbgEEDG5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 23:06:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04534wjm034911;
        Tue, 5 May 2020 03:06:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=hy2h3ugQzY2cgYZXfce2ocywq3sFwtbMBgk/4FzdT8M=;
 b=M6+z3xxVBEj2YHtJzLWJ3tXbaemQxc1iqhkdIiLZ4goRkMRCMavzTtamrqpJWZV/e8+7
 TFj4hdK/otrxEJZ3QpnBzlG/0PjaOrOYDBffaIDDqKiOzEkIhrjgWxURXcDzacWdYso+
 7cdkzWD+nNwlXAdilun3ACOL07ieIBi0QDYRFRq96INXiyOoH+7BJZD78nbwHB4hEcQ9
 QD3EmbFTIjobT15aE/NLr6QX7oWW5c/B70KZyfXbC20BWOB9ZnJCrMnEAgzZDkArlCln
 LrR8arnlN0DHN5MuBBs5lSN0+CuOyE5wb0tuas12W62+ur8TxKEZidwLVj537XcHrR4t 9g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30s1gn23rb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 03:06:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04536s91142017;
        Tue, 5 May 2020 03:06:54 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 30sjds0c4m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 03:06:54 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04536qTf024984;
        Tue, 5 May 2020 03:06:52 GMT
Received: from localhost (/10.159.143.218)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 20:06:52 -0700
Date:   Mon, 4 May 2020 20:06:51 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: proper replay of deferred ops queued during log
 recovery
Message-ID: <20200505030651.GE5716@magnolia>
References: <158864121286.184729.5959003885146573075.stgit@magnolia>
 <158864121900.184729.15751838615488460497.stgit@magnolia>
 <20200505023305.GM2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505023305.GM2040@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=5 mlxscore=0
 bulkscore=0 adultscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=5 mlxscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050022
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 05, 2020 at 12:33:05PM +1000, Dave Chinner wrote:
> On Mon, May 04, 2020 at 06:13:39PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > When we replay unfinished intent items that have been recovered from the
> > log, it's possible that the replay will cause the creation of more
> > deferred work items.  As outlined in commit 509955823cc9c ("xfs: log
> > recovery should replay deferred ops in order"), later work items have an
> > implicit ordering dependency on earlier work items.  Therefore, recovery
> > must replay the items (both recovered and created) in the same order
> > that they would have been during normal operation.
> > 
> > For log recovery, we enforce this ordering by using an empty transaction
> > to collect deferred ops that get created in the process of recovering a
> > log intent item to prevent them from being committed before the rest of
> > the recovered intent items.  After we finish committing all the
> > recovered log items, we allocate a transaction with an enormous block
> > reservation, splice our huge list of created deferred ops into that
> > transaction, and commit it, thereby finishing all those ops.
> > 
> > This is /really/ hokey -- it's the one place in XFS where we allow
> > nested transactions; the splicing of the defer ops list is is inelegant
> > and has to be done twice per recovery function; and the broken way we
> > handle inode pointers and block reservations cause subtle use-after-free
> > and allocator problems that will be fixed by this patch and the two
> > patches after it.
> > 
> > Therefore, replace the hokey empty transaction with a structure designed
> > to capture each chain of deferred ops that are created as part of
> > recovering a single unfinished log intent.  Finally, refactor the loop
> > that replays those chains to do so using one transaction per chain.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> FWIW, I don't like the "freezer" based naming here. It's too easily
> confused with freezing and thawing the filesystem....
> 
> I know, "delayed deferred ops" isn't much better, but at least it
> won't get confused with existing unrelated functionality.

xfs_defer_{freeze,thaw} -> xfs_defer_{capture,relink} ?

> I've barely looked at the code, so no real comments on that yet,
> but I did notice this:
> 
> > @@ -2495,35 +2515,59 @@ xlog_recover_process_data(
> >  /* Take all the collected deferred ops and finish them in order. */
> >  static int
> >  xlog_finish_defer_ops(
> > -	struct xfs_trans	*parent_tp)
> > +	struct xfs_mount	*mp,
> > +	struct list_head	*dfops_freezers)
> >  {
> > -	struct xfs_mount	*mp = parent_tp->t_mountp;
> > +	struct xfs_defer_freezer *dff, *next;
> >  	struct xfs_trans	*tp;
> >  	int64_t			freeblks;
> >  	uint			resblks;
> ....
> > +		resblks = min_t(int64_t, UINT_MAX, freeblks);
> > +		resblks = (resblks * 15) >> 4;
> 
> Can overflow when freeblks > (UINT_MAX / 15).

D'oh.  Ugh, I hate this whole fugly hack.

TBH I've been thinking that perhaps the freezer function should be
capturing the unused transaction block reservation when we capture the
dfops chain from the transaction.

When we set up the second transaction, we then set t_blk_res to the
captured block reservation.  So long as the recovery function is smart
enough to set up sufficient reservation we should avoid hitting ENOSPC,
right?

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
