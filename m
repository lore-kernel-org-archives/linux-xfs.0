Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F0FDC2BBD1
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 08:08:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC0B9221E7
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 08:08:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="t2uM9yCz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbgIQIIf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 04:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726458AbgIQIIU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 04:08:20 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D400C06174A
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 01:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5noAswOBY9MEw8HN8NwuujGCR86OO7jFDmFPLsVxZW4=; b=t2uM9yCzgct9Z8Ku2OaZCOiq9m
        Q4Q3aqM3ha9zjJRyUxG2MKkMhtEJruptyMij904TI/c9L2wFE8VpL8ElwOH2kAdZhKQifwOBSk6/J
        BJSI/86rbuv4GbrcSOKzj1vBDyZbvSLL7CNBy8/aOal3R8QoWkahnU7WvHu3xFMv0aLUA079Di5qA
        ts81oyct1hixcK+wuc/5oVqRigVEoh6XkcD2797KhIQGu/P4gXXf6mMPUG6cyNM4v2hy6F4ZH4mm8
        V5czsebo7l5PgUfurjOsl/849RV/mWXGkT6yQ9fVcG6/SKoC9q4p3QYpIB2hiNc72kYqIwLSsyATv
        UOYFVcog==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIoxb-0008E6-4k; Thu, 17 Sep 2020 08:08:07 +0000
Date:   Thu, 17 Sep 2020 09:08:07 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xiakaixu1987@gmail.com, linux-xfs@vger.kernel.org,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] xfs: do the assert for all the log done items in
 xfs_trans_cancel
Message-ID: <20200917080807.GB26262@infradead.org>
References: <1600255152-16086-1-git-send-email-kaixuxia@tencent.com>
 <1600255152-16086-5-git-send-email-kaixuxia@tencent.com>
 <20200917001042.GP7955@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917001042.GP7955@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 16, 2020 at 05:10:42PM -0700, Darrick J. Wong wrote:
> Please don't go adding more flags for a debugging check.
> 
> You /could/ just detect intent-done items by the fact that their item
> ops don't have unpin or push methods, kind of like what we do for
> detecting intent items in log recovery.
> 
> Oh wait, you mowed /that/ down too.

Yes, I'd much rather change based on method presence instead of creating
redundant flags.
