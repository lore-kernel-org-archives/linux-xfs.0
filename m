Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18F48C47253
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 17:09:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCCBF208D6
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 17:09:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cdZS39fa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729061AbgEARJf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 13:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728970AbgEARJf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 13:09:35 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F3CC061A0C
        for <linux-xfs@vger.kernel.org>; Fri,  1 May 2020 10:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=VWDoSah/87IlAuARU/bBgMG8UT8ajfWaoewv7EFY4Bg=; b=cdZS39fazv4orVAtIa2o7yTDVU
        95NP7HKfqfyC0G1/LQ/frxnTpVh9eaZNtrT9iM3YFH0opVrfI7c3lhU4orCwEgrsOujJdCybDmdm/
        Zzz5lrG5IHJDAT6ZWWrPduL3Z5ukBM79htiaa7zTnBtMw3PdAT+fV0Gq7KEeFeXg1TMBSwlWA3rv0
        09CMzrStjVbyB6y8p6AG1eUQACTgypc7tWvRwnUl4E9omb0aaZx6eCNFiTGv1eg1Y2A6k+4Em8j/z
        O6qnrEYK9c+uWxHmfz56HlpVCjdZcisZlQUbyeZTdqODbUQrQRmpEFh/kXyvYXp9mAJa3Zo9EwbHO
        fc+8ZVjA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jUZAL-0002Da-5a; Fri, 01 May 2020 17:09:33 +0000
Date:   Fri, 1 May 2020 10:09:33 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: teach deferred op freezer to freeze and thaw
 inodes
Message-ID: <20200501170933.GA7910@infradead.org>
References: <158752128766.2142108.8793264653760565688.stgit@magnolia>
 <158752130655.2142108.9338576917893374360.stgit@magnolia>
 <20200425190137.GA16009@infradead.org>
 <20200427113752.GE4577@bfoster>
 <20200428221747.GH6742@magnolia>
 <20200429113803.GA33986@bfoster>
 <20200429114819.GA24120@infradead.org>
 <20200429142807.GU6742@magnolia>
 <20200429145557.GA26461@infradead.org>
 <20200429235818.GX6742@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429235818.GX6742@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 29, 2020 at 04:58:19PM -0700, Darrick J. Wong wrote:
> On Wed, Apr 29, 2020 at 07:55:57AM -0700, Christoph Hellwig wrote:
> > On Wed, Apr 29, 2020 at 07:28:07AM -0700, Darrick J. Wong wrote:
> > > Hmm.  Actually now that I think harder about it, the bmap item is
> > > completely incore and fields are selectively copied to the log item.
> > > This means that regular IO could set bi_owner = <some inode number> and
> > > bi_ip = <the incore inode>.  Recovery IO can set bi_owner but leave
> > > bi_ip NULL, and then the bmap item replay can iget as needed.  Now we
> > > don't need this freeze/thaw thing at all.
> > 
> > Yes, that sounds pretty reasonable.
> 
> OTOH I was talking to Dave and we decided to try the simpler solution of
> retaining the inode reference unless someone can show that the more
> complex machinery is required.

Sounds good.  And we only need to do it when in recovery, this should
save a few atomic ops during normal operations.
