Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E8AAC3F6B0
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jul 2022 19:02:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232698AbiG1TCa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jul 2022 15:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbiG1TC3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jul 2022 15:02:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F426371BC;
        Thu, 28 Jul 2022 12:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=RtVO3KRV6CVvGfZUj7vcN4tSij6nOpaqdo7d5o1qCBI=; b=NS6eAKX+TQltfq6OPsGX7Izq9f
        dSODFGh4ccwl/boAQAH2G/lS9pyt8iYSF9Juy75oTInS5O0I0+9ihFa13D10AdRwZ9SEgp49lU7ak
        TQuGwHakiHgqHMhxzE8UjAuJRmh7tvDLIWs46sTB2wupDV6GhZswpDK1aZrW0cWNmno2kjJkHay0l
        JObfSTBGyYM7Zi4xMoBI6nlmmZQHTNtjO3MZtCSudFX9CWc/zX1DxO2H7XqGoodpntWD++Zv1kNrG
        s4rqx42wUSKHpBjNczIil9AzOZjnfYXoUQcT/mQYFL6emFR9KiGjeYPvgsbjTJF2Y+fOreaJPMje3
        bRoVaDYA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oH8m8-00DO8Z-Sq; Thu, 28 Jul 2022 19:02:24 +0000
Date:   Thu, 28 Jul 2022 12:02:24 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 2/2] fail_make_request: teach helpers about external
 devices
Message-ID: <YuLdQC7dh6stnIbm@infradead.org>
References: <165886493457.1585218.32410114728132213.stgit@magnolia>
 <165886494578.1585218.6398445606846645392.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165886494578.1585218.6398445606846645392.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Ah, and this adds the per-bdev helpers.  So this looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>

I can add an incremental patch to convert btrfs/271
