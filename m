Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C12ABC433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 17:55:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C23522BEA
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 17:55:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407074AbhARRgU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 12:36:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436550AbhARRe4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jan 2021 12:34:56 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F347C061573
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jan 2021 09:34:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=QtDfHpPOYXJmzOJD78mNKA8VY9r1amAbaaODmIjU0Kw=; b=kmwEWe7ieIWsvF+1kksVqmdmPj
        4Xs1CjcyFAHvoW8OkEQp/TywTz6DiplV+JgYs0qy0GKISHSKPLQR+jmE19Y3VhWA+6eHcAfKYnY7Y
        W9ToQRCoVvCl75jhN4bvvskk/wRb2XQqktLyB0ZwU8/w/j/pEffX+EbA6VdQotPdBKaIBFz07gcIS
        VuZwFjKjA3lb3foxMOwssi5121g5IVlWSU3gqvfCndRW/hkozlAe94B+TIhPLOpR/84o49PVht8NU
        hDQF/40ikQ3QjEvGOLOwo1NGuy4bT/hV/59PP4Zwq1ooCZSMjmj4BTWt9AvnBQw5gOg4IoIR4eSvF
        tHHPgdLw==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l1YPs-00D9i6-Dh; Mon, 18 Jan 2021 17:34:13 +0000
Date:   Mon, 18 Jan 2021 17:34:12 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: don't stall cowblocks scan if we can't take
 locks
Message-ID: <20210118173412.GA3134885@infradead.org>
References: <161040735389.1582114.15084485390769234805.stgit@magnolia>
 <161040737263.1582114.4973977520111925461.stgit@magnolia>
 <X/8HLQGzXSbC2IIn@infradead.org>
 <20210114215453.GG1164246@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210114215453.GG1164246@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 14, 2021 at 01:54:53PM -0800, Darrick J. Wong wrote:
> On Wed, Jan 13, 2021 at 03:43:57PM +0100, Christoph Hellwig wrote:
> > On Mon, Jan 11, 2021 at 03:22:52PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Don't stall the cowblocks scan on a locked inode if we possibly can.
> > > We'd much rather the background scanner keep moving.
> > 
> > Wouldn't it make more sense to move the logic to ignore the -EAGAIN
> > for not-sync calls into xfs_inode_walk_ag?
> 
> I'm not sure what you're asking here?  _free_cowblocks only returns
> EAGAIN for sync calls.  Locking failure for a not-sync call results in a
> return 0, which means that _walk_ag just moves on to the next inode.

What I mean is:

 - always return -EAGAIN when taking the locks fails
 - don't exit early on -EAGAIN in xfs_inode_walk at least for sync
   calls, although thinking loud I see no good reason to exit early
   even for non-sync invocations
