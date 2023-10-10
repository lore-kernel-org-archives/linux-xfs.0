Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38DEFCD68ED
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Oct 2023 06:56:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442278AbjJJG4e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Oct 2023 02:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442233AbjJJG4d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Oct 2023 02:56:33 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8778B99
        for <linux-xfs@vger.kernel.org>; Mon,  9 Oct 2023 23:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=eG4tAcWegEHKEhDVs2lFPET+PmKiQG/Kq+cq3mGmo20=; b=pYcPCiUXG/HpME1/0lKJ1b2zXT
        T6a9jNlzCocRl/+NjeD+Dq4h5tA1MUsg1o1cjyuIhgzxW6GH5XMDKU7TUCYbBSxfxP0KCsSloyZfI
        VSizego8EOrzVPlj/+gu63GGWDc1Ay8SkbXJphYq8tWBXY43lSvJFvMdeWsQxGioFjoe4q1RWnkBk
        LVgjNe3M162lzDgbUq7phB32zgzeTvJdsRGGu2F1QKHWaWY0qzNFtO9ieCTaDblnL5yZWez01N1NA
        tTWexQEjp8spXy+dR6npkzQJhSVp3TMDbLDkeDpri/CZFhLQ0GSu8PhzGCOJ5DfzxwzO+fGDBpJ5n
        PluMgUrQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qq6fQ-00CeC3-1P;
        Tue, 10 Oct 2023 06:56:32 +0000
Date:   Mon, 9 Oct 2023 23:56:32 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: process free extents to busy list in FIFO order
Message-ID: <ZST1oEZlh6/UAQwS@infradead.org>
References: <169687594536.3969352.5780413854846204650.stgit@frogsfrogsfrogs>
 <169687595684.3969352.13337782664797983922.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169687595684.3969352.13337782664797983922.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 09, 2023 at 11:25:56AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> When we're adding extents to the busy discard list, add them to the tail
> of the list so that we get FIFO order.  For FITRIM commands, this means
> that we send discard bios sorted in order from longest to shortest, like
> we did before commit 89cfa899608fc.
> 
> For transactions that are freeing extents, this puts them in the
> transaction's busy list in FIFO order as well, which shouldn't make any
> noticeable difference.
> 
> Fixes: 89cfa899608fc ("xfs: reduce AGF hold times during fstrim operations")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Does this actually fix an observed issue, or just restor the previous
behavior?

Eitherway the change make sense:

Reviewed-by: Christoph Hellwig <hch@lst.de>
