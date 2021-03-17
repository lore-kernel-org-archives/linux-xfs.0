Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D099C43603
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Mar 2021 15:49:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0502E64F8B
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Mar 2021 15:49:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbhCQPst (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 Mar 2021 11:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231985AbhCQPs3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Mar 2021 11:48:29 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CFC2C061762
        for <linux-xfs@vger.kernel.org>; Wed, 17 Mar 2021 08:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Ln2a4/zicFP8QqacATNEcL4t2114cMsUovOND5cGvs8=; b=tBeiWzIxWQzwklP77kUK6MhuDy
        291xoicpeSau0wKZ4QK1rfD31Of+zlz8f17a5rPMzBm8feKJsS5a3yjHPw7ELLBikEOMul5QvPvAR
        DgklFlJM8LPFNFe2k6vzIahOtInR776ot2qULdTiuLXo0SrbLWR7akEKifKkXgrLHZXfu2E8voOQu
        XdWE+KBnXjntIM1oLJ1gXGkdjtKnDyG0ABJrUbAu8gwM3/hTa80QZX8mZLUQ8ntSMeB+K5i6teYl6
        iy/Xn9n6mxGhx3ZXFJFrkgHHWvT7nHrF28VOl5YdPsm4eK1lof77ABHlTxKEbCnHYoCXz2H/kkcGD
        PNTwmOSA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lMXzB-001cWZ-Bx; Wed, 17 Mar 2021 15:21:26 +0000
Date:   Wed, 17 Mar 2021 15:21:25 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/11] xfs: deferred inode inactivation
Message-ID: <20210317152125.GA384335@infradead.org>
References: <161543194009.1947934.9910987247994410125.stgit@magnolia>
 <161543197372.1947934.1230576164438094965.stgit@magnolia>
 <20210316072710.GA375263@infradead.org>
 <20210316154729.GI22100@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316154729.GI22100@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 16, 2021 at 08:47:29AM -0700, Darrick J. Wong wrote:
> On Tue, Mar 16, 2021 at 07:27:10AM +0000, Christoph Hellwig wrote:
> > Still digesting this.  What trips me off a bit is the huge amount of
> > duplication vs the inode reclaim mechanism.  Did you look into sharing
> > more code there and if yes what speaks against that?
> 
> TBH I didn't look /too/ hard because once upon a time[1] Dave was aiming
> to replace the inode reclaim tagging and iteration with an lru list walk
> so I decided not to entangle the two.
> 
> [1] https://lore.kernel.org/linux-xfs/20191009032124.10541-23-david@fromorbit.com/

Well, it isn't just the radix tree tagging, but mostly the
infrastructure in iget that seems duplicates a lot of very delicate
code.

For the actual inactivation run:  why don't we queue up the inodes
for deactivation directly that, that use the work_struct in the
inode to directly queue up the inode to the workqueue and let the
workqueue manage the details?  That also means we can piggy back on
flush_work and flush_workqueue to force one or more entries out.

Again I'm not saying I know this is better, but this is something that
comes to my mind when reading the code.
