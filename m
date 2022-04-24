Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01C8BC433F5
	for <linux-xfs@archiver.kernel.org>; Sun, 24 Apr 2022 05:42:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238299AbiDXFpB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 Apr 2022 01:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbiDXFpB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Apr 2022 01:45:01 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB66B19C741
        for <linux-xfs@vger.kernel.org>; Sat, 23 Apr 2022 22:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Y6X86cQXUUyvHAlBzOX8fYi80n
        rUoZkYQKofNmSw0plMD0iLKgBrOOuUAK1u1idPjgwvwvqrkzur2bKKgt9L3CXneceRw0eX3PsPBNa
        LrYfOG3o6RdlyMvZ4VkKNWN3vDAD3L8Xtbv+O8GN7nybB5DvjuSmKYGQZool4SNkbydNWQEA19ypn
        MPqBB69HeMguObHUZh1A6Dj7oN3Wydwb9sPCtnra+5RaKqjwV3AsdsuJOkEFSmwKtrCWfIZUzxgtk
        8ML49AlvcLXDAM3mJV413BfQ3A4TfFIxqmlX4qWvRCdkPJYFf8oeo+ZuReijQwhZobk/6yqxx1ht0
        a4pMnkSQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1niV0R-005rJP-TQ; Sun, 24 Apr 2022 05:41:59 +0000
Date:   Sat, 23 Apr 2022 22:41:59 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] mkfs: reduce internal log size when log stripe units
 are in play
Message-ID: <YmTjJw5QhTz0QoYT@infradead.org>
References: <164996213753.226891.14458233911347178679.stgit@magnolia>
 <164996214899.226891.5031116645577578021.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164996214899.226891.5031116645577578021.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
