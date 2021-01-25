Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F3CBC433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Jan 2021 23:51:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14909229EF
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Jan 2021 23:51:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732138AbhAYVJb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Jan 2021 16:09:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59124 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732343AbhAYVIB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Jan 2021 16:08:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611608794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2jY29J4XHDYjWsKf2k1OPQJEP+pWBWgU5LsH2laalbc=;
        b=caYZEGG07+WdcyCRYjuyrF0ok/dvTf1zZ64LD3MQd5eHdrFLthxPhiJjicmNiR/SrrJnX1
        +nYNrl0ZaFQxSpbts4PxRfgR+Cn/fCKBpcZ+jZG2GNsC9L6X3MvnXu3rJwuWc2cPAKkpNI
        soIigtpB9LunzT0t7/ai9oG32LnNfp8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-538-raVo0WyoMaaItsiO_p_liw-1; Mon, 25 Jan 2021 16:06:31 -0500
X-MC-Unique: raVo0WyoMaaItsiO_p_liw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 71A9F8030A0;
        Mon, 25 Jan 2021 21:06:30 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E827419C47;
        Mon, 25 Jan 2021 21:06:29 +0000 (UTC)
Date:   Mon, 25 Jan 2021 16:06:28 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        david@fromorbit.com
Subject: Re: [PATCH 11/11] xfs: flush speculative space allocations when we
 run out of space
Message-ID: <20210125210628.GP2047559@bfoster>
References: <161142791950.2171939.3320927557987463636.stgit@magnolia>
 <161142798066.2171939.9311024588681972086.stgit@magnolia>
 <20210124094816.GE670331@infradead.org>
 <20210125200216.GE7698@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125200216.GE7698@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 25, 2021 at 12:02:16PM -0800, Darrick J. Wong wrote:
> On Sun, Jan 24, 2021 at 09:48:16AM +0000, Christoph Hellwig wrote:
> > > +retry:
> > >  	/*
> > >  	 * Allocate the handle before we do our freeze accounting and setting up
> > >  	 * GFP_NOFS allocation context so that we avoid lockdep false positives
> > > @@ -285,6 +289,22 @@ xfs_trans_alloc(
> > >  	tp->t_firstblock = NULLFSBLOCK;
> > >  
> > >  	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
> > > +	if (error == -ENOSPC && tries > 0) {
> > > +		xfs_trans_cancel(tp);
> > > +
> > > +		/*
> > > +		 * We weren't able to reserve enough space for the transaction.
> > > +		 * Flush the other speculative space allocations to free space.
> > > +		 * Do not perform a synchronous scan because callers can hold
> > > +		 * other locks.
> > > +		 */
> > > +		error = xfs_blockgc_free_space(mp, NULL);
> > > +		if (error)
> > > +			return error;
> > > +
> > > +		tries--;
> > > +		goto retry;
> > > +	}
> > >  	if (error) {
> > >  		xfs_trans_cancel(tp);
> > >  		return error;
> > 
> > Why do we need to restart the whole function?  A failing
> > xfs_trans_reserve should restore tp to its initial state, and keeping
> > the SB_FREEZE_FS counter increased also doesn't look harmful as far as
> > I can tell.  So why not:
> > 
> > 	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
> > 	if (error == -ENOSPC) {
> > 		/*
> > 		 * We weren't able to reserve enough space for the transaction.
> > 		 * Flush the other speculative space allocations to free space.
> > 		 * Do not perform a synchronous scan because callers can hold
> > 		 * other locks.
> > 		 */
> > 		error = xfs_blockgc_free_space(mp, NULL);
> 
> xfs_blockgc_free_space runs the blockgc scan directly, which means that
> it creates transactions to free blocks.  Since we can't have nested
> transactions, we have to drop tp here.
> 

Technically, I don't think it's a problem to hold a transaction memory
allocation (and superblock write access?) while diving into the scanning
mechanism. BTW, this also looks like a landmine passing a NULL eofb into
the xfs_blockgc_free_space() tracepoint.

Brian

> --D
> 
> > 		if (error)
> > 			return error;
> > 		error = xfs_trans_reserve(tp, resp, blocks, rtextents);
> > 	}
> >  	if (error) {
> >   		xfs_trans_cancel(tp);
> >   		return error;
> > 
> > ?
> 

