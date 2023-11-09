Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80A81C4167D
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Nov 2023 05:03:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbjKIFDh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Nov 2023 00:03:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjKIFDg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2023 00:03:36 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E2A8D58;
        Wed,  8 Nov 2023 21:03:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Type:MIME-Version:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=Qfhk3djxrRjTvI9hLvzG1yLZFLQpDMGY9IpuUynjJLE=; b=rz3FV6TwSsF2BEVsuEcbUy8m1j
        mu9zjA/a6kWDlDqT5WG24Bs8obL8ELVlnJQGRK2qmFXBBEjTyzh3di2IBrOUd8VgfzJF6v+pZOPli
        uIKMenORyuQtwX9lgl6Bjhv/PiqsQoRiv9ImDtPcld+w+bcrGUKVXEFEH/Tf+9Z4y06twOv0FQWXt
        TwNJf2tRxVbeE5NdGnzRWtmHSxZLz9mCpLdyx1vT9KZwxyz65j88EQJG0AozZrQjWKWuxa/uW8nJh
        2j48LclmzjpSUC3pV7IYrL9anDrX1H5vbE88AdmR1KSgWfFqoaCavk0pv2uZ4hKSdDaRJ2YHtWRc7
        b5M0EGOQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1r0xCY-005ILO-13;
        Thu, 09 Nov 2023 05:03:34 +0000
Date:   Wed, 8 Nov 2023 21:03:34 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     linux-sparse@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: sparse feature request: nocast integer types
Message-ID: <ZUxoJh7NlWw+uBlt@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi dear spearse developers,

in a lot of kernel code we have integer types that store offsets and
length in certain units (typically 512 byte disk "sectors", file systems
block sizes, and some weird variations of the same), and we had a fair
amount of bugs beause people get confused about which ones to use.

I wonder if it is possible to add an attribute (say nocast) that works
similar to __attribute__((bitwise)) in that it disallows mixing this
type with other integer types, but unlike __attribute__((bitwise))
allows all the normal arithmetics on it?  That way we could annotate
all the normal conversion helpers with __force overrides and check
where people are otherwise mixing these types.
