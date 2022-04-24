Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A56BCC433F5
	for <linux-xfs@archiver.kernel.org>; Sun, 24 Apr 2022 05:28:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238263AbiDXFbO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 Apr 2022 01:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbiDXFbN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Apr 2022 01:31:13 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 785EE1CB11
        for <linux-xfs@vger.kernel.org>; Sat, 23 Apr 2022 22:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=yOQo9NACmd9xq4a9s9RCBZg3J/
        pmsOWELPYiTaHT/xkt3TK3Lwgzg2jK7AHjiukiJ074vhsGFZchhTcmF04kV6mqtYtXpsla2+Ym7d0
        kisnCb4vIA4gE7nuMXV6CANu/zN0Igri82ZJZtSVKCNiJbdyRujB0ql9I662ewhUr2e+iaG3YQ6Ke
        KuxJ+54MXRZISy0DVBP7jnV4XtFKpuE5KpfeEDUmcT9AshL8j+AYqgp9DoFnwaLdMd3b/8G6G0aYH
        MR0kCNSnAIPCqPBGK/oYZeGgiuPJ7Hj3IvTFUEaMlYf4OhCUtsuij5DUE9iM6VXxarYNQH1+KxJD2
        LHVLI0Ow==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1niUn8-005q6U-2S; Sun, 24 Apr 2022 05:28:14 +0000
Date:   Sat, 23 Apr 2022 22:28:14 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Yang Xu <xuyang2018.jy@fujitsu.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org, brauner@kernel.org
Subject: Re: [PATCH] xfs: improve __xfs_set_acl
Message-ID: <YmTf7qfQ4uJ0B00F@infradead.org>
References: <1650531290-3262-1-git-send-email-xuyang2018.jy@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1650531290-3262-1-git-send-email-xuyang2018.jy@fujitsu.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
