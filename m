Return-Path: <SRS0=Kgg+=CR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCFB3C433E2
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Sep 2020 20:06:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85093204FD
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Sep 2020 20:06:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BRKgkJQr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730349AbgIHUGO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Sep 2020 16:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730354AbgIHPVk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Sep 2020 11:21:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C0AEC09B04D
        for <linux-xfs@vger.kernel.org>; Tue,  8 Sep 2020 07:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=h3xg6JC6mAGEXPe3yXtQzAR1GPPNXtWkddmUMffAtDE=; b=BRKgkJQrduGbE6tpf92+LxhANI
        ZHqZW7nqB8KjvTcNaiIrtb+T6WsZBtPccyrU7bu1QYOSIhemRZMyQwZewztJ/jV0fvfk8hMDW/5kh
        UzjTwZWnrpY/AQeHrAtZz7sYlDR0BcBbDiFSuW7B0cBTpDe6yJbNHcWAxQCK7B4x2diTM0vTd9l56
        mUh+Cg2M5+o3eopOMso+ruF4hJSZeuYfftIjUa2uLRNYkeKvAXeP41w+z8VyIjxzEOLdBDRAb1Q4/
        jwOVeM6YwWH+OM3H63z/HHp3cFejgL36UWr4cmNUKHBHXMOEC1FenhtED9dcNt702Ms4KzBhkeFLV
        wkL0b+kQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kFetV-0002bN-1Z; Tue, 08 Sep 2020 14:46:49 +0000
Date:   Tue, 8 Sep 2020 15:46:48 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs_repair: fix error in process_sf_dir2_fixi8
Message-ID: <20200908144648.GG6039@infradead.org>
References: <159950111751.567790.16914248540507629904.stgit@magnolia>
 <159950112994.567790.6177947698105660609.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159950112994.567790.6177947698105660609.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 07, 2020 at 10:52:10AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The goal of process_sf_dir2_fixi8 is to convert an i8 shortform
> directory into a (shorter) i4 shortform directory.  It achieves this by
> duplicating the old sf directory contents (as oldsfp), zeroing i8count
> in the caller's directory buffer (i.e. newsfp/sfp), and reinitializing
> the new directory with the old directory's entries.
> 
> Unfortunately, it copies the parent pointer from sfp (the buffer we've
> already started changing), not oldsfp.  This leads to directory
> corruption since at that point we zeroed i8count, which means that we
> save only the upper four bytes from the parent pointer entry.
> 
> This was found by fuzzing u3.sfdir3.hdr.i8count = ones in xfs/384.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
