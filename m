Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20C77C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 06:15:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F145C60FD8
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 06:15:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347762AbhDNGP5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Apr 2021 02:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232679AbhDNGPy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Apr 2021 02:15:54 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86891C061574;
        Tue, 13 Apr 2021 23:15:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=J7A9cLC/6A/y7X9yFbyGlwb164/nCeP+CkY/hdT7DWw=; b=C2mCcu2fsnY4/Q1Fe3ykxuGs/h
        4ugRrqFvBb3kEEeIryT97FL/1eQAfj4YkQCMtDQhpzwErgE39r74wiAf++I5UpRKdRdg2hs2oFvxQ
        lcQkxMIkHsYWvnhlmKR68boxj3YGJpXds65DxcfNB9PHAGzHvMGBB5yYUkAg7iaWiGbGrz5uNmzM2
        Yhaeeaw7noV18cXL8u7tkt+944s3t4tq8uAnbeXN/k9RvBhmrRyV/4MlvomaYWSVuqI3/cZB1OCQ4
        xZDMAU7wnyZTX/ODXg1KV4yURX8yNFcLPuwHrhDltnPItebxZ8gzlMQayTHNe1KDzp/E3AUIwxzMR
        U8HlvUMg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lWYnu-006jL8-07; Wed, 14 Apr 2021 06:15:14 +0000
Date:   Wed, 14 Apr 2021 07:15:09 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 3/9] xfs/521,530: refactor scratch fs check
Message-ID: <20210414061509.GE1602505@infradead.org>
References: <161836227000.2754991.9697150788054520169.stgit@magnolia>
 <161836228828.2754991.13327862649701948223.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161836228828.2754991.13327862649701948223.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 13, 2021 at 06:04:48PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Use the existing _check_scratch_fs helper to check the (modified)
> scratch filesystem in these tests.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
