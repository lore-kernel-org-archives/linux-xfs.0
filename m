Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A17FC4320E
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 08:45:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23E9161059
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 08:45:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241719AbhIAIq3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Sep 2021 04:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241662AbhIAIq2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Sep 2021 04:46:28 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BEB6C061575;
        Wed,  1 Sep 2021 01:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=AtAlcOpWfPwSC5zRvLKt8j43/w
        lH6ic8Qp5yc39mb6VDCmX3kxEA563gk+baKWiWgxbs3VBup2ttkCHdfjx+7W638BmxyEZfKmXDkTN
        t+8iOV6VtoJOb1EXXuEMS+8tsHP13Df/LgMKmaE0zlW99QXuarqw+jydMzLVDlioriNtV/UghDMzS
        enP75YHacKIXz4clgy1Zex2I5UG4/F63rfP5IwYrtGA2UT3QXyC3lmNOe/L+a1PXOhs5DTz/Gj7Wt
        4pT84C6oxu0DPe4Pt7X4bx6wErEVHX68mUQtff7pgz0hzLwAkk/pX1YUEZm8koKfh6zlVrYdrFT6o
        kxeyuW7Q==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mLLrc-0023a4-0I; Wed, 01 Sep 2021 08:45:03 +0000
Date:   Wed, 1 Sep 2021 09:44:55 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/5] ceph: re-tag copy_file_range as being in the
 copy_range group
Message-ID: <YS89h+Qce+PDWFGR@infradead.org>
References: <163045514980.771564.6282165259140399788.stgit@magnolia>
 <163045515529.771564.6600748735943731783.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163045515529.771564.6600748735943731783.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
