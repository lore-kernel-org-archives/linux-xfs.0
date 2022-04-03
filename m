Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82975C433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Apr 2022 11:55:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233471AbiDCL51 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 3 Apr 2022 07:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237492AbiDCL51 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Apr 2022 07:57:27 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4250C27B00
        for <linux-xfs@vger.kernel.org>; Sun,  3 Apr 2022 04:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=trx0vt+ur3LAE+F0Vfo1N7IUO6px44pE29CgtBITrKM=; b=kL0HWY91eqceZAFgrws7MU/ibV
        ZXvy728k20KxYbCl1P9NOZY2L3SUfc/obtuZ5xTnNM96rbrzZJg/Zf3mJl5bBhVgzMd2aFLWI/QOj
        6FGljBPBjit/H2Dj0BkX+Gr/0ERs4rELp+myZlMe5JbZYde6YWklJCvsvnGvqzhrPet8MrsOd0Wvb
        fPo22/jkQDj5JYIGzChGcqaELG+UQbwgbNm4xnfHciyJtGdlEAFK38lV2/do1sAEnSdbjNcNWMdeO
        JirroCBrG5GPFc5JNQBXdl6iYdxLGy7cAJOctw3NG6WoccMcwVgMFh4f/ccE/gsVlF1P7goYYGapx
        z8pQJdJA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1naypQ-00BJd8-AD; Sun, 03 Apr 2022 11:55:32 +0000
Date:   Sun, 3 Apr 2022 04:55:32 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: lockless buffer lookup
Message-ID: <YkmLNHUbQkcgnw8r@infradead.org>
References: <20220328213810.1174688-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220328213810.1174688-1-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

So while this patch looks correct and very useful to me, that special
path reallyirked me.  The root cause is that the existing buffer lookup
is a mess, so I spent some time this weekend to refactor this before
applying a now simplified version of your patch.  I'll send out the
series in a bit.
