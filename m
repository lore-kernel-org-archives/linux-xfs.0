Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54738C433E0
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 08:28:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1ED9F64D74
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 08:28:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbhCEI2R (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Mar 2021 03:28:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbhCEI2M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Mar 2021 03:28:12 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7395C061574
        for <linux-xfs@vger.kernel.org>; Fri,  5 Mar 2021 00:28:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1VrcYMhedgmi+pflyVUOQ5GSuLQk9QYyJ3UtzH5lGTM=; b=AWaGQn8idzrTa31sqOO/tCcw0x
        /8OsphcWadzwjWWF5v9UM+a41ilxrxHCmVO8sS69Q2ydUyWb315lt9LZ7UkNZ1hg0VG6t09D7MmAI
        PwLV0CBK4ZlUN89xOYXDupJrLECobLujWbM6rHoTw1SsyhVUd5SwsQekBBVJdsxi6B8lV+WjlYVFt
        n5aUreZrQ1lFH/wJZeqMDSYqtEUTdusicATxv7jlQ/XuNxQnSZinMqezbPqyhQ2EdS6XaMY43TWzE
        TcbgELzLI4MSVSaLCzuO59/0+OiW6T+B3f6POSWZo5G242pMO1RrXomzlor0iZqY6vOrvrLGJ1ph7
        OMHM0NJw==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lI5oQ-00Apve-VC; Fri, 05 Mar 2021 08:28:00 +0000
Date:   Fri, 5 Mar 2021 08:27:54 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs: set the scrub AG number in xchk_ag_read_headers
Message-ID: <20210305082754.GE2567783@infradead.org>
References: <161472411627.3421582.2040330025988154363.stgit@magnolia>
 <161472414479.3421582.13278274089212153461.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161472414479.3421582.13278274089212153461.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 02, 2021 at 02:29:04PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Since xchk_ag_read_headers initializes fields in struct xchk_ag, we
> might as well set the AG number and save the callers the trouble.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Nice cleanup!

Reviewed-by: Christoph Hellwig <hch@lst.de>
