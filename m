Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B52E3C43334
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jul 2022 03:38:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbiGKDii (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Jul 2022 23:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiGKDii (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Jul 2022 23:38:38 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D89B85F8B
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jul 2022 20:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=GTTT095GTKobHSN5HqE8QiwQMB
        x9CBGHXjyoNBmF93RVrlD6gatrNkXEBVPCYoxChdcBvebiJCYjTwn2HWpu+T6n3cq0T6ezueX35Gh
        wEi5d1Uzyrq03ASyZzh6RBXJ5mcrWAuJmlog4Dn1diNVqy+Nyio4LlVf+ZB73pId1gnP1mcuqj3xT
        a36XSVx+LxEolN86FwB0YDHxu2N8wd4noau1TwmIX/4EWs/kldBTc/u/Cnd830U4xe4kqruezmc6R
        T0wfKevtRzu0YvYyEwLdm5XsMddj0cLWXmEcrj1+//Giu4C48y5KcS2YQWfJv1xGY8uefi0T2aOIG
        8I3hf1xg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oAkFm-00FeDe-WB; Mon, 11 Jul 2022 03:38:34 +0000
Date:   Sun, 10 Jul 2022 20:38:34 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, oliver.sang@intel.com
Subject: Re: [PATCH v2] xfs: fix use-after-free in xattr node block
 inactivation
Message-ID: <YsubOtrjuG2e9WoS@infradead.org>
References: <YsoGnNoF8pGTBPFd@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YsoGnNoF8pGTBPFd@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
