Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEBD4C433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 09:12:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 802DD64EB9
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 09:12:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbhBIJMj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Feb 2021 04:12:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbhBIJJH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Feb 2021 04:09:07 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F374C061788
        for <linux-xfs@vger.kernel.org>; Tue,  9 Feb 2021 01:08:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YnTpJ5TZ2pOWapPGpPMcw61GbKbhZbpWpo6xEqqS2ws=; b=LZEwQa8MIx7oOQqlK5m5qX3ANo
        s4pNBZ5uou32wJJldo47vR4DJOi8cN617QFBWFIhYz/Nddy41wByNOJFBSmYibhe89Vf3HnkK8kq3
        JCy4z3fR28KYvMMJ+kDuzS/8YBnCK5qh0LMyxjbgu0VQ9wcabzveWP3c7vCagnM4RlckjOYZ3EvJG
        ESqNp0ZZMBjYbt7v5x/xdPAeifxByLLtjE092Qdg6gjGUzwylIvG7bbREZcyqwc5qLN743MtG7jnv
        XKSC+EG8gqJYyFXup0z4GJaL8YUELSXl1VMsQRkyPG6zoGXHxF/CP+obJvkFSYFnT7njyBiMfQ1of
        eu5MHHbA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l9P0Q-007D2L-5V; Tue, 09 Feb 2021 09:08:22 +0000
Date:   Tue, 9 Feb 2021 09:08:22 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 02/10] xfs_admin: support filesystems with realtime
 devices
Message-ID: <20210209090822.GB1718132@infradead.org>
References: <161284380403.3057868.11153586180065627226.stgit@magnolia>
 <161284381548.3057868.17951198536217853244.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161284381548.3057868.17951198536217853244.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 08, 2021 at 08:10:15PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add a -r option to xfs_admin so that we can pass the name of the
> realtime device to xfs_repair.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
