Return-Path: <SRS0=Xde3=3T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71E2EC2D0DB
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jan 2020 20:27:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4323820708
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jan 2020 20:27:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gmm3Gpgx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbgA3U1y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Jan 2020 15:27:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44505 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726514AbgA3U1y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Jan 2020 15:27:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580416073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HzjnQ/k9w5KcIzzpsMKc7B81zqkJ7BnMXjWRvT/v2M4=;
        b=Gmm3Gpgxxit+0el2UBzCy/uzl2YExqKvujqKRxo3y0RV4y4ajAbdmmOgJcv8Hi4jC11X39
        tKMTxVcZjX8swL1LYD7/mEAEcDdFEZdBh/zTlBgM/LI7V93FDA79lPaebYP+c+SchyBYoI
        eXWWK60jP1++pNaPfP/9sPv6EXJhjj4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-pxBimR36PBmiuRWwU7n1tw-1; Thu, 30 Jan 2020 15:27:50 -0500
X-MC-Unique: pxBimR36PBmiuRWwU7n1tw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6AA548010CB;
        Thu, 30 Jan 2020 20:27:49 +0000 (UTC)
Received: from redhat.com (ovpn-121-47.rdu2.redhat.com [10.10.121.47])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 96C6A77920;
        Thu, 30 Jan 2020 20:27:48 +0000 (UTC)
Date:   Thu, 30 Jan 2020 14:27:46 -0600
From:   Bill O'Donnell <billodo@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Pavel Reichl <preichl@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: change xfs_isilocked() to always use lockdep()
Message-ID: <20200130202746.GB118904@redhat.com>
References: <20200128145528.2093039-1-preichl@redhat.com>
 <20200128145528.2093039-2-preichl@redhat.com>
 <20200129221819.GO18610@dread.disaster.area>
 <20200130074424.GA26672@infradead.org>
 <20200130201447.GQ18610@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200130201447.GQ18610@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 31, 2020 at 07:14:47AM +1100, Dave Chinner wrote:
> On Wed, Jan 29, 2020 at 11:44:24PM -0800, Christoph Hellwig wrote:
> > On Thu, Jan 30, 2020 at 09:18:19AM +1100, Dave Chinner wrote:
> > > This captures both read and write locks on the rwsem, and doesn't
> > > discriminate at all. Now we don't have explicit writer lock checking
> > > in CONFIG_XFS_DEBUG=y kernels, I think we need to at least check
> > > that the rwsem is locked in all cases to catch cases where we are
> > > calling a function without the lock held. That will ctach most
> > > programming mistakes, and then lockdep will provide the
> > > read-vs-write discrimination to catch the "hold the wrong lock type"
> > > mistakes.
> > > 
> > > Hence I think this code should end up looking like this:
> > > 
> > > 	if (lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) {
> > > 		bool locked = false;
> > > 
> > > 		if (!rwsem_is_locked(&ip->i_lock))
> > > 			return false;
> > > 		if (!debug_locks)
> > > 			return true;
> > > 		if (lock_flags & XFS_ILOCK_EXCL)
> > > 			locked = lockdep_is_held_type(&ip->i_lock, 0);
> > > 		if (lock_flags & XFS_ILOCK_SHARED)
> > > 			locked |= lockdep_is_held_type(&ip->i_lock, 1);
> > > 		return locked;
> > > 	}
> > > 
> > > Thoughts?
> > 
> > I like the idea, but I really think that this does not belong into XFS,
> > but into the core rwsem code.  That means replacing the lock_flags with
> > a bool exclusive, picking a good name for it (can't think of one right
> > now, except for re-using rwsem_is_locked), and adding a kerneldoc
> > comment explaining the semantics and use cases in detail.
> 
> I'd say that's the step after removing mrlocks in XFS. Get this
> patchset sorted, then lift the rwsem checking function to the core
> code as a separate patchset that can be handled indepedently to the
> changes we need to make to XFS...

I agree with this approach, with modification of rwsem checking code as
as separate follow-on patchset.
Thanks-
Bill

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

