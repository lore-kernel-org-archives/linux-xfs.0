Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C034AC433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 06:56:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A2E5207DF
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 06:56:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vyHVUxhA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgHQG4c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 02:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbgHQG4b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 02:56:31 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 800A8C061388
        for <linux-xfs@vger.kernel.org>; Sun, 16 Aug 2020 23:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=vyHVUxhAyVbbbgMYKlDz6p2mUt
        zUAyVoxOKuglkrHDANwwBK0AraFmQXbu5EdaE0UO6FlsFYqx0VyY6efoShTiY9sa7lkoNII0wDlNy
        pj/MCLXlcpvKc17YJ09LHdCCkMSBxBcxrovdroAnNujF4jFwyWXeKLhVMLC5nxtGBPIZ0AGPRkVGZ
        3G6nNSpACLmuGco+TUXLcSeokDOf10M528znEWG5gEUMtp7is2xbXyO3vLwePS5cJu5z6fqS9abEw
        1nqk0YH8QlDr2vy2kssi82TLfoaY1Qm6ru/+TpSu2xMNQBifPerkbj4gpy3j3lJBDQu5Bln4oBE/F
        Zo79VEWQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k7Z4I-0006l2-5W; Mon, 17 Aug 2020 06:56:30 +0000
Date:   Mon, 17 Aug 2020 07:56:30 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfsprogs: move custom interface definitions out of
 xfs_fs.h
Message-ID: <20200817065630.GH23516@infradead.org>
References: <df0d78d0-eada-374a-2720-897fb75bd34b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df0d78d0-eada-374a-2720-897fb75bd34b@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
