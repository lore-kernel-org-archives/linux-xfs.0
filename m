Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F6A1C4332F
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Nov 2023 08:37:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233760AbjKGIhg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Nov 2023 03:37:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233784AbjKGIhd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2023 03:37:33 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63CA9D7E
        for <linux-xfs@vger.kernel.org>; Tue,  7 Nov 2023 00:37:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=YkdomgtaOuO/9SUJrZke1McZf1
        AC+lCiZIaKkZI9HfkILSxjMdd++29IhhOZm7pHoWyiKHcgYRR1hzDQDqk0WoyqC8Ay6uIe+RxuPjp
        DoUXzWeiF4Do5ky1rvin70QACFrT06O3ZxwpRXssKigyXJiHP8YHpPiohN+ciTvRlWRszEUHIk7UG
        g+4SJQHrZFuVsf+tiM0K1mVevTbou+BKCLx0CDAYDrm2ceaRlTqXOCP4c7xW32sErDbB/m0dp2ldg
        O6XtYJONlBwfzlaNh/kqdGhAf/tILnl51UeyqVj3TUnQRDGvbQs1BpHx55kVzVwQ5b7O9hQJxiJux
        TVuHLBbg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1r0HaU-000pfy-0X;
        Tue, 07 Nov 2023 08:37:30 +0000
Date:   Tue, 7 Nov 2023 00:37:30 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs_scrub_all: escape service names consistently
Message-ID: <ZUn3SorDeYoOizs5@infradead.org>
References: <168506073832.3745766.10929690168821459226.stgit@frogsfrogsfrogs>
 <168506073859.3745766.15701175812728914090.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168506073859.3745766.15701175812728914090.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
