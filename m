Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FFB2C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 10 May 2022 12:47:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241838AbiEJMvv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 08:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234305AbiEJMvu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 08:51:50 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827E0107880
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 05:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=XkTFEMw9N9O7vtieEHkQUAnAfnKDxqldglMdv/UND4M=; b=YwDbo6yJJC2NstkzvNC2XWEbxn
        W8y5zNbLgRglEUdJTVSIMHPD8sIn4Mf0kOzOBQBNOkVuNplnZRyfs98o2OfdQ/ocruLx/5slKr+mv
        nr+2CwHdtCh5nZfJzQHWYrMXyjOyToC+Nqx0YEUQFB88sWKe4ZLbyxOMQfHVYorm0XW4S0960Jh4c
        PZtHlhchW6qqpySbElpKDOE9TVs06/9DdeJcK59HO4ZKTwTKJhCsKsjAxSIkJdnKuixjDlzFDy6D+
        fjZVSNnPLstO9sp4Owiku5zljLUlHNYR/r+TxkOOTBsul452DpWFrh2kAyXgRBoj/C7trUUVlfoyt
        L1ch6AIw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1noPHM-001zmS-5r; Tue, 10 May 2022 12:47:52 +0000
Date:   Tue, 10 May 2022 05:47:52 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/10] xfs: zero inode fork buffer at allocation
Message-ID: <Ynpe+FdmXiVHhiMb@infradead.org>
References: <20220503221728.185449-1-david@fromorbit.com>
 <20220503221728.185449-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503221728.185449-2-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 04, 2022 at 08:17:19AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we first allocate or resize an inline inode fork, we round up
> the allocation to 4 byte alingment to make journal alignment
> constraints. We don't clear the unused bytes, so we can copy up to
> three uninitialised bytes into the journal. Zero those bytes so we
> only ever copy zeros into the journal.

It took me a while to figure out how GFP_ZERO works for krealloc,
and it seems like kmalloc and friends always zero the entire length
of the kmem_cache, so if krealloc reuses a rounded up allocation the
padding is alredy zeroed at that point.

So this looks good to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
