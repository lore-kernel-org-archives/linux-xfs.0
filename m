Return-Path: <SRS0=RpwR=EJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04DE2C2D0A3
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Nov 2020 17:40:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 990AF21D91
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Nov 2020 17:40:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IPcZCLaQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727688AbgKCRk0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Nov 2020 12:40:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727530AbgKCRk0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Nov 2020 12:40:26 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF30C0613D1
        for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2020 09:40:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=WeBFix+zRfPAvkNM5DyJR21TkszV8XNjfy6zjM1hQLE=; b=IPcZCLaQ7MMRT9aDEJ/BZIV2Lp
        wPALkhms4Tp4Suf5Ljes69TVp3YMVdlhTqKP3xwLJRttWG1R/hTVOjNJhQfmR6pstsfD6Cbj88qMZ
        KEJa1tzp/xV6+emCVFZh5hD/BpnfqMyiCLkP9ejMgG1bUC4I6jjPOqtjUrGAB9E3m7fzR0lmTciU0
        b45wNN91fYe02p1VFkBUuGuY4VyK0U6ZLtOynaGaiPRXEFzSDtpnmH0djXh77QvtdcA4pOYqr5dbb
        zNAX2QXFDdldgiNTmuHqi0JVLxVwVZVD1aXJURET4mEWB3EI6Lb9Qd8gFwQL+jZlcpPFXcxfSH9U6
        2GA3oz+A==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ka0IB-0000Bz-Vj; Tue, 03 Nov 2020 17:40:24 +0000
Date:   Tue, 3 Nov 2020 17:40:23 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix missing CoW blocks writeback conversion retry
Message-ID: <20201103174023.GA382@infradead.org>
References: <20201103172732.GD7123@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103172732.GD7123@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 03, 2020 at 09:27:32AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In commit 7588cbeec6df, we tried to fix a race stemming from the lack of
> coordination between higher level code that wants to allocate and remap
> CoW fork extents into the data fork.  Christoph cites as examples the
> always_cow mode, and a directio write completion racing with writeback.
> 
> According to the comments before the goto retry, we want to restart the
> lookup to catch the extent in the data fork, but we don't actually reset
> whichfork or cow_fsb, which means the second try executes using stale
> information.  Up until now I think we've gotten lucky that either
> there's something left in the CoW fork to cause cow_fsb to be reset, or
> either data/cow fork sequence numbers have advanced enough to force a
> fresh lookup from the data fork.  However, if we reach the retry with an
> empty stable CoW fork and a stable data fork, neither of those things
> happens.  The retry foolishly re-calls xfs_convert_blocks on the CoW
> fork which fails again.  This time, we toss the write.
> 
> I've recently been working on extending reflink to the realtime device.
> When the realtime extent size is larger than a single block, we have to
> force the page cache to CoW the entire rt extent if a write (or
> fallocate) are not aligned with the rt extent size.  The strategy I've
> chosen to deal with this is derived from Dave's blocksize > pagesize
> series: dirtying around the write range, and ensuring that writeback
> always starts mapping on an rt extent boundary.  This has brought this
> race front and center, since generic/522 blows up immediately.
> 
> However, I'm pretty sure this is a bug outright, independent of that.
> 
> Fixes: 7588cbeec6df ("xfs: retry COW fork delalloc conversion when no extent was found")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Yes, this looks pretty sensible:

Reviewed-by: Christoph Hellwig <hch@lst.de>
