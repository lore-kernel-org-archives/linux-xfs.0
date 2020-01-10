Return-Path: <SRS0=1MH2=27=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 669EEC33CA2
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jan 2020 11:57:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38F552072A
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jan 2020 11:57:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Z6g2T66X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727949AbgAJL5m (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jan 2020 06:57:42 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:35098 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727710AbgAJL5m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jan 2020 06:57:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=x0DSt55co83hYVzLtSNJTN5LSd7ti99psefmVUr/k2Q=; b=Z6g2T66Xy6AoEwlmqdbbQ6Jyg
        LAhvCfzVlMYwkz1MQwxjnkAtUlJboDvxnDYu+NHJyNjDjIA/3mMSxkp7WesRbbVFvKrHiK1f/WzpZ
        9d8vzPeYvcibnuOKKQWFwIolZUCvy5ZsjztL95yuXNW8OwkrQde63RmnvybZfM7MoKjo/G1o+aibn
        hV0bZ95sQatPFBqiu5UG0KflmqwBU/2MeXQZNrQC2FJcqXjM3VNnthL8OAx2P2lvmD4VFZ9Yj2i1s
        N9H6hHWVdb3TQUY/93Mw7Au6vRzf7yrrz0a1K5SkPE+tSP25tNpLUHIowG/p2PwmwqQ3gxf2Cs6m2
        OfV2uHqvQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ipsv8-00027x-DJ; Fri, 10 Jan 2020 11:57:42 +0000
Date:   Fri, 10 Jan 2020 03:57:42 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: fix memory corruption during remote attr value
 buffer invalidation
Message-ID: <20200110115742.GD19577@infradead.org>
References: <157859548029.164065.5207227581806532577.stgit@magnolia>
 <157859549406.164065.17179006268680393660.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157859549406.164065.17179006268680393660.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> While running generic/103, I observed what looks like memory corruption
> and (with slub debugging turned on) a slub redzone warning on i386 when
> inactivating an inode with a 64k remote attr value.
> 
> On a v5 filesystem, maximally sized remote attr values require one block
> more than 64k worth of space to hold both the remote attribute value
> header (64 bytes).  On a 4k block filesystem this results in a 68k
> buffer; on a 64k block filesystem, this would be a 128k buffer.  Note
> that even though we'll never use more than 65,600 bytes of this buffer,
> XFS_MAX_BLOCKSIZE is 64k.
> 
> This is a problem because the definition of struct xfs_buf_log_format
> allows for XFS_MAX_BLOCKSIZE worth of dirty bitmap (64k).  On i386 when we
> invalidate a remote attribute, xfs_trans_binval zeroes all 68k worth of
> the dirty map, writing right off the end of the log item and corrupting
> memory.  We've gotten away with this on x86_64 for years because the
> compiler inserts a u32 padding on the end of struct xfs_buf_log_format.
> 
> Fortunately for us, remote attribute values are written to disk with
> xfs_bwrite(), which is to say that they are not logged.  Fix the problem
> by removing all places where we could end up creating a buffer log item
> for a remote attribute value and leave a note explaining why.

I think this changelog needs an explanation why using
xfs_attr_rmtval_stale which just trylock and checks if the buffers are
in core only in xfs_attr3_leaf_freextent is fine.  And while the incore
part looks sane to me, I think the trylock is wrong and we need to pass
the locking flag to xfs_attr_rmtval_stale.
