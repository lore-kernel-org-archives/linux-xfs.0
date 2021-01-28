Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4474EC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 09:31:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E34BA60C3D
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 09:31:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232406AbhA1JaL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 04:30:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232539AbhA1J0q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jan 2021 04:26:46 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5D1C061574
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jan 2021 01:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4ZedBZGyO5u3bkmeOkfghV7+kv+l7F+9SJqxyIPEtdQ=; b=pToaKlxnCWrKKbOwbgfRkblv/i
        jr+I0Kvf6DJgwQqV9/MFfQf12N+y1oZB31zDZe2jQI0Fc6pEc7DIt7vI8B5yWQXOuaRwbFo031uZd
        10wlIsinKCB+KpsH5NyzE3kymE4DMZ+gwvNZhs10cJTaJz15iuYAjMpurXmJj88HjBcsy+vAnCAyX
        Pb71hnrQKbxFJZWuwN8K2GBk5mWfEwGgJSjN1cDaa8yewM5xSvrCNsZTTEsvJMNC1zkmpm7mPb8AP
        LYvblMd6zS9NgSzoNh9Pd+qX2pygJIc4xBfubzF5jZuISHyhYZPHaEGQKWPPaNR8t2rpwuDzw1GoG
        WgNhyccg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l53Yv-008G45-Jr; Thu, 28 Jan 2021 09:26:02 +0000
Date:   Thu, 28 Jan 2021 09:26:01 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Subject: Re: [PATCH 06/11] xfs: flush eof/cowblocks if we can't reserve quota
 for file blocks
Message-ID: <20210128092601.GA1967319@infradead.org>
References: <161181374062.1525026.14717838769921652940.stgit@magnolia>
 <161181377500.1525026.4807452419379444724.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161181377500.1525026.4807452419379444724.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +void
> +xfs_trans_cancel_qretry_nblks(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*ip)
> +{
> +	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> +
> +	xfs_trans_cancel(tp);
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	xfs_blockgc_free_quota(ip, 0);
> +}

I still find this helper a little weird.  Why not cancel the transaction
in xfs_trans_reserve_quota_nblks, and then just open code the calls to
xfs_iunlock and xfs_blockgc_free_quota in the callers?
