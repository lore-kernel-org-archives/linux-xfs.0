Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D095C4332F
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Nov 2023 08:39:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233760AbjKGIjV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Nov 2023 03:39:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbjKGIjU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2023 03:39:20 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2771310A
        for <linux-xfs@vger.kernel.org>; Tue,  7 Nov 2023 00:39:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=DVgyhm7JvJ0zZqFuzWqhwLC6Ji
        gGV4IFA7KdWZqW8wsc/QOdfI2O3WCLjhgPcm8BvYm+Are3Jfra5IETf+jTu6w+q7g4Gz/7eoQ7+ir
        yoogiPFkPWPJ2gdS4Ul5d79HZKzm1ApdpSDDvUPivhRox03fmZ9R+zxPKuuTIQ6UReIJvXdQw6Q7B
        0oRWxQ6NWgjmRHhyUaVGHg9KZNdH5n6d8+glTD0FMJkQ90S5Mr9szBQ/839VEW+KDr7c/nFRvDHOG
        kgEgUlUoVsMMoQswJm4/ynpOayq3jIcwlxjJKM1ZmTHh8jM/etdKjrODyDBINkEWgiSUT4JahH9GD
        1L/OBBDA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1r0HcE-000pzN-09;
        Tue, 07 Nov 2023 08:39:18 +0000
Date:   Tue, 7 Nov 2023 00:39:18 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs_scrub_fail: return the failure status of the
 mailer program
Message-ID: <ZUn3thbZDWlUFD/7@infradead.org>
References: <168506073832.3745766.10929690168821459226.stgit@frogsfrogsfrogs>
 <168506073900.3745766.12097252494988640270.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168506073900.3745766.12097252494988640270.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
