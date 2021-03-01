Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D54AC433DB
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Mar 2021 09:09:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14B6164E01
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Mar 2021 09:09:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233519AbhCAJJx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Mar 2021 04:09:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233372AbhCAJJw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Mar 2021 04:09:52 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69443C06174A
        for <linux-xfs@vger.kernel.org>; Mon,  1 Mar 2021 01:09:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=RsFljr29JB0nmrWmoePU9o8RBeLqXVI0FzuOhfayKtc=; b=dlwD1aiaI70asikwKO+Xp/4ocQ
        /ZHuWFPCqoV7nv2TQreuiSgaqoWduf9FqRmZQ5eExUj4a7Xakae6wVF5DfqCZpkQCn/ysRyyqDK4Q
        cG4ZixffFx5hBdVFPQcahSwCFWpnIEEJfU6W90uH8o/Yo/mZVmBND3DNMFoTfkcfq8xCwsVjP1if0
        FE0umKv8ybOsiHszvD7Cq5wc0fB00irAhSWIsApCrKaI0eeSnW43VMEcICrk3Fi+r62UZyCKKS19J
        hNNrN2nlz9qAn1Q1h1LN1mNWrCbOYuY0W6G0ikvCG+1uqKCQZ0uRGz6bwusH0MmGFaAz5zrf6Tp1b
        ZMl/SEww==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lGeY1-00FWIm-S8; Mon, 01 Mar 2021 09:09:04 +0000
Date:   Mon, 1 Mar 2021 09:09:01 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: separate CIL commit record IO
Message-ID: <20210301090901.GA3698088@infradead.org>
References: <20210223033442.3267258-1-david@fromorbit.com>
 <20210223033442.3267258-3-david@fromorbit.com>
 <20210224203429.GR7272@magnolia>
 <20210224214417.GB4662@dread.disaster.area>
 <YDdhJ0Oe6R+UXqDU@infradead.org>
 <20210225204755.GK4662@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210225204755.GK4662@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 26, 2021 at 07:47:55AM +1100, Dave Chinner wrote:
> Sorry, I/O wait might matter for what?

Think you have a SAS hard drive, WCE=0, typical queue depth of a few
dozend commands.

Before that we'd submit a bunch of iclogs, which are generally
sequential except of course for the log wrap around case.  The drive
can now easily take all the iclogs and write them in one rotation.

Now if we wait for the previous iclogs before submitting the
commit_iclog we need at least one more additional full roundtrip.
