Return-Path: <SRS0=0AGZ=6M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18E7CC83000
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Apr 2020 06:12:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7061206D9
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Apr 2020 06:12:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KdUKPuK6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgD1GMN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Apr 2020 02:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726042AbgD1GMN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Apr 2020 02:12:13 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E132C03C1A9
        for <linux-xfs@vger.kernel.org>; Mon, 27 Apr 2020 23:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=bzkhE0b0ftGegEHiAkvEygxBKmX3I4umHOWPmel94E0=; b=KdUKPuK6brM1L1xmLNv6DzVfy8
        NPK9Hro68CjKNyG6sMzL7B455dgnS9ZfB0yIC94eD1mdrJHwPADCgZTg6dBR2nJlBGqvDtD0YD0xd
        RkKEpQ51xxPV54f87kCyC9q6v2tZFjP5EUPrpM+ZVM5tx3gYMVMBYGT651Uqc1spAluGUSbFQeLVc
        7OGABrhJ7gkUcQ9UZT9cWaF+R8a2QBs8SREFtHloF8Y6aPiuebUuZ87tuQontymoFE6vx+BhHO4Z0
        LRnmPfabrdqnVk+hGvUQ45fgY6oAvaUS1feHOGixe8SXscNvDkBiEEnIcJu8OIkK7qER9Zz+rJgGi
        aiXpYcCg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jTJTU-0006xd-Ss; Tue, 28 Apr 2020 06:12:08 +0000
Date:   Mon, 27 Apr 2020 23:12:08 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 00/19] xfs: refactor log recovery
Message-ID: <20200428061208.GA18850@infradead.org>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
 <20200422161854.GB37352@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422161854.GB37352@bfoster>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 22, 2020 at 12:18:54PM -0400, Brian Foster wrote:
> - Transaction reorder
> 
> Virtualizing the transaction reorder across all several files/types
> strikes me as overkill for several reasons. From a code standpoint,
> we've created a new type enumeration and a couple fields (enum type and
> a function) in a generic structure to essentially abstract out the
> buffer handling into a function. The latter checks another couple of blf
> flags, which appears to be the only real "type specific" logic in the
> whole sequence. From a complexity standpoint, the reorder operation is a
> fairly low level and internal recovery operation. We have this huge
> comment just to explain exactly what's happening and why certain items
> have to be ordered as such, or some treated like others, etc. TBH it's
> not terribly clear even with that documentation, so I don't know that
> splitting the associated mapping logic off into separate files is
> helpful.

I actually very much like idea of moving any knowledge of the individual
item types out of xfs_log_recovery.c.  In reply to the patch I've
suggsted an idea how to kill the knowledge for all but the buffer and
icreate items, which should make this a little more sensible.

I actually think we should go further in one aspect - instead of having
the item type to ops mapping in a single function in xfs_log_recovery.c
we should have a table that the items can just add themselves to.

> - Readahead
> 
> We end up with readahead callouts for only the types that translate to
> buffers (so buffers, inode, dquots), and then those callouts do some
> type specific mapping (that is duplicated within the specific type
> handers) and issue a readahead (which is duplicated across each ra_pass2
> call). I wonder if this would be better abstracted by a ->bmap() like
> call that simply maps the item to a [block,length] and returns a
> non-zero length if the core recovery code should invoke readahead (after
> checking for cancellation). It looks like the underlying implementation
> of those bmap calls could be further factored into helpers that
> translate from the raw record data into the type specific format
> structures, and that could reduce duplication between the readahead
> calls and the pass2 calls in a couple cases. (The more I think about,
> the more I think we should introduce those kind of cleanups before
> getting into the need for function pointers.)

That sounds more complicated what we have right now, and even more so
with my little xlog_buf_readahead helper.  Yes, the methods will all
just call xlog_buf_readahead, but they are trivial two-liners that are
easy to understand.  Much easier than a complicated calling convention
to pass the blkno, len and buf ops back.

> - Recovery (pass1/pass2)
> 
> The core recovery bits seem more reasonable to factor out in general.
> That said, we only have two pass1 callbacks (buffers and quotaoff). The
> buffer callback does cancellation management and the quotaoff sets some
> flags, so I wonder why those couldn't just remain as direct function
> calls (even if we move the functions out of xfs_log_recover.c). There
> are more callbacks for pass2 so the function pointers make a bit more
> sense there, but at the same time it looks like the various intents are
> further abstracted behind a single "intent type" pass2 call (which has a
> hardcoded XLOG_REORDER_INODE_LIST reorder value and is about as clear as
> mud in that context, getting to my earlier point).

Again I actually like the callouts, mostly because they make it pretty
clear what is going on.  I also really like the fact that the recovery
code is close to the code actually writing the log items.
