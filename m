Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D778C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 31 May 2022 06:59:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244404AbiEaG7C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 May 2022 02:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244408AbiEaG7B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 May 2022 02:59:01 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B318395A20;
        Mon, 30 May 2022 23:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YoT/NLZDDfib5ytOJnRS5vze+GhpYCNRZXiE9Q8MSmo=; b=k8UhONKfGl00SBtcuysxmofSbJ
        SzfavirDzF9+Mz1TPOVj7NZploaHQcd5FmjgA9TpqF4vQCnLxH3UVjsjBIGBRMjLgLUhd95eXFi0n
        1vsqTigsFVMzUnscBxa0z0SA592CHrgmu6yGzNi5IYarBvh3wqEj32/a9lYH9jhZX0/jt7FHKDdBV
        oqZw7ysM3F0FHDzScJlsGOqsD5mgHd/1mqI6MkBKvXGnytnzGD6uSlrHIjxMAKEQ1gu+fEvrWeXpw
        6oXTc5RM/6FLl7/2TLFIx36JRTfwvHzrIfY9waRj6VCMSofFuQRrYMLQlSj8I2xnuPBfnl+k1YwR1
        paesYx3w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nvvqG-009dPt-0X; Tue, 31 May 2022 06:59:00 +0000
Date:   Mon, 30 May 2022 23:58:59 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org
Subject: Re: [PATCH v6 05/16] iomap: Add async buffered write support
Message-ID: <YpW8s3qvuI+tPH88@infradead.org>
References: <20220526173840.578265-1-shr@fb.com>
 <20220526173840.578265-6-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526173840.578265-6-shr@fb.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I'll leave the throttling algorithm discussion to the experts, but
from the pure code POV this looks good to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>

