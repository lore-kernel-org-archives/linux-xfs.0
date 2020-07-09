Return-Path: <SRS0=XuOj=AU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DFBCC433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 13:37:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 442B32073A
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 13:37:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ARSw6kHa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbgGINht (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Jul 2020 09:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgGINhs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Jul 2020 09:37:48 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73260C08C5CE
        for <linux-xfs@vger.kernel.org>; Thu,  9 Jul 2020 06:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=fD7VEHEEM8k+tC5hEyX9ft8ot8dWL4Sd1tksZAY96xA=; b=ARSw6kHaTKlXTVhf5jRUSLTHVm
        RW/CBe7vJrBnXGBamiCediv69tXcQG38m5eKLErz5aXFdoPOW3mLXGrsTpWjxJIcQ9mEtUHxtqaZG
        ebMp3EhyVODM/gjspfhadw0b5wMYxX1T5fU2ctAioxFg+7/0lPv02BU5u+O386irohQX8VDt0p253
        /HHihI60khTkYAF8LK5Ds6Xt49so/GTs6oiWHH5+d3yM2yCPKDf7qMi5REkvj5tm3qn+anBw7nqy8
        76suT4C3df1+0oS03i3Q519fBoCSGJxNjyPiCQbgcbGUfu0SofzwHJPQ1Fwm+2KFskUE3whxmPzsK
        LWv0K+EA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtWkA-00012m-I5; Thu, 09 Jul 2020 13:37:42 +0000
Date:   Thu, 9 Jul 2020 14:37:42 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 3/3] xfs_repair: try to fill the AGFL before we fix
 the freelist
Message-ID: <20200709133742.GA3860@infradead.org>
References: <159370361029.3579756.1711322369086095823.stgit@magnolia>
 <159370362968.3579756.14752877317465395252.stgit@magnolia>
 <20200708153455.GM7606@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200708153455.GM7606@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 08, 2020 at 08:34:55AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In commit 9851fd79bfb1, we added a slight amount of slack to the free
> space btrees being reconstructed so that the initial fix_freelist call
> (which is run against a totally empty AGFL) would never have to split
> either free space btree in order to populate the free list.
> 
> The new btree bulk loading code in xfs_repair can re-create this
> situation because it can set the slack values to zero if the filesystem
> is very full.  However, these days repair has the infrastructure needed
> to ensure that overestimations of the btree block counts end up on the
> AGFL or get freed back into the filesystem at the end of phase 5.
> 
> Fix this problem by reserving extra blocks in the bnobt reservation, and
> checking that there are enough overages in the bnobt/cntbt fakeroots to
> populate the AGFL with the minimum number of blocks it needs to handle a
> split in the bno/cnt/rmap btrees.
> 
> Note that we reserve blocks for the new bnobt/cntbt/AGFL at the very end
> of the reservation steps in phase 5, so the extra allocation should not
> cause repair to fail if it can't find blocks for btrees.
> 
> Fixes: 9851fd79bfb1 ("repair: AGFL rebuild fails if btree split required")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
