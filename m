Return-Path: <SRS0=QbY/=2I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A461C43603
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 12:10:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EF102072B
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 12:10:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W1cELG/0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbfLRMKj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Dec 2019 07:10:39 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:40505 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726141AbfLRMKj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Dec 2019 07:10:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576671038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z+5mz3F6uqH+NcMfXKj6tEQ0HIa1GOVPaCUuG9eRhv8=;
        b=W1cELG/0XlSMa5la7/n2o68rhTrPySyk2hZyAsWmdOKrf1bqNBINjeobiNw7hp0YI2nvIT
        VuaRGNZFToIMW1WJjHwDqhmTt0dodIoxgKmvVmbjd97IWHEAAdbrKoK/0HmRaj5cOt+1YY
        JLq9+T81gKRxLv9stAwo+M60wfxyaYs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-9U8m6rwVPUa2gDahqoejTA-1; Wed, 18 Dec 2019 07:10:36 -0500
X-MC-Unique: 9U8m6rwVPUa2gDahqoejTA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E3CE8017DF;
        Wed, 18 Dec 2019 12:10:35 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 451685C28D;
        Wed, 18 Dec 2019 12:10:35 +0000 (UTC)
Date:   Wed, 18 Dec 2019 07:10:33 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: rework insert range into an atomic operation
Message-ID: <20191218121033.GA63809@bfoster>
References: <20191213171258.36934-1-bfoster@redhat.com>
 <20191213171258.36934-3-bfoster@redhat.com>
 <20191218023726.GH12765@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218023726.GH12765@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 17, 2019 at 06:37:26PM -0800, Darrick J. Wong wrote:
> On Fri, Dec 13, 2019 at 12:12:57PM -0500, Brian Foster wrote:
> > The insert range operation uses a unique transaction and ilock cycle
> > for the extent split and each extent shift iteration of the overall
> > operation. While this works, it is risks racing with other
> > operations in subtle ways such as COW writeback modifying an extent
> > tree in the middle of a shift operation.
> > 
> > To avoid this problem, make insert range atomic with respect to
> > ilock. Hold the ilock across the entire operation, replace the
> > individual transactions with a single rolling transaction sequence
> > and relog the inode to keep it moving in the log. This guarantees
> > that nothing else can change the extent mapping of an inode while
> > an insert range operation is in progress.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_bmap_util.c | 32 +++++++++++++-------------------
> >  1 file changed, 13 insertions(+), 19 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > index 829ab1a804c9..555c8b49a223 100644
> > --- a/fs/xfs/xfs_bmap_util.c
> > +++ b/fs/xfs/xfs_bmap_util.c
> > @@ -1134,47 +1134,41 @@ xfs_insert_file_space(
> >  	if (error)
> >  		return error;
> >  
> > -	/*
> > -	 * The extent shifting code works on extent granularity. So, if stop_fsb
> > -	 * is not the starting block of extent, we need to split the extent at
> > -	 * stop_fsb.
> > -	 */
> >  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write,
> >  			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0, 0, &tp);
> >  	if (error)
> >  		return error;
> >  
> >  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > -	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> > +	xfs_trans_ijoin(tp, ip, 0);
> >  
> > +	/*
> > +	 * The extent shifting code works on extent granularity. So, if stop_fsb
> > +	 * is not the starting block of extent, we need to split the extent at
> > +	 * stop_fsb.
> > +	 */
> >  	error = xfs_bmap_split_extent(tp, ip, stop_fsb);
> >  	if (error)
> >  		goto out_trans_cancel;
> >  
> > -	error = xfs_trans_commit(tp);
> > -	if (error)
> > -		return error;
> > -
> > -	while (!error && !done) {
> > -		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0, 0,
> > -					&tp);
> 
> I'm a little concerned about the livelock potential here, if there are a lot of
> other threads that have eaten all the transaction reservation and are trying to
> get our ILOCK, while at the same time this thread has the ILOCK and is trying
> to roll the transaction to move another extent, having already rolled the
> transaction more than logcount times.
> 

My understanding is that the regrant mechanism is intended to deal with
that scenario. Even after the initial (res * logcount) reservation is
consumed, a regrant is different from an initial reservation in that the
reservation head is unconditionally updated with a new reservation unit.
We do wait on the write head in regrant, but IIUC that should be limited
to the pool of already allocated transactions (and is woken before the
reserve head waiters IIRC). I suppose something like this might be
possible in theory if we were blocked on regrant and the entirety of
remaining log space was consumed by transactions waiting on our ilock,
but I think that is highly unlikely since we also hold the iolock here.

Also note that this approach is based on the current truncate algorithm,
which is probably a better barometer of potential for this kind of issue
as it is a less specialized operation. I'd argue that if this is safe
enough for truncate, it should be safe enough for range shifting.

> I think the extent shifting loop starts with the highest offset mapping and
> shifts it up and continues in order of decreasing offset until it gets to
>  @stop_fsb, correct?
> 

Yep, for insert range at least.

> Can we use "alloc trans; ilock; move; commit" for every extent higher than the
> one that crosses @stop_fsb, and use "alloc trans; ilock; split; roll;
> insert_extents; commit" to deal with that one extent that crosses @stop_fsb?
> tr_write pre-reserves enough space to that the roll won't need to get more,
> which would eliminate that potential problem, I think.
> 

We'd have to reorder the extent split for that kind of approach, which I
think you've noted in the sequence above, as the race window is between
the split and subsequent shift. Otherwise I think that would work.

That said, I'd prefer not to introduce the extra complexity and
functional variance unless it were absolutely necessary, and it's not
clear to me that it is. If it is, we'd probably have seen similar issues
in truncate and should target a fix there before worrying about range
shift.

Brian

> --D
> 
> > +	do {
> > +		error = xfs_trans_roll_inode(&tp, ip);
> >  		if (error)
> > -			break;
> > +			goto out_trans_cancel;
> >  
> > -		xfs_ilock(ip, XFS_ILOCK_EXCL);
> > -		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> >  		error = xfs_bmap_insert_extents(tp, ip, &next_fsb, shift_fsb,
> >  				&done, stop_fsb);
> >  		if (error)
> >  			goto out_trans_cancel;
> > +	} while (!done);
> >  
> > -		error = xfs_trans_commit(tp);
> > -	}
> > -
> > +	error = xfs_trans_commit(tp);
> > +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> >  	return error;
> >  
> >  out_trans_cancel:
> >  	xfs_trans_cancel(tp);
> > +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> >  	return error;
> >  }
> >  
> > -- 
> > 2.20.1
> > 
> 

