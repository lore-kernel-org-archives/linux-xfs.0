Return-Path: <SRS0=7yvF=YM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 199F5CA9EAC
	for <linux-xfs@archiver.kernel.org>; Sat, 19 Oct 2019 08:12:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC0A8222C2
	for <linux-xfs@archiver.kernel.org>; Sat, 19 Oct 2019 08:12:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="By988nsu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbfJSIMT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 19 Oct 2019 04:12:19 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59696 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbfJSIMT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 19 Oct 2019 04:12:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=sBhdJJsKEU5N2pXvvia6LRQuh+baua5m3sswozX8DKc=; b=By988nsuxisz7nl4WH5MhPeZZ
        jfBw4xssv+LaWS45bLrL+8d42ic9ebOR32b2OhRN4YglMDlSygEwsGiuAnwJrPSUW2mkezUMM/27l
        6hkaG1KaE7EKHxT1838ED6voBzww35PKkPCsfXLY9m0PJeIycXFhtfeqYEOpUzaKiiqnTVubkYjDn
        n3TJcI4D6/TucIxaCZ3jKcTZUpjOEAomRKk+xKpG/9SDeCuQ0xNOtZgWQ7tW2wI7mPN3N+1NF82Z6
        0ZFaUcPB0MoijrsN5QlH2JDTyVQdZWxhrhJ0fpgj8LVihB7OZj/7P1Apmx23HJvI9CR9urnxiQ/0H
        3monsTkMg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iLjqS-00006r-Ow; Sat, 19 Oct 2019 08:12:16 +0000
Date:   Sat, 19 Oct 2019 01:12:16 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Thomas Meyer <thomas@m3y3r.de>
Cc:     linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: replace homemade binary search
Message-ID: <20191019081216.GA21691@infradead.org>
References: <20191019072033.17744-1-thomas@m3y3r.de>
 <20191019072033.17744-2-thomas@m3y3r.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191019072033.17744-2-thomas@m3y3r.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Oct 19, 2019 at 09:20:33AM +0200, Thomas Meyer wrote:
> use newly introduced bsearch_idx instead.
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>

What is the point?  This adds more code, and makes it slower by
adding an indirect function call.
