Return-Path: <SRS0=BjFQ=46=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48D71C10DCE
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Mar 2020 06:52:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 147FA2072C
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Mar 2020 06:52:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gq+60G3F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbgCMGwp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Mar 2020 02:52:45 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57574 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbgCMGwp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Mar 2020 02:52:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=nZxX/aczlPoc+ppL1RrZbbUJTrNEkwq2MB57cgq8b4k=; b=gq+60G3FCjC1QxyH4xkM9HpZpr
        ca5qsiieGbb9G29L/opOle3IhL6aSrPOXUsScbVxRNvQDwTeKqOr43Bo5yihmveKe4JZcBMFJe+pk
        3QGp9akYVg1S8SI2NMkutQNEUkpsGQWHNHjb2h9HMLcJqLnS/ZhXESmd6UNxvjkP/Dz6+m7LOMkSH
        Z60kk9AZx15G/pjMJ2tY7oUTvfpoDtsfb83NI8I2oOL9WnNBQVNkMZIT4qjUvVH1A4tSQLbHvQ5kP
        oO7KvFY0vwC/2zquNK5hlzOEEOUPTv776zYWFdo4ZH9sk3UTHEmqoaRfdiufMINgtKgeunhIRTqAe
        aw5/20Hw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jCeBX-00030y-Q8; Fri, 13 Mar 2020 06:52:43 +0000
Date:   Thu, 12 Mar 2020 23:52:43 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Takashi Iwai <tiwai@suse.de>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Use scnprintf() for avoiding potential buffer
 overflow
Message-ID: <20200313065243.GA5198@infradead.org>
References: <20200311093552.25354-1-tiwai@suse.de>
 <20200311220914.GF10776@dread.disaster.area>
 <s5hsgie5a5r.wl-tiwai@suse.de>
 <20200312222701.GK10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312222701.GK10776@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

FYI, the right fix for sysfs would be to simply offer a new variant
of ->show using the seq_file infrastructure.  That will take care
of all the bounds checking in a maintainable and well understood way.
