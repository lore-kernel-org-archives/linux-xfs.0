Return-Path: <SRS0=n/sd=6L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62C70C54FD0
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 05:57:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 363C22075B
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 05:57:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OapiYWlE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbgD0F51 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Apr 2020 01:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726221AbgD0F51 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Apr 2020 01:57:27 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A80CC061A0F;
        Sun, 26 Apr 2020 22:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7zElAvoUBkSCcndQ+mZNHBtIxRc2td7Rq7fW1hfPztY=; b=OapiYWlEmna+aaE+vjReoQWnqh
        iYK6z5lAmhnykIOVbybn3iQ7hHeZ53/ShWroCls3IXOv0Zkpm2ec/U1vJWXxjV71Er8ji6/VOdnLW
        GeMvGb9SXY0U02rDNufTmoxsudBnfQf/uQeaavGwnxdR6Doec19IkDbdZ2WNcAkGFPMWGQdbDWkIO
        mfwNXtLL2RPBr1w4pd095jmkbhFhUlOhn2IA51vxSP9LtpIP+ePK847OhKMisZdOWHlYssJakjm0c
        4qeHj/EZoNtju88tdV77lACF1hENIN95TnuoY3G8rQSc2vjycDMu4/txj+7fVgVWEyc6KbLGEikuA
        c4aNa4DQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jSwlj-00082h-5q; Mon, 27 Apr 2020 05:57:27 +0000
Date:   Sun, 26 Apr 2020 22:57:27 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com, willy@infradead.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 6/9] iomap: use set/clear_fs_page_private
Message-ID: <20200427055727.GA30480@infradead.org>
References: <20200426214925.10970-1-guoqing.jiang@cloud.ionos.com>
 <20200426214925.10970-7-guoqing.jiang@cloud.ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200426214925.10970-7-guoqing.jiang@cloud.ionos.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

FYI, you've only Cced the xfs list on this one patch.  Please Cc the
whole list to everyone, otherwise a person just on the xfs list has
no idea what your helpers added in patch 1 actually do.
