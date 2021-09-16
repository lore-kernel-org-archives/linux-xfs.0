Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 317AAC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 15:18:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F79761216
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 15:18:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238665AbhIPPTp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 11:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236774AbhIPPTo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 11:19:44 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C40C061574
        for <linux-xfs@vger.kernel.org>; Thu, 16 Sep 2021 08:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=129AApKO4sgkMCPrx6ErmEhzb8h5RIf9BK3OiikLjJM=; b=qabvytUlAa1GOdbphOuXY50Lj9
        4LINxH9lkzH39u4TDEd+N6GtQcBIonc1kOt+dm3u/YbLmZI8bgnKToeONKJZQK6q7UJvAlXJgNjXn
        fZveqbaAbDYJdsg0fNvrQyzS0phAdintw0l9qsVdRbcQ+4pZrzpslayubgpXWvSVPLhFeFYfcLPC+
        zd/JY464gWLWIxoGgDQVXTibYqic3A5ZNxssgeKyGaGyebL3McYTPfdw3rtZqyOFoIr2Acx7nkhxC
        164JuPNbx1mrcMQJOu58r0RS739jQNREnQTgyb/tTboVVY76Z3cg8MmD0R8lOa6TgScNfkB7UmNvu
        WblSjPzA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mQt6m-00GoSr-70; Thu, 16 Sep 2021 15:15:41 +0000
Date:   Thu, 16 Sep 2021 16:15:28 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, sandeen@sandeen.net,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 61/61] mkfs: warn about V4 deprecation when creating new
 V4 filesystems
Message-ID: <YUNfkLUcyRtkzEUD@infradead.org>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
 <163174752777.350433.15312061958254066456.stgit@magnolia>
 <YULvufnBE3VRfZu8@infradead.org>
 <20210916151024.GC34874@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916151024.GC34874@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 16, 2021 at 08:10:24AM -0700, Darrick J. Wong wrote:
> On Thu, Sep 16, 2021 at 08:18:17AM +0100, Christoph Hellwig wrote:
> > On Wed, Sep 15, 2021 at 04:12:07PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > The V4 filesystem format is deprecated in the upstream Linux kernel.  In
> > > September 2025 it will be turned off by default in the kernel and five
> > > years after that, support will be removed entirely.  Warn people
> > > formatting new filesystems with the old format, particularly since V4 is
> > > not the default.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> > 
> > Looks good,
> > 
> > (assuming you're already dealing with the xfstests fallout)
> 
> Already merged to fstests two weeks ago. ;)
> 
> (Was there supposed to be a RVB tag here?)

Reviewed-by: Christoph Hellwig <hch@lst.de>
