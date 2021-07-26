Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFA0DC4338F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 07:28:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8EC760560
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 07:28:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232216AbhGZGry (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 02:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232213AbhGZGry (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jul 2021 02:47:54 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F62C061757
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 00:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=DS8NjYaVptjFpAuPVdxA4l+Ua0
        r+z1Ar8A0gkCnyeppuXJ4kXp1HxaZIMww/Qx8k39qgr5Uamu6/qZsVvOiQfRYZFJPF6cT/BIA5oLB
        YPLX2hpzpThDjFAmfvp0tR8t1mcZ8xnFVRBXRGfdsarWZJSqK4D1h/K60S+/8fGHKIBQJgnEl87U0
        eSDISlv3maZhxOlAsxpC/USjaoGYzzH+OmYzLXuuiWskipaxl/IiW736+hKI2bJ4JbTgU7Q+vFYN4
        r5EDYl3BLwMOyco083vLYMqseaOsx5jEhZUMbI2wNakVKKtXGVsXSfaODV89TDtfrAMkjBL3Y/iit
        Md+VcIyQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m7v1g-00DhQA-Ib; Mon, 26 Jul 2021 07:28:02 +0000
Date:   Mon, 26 Jul 2021 08:27:48 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/10] xfs: log forces imply data device cache flushes
Message-ID: <YP5j9EDKh62mhLrY@infradead.org>
References: <20210726060716.3295008-1-david@fromorbit.com>
 <20210726060716.3295008-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726060716.3295008-7-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
