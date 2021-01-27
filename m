Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D6D9C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 17:05:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DF0364DC2
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 17:05:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235582AbhA0RFk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Jan 2021 12:05:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234624AbhA0REG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Jan 2021 12:04:06 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA1AC061573
        for <linux-xfs@vger.kernel.org>; Wed, 27 Jan 2021 09:03:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=LV1c/W/dLa9GeeqbyLAHHDcIqcG0oWDFJQXBRo4TbIA=; b=MG7lGDOOXGo+ghThbzhq6vU/qv
        mW/2lCci3QfWCGLc4/YJ6heTDJWmFzfqS13OPiTFOzVs2mzV7eb+sUbbESN/BJmjhbFDcqLlqmX6r
        JsG6owzGo8DTd4sXFxQKsLpyS6jAlPpR8dGHTrPaflb7EL7/m4kbH8Y2s1J/F85OYC2QNF00XNtsp
        9xkr9XpTZuP3e9ufnkZkdHtdHp2a5Zvdz3pkBGaoSU4CgxxXfub9Gp3mRpIgOZDjCOTgVYVt4NRt8
        KVyNBBR3AhOj/a5oBzHnnIrs9i+KFpBMyj86AL5tPW0ponpMuBdVhGn+Qz6hZ5GNa60rwTaroK+2f
        hEfgs2vg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l4oDi-007GRX-4I; Wed, 27 Jan 2021 17:03:07 +0000
Date:   Wed, 27 Jan 2021 17:03:06 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 4/3] xfs: set WQ_SYSFS on all workqueues in debug mode
Message-ID: <20210127170306.GC1730140@infradead.org>
References: <161142798284.2173328.11591192629841647898.stgit@magnolia>
 <161142799960.2173328.12558377173737512680.stgit@magnolia>
 <20210126050619.GT7698@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210126050619.GT7698@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 25, 2021 at 09:06:19PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> When CONFIG_XFS_DEBUG=y, set WQ_SYSFS on all workqueues that we create
> so that we (developers) have a means to monitor cpu affinity and whatnot
> for background workers.  In the next patchset we'll expose knobs for
> some of the workqueues publicly and document it, but not now.

I don't really think this is a very good idea.  If we want something like
this it should be kernel-wide and coordinated with the workqueue 
maintainer, but I'm a little doubtful about the use case.

