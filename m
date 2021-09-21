Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D980C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Sep 2021 08:40:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40A8B610E8
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Sep 2021 08:40:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbhIUIli (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Sep 2021 04:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbhIUIlh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Sep 2021 04:41:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E251C061575
        for <linux-xfs@vger.kernel.org>; Tue, 21 Sep 2021 01:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=SHo5FaMgVlKkd2Kmxx3Z8naIXgNyPQenEUq4cskjd0k=; b=MXoUtKKgzG043Vqi3qWREyJtis
        MKUOwSQMKEJ2OYx9kBMV+LN596HrN1hDKXGv/rrx8RO/ciCfOGcBvMfdISYK2Mo69Ws3zdGC7BkMm
        0DzqOAw47nDRmkna79E9bxOLMYoAv4WTNeOM27lfd+UEeLI+w/aSpPSxdBxBuBMjtS/shZ9DQBbgC
        rsLOGfhMFfYDBjCrpBC0Fzw3YgMRub+wZABUSzx92NTso91KxtrxfUcdQ5kUYSsHuj8VFUti/VjXp
        VNPNWzzFRX8nbKpgacU0n8R1781NbfdmwbBLjcqfjyrf/S9odaeKA1ep7bpM088/nsRbybFQFBwf6
        qM37/igw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mSbJN-003dx3-H1; Tue, 21 Sep 2021 08:39:38 +0000
Date:   Tue, 21 Sep 2021 09:39:33 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandan.babu@oracle.com, chandanrlinux@gmail.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/14] xfs: don't allocate scrub contexts on the stack
Message-ID: <YUmaRVf7opVdR+Au@infradead.org>
References: <163192854958.416199.3396890438240296942.stgit@magnolia>
 <163192856086.416199.10504751435007741959.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163192856086.416199.10504751435007741959.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

With the goto label fixes:

Reviewed-by: Christoph Hellwig <hch@lst.de>
