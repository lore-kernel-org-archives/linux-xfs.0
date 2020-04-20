Return-Path: <SRS0=5D7u=6E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E9C1C3A5A0
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 14:02:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1ECC521927
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 14:02:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e13KKvPR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgDTOC2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Apr 2020 10:02:28 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57131 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726871AbgDTOC2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Apr 2020 10:02:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587391347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Vz3Ki9u2n86m5yID5NJOJ6zt1qUFaqBUjM7QdT4xyeY=;
        b=e13KKvPR0PJ03HSJn0jKvhnraJHXzIxETzZe3dzlaaAbNfOOHYywgUYX5AadqahN0kEAs0
        YG8d8PvsMznJg0AVRCzvYs8YEo0s0nQzvrdxDh58k2fQ4k8XmEvwi3Tq63cCmRVOXmXky+
        8+ekGUVgYHGiT/WoBrAgXhExve4wFkY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-LKAW1GWaOYWV1cC0GQtD6w-1; Mon, 20 Apr 2020 10:02:24 -0400
X-MC-Unique: LKAW1GWaOYWV1cC0GQtD6w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB6BF802689;
        Mon, 20 Apr 2020 14:02:22 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A13315E001;
        Mon, 20 Apr 2020 14:02:22 +0000 (UTC)
Date:   Mon, 20 Apr 2020 10:02:21 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/12] xfs: remove duplicate verification from
 xfs_qm_dqflush()
Message-ID: <20200420140221.GF27516@bfoster>
References: <20200417150859.14734-1-bfoster@redhat.com>
 <20200417150859.14734-7-bfoster@redhat.com>
 <20200420035322.GI9800@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200420035322.GI9800@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 20, 2020 at 01:53:22PM +1000, Dave Chinner wrote:
> On Fri, Apr 17, 2020 at 11:08:53AM -0400, Brian Foster wrote:
> > The dquot read/write verifier calls xfs_dqblk_verify() on every
> > dquot in the buffer. Remove the duplicate call from
> > xfs_qm_dqflush().
> 
> Ah, I think there's a bug here - it's not supposed to be a
> duplicate....
> 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_dquot.c | 14 --------------
> >  1 file changed, 14 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> > index af2c8e5ceea0..73032c18a94a 100644
> > --- a/fs/xfs/xfs_dquot.c
> > +++ b/fs/xfs/xfs_dquot.c
> > @@ -1071,7 +1071,6 @@ xfs_qm_dqflush(
> >  	struct xfs_buf		*bp;
> >  	struct xfs_dqblk	*dqb;
> >  	struct xfs_disk_dquot	*ddqp;
> > -	xfs_failaddr_t		fa;
> >  	int			error;
> >  
> >  	ASSERT(XFS_DQ_IS_LOCKED(dqp));
> > @@ -1116,19 +1115,6 @@ xfs_qm_dqflush(
> >  	dqb = bp->b_addr + dqp->q_bufoffset;
> >  	ddqp = &dqb->dd_diskdq;
> >  
> > -	/*
> > -	 * A simple sanity check in case we got a corrupted dquot.
> > -	 */
> > -	fa = xfs_dqblk_verify(mp, dqb, be32_to_cpu(ddqp->d_id), 0);
> 
> So this verifies the on disk dquot ....
> 
> > -	if (fa) {
> > -		xfs_alert(mp, "corrupt dquot ID 0x%x in memory at %pS",
> 
> ...which issues an "in memory corruption" alert on failure...
> 
> > -				be32_to_cpu(ddqp->d_id), fa);
> > -		xfs_buf_relse(bp);
> > -		xfs_dqfunlock(dqp);
> > -		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> > -		return -EFSCORRUPTED;
> > -	}
> > -
> >  	/* This is the only portion of data that needs to persist */
> >  	memcpy(ddqp, &dqp->q_core, sizeof(struct xfs_disk_dquot));
> 
> .... and on success we immediately overwrite the on-disk copy with
> the unchecked in-memory copy of the dquot. 
> 
> IOWs, I think that verification call here should be checking the
> in-memory dquot core, not the on disk buffer that is about to get
> trashed.  i.e. something like this:
> 
> -	fa = xfs_dqblk_verify(mp, dqb, be32_to_cpu(ddqp->d_id), 0);
> +	fa = xfs_dquot_verify(mp, &dqp->q_core, be32_to_cpu(ddqp->d_id), 0);
> 

Isn't this still essentially duplicated by the write verifier? I don't
feel strongly about changing it as above vs. removing it, but it does
still seem unnecessary to me..

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

