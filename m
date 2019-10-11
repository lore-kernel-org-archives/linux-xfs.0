Return-Path: <SRS0=M45Y=YE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F760C47404
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Oct 2019 10:39:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 139D72089F
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Oct 2019 10:39:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="acf7neqF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727236AbfJKKjq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Oct 2019 06:39:46 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55948 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbfJKKjq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Oct 2019 06:39:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=VPowYaaQeufsgbQpNT8qO9wU/pDjPBckYc+AN8WzdnU=; b=acf7neqFCemrbbHYbcPIUzMr+
        6HhjMRxLTwTRh2qG0EXpgvB15jVYN8gLCXvHHakytDT3WXY6gOZhvYMT/SSwKagf2IYOrB2X4Zz94
        ek4KCZn9/MBOp7lBnt/q4VUh2utVrDiUPNMLU/5IF1ftJS6TpfxjkcO7YF8YN/Hs4zbrm8z6pOwH3
        GY6JDE/Ap+mQ9wvsmcn8kIY+Z2EpgDUQBkiHVJgUOQzL3SeIvE4XTDe1GehkAkBNbn1h86TtL/EOX
        i+J1nO8EG5nk5I0EyO1QRBQYKW2cAszC+4f1wPKYHwCyHJ9+mucahclXRFQjDgIqerkBvgWKniZEv
        cqUA1Qmxg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iIsKo-0005Rh-49; Fri, 11 Oct 2019 10:39:46 +0000
Date:   Fri, 11 Oct 2019 03:39:46 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 21/26] xfs: remove mode from xfs_reclaim_inodes()
Message-ID: <20191011103946.GC12811@infradead.org>
References: <20191009032124.10541-1-david@fromorbit.com>
 <20191009032124.10541-22-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009032124.10541-22-david@fromorbit.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 02:21:19PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Because it's always SYNC_WAIT now.

Not really new in your series, but can use rename it to
xfs_reclaim_all_inodes if you touch all callers anyway? 
