Return-Path: <SRS0=6H2z=7S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98B11C433E0
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Jun 2020 16:25:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74FA82074B
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Jun 2020 16:25:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vy83ry+q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726040AbgFEQZv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Jun 2020 12:25:51 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:40911 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726024AbgFEQZu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Jun 2020 12:25:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591374349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XWHf3303o24b93+WocBKkZTEpUapxdeN6iqSCQ2Y2Fs=;
        b=Vy83ry+qn/6H1zXHu+43Y7kYt3mB/UTW80XgO2FljMrIfKDs+ZVhweVdjCWUvBJRsLQNsO
        ICCLzPRK9fQkxWOHi/uwMBgN42UxH8s8SpB0BA6iOYSL1iFFp1YXmqQTmSYrSLaemvjSHY
        mIpKC3J2MoK4s4QsrwLrQB6m9oDXQGU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-128-wbKGthHpMlOZa1T8ckGFRQ-1; Fri, 05 Jun 2020 12:25:47 -0400
X-MC-Unique: wbKGthHpMlOZa1T8ckGFRQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5A419800688;
        Fri,  5 Jun 2020 16:25:46 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 146F3108BA;
        Fri,  5 Jun 2020 16:25:45 +0000 (UTC)
Date:   Fri, 5 Jun 2020 12:25:44 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/30] xfs: remove IO submission from xfs_reclaim_inode()
Message-ID: <20200605162544.GB23747@bfoster>
References: <20200604074606.266213-1-david@fromorbit.com>
 <20200604074606.266213-19-david@fromorbit.com>
 <20200604180814.GG17815@bfoster>
 <20200604225342.GT2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604225342.GT2040@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 05, 2020 at 08:53:42AM +1000, Dave Chinner wrote:
> On Thu, Jun 04, 2020 at 02:08:14PM -0400, Brian Foster wrote:
> > On Thu, Jun 04, 2020 at 05:45:54PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > We no longer need to issue IO from shrinker based inode reclaim to
> > > prevent spurious OOM killer invocation. This leaves only the global
> > > filesystem management operations such as unmount needing to
> > > writeback dirty inodes and reclaim them.
> > > 
> > > Instead of using the reclaim pass to write dirty inodes before
> > > reclaiming them, use the AIL to push all the dirty inodes before we
> > > try to reclaim them. This allows us to remove all the conditional
> > > SYNC_WAIT locking and the writeback code from xfs_reclaim_inode()
> > > and greatly simplify the checks we need to do to reclaim an inode.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  fs/xfs/xfs_icache.c | 117 ++++++++++++--------------------------------
> > >  1 file changed, 31 insertions(+), 86 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > > index a6780942034fc..74032316ce5cc 100644
> > > --- a/fs/xfs/xfs_icache.c
> > > +++ b/fs/xfs/xfs_icache.c
> > ...
> > > @@ -1341,9 +1288,8 @@ xfs_reclaim_inodes_ag(
> > >  			for (i = 0; i < nr_found; i++) {
> > >  				if (!batch[i])
> > >  					continue;
> > > -				error = xfs_reclaim_inode(batch[i], pag, flags);
> > > -				if (error && last_error != -EFSCORRUPTED)
> > > -					last_error = error;
> > > +				if (!xfs_reclaim_inode(batch[i], pag, flags))
> > > +					skipped++;
> > 
> > Just a note that I find it a little bit of a landmine that skipped is
> > bumped on trylock failure of the perag reclaim lock when the
> > xfs_reclaim_inodes() caller can now spin on that.
> 
> Intentional, because without bumping skipped on perag reclaim lock
> failure we can silently skip entire AGs when doing blocking reclaim
> and xfs_reclaim_inodes() fails to reclaim all inodes in the cache.
> 
> It's only necessary to work around fatal bugs this patch exposes
> for the brief period that this infrastructure is being torn down by
> this patchset....
> 
> > It doesn't appear to
> > be an issue with current users, though (xfs_reclaim_workers() passes
> > SYNC_TRYLOCK but not SYNC_WAIT).
> 
> xfs_reclaim_workers() is optimisitic, background reclaim, so we
> just don't care if it skips over things. We just don't want it to
> block.
> 

Sure, I'm just warning that this puts in place infrastructure that is
easily possible to misuse in a way that could lead to livelocks. If it's
torn done by the end of the series then it's not a problem. If not, we
should probably consider hardening it somehow or another after the
series so we don't leave ourselves a landmine to step on.

Brian

> > >  			}
> > >  
> > >  			*nr_to_scan -= XFS_LOOKUP_BATCH;
> > ...
> > > @@ -1380,8 +1314,18 @@ xfs_reclaim_inodes(
> > >  	int		mode)
> > >  {
> > >  	int		nr_to_scan = INT_MAX;
> > > +	int		skipped;
> > >  
> > > -	return xfs_reclaim_inodes_ag(mp, mode, &nr_to_scan);
> > > +	xfs_reclaim_inodes_ag(mp, mode, &nr_to_scan);
> > > +	if (!(mode & SYNC_WAIT))
> > > +		return 0;
> > > +
> > 
> > Any reason we fall into the loop below if SYNC_WAIT was passed but the
> > above xfs_reclaim_inodes_ag() call would have returned 0?
> 
> Same thing again. It's temporary to maintain correctness while one
> thing at time is removed from the reclaim code. This code goes away
> in the same patch that makes SYNC_WAIT go away.
> 
> > Looks reasonable other than that inefficiency:
> > 
> > Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> Thanks!
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

