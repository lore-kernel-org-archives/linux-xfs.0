Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4B89C433E6
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jan 2021 14:46:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F6F52343B
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jan 2021 14:46:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725870AbhAMOqE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Jan 2021 09:46:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbhAMOqE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jan 2021 09:46:04 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF32C061786
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jan 2021 06:45:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=tuQ05YyYos1XR9+6IyzloqkgGtacHkUMBAEHN/v8Klg=; b=ZiXGENjZ5DW1J4Bew97HMxSi95
        b7evHml5BS54oYMxzkVVgGg55azpuyv0Fz6APt8qdACaaDOkW1R1PFKtWVX2NQTU0kB0k6PeyNnFZ
        OPwoZsKtlmLYVP9lj5u2sd7hwGuCV34mssn5lvRJqN4ydfFyr5zjjUmZCTWmi2oKMHN2bsrEWfSmr
        1/X6vDufc4djnZpzDPIKw8KoI91v0eGG5p7rW7gXBDcvaAjyOUPOKDw9LMQ28YUG4ofFJEQunuz5h
        sV8Ge89dU4usJxEPiQOmNVFcwmwFoODAPZVLM1xMnz50ZrR8dPEIL6llE+jKexEsVZ0WL2AOa0psn
        /9mB69Xw==;
Received: from [2001:4bb8:19b:e528:d345:8855:f08f:87f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1kzhNQ-006ND7-HP; Wed, 13 Jan 2021 14:44:40 +0000
Date:   Wed, 13 Jan 2021 15:43:57 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: don't stall cowblocks scan if we can't take
 locks
Message-ID: <X/8HLQGzXSbC2IIn@infradead.org>
References: <161040735389.1582114.15084485390769234805.stgit@magnolia>
 <161040737263.1582114.4973977520111925461.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161040737263.1582114.4973977520111925461.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 11, 2021 at 03:22:52PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Don't stall the cowblocks scan on a locked inode if we possibly can.
> We'd much rather the background scanner keep moving.

Wouldn't it make more sense to move the logic to ignore the -EAGAIN
for not-sync calls into xfs_inode_walk_ag?
