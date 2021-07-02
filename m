Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93CCAC11F68
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Jul 2021 08:29:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79BC3613F1
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Jul 2021 08:29:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbhGBIbl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Jul 2021 04:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhGBIbl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Jul 2021 04:31:41 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729DAC061762
        for <linux-xfs@vger.kernel.org>; Fri,  2 Jul 2021 01:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jtKx0rWwPemrHHQNK0fPoHcjHK0LpPvRjuMGbhNyjQI=; b=vu2leA8PS9RMQIvJX0vVA0E7qe
        RX69cJYOiu0Lw8v5pQAYlvtvpurXmHE4gO4Kro82ZhBRxXQsiO/2Y74sa2lnhpGwcIygUlvLb74Jf
        SfQ0sQneh6A/riZO0tyeHnXSf8u5i3Y9lKBiC3nq4xiKdR6lKxQBGq+iwQWjiV33tP5UMoYt6kw6V
        VYH6psFK/YNdGFoSHM1PD32TswkMk+a7r/kysXveoynV+fq2PENGtzQYpdMoX2JNfYt2VRL6BRdol
        IohtAlifLjMiclFZiySxvMJAGqwjeHYPpHc3UtcCorjANas3VLvY7nEyJVhZtWvlKjsmgMIAsHDUj
        +4+Qv9jA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lzEXS-007VGT-Hl; Fri, 02 Jul 2021 08:28:48 +0000
Date:   Fri, 2 Jul 2021 09:28:42 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/9] xfs: reowrk up xlog_state_do_callback
Message-ID: <YN7OOjQAqDDPKEfa@infradead.org>
References: <20210630063813.1751007-1-david@fromorbit.com>
 <20210630063813.1751007-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210630063813.1751007-7-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

s/reowrk/rework/ in the subject.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
