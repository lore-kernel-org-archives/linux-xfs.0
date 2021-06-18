Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31B27C48BDF
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 13:59:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A8FB611B0
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 13:59:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233944AbhFROBb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Jun 2021 10:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233754AbhFROBb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Jun 2021 10:01:31 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDA85C061574
        for <linux-xfs@vger.kernel.org>; Fri, 18 Jun 2021 06:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=fwhmsRJHvsTbpjghn/0s0CMpqMRfUwh4+UDQbyWMbrs=; b=mcveSabtRHxxnEpa4gj+6Z63H7
        /MIsJ2p8ZRqgj3jHbAL15mjDI0/UOOgW3JWmhaivhsPNl1Xguqchqx0gz5zuLutIkV2mwe/A3BGpB
        Pa5C+Wd9qT4L0eTOmvpup++tG1lR9ebFZiyq6Hs0DQPO5B4lkMBwt9/lMTM7BLAV34R0zC6ipCxcr
        nRYDfwvNjhVMLkWsvMJlMExlezBd3irxM/Sj/lnO6osvdQrBpqK6zXbUAZCT/mUx+s3CEFNu1LtfD
        aiC4/Hv0+NTEZeJTLCFpuinsfSyKlbOra5D5tWU+K5XYHxCO0YvseVe05xFDfq984MPdImaqz2vto
        2l95dngg==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1luF1C-00AKcL-4L; Fri, 18 Jun 2021 13:58:52 +0000
Date:   Fri, 18 Jun 2021 14:58:46 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: print name of function causing fs shutdown
 instead of hex pointer
Message-ID: <YMymlgzxg4IYHPyi@infradead.org>
References: <162388772484.3427063.6225456710511333443.stgit@locust>
 <162388773604.3427063.17701184250204042441.stgit@locust>
 <YMsDmxk6nKehJP0q@infradead.org>
 <20210617161041.GM158209@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617161041.GM158209@locust>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 17, 2021 at 09:10:41AM -0700, Darrick J. Wong wrote:
> Um, we /do/ log the error already; a full shutdown report looks like:
> 
> XFS (sda): xfs_do_force_shutdown(0x2) called from line 2440 of file
> 	fs/xfs/xfs_log.c. Return address = xfs_trans_mod_sb+0x25
> XFS (sda): Corruption of in-memory data detected.  Shutting down
> 	filesystem

Yeah, it's pretty verbose.

> Or are you saying that we should combine them into a single message?
> 
> XFS (sda): Corruption of in-memory data detected at xlog_write+0x10
> 	(fs/xfs/xfs_log.c:2440).  Shutting down filesystem.
> 
> XFS (sda): Log I/O error detected at xlog_write+0x10
> 	(fs/xfs/xfs_log.c:2440).  Shutting down filesystem.
> 
> XFS (sda): I/O error detected at xlog_write+0x10
> 	(fs/xfs/xfs_log.c:2440).  Shutting down filesystem.
> 
> etc?

I think that reads much nicer.  So if we cause some churn in this area
we might as well go with that.
