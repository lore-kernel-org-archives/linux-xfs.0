Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BDF3C432BE
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Aug 2021 06:23:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1828660EFE
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Aug 2021 06:23:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244278AbhH0GYF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Aug 2021 02:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbhH0GYF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Aug 2021 02:24:05 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE04FC061757
        for <linux-xfs@vger.kernel.org>; Thu, 26 Aug 2021 23:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=K6ZX9p/SlMREDm5iY6D0wVifKI1b2YmNRJGEzeNuYME=; b=v2TM819fQfJWSR+B3Oh8RsTpDR
        UfDQMSux/VCVzJ7HuTDkq93vPcivz/5zkZmvzqOGG1MyXPd3mgUt6IBE4sJzd0nMa1NPxS1w2R2h4
        9wM47RYHavTtIxSddgHWz2rHuUkYCiPtyhIymmzzyc0ycOsk3vkBwVCtL1W0lTKDXqQdBxcp5x3vv
        fBXAaJZtWa57ITyXD5P+rl9xwP92eAuj03uBDma6Zvjh7r+Y+mDG8+lLyVZcNdjRON+IiiJlj4Ai7
        AKUYUWaaycwItJcJz7ZMgYlKfWVi0Wt8dyUSByo7LNNToohx2HD8qBWZK6RcBxqSjNk/DdVr2zpAj
        Ges849vw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJVFr-00ECF5-SM; Fri, 27 Aug 2021 06:22:45 +0000
Date:   Fri, 27 Aug 2021 07:22:19 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: xs_ig_attempts ??? xs_ig_found + xs_ig_missed
Message-ID: <YSiEm7ejmZkM4QWq@infradead.org>
References: <e9072acd-2daa-96da-f1f2-bca7870d6b55@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9072acd-2daa-96da-f1f2-bca7870d6b55@molgen.mpg.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 26, 2021 at 10:36:41AM +0200, Paul Menzel wrote:
> Dear Linux folks,
> 
> 
> In the internal statistics [1] the attempts to look up an inode in the inode
> cache (`xs_ig_attempts`) is a little bigger (35) than the sum of found and
> missed entries minus duplicates (`xfs.inode_ops.ig_dup`): 651067226 =
> 651067191 + 35 > 651067191 = 259143798 + 391923706 - 313.

In addition to the explanation about the counters from data:  all error
returns are also not counted, as well as the case where an
XFS_IGET_INCORE lookup did not find the inode cached.  The latter
would make sense to be included in a missed counter, but it looks like
the counter is more intended to count when an inode is actually read
from disk.
