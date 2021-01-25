Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC875C433E9
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 20:22:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E2F822A85
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 20:22:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbhAZFSy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 00:18:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37463 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730607AbhAYSsA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Jan 2021 13:48:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611600392;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wYXW6owGMrMXzO6b4yjCzvhJhtVuXSm8n1/BYYrygyI=;
        b=BNL2aMefb8ReEymyXn99zNbVnlLno+O8bcY5LZP1gc5tjtDGdPivNTeFjoWBKoXwjMYnLU
        ASY4HBl0Wd5yY000cuej4OEzUuFZ9rWuaUeV10A24PuyHAciYbz/j68TE2F57NHL1+6VQq
        tgt62tIJRGJuwI2BmSPeo00PdZvWK8w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-477-CaahO_lCPxysTxU5IzZiuA-1; Mon, 25 Jan 2021 13:46:30 -0500
X-MC-Unique: CaahO_lCPxysTxU5IzZiuA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2A828144E0;
        Mon, 25 Jan 2021 18:46:29 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 402965D734;
        Mon, 25 Jan 2021 18:46:29 +0000 (UTC)
Date:   Mon, 25 Jan 2021 13:46:27 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        david@fromorbit.com
Subject: Re: [PATCH 11/11] xfs: flush speculative space allocations when we
 run out of space
Message-ID: <20210125184627.GO2047559@bfoster>
References: <161142791950.2171939.3320927557987463636.stgit@magnolia>
 <161142798066.2171939.9311024588681972086.stgit@magnolia>
 <20210124094816.GE670331@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210124094816.GE670331@infradead.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jan 24, 2021 at 09:48:16AM +0000, Christoph Hellwig wrote:
> > +retry:
> >  	/*
> >  	 * Allocate the handle before we do our freeze accounting and setting up
> >  	 * GFP_NOFS allocation context so that we avoid lockdep false positives
> > @@ -285,6 +289,22 @@ xfs_trans_alloc(
> >  	tp->t_firstblock = NULLFSBLOCK;
> >  
> >  	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
> > +	if (error == -ENOSPC && tries > 0) {
> > +		xfs_trans_cancel(tp);
> > +
> > +		/*
> > +		 * We weren't able to reserve enough space for the transaction.
> > +		 * Flush the other speculative space allocations to free space.
> > +		 * Do not perform a synchronous scan because callers can hold
> > +		 * other locks.
> > +		 */
> > +		error = xfs_blockgc_free_space(mp, NULL);
> > +		if (error)
> > +			return error;
> > +
> > +		tries--;
> > +		goto retry;
> > +	}
> >  	if (error) {
> >  		xfs_trans_cancel(tp);
> >  		return error;
> 
> Why do we need to restart the whole function?  A failing
> xfs_trans_reserve should restore tp to its initial state, and keeping
> the SB_FREEZE_FS counter increased also doesn't look harmful as far as
> I can tell.  So why not:
> 
> 	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
> 	if (error == -ENOSPC) {
> 		/*
> 		 * We weren't able to reserve enough space for the transaction.
> 		 * Flush the other speculative space allocations to free space.
> 		 * Do not perform a synchronous scan because callers can hold
> 		 * other locks.
> 		 */
> 		error = xfs_blockgc_free_space(mp, NULL);
> 		if (error)
> 			return error;
> 		error = xfs_trans_reserve(tp, resp, blocks, rtextents);
> 	}
>  	if (error) {
>   		xfs_trans_cancel(tp);
>   		return error;
> 
> ?
> 

That looks cleaner to me, but similar to the earlier quota res patch I'm
wondering if this should be pushed down into xfs_trans_reserve() (or
lifted into a new xfs_trans_reserve_blks() helper called from there)
such that it can handle the various scan/retry scenarios in one place.

Brian

