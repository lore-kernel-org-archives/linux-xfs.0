Return-Path: <SRS0=37eZ=4V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69917C3F2D1
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 15:25:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F6A521739
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 15:25:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oA5QWTME"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725897AbgCDPZP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Mar 2020 10:25:15 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:42570 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbgCDPZP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Mar 2020 10:25:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=NLR1W71Y/VoqRQTjf9FpHr9ctwEcNNeQYoWDLtxQNh4=; b=oA5QWTME9j08l8wVRW8JreB/id
        sTucpH7cYGXnG9ZWD13wHM+xZj331KRknVrTtl/8vBLeW0bbhYUCLyixdlYvOpsvTerk09jnasre1
        +N7LVR9DBGNl0e+d+N4wY4eHS+QBSiJYBua72tK6j18zHkSzvtFDyZim3UznxMlWrCD1S2Wn8ohep
        uvMFkd01bLEepBeoi97d//1z/NJNrZ/oa46EpP9WhHiya6GwIQgfWtWrjXNW6RYsILAguIxvKIkQ3
        WBsuW1wN7lHzxN0Aw8g4I6t5s2pxe8xG0SpWSJ+UWg64Fnpn9Dzxr0mfdonSDCWdFECjADvyz/fdZ
        zsvPJsUw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j9Vtb-0007G4-32; Wed, 04 Mar 2020 15:25:15 +0000
Date:   Wed, 4 Mar 2020 07:25:15 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] iomap: Fix writepage tracepoint pgoff
Message-ID: <20200304152515.GA23148@infradead.org>
References: <20200304142259.GF29971@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304142259.GF29971@bombadil.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 04, 2020 at 06:22:59AM -0800, Matthew Wilcox wrote:
> From: Matthew Wilcox (Oracle) <willy@infradead.org>
> 
> page_offset() confusingly returns the number of bytes from the
> beginning of the file and not the pgoff, which the tracepoint claims
> to be returning.  We're already returning the number of bytes from the
> beginning of the file in the 'offset' parameter, so correct the pgoff
> to be what was apparently intended.
> 
> Fixes: 0b1b213fcf3a ("xfs: event tracing support")
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

I wonder if tracing the byte offset and just changing the name
might be more useful.  But I agree that we should fix it one way or
another.
