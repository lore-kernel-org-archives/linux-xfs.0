Return-Path: <SRS0=Xde3=3T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9417EC33C9E
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jan 2020 07:44:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E195206F0
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jan 2020 07:44:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KtQkGdIj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgA3Ho0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Jan 2020 02:44:26 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:41326 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbgA3Ho0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Jan 2020 02:44:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=mkZpFICk6JHjdkqn5t4Eq8WtAKhDPwVpkuEBpmbna80=; b=KtQkGdIj1DWdWLBkiXF+9hiOT
        ymfFUFsGljTC3qTn48hETOBEoILkTIvW85ru9c2dn+t9TljS+Ke+9EWG9m5dgOIlQ9TzH2w0+Nre+
        q2TbUvNp/34aF25HJCNFsbjqRbebye6SBqCe1jqKhwO2St5pG+qJxwbvpLnrQfdkFdfYx9NMMQF0j
        qDOMQPV30T3dPeB6ZTNZqAl/JShsJva3YSj0eQbqqdWx7PzWzexfP1ArLZlD0vYKPwmZUP4DlDhXZ
        wUMk7EMATNilibG7Q4TErEMuzoNgZkr6hmZksJw02MnzIwt2zO3DQCBGlSd3laEqjaxXh0Cfixj+j
        4lMPEh57g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ix4Uy-00076e-Uk; Thu, 30 Jan 2020 07:44:24 +0000
Date:   Wed, 29 Jan 2020 23:44:24 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Pavel Reichl <preichl@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: change xfs_isilocked() to always use lockdep()
Message-ID: <20200130074424.GA26672@infradead.org>
References: <20200128145528.2093039-1-preichl@redhat.com>
 <20200128145528.2093039-2-preichl@redhat.com>
 <20200129221819.GO18610@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200129221819.GO18610@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 30, 2020 at 09:18:19AM +1100, Dave Chinner wrote:
> This captures both read and write locks on the rwsem, and doesn't
> discriminate at all. Now we don't have explicit writer lock checking
> in CONFIG_XFS_DEBUG=y kernels, I think we need to at least check
> that the rwsem is locked in all cases to catch cases where we are
> calling a function without the lock held. That will ctach most
> programming mistakes, and then lockdep will provide the
> read-vs-write discrimination to catch the "hold the wrong lock type"
> mistakes.
> 
> Hence I think this code should end up looking like this:
> 
> 	if (lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) {
> 		bool locked = false;
> 
> 		if (!rwsem_is_locked(&ip->i_lock))
> 			return false;
> 		if (!debug_locks)
> 			return true;
> 		if (lock_flags & XFS_ILOCK_EXCL)
> 			locked = lockdep_is_held_type(&ip->i_lock, 0);
> 		if (lock_flags & XFS_ILOCK_SHARED)
> 			locked |= lockdep_is_held_type(&ip->i_lock, 1);
> 		return locked;
> 	}
> 
> Thoughts?

I like the idea, but I really think that this does not belong into XFS,
but into the core rwsem code.  That means replacing the lock_flags with
a bool exclusive, picking a good name for it (can't think of one right
now, except for re-using rwsem_is_locked), and adding a kerneldoc
comment explaining the semantics and use cases in detail.
