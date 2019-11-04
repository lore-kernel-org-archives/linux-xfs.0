Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B45BCA9EB5
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 15:25:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F44620842
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 15:25:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YFUIsu2r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728336AbfKDPZR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 10:25:17 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:43140 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728188AbfKDPZR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 10:25:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=6RJcO60dMsiGxsPGdyjVOQPZBFgaMzgTygSbxJ4e+CU=; b=YFUIsu2rIwYhtf0YQrTNvlcjJ
        SO0I4oSS3QynWHt7Sazsyq1IOUCgun/k4vJiIXjPKOSrykbptDYDNBUa3tIVDiH6tXElNKPd+xpYX
        cHagNUwalzMj4LTnTbdW7KsQxPxrALcRMaxYc5q2M4omVPBnfOKzp/YFOPYixHVoPYHBJ6xDphfgk
        WEqggglMx1L0p5wZd+tQ6FxibmvYjxRBQLicMrJj44MXc6GAKXU58cXXt1BNM//WiPHcWS3hgc3k5
        c091YmFnkMl+tpSJcZWD2lAqemywdW1aTCLGq+ywBcILCaW/lysqqxUz6E4dx1ipzHrWgoq5g5QkG
        I/vaNzUAg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iReEH-0001io-FZ; Mon, 04 Nov 2019 15:25:17 +0000
Date:   Mon, 4 Nov 2019 07:25:17 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Shaokun Zhang <zhangshaokun@hisilicon.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Guo <guoyang2@huawei.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: optimise xfs_mod_icount/ifree when delta < 0
Message-ID: <20191104152517.GD10485@infradead.org>
References: <1572866980-13001-1-git-send-email-zhangshaokun@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1572866980-13001-1-git-send-email-zhangshaokun@hisilicon.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 04, 2019 at 07:29:40PM +0800, Shaokun Zhang wrote:
> From: Yang Guo <guoyang2@huawei.com>
> 
> percpu_counter_compare will be called by xfs_mod_icount/ifree to check
> whether the counter less than 0 and it is a expensive function.
> let's check it only when delta < 0, it will be good for xfs's performance.

How much overhead do you see?  In the end the compare is just a debug
check, so if it actually shows up we should remove it entirely.
