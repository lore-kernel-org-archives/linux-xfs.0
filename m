Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D846C433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Mar 2021 18:47:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E49E764F4B
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Mar 2021 18:47:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231800AbhCOSqt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Mar 2021 14:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbhCOSqV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Mar 2021 14:46:21 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC98C06174A
        for <linux-xfs@vger.kernel.org>; Mon, 15 Mar 2021 11:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Qpxxa24cA6nVCDtFYfsbwCvOUIR49Q1Ym3oMCS1H7KA=; b=C9xEUWrl+ojKAJMmvoNEjahvRV
        yWwzMHy5PssetNvD7MQhVCGywDPEyhPr8KsR8S0FeTucHKdsRQcGsVuek83GICufYvWv0gD8XIn09
        RRsNNxKvm1/3U4XChAuqtEZRFb+SrmXYwt7refgidjvJl7eaoxVXlPBf4JexhsZ5FgQPE09cRuxoH
        NwLEGUIxxMm8Ly4rk02+brqWOmSCqtkBsWMQCDyH2Zfef/1WtvvSiIhGroie7GKv3bzft7c7gsNOX
        sfTZ1l1wuSajjyJdmZ16cHWvfQQtCq/4i8A/Ti35P1ayU1AMll2i8EsC6BwOJ8UcbgfbkZ5G0unOI
        QHvMJjbQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lLsEJ-000c63-2o; Mon, 15 Mar 2021 18:46:17 +0000
Date:   Mon, 15 Mar 2021 18:46:15 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/11] xfs: refactor the predicate part of
 xfs_free_eofblocks
Message-ID: <20210315184615.GB140421@infradead.org>
References: <161543194009.1947934.9910987247994410125.stgit@magnolia>
 <161543195167.1947934.16237799936089844524.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161543195167.1947934.16237799936089844524.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Going further through the series actually made me go back to this one,
so a few more comments:

>  /*
> + * Decide if this inode have post-EOF blocks.  The caller is responsible
> + * for knowing / caring about the PREALLOC/APPEND flags.

Please spell out the XFS_DIFLAG_ here, as this really confused me.  In
fact even with that it still confuses me, as "caller is responsible"
here really means: only call this if you previously called
xfs_can_free_eofblocks and it return true.

Which brings me to the structure of this:  I think without much pain
we can ensure xfs_can_free_eofblocks is always called with the iolock,
in which case we really should merge xfs_can_free_eofblocks and this
new helper to avoid the rather confusing fact that we have two similarly
named helper doing similiar but not the same thing.

>  int
> +xfs_has_eofblocks(
> +	struct xfs_inode	*ip,
> +	bool			*has)

I also think the calling convention can be simplified here.  If an
error occurs we obviously do not want to free the eofblocks.  So
instead of returning two calues we can just return a single bool.
