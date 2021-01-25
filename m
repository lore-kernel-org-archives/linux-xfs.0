Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 533F4C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Jan 2021 18:18:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCA2622ADC
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Jan 2021 18:18:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbhAYSS1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Jan 2021 13:18:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52270 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726194AbhAYSRz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Jan 2021 13:17:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611598588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LejV2EZMn9mdxo0Gqh9ayzMCmH+dyWilQ5Yd0R9HDeY=;
        b=ZbF77/3Y5DKPFmE886LfQpFHk9hOsP3JoQrqhc2581mGibRtGTUXwXKZm2syti4JXdWH8K
        1VxhFTZDdNZfSz4lz5kdVS/Q4gWU2kZ+KZ5XU5Ey32qKGhuEJ/VNoUqFsy7ILExWElc+G9
        PgIxiWJI1uMGyv8/cZMH0UISNz4lKgs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-111-aMBkB1-2O8iFCI2WprnMPw-1; Mon, 25 Jan 2021 13:16:27 -0500
X-MC-Unique: aMBkB1-2O8iFCI2WprnMPw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C33A0100C661;
        Mon, 25 Jan 2021 18:16:25 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4030C5C1C5;
        Mon, 25 Jan 2021 18:16:25 +0000 (UTC)
Date:   Mon, 25 Jan 2021 13:16:23 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        david@fromorbit.com
Subject: Re: [PATCH 06/11] xfs: flush eof/cowblocks if we can't reserve quota
 for file blocks
Message-ID: <20210125181623.GL2047559@bfoster>
References: <161142791950.2171939.3320927557987463636.stgit@magnolia>
 <161142795294.2171939.2305516748220731694.stgit@magnolia>
 <20210124093953.GC670331@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210124093953.GC670331@infradead.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jan 24, 2021 at 09:39:53AM +0000, Christoph Hellwig wrote:
> > +	/* We only allow one retry for EDQUOT/ENOSPC. */
> > +	if (*retry || (error != -EDQUOT && error != -ENOSPC)) {
> > +		*retry = false;
> > +		return error;
> > +	}
> 
> > +	/* Release resources, prepare for scan. */
> > +	xfs_trans_cancel(*tpp);
> > +	*tpp = NULL;
> > +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > +
> > +	/* Try to free some quota for this file's dquots. */
> > +	*retry = true;
> > +	xfs_blockgc_free_quota(ip, 0);
> > +	return 0;
> 
> I till have grave reservations about this calling conventions.  And if
> you just remove the unlock and th call to xfs_blockgc_free_quota here
> we don't equire a whole lot of boilerplate code in the callers while
> making the code possible to reason about for a mere human.
> 

I agree that the retry pattern is rather odd. I'm curious, is there a
specific reason this scanning task has to execute outside of transaction
context in the first place? Assuming it does because the underlying work
may involve more transactions or whatnot, I'm wondering if this logic
could be buried further down in the transaction allocation path.

For example, if we passed the quota reservation and inode down into a
new variant of xfs_trans_alloc(), it could acquire the ilock and attempt
the quota reservation as a final step (to avoid adding an extra
unconditional ilock cycle). If quota res fails, iunlock and release the
log res internally and perform the scan. From there, perhaps we could
retry the quota reservation immediately without logres or the ilock by
saving references to the dquots, and then only reacquire logres/ilock on
success..? Just thinking out loud so that might require further
thought...

Brian

