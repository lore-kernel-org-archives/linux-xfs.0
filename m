Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23A79C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Oct 2022 06:12:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbiJRGMl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Oct 2022 02:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbiJRGMl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Oct 2022 02:12:41 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB11B4D15D
        for <linux-xfs@vger.kernel.org>; Mon, 17 Oct 2022 23:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=XfzImadJHLLNlDPv0xzrXp+PhV
        P7/dBO6SK6v3TbzTe6hY0/vVSgjg3XhLDk7J/kkgGxDnH/dM5i515yDZUNzxF8OaF5iICy9agy5jr
        o5PbXIP4vBRGEqkBKkQPH4OltLdI22rKJ0xVasNWNO3odTJvXPhEYJfRstyNH/NBeCpRh5qpHIuYL
        la6qchV9uL4Q39vnmC8qTa0ENTOfzsyILKAGTxZHByOc1ZeZ+OWdtMVnaT8CpvsHXwSsw5DD80aii
        7c7v91WbAVVkxCfBk4Z1ZOrln5RC/mOgQciYZaLtwDKCU/+EKymLn2iJFR9FNfYJF/vZTQotic/2x
        CHhC0DFg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1okfqB-003Dif-1T; Tue, 18 Oct 2022 06:12:39 +0000
Date:   Mon, 17 Oct 2022 23:12:39 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: avoid a UAF when log intent item recovery fails
Message-ID: <Y05D16QnaKbTY9/s@infradead.org>
References: <Y03T2BMdS4membDl@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y03T2BMdS4membDl@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

