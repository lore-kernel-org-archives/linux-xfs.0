Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E4FBC433B4
	for <linux-xfs@archiver.kernel.org>; Fri, 21 May 2021 08:03:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78535613B6
	for <linux-xfs@archiver.kernel.org>; Fri, 21 May 2021 08:03:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236446AbhEUIFM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 May 2021 04:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbhEUIEM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 May 2021 04:04:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA13C061574;
        Fri, 21 May 2021 01:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=B0Xmn9S/z6Sn+GNuRexeU8FcGq
        9UdQ9JqSLmzRsv+rLqPCfy3LSEVqEn7g789J91xXWsiXFpWF4PH9wEMpM5XMqqFxG6QwhJ5exLCgR
        ge7Lrc9O1FqmD5J/saKmiYpUWW3wiRelv77jNoGGAUZjfiWLKFjpLxTtsxhLk2pDZhwEX2M+MkDE0
        sTEsTrd+kp8q5KVq44tHLeoQJ3/HsbmsEWPpzB6kzdNQBHoXfrKvVjCQS9UBvFr3YZ5yBk56wtiKF
        ElOuiWE9Lq1ADBmewqL3z7MShIq8LJKIWt7s8GlLEhTgWZZ7nkuQ6xDzNwnwcISvd+PSUocOMSa63
        GZrNUEmA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lk06b-00Glcl-HZ; Fri, 21 May 2021 08:02:25 +0000
Date:   Fri, 21 May 2021 09:02:01 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 4/6] fsx/fsstress: round blocksize properly
Message-ID: <YKdo+RZM2a+sHH09@infradead.org>
References: <162146860057.2500122.8732083536936062491.stgit@magnolia>
 <162146862463.2500122.10829551919577698395.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162146862463.2500122.10829551919577698395.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
