Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84AE3C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 09:52:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25AEC64DD6
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 09:52:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbhA1Jw0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 04:52:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbhA1Jvs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jan 2021 04:51:48 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF7A8C061573
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jan 2021 01:50:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=IjrI4726QWWWEo0RKi4jqvxQIx
        3aAn+6lQ2FzVj5Ph2opG8Dyy+mvVgZBBLtQJX2HDfWNTdUqAYmy+RU1QazNql3fMx6t05msYZr2SV
        HERAuIFp7FDJlyw/EauGLFoWEFMFeyhFo05VPOFERzzHFL9xPQ8WIz1OW8ZROjEzvtp9G5Zts/nZh
        r8NPDrIY6S4gN3T6kL2F0XkTQuxFpXvFxKAE0hh0eBLfaXgxazd7AIy3hDnZumg57aD1L+X7Vx8/V
        3XIDUCBULxrK9OuiXbeNmBKRBlrQVULHONBgLf4K8axfwHIqJaM/fyo8sIGJWIJ8jWQqapUaKZnJY
        QwCbsvZQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l53ww-008Hqp-Tp; Thu, 28 Jan 2021 09:50:51 +0000
Date:   Thu, 28 Jan 2021 09:50:50 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Subject: Re: [PATCH 07/13] xfs: refactor common transaction/inode/quota
 allocation idiom
Message-ID: <20210128095050.GC1973802@infradead.org>
References: <161181366379.1523592.9213241916555622577.stgit@magnolia>
 <161181370409.1523592.1925953061702139800.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161181370409.1523592.1925953061702139800.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
