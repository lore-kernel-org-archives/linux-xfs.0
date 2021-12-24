Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA7A8C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Dec 2021 07:19:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343547AbhLXHTe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Dec 2021 02:19:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343536AbhLXHTS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Dec 2021 02:19:18 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0161C06175E
        for <linux-xfs@vger.kernel.org>; Thu, 23 Dec 2021 23:18:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=o/pY5du6nd6dqMeDjQ05bvZlHD
        7/gqIF2CsJokeGl8w0t/k5V2Hs9PFDfXJ05RrJA3iz8HLzrdzTB7sOpzBXDRjkwYtlCH6ygV5En/g
        Ke/1mBMChXJcWbN84jAm2foyofVqCMAEzI1SpiBcWjf+hVmyuk5zpVwgtwF2D2DvwX6gOx+vYYz9k
        VaBq2UPv5iQenZBfPq5KbR3vdlxlP8jTHSPnemQwrQaZF0HgZ14x1Vyx63RTHVirYUq8Q7Pmyr5C2
        ssIyxg6q7vC6boqUfpOyuX0lviLYmMPooPmBPHidvyHRhmZb+okDwcEmkWJU6Kqhnmj3ekf1PTZB8
        xY653Big==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n0eqk-00Dq7W-47; Fri, 24 Dec 2021 07:18:46 +0000
Date:   Thu, 23 Dec 2021 23:18:46 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: only run COW extent recovery when there are no
 live extents
Message-ID: <YcV0VjFhdqOmIadc@infradead.org>
References: <163961695502.3129691.3496134437073533141.stgit@magnolia>
 <163961699399.3129691.9449691191051808697.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163961699399.3129691.9449691191051808697.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
