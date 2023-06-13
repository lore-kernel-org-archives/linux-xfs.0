Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFDD8C7EE29
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Jun 2023 04:56:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234684AbjFME4O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Jun 2023 00:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232700AbjFME4N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Jun 2023 00:56:13 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FEE018C;
        Mon, 12 Jun 2023 21:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ZbCDnWNRZv5OG2l2r5APaCfA0qlI1mqmiQc4M7Qw5oc=; b=PmbWQ9zN+kqMultNL2DB9cQLLF
        UAgseTyky19nsjOTD27RREa20+7Jev0lH7lDYkgfZVZkzGgFYyxuu+k95rrjy9Hpu3xERg2ACW9Zi
        jBF36RbxTBdrZO5JZF2wHFCKzbUYyg5vLF2B54FIQF64Hw7T+EetKu25KjjrckkfzcId+o+20eWzC
        7zOzU2xTZUO7Bh4F0VXFq7vGyHrQguHvJc5nLOGTymVHsyOYmdzBOhBIbRCksNtkghylJYRaf1j54
        1Buixf1umiiXsZFGE/SQrJF+pU0Skok0p2XPt6BqgyyRlECy7Z+bcycxwONm5byCWklU79YKV0kWl
        fSy24QHQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1q8w4i-006vIr-39;
        Tue, 13 Jun 2023 04:56:12 +0000
Date:   Mon, 12 Jun 2023 21:56:12 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        Wang Yugui <wangyugui@e16-tech.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: Re: [PATCH v3 6/8] filemap: Allow __filemap_get_folio to allocate
 large folios
Message-ID: <ZIf27AcGaDW2C/je@infradead.org>
References: <20230612203910.724378-1-willy@infradead.org>
 <20230612203910.724378-7-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612203910.724378-7-willy@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

(and I agree with keeping it simple and the folios aligned in the
page and not too optimistically allocated for now)

