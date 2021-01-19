Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90AE6C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 06:58:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F58E23129
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 06:58:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730012AbhASG6j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jan 2021 01:58:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729544AbhASG4l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jan 2021 01:56:41 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84257C061574
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jan 2021 22:55:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=v1SgYWHv+TxTTXSkVqrXPOk9yPhTURFEJM33QmWFV/k=; b=modE5TzCa8Xc/GDgpOPoOt1SKh
        ER9WiNAuFFh0DMvIKGuXd5SA7o8hfui+M9wO0hxKX2gghTMw9Jlt4S3iVxHrY0L8FfHVSA32T+Lq+
        t8FzNyfM9nCqHqle8D/NDdmskAzdlxZlc5CyZgBfPvR11oGqDpKKG7M24YHgw8okbHVaALSsK1PGF
        SviLm2NMgYlPMJrwHAjUYmydXkRjMzNFaVuEniWsyEUfDVTLbiR1cV0CIt5ZJjNou8aGpb/y0wAME
        dF42Ey5zeY6nOnKbhUTHo4LfVbLZsWCND+wtKoCgy4LIaxFnCBlqpPYVMEPLxQMZJVQVuheGni9Fb
        oezMMgTw==;
Received: from 089144206130.atnat0015.highway.bob.at ([89.144.206.130] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l1kva-00Dvjd-R3; Tue, 19 Jan 2021 06:55:51 +0000
Date:   Tue, 19 Jan 2021 07:53:35 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/11] xfs: move and rename xfs_inode_free_quota_blocks
 to avoid conflicts
Message-ID: <YAaB79hf6bzb1nF5@infradead.org>
References: <161100791789.88816.10902093186807310995.stgit@magnolia>
 <161100794020.88816.15799119257763634834.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161100794020.88816.15799119257763634834.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 18, 2021 at 02:12:20PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Move this function further down in the file so that later cleanups won't
> have to declare static functions.  Change the name because we're about
> to rework all the code that performs garbage collection of speculatively
> allocated file blocks.  No functional changes.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
