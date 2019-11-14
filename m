Return-Path: <SRS0=4PMG=ZG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46A18C432C3
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 14:53:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01D52206F0
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 14:53:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="N3M3mv0x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbfKNOx6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Nov 2019 09:53:58 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:50114 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfKNOx6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Nov 2019 09:53:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=/LkujawD9BpR78iWhtBSt8Vd3d1cINPe05QwYpS6+zc=; b=N3M3mv0xGqSGJzF/emRpFnB4u
        RpSoDxH9X0pO7RKqZP7Q6lzbMecpuMAAPfJoOm+rLXCp+0B/1HsOrgavIPFggtvZghRJX+3ZXxrEH
        KUQewUj/AVgK3s40IyLdRquuAt3r+HRWgIlk66MNDyUAo7nBKSYpyons2bXTZdc5tDycxSL4RK2bJ
        6YqmhxtLFYSPzXoAefu8oTCgOCcoFxpkEW7xioLmz4ApehW27ltxYXwgKCVstiHL2en1ZoH+28HjM
        FqvdWVuqMrPOPAbeEdR+prdntE0AL73ulxB/ndme+djGj9CPLPAvTDVZK74Suo7nsJOL9Yrq3FfA3
        g45wWvrTA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iVGVO-0004lp-Mo; Thu, 14 Nov 2019 14:53:54 +0000
Date:   Thu, 14 Nov 2019 06:53:54 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: attach dquots before performing xfs_swap_extents
Message-ID: <20191114145354.GA17290@infradead.org>
References: <157343509505.1948946.5379830250503479422.stgit@magnolia>
 <157343511427.1948946.2692071497822316839.stgit@magnolia>
 <20191111080503.GC4548@infradead.org>
 <20191112221448.GQ4614@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112221448.GQ4614@dread.disaster.area>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 13, 2019 at 09:14:48AM +1100, Dave Chinner wrote:
> If the dquots are not attached to the inode, how would you pass the
> 3 dquots per inode down the stack to where they are actually used
> inside the filesystem? I mean, we have to get the dquots attached to
> the transaction so we can update them in xfs_trans_commit ->
> xfs_trans_apply_dquot_deltas(), so somehow we'd have to get them
> from the high level file/inode operations down to the XFS
> transaction context. And things like writeback need dquots attached
> for delayed allocation, so various aops would need to do dquot
> lookups, too...

My prime idea was to attach them to the transaction and keep them
over transaction roles.  Then see what is left and probably use an
on-stack struct containing three dquots.  At that point I know if
that idea was feasible, because if we have too many deep callstacks
where we need to pass that struct it obviously isn't.

> I can see the advantage of doing rcu dquot cache lookups in the xfs
> context where we are attaching the dquots to the transaction rather
> than attaching them to the inode, but I can't see how the "do it at
> a high level" aspect of this would work....

Most of our ops really just have one transaction / set of rolled
over permanent transactions, because if they didn't they wouldn't
be atomic..
