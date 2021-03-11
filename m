Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0114CC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 13:01:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E3FC64FE0
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 13:01:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233282AbhCKNA7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Mar 2021 08:00:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233252AbhCKNAq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Mar 2021 08:00:46 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE9AC061574
        for <linux-xfs@vger.kernel.org>; Thu, 11 Mar 2021 05:00:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=VxTmwKIMEW7HnoTJsjJLKr5plc
        qIKpC3YBOvMaOUYXeUcuTXu2qqnoqBBS67rLQ/RD7fhHNl/R4KoJOUKZ2bBkbJT8LsLXa+/NJwnFD
        SvZYN+PmJb+kzUv+srHRZf6Tp0t0nkHXFc0KsQP9QmcEg4vpaJlSTOryT/Q3+wMe8ffbg0Lkc661A
        ac1F+J5zcF/Ig+BJvoOWYxGZH8L22d1ce4LPr9ZbvdA46XMB5lCksM2AKx+GEiiUFPieUg+UvBdVy
        A0+l0eG+1Ka7f8n8wEAeWK75D7mBtalwUD1g4pm75/9UJfW516gIISXJhl4ReTfw/C1Z8iHPihvX6
        xfD9Tqpg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lKKvQ-007KgA-5s; Thu, 11 Mar 2021 13:00:28 +0000
Date:   Thu, 11 Mar 2021 13:00:24 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Gao Xiang <hsiangkao@aol.com>
Cc:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: Re: [PATCH] xfs: ensure xfs_errortag_random_default matches
 XFS_ERRTAG_MAX
Message-ID: <20210311130024.GF1742851@infradead.org>
References: <20210309184205.18675-1-hsiangkao.ref@aol.com>
 <20210309184205.18675-1-hsiangkao@aol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309184205.18675-1-hsiangkao@aol.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
