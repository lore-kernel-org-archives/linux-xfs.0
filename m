Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 448EBC3A59B
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 15:30:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B52B22CE9
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 15:30:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hUeE1zRJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbfH3PaJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 11:30:09 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55956 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727751AbfH3PaJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 11:30:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ZH30THQl3g0mpihwpN8qwSCogyaOh6ecy9cPAcRRZgs=; b=hUeE1zRJidoWmF0NQ0J/0jwdR
        qykFyKOdycSQ1UmRvYXX8fFSrZc9VkqRu9Wbg2cEKMN0QtMMbQwAKjg+KllbTrCCSPk8qKMuWwa/r
        eHGUAV1nKapkPkFk3/Vz6Mo5wOyvOS7yq2JCJc/hOPu5k4EYvc1Y8QrUktgXaZgpSXaD9/7d/YUWM
        Vcy2VyjZumyHoHnkAhTTqxclG2EotKlAxp28WVVdBS9C3igyRuACowLIpyE8KoLA+Cc6GjmE+zGhS
        KQB4yZcSa8u9Cc2FLhT7RuwQigHrvjTlbi85zRgcMPy0OUtIjxHtYMlC5qp87iDPybyYiGNEGtriz
        5HYqWXHew==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i3iqm-00070y-Ur; Fri, 30 Aug 2019 15:30:08 +0000
Date:   Fri, 30 Aug 2019 08:30:08 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix sign handling problem in xfs_bmbt_diff_two_keys
Message-ID: <20190830153008.GA13924@infradead.org>
References: <20190826183803.GQ1037350@magnolia>
 <20190829072318.GA18102@infradead.org>
 <20190829154158.GB5354@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829154158.GB5354@magnolia>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 08:41:58AM -0700, Darrick J. Wong wrote:
> A signed s64 comparison would just break the diff_two_keys function
> again.  The reason for the big dorky comment is to point out that the
> signed comparison doesn't work for xfs_btree_query_all, because it does:

Even more reason to have a good helper encapsulating and documenting
all the caveats :)

> I wouldn't mind you cooking up a patch (I think I'm going to be busy
> for a few hours digging through all of Dave's patches) but the helper
> needs to be cmp_u64.  Though ... I also think the logic in the patched
> bmbt diff_two_keys is easy enough to follow along.
> 
> (Personally I find the subtraction logic harder to follow, though it
> generates less asm code on x64...)

The subtraction is a little weird, but very efficient if it works.
I'm not sure any of our users is worth the micro-optimization, though.

I'll cook up a series over the weekend.
