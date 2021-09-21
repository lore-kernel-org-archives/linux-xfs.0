Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEB4FC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Sep 2021 08:59:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9660D61168
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Sep 2021 08:59:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbhIUJA1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Sep 2021 05:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbhIUJA1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Sep 2021 05:00:27 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4791BC061574
        for <linux-xfs@vger.kernel.org>; Tue, 21 Sep 2021 01:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=eHWR0HByYSjnhi92k5hRHvgR8H
        P5vu62Uh+pUkAzHNofEZH4qtUdgRHMdaptqCjVSK2XFjsyofdfa28o3aWGylT6o9gO5gLbXdFtbom
        DiFnr85j3VJO71cRT8nbuS/miu4sgONCulw2g3Qbc2jkLh7WzTjOr+w4+DQ5kjTfqbtzmh0Ot7y0y
        ZjrA/mpgBqF9cmCm0tUiUgb25ISiUL93/aFYWSn5GL+LSXB/j4b4jzb01rauaVhSHEkA6RkJaqa0L
        xl35Ld3d+T9IApaCbpAWs/X81M5yHg0RJVb32oMRQN/Z5+v1BJkLFwO4QAWE5iNtSq+bHJpRdYrMz
        +USKAQnA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mSbau-003eca-FG; Tue, 21 Sep 2021 08:58:15 +0000
Date:   Tue, 21 Sep 2021 09:57:40 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandan.babu@oracle.com, chandanrlinux@gmail.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/14] xfs: encode the max btree height in the cursor
Message-ID: <YUmehPB7PIDcmocD@infradead.org>
References: <163192854958.416199.3396890438240296942.stgit@magnolia>
 <163192860467.416199.3157992669504614921.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163192860467.416199.3157992669504614921.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
