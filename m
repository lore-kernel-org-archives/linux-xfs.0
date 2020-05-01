Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECFF4C47253
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 09:17:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA6432173E
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 09:17:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="C8CdfKgb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728352AbgEAJRd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 05:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728159AbgEAJRd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 05:17:33 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E12C035495
        for <linux-xfs@vger.kernel.org>; Fri,  1 May 2020 02:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Yh8uaELvtNUFOjbSBaTQdmVqVTjdy2NdS4BErHN0vcY=; b=C8CdfKgbHTGHOsbRdVtoq1KY+3
        KchIapELa+AatAkRHJKGn0hcIvpo/0dlRiWBL8obitykFoAaGgH+1/usMGWmDF//QgSJ5Z7Dzb6vC
        27zZTg9scLnb7a/tGpANAkLdbxhUhtnhKS8D8zyvQ8x+Pb6NvL9n5LErpWR5I/IZOjw1BrAUjI884
        qW5LBKoQsWBQl7fGzATG4XYxZ27+n3nAFRm9fuIx91D4zCgXyh0Dp+0Dfa7/4HESEovqze31fTa5r
        B34xieWT122nAgDynK5VO5ncsPqVsfWTKrDZ3SUSTTAsps0xj1OGgvV0qg9MsNXfl+KehVy84A8mJ
        K+D+Mbiw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jURnW-0000eO-MN; Fri, 01 May 2020 09:17:30 +0000
Date:   Fri, 1 May 2020 02:17:30 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 03/17] xfs: simplify inode flush error handling
Message-ID: <20200501091730.GA20187@infradead.org>
References: <20200429172153.41680-1-bfoster@redhat.com>
 <20200429172153.41680-4-bfoster@redhat.com>
 <20200430183703.GD6742@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430183703.GD6742@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 30, 2020 at 11:37:03AM -0700, Darrick J. Wong wrote:
> TBH I've long wondered why we flush one inode and only then check that
> the icluster buffer is pinned and if so force the log?  Did we do that
> for some sort of forward progress guarantee?
> 
> I looked at a3f74ffb6d144 (aka when the log force moved here from after
> the iflush_cluster call) but that didn't help me figure out if there's
> some subtlety here I'm missing, or if the ordering here was weird but
> the weirdness didn't matter?
> 
> TLDR: I can't tell why it's ok to move the xfs_iflush_int call down past
> the log force. :/

As far as I can tell the log force is to avoid waiting for the buffer
to be unpinned.  This is mostly bad when using xfs_bwrite, which we
still do for the xfs_reclaim_inode case, given that xfs_inode_item_push
alredy checks for the pinned inode earlier, and lets the xfsaild handle
the log pushing.

Which means doing the log_force earlier is actually a (practially not
relevant) micro-optimization as it gives the log code a few more
instructions worth of time to push out and complete the log buffer.

Maybe this wants to be split out into a prep patch to better document
the change.


